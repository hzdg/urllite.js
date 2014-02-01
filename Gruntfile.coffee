module.exports = (grunt) ->

  TEST_SERVER_PORT = 4000

  # Used instead of "ext" to accommodate filenames with dots. Lots of talk all
  # over GitHub, including here: https://github.com/gruntjs/grunt/pull/750
  coffeeRename = (dest, src) -> "#{ dest }#{ src.replace /\.(lit)?coffee$/, '.js' }"

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    browserify:
      options:
        transform: ['coffeeify']
      standalone:
        options:
          standalone: 'urllite'
        files:
          './browser-builds/standalone/urllite.js': './lib/core.js'
          './browser-builds/standalone/urllite-full.js': './lib/complete.js'
      tests:
        files:
          './test/tests.js': './test/tests.litcoffee'
    coffee:
      compile:
        files: [
          expand: true
          cwd: './src/'
          src: ['**/*.litcoffee', '**/*.coffee']
          dest: './lib/'
          rename: coffeeRename
        ]
    connect:
      tests:
        options:
          port: TEST_SERVER_PORT
          base: '.'
    mocha:
      all:
        options:
          run: true
          log: true
          reporter: 'Spec'
          urls: ["http://localhost:#{ TEST_SERVER_PORT }/test/index.html"]
    watch:
      options:
        atBegin: true
      lib:
        files: ['src/*.litcoffee', 'src/*.coffee']
        tasks: ['build:node', 'build:standalone']
      tests:
        files: ['test/*.litcoffee', 'test/urls.json']
        tasks: ['build:tests']
    bump:
      options:
        files: ['package.json', 'bower.json']
        commit: true
        commitFiles: ['-a']
        createTag: true
        push: false

  # Load grunt plugins
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-mocha'
  grunt.loadNpmTasks 'grunt-bump'
  grunt.loadNpmTasks 'grunt-browserify'

  # Define tasks.
  grunt.registerTask 'build', ['build:node', 'build:standalone', 'build:tests']
  grunt.registerTask 'build:node', ['coffee']
  grunt.registerTask 'build:standalone', ['build:node', 'browserify:standalone']
  grunt.registerTask 'build:tests', ['browserify:tests']
  grunt.registerTask 'default', ['build']
  grunt.registerTask 'test', ['build', 'connect:tests', 'mocha']
