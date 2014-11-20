/*jslint node: true*/
require('coffee-script-redux/register');
var extend = require('extend');

var load = require('./loader');
var wrapper = require('./wrapper');

var defaults = {
  folder: './gulp',
  gulp: wrapper
};

module.exports = function (options) {
    return load(extend({}, defaults, options));
};