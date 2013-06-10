moment = require 'moment'
config = require '../server-config'
marked = require 'marked'

module.exports = (req, res, next) ->
  res.locals.headerAction = (label, url, icon) ->
    @safe """
    <a href="#{url}" style="float: right">
      <button class="btn btn-inverse"><i class="icon-#{icon}"></i>#{label}</button>
    </a>
    """

  htmlEscape = (str) ->
    str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')

  res.locals.json = (obj) ->
    str = "" + JSON.stringify(obj)
    return htmlEscape str

  res.locals.user = req.user
  res.locals.path = req.path

  res.locals.isDevelopment = config.isDevelopment
  res.locals.isProduction = config.isProduction
  res.locals.rootPath = config.ROOTPATH

  res.locals.printDateAndTime = (date, time) ->
    if not date
      return ""
    output = """<i class="icon-calendar"></i>&nbsp; #{date}"""
    if time
      output += """&nbsp;&nbsp;&nbsp;<i class="icon-time"></i>&nbsp;#{time}"""
    @safe output

  res.locals.textOrNa = (text) ->
    if text then text else "n/a"

  res.locals.markdownToHtml = (str) ->
    @safe marked str

  res.locals.toSelectData = (array, id, label) ->
    if not array then return []
    array.map (item) ->
      iid = if id then item[id] else item
      newItem = 
        id: iid
        label: if label then item[label] else req.i18n[iid]


  res.addError = (message, title) ->
    res.locals.errors = [] if not res.locals.errors?
    res.locals.errors.push 
      message: message
      title: if title? then title else "#{req.i18n.error}!"

  res.addWarning = (message, title) ->
    res.locals.warnings = [] if not res.locals.warnings?
    res.locals.warnings.push
      message: message
      title: if title? then title else "#{req.i18n.warning}!"

  res.addInfo = (message, title) ->
    res.locals.infos = [] if not res.locals.infos?
    res.locals.infos.push
      message: message
      title: if title? then title else "Information!"

  next()

  