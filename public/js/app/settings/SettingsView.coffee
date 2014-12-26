App.templates.settings = """
<div class="container dashboard">
  <div class="row">
  <div class="col-md-6">
  <div class="dashboardBox">
    <fieldset>
      <legend>{{App.i18n.settings.colorSelection}}</legend>
      <form class="form-horizontal" action="{{unbound colorsUrl}}" method="post">
          <div class="form-group">
            <label class="control-label col-sm-2">{{App.i18n.settings.theme}}</label>
            <div class="col-sm-10">
              <span class="btn btn-link" {{action "openSelectionPopup" target="view"}}><i class="fa fa-picture-o"></i>{{App.i18n.settings.selectTheme}}</span>
            </div>
          </div>
          {{#form-group label=i18n.settings.background name="background"}}
            {{color-selection value=tournament.settings.colors.background name="background"}}
          {{/form-group}}
          {{#form-group label=i18n.settings.content name="content"}}
            {{color-selection value=tournament.settings.colors.content name="content"}}
          {{/form-group}}
          {{#form-group label=i18n.settings.contentText name="contentText"}}
            {{color-selection value=tournament.settings.colors.contentText name="contentText"}}
          {{/form-group}}
          {{#form-group label=i18n.settings.footer name="footer"}}
            {{color-selection value=tournament.settings.colors.footer name="footer"}}
          {{/form-group}}
          {{#form-group label=i18n.settings.footerText name="footerText"}}
            {{color-selection value=tournament.settings.colors.footerText name="footerText"}}
          {{/form-group}}
          {{save-button label=i18n.settings.applyColor}}
        </form>
    </fieldset>
  </div>
  </div>
  </div>
"""


App.SettingsView = Em.View.extend
  temp: """
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
  template: Ember.Handlebars.compile App.templates.settings

  actions:
    openSelectionPopup: ->
      App.ColorSelectionPopup.create
        onSelection: @fillColors

  didInsertElement: ->
    @_super()

  fillColors: (colorTheme) =>
    console.debug "fill"
    for key, value of colorTheme
      if key is "name" then continue
      $("input[name='#{key}']").val value
    $("input[name='content']").closest("form").submit()


