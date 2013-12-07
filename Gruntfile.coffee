treeOrderedFiles = require './public/js/tree/Order'

module.exports = (grunt) ->

  clientDir =  "client/"
  publicDir = "server/public/"

  grunt.initConfig

    watch:
      coffee:
        files: ['public/js/tree/**/*.coffee']
        tasks: 'coffee'

    coffee:
      tree:
        options:
          join: true
        files:
          'public/js/tree.js': treeOrderedFiles
      treeTests:
        options:
          join: true
        files:
          'public/js/tree-test.js': ['public/js/tree/tests/*.coffee']

    uglify:
      js:
        files: [
          expand: true
          cwd: 'public/js/'
          src: '**/*.js'
          dest: 'public/js'
        ]

    nodemon:
      server:
        options:
          file: 'app'
          watchedExtensions: ['coffee']
          watchedFolders: ['app']
          debug: true
          delayTime: 1

    concurrent:
      tasks: ['nodemon', 'watch']
      options:
        logConcurrentOutput: true

    mochaTest:
      test:
        options:
          reporter: 'spec'
          timeout: 2*60*1000
          require: 'coffee-script'
        src: ['test/**/*.coffee']

    clean:
      dist: [
        'public/js/tree.js'
        'public/js/tree-test.js'
      ]

  # load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  grunt.registerTask 'compile', ['clean', 'coffee']
  grunt.registerTask 'compileDist', ['compile', 'uglify']
  grunt.registerTask 'default', ['compile', 'concurrent']
  grunt.registerTask 'test', 'mochaTest'

