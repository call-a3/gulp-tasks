path = require 'path'

module.exports = class Sandbox
  constructor: ({filename, module, imports}) ->
    self = @
    
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

    # Add aliases to module fields
    Object.defineProperty @, 'exports',
      get: () -> module.exports
    Object.defineProperty @, 'require',
      value: (id) ->
        module.require.call module, id
        
    # Add imported globals if they don't override fixed globals
    for name, prop of imports
      if not @hasOwnProperty name
        Object.defineProperty @, name, value: prop
    
    # Add true globals if they don't override imports
    for own name, prop of global
      blacklisted = name in ['Sandbox', 'Module', 'global']
      if not (@hasOwnProperty name) and not blacklisted
        Object.defineProperty @, name, value: prop