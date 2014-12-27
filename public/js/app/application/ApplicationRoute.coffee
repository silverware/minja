App.ApplicationRoute = Ember.Route.extend
  openDetailViews: []
  currentPathDidChange: (->
    console.debug 'path changed'
    console.debug 'remove detailviews'
  ).observes('currentPath')
  
  actions:
    openDetailView: (detailView, obj) ->
      position = @openDetailViews.get('length') + 1
      currentView = @openDetailViews.get('lastObject')
      @getContainer().hide()
      $(".navbar-static-top").addClass "visible-lg"
      @openDetailViews.pushObject detailView

      if currentView
        @controllerFor(currentView).set 'hide', true
      for key, value of obj
        @controllerFor(detailView).set key, value

      return this.render detailView,
        into: 'application'
        outlet: 'detailView' + position

    closeDetailView: ->
      console.debug 'cloooooooooooooose'
      position = @openDetailViews.get('length')
      @openDetailViews.popObject()
      if position is 1
        @getContainer().show()
        $(".navbar-static-top").removeClass "visible-lg"
      return @disconnectOutlet
        outlet: 'detailView' + position,
        parentView: 'application'

  getContainer: ->
    if $(".tournament").exists()
      return $(".tournament")
    if $("#players-container").exists()
      return $("#players-container")
    throw 'no container found'
