gulp-tasks
==========

[![Build Status](https://travis-ci.org/call-a3/gulp-tasks.svg?branch=master)](https://travis-ci.org/call-a3/gulp-tasks)
[![Dependency Status](https://david-dm.org/call-a3/gulp-tasks.svg)](https://david-dm.org/call-a3/gulp-tasks) [![devDependency Status](https://david-dm.org/call-a3/gulp-tasks/dev-status.svg)](https://david-dm.org/call-a3/gulp-tasks#info=devDependencies)

Gulp plugin that allows the use of browserify transforms in a gulp pipeline.

## Installation

[![gulp-tasks](https://nodei.co/npm/gulp-tasks.png?mini=true)](https://nodei.co/npm/gulp-tasks)

## Usage
Just write this in your gulpfile.js
```javascript
// instead of require('gulp') and then defining tasks on it, just do
require('gulp-tasks');
```

Now create a folder next to your gulpfile.js called `gulp` and have them contain tasks like this:
```javascript
module.exports = function () {
	gulp.src('...')
	// your gulp task here
		.pipe(gulp.dest('...'));
}
```
You can also write tasks in coffeescript.

## License
[MIT](http://github.com/call-a3/gulp-tasks/blob/master/LICENSE)
