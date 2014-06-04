define [
  "utils/DynamicTextField"
  "utils/TypeaheadTextField"
  "utils/EmberSerializer"
  "utils/Popup"
  "text!./members_table_template.hbs"
], (DynamicTextField, TypeaheadTextField, Serializer, Popup, template) ->

  Em.Application.extend

    members: []
    attributes: []

    init: ->
      @_super()
      if @membersData?
        for member in @membersData.members
          @members.pushObject @Member.create(member)

        if @membersData.membersAttributes?
          for attribute in @membersData.membersAttributes
            @attributes.pushObject @Attribute.create(attribute)

      @view.appendTo("#membersTable")

    data: ->
      data =
        members: Serializer.emberObjArrToJsonDataArr @members
        membersAttributes: Serializer.emberObjArrToJsonDataArr @attributes

    addMember: ->
      @members.pushObject @Member.create()


    addAttribute: ->
      @attributes.pushObject @Attribute.create
        name: $("#inputname").val()
        type: $("#inputtyp").val()

    showAttributePopup: ->
      Popup.show
        title: @i18n.addAttribute
        actions: [{closePopup: true, label: @i18n.addAttribute, action: => @addAttribute()}]
        bodyUrl: "/tournament/members/attribute_popup"



    # ------------------------ MODELS ----------------------------#

    Member: Em.Object.extend
      name: ""
      remove: ->
        MembersTable.members.removeObject @


    Attribute: Em.Object.extend
      name: ""
      type: "textfield"
      id: ""

      init: ->
        @_super()
        @id = UniqueId.create() if not @id

      isCheckbox: (->
        @get("type") == "checkbox"
      ).property("type")
      isTextfield: (->
        @get("type") == "textfield"
      ).property("type")
      remove: ->
        MembersTable.attributes.removeObject @


    # ------------------------ VIEWS ----------------------------#

    view: Ember.View.create
      DynamicTextField: DynamicTextField
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
        else
          @get("member").set @get("attribute").id, value
      ).property("member", "attribute.name")

