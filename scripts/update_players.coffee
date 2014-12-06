dao = require "../app/daos/tournamentDao"

transform = (t) ->
  t.info.name = "Huhu"
  t


dao.findAllTournamentIdentifiers (result) ->
  result.forEach (id) ->
    dao.findTournamentByIdentifier id, (tournament) ->
      tournament = transform tournament
      dao.merge tournament._id, tournament, (result) ->
        console.log result

