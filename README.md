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
/* 
  instead of require('gulp') and then defining tasks on it
  just write the following 
*/
require('gulp-tasks')();
```

Now create a folder next to your gulpfile.js called `gulp` and have them contain tasks like this:
```javascript
/*
  no need to require('gulp')
  because gulp is already defined in the scope of the module
*/
module.exports = function () {
	gulp.src('...')
	// your gulp task here
		.pipe(gulp.dest('...'));
}
    
// the following line is optional
module.exports.dependencies = ['dep1', 'dep2'];
```
(Note: this setup is compatible with [gulp-task-loader](https://www.npmjs.org/package/gulp-task-loader).)
You can also write tasks in coffeescript.

**WARNING**: tasks are included inside the scope of the gulpfile. Therefore, when require-ing from relative paths within tasks, assume the current directory is the one in which the gulpfile is found.

## Extra features
Gulp-tasks wraps the gulp library in a backwards-compatible way and exposes it to the tasks. 
This means you can define your tasks as if gulp was pre-loaded, but you can also use some shortcuts or extra features.

### gulp.util
This exposes the gulp-util library. In other words, you can use `gulp.util` instead of
```
var gutil = require('gulp-util');
gutil.log(); // or whatever gulp-util function you would use
```

## License
[MIT](http://github.com/call-a3/gulp-tasks/blob/master/LICENSE)
