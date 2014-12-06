dao = require "../app/daos/tournamentDao"
_ = require "Underscore"

extractPlayers = (t) ->
  players = []
  if t.tree
    for round in t.tree.rounds
      for item in round.items
        for player in item.players
          if not _.contains(players, player) and player.isPlayer
            players.push player

  if t.members?.members?
    members = t.members.members
    for member in members
      if not _.contains players.map((p) -> p.name), member.name
        players.push member
  players

transform = (t) ->
  players = extractPlayers(t)
  members =
    members: players
    membersAttributes: t.members?.membersAttributes

dao.findAllTournamentIdentifiers (result) ->
  result.forEach (id) ->
    dao.findTournamentByIdentifier id, (tournament) ->
      members = transform tournament
      console.log tournament._id
      console.log tournament
      dao.merge tournament._id, members: members, (result, err) ->
        console.log err

