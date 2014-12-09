treeOrder = require './public/js/tree/Order'

module.exports = (grunt) ->

  grunt.initConfig

    watch:
      coffee:
        files: ['public/js/tree/**/*.coffee', 'public/less/**/*.less']
        tasks: 'compile'

    coffee:
      tree:
        options:
          join: true
        files:
          'public/js/tree.js': treeOrder.files
      treeTests:
        options:
          join: true
        files:
          'public/js/tree-test.js': ['public/js/tree/tests/**/*.coffee']
      all:
        expand: true
        cwd: 'public/js'
        src: ['**/*.coffee']
        dest: 'public/js'
        ext: '.js'

    wrap:
      basic:
        src: 'public/js/tree.js',
        dest: 'public/js/tree.js',
        options:
          wrapper: [treeOrder.wrapperTop, treeOrder.wrapperBottom]

    less:
      production:
        options:
          cleancss: true,
        files: [
          expand: true
          cwd: 'public/less/'
          src: '**/*.less'
          filter: (filepath) ->
            # do not compile colors_template.less -> compiled at runtime
            return -1 == filepath.indexOf 'colors_template'
          dest: 'public/css'
          ext: '.css'
        ]

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
        src: ['test/mocha/**/*.coffee']

    cucumberjs:
      src: 'test/cucumber/features'
      options:
        format: 'summary'
        steps: "test/cucumber/step_definitions"

    clean:
      dist: [
        'public/js/**/*.js'
        'public/css/**/*.css'
      ]

  # load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  grunt.registerTask 'compile', ['clean', 'coffee:tree', 'wrap', 'coffee:treeTests', 'less']
  grunt.registerTask 'compileDist', ['compile', 'coffee:all', 'uglify', 'less']
  grunt.registerTask 'default', ['compile', 'concurrent']
  grunt.registerTask 'test', ['mochaTest', 'cucumberjs']

