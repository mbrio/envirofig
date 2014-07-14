gulp = require 'gulp'
coffeelint = require 'gulp-coffeelint'
mocha = require 'gulp-mocha'
clean = require 'gulp-clean'
istanbul = require 'gulp-istanbul'
biscotto = require 'gulp-biscotto'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'

srcFiles = ['./src/**/*.coffee']
libFiles = ['./lib/**/*.js']

gulp.task 'clean-build', ->
  gulp.src './lib/*'
    .pipe clean { force: true }

gulp.task 'clean', ['clean-build']

gulp.task 'lint', ->
  gulp.src srcFiles.concat ['./*.coffee', './spec/**/*.coffee']
    .pipe coffeelint()
    .pipe coffeelint.reporter()
    .pipe coffeelint.reporter('fail')

gulp.task 'test', ['lint', 'build'], (cb) ->
  gulp.src libFiles
    .pipe istanbul()
    .on 'finish', ->
      gulp.src ['./spec/**/*-spec.coffee']
        .pipe mocha({
          reporter: 'spec'
          compilers: 'coffee:coffee-script'
          bail: true
        })
        .on 'error', -> @emit 'end'
        .pipe istanbul.writeReports()
        .on 'end', cb

  return

gulp.task 'spec', ['test']

gulp.task 'docs', ->
  biscotto()
    .pipe gulp.dest './docs'

gulp.task 'build', ['clean-build'], ->
  gulp.src srcFiles
    .pipe coffee({ bare: true }).on('error', gutil.log)
    .pipe gulp.dest 'lib'

gulp.task 'ci', ->
  watcher = gulp.watch srcFiles.concat(['./spec/**/*']), ['test']
  watcher.on 'error', (err) ->
    console.log 'An error has occurred'
    console.dir err

gulp.task 'watch', ->
  watcher = gulp.watch srcFiles, ['build']
  watcher.on 'error', (err) ->
    console.log 'An error has occurred'
    console.dir err

gulp.task 'doc', ['docs']

gulp.task 'default', ['test']
