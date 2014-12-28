App.templates.participants = """
<div class="container container-normal" id="players-container">
  {{#if editable}}
    {{edit-link editable=editable route="participants"}} 
      <a style="margin-right: 10px" class="float-right" href="#">
        <button type="button" class="btn btn-inverse" {{action 'showAttributePopup' target="view"}}><i class="fa fa-plus"></i>{{i18n.members.attribute}}</button>
      </a>
      <a style="float: right; margin-right: 10px" href="#" {{action "createPlayer" target="participants"}}>
        <button type="button" class="btn btn-inverse"><i class="fa fa-plus"></i>{{i18n.members.member}}</button>
    </a>
  {{else}}
    {{edit-link editable=editable route="participants.edit"}} 
  {{/if}}
  <h1>{{i18n.members.navName}}</h1>
<table class="table table-striped">
  <thead>
    <th width="25px"></th>
    <th>Name</th>
    {{#each attribute in participants.attributes}}
      <th>
        {{attribute.name}}
        {{#if editable}}
          &nbsp;&nbsp;<i class="fa fa-times-circle" rel="tooltip" {{action "removeAttribute" attribute target="participants"}}></i>
        {{/if}}
      </th>
    {{/each}}
    <th></th>
  </thead>
  <tbody>
  {{#each member in participants.sortedPlayers}}
    <tr>
      <td style="height: 39px;">
        {{#if member.isPartaking}}
          <i title="{{unbound i18n.playerDoPartipate}}" class="fa fa-fw fa-sitemap fa-rotate-180"></i>
        {{/if}}
      </td>
      <td style="height: 39px;">
        {{#if editable}}
          {{input value=member.name classNames="form-control required l" placeholder="Name"}}
        {{else}}
          {{member.name}}
        {{/if}}
      </td>
      {{#each attribute in participants.attributes}}
        {{#view 'memberValue' memberBinding="member.attributes" attributeBinding="attribute"}}
          {{#if attribute.isCheckbox}}
            {{#if editable}}
              {{view Ember.Checkbox checkedBinding="view.memberValue"}}
            {{else}}
              {{#if view.memberValue}}
                <i class="fa fa-check" />
              {{/if}}
            {{/if}}
          {{/if}}
          {{#if attribute.isTextfield}}
            {{#if editable}}
              {{view 'typeAheadTextField' classNames="m form-control" nameBinding="attribute.id" valueBinding="view.memberValue"}}
            {{else}}
              {{view.memberValue}}
            {{/if}}
          {{/if}}
        {{/view}}
      {{/each}}

      <td width="50px">
        {{#unless editable}}
          {{#if member.isPartaking}}
            <button class="btn btn-inverse" rel="tooltip" title="Info" {{action "openPlayerView" member}} type="button">
              <i class="fa fa-info"></i>
            </button>
          {{/if}}
        {{/unless}}
        {{#if editable}}
          {{#unless member.isPartaking}}
            <button class="btn btn-inverse" rel="tooltip" title="Delete" {{action "remove" member target="participants"}} type="button">
              <i class="fa fa-times"></i>
            </button>
          {{/unless}}
        {{/if}}
      </td>
    </tr>
  {{/each}}
  </tbody>
</table>

<div style="text-align: right"><em>{{participants.players.length}} {{i18n.members.navName}}</em></div>
  <form class="form-horizontal" method="post" id="participants-form">
  {{#if editable}}
      {{save-button label=i18n.save}}
  {{/if}}
  </form>
</div>
"""

App.ParticipantsView = Em.View.extend

  data: ->
    data =
      members: App.Serializer.emberObjArrToJsonDataArr App.tournament.participants.players
      membersAttributes: App.Serializer.emberObjArrToJsonDataArr App.tournament.participants.attributes

  actions:
    showAttributePopup: ->
      App.Popup.show
        title: App.i18n.members.addAttribute
        actions: [{closePopup: true, label: App.i18n.members.addAttribute, action: => @addAttribute()}]
        bodyUrl: "/tournament/members/attribute_popup"
        afterRendering: ($popup) ->
          $popup.find("form").submit (event) ->
            event.preventDefault()

  addAttribute: ->
    App.tournament.participants.createAttribute
      name: $("#inputname").val()
      type: $("#inputtyp").val()
      isPrivate: $("#inputprivate").val()

  addNoItemsRow: (->
    # if App.PlayerPool.get('sortedPlayers').length == 0
    #   @$('table').after('<p>asdlfkj</p>')
  
  ).observes('App.tournament.participants.sortedPlayers')


  # ------------------------ VIEWS ----------------------------#

  template: Ember.Handlebars.compile App.templates.participants
  didInsertElement: ->
    @$("[rel='tooltip']").tooltip()

    console.debug 'init save'
    new Save
      url: @get 'controller.participantsUrl'
      form: @$ '#participants-form'
      data: @data

App.MemberValueView = Ember.View.extend
  tagName: 'td'
  member: null
  attribute: null

  memberValue: ((key, value) ->
    # GETTER
    if arguments.length == 1
      return @get("member")[@get("attribute").id]
    # SETTER
    @get("member").set @get("attribute").id, value
  ).property("member", "attribute.name")

