path = require 'path'

module.exports = class Sandbox
  constructor: ({filename, module, imports}) ->
    # Include global as reference to self
    Object.defineProperty @, 'global',
      get: () -> @
    ## init magic constants __filename and __dirname
    Object.defineProperty @, '__filename',
      value: filename
    Object.defineProperty @, '__dirname',
      value: path.dirname filename
    
    # Set module
    Object.defineProperty @, 'module',
      value: module

    console.log('binding sandbox require: ', module.require)
    # Add aliases to module fields
    Object.defineProperty @, 'exports',
      get: () -> module.exports
    Object.defineProperty @, 'require',
      get: () -> module.require
        
    # Add imported globals if they don't override fixed globals
    for name, prop in imports
      if not @hasOwnProperty name
        Object.defineProperty @, name, value: prop
    
    # Add true globals if they don't override imports
    for name, prop in global
      console.log 'pulling in global.' + name + ' to sandbox'
      if not @hasOwnProperty name
        Object.defineProperty @, name, value: prop