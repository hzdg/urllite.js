module.exports = (grunt) ->

  TEST_SERVER_PORT = 4000

  # Used instead of "ext" to accommodate filenames with dots. Lots of talk all
  # over GitHub, including here: https://github.com/gruntjs/grunt/pull/750
  coffeeRename = (dest, src) -> "#{ dest }#{ src.replace /\.(lit)?coffee$/, '.js' }"

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      compile:
        files: [
          expand: true
          cwd: './src/'
          src: ['*.litcoffee', '*.coffee']
          dest: './'
          rename: coffeeRename
        ]
      tests:
        files: [
          expand: true
          src: 'test/**/*.coffee'
          ext: '.js'
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
      coffee:
        files: ['src/*.litcoffee', 'src/*.coffee', 'test/*.coffee']
        tasks: ['coffee']
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

  # Define tasks.
  grunt.registerTask 'build', ['coffee']
  grunt.registerTask 'default', ['build']
  grunt.registerTask 'test', ['coffee', 'connect:tests', 'mocha']
