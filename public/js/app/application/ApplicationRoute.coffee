App.ApplicationRoute = Ember.Route.extend
  openDetailViews: []
  currentPathDidChange: (->
    console.debug 'path changed'
    console.debug 'remove detailviews'
  ).observes('currentPath')
  
  actions:
    willTransition: ->
      @send 'closeDetailView' for [1..@openDetailViews.get('length')]
    openDetailView: (detailView, obj) ->
      position = @openDetailViews.get('length') + 1
      currentView = @openDetailViews.get('lastObject')
      @getContainer().hide()
      $(".navbar-static-top").addClass "visible-lg"
      @openDetailViews.pushObject detailView
      App.BracketLineDrawer.hide()

      if currentView
        @controllerFor(currentView).set 'isHidden', true
      for key, value of obj
        @controllerFor(detailView).set key, value

      return this.render detailView,
        into: 'application'
        outlet: 'detailView' + position

    closeDetailView: ->
      position = @openDetailViews.get('length')
      if position is 0 then return
      @openDetailViews.popObject()
      if position is 1
        @getContainer().show()
        $(".navbar-static-top").removeClass "visible-lg"
        App.BracketLineDrawer.show()
      else
        @controllerFor(@openDetailViews.get('lastObject')).set 'isHidden', false
      return @disconnectOutlet
        outlet: 'detailView' + position,
        parentView: 'application'

  getContainer: ->
    if $(".tournament").exists()
      return $(".tournament")
    if $("#players-container").exists()
      return $("#players-container")
    throw 'no container found'
