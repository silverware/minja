languages =
  de: require '../languages/de'
  en: require '../languages/en'

module.exports = (req, res, next) ->
  if not req.session.language?
  	if /de/.test req.acceptedLanguages[0]
  	  req.session.language = "de"
  	else
  	  req.session.language = "en"

  req.i18n = languages[req.session.language]
  res.locals.i18n = languages[req.session.language]
  next()

