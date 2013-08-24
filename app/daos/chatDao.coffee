class ChatDao extends require('./daoBase')

  authorTypes:
    leader: "leader"
    guest: "guest"

  constructor: ->
    super 'chat'

  initialize: ->
    @db.save '_design/messages',
      views:
        byTournament:
          map: 'function(doc) {emit(doc.tournament_id, doc)}'

  findMessagesByTournamentId: (tournamentId, i18n, paginator, callback) ->
    @db.view "messages/byTournament", key: tournamentId, descending: true, skip: paginator.first, limit: paginator.limit, (err, messages) =>
      if err then return callback []
      for message in messages
        m = message.value
        switch m.authorType
          when @authorTypes.leader then m.author = i18n.tournamentLeader
          when @authorTypes.guest then m.author += " [#{i18n.guest}]"
          else
        m.created_at_humanized = i18n.date m.created_at
      callback messages

module.exports = new ChatDao()
