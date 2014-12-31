emberAppOrder = require './public/js/app/Order'

module.exports = (grunt) ->

  grunt.initConfig

    watch:
      coffee:
        files: ['public/js/app/**/*.coffee', 'public/less/**/*.less']
        tasks: 'compile'

    coffee:
      emberApp:
        options:
          join: true
        files:
          'public/js/app.js': emberAppOrder.files
      treeTests:
        options:
          join: true
        files:
          'public/js/tree-test.js': ['public/js/app/bracket/tests/**/*.coffee']
      all:
        expand: true
        cwd: 'public/js'
        src: ['**/*.coffee']
        dest: 'public/js'
        ext: '.js'

    requirejs:
      compile:
        options:
          baseUrl: "public/js",
          mainConfigFile: "public/js/require-config-global.js",
          out: "public/js/main-built.js"
          name: 'require-config-global'

    wrap:
      basic:
        src: 'public/js/app.js',
        dest: 'public/js/app.js',
        options:
          wrapper: [emberAppOrder.wrapperTop, emberAppOrder.wrapperBottom]

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

    webdriver:
      options:
        desiredCapabilities:
            browserName: 'chrome'
      login:
        tests: ['test/selenium/*.coffee'],
        options:
            desiredCapabilities:
                browserName: 'firefox'

  # load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  grunt.registerTask 'compile', ['clean', 'coffee:emberApp', 'wrap', 'coffee:treeTests', 'less']
  grunt.registerTask 'compileDist', ['compile', 'coffee:all', 'uglify', 'less']
  grunt.registerTask 'default', ['compile', 'concurrent']
  grunt.registerTask 'test', ['mochaTest', 'cucumberjs']

