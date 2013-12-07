treeOrderedFiles = require './public/js/tree/Order'

module.exports = (grunt) ->

  grunt.initConfig

    watch:
      coffee:
        files: ['public/js/tree/**/*.coffee']
        tasks: 'compile'

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
      all:
        expand: true
        cwd: 'public/js'
        src: ['**/*.coffee']
        dest: 'public/js'
        ext: '.js'

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
          file: 'server.coffee'
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
        'public/js/**/*.js'
      ]

  # load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  grunt.registerTask 'compile', ['clean', 'coffee:tree', 'coffee:treeTests']
  grunt.registerTask 'compileDist', ['compile', 'coffee:all', 'uglify']
  grunt.registerTask 'default', ['compile', 'concurrent']
  grunt.registerTask 'test', 'mochaTest'

