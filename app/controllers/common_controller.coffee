class CommonController

  "/": (req, res) =>
    res.render 'index'

  "/impressum": (req, res) =>
    res.render 'impressum'

  "/lang/:lang": (req, res) =>
  	req.session.language = req.params.lang
  	res.redirect req.param "next"

module.exports = new CommonController()
