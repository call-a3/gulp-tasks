BuiltinModule = require 'module'
assert = (require 'assert').ok

NativeModule = do (natives = Object.keys process.binding 'natives') ->
  exists: (name) -> name in natives

wrapper = require './wrapper'

class Module extends BuiltinModule
  require: (path) ->
    assert typeof path is 'string', 'path must be a string'
    assert path, 'missing path'
    
    if path is 'gulp'
      console.log 'requires gulp, gets our wrapper'
      return wrapper
    
    filename = BuiltinModule._resolveFilename path, @parent
    if NativeModule.exists filename
      return BuiltinModule._load.call @, path, @parent
    
    cached = BuiltinModule._cache[filename]
    if cached
      return cached.exports
      
    BuiltinModule._cache[filename] = module = new Module(filename, @parent)
    
    hadException = yes
    try
      module.load filename
      hadException = false
    finally
      if hadException
        delete BuiltinModule._cache[filename]
    
    console.log 'require(', path, ')'
    return module.exports
    
    #BuiltinModule._load.call @, path, @parent
    
  load: (filename) ->
    console.log 'load(', filename, ')'
    BuiltinModule.prototype.load.call @, filename
    
module.exports = Module