App.templates.participants = """
<div class="container container-normal" id="players-container">
  <h1>{{App.i18n.members.navName}}
  <% if @tournament.isOwner: %>
    <%= @headerAction @i18n.edit, "participants/edit", "edit" %>
  <% end %>
  {{edit-link}}
  </h1>
<table class="table table-striped">
  <thead>
    <th width="25px"></th>
    <th>Name</th>
    {{#each attribute in App.tournament.participants.attributes}}
      <th>
        {{attribute.name}}
        {{#if App.editable}}
          &nbsp;&nbsp;<i class="fa fa-times-circle" rel="tooltip" {{action "removeAttribute" attribute target="App.Tournament.Participants"}}></i>
        {{/if}}
      </th>
    {{/each}}
    <th></th>
  </thead>
  {{#each member in App.tournament.participants.sortedPlayers}}
    <tr>
      <td style="height: 39px;">
        {{#if member.isPartaking}}
          <i title="{{unbound App.i18n.playerDoPartipate}}" class="fa fa-fw fa-sitemap fa-rotate-180"></i>
        {{/if}}
      </td>
      <td style="height: 39px;">
        {{#if App.editable}}
          {{view Em.TextField valueBinding="member.name" classNames="form-control required l" placeholder="Name"}}
        {{else}}
          {{member.name}}
        {{/if}}
      </td>
      {{#each attribute in App.Tournament.Participants.attributes}}
        {{#view MembersTable.MemberValueView memberBinding="member.attributes" attributeBinding="attribute"}}
          {{#if attribute.isCheckbox}}
            {{#if App.editable}}
              {{view Ember.Checkbox checkedBinding="view.memberValue" editableBinding="MembersTable.editable"}}
            {{else}}
              {{#if view.memberValue}}
                <i class="fa fa-check" />
              {{/if}}
            {{/if}}
          {{/if}}
          {{#if attribute.isTextfield}}
            {{#if App.editable}}
              {{view view.TypeaheadTextField classNames="m form-control" nameBinding="attribute.id" valueBinding="view.memberValue"}}
            {{else}}
              {{view.memberValue}}
            {{/if}}
          {{/if}}
        {{/view}}
      {{/each}}

      <td width="50px">
        {{#unless App.editable}}
          {{#if member.isPartaking}}
            <button class="btn btn-inverse" rel="tooltip" title="Info" {{action "openPlayerView" member target="view"}} type="button">
              <i class="fa fa-info"></i>
            </button>
          {{/if}}
        {{/unless}}
        {{#if App.editable}}
          {{#unless member.isPartaking}}
            <button class="btn btn-inverse" rel="tooltip" title="Delete" {{action "remove" member target="App.Tournament.Participants"}} type="button">
              <i class="fa fa-times"></i>
            </button>
          {{/unless}}
        {{/if}}
      </td>
    </tr>
  {{/each}}
</table>

<div style="text-align: right"><em>{{App.Tournament.Participants.players.length}} {{App.i18n.members.navName}}</em></div>
</div>
"""

App.ParticipantsView = Em.View.extend

  data: ->
    data =
      members: Serializer.emberObjArrToJsonDataArr App.Tournament.Participants.players
      membersAttributes: Serializer.emberObjArrToJsonDataArr App.Tournament.Participants.attributes

  addMember: ->
    App.Tournament.Participants.createPlayer()

  addAttribute: ->
    App.Tournament.Participants.createAttribute
      name: $("#inputname").val()
      type: $("#inputtyp").val()
      isPrivate: $("#inputprivate").val()

  showAttributePopup: ->
    Popup.show
      title: @i18n.addAttribute
      actions: [{closePopup: true, label: @i18n.addAttribute, action: => @addAttribute()}]
      bodyUrl: "/tournament/members/attribute_popup"
      afterRendering: ($popup) ->
        $popup.find("form").submit (event) ->
          event.preventDefault()

  addNoItemsRow: (->
    # if App.PlayerPool.get('sortedPlayers').length == 0
    #   @$('table').after('<p>asdlfkj</p>')
  
  ).observes('App.Tournament.Participants.sortedPlayers')

  openPlayerView: (player) ->
    App.PlayerDetailView.create
      player: player


  # ------------------------ VIEWS ----------------------------#

  template: Ember.Handlebars.compile App.templates.participants
  didInsertElement: ->
    @$("[rel='tooltip']").tooltip()

  MemberValueView: Ember.View.extend
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

