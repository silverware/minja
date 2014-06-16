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
        members: Serializer.emberObjArrToJsonDataArr @members
        membersAttributes: Serializer.emberObjArrToJsonDataArr @attributes

    addMember: ->
      App.PlayerPool.createNewPlayer()

    addAttribute: ->
      App.PlayerPool.createNewPlayer()
      @attributes.pushObject @Attribute.create
        name: $("#inputname").val()
        type: $("#inputtyp").val()

    showAttributePopup: ->
      Popup.show
        title: @i18n.addAttribute
        actions: [{closePopup: true, label: @i18n.addAttribute, action: => @addAttribute()}]
        bodyUrl: "/tournament/members/attribute_popup"
        afterRendering: ($popup) ->
          $popup.find("form").submit (event) ->
            event.preventDefault()


    # ------------------------ VIEWS ----------------------------#

    template: Ember.Handlebars.compile template
    didInsertElement: ->
      @$().hide().fadeIn 1000
      @$("[rel='tooltip']").tooltip()


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

