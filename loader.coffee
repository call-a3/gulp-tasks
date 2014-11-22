fs   = require 'fs'
path = require 'path'
gulp = require './wrapper'
Module = require './Module'
gulpfile = require './gulpfile'

getStack = (error) ->
  s = null
  b = Error.prepareStackTrace
  Error.prepareStackTrace = (error, stack) ->
    s = stack
    b error, stack
  stack = error.stack
  Error.prepareStackTrace = b
  return s

logException = (ex) ->
  stack = getStack ex
  gulp.util.log [
    gulp.util.colors.red(ex.name + ': ' + ex.message)
    if stack[0].getFileName?()?[0] is '/' then [
      ' at '
      stack[0].getFileName() + ':'
      stack[0].getLineNumber() + ':'
      stack[0].getColumnNumber()
    ].join '' else ''
  ].join ''
  console.log ex.stack

module.exports = ({folder, gulp}) ->
  folder = path.resolve folder
  gulp.util.log 'Loading tasks from '+ (gulp.util.colors.magenta folder)
  try
    files = fs.readdirSync folder
    files.forEach (relative) ->
      try
        file = path.resolve folder, relative
        if fs.statSync(file).isFile()
          ext = path.extname file
          name = path.basename file, ext
          if ext is '.js' or /\.((lit)?coffee|coffee\.md)$/.test file
            gulp.util.log 'Found task \'' + (gulp.util.colors.cyan name) + '\''
            try
              taskModule = new Module(file, gulpfile)
              taskModule.load file
              task = taskModule.exports
              gulp.task name, task.dependencies ? [], task
            catch ex
              stack = getStack ex
              ###
              gulp.util.log [
                gulp.util.colors.red(ex.name + ': ' + ex.message)
                ' in task \''
                gulp.util.colors.cyan name
                '\''
                if stack[0].getFileName?()?[0] is '/' then [
                  ' at '
                  stack[0].getFileName() + ':'
                  stack[0].getLineNumber() + ':'
                  stack[0].getColumnNumber()
                ].join '' else ''
              ].join ''
              ###
              console.log ex.stack
      catch ex
        logException ex
        msg = 'Couldn\'t read directory \'' + folder + '\''
        throw new gulp.util.PluginError 'gulp-tasks', msg
  catch ex
    logException ex
    throw new gulp.util.PluginError 'gulp-tasks', (ex.name + ': ' + ex.message)
  return gulp