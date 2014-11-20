# Import gulp libraries
gulp = require 'gulp'
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
clean = require 'gulp-clean'
path = require 'path'
extend = require 'extend'
minimist = require 'minimist'
options = require path.resolve './package.json'
  
wrapper = extend {}, gulp, {
  util: gutil
  task: (params...) ->
    gulp.task params...
  watch: (params...) ->
    gulp.watch params...
  src: (params...) ->
    if params.length is 0 or typeof params[0] isnt 'string'
      params.unshift @dirs.source + '/*'
    gulp.src params...
      .pipe plumber()
  dest: (params...) ->
    if params.length is 0 or typeof params[0] isnt 'string'
      if @debug
        params.unshift @dirs.test
      else
        params.unshift @dirs.dist
    gulp.dest params...
  env: minimist process.argv.slice 2
}

Object.defineProperty wrapper, 'name',
  value: options.name+'-'+options.version+'.js'

Object.defineProperty wrapper, 'debug',
  value: gutil.env.target isnt 'production'

Object.defineProperty wrapper, 'dirs',
  value: Object.create Object.prototype,
    source: value: options.gulp?.source ? 'src'
    test:   value: options.gulp?.test   ? 'test'
    build:  value: options.gulp?.build  ? 'build'
    dist:   value: options.gulp?.dist   ? 'dist'

Object.defineProperty wrapper, 'main',
  value: path.resolve (options.main ? (wrapper.dirs.source + '/' + 'main.js'))

gulp.task 'clean', () ->
  gulp.src wrapper.dirs.build
  .pipe clean()
      
module.exports = wrapper
