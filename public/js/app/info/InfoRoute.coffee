App.InfoRoute = Ember.Route.extend
  beforeModel: ->
    if App.tournament.info.get('isEmpty') and App.tournament.get('isOwner')
      @transitionTo 'info.edit'

# App.InfoEditRoute = Ember.Route.extend
#   renderTemplate: ->
#     @render 'infoEdit'


