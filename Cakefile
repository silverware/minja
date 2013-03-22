fs = require 'fs'
{spawn, exec} = require 'child_process'
which = require 'which'
{print} = require 'util'


# ANSI Terminal Colors
bold = '\x1B[0;1m'
red = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

tournament_tree_root_dir = "public/js/tree/"

treeFiles  = [
  # omit src/ and .coffee to make the below lines a little shorter
  tournament_tree_root_dir + 'App.coffee',
  tournament_tree_root_dir + 'model/round.coffee',
  tournament_tree_root_dir + 'model/koRound.coffee',
  tournament_tree_root_dir + 'model/groupRound.coffee',
  tournament_tree_root_dir + 'model/roundItem.coffee',
  tournament_tree_root_dir + 'model/group.coffee',
  tournament_tree_root_dir + 'model/roundGame.coffee',
  tournament_tree_root_dir + 'model/game.coffee',
  tournament_tree_root_dir + 'model/player.coffee',
  tournament_tree_root_dir + 'model/tournament.coffee',
  tournament_tree_root_dir + 'view/TournamentView.coffee',
  tournament_tree_root_dir + 'view/RoundItemView.coffee',
  tournament_tree_root_dir + 'view/RoundSettingView.coffee',
  tournament_tree_root_dir + 'view/RoundView.coffee',
  tournament_tree_root_dir + 'view/GroupRoundView.coffee',
  tournament_tree_root_dir + 'view/GroupView.coffee',
  tournament_tree_root_dir + 'view/GameView.coffee',
  tournament_tree_root_dir + 'view/TournamentPopup.coffee',
  tournament_tree_root_dir + 'view/helper/NumberField.coffee',
  tournament_tree_root_dir + 'view/helper/Alert.coffee',
  tournament_tree_root_dir + 'view/detailViews/DetailView.coffee',
  tournament_tree_root_dir + 'view/detailViews/GroupDetailView.coffee',
  tournament_tree_root_dir + 'view/detailViews/GroupGamesDetailView.coffee',
  tournament_tree_root_dir + 'view/detailViews/GroupRoundDetailView.coffee',
  tournament_tree_root_dir + 'view/detailViews/KoRoundDetailView.coffee',
  tournament_tree_root_dir + 'utils/Utils.coffee',
  tournament_tree_root_dir + 'utils/PersistanceManager.coffee',
  tournament_tree_root_dir + 'utils/RoundRobin.coffee'
]

readDir = (src) ->
  files = fs.readdirSync(src)
  allFiles = []
  for file in files
    if file.match(/\.coffee$/)
      allFiles.push src + "/" + file
    else
      if file != ".svn" && !file.match(/\.js$/) && !file.match(/\.hbs$/)
        allFiles = allFiles.concat readDir(src + "/" + file)
  allFiles

uniqueId = (length = 8) ->
  id = ""
  id += Math.random().toString(36).substr(2) while id.length < length
  id.substr 0, length
  id

concatAndBuild = (files, target) ->
  appContents = new Array remaining = files.length
  for file, index in files then do (file, index) ->
    fs.readFile file, 'utf8', (err, fileContents) ->
      if err
        console.log "huhu" + file
        return
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    tempFile = uniqueId()
    fs.writeFile "#{tempFile}.coffee", appContents.join('\n\n'), 'utf8', (err) ->
      if err
        console.log "huhu"
        return
      exec "coffee --join #{target} --compile #{tempFile}.coffee", (err, stdout, stderr) ->
        if err
          console.log 'Error while compiling'
          console.log err
        else
          fs.unlink "#{tempFile}.coffee", (err) ->
            if err
              console.log "huhu"
              return
          console.log 'Done.'

task 'build-tree', 'Build tree-app', ->
  concatAndBuild(treeFiles, "public/js/tree.js")

task 'build-test', 'Build Tree-Test File', ->
  testFiles = readDir("public/js/tree/tests")
  concatAndBuild(testFiles, "public/js/tree-test.js")

task 'watch', 'Watch prod source files and build changes', ->
    invoke 'build-tree'
    invoke 'build-test'
    console.log "Watching for changes in src"
    allFiles = readDir("public/js/tree")
    for file in allFiles then do (file) ->
        fs.watch file, (curr, prev) ->
            if +curr.mtime isnt +prev.mtime
                console.log "Saw change in #{file}"
                console.log 'Whoa. Saw a change. Building. Hold plz.'
                invoke 'build-tree'
                invoke 'build-test'




log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

task 'spec', 'Run Mocha tests', ->
  build -> test -> log ":)", green

task 'test', 'Run Mocha tests', ->
  options = [
    '--compilers'
    'coffee:coffee-script'
  ]
  ###'--require'
  './server'###
  try
    cmd = which.sync 'mocha'
    spec = spawn cmd, options
    spec.stdout.pipe process.stdout
    spec.stderr.pipe process.stderr
    spec.on 'exit', (status) -> callback?() if status is 0
  catch err
    log err.message, red
    log 'Mocha is not installed - try npm install mocha -g', red


task 'dev', 'start dev env', ->
  platform = process.platform
  isWindows = platform == 'win32'
  iced = "coffee"
  #if isWindows
  #  iced = "coffee"
  invoke 'build-tree'
  cmd = which.sync 'nodemon'
  nodemon = spawn cmd, ["--exec", iced, "server.coffee", "-w", "app", "-w", "app/controllers", "-w", "app/dao", "-w", "app/services",  "-w", "app/helper",  "-w", "app/languages", ""]
  nodemon.stdout.pipe process.stdout
  nodemon.stderr.pipe process.stderr
  log 'Watching js files and running server', green