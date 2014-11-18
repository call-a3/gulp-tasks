fs   = require 'fs'
path = require 'path'
vm   = require 'vm'
rekwire = './rekwire'

getStack = (error) ->
  b = Error.prepareStackTrace
  Error.prepareStackTrace = (_, stack) -> stack
  s = error.stack
  Error.prepareStackTrace = b
  console.log b error, s
  return s

module.exports = (gulp, options) ->
  {folder} = options
  folder = path.resolve folder
  sandbox = {
    gulp
    process
    console
    require: rekwire
  }
  ###
    require: require#.main.require
    console
    process
  ###
  context = vm.createContext sandbox
  gulp.util.log 'Trying to load tasks from \''+folder+'\''
  try
    files = fs.readdirSync folder
    files.forEach (relative) ->
      file = path.resolve folder, relative
      if fs.statSync(file).isFile()
        ext = path.extname file
        name = path.basename file, ext
        if ext is '.js' or /\.((lit)?coffee|coffee\.md)$/.test file
          gulp.util.log 'Found task \'' + (gulp.util.colors.cyan name) + '\''
          try
            vm.runInContext ([
                'var task = require(\''+file+'\');'
              ].join ''), context
            {task} = context
            gulp.task name, task.dependencies ? [], task
          catch ex
            s = getStack ex
            gulp.util.log [
              gulp.util.colors.red(ex.name + ': ' + ex.message)
              ' in task \''
              gulp.util.colors.cyan name
              '\''
              if s[0].getFileName?()?[0] is '/' then [
                ' at '
                s[0].getFileName() + ':'
                s[0].getLineNumber() + ':'
                s[0].getColumnNumber()
              ].join '' else ''
            ].join ''
  catch
    msg = 'Couldn\'t read directory \'' + folder + '\''
    throw new gulp.util.PluginError 'gulp-tasks', msg