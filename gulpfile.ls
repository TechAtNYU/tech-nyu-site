require! {
  gulp
  util: "gulp-util"
  changed: "gulp-changed"
  ls: "gulp-livescript"
  sass: "gulp-ruby-sass"
  clean: "gulp-clean"
}

paths =
  build: './build/'
  buildViews: './build/views/'
  buildCss: './build/public/css'

globs =
  src: './src/**/*'
  build: './build/*'
  views: '**.tmpl'
  ls: './src/**/*.ls'
  sass: './src/sass/screen.scss'
  srcRaw: ['./src/**/*' '!./src/sass' '!**/*.{ls,scss}']

gulp.task('clean', ->
  gulp.src(paths.build, {read: false}).pipe(clean())
)

gulp.task('sass', [\clean],  ->
  gulp.src(globs.sass)
    .pipe(changed(paths.buildCss))
    .pipe(sass())
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

gulp.task('copy', [\clean],  ->
  gulp.src(globs.srcRaw)
    .pipe(gulp.dest(paths.build))
)

gulp.watch(globs.src, [\default])
gulp.task(\default, [\clean \ls \copy \sass])