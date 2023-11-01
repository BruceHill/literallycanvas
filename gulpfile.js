const { src, dest, series, parallel, watch } = require('gulp');
const browserify = require('browserify');
const connect = require('gulp-connect');
const rename = require('gulp-rename');
const sass = require('gulp-sass')(require('sass'));
const source = require('vinyl-source-stream');
const streamify = require('gulp-streamify');
const uglify = require('gulp-uglify');
const coffee = require('gulp-coffee');
const babel = require('gulp-babel');
const preprocess = require('gulp-preprocess');
const preprocessify = require('preprocessify');
const merge = require('merge-stream');

function newcore() {
  return src(['./node_modules/literallycanvas-core/src/**/*.js'])
    .pipe(preprocess({ context: { INCLUDE_GUI: true } }))
    .pipe(babel())
    .pipe(dest('./src/core/'));
}

function commonjs() {
  const babelTrans = src(['./src/**/*.js', './src/**/*.jsx'])
    .pipe(preprocess({ context: { INCLUDE_GUI: true } }))
    .pipe(babel())
    .pipe(dest('./lib/js/'));

  const coffeeTrans = src('./src/**/*.coffee')
    .pipe(preprocess({ context: { INCLUDE_GUI: true } }))
    .pipe(coffee({ bare: true }))
    .pipe(dest('./lib/js/'));

  return merge(babelTrans, coffeeTrans);
}

function sassTask() {
  return src('./scss/**/*.scss')
    .pipe(sass({ outputStyle: 'compressed' }))
    .pipe(dest('./lib/css/'))
    .pipe(connect.reload());
}

function browserifyLcMain() {
  const bundleStream = browserify({
      basedir: 'src', 
      extensions: ['.js', '.jsx', '.coffee'], 
      debug: true, 
      standalone: 'LC'
    })
    .add('./index.coffee')
    .external('create-react-class')
    .external('react')
    .external('react-dom')
    .external('react-dom-factories')
    .transform(preprocessify, {
      includeExtensions: ['.coffee'],
      type: 'coffee',
      context: { INCLUDE_GUI: true }
    })
    
    .transform('coffeeify')
    .transform('babelify')
    .bundle()
    .on('error', function (err) {
      if (err) {
        console.error(err.toString());
      }
    });

  return bundleStream
    .pipe(source('./src/index.coffee'))
    .pipe(rename('literallycanvas.js'))
    .pipe(dest('./lib/js/'))
    .pipe(connect.reload());
}

function browserifyLcCore() {
  const bundleStream = browserify({
      basedir: 'src', 
      extensions: ['.js', '.jsx', '.coffee'], 
      debug: true, 
      standalone: 'LC'
    })
    .add('./index.coffee')
    .transform(preprocessify, {
      includeExtensions: ['.coffee'],
      type: 'coffee',
      context: {}
    })
    .transform('coffeeify')
    .transform('babelify')
    .bundle()
    .on('error', function (err) {
      if (err) {
        console.error(err.toString());
      }
    });

  return bundleStream
    .pipe(source('./src/index.coffee'))
    .pipe(rename('literallycanvas-core.js'))
    .pipe(dest('./lib/js/'))
    .pipe(connect.reload());
}

function uglifyTask() {
  return src(['./lib/js/literallycanvas?(-core).js'])
    .pipe(streamify(uglify()))
    .pipe(rename({ suffix: ".min" }))
    .pipe(dest('./lib/js'));
}

function demoReload() {
  return src('demo/*').pipe(connect.reload());
}

function serve(done) {
  connect.server({
    livereload: { port: 35728 }
  });
  done();
}

const watchTask = (done) => {
  watch(['src/*.coffee', 'src/*/*.coffee', 'src/*.js', 'src/*/*.js'], series(browserifyLcMain, browserifyLcCore));
  watch('scss/*.scss', sassTask);
  watch('demo/*', demoReload);
  done();
};

const defaultTask = series(parallel(uglifyTask, sassTask));
const dev = series(parallel(browserifyLcMain, browserifyLcCore, sassTask), parallel(watchTask, serve));

exports.newcore = newcore;
exports.commonjs = commonjs;
exports.sass = sassTask;
exports.browserifyLcMain = browserifyLcMain;
exports.browserifyLcCore = browserifyLcCore;
exports.uglify = uglifyTask;
exports.default = defaultTask;
exports.watch = watchTask;
exports.dev = dev;
