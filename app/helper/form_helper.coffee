eco = require "eco"


passwordTemplate = """
  <input id="input<%= @name %>" name="<%= @name %>" type="password" />
"""

textareaTemplate = """
  <textarea id="input<%= @name %>" <%= @attrs %> name="<%= @name %>"><%- @val %></textarea>
"""

textfieldTemplate = """
  <input type="text" value="<%- @val %>" <%= @attrs %> id="input<%= @name %>" name="<%= @name %>">
"""

selectTemplate = """
  <div class="chosen">
    <select type="text" class="chzn-select" value="<%= @val %>" <%= @attrs %> id="input<%= @name %>" name="<%= @name %>">
      <% for opt in @options: %>
        <option value="<%= opt.id %>"><%= opt.label %></option> 
      <% end %>
    </select>
  </div>
  <script>$("#input<%= @name %>").chosen()</script>
"""


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

  render = (template, args) =>
    label = args[0]
    attribute = args[1]
    attributes = args[2]
    startInline = attributes?.startInline
    stopInline = attributes?.stopInline

    locals = createLocals label, attribute, attributes
    control = eco.render template, locals
    wrapper locals.name, label, control, startInline, stopInline

  createAttributes = (attributes) =>
    attributesString = " "
    for attr, val of attributes
      attributesString += """ #{attr}="#{val}" """
    @safe attributesString

  createLocals = (label, attribute, attributes) =>
    locals =
      name: attribute
      attrs: createAttributes attributes
      val: value attribute

  value = (name) =>
    if obj and obj[name] then @escape obj[name] else ""

  form =
    password: =>
      render passwordTemplate, arguments

    textarea: =>
      render textareaTemplate, arguments

    textField: =>
      render textfieldTemplate, arguments

    select: (label, attribute, attributes, options) =>
      locals = createLocals.apply null, arguments
      locals.options = options
      wrapper locals.name, label, eco.render selectTemplate, locals

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
