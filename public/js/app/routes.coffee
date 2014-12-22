Chat.Router.map ->
  @route 'info'
  @route 'participants'
  @route 'bracket'
  @route 'settings'
  @route 'chat'

Chat.Router.reopen
  location: 'history'
