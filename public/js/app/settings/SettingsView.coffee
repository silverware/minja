App.templates.settings = """
<div class="container dashboard">
  <div class="row">
  <div class="col-md-6">
  <div class="dashboardBox">
    <fieldset>
      <legend>{{App.i18n.settings.colorSelection}}</legend>
        <%= @formWithActionFor @tournament.colors, "/tournament.id/settings/colors", (form) => %>
          <div class="form-group">
            <label class="control-label col-sm-2">{{App.i18n.settings.theme}}</label>
            <div class="col-sm-10">
              <span class="btn btn-link" id="selectTheme"><i class="fa fa-picture-o"></i><%= @i18n.settings.selectTheme %></span>
            </div>
          </div>
          <%= form.colorSelect @i18n.settings.background, "background", {placeholder: @i18n.color} %>
          <br />
          <%= form.colorSelect @i18n.settings.content, "content", {placeholder: @i18n.color} %>
          <%= form.colorSelect @i18n.settings.contentText, "contentText", {placeholder: @i18n.color} %>
          <br />
          <%= form.colorSelect @i18n.settings.footer, "footer", {placeholder: @i18n.color} %>
          <%= form.colorSelect @i18n.settings.footerText, "footerText", {placeholder: @i18n.color} %>
          <%= form.button @i18n.settings.applyColor %>
        <% end %>
    </fieldset>
  </div>
  </div>

  <div class="col-md-6">
  <div class="dashboardBox">
    <fieldset>
      <legend>{{App.i18n.settings.publicName}}</legend>
        <%= @infoHint => %>
          <%= @i18n.settings.publicNameInfo %><br /><%= @i18n.settings.publicNameExample %>
          <br /> <br />
          {{App.i18n.settings.publicNameRestriction}}
          <ul>
            <li>{{App.i18n.settings.publicNameRestriction1}}</li>
            <li>{{App.i18n.settings.publicNameRestriction2}}</li>
            <li>{{App.i18n.settings.publicNameRestriction3}}</li>
          </ul>
        <% end %>
        <br />

        <%= @formFor @tournament, (form) => %>
          <%= form.textField 'Name', "publicName", {class: "publicName", placeholder: @i18n.settings.publicName} %>
          <%= form.button @i18n.save %>
        <% end %>
    </fieldset>
    <!--
    <fieldset>
      <legend><%= @i18n.settings.messages %></legend>

Nachrichten aktivieren/deaktivieren

  -->
</div>
"""

App.SettingsView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.settings
  didInsertElement: ->
    @_super()

