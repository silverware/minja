App.templates.infoEdit = """
<div class="container container-normal">
  {{edit-link editable='false' route="info"}} 
  <h1>{{i18n.info.header}}</h1>
  <form class="form-horizontal">
    <fieldset>
      <legend>{{i18n.info.basicData}}</legend>
        {{#form-group label=i18n.tournamentName name="name" formControl="col-md-4"}}
          {{input value=tournament.info.name name="name" class="form-control"}}
        {{/form-group}}
        <div class="form-group">
          <label class="col-sm-2 control-label" for="inputdescription">
            {{i18n.info.description}}<br />
            <a href="http://daringfireball.net/projects/markdown/syntax" target="_blank">Markdown</a><br />
            <button class="btn btn-inverse" style="margin-top: 20px" {{action 'openPreview'}}>{{i18n.info.preview}}</button>
          </label>
          <div class="col-sm-10">
            {{textarea value=tournament.info.description name="description" class="form-control"}}
          </div>
        </div>
        {{#form-group label=i18n.info.venue name="venue" formControl="col-md-4"}}
          {{input value=tournament.info.venue name="venue" class="form-control"}}
        {{/form-group}}
      <div class="form-group">
        <label class="control-label col-sm-2">{{i18n.info.startDate}}</label>
        <div class="col-sm-10 col-md-8 inline-form-groups">
          {{date-time isDate=true name='startDate' value=info.startDate}}
          {{date-time isTime=true name='startTime' value=info.startTime}}
          <span {{bind-attr class=':btn :btn-link hasStopDate:hide'}} {{action 'showStopDate'}}>{{i18n.info.stopTimeKnown}}</span>
        </div>
        </div>
        {{#if hasStopDate}}
          <div class="form-group">
            <label class="control-label col-sm-2">{{i18n.info.stopDate}}</label>
            <div class="col-sm-10 col-md-8 inline-form-groups">
              {{date-time isDate=true name='stopDate' value=info.stopDate}}
              {{date-time isTime=true name='stopTime' value=info.stopTime}}
              <span class='btn btn-link' {{action 'hideStopDate'}}>{{i18n.info.deleteStopTime}}</span>
            </div>
          </div>
        {{/if}}
      <fieldset>
        <legend>{{i18n.contact}}</legend>
        {{#form-group label=i18n.info.host name="host" formControl="col-md-4"}}
          {{input value=tournament.info.host name="host" class="form-control"}}
        {{/form-group}}
        {{#form-group label="E-Mail" name="hostMail" formControl="col-md-4"}}
          {{input value=tournament.info.hostMail name="hostMail" class="form-control email"}}
        {{/form-group}}
      </fieldset>

      {{save-button label=i18n.save}}

  </form>
</div>
"""

App.InfoEditView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.infoEdit

  didInsertElement: ->
    @_super()
    console.debug "insert info edit"
    new Save
      form: @$('form')
      tournamentId: App.tournament.identifier
