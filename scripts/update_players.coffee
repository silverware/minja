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
# data = {info: {name: "Paule"}}
# dao.find  "ea53c3954a7bfd802b348288ab00177b", (result) ->
#   console.log result

dao.findAllTournamentIdentifiers (result) ->
  for r in result
    do (r)->
      dao.findTournamentByIdentifier r.id, (tournament) ->
        members = transform tournament
        # console.log tournament._id
        # console.log tournament
        dao.merge r.id, {members: members}, (result, err) ->
          console.log err

