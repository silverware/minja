fs = require 'fs'
{spawn, exec} = require 'child_process'
which = require 'which'

# ANSI Terminal Colors
bold = '\x1B[0;1m'
red = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

root = "public/js/tree/"

treeFiles  = [
  # omit src/ and .coffee to make the below lines a little shorter
  'App.coffee'
  'model/round.coffee'
  'model/koRound.coffee'
  'model/groupRound.coffee'
  'model/roundItem.coffee'
  'model/group.coffee'
  'model/roundGame.coffee'
  'model/game.coffee'
  'model/gameAttribute.coffee'
  'model/player.coffee'
  'model/tournament.coffee'
  'view/TournamentView.coffee'
  'view/RoundItemView.coffee'
  'view/RoundSettingView.coffee'
  'view/RoundView.coffee'
  'view/GroupRoundView.coffee'
  'view/GroupView.coffee'
  'view/GameView.coffee'
  'view/TournamentPopup.coffee'
  'view/helper/NumberField.coffee'
  'view/helper/Alert.coffee'
  'view/detailViews/DetailView.coffee'
  'view/detailViews/GamesDetailView.coffee'
  'view/detailViews/RoundDetailView.coffee'
  'view/detailViews/RoundItemDetailView.coffee'
  'view/detailViews/FilterView.coffee'
  'view/detailViews/TableDetailView.coffee'
  'utils/Utils.coffee'
  'utils/PersistanceManager.coffee'
  'utils/RoundRobin.coffee'
]

for f, index in treeFiles
  treeFiles[index] = root + f

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
        return
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    tempFile = uniqueId()
    fs.writeFile "#{tempFile}.coffee", appContents.join('\n\n'), 'utf8', (err) ->
      if err
        return
      exec "coffee --join #{target} --compile #{tempFile}.coffee", (err, stdout, stderr) ->
        if err
          console.log 'Error while compiling'
          console.log err
        else
          fs.unlink "#{tempFile}.coffee", (err) ->
            if err
              return
          console.log 'Done.'

task 'build-tree', 'Build tree-app', ->
  concatAndBuild treeFiles, "public/js/tree.js"

task 'build-test', 'Build Tree-Test File', ->
  testFiles = readDir("public/js/tree/tests")
  concatAndBuild testFiles, "public/js/tree-test.js"

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

task 'test', 'Run Mocha tests', ->
  options = [
    '--compilers'
    'coffee:coffee-script'
  ]
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
  invoke 'watch'
  platform = process.platform
  invoke 'build-tree'
  cmd = which.sync 'nodemon'
  nodemon = spawn cmd, ["--exec", "coffee", "server.coffee", "-w", "app", "-w", "app/controllers", "-w", "app/dao", "-w", "app/services",  "-w", "app/helper",  "-w", "app/languages", ""]
  nodemon.stdout.pipe process.stdout
  nodemon.stderr.pipe process.stderr
  log 'Watching js files and running server', green