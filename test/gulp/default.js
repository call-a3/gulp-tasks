console.log('global: ' + Object.getOwnPropertyNames(global).sort().join(', \n\t'));
console.log('module: ' + Object.keys(module).sort().join(', '));

module.exports = function() {
	gulp.src().pipe(gulp.dest());
};