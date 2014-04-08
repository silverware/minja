express = require 'express'
MemoryStore = require('connect').session.MemoryStore
configure_controllers = require './controllers/config'
partials = require 'express-partials'
consolidate = require 'consolidate'
assets = require 'connect-assets'
coffee = require 'coffee-script'
eco = require 'eco'
config = require "./server-config"
fs = require 'fs'
flash = require 'connect-flash'


app = express()
app.engine 'eco', consolidate.eco
app.set "view engine", 'eco'
app.use partials()
app.use express.methodOverride()
app.use assets src: config.CLIENT_DIR, buildDir: false
app.use express.bodyParser()
app.use express.cookieParser 'keyboard cat'
app.use express.static config.CLIENT_DIR
app.use express.session({secret: 'keyboard cat', cookie: {maxAge: 1000 * 60 * 24 * 30}, store: new MemoryStore({ reapInterval:  60000 * 10 })})
app.use flash()

configure_controllers app


if config.isDevelopment
  # needed to provide compiled coffeescript files
  app.get /^(\/[^\s]+)\.js$/, (req, res) ->
    res.header 'Content-Type', 'application/x-javascript'
    cs = fs.readFileSync "#{config.CLIENT_DIR}/#{req.params[0]}.coffee", "utf8"
    js = coffee.compile cs
    res.send js

app.listen config.SERVER_PORT
console.log "Express server started"
