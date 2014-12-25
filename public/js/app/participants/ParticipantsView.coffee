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
        {{#if editable}}
          &nbsp;&nbsp;<i class="fa fa-times-circle" rel="tooltip" {{action "removeAttribute" attribute target="App.tournament.participants"}}></i>
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
        {{#if editable}}
          {{view Em.TextField valueBinding="member.name" classNames="form-control required l" placeholder="Name"}}
        {{else}}
          {{member.name}}
        {{/if}}
      </td>
      {{#each attribute in App.tournament.participants.attributes}}
        {{#view view.MemberValueView memberBinding="member.attributes" attributeBinding="attribute"}}
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
              {{view App.TypeaheadTextField classNames="m form-control" nameBinding="attribute.id" valueBinding="view.memberValue"}}
            {{else}}
              {{view.memberValue}}
            {{/if}}
          {{/if}}
        {{/view}}
      {{/each}}

      <td width="50px">
        {{#unless editable}}
          {{#if member.isPartaking}}
            <button class="btn btn-inverse" rel="tooltip" title="Info" {{action "openPlayerView" member target="view"}} type="button">
              <i class="fa fa-info"></i>
            </button>
          {{/if}}
        {{/unless}}
        {{#if editable}}
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

<div style="text-align: right"><em>{{App.tournament.participants.players.length}} {{App.i18n.members.navName}}</em></div>
</div>
"""

App.ParticipantsView = Em.View.extend

  data: ->
    data =
      members: App.Serializer.emberObjArrToJsonDataArr App.tournament.participants.players
      membersAttributes: App.Serializer.emberObjArrToJsonDataArr App.tournament.participants.attributes

  addMember: ->
    App.tournament.participants.createPlayer()

  addAttribute: ->
    App.tournament.participants.createAttribute
      name: $("#inputname").val()
      type: $("#inputtyp").val()
      isPrivate: $("#inputprivate").val()

  showAttributePopup: ->
    App.Popup.show
      title: @i18n.addAttribute
      actions: [{closePopup: true, label: @i18n.addAttribute, action: => @addAttribute()}]
      bodyUrl: "/tournament/members/attribute_popup"
      afterRendering: ($popup) ->
        $popup.find("form").submit (event) ->
          event.preventDefault()

  addNoItemsRow: (->
    # if App.PlayerPool.get('sortedPlayers').length == 0
    #   @$('table').after('<p>asdlfkj</p>')
  
  ).observes('App.tournament.participants.sortedPlayers')

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

