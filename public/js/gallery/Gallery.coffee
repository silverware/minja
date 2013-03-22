define [
  "utils/EmberSerializer"
  "text!./gallery_template.hbs"
  "gallery/GalleryPopup"
], (Serializer, template, Popup) ->

  MAX_IMAGE_COUNT = 20

  Em.Application.extend

    images: []

    init: ->
      @_super()
      if @imagesData?
        for id, data of @imagesData
          @images.pushObject @Image.create
            id: id
            title: data.title
            url: "/#{@tournamentId}/image/#{id}"

      @view.appendTo("#gallery")

    data: ->
      formData = new FormData()
      formData.append "empty", "" if @images.get("length") == 0
      for image in @images
        if image.file
          formData.append image.id, image.file
        formData.append "#{image.id}[title]", image.title
      formData

    addImage: ->
      @images.pushObject @Image.create()

    loadImage: ->
      fileInput = $("#file")
      fileInput.click()

    Image: Em.Object.extend
      title: ""
      url: ""

      init: ->
        @_super()
        if not @id
          @id = UniqueId.create()

      show: ->
        Popup.show @

      remove: ->
        Gallery.images.removeObject @


    view: Ember.View.create
      template: Ember.Handlebars.compile template
      tagName: 'ul'
      classNames: ['thumbnails']

      didInsertElement: ->
        $("#file").live 'change', ->
          for file in @files
            url = URL.createObjectURL(file)
            if Gallery.images.get("length") < MAX_IMAGE_COUNT
              Gallery.images.pushObject Gallery.Image.create({url: url, file: file})

