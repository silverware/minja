App.Router.map ->
  @route 'dashboard', {path: '/'}
  @route 'info'
  @route 'participants'
  @route 'bracket'
  @route 'settings'
  @route 'chat'

App.Router.reopen
  location: 'history'
  init: ->
   ## set rootURL using regex to extract appropriate
   ## rootURL based on current window location
   @set('rootURL', window.location.pathname.match('(/[^/]*)')[0])
   @_super()
