path = require 'path'

gulpfile = module

while path.basename(gulpfile?.filename).toLowerCase() isnt 'gulpfile.js'
    
  console.log gulpfile.id
  if gulpfile.parent?
    gulpfile = gulpfile.parent
  else
    return

module.exports = gulpfile