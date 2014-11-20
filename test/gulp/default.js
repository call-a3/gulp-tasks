// TASK default

var gulp = require('gulp');
var rename = require('./lib/rename');

module.exports = function() {
	gulp.src()
      .pipe(rename({
        prefix: "copied-"
      }))
      .pipe(gulp.dest());
};