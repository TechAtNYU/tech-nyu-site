require! {
  gulp
  util: "gulp-util"
  changed: "gulp-changed"
  ls: "gulp-livescript"
  sass: "gulp-ruby-sass"
  clean: "gulp-clean"
  uglify: "gulp-uglify"
  rjs: "gulp-requirejs"
  replace: "gulp-replace"
  minify: "gulp-minify-html"
  es: "event-stream"
  filter: "gulp-filter"
}

paths =
  src: './src'
  build: './build'
  buildViews: './build/views'
  buildPublic: './build/public'
  buildCss: './build/public/css'

globs =
  src:  paths.src + '/**/*'
  build: paths.build + '/**/*'
  views: '**.tmpl'
  ls: paths.src + '/**/*.ls'
  js: paths.src + '/**/*.js'
  sass: ['./src/public/sass/screen.scss' './src/public/sass/skrollr/skrollr-*.scss']
  toCopyDirectly: ['./src/**/*' '!./src/**/*.ls' '!./src/public/sass{,/**}']

gulp.task('clean', ->
  gulp.src([paths.build], {read: false}).pipe(clean!)
)

gulp.task('copy', [\clean],  ->
  gulp.src(globs.toCopyDirectly).pipe(gulp.dest(paths.build))
)

gulp.task('sass', [\clean],  ->
  gulp.src(globs.sass)
    .pipe(changed(paths.buildCss))
    .pipe(sass({style:\compressed, compass: true}))
    .on('error', util.log)
    .pipe(gulp.dest(paths.buildCss))
)

gulp.task('ls', [\clean],  ->
  gulp.src(globs.ls)
    .pipe(changed(paths.build))
    .pipe(ls({bare: true}))
    .on('error', util.log)
    .pipe(gulp.dest(paths.build))
)

# runs all the amd modules through r.js and uglify; dump to build.
gulp.task('optimizeJS', [\ls \copy], ->
  rjs(do
    baseUrl: paths.buildPublic + '/scripts/bower_components',
    paths:
      jquery: \empty:
    mainConfigFile: paths.buildPublic + '/scripts/app.js'
    include: [\app]
    out: 'scripts/app.js'
    preserveLicenseComments: false
  ).pipe(uglify!)
  .pipe(gulp.dest(paths.buildPublic))
  void
)

gulp.watch(globs.src, [\dev])
gulp.task(\test, [])
gulp.task(\dev, [\clean \ls \copy \sass])
gulp.task(\default, [\dev \optimizeJS])