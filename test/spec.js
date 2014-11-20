process.chdir('./test');

var test = require('tape');
var modul = require('../');

var exec = require('child_process').exec;
var fs = require('fs');
var stream = require('stream');

test('gulp compliance test', function (t) {
    t.plan(7);

    t.equal(typeof modul, "function", 'gulp-tasks should be a function');
    var gulp = modul();

    t.equal(typeof gulp.task, "function", 'gulp.task should be a function');
    t.equal(typeof gulp.src, "function", 'gulp.src should be a function');
    t.equal(typeof gulp.src('./**').on, 'function', 'gulp.src(\'./**\') should return a readable stream');
    t.equal(typeof gulp.dest, "function", 'gulp.dest should be a function');
    t.equal(typeof gulp.dest('./').on, 'function', 'gulp.dest(\'./\') should return a writable stream');
    t.equal(typeof gulp.watch, "function", 'gulp.watch should be a function');
});

test('gulp extension test', function (t) {
    t.plan(4);
    var gulp = modul();

    t.equal(typeof gulp.src().on, 'function', 'gulp.src() should return a readable stream');
    t.equal(typeof gulp.dest().on, 'function', 'gulp.dest() should return a writable stream');
    var name = gulp.name;
    t.equal(typeof name, 'string', 'gulp.name should return a string');
    gulp.name = 'hahaha';
    t.equal(name, gulp.name, 'gulp.name should not be modifiable');
});

function checkFile(t, file, msg) {
    try {
        t.ok(fs.statSync(file).isFile(), msg);
    } catch (ex) {
        t.fail(msg);
    }
}

test('functionality test', function (t) {
    t.plan(4);

    exec('gulp', function (error, stdout, stderr) {
        t.error(error, 'gulp command should execute without errors');

        checkFile(t, './test/copied-dummy.js', 'gulp should have created a new file in test');
    });

    exec('gulp --target=production', function (error, stdout, stderr) {
        t.error(error, 'gulp command should execute without errors');

        checkFile(t, './dist/copied-dummy.js', 'gulp should have created a new file in dist');
    });
});