_ = require 'underscore'
one = require "onecolor"

module.exports =

  defaultColors:
    content: "rgba(72, 82, 97, 0.7)"
    contentText: "rgba(255,255,255,1)"
    background: "rgba(106, 123, 145, 1)"
    footer: "rgba(52, 62, 77, 0.95)"
    footerText: "rgba(255,255,255,1)"

  isColorSelected: (tournament) ->
    if not tournament.colors then return false
    for key, value of @defaultColors
      if not tournament.colors[key] then return false
    true

  getColors: (tournament) ->
    if @isColorSelected tournament
      return tournament.colors
    else
      return @defaultColors

  isDefaultColor: (color) ->
    for key, value of @defaultColors
      if color[key] isnt @defaultColors[key] then return false
    true

  opaque: (color) ->
    begin = color.lastIndexOf ","
    stop = color.indexOf ")"
    color.replace color.substring(begin, stop), ",1"

  generateLinkColor: (color) ->
    textColor = one color.contentText
