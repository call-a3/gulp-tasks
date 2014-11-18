/*jslint node: true*/
require('coffee-script/register');
var extend = require('extend');

var load = require('./loader');
var wrap = require('./wrapper');

var defaults = {
  folder: './gulp'
};

module.exports = function (gulp, options) {
    options = extend({}, defaults, options);
    var wrapper = wrap(gulp);
    try {
      load(wrapper, options);
    } catch (e) {
      wrapper.emit('error', e);
    }
    return wrapper;
};