BuiltinModule = require 'module'
assert = (require 'assert').ok

wrapper = require './wrapper'

class Module extends BuiltinModule
  require: (path) ->
    assert typeof path is 'string', 'path must be a string'
    assert path, 'missing path'
    
    if path is 'gulp'
      console.log 'requires gulp, gets our wrapper'
      return wrapper
    
    console.log 'require(', path, ')'
    
    BuiltinModule._load.call @, path, @parent
    
  load: (filename) ->
    console.log 'load(', filename, ')'
    BuiltinModule.prototype.load.call @, filename
    
module.exports = Module