module.exports = (path) ->
  mojewel = new Module(path)
  console.log 'rekwire(', path, ')'
  module.main.require path