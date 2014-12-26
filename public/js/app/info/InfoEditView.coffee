App.templates.infoEdit = """
  <h1>{{i18n.info.header}}</h1>
  <form class="form-horizontal">
    <fieldset>
      <legend>{{i18n.info.basicData}}</legend>
        {{#form-group label=i18n.info.tournamentName name="name"}}
          {{input value=tournament.info.name name="name"}}
        {{/form-group}}
  </form>
"""

App.InfoEditView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.infoEdit

  didInsertElement: ->
    @_super()

tempasdlfj= """
    <%= @headerAction i18n.show, "../info", "eye-open" %>
    <h1><%= @i18n.info.header %></h1>
    <%= @formFor @tournament.info, (form) => %>
      <fieldset>
        <legend><%= @i18n.info.basicData %></legend>
        <%= form.textField @i18n.tournamentName, "name", {class: "required", formControl: "col-md-4"} %>
        <%= form.textarea "i18n.info.description}<br /><a href="http://daringfireball.net/projects/markdown/syntax" target="_blank">Markdown</a><br /><button class="btn btn-inverse" style="margin-top: 20px" onclick="save.openPreview()">info.preview}</button>", "description" %>

        <%= form.textField @i18n.info.venue, "venue", {formControl: 'col-md-4'} %>
        <div class="form-group">
          <label class="control-label col-sm-2"><%= @i18n.info.startDate %></label>
          <div class="col-sm-10 col-md-8 inline-form-groups">
            <div class='input-group col-sm-3' id="startDate">
              <input type='text' name="startDate" value="<%= @tournament.info.startDate %>" class="form-control" />
                <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
              </div>
            <div class='input-group col-sm-3' id="startTime">
              <input type='text' name="startTime" value="<%= @tournament.info.startTime %>" class="form-control" />
                <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
              </div>
            </div>
          </div>

        <div class="form-group">
          <label class="control-label col-sm-2"><%= @i18n.info.stopDate %></label>
          <div class="col-sm-10 col-md-8 inline-form-groups">
            <div class='input-group col-sm-3' id="stopDate">
              <input type='text' name="stopDate" value="<%= @tournament.info.stopDate %>" class="form-control" />
                <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
              </div>
            <div class='input-group col-sm-3' id="stopTime">
              <input type='text' name="stopTime" value="<%= @tournament.info.stopTime %>" class="form-control" />
                <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
              </div>
            </div>
          </div>
      </fieldset>

      <fieldset>
        <legend><%= @i18n.contact %></legend>
        <%= form.textField @i18n.info.host, "host", {formControl: "col-md-4"} %>
        <%= form.textField "E-Mail", "hostMail", {class: "email", formControl: "col-md-4"} %>
      </fieldset>

      <%= form.button @i18n.save %>
    <% end %>
  """

