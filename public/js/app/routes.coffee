App.Router.map ->

  @resource 'dashboard', {path: '/:tid'}, ->
    @route 'info'
    @route 'participants'
    @route 'bracket'
    @route 'settings'
    @route 'chat'

App.Router.reopen
  location: 'history'
