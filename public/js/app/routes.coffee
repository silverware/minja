App.Router.map ->
  @route 'dashboard', {path: '/'}
  @route 'info'
  @route 'info.edit', {path: "/info/edit"}
  @resource 'participants', {path: '/participants'}, ->
    @route 'edit'
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

