# Import gulp libraries
gulp = require 'gulp'
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
del = require 'del'
path = require 'path'
extend = require 'extend'
minimist = require 'minimist'
bundle = require path.resolve './package.json'
options = extend {}, {
  name:
    infix: '-'
    extension: '.js'
  source: 'src'
  test: 'test'
  build: 'build'
  dist: 'dist'
}, bundle.gulp?

  
wrapper = extend {}, gulp, {
  util: gutil
  task: (params...) ->
    gulp.task.call @, params...
  watch: (params...) ->
    gulp.watch.call @, params...
  src: (params...) ->
    if params.length is 0 or
        (typeof params[0] isnt 'string' and not Array.isArray params[0])
      params.unshift @dirs.source + '/*'
    gulp.src.call(@, params...)
      .pipe(plumber())
  dest: (params...) ->
    if params.length is 0 or typeof params[0] isnt 'string'
      params.unshift @dirs.build
    gulp.dest.call @, params...
  env: minimist process.argv.slice 2
}

Object.defineProperty wrapper, 'name',
  value: bundle.name+options.name.infix+bundle.version+options.name.extension

Object.defineProperty wrapper, 'debug',
  value: gutil.env.target isnt 'production'

Object.defineProperty wrapper, 'dirs',
  value: Object.create Object.prototype,
    source:
      value: options.source
      enumerable: true
    test:
      value: options.test
      enumerable: true
    build:
      value: options.build
      enumerable: true
    dist:
      value: options.dist
      enumerable: true

Object.defineProperty wrapper, 'main',
  value: path.resolve (bundle.main ? (wrapper.dirs.source + '/' + 'main.js'))

Object.defineProperty wrapper, 'deploy',
  value: () ->
    if @debug
      @dest @dirs.test
    else
      @dest @dirs.dist

gulp.task 'clean', (cb) ->
  del [
    wrapper.dirs.build + '/*'
  ], cb

gulp.task 'clean:test', (cb) ->
  del [
    wrapper.dirs.test + '/*'
  ], cb

gulp.task 'clean:dist', (cb) ->
  del [
    wrapper.dirs.dist + '/*'
  ], cb

gulp.task 'deploy', (cb) ->
  wrapper.src('build/*')
  .pipe wrapper.deploy()
      
module.exports = wrapper
