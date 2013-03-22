define ["utils/Popup"], (Popup) ->

  galleryPopupTemplate = """
    <div id="myCarousel" class="carousel slide">
      <div class="carousel-inner"></div>
      <a class="carousel-control left" href="#myCarousel" data-slide="prev">&lsaquo;</a>
      <a class="carousel-control right" href="#myCarousel" data-slide="next">&rsaquo;</a>
    </div>
  """

  GalleryPopup = Em.View.create(
    template: Ember.Handlebars.compile galleryPopupTemplate
    classNames: ["hide"]

    show: (activeImage) ->
      @$().show()
      Popup.show
        title: "Bilder"
        bodyContent: @$()[0]
      @$('.carousel-inner').empty()
      for image in Gallery.images
        cssClass = "item"
        cssClass += " active" if image is activeImage
        @$('.carousel-inner').append """
          <div class="#{cssClass}"><img src="#{image.url}" width="700px"/>
              <div class="carousel-caption">
                <h4>#{image.title}</h4>
              </div>
            </div>
        """
      @$('.carousel').carousel()

  ).appendTo("body")