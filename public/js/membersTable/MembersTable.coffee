define [
  "utils/DynamicTextField"
  "utils/TypeaheadTextField"
  "utils/EmberSerializer"
  "utils/Popup"
  "text!./members_table_template.hbs"
], (DynamicTextField, TypeaheadTextField, Serializer, Popup, template) ->

  Em.View.extend
    DynamicTextField: DynamicTextField

    init: ->
      @_super()
      @appendTo("#membersTable")

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

    template: Ember.Handlebars.compile template
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
      TypeaheadTextField: TypeaheadTextField

      memberValue: ((key, value) ->
        # GETTER
        if arguments.length == 1
          return @get("member")[@get("attribute").id]
        # SETTER
        @get("member").set @get("attribute").id, value
      ).property("member", "attribute.name")

