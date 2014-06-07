window.UniqueId =
  create: (length=8) ->
    id = ""
    id += Math.random().toString(36).substr(2) while id.length < length
    id.substr 0, length

############ after each Page-Load ##################
require ->
  $("[rel='tooltip']").tooltip()

  # Favorite Tournament Toggle
  $favIcon = $("#favoriteStar")
  if $favIcon
  	isFavorite = $favIcon.attr "isFavorite"
  	if isFavorite then $favIcon.addClass "icon-star" else $favIcon.addClass "icon-star-empty"
  	$favIcon.click ->
  	  $.post "/me/favorites/toggle", tid: $favIcon.attr "tid"
  	  $favIcon.toggleClass "icon-star"
  	  $favIcon.toggleClass "icon-star-empty"
