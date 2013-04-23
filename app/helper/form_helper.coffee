formFor = (obj, yield_to, action="") ->
  wrapper = (name, label, control, startInline, stopInline) => 
    s = ""
    if not stopInline?
      s += """
        <div class="control-group">
        <label class="control-label" for="input#{name}">#{label}</label>
        <div class="controls">
      """
    s += """#{control}"""

    if not startInline? then s += """</div></div>"""
    @safe s

  createAttributes = (attributes) ->
    attributesString = " "
    for attr, val of attributes
      attributesString += """ #{attr}="#{val}" """
    attributesString

  createOptions = (opts) ->
    attributesString = " "
    for attr, val of attributes
      attributesString += """ #{attr}="#{val}" """
    attributesString

  value = (name) =>
    if obj and obj[name] then @escape obj[name] else ""

  form =
    password: (label, attribute, attributes) =>
      name = @escape attribute
      content = @safe """<input id="input#{name}" name="#{name}" type="password" />"""
      wrapper name, label, content

    textarea: (label, attribute, attributes) =>
      name = @escape attribute
      attrs = createAttributes attributes
      val = value attribute
      content = @safe """<textarea id="input#{name}" #{attrs} name="#{name}">#{val}</textarea>"""
      wrapper name, label, content

    textField: (label, attribute, attributes) =>
      name = @escape attribute
      attrs = createAttributes attributes
      val = value attribute
      
      content = @safe """<input type="text" value="#{val}" #{attrs} id="input#{name}" name="#{name}">"""

      wrapper name, label, content, attributes?.startInline, attributes?.stopInline

    select: (label, attribute, attributes, options) =>
      name = @escape attribute
      attrs = createAttributes attributes
      val = value attribute
      opts = createOptions options
      content = @safe """<select type="text" value="#{val}" #{attrs} id="input#{name}" name="#{name}">#{opts}</select>"""
      wrapper name, label, content

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
  action = if not action then "" else """ action="#{action}" """
  @safe """<form class="form-horizontal" #{action} method="post">#{body}</form>"""

formWithActionFor = (object, action, yield_to) ->
  formFor.call(this, object, yield_to, action)

module.exports = (req, res, next) ->
  res.locals.formWithActionFor = formWithActionFor
  res.locals.formFor = formFor
  next()
