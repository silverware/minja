# TODO: nachrichten aktivieren/deaktivieren
#
#

App.templates.settings = """
<div class="container dashboard">
  <div class="row">
  <div class="col-md-6">
  <div class="dashboardBox">
    <fieldset>
      <legend>{{i18n.settings.colorSelection}}</legend>
      <form class="form-horizontal" action="{{unbound colorsUrl}}" method="post">
          <div class="form-group">
            <label class="control-label col-sm-2">{{i18n.settings.theme}}</label>
            <div class="col-sm-10">
              <span class="btn btn-link" {{action "openSelectionPopup" target="view"}}><i class="fa fa-picture-o"></i>{{i18n.settings.selectTheme}}</span>
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
  <div class="dashboardBox">

    <fieldset>
      <legend>{{i18n.settings.uploadLogo}}</legend>

      <form class="form-horizontal" role="form" action="/{{unbound tournament.identifier}}/logo" method="post" enctype="multipart/form-data">
      <div id="logocontainer" {{bind-attr class="tournament.settings.hasLogo::hide"}}>
        <div class="form-group">
          <label class="control-label col-sm-2">&nbsp;</label>
          <div class="col-sm-10">
            <img id="logo" style="max-width:200px" src="/{{unbound tournament.identifier}}/logo/display" alt="your tournament logo" />
          </div>
        </div>
      </div>
      <div class="form-group">
      <label class="control-label col-sm-2" for="logofile">{{i18n.settings.choosePicture}}</label>
        <div class="col-sm-10">
          <input type="file" name="logo" accept="image/* " size="50" id="logofile" />
         </div>
      </div>


      <div class="form-group">
        <div class="col-sm-offset-2 col-sm-10">
          <button class="btn btn-inverse" name="save" value="1" type="submit" style="margin-right: 20px">{{i18n.settings.saveLogo}}</button>
          {{#if tournament.settings.hasLogo}}
            <button class="btn btn-danger" name="delete" value="1" type="submit" style="margin-right: 20px">{{i18n.settings.deleteLogo}}</button>
          {{/if}}
        </div>
      </div>
    </form>
  </fieldset>
  </div>

  </div>
  <div class="col-md-6">
  <div class="dashboardBox">
    <fieldset>
      <legend>{{i18n.settings.publicName}}</legend>
        {{#info-hint}}
          {{i18n.settings.publicNameInfo}}<br />{{i18n.settings.publicNameExample}}
          <br /> <br />
          {{i18n.settings.publicNameRestriction}}
          <ul>
            <li>{{i18n.settings.publicNameRestriction1}}</li>
            <li>{{i18n.settings.publicNameRestriction2}}</li>
            <li>{{i18n.settings.publicNameRestriction3}}</li>
          </ul>
        {{/info-hint}}
        <br />

        <form id="public-name-form" class="form-horizontal">
          {{#form-group label='Name' name="publicName"}}
            {{input value=tournament.publicName name="publicName" class='form-control publicName' placeholder=i18n.settings.publicName}}
          {{/form-group}}
          {{save-button label=i18n.save}}
        </form>
    </fieldset>
  </div>
  </div>
  </div>
"""


App.SettingsView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.settings

  actions:
    openSelectionPopup: ->
      App.ColorSelectionPopup.create
        onSelection: @fillColors
    handleFileSelect: (evt) ->
      files = evt.target.files
      for f in files
        if !f.type.match('image.*') then continue
        reader = new FileReader()
        reader.onload = (theFile) ->
          logo = $('#logo')
          logocontainer = $('#logocontainer')
          logo.setAttribute("src", e.target.result)
          logocontainer.setAttribute("style", "")
        reader.readAsDataURL(f)

  # document.getElementById('logofile').addEventListener('change', handleFileSelect, false);

  didInsertElement: ->
    @_super()
    new Save
      url: @get 'controller.publicNameUrl'
      form: @$ '#public-name-form'
      onSave: ->
        window.location.href = '/' + App.tournament.publicName + '/settings'

  fillColors: (colorTheme) =>
    console.debug "fill"
    for key, value of colorTheme
      if key is "name" then continue
      $("input[name='#{key}']").val value
    $("input[name='content']").closest("form").submit()


