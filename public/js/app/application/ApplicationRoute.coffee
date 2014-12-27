App.ApplicationRoute = Ember.Route.extend
  actions:
    openDetailView: (detailView, obj) ->
      for key, value of obj
        @controllerFor(detailView).set key, value
      console.debug @controllerFor detailView
      return this.render detailView,
        into: 'application'
        outlet: 'detailView'
