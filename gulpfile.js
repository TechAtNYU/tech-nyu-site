// TODO jshint/jscs + unit testing

var gulp    = require('gulp');
var util    = require("gulp-util");
var changed = require("gulp-changed");
var sass    = require("gulp-ruby-sass");
var clean   = require("gulp-clean");
var uglify  = require("gulp-uglify");
var rjs     = require("gulp-requirejs")
var replace = require("gulp-replace");
var minify  = require("gulp-minify-html");
var es      = require("event-stream");
var filter  = require("gulp-filter");
var htmlReplace = require("gulp-html-replace");

var paths = {
  src: './src',
  build: './build',
  buildViews: './build/views',
  buildPublic: './build/public',
  buildCss: './build/public/css'
};

var globs = {
  src: paths.src + '/**/*',
  build: paths.build + '/**/*',
  views: '**.tmpl',
  js: paths.src + '/**/*.js',
  sass: ['./src/public/sass/{screen,apply}.scss', './src/public/sass/skrollr/skrollr-*.scss'],
  toCopyDirectly: ['./src/**/*', '!./src/**/*.js', '!./src/public/sass{,/**}']
};

gulp.task('clean', function(){
  return gulp.src([paths.build], {
    read: false
  }).pipe(clean());
});

gulp.task('copy', ['clean'], function(){
  return gulp.src(globs.toCopyDirectly).pipe(changed(paths.build)).pipe(gulp.dest(paths.build));
});

gulp.task('sass', ['clean'], function(){
  return gulp.src(globs.sass).pipe(changed(paths.buildCss)).pipe(sass({
    style: 'compressed',
    compass: true
  })).on('error', util.log).pipe(gulp.dest(paths.buildCss));
});

gulp.task('compileJS', ['clean'], function(){
  return gulp.src(globs.js).pipe(changed(paths.build))/*.pipe(ls({
    bare: true
  })).on('error', util.log)*/.pipe(gulp.dest(paths.build));
});

gulp.task('optimizeJS', ['compileJS', 'copy'], function(){
  rjs({
    baseUrl: paths.buildPublic + '/scripts/bower_components',
    paths: {
      jquery: 'empty:',
      requireLib: "requirejs/require"
    },
    mainConfigFile: paths.buildPublic + '/scripts/app.js',
    include: ['requireLib', 'app'],
    insertRequire: ['app'],
    out: 'scripts/app.js',
    preserveLicenseComments: false
  }).pipe(uglify()).pipe(gulp.dest(paths.buildPublic));
});

gulp.task('buildHTML', ['copy'], function(){
  return gulp.src(paths.build + '/views/home.tmpl').pipe(htmlReplace({
    js: 'scripts/app.js'
  })).pipe(gulp.dest(paths.build + '/views'));
});

gulp.task('test', []);
gulp.task('dev', ['clean', 'compileJS', 'copy', 'sass']);
gulp.task('default', ['dev', 'optimizeJS', 'buildHTML']);
