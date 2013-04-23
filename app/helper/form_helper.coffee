formFor = (tournament, yield_to, action="") ->
  wrapper = (name, label, control, startInline, stopInline) => 
    s = ""
    if not stopInline?
      s += """
        <div class="control-group">
        <label class="control-label" for="input#{name}">#{label}</label>
        <div class="controls">
      """
    s += """
        #{control}
    """
    if not startInline?
      s += """
        </div>
        </div>
      """
    @safe s
  form =
    password: (label, attribute, attributes) =>
      name = @escape attribute
      wrapper name, label, @safe("""<input id="input#{name}" name="#{name}" type="password" />""")

    textarea: (label, attribute, attributes) =>
      name = @escape attribute
      attributesString = " "
      for attr, val of attributes
        attributesString += """
          #{attr}="#{val}" 
        """

      value = if tournament[attribute]? then @escape tournament[attribute] else ""
      wrapper name, label, @safe("""<textarea id="input#{name}"  #{attributesString} name="#{name}">#{value}</textarea>""")

    textField: (label, attribute, attributes) =>
      name = @escape attribute

      attributesString = " "
      for attr, val of attributes
        attributesString += """
          #{attr}="#{val}" 
        """

      value = if tournament? and tournament[attribute]? then @escape tournament[attribute] else ""
      wrapper name, label, @safe("""
          <input type="text" value="#{value}" #{attributesString} id="input#{name}" name="#{name}">
      """), attributes?.startInline, attributes?.stopInline

    select: (label, attribute, attributes, options) =>
      name = @escape attribute

      attributesString = " "
      for attr, val of attributes
        attributesString += """
          #{attr}="#{val}" 
        """

      value = if tournament? and tournament[attribute]? then @escape tournament[attribute] else ""
      wrapper name, label, @safe("""
          <input type="text" value="#{value}" #{attributesString} id="input#{name}" name="#{name}">
      """), attributes?.startInline, attributes?.stopInline

    button: (label) =>
      saved = "Gespeichert"
      if label == "Save" then saved = "Saved"
      @safe """
        <div class="control-group">
          <div class="controls">
            <button class="btn btn-primary btn" type="submit">#{label}</button>
            <img class="ajaxLoader" src="/img/ajax-loader.gif" />
            <span class="successIcon"><i class="icon-ok"></i> #{saved}</span>
          </div>
        </div>
      """


  body = yield_to form
  action = if action == "" then "" else "action=\"#{action}\""
  @safe """<form class="form-horizontal" #{action} method="post">#{body}</form>"""

formWithActionFor = (object, action, yield_to) ->
  formFor.call(this, object, yield_to, action)

module.exports = (req, res, next) ->
  res.locals.formWithActionFor = formWithActionFor
  res.locals.formFor = formFor
  next()
