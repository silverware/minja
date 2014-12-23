App.templates.participants = """
<table class="table table-striped">
  <thead>
    <th width="25px"></th>
    <th>Name</th>
    {{#each attribute in App.PlayerPool.attributes}}
      <th>
        {{attribute.name}}
        {{#if App.editable}}
          &nbsp;&nbsp;<i class="fa fa-times-circle" rel="tooltip" {{action "removeAttribute" attribute target="App.PlayerPool"}}></i>
        {{/if}}
      </th>
    {{/each}}
    <th></th>
  </thead>
  {{#each member in App.PlayerPool.sortedPlayers}}
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
      {{#each attribute in App.PlayerPool.attributes}}
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
            <button class="btn btn-inverse" rel="tooltip" title="Delete" {{action "remove" member target="App.PlayerPool"}} type="button">
              <i class="fa fa-times"></i>
            </button>
          {{/unless}}
        {{/if}}
      </td>
    </tr>
  {{/each}}
</table>

<div style="text-align: right"><em>{{App.PlayerPool.players.length}} {{MembersTable.i18n.navName}}</em></div>
"""

App.ParticipantsView = Em.View.extend

  data: ->
    data =
      members: Serializer.emberObjArrToJsonDataArr App.PlayerPool.players
      membersAttributes: Serializer.emberObjArrToJsonDataArr App.PlayerPool.attributes

  addMember: ->
    App.PlayerPool.createPlayer()

  addAttribute: ->
    App.PlayerPool.createAttribute
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
  
  ).observes('App.PlayerPool.sortedPlayers')

  openPlayerView: (player) ->
    App.PlayerDetailView.create
      player: player


  # ------------------------ VIEWS ----------------------------#

  template: Ember.Handlebars.compile App.templates.participants
  didInsertElement: ->
    @$().hide()
    $('.spinner-wrapper').fadeOut 'fast', =>
      @$().fadeIn 1000
    @$("[rel='tooltip']").tooltip()
    App.Observer.snapshot()


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

