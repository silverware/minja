Chat.ChanController = Ember.ObjectController.extend
  title: ""
  actions:
    part: ->
      @get("model").part()
    showUserInfo: (username) ->
      Chat.User.find username, (user) =>
        @get("model").addMessage
          type: "user"
          user: user
