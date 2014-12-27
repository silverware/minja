App.ApplicationRoute = Ember.Route.extend
  openDetailViews: []
  
  actions:
    openDetailView: (detailView, obj) ->
      position = @openDetailViews.get('length') + 1
      currentView = @openDetailViews.get('lastObject')
      if currentView
        @controllerFor(currentView).set 'hide', true
      for key, value of obj
        @controllerFor(detailView).set key, value
      console.debug @controllerFor detailView
      return this.render detailView,
        into: 'application'
        outlet: 'detailView' + position
