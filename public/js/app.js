(function() {
  var _this = this;

  window.App = Em.Application.create({
    LOG_TRANSITIONS: true,
    rootElement: '#appRoot',
    LOG_TRANSITIONS_INTERNAL: true,
    Tournament: Ember.Object.create({
      Info: null,
      Settings: null,
      Bracket: null,
      Participants: null
    }),
    openDetailViews: [],
    i18n: {},
    templates: {},
    persist: function() {
      return App.PersistanceManager.persist();
    },
    transitionTo: function(route) {
      return App.Router.router.transitionTo(route);
    }
  });

  App.init = function(_arg) {
    var colors, editable, i18n, isOwner, sport, tournament;
    isOwner = _arg.isOwner, editable = _arg.editable, i18n = _arg.i18n, sport = _arg.sport, colors = _arg.colors, tournament = _arg.tournament;
    App.editable = editable || false;
    App.isOwner = isOwner || false;
    App.i18n = i18n;
    App.sport = sport;
    App.colors = colors;
    if (App.sport) {
      App.Tournament.Bracket.set("winPoints", App.sport.pointsPerWin);
      App.Tournament.Bracket.set("drawPoints", App.sport.pointsPerDraw);
      App.Tournament.Bracket.set("qualifierModus", App.sport.qualifierModus);
    }
    if (tournament != null ? tournament.members : void 0) {
      App.Tournament.Participants.initPlayers(tournament.members);
    }
    if (tournament != null ? tournament.tree : void 0) {
      App.PersistanceManager.buildBracket(tournament.tree);
    }
    App.Tournament.set("Info", tournament.info);
    return App.Tournament.set("Settings", tournament.settings);
  };

  $.fn.createTree = function() {
    var view;
    view = App.TournamentView.create();
    setTimeout((function() {
      $("#settings .close").click();
      return $("#tournamentAddRemoveActions").click();
    }), 50);
    view.appendTo(this);
    return App.Observer.snapshot();
  };

  App.Tournament.Bracket = Em.ArrayController.extend({
    winPoints: 3,
    drawPoints: 1,
    qualifierModus: "aggregate",
    timePerGame: 20,
    gamesParallel: 1,
    info: {},
    settings: {},
    gameAttributes: [],
    content: [],
    games: (function() {
      return this.reduce(function(tournamentGames, round) {
        return tournamentGames = tournamentGames.concat(round.get("games"));
      }, []);
    }).property('@each.games'),
    getGamesByPlayer: function(player) {
      return this.reduce(function(games, round) {
        var roundGames;
        roundGames = round.get("games").filter(function(game) {
          return game.get("players").contains(player);
        });
        if (roundGames.length > 0) {
          games = games.concat({
            round: round,
            games: roundGames
          });
        }
        return games;
      }, []);
    },
    getPlayers: function() {
      return _.chain(this.map(function(round) {
        return round.getPlayers();
      })).flatten().uniq().value();
    },
    addGroupRound: function() {
      if (this.addRound()) {
        $("#settings .close").click();
        return this.pushObject(App.GroupRound.create({
          name: App.i18n.groupStage,
          _previousRound: this.lastRound()
        }));
      }
    },
    addKoRound: function() {
      if (this.addRound()) {
        $("#settings .close").click();
        return this.pushObject(App.KoRound.create({
          name: App.i18n.koRound,
          _previousRound: this.lastRound()
        }));
      }
    },
    addRound: function() {
      var _ref;
      if (this.content.length === 0 || this.lastRound().validate()) {
        if ((_ref = this.lastRound()) != null) {
          _ref.set("editable", false);
        }
        return true;
      } else {
        App.Popup.showInfo({
          title: "",
          bodyContent: App.i18n.bracket.lastRoundNotValid
        });
        return false;
      }
    },
    lastRound: function() {
      return _.last(this.content);
    },
    removeLastRound: function() {
      var _ref;
      this.removeObject(this.lastRound());
      return (_ref = this.lastRound()) != null ? _ref.set("editable", true) : void 0;
    },
    replacePlayer: function(from, to, fromRound) {
      var isFurtherRound;
      isFurtherRound = false;
      if (from && to) {
        return this.forEach(function(round) {
          if (isFurtherRound) {
            round.items.forEach(function(roundItem) {
              return roundItem.players.forEach(function(player) {
                var i;
                if (player === from) {
                  i = roundItem.players.indexOf(player);
                  roundItem.players.removeObject(player);
                  return roundItem.players.insertAt(i, to);
                }
              });
            });
          }
          if (round === fromRound) {
            return isFurtherRound = true;
          }
        });
      }
    }
  });

  App.qualifierModi = {
    BEST_OF: Em.Object.create({
      id: "bestof",
      label: "Best Of X"
    }),
    AGGREGATE: Em.Object.create({
      id: "aggregate",
      label: "Aggregated"
    })
  };

  App.Tournament.Bracket = App.Tournament.Bracket.create();

  App.Round = Em.Object.extend({
    name: "",
    items: [],
    _previousRound: null,
    _editable: true,
    matchesPerGame: 1,
    games: (function() {
      return this.get("items").reduce(function(roundGames, item) {
        return roundGames.concat(item.get("games"));
      }, []);
    }).property('items.@each.games.@each'),
    matchDays: (function() {
      var games, i, matchDays, maxMatchDays, roundItem, _i, _ref, _results;
      matchDays = [];
      maxMatchDays = _.max((function() {
        var _i, _len, _ref, _results;
        _ref = this.get("items");
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          roundItem = _ref[_i];
          _results.push(roundItem.get("matchDayCount"));
        }
        return _results;
      }).call(this));
      _results = [];
      for (i = _i = 0, _ref = maxMatchDays - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        games = [];
        this.get("items").forEach(function(item) {
          if (item.get("matchDays").objectAt(i)) {
            return games.pushObject(item.get("matchDays").objectAt(i).games);
          }
        });
        games = _.flatten(_.zip.apply(null, games));
        games = games.filter(function(game) {
          return game;
        });
        _results.push(matchDays.pushObject(Em.Object.create({
          games: games,
          matchDay: i + 1
        })));
      }
      return _results;
    }).property("items.@each.matchDays"),
    init: function() {
      this._super();
      return this.set("items", []);
    },
    editable: (function(key, value) {
      if (arguments.length > 1) {
        this.set("_editable", value);
      }
      return this.get('_editable');
    }).property('_editable'),
    isEditable: (function() {
      return App.editable && this.get("editable");
    }).property("editable"),
    qualifiers: (function() {
      return this.get("items").reduce(function(qualifiers, item) {
        return qualifiers.concat(item.get("qualifiers"));
      }, []);
    }).property("items.@each.qualifiers"),
    getMembers: function() {
      if (this.get("_previousRound")) {
        return this.get("_previousRound").get("qualifiers");
      }
      if (App.initialMembers) {
        return App.initialMembers;
      }
      return null;
    },
    getFreeMembers: function() {
      var freeMembers, member, members, _i, _len;
      freeMembers = null;
      members = this.getMembers();
      if (members) {
        freeMembers = [];
        for (_i = 0, _len = members.length; _i < _len; _i++) {
          member = members[_i];
          if (this.memberNotAssigned(member)) {
            freeMembers.pushObject(member);
          }
        }
      }
      return freeMembers;
    },
    isFirstRound: function() {
      return !_this.get("_previousRound");
    },
    isLastRound: (function() {
      return App.Tournament.Bracket.lastRound() === this;
    }).property("App.Tournament.Bracket.@each"),
    validate: function() {
      return (this.getFreeMembers() === null || this.getFreeMembers().length === 0) && this.get("qualifiers").length > 1;
    },
    removeItem: function(item) {
      return this.items.removeObject(item);
    },
    memberNotAssigned: function(member) {
      var item, _i, _len, _ref;
      _ref = this.get("items");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (_.include(item.get("players"), member)) {
          return false;
        }
      }
      return true;
    },
    swapPlayers: function(player1Index, player2Index) {
      var gamePlayers1, gamePlayers2, player1, player2;
      gamePlayers1 = this.items.objectAt(player1Index[0]).players;
      gamePlayers2 = this.items.objectAt(player2Index[0]).players;
      if (gamePlayers1 === gamePlayers2 && this.isGroupRound) {
        return;
      }
      player1 = gamePlayers1.objectAt(player1Index[1]);
      player2 = gamePlayers2.objectAt(player2Index[1]);
      gamePlayers1.removeObject(player1);
      gamePlayers2.removeObject(player2);
      if (player1Index[1] < player2Index[1]) {
        gamePlayers1.insertAt(player1Index[1], player2);
        return gamePlayers2.insertAt(player2Index[1], player1);
      } else {
        gamePlayers2.insertAt(player2Index[1], player1);
        return gamePlayers1.insertAt(player1Index[1], player2);
      }
    },
    getPlayers: function() {
      return _.flatten(this.get('items').map(function(item) {
        return item.get('players');
      })).filter(function(player) {
        return player.isPlayer;
      });
    },
    shuffle: function() {
      var players;
      players = _.shuffle(_.flatten(this.get('items').map(function(item) {
        return item.get('players');
      })));
      return this.get('items').forEach(function(item) {
        var i, _i, _ref, _results;
        _results = [];
        for (i = _i = 0, _ref = item.get('players.length') - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          item.get('players').replace(i, 1, [_.last(players)]);
          _results.push(players.popObject());
        }
        return _results;
      });
    },
    koRoundsBefore: function() {
      if (!this._previousRound || !this._previousRound.isKoRound) {
        return 0;
      }
      return this._previousRound.koRoundsBefore() + 1;
    },
    /*---------------------------------------------------------------------------
      Statistics
    ---------------------------------------------------------------------------
    */

    gamesCount: (function() {
      return this.get('games.length');
    }).property('games'),
    completion: (function() {
      var completion;
      completion = 0;
      this.get("items").forEach(function(item) {
        return completion += item.get("completion");
      });
      return completion;
    }).property("items.@each.completion"),
    isNotStarted: (function() {
      return this.get('completion') === 0;
    }).property('completion'),
    completionRatio: (function() {
      return this.get("completion") / this.get("gamesCount") * 100;
    }).property("completion", "gamesCount")
  });

  App.KoRound = App.Round.extend({
    _itemLabel: "",
    isKoRound: true,
    init: function() {
      this._super();
      return this._itemLabel = App.i18n.game;
    },
    addItem: function() {
      var game, i, _i, _ref, _results;
      if (!this.get('editable')) {
        App.Popup.showInfo({
          bodyContent: App.i18n.roundItemNotAddable
        });
        return;
      }
      game = App.RoundGame.create({
        name: ("" + App.i18n.game + " ") + (this.items.get("length") + 1),
        _round: this
      });
      this.items.pushObject(game);
      _results = [];
      for (i = _i = 0; _i <= 1; i = ++_i) {
        if (((_ref = this.getFreeMembers()) != null ? _ref[0] : void 0) != null) {
          _results.push(game.players.pushObject(this.getFreeMembers()[0]));
        } else {
          _results.push(game.players.pushObject(App.Tournament.Participants.getNewPlayer({
            name: ("" + App.i18n.player + " ") + (i + 1)
          })));
        }
      }
      return _results;
    }
  });

  App.GroupRound = App.Round.extend({
    _itemLabel: "",
    isGroupRound: true,
    _letters: "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    init: function() {
      this._super();
      return this._itemLabel = App.i18n.group;
    },
    addItem: function() {
      var group, i, players, playersCount, prevGroup, prevPlayersLength, _i, _ref, _results;
      if (!this.get('editable')) {
        App.Popup.showInfo({
          bodyContent: App.i18n.roundItemNotAddable
        });
        return;
      }
      group = App.Group.create({
        name: ("" + App.i18n.group + " ") + this._letters[this.get('items.length')],
        _round: this
      });
      prevGroup = this.get('items.lastObject');
      if (prevGroup) {
        group.set("qualifierCount", prevGroup.get("qualifierCount"));
        prevPlayersLength = prevGroup.get("players.length");
      }
      playersCount = (prevPlayersLength - 1) || 3;
      this.get("items").pushObject(group);
      players = [];
      _results = [];
      for (i = _i = 0; 0 <= playersCount ? _i <= playersCount : _i >= playersCount; i = 0 <= playersCount ? ++_i : --_i) {
        if (((_ref = this.getFreeMembers()) != null ? _ref[0] : void 0) != null) {
          players.pushObject(this.getFreeMembers()[0]);
        } else {
          players.pushObject(App.Tournament.Participants.getNewPlayer({
            name: ("" + App.i18n.player + " ") + (i + 1)
          }));
        }
        _results.push(group.set('players', players));
      }
      return _results;
    }
  });

  App.RoundItem = Em.Object.extend({
    name: "",
    _round: null,
    players: [],
    games: [],
    dummies: [],
    init: function() {
      this._super();
      this.set("players", []);
      this.set("games", []);
      return this.set("dummies", []);
    },
    remove: function() {
      return this._round.removeItem(this);
    },
    replace: function(from, to) {
      return App.Tournament.Bracket.replacePlayer(from, to, this.get("_round"));
    },
    matchDays: (function() {
      var gamesPerMatchDay, matchDays, playerCount, roundItemName;
      matchDays = [];
      playerCount = this.get("players.length");
      gamesPerMatchDay = Math.floor(playerCount / 2);
      roundItemName = this.name;
      _.chain(this.get("games")).groupBy(function(item, index) {
        return Math.floor(index / gamesPerMatchDay);
      }).map(function(chunk, index) {
        var game, games, _i, _len;
        games = [];
        for (_i = 0, _len = chunk.length; _i < _len; _i++) {
          game = chunk[_i];
          game.set("_roundItemName", roundItemName);
          games.pushObject(game);
        }
        return matchDays.pushObject(Em.Object.create({
          matchDay: parseInt(index) + 1,
          games: games
        }));
      });
      return matchDays;
    }).property("games.@each"),
    matchDayCount: (function() {
      return this.get("matchDays.length");
    }).property("matchDays.@each"),
    completedGames: (function() {
      return this.games.filter(function(game) {
        return game.get("isCompleted");
      });
    }).property("games.@each.isCompleted"),
    completion: (function() {
      return this.get("completedGames.length");
    }).property("completedGames"),
    itemId: (function() {
      var itemIndex, roundIndex;
      itemIndex = this.get('_round.items').indexOf(this);
      roundIndex = App.Tournament.Bracket.indexOf(this.get('_round'));
      return roundIndex + '-' + itemIndex;
    }).property('_round.items.@each')
  });

  App.Group = App.RoundItem.extend({
    isGroup: true,
    qualifierCount: null,
    _tempQualifiers: [],
    qualifiers: (function() {
      var i, index, player, qualifiers, _i, _j, _ref, _ref1;
      qualifiers = [];
      if (!this.isCompleted()) {
        for (i = _i = 1, _ref = this.get("qualifierCount"); 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
          index = i - 1;
          if (!this.dummies[index]) {
            this.dummies[index] = App.Dummy.create();
          }
          this.dummies[index].set("name", i + ". " + this.get("name"));
          if ((this._tempQualifiers[index] != null) && !this._tempQualifiers[index].isDummy) {
            this.replace(this._tempQualifiers[index], this.dummies[index]);
          }
          qualifiers.pushObject(this.dummies[index]);
        }
      } else {
        for (i = _j = 0, _ref1 = this.get("qualifierCount") - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          player = this.get("table").objectAt(i).player;
          qualifiers.pushObject(player);
          this.replace(this.dummies[i], player);
        }
      }
      this._tempQualifiers = qualifiers;
      return qualifiers;
    }).property("qualifierCount", "games.@each.isCompleted", "name"),
    init: function() {
      this._super();
      return this.set("qualifierCount", 2);
    },
    removeLastPlayer: function() {
      var player;
      if (this.get("players.length") > 2) {
        player = this.get("players").popObject();
      }
      return this.onPlayerSizeChange();
    },
    addPlayer: function() {
      var freeMembers;
      freeMembers = this.get("_round").getFreeMembers();
      if ((freeMembers != null ? freeMembers.length : void 0) > 0) {
        this.get("players").pushObject(freeMembers[0]);
      } else {
        this.get("players").pushObject(App.Tournament.Participants.getNewPlayer({
          name: "Player"
        }));
      }
      return this.onPlayerSizeChange();
    },
    table: (function() {
      var index, p, player, players, sorted, _i, _j, _ref, _ref1;
      players = [];
      for (index = _i = 0, _ref = this.get("players.length") - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; index = 0 <= _ref ? ++_i : --_i) {
        player = this.get("players").objectAt(index);
        p = Em.Object.create({
          player: player,
          index: index
        });
        p.setProperties(this.calculateStats(player));
        players.pushObject(p);
      }
      sorted = players.sort(function(a, b) {
        var greater;
        greater = b.points - a.points;
        if (greater === 0) {
          greater = b.difference - a.difference;
          if (greater === 0) {
            greater = b.goals - a.goals;
          }
        }
        return greater;
      });
      for (index = _j = 1, _ref1 = sorted.length; 1 <= _ref1 ? _j <= _ref1 : _j >= _ref1; index = 1 <= _ref1 ? ++_j : --_j) {
        sorted[index - 1].rank = index;
        sorted[index - 1].qualified = index <= this.get("qualifierCount");
      }
      return sorted;
    }).property("players.@each", "qualifierCount", "games.@each.result1", "games.@each.result2", "App.Tournament.Bracket.winPoints", "App.Tournament.Bracket.drawPoints"),
    generateGames: (function() {
      var game, games, i, p1, p2, _i, _ref, _results;
      this.games.clear();
      games = App.RoundRobin.generateGames(this.get("players"));
      _results = [];
      for (i = _i = 1, _ref = this.get("_round.matchesPerGame"); 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        _results.push((function() {
          var _j, _len, _ref1, _results1;
          _results1 = [];
          for (_j = 0, _len = games.length; _j < _len; _j++) {
            game = games[_j];
            p1 = game[0];
            p2 = game[1];
            if (i % 2 === 0) {
              _ref1 = [p2, p1], p1 = _ref1[0], p2 = _ref1[1];
            }
            _results1.push(this.games.pushObject(App.Game.create({
              player1: p1,
              player2: p2
            })));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    }).observes("players.@each", "_round.matchesPerGame"),
    isCompleted: function() {
      return this.get("games").every(function(game) {
        return game.get("isCompleted");
      });
    },
    increaseQualifierCount: function() {
      if (this.get("players.length") > this.qualifierCount) {
        return this.set("qualifierCount", this.qualifierCount + 1);
      }
    },
    decreaseQualifierCount: function() {
      if (this.qualifierCount > 1) {
        return this.set("qualifierCount", this.qualifierCount - 1);
      }
    },
    onPlayerSizeChange: function() {
      if (this.get("players.length") < this.qualifierCount) {
        return this.set("qualifierCount", this.get('players.length'));
      }
    },
    calculateStats: function(player) {
      var stats;
      stats = {
        points: 0,
        games: 0,
        wins: 0,
        draws: 0,
        defeats: 0,
        goals: 0,
        goalsAgainst: 0,
        difference: 0
      };
      this.games.forEach(function(game) {
        var winner;
        if (!game.get("isCompleted")) {
          return;
        }
        if (player !== game.get("player1") && player !== game.get("player2")) {
          return;
        }
        stats.games += 1;
        winner = game.getWinner();
        if (player === winner) {
          stats.wins += 1;
        } else if (!winner) {
          stats.draws += 1;
        } else {
          stats.defeats += 1;
        }
        if (player === game.get("player1")) {
          stats.goals += game.get("goals1");
          stats.goalsAgainst += game.get("goals2");
          stats.points += game.getPoints(1);
        }
        if (player === game.get("player2")) {
          stats.goals += game.get("goals2");
          stats.goalsAgainst += game.get("goals1");
          return stats.points += game.getPoints(2);
        }
      });
      stats.difference = stats.goals - stats.goalsAgainst;
      return stats;
    },
    swapGames: function(gameIndex1, gameIndex2) {
      var content, fromGame, game, toGame;
      fromGame = this.games.objectAt(gameIndex1);
      toGame = this.games.objectAt(gameIndex2);
      content = this.games;
      content[gameIndex1] = toGame;
      content[gameIndex2] = fromGame;
      game = this.games.objectAt(gameIndex1);
      this.games.removeObject(game);
      return this.games.insertAt(gameIndex1, game);
    }
  });

  App.RoundGame = App.RoundItem.extend({
    isGame: true,
    player1: (function() {
      return this.get("players").objectAt(0);
    }).property("players.@each"),
    player2: (function() {
      return this.get("players").objectAt(1);
    }).property("players.@each"),
    winnerDummy: (function() {
      return this.get("dummies").objectAt(0);
    }).property("dummies.@each"),
    qualifiers: (function() {
      var winner;
      if (!this.isCompleted()) {
        this.get("winnerDummy").set("name", ("" + App.i18n.winner + " ") + this.get("name"));
        this.replace(this.get("player1"), this.get("winnerDummy"));
        this.replace(this.get("player2"), this.get("winnerDummy"));
        return this.dummies;
      } else {
        winner = this.getWinner();
        this.replace(this.get("winnerDummy"), winner);
        this.replace(this.get("player1"), winner);
        this.replace(this.get("player2"), winner);
        return [winner];
      }
    }).property("players.@each", "games.@each.result1", "games.@each.result2", "name", "App.Tournament.Bracket.qualifierModus"),
    init: function() {
      this._super();
      return this.dummies.pushObject(App.Dummy.create());
    },
    getWinner: function() {
      var goalsPlayer1, goalsPlayer2, wins1, wins2,
        _this = this;
      if (App.Tournament.Bracket.get('qualifierModus') === App.qualifierModi.AGGREGATE.id) {
        goalsPlayer1 = 0;
        goalsPlayer2 = 0;
        this.games.forEach(function(game) {
          goalsPlayer1 += game.getGoalsByPlayer(_this.get("player1"));
          return goalsPlayer2 += game.getGoalsByPlayer(_this.get("player2"));
        });
        if (goalsPlayer2 > goalsPlayer1) {
          return this.get("player2");
        } else {
          return this.get("player1");
        }
      } else if (App.Tournament.Bracket.get('qualifierModus') === App.qualifierModi.BEST_OF.id) {
        wins1 = 0;
        wins2 = 0;
        this.games.forEach(function(game) {
          var winner;
          winner = game.getWinner();
          if (winner === _this.get("player1")) {
            wins1++;
          }
          if (winner === _this.get("player2")) {
            return wins2++;
          }
        });
        if (wins2 > wins1) {
          return this.get("player2");
        } else {
          return this.get("player1");
        }
      }
    },
    isCompleted: function() {
      return this.games.every(function(game) {
        return game.get("isCompleted");
      });
    },
    generateGames: (function() {
      var i, p1, p2, _i, _ref, _ref1, _results;
      this.get("games").clear();
      _results = [];
      for (i = _i = 1, _ref = this.get("_round").get("matchesPerGame"); 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        p1 = this.get("player1");
        p2 = this.get("player2");
        if (i % 2 === 0) {
          _ref1 = [p2, p1], p1 = _ref1[0], p2 = _ref1[1];
        }
        _results.push(this.get("games").pushObject(App.Game.create({
          player1: p1,
          player2: p2
        })));
      }
      return _results;
    }).observes("_round.matchesPerGame", "players.@each")
  });

  App.Game = Em.Object.extend({
    player1: null,
    player2: null,
    result1: null,
    result2: null,
    date: null,
    _playersSwapped: true,
    isCompleted: (function() {
      return (this.get("result1") || this.get("result1") === 0) && (this.get("result2") || this.get("result2") === 0);
    }).property("result1", "result2"),
    players: (function() {
      return [this.player1, this.player2];
    }).property('player1', 'player2'),
    goals1: (function() {
      if (this.get("result1")) {
        return parseInt(this.get("result1"));
      }
      return null;
    }).property("result1"),
    goals2: (function() {
      if (this.get("result2")) {
        return parseInt(this.get("result2"));
      }
      return null;
    }).property("result2"),
    setResult: function(r1, r2) {
      this.set("result1", r1);
      return this.set("result2", r2);
    },
    getGoalsByPlayer: function(player) {
      if (player === this.player1) {
        return this.get("goals1");
      }
      if (player === this.player2) {
        return this.get("goals2");
      }
    },
    getGoalsAgainstByPlayer: function(player) {
      if (player === this.player1) {
        return this.get("goals2");
      }
      if (player === this.player2) {
        return this.get("goals1");
      }
    },
    getWinner: function() {
      if (!this.get("isCompleted")) {
        return null;
      }
      if (this.get("goals1") > this.get("goals2")) {
        return this.get("player1");
      }
      if (this.get("goals1") < this.get("goals2")) {
        return this.get("player2");
      }
      if (this.get("goals1") === this.get("goals2")) {
        return false;
      }
    },
    player1Wins: (function() {
      return this.getWinner() === this.get("player1");
    }).property('isCompleted', 'player1'),
    player2Wins: (function() {
      return this.getWinner() === this.get("player2");
    }).property('isCompleted', 'player2'),
    getPoints: function(playerNumber) {
      var drawPoints, player, winPoints, winner;
      winPoints = parseInt(App.Tournament.Bracket.get("winPoints"));
      drawPoints = parseInt(App.Tournament.Bracket.get("drawPoints"));
      if (!this.get("isCompleted")) {
        return 0;
      }
      player = this.get("player" + playerNumber);
      winner = this.getWinner();
      if (!winner) {
        return drawPoints;
      }
      if (player === winner) {
        return winPoints;
      }
      if (player !== winner) {
        return 0;
      }
    },
    swapPlayers: function() {
      var gameAttribute, id, results, tempPlayer, tempResult, value, _i, _len, _ref;
      tempPlayer = this.get('player1');
      this.set('player1', this.get('player2'));
      this.set('player2', tempPlayer);
      tempResult = this.get('result1');
      this.set('result1', this.get('result2'));
      this.set('result2', tempResult);
      _ref = App.Tournament.Bracket.gameAttributes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        gameAttribute = _ref[_i];
        if (!(gameAttribute.type === 'result')) {
          continue;
        }
        id = gameAttribute.get('id');
        value = this.get(id);
        if (value != null ? value.search(/:/ !== -1) : void 0) {
          results = value.split(':');
          this.set(id, results[1] + ':' + results[0]);
        }
      }
      return this.set('_playersSwapped', !this.get('_playersSwapped'));
    }
  });

  App.GameAttribute = Em.Object.extend({
    name: "",
    type: "",
    id: "",
    init: function() {
      this._super();
      if (!this.id) {
        return this.id = UniqueId.create();
      }
    },
    isCheckbox: (function() {
      return this.get("type") === "checkbox";
    }).property("type"),
    isTextfield: (function() {
      return this.get("type") === "textfield";
    }).property("type"),
    isNumber: (function() {
      return this.get("type") === "number";
    }).property("type"),
    isResult: (function() {
      return this.get("type") === "result";
    }).property("type"),
    isDate: (function() {
      return this.get("type") === "date";
    }).property("type"),
    isTime: (function() {
      return this.get("type") === "time";
    }).property("type"),
    remove: function() {
      var _this = this;
      return App.Popup.showQuestion({
        title: App.i18n.deleteGameAttribute,
        bodyContent: App.i18n.reallyDeleteGameAttribute,
        onConfirm: function() {
          return App.Tournament.Bracket.gameAttributes.removeObject(_this);
        }
      });
    }
  });

  /*
    Em.Object.create {type: "date", label: "Date"}
    Em.Object.create {type: "time", label: "Time"}
  */


  App.Player = Em.Object.extend({
    name: "",
    isDummy: false,
    isPlayer: true,
    isPrivate: false,
    attributes: {},
    init: function() {
      this._super();
      if (!this.id) {
        this.set('id', UniqueId.create());
      }
      return this.attributes = Em.Object.create();
    },
    editable: (function() {
      return this.get("isPlayer") && App.editable;
    }).property("isPlayer"),
    isPartaking: (function() {
      return _.contains(App.Tournament.Bracket.getPlayers(), this);
    }).property(),
    isRealPlayer: (function() {
      return this.get('isPlayer') && !this.get('isPrivate');
    }).property('isDummy', 'isPlayer', 'isPrivate')
  });

  App.Player.reopenClass({
    createPlayer: function(args) {
      var player;
      player = App.Player.create(args);
      player.set('attributes', Em.Object.create(args.attributes));
      return player;
    }
  });

  App.Dummy = App.Player.extend({
    isDummy: true,
    isPlayer: false
  });

  App.PlayerAttribute = Em.Object.extend({
    name: "",
    type: "textfield",
    id: "",
    init: function() {
      this._super();
      if (!this.id) {
        return this.set('id', UniqueId.create());
      }
    },
    isCheckbox: (function() {
      return this.get("type") === "checkbox";
    }).property("type"),
    isTextfield: (function() {
      return this.get("type") === "textfield";
    }).property("type")
  });

  App.Tournament.Participants = Em.Object.extend({
    players: [],
    attributes: [],
    init: function() {
      this.set('players', []);
      return this.set('attributes', []);
    },
    initPlayers: function(members) {
      var _ref, _ref1,
        _this = this;
      if (members != null) {
        if ((_ref = members.members) != null) {
          _ref.forEach(function(member) {
            return _this.players.pushObject(App.Player.createPlayer(member));
          });
        }
      }
      return members != null ? (_ref1 = members.membersAttributes) != null ? _ref1.forEach(function(attribute) {
        return _this.attributes.pushObject(App.PlayerAttribute.create(attribute));
      }) : void 0 : void 0;
    },
    sortedPlayers: (function() {
      return this.get("players").sort(function(player1, player2) {
        if (player1.get('isPartaking') === player2.get('isPartaking')) {
          return player1.get('name').toLowerCase() > player2.get('name').toLowerCase();
        }
        return player2.get('isPartaking');
      });
    }).property("players.@each.name", "players.@each.isPartaking"),
    getNewPlayer: function(data) {
      var unusedPlayers;
      unusedPlayers = _.difference(this.players, App.Tournament.Bracket.getPlayers());
      if (unusedPlayers.length > 0) {
        return unusedPlayers[0];
      }
      data._isTemporary = true;
      return this.createPlayer(data);
    },
    getPlayerById: function(id) {
      var player, _i, _len, _ref;
      if (!id) {
        throw 'Id must be set';
      }
      _ref = this.players;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        player = _ref[_i];
        if (player.id === id) {
          return player;
        }
      }
    },
    createPlayer: function(data) {
      var player;
      if (!data) {
        data = {};
      }
      if (!data.name) {
        data.name = 'Player';
      }
      player = App.Player.createPlayer(data);
      this.players.pushObject(player);
      return player;
    },
    createAttribute: function(data) {
      var attribute;
      attribute = App.PlayerAttribute.create(data);
      this.attributes.pushObject(attribute);
      return attribute;
    },
    filterOutTemporaryPlayers: function() {
      var playersInBracket;
      playersInBracket = App.Tournament.getPlayers();
      return this.get('players').filter(function(player) {
        return !player._isTemporary || playersInBracket.contains(player);
      });
    },
    remove: function(player) {
      if (App.Tournament.getPlayers().contains(player)) {
        return;
      }
      if (player.isInitialPlayer) {
        return;
      }
      return this.players.removeObject(player);
    },
    removeAttribute: function(attribute) {
      return this.attributes.removeObject(attribute);
    },
    clear: function() {
      this.players.clear();
      return this.attributes.clear();
    }
  });

  App.Tournament.Participants = App.Tournament.Participants.create();

  App.Router.map(function() {
    this.route('dashboard', {
      path: '/'
    });
    this.route('info');
    this.route('participants');
    this.route('bracket');
    this.route('settings');
    return this.route('chat');
  });

  App.Router.reopen({
    location: 'history',
    init: function() {
      this.set('rootURL', window.location.pathname.match('(/[^/]*)')[0]);
      return this._super();
    }
  });

  App.BracketRoute = Ember.Route.extend({
    setupController: function(controller, videoChat) {
      this._super(controller, videoChat);
      return controller.set("title", "Video Chat");
    },
    renderTemplate: function() {
      return this.render('bracket');
    }
  });

  App.DynamicTextField = Ember.TextField.extend({
    classNames: ['s', 'dynamicTextField'],
    minWidth: 20,
    editable: true,
    onValueChanged: (function() {
      return this.updateWidth();
    }).observes("value"),
    didInsertElement: function() {
      this.updateWidth();
      return this.onEditableChange();
    },
    onEditableChange: (function() {
      return this.$().attr("disabled", !this.get("editable"));
    }).observes("editable"),
    updateWidth: function() {
      var sensor, width;
      sensor = $('<label>' + this.get("value") + '</label>').css({
        margin: 0,
        padding: 0,
        display: "inline-block"
      });
      $("body").append(sensor);
      width = sensor.width() + 6;
      sensor.remove();
      return this.$().width(Math.max(this.minWidth, width) + "px");
    }
  });

  App.DynamicTypeAheadTextField = App.DynamicTextField.extend({
    name: null,
    didInsertElement: function() {
      this._super();
      return this.$().addClass(this.name);
    },
    focusIn: function() {
      var input, values;
      this._super();
      values = (function() {
        var _i, _len, _ref, _results;
        _ref = $("." + this.name);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          input = _ref[_i];
          _results.push(input.value);
        }
        return _results;
      }).call(this);
      return this.$().typeahead({
        source: _.uniq(values)
      });
    }
  });

  App.NumberSpinner = Ember.TextField.extend({
    classNames: ['input-mini spinner-input'],
    editable: true,
    didInsertElement: function() {
      this.wrapper = $("<div id=\"MySpinner\" class=\"spinner\"></div>");
      this.$().wrap(this.wrapper);
      this.$().after("  <div class=\"spinner-buttons btn-group btn-group-vertical\">\n<button type=\"button\" class=\"btn spinner-up\">\n<i class=\"icon-chevron-up\"></i>\n</button>\n<button type=\"button\" class=\"btn spinner-down\">\n<i class=\"icon-chevron-down\"></i>\n</button>\n</div>");
      this.wrapper.spinner();
      return this.onEditableChange();
    },
    onValueChanged: (function() {
      this.set('value', parseInt(this.onlyNumber(this.get('value'))));
      return console.debug(this.get("value"));
    }).observes("value"),
    onEditableChange: (function() {
      if (this.get("editable")) {
        return this.get("wrapper").spinner("enable");
      } else {
        return this.get("wrapper").spinner("disable");
      }
    }).observes("editable"),
    onlyNumber: function(input) {
      if (input) {
        return input.replace(/[^\d]/g, "");
      }
    }
  });

  App.Serializer = {
    emberObjToJsonData: function(obj) {
      var emberObj, jsonObj, key, value;
      if (!(obj instanceof Ember.Object)) {
        throw TypeError("argument is not an Ember Object");
      }
      jsonObj = {};
      emberObj = Ember.ArrayController.create({
        content: []
      });
      for (key in obj) {
        value = obj[key];
        if (Ember.typeOf(value) === 'function') {
          continue;
        }
        if (emberObj[key] !== void 0) {
          continue;
        }
        if (value === 'toString') {
          continue;
        }
        if (value === void 0) {
          continue;
        }
        if (/^_/.test(key)) {
          continue;
        }
        if (value instanceof Em.ArrayController) {
          jsonObj[key] = this.emberObjArrToJsonDataArr(value.content);
        } else if (typeof value === 'object' && value instanceof Array) {
          jsonObj[key] = this.emberObjArrToJsonDataArr(value);
        } else {
          jsonObj[key] = value;
        }
      }
      return jsonObj;
    },
    toJsonData: function() {
      return this.emberObjToJsonData(this);
    },
    emberObjArrToJsonDataArr: function(objArray) {
      var obj, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = objArray.length; _i < _len; _i++) {
        obj = objArray[_i];
        _results.push(this.emberObjToJsonData(obj));
      }
      return _results;
    },
    controllerToJson: function(controller) {
      return this.emberObjArrToJsonDataArr(controller.content);
    },
    toJsonDataArray: function(arrayProperty) {
      return this.emberObjArrToJsonDataArr(this.get(arrayProperty));
    },
    dataArrayToEmberObjArray: function(EmberClass, dataArray) {
      var obj, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = dataArray.length; _i < _len; _i++) {
        obj = dataArray[_i];
        _results.push(EmberClass.create(obj));
      }
      return _results;
    }
  };

  App.ApplicationRoute = Ember.Route.extend({
    setupController: function(controller) {
      return controller.set("initialTab", "login");
    }
  });

  App.ApplicationController = Ember.Controller.extend({
    init: function() {
      return this._super();
    },
    logout: function() {
      return Chat.logout();
    }
  });

  App.ApplicationView = Em.View.extend({
    classNames: ['chat'],
    defaultTemplate: Ember.Handlebars.compile("{{outlet}}"),
    didInsertElement: function() {
      this._super();
      return console.debug("Application view");
    },
    isExpanded: true,
    actions: {
      toggleExpansion: function() {
        return this.expand(!this.get("isExpanded"));
      }
    },
    expand: function(expand) {
      var links;
      links = this.$('.nav-0 li');
      if (expand) {
        $('body').removeClass('contracted');
        links.tooltip('destroy');
      } else {
        $('body').addClass('contracted');
        links.each(function(i, link) {
          return $(link).tooltip({
            placement: 'right',
            title: $(link).text(),
            animation: false
          });
        });
      }
      return this.set("isExpanded", expand);
    }
  });

  App.InfoRoute = Ember.Route.extend({
    model: function() {
      return App.Tournament.info;
    }
  });

  App.templates.info = "<style type=\"text/css\">\ndl {\n  font-size: 16px;\n}\n</style>\n<div class=\"container container-normal\">\n  <% if @tournament.isOwner: %>\n    <%= @headerAction @i18n.edit, \"info/edit\", \"edit\" %>\n  <% end %>\n  <h1>{{App.i18n.info.header}}</h1>\n  <dl class=\"dl-horizontal\">\n    <dt>{{App.i18n.info.startDate}}</dt>\n    <dd itemprop=\"startDate\" content=\"<%= @printDateDbFormat @tournament.info.startDate %>\">\n      <%= @printDateAndTime @i18n.parseAndPrintDate(@tournament.info.startDate), @tournament.info.startTime, true %>\n    </dd>\n    {{#if App.Tournament.info.stopDate}}\n      <dt>{{App.i18n.info.stopDate}}</dt>\n      <dd><%= @printDateAndTime @i18n.parseAndPrintDate(@tournament.info.stopDate), @tournament.info.stopTime, true %></dd>\n    {{/if}}\n    <dt>{{App.i18n.info.venue}}</dt>\n    <span itemprop=\"location\" itemscope itemtype=\"http://schema.org/Place\">\n    <dd itemprop=\"name\">{{App.Tournament.info.venue}}</dd>\n    </span>\n  </dl>\n    <dl class=\"dl-horizontal\">\n    <dt>{{App.i18n.info.host}}</dt>\n    <dd>{{App.Tournament.info.host}}</dd>\n    <dt>E-Mail</dt>\n    <dd>{{App.Tournament.info.hostMail}}\n  </dl>\n  <div itemprop=\"description\" id=\"description\">{{App.Tournament.info.descriptionCompiled}}</div>\n</div>";

  App.InfoView = Em.View.extend({
    template: Ember.Handlebars.compile(App.templates.info),
    didInsertElement: function() {
      return this._super();
    }
  });

  App.SettingsRoute = Ember.Route.extend({
    setupController: function(controller) {
      return controller.set("initialTab", "login");
    }
  });

  App.SettingsController = Ember.Controller.extend({
    initialTab: "",
    actions: {
      login: function() {
        var previousTransition;
        previousTransition = this.get('previousTransition');
        if (previousTransition) {
          this.set('previousTransition', null);
          if (typeof previousTransition === 'string') {
            return this.transitionTo(previousTransition);
          } else {
            return previousTransition.retry();
          }
        } else {
          return this.transitionToRoute('index');
        }
      }
    }
  });

  App.templates.settings = "<div class=\"container dashboard\">\n  <div class=\"row\">\n  <div class=\"col-md-6\">\n  <div class=\"dashboardBox\">\n    <fieldset>\n      <legend>{{App.i18n.settings.colorSelection}}</legend>\n        <%= @formWithActionFor @tournament.colors, \"/tournament.id/settings/colors\", (form) => %>\n          <div class=\"form-group\">\n            <label class=\"control-label col-sm-2\">{{App.i18n.settings.theme}}</label>\n            <div class=\"col-sm-10\">\n              <span class=\"btn btn-link\" id=\"selectTheme\"><i class=\"fa fa-picture-o\"></i><%= @i18n.settings.selectTheme %></span>\n            </div>\n          </div>\n          <%= form.colorSelect @i18n.settings.background, \"background\", {placeholder: @i18n.color} %>\n          <br />\n          <%= form.colorSelect @i18n.settings.content, \"content\", {placeholder: @i18n.color} %>\n          <%= form.colorSelect @i18n.settings.contentText, \"contentText\", {placeholder: @i18n.color} %>\n          <br />\n          <%= form.colorSelect @i18n.settings.footer, \"footer\", {placeholder: @i18n.color} %>\n          <%= form.colorSelect @i18n.settings.footerText, \"footerText\", {placeholder: @i18n.color} %>\n          <%= form.button @i18n.settings.applyColor %>\n        <% end %>\n    </fieldset>\n  </div>\n  </div>\n\n  <div class=\"col-md-6\">\n  <div class=\"dashboardBox\">\n    <fieldset>\n      <legend>{{App.i18n.settings.publicName}}</legend>\n        <%= @infoHint => %>\n          <%= @i18n.settings.publicNameInfo %><br /><%= @i18n.settings.publicNameExample %>\n          <br /> <br />\n          {{App.i18n.settings.publicNameRestriction}}\n          <ul>\n            <li>{{App.i18n.settings.publicNameRestriction1}}</li>\n            <li>{{App.i18n.settings.publicNameRestriction2}}</li>\n            <li>{{App.i18n.settings.publicNameRestriction3}}</li>\n          </ul>\n        <% end %>\n        <br />\n\n        <%= @formFor @tournament, (form) => %>\n          <%= form.textField 'Name', \"publicName\", {class: \"publicName\", placeholder: @i18n.settings.publicName} %>\n          <%= form.button @i18n.save %>\n        <% end %>\n    </fieldset>\n    <!--\n    <fieldset>\n      <legend><%= @i18n.settings.messages %></legend>\n\nNachrichten aktivieren/deaktivieren\n\n  -->\n</div>";

  App.SettingsView = Em.View.extend({
    template: Ember.Handlebars.compile(App.templates.settings),
    didInsertElement: function() {
      return this._super();
    }
  });

  App.templates.dashboard = "<div class=\"container dashboard\">\n<div class=\"row\">\n<div class=\"col-md-6\">\n  {{#link-to 'info'}}\n  <section class=\"dashboardBox dashboardLightning\">\n    <fieldset>\n    <legend>{{App.i18n.info.basicData}}</legend>\n    <dl class=\"dl-horizontal\" style=\"margin-top: 0px\">\n      <dt><i class=\"fa fa-calendar\"></i></dt>\n      <dd>\n        {{App.Tournament.Info.startDate}}\n      </dd>\n      <dt><i class=\"fa fa-map-marker\"></i></dt>\n      <dd>{{App.Tournament.Info.venue}}\n    </dl>\n    <dl class=\"dl-horizontal\">\n      <dt><i class=\"fa fa-user\"></i></dt>\n      <dd>{{App.Tournament.Info.host}}</dd>\n      <dt>E-Mail</dt>\n      <dd>{{App.Tournament.Info.hostMail}}\n    </dl>\n    </fieldset>\n  </section>\n  {{/link-to}}\n\n\n  {{#link-to 'chat'}}\n<section id=\"messageDashboardBox\" class=\"dashboardBox dashboardLightning\">\n  <fieldset>\n  <legend>{{App.i18n.chat.messageStream}}</legend>\n    <center class=\"spinner-wrapper\"><i class=\"fa fa-spinner fa-spin\"></i></center>\n    <div id=\"chat\"></div>\n  </fieldset>\n</section>\n  {{/link-to}}\n</div>\n\n\n<div class=\"col-md-6\">\n\n  {{#link-to 'participants'}}\n<section class=\"dashboardBox dashboardLightning\">\n  <fieldset>\n    <legend>{{App.i18n.members.navName}}</legend>\n    {{#each member in App.Tournament.Participants.players}}\n      <span class=\"label\" style=\"display: inline-block\">{{member.name}}</span>\n      {{/each}}\n    <div class=\"bottomRight\">\n      <em>{{participantCount}} {{App.i18n.members.navName}}</em>\n    </div>\n    </span>\n  </fieldset>\n</section>\n  {{/link-to}}\n\n  {{#link-to 'bracket'}}\n    <section class=\"dashboardBox dashboardLightning\" id=\"treeDashboardBox\">\n      <fieldset>\n        <legend>{{App.i18n.tree.navName}}</legend>\n        <center class=\"spinner-wrapper\"><i class=\"fa fa-spinner fa-spin\"></i></center>\n      </fieldset>\n    </section>\n  {{/link-to}}\n\n</div>\n</div>\n</div>";

  App.DashboardView = Em.View.extend({
    template: Ember.Handlebars.compile(App.templates.dashboard),
    didInsertElement: function() {
      return this._super();
    }
  });

  App.DashboardRoute = Ember.Route.extend({
    setupController: function(controller) {
      return controller.set("initialTab", "login");
    }
  });

  App.DashboardController = Ember.Controller.extend({
    initialTab: "",
    actions: {
      login: function() {
        var previousTransition;
        previousTransition = this.get('previousTransition');
        if (previousTransition) {
          this.set('previousTransition', null);
          if (typeof previousTransition === 'string') {
            return this.transitionTo(previousTransition);
          } else {
            return previousTransition.retry();
          }
        } else {
          return this.transitionToRoute('index');
        }
      }
    },
    participantCount: (function() {
      return App.Tournament.Participants.players.length;
    }).property('App.Tournament.Participants.players')
  });

  App.ParticipantsRoute = Ember.Route.extend({
    setupController: function(controller) {
      return controller.set("initialTab", "login");
    }
  });

  App.ParticipantsController = Ember.Controller.extend({
    initialTab: "",
    actions: {
      login: function() {
        var previousTransition;
        previousTransition = this.get('previousTransition');
        if (previousTransition) {
          this.set('previousTransition', null);
          if (typeof previousTransition === 'string') {
            return this.transitionTo(previousTransition);
          } else {
            return previousTransition.retry();
          }
        } else {
          return this.transitionToRoute('index');
        }
      }
    }
  });

  App.templates.participants = "<div class=\"container container-normal\" id=\"players-container\">\n  <h1>{{App.i18n.members.navName}}\n  <% if @tournament.isOwner: %>\n    <%= @headerAction @i18n.edit, \"participants/edit\", \"edit\" %>\n  <% end %>\n  </h1>\n<table class=\"table table-striped\">\n  <thead>\n    <th width=\"25px\"></th>\n    <th>Name</th>\n    {{#each attribute in App.Tournament.Participants.attributes}}\n      <th>\n        {{attribute.name}}\n        {{#if App.editable}}\n          &nbsp;&nbsp;<i class=\"fa fa-times-circle\" rel=\"tooltip\" {{action \"removeAttribute\" attribute target=\"App.Tournament.Participants\"}}></i>\n        {{/if}}\n      </th>\n    {{/each}}\n    <th></th>\n  </thead>\n  {{#each member in App.Tournament.Participants.sortedPlayers}}\n    <tr>\n      <td style=\"height: 39px;\">\n        {{#if member.isPartaking}}\n          <i title=\"{{unbound App.i18n.playerDoPartipate}}\" class=\"fa fa-fw fa-sitemap fa-rotate-180\"></i>\n        {{/if}}\n      </td>\n      <td style=\"height: 39px;\">\n        {{#if App.editable}}\n          {{view Em.TextField valueBinding=\"member.name\" classNames=\"form-control required l\" placeholder=\"Name\"}}\n        {{else}}\n          {{member.name}}\n        {{/if}}\n      </td>\n      {{#each attribute in App.Tournament.Participants.attributes}}\n        {{#view MembersTable.MemberValueView memberBinding=\"member.attributes\" attributeBinding=\"attribute\"}}\n          {{#if attribute.isCheckbox}}\n            {{#if App.editable}}\n              {{view Ember.Checkbox checkedBinding=\"view.memberValue\" editableBinding=\"MembersTable.editable\"}}\n            {{else}}\n              {{#if view.memberValue}}\n                <i class=\"fa fa-check\" />\n              {{/if}}\n            {{/if}}\n          {{/if}}\n          {{#if attribute.isTextfield}}\n            {{#if App.editable}}\n              {{view view.TypeaheadTextField classNames=\"m form-control\" nameBinding=\"attribute.id\" valueBinding=\"view.memberValue\"}}\n            {{else}}\n              {{view.memberValue}}\n            {{/if}}\n          {{/if}}\n        {{/view}}\n      {{/each}}\n\n      <td width=\"50px\">\n        {{#unless App.editable}}\n          {{#if member.isPartaking}}\n            <button class=\"btn btn-inverse\" rel=\"tooltip\" title=\"Info\" {{action \"openPlayerView\" member target=\"view\"}} type=\"button\">\n              <i class=\"fa fa-info\"></i>\n            </button>\n          {{/if}}\n        {{/unless}}\n        {{#if App.editable}}\n          {{#unless member.isPartaking}}\n            <button class=\"btn btn-inverse\" rel=\"tooltip\" title=\"Delete\" {{action \"remove\" member target=\"App.Tournament.Participants\"}} type=\"button\">\n              <i class=\"fa fa-times\"></i>\n            </button>\n          {{/unless}}\n        {{/if}}\n      </td>\n    </tr>\n  {{/each}}\n</table>\n\n<div style=\"text-align: right\"><em>{{App.Tournament.Participants.players.length}} {{App.i18n.members.navName}}</em></div>\n</div>";

  App.ParticipantsView = Em.View.extend({
    data: function() {
      var data;
      return data = {
        members: Serializer.emberObjArrToJsonDataArr(App.Tournament.Participants.players),
        membersAttributes: Serializer.emberObjArrToJsonDataArr(App.Tournament.Participants.attributes)
      };
    },
    addMember: function() {
      return App.Tournament.Participants.createPlayer();
    },
    addAttribute: function() {
      return App.Tournament.Participants.createAttribute({
        name: $("#inputname").val(),
        type: $("#inputtyp").val(),
        isPrivate: $("#inputprivate").val()
      });
    },
    showAttributePopup: function() {
      var _this = this;
      return Popup.show({
        title: this.i18n.addAttribute,
        actions: [
          {
            closePopup: true,
            label: this.i18n.addAttribute,
            action: function() {
              return _this.addAttribute();
            }
          }
        ],
        bodyUrl: "/tournament/members/attribute_popup",
        afterRendering: function($popup) {
          return $popup.find("form").submit(function(event) {
            return event.preventDefault();
          });
        }
      });
    },
    addNoItemsRow: (function() {}).observes('App.Tournament.Participants.sortedPlayers'),
    openPlayerView: function(player) {
      return App.PlayerDetailView.create({
        player: player
      });
    },
    template: Ember.Handlebars.compile(App.templates.participants),
    didInsertElement: function() {
      return this.$("[rel='tooltip']").tooltip();
    },
    MemberValueView: Ember.View.extend({
      tagName: 'td',
      member: null,
      attribute: null,
      memberValue: (function(key, value) {
        if (arguments.length === 1) {
          return this.get("member")[this.get("attribute").id];
        }
        return this.get("member").set(this.get("attribute").id, value);
      }).property("member", "attribute.name")
    })
  });

  App.utils = {
    subStringContained: function(s, sub) {
      if (!s) {
        return false;
      }
      return s.toLowerCase().indexOf(sub.toLowerCase()) !== -1;
    },
    filterGames: function(filter, games) {
      var filtered, playedFilter, searchString,
        _this = this;
      if (!filter) {
        return games;
      }
      playedFilter = filter.played;
      searchString = filter.search;
      return filtered = games.filter(function(game) {
        var s;
        if (game.get('isCompleted') && (playedFilter === false)) {
          return false;
        }
        if ((!game.get('isCompleted')) && (playedFilter === true)) {
          return false;
        }
        if (!searchString) {
          return true;
        }
        s = searchString.split(' ');
        return s.every(function(ss) {
          var attribute, attributes, attrs, p1, p2, _i, _len, _ref;
          if (!ss) {
            return true;
          }
          attributes = [];
          p1 = _this.subStringContained(game.player1.name, ss);
          p2 = _this.subStringContained(game.player2.name, ss);
          _ref = App.Tournament.gameAttributes;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            attribute = _ref[_i];
            if (attribute.get("isTextfield")) {
              attributes.push(attribute.id);
            }
          }
          attrs = attributes.some(function(attr) {
            return _this.subStringContained(game[attr], ss);
          });
          return p1 || p2 || attrs;
        });
      });
    }
  };

  window.onbeforeunload = function() {
    if (App.editable && App.Observer.hasChanges()) {
      return App.i18n.unsavedChanges;
    }
  };

  App.Observer = {
    _snapshot: null,
    snapshot: function() {
      return this._snapshot = App.persist();
    },
    hasChanges: function() {
      return !_.isEqual(this._snapshot, App.persist());
    }
  };

  App.PersistanceManager = {
    dummies: [],
    persist: function() {
      return {
        members: this.persistPlayers(),
        tree: this.persistTree()
      };
    },
    persistPlayers: function() {
      return App.Serializer.emberObjArrToJsonDataArr(App.Tournament.Participants.filterOutTemporaryPlayers());
    },
    persistTree: function() {
      var round, serialized, tournament, _i, _len, _ref;
      tournament = App.Tournament.Bracket;
      serialized = App.Serializer.emberObjToJsonData(tournament);
      serialized.rounds = [];
      _ref = tournament.content;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        round = _ref[_i];
        serialized.rounds.push(App.Serializer.emberObjToJsonData(round));
      }
      return serialized;
    },
    extend: function(target, source) {
      var key, method, name, value, _results;
      for (name in source) {
        method = source[name];
        target.set(name, method);
      }
      _results = [];
      for (key in target) {
        value = target[key];
        if (typeof value === 'string') {
          if (value === 'false') {
            target.set(key, false);
          }
          if (value === 'true') {
            target.set(key, true);
          }
          if (value === 'null') {
            _results.push(target.set(key, null));
          } else {
            _results.push(void 0);
          }
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    },
    removeValue: function(obj, key) {
      var value;
      value = _.pick(obj, key);
      delete obj[key];
      return value[key];
    },
    buildBracket: function(obj) {
      var gRound, gameAttribute, gameAttributes, item, kRound, round, roundItems, tournamentRounds, _i, _j, _k, _l, _len, _len1, _len2, _len3, _results;
      if (!(obj != null ? obj.rounds : void 0)) {
        return;
      }
      tournamentRounds = this.removeValue(obj, "rounds");
      gameAttributes = this.removeValue(obj, "gameAttributes");
      this.extend(App.Tournament.Bracket, obj);
      App.Tournament.Bracket.clear();
      for (_i = 0, _len = tournamentRounds.length; _i < _len; _i++) {
        round = tournamentRounds[_i];
        if (round.isGroupRound) {
          gRound = App.Tournament.Bracket.addGroupRound();
          roundItems = this.removeValue(round, "items");
          this.extend(gRound, round);
          for (_j = 0, _len1 = roundItems.length; _j < _len1; _j++) {
            item = roundItems[_j];
            gRound.items.pushObject(this.buildGroup(item, gRound));
          }
        }
        if (round.isKoRound) {
          kRound = App.Tournament.Bracket.addKoRound();
          roundItems = this.removeValue(round, "items");
          this.extend(kRound, round);
          for (_k = 0, _len2 = roundItems.length; _k < _len2; _k++) {
            item = roundItems[_k];
            kRound.items.pushObject(this.buildRoundGame(item, kRound));
          }
        }
      }
      _results = [];
      for (_l = 0, _len3 = gameAttributes.length; _l < _len3; _l++) {
        gameAttribute = gameAttributes[_l];
        _results.push(App.Tournament.Bracket.gameAttributes.pushObject(App.GameAttribute.create(gameAttribute)));
      }
      return _results;
    },
    buildGroup: function(obj, round) {
      var group;
      group = App.Group.create({
        _round: round
      });
      this.buildRoundItem(group, obj);
      return group;
    },
    buildRoundGame: function(obj, round) {
      var roundGame;
      roundGame = App.RoundGame.create({
        _round: round
      });
      this.buildRoundItem(roundGame, obj);
      return roundGame;
    },
    buildGame: function(obj) {
      var game;
      game = App.Game.create({
        player1: this.createPlayer(obj.player1),
        player2: this.createPlayer(obj.player2)
      });
      delete obj.player1;
      delete obj.player2;
      this.extend(game, obj);
      return game;
    },
    buildRoundItem: function(roundItem, obj) {
      var dummy, game, player, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      roundItem.dummies.clear();
      _ref = obj.dummies;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        dummy = _ref[_i];
        roundItem.dummies.pushObject(this.createPlayer(dummy));
      }
      _ref1 = obj.players;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        player = _ref1[_j];
        roundItem.players.pushObject(this.createPlayer(player));
      }
      roundItem.games.clear();
      _ref2 = obj.games;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        game = _ref2[_k];
        roundItem.games.pushObject(this.buildGame(game));
      }
      delete obj.games;
      delete obj.dummies;
      delete obj.players;
      return this.extend(roundItem, obj);
    },
    isTrue: function(obj) {
      return obj && obj !== "false";
    },
    createPlayer: function(obj) {
      var dummy, newPlayer, _i, _len, _ref;
      _ref = this.dummies;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        dummy = _ref[_i];
        if (dummy.id === obj.id) {
          return dummy;
        }
      }
      newPlayer = this.isTrue(obj.isDummy) ? App.Dummy.create(obj) : App.Tournament.Participants.getPlayerById(obj.id);
      newPlayer.set("id", obj.id);
      this.extend(newPlayer, {});
      if (newPlayer.isDummy) {
        this.dummies.pushObject(newPlayer);
      }
      return newPlayer;
    }
  };

  /*
    RoundRobin eine Klasse um in einer Liga Spieltage zu erzeugen.
    Der Algorithmus der Berechnung folgt in etwa dem, der auf dieser Seite beschrieben wird: http://www-i1.informatik.rwth-aachen.de/~algorithmus/algo36.php
    
    @author  M.Richter
    @version  1.0.0
    @date  12:21 10.07.2012
  */


  App.RoundRobin = {
    generateGames: function(players) {
      var game, games, result, _i, _len;
      if (!players) {
        throw new TypeError("Parameter must be greater than zero");
      }
      if (players.length % 2 !== 0) {
        games = this.generate(players.length + 1);
      } else {
        games = this.generate(players.length);
      }
      result = [];
      for (_i = 0, _len = games.length; _i < _len; _i++) {
        game = games[_i];
        if (players[game[0] - 1] && players[game[1] - 1]) {
          result.push([players[game[0] - 1], players[game[1] - 1]]);
        }
      }
      return result;
    },
    generate: function(teamCount) {
      var a, h, i, k, n, spiele, temp, _i, _j, _ref, _ref1;
      if ((teamCount % 2) !== 0) {
        return false;
      }
      if (teamCount === 2) {
        return [[1, 2]];
      }
      n = teamCount - 1;
      spiele = [];
      for (i = _i = 1, _ref = teamCount - 1; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        h = teamCount;
        a = i;
        if ((i % 2) !== 0) {
          temp = a;
          a = h;
          h = temp;
        }
        spiele.push([h, a]);
        for (k = _j = 1, _ref1 = (teamCount / 2) - 1; 1 <= _ref1 ? _j <= _ref1 : _j >= _ref1; k = 1 <= _ref1 ? ++_j : --_j) {
          if ((i - k) < 0) {
            a = n + (i - k);
          } else {
            a = (i - k) % n;
            a = a === 0 ? n : a;
          }
          h = (i + k) % n;
          h = h === 0 ? n : h;
          if ((k % 2) === 0) {
            temp = a;
            a = h;
            h = temp;
          }
          spiele.push([h, a]);
        }
      }
      return spiele;
    }
  };

  App.BracketLineDrawer = {
    ctx: null,
    canvas: null,
    lastChange: new Date().getTime(),
    init: function() {
      var _this = this;
      this.canvas = document.getElementById("bracketLines");
      $(this.canvas).hide();
      this.ctx = this.canvas.getContext("2d");
      window.addEventListener('resize', (function() {
        return _this.update();
      }), false);
      $("#treeWrapper").bind("DOMSubtreeModified", function() {
        return setTimeout((function() {
          return _this.update();
        }), 10);
      });
      this.update();
      return $(this.canvas).fadeIn('slow');
    },
    update: function() {
      var _this = this;
      if (!this.ctx) {
        return;
      }
      if (new Date().getTime() - this.lastChange < 500) {
        return;
      }
      this.lastChange = new Date().getTime();
      this.clear();
      this.resize();
      return App.Tournament.forEach(function(round) {
        var gameCurrent, gamePrev, playersCurrent, prev, _i, _len, _ref, _results;
        prev = round._previousRound;
        if (!prev) {
          return;
        }
        if (prev.isGroupRound || round.isGroupRound) {
          return;
        }
        _ref = round.items;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          gameCurrent = _ref[_i];
          playersCurrent = gameCurrent.get("players");
          _results.push((function() {
            var _j, _len1, _ref1, _results1;
            _ref1 = prev.items;
            _results1 = [];
            for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
              gamePrev = _ref1[_j];
              if (_.intersection(playersCurrent, gamePrev.get("qualifiers")).length > 0) {
                _results1.push(this.draw(gameCurrent, gamePrev));
              } else {
                _results1.push(void 0);
              }
            }
            return _results1;
          }).call(_this));
        }
        return _results;
      });
    },
    draw: function(from, to) {
      var midY, posFrom, posTo;
      posFrom = this.centerPos($("." + from.get('itemId')), true);
      posTo = this.centerPos($("." + to.get('itemId')));
      if (!posFrom || !posTo) {
        return;
      }
      midY = posFrom.y + ((posTo.y - posFrom.y) / 2);
      this.ctx.lineWidth = 2;
      this.ctx.beginPath();
      this.ctx.moveTo(posFrom.x, posFrom.y);
      this.ctx.lineTo(posFrom.x, midY);
      this.ctx.lineTo(posTo.x, midY);
      this.ctx.lineTo(posTo.x, posTo.y);
      this.ctx.strokeStyle = App.colors.content;
      return this.ctx.stroke();
    },
    centerPos: function(element, top) {
      var pos;
      if (element.length === 0) {
        return void 0;
      }
      return pos = {
        x: element.offset().left + element.width() / 2,
        y: element.offset().top + (!top ? element.height() : 0)
      };
    },
    resize: function() {
      this.canvas.width = this.width();
      return this.canvas.height = this.height();
    },
    width: function() {
      return $(window).width();
    },
    height: function() {
      return $('body').height();
    },
    show: function() {
      return $(this.canvas).fadeIn('slow');
    },
    hide: function() {
      return $(this.canvas).fadeOut('medium');
    },
    clear: function() {
      if (!this.ctx) {
        return;
      }
      return this.ctx.clearRect(0, 0, this.width(), this.height());
    }
  };

  App.templates.tournament = "{{#each round in App.Tournament}}\n  {{#if round.isGroupRound}}\n    {{view App.GroupRoundView roundBinding=\"round\"}}\n  {{/if}}\n  {{#if round.isKoRound}}\n    {{view App.RoundView roundBinding=\"round\"}}\n  {{/if}}\n{{/each}}\n\n{{#if App.editable}}\n  <div class=\"saveActions box\">\n    <form action=\"#\" method=\"post\" style=\"margin: 1px 20px\">\n      <span>\n        <button class=\"btn btn-inverse\" {{action \"edit\" target=\"view\"}} ><i class=\"fa fa-cog\"></i>{{App.i18n.settings}}</button>\n        <button type=\"submit\" class=\"btn btn-inverse\">{{App.i18n.save}}</button>\n        <i class=\"fa fa-spinner fa-spin ajaxLoader\"></i>\n        <span class=\"successIcon\"><i class=\"fa fa-check\"></i> {{App.i18n.saved}}</span>\n      </span>\n    </form>\n  </div>\n{{else}}\n  {{#if App.isOwner}}\n    <div class=\"saveActions box\">\n      <a href=\"bracket/edit\">\n        <button  style=\"margin: 1px 20px\" class=\"btn btn-inverse\"><i class=\"fa fa-edit\"></i>{{App.i18n.edit}}</button>\n      </a>\n    </div>\n  {{/if}}\n{{/if}}\n\n\n{{#if App.editable}}\n  <div class=\"tournamentActions\">\n  <div class=\"roundSetting box\">\n    <span  id=\"tournamentAddRemoveActions\" class=\"roundName\"><i class=\"icon-plus\"></i></span>\n    <div class=\"actions\">\n      <button class=\"btn btn-inverse addKoRound\" {{action \"addKoRound\" target=\"App.Tournament\"}}><i class=\"fa fa-plus\"></i>{{App.i18n.koRound}}</button>\n      <button class=\"btn btn-inverse addGroupStage\" {{action \"addGroupRound\" target=\"App.Tournament\"}}><i class=\"fa fa-plus\"></i>{{App.i18n.groupStage}}</button>\n      <button class=\"btn btn-inverse deletePrevRound\" {{action \"removeLastRound\" target=\"view\"}}><i class=\"fa fa-trash-o\"></i>{{App.i18n.previousRound}}</button>\n    </div>\n  </div>\n  </div>\n{{/if}}\n\n<div style=\"clear: both\"></div>";

  App.TournamentView = Em.View.extend({
    classNames: ["tournament"],
    template: Ember.Handlebars.compile(App.templates.tournament),
    didInsertElement: function() {
      var _this = this;
      this.$().hide();
      $(".loading-screen").fadeOut('medium', function() {
        return _this.$().fadeIn('slow', function() {
          return App.BracketLineDrawer.init();
        });
      });
      new Save({
        form: $("form"),
        data: App.persist,
        onSave: function() {
          return App.Observer.snapshot();
        }
      });
      this.$(".deletePrevRound").tooltip({
        title: App.i18n.deletePreviousRound
      });
      this.$(".addGroupStage").tooltip({
        title: App.i18n.addGroupStage
      });
      this.$(".addKoRound").tooltip({
        title: App.i18n.addKoRound
      });
      if (App.editable) {
        return this.$(".tournamentActions .roundName").click(function() {
          if (_this.$(".tournamentActions .actions").is(":visible")) {
            return _this.$(".tournamentActions .actions").hide("medium");
          } else {
            return _this.$(".tournamentActions .actions").show("medium");
          }
        });
      }
    },
    edit: function() {
      return App.TournamentSettings.create({
        tournament: App.Tournament
      });
    },
    removeLastRound: function() {
      var _this = this;
      return App.Popup.showQuestion({
        title: App.i18n.deletePreviousRound,
        bodyContent: App.i18n.deletePreviousRoundInfo,
        onConfirm: function() {
          return App.Tournament.removeLastRound();
        }
      });
    }
  });

  App.RoundItemView = Em.View.extend({
    round: null,
    didInsertElement: function() {
      this.$(".fa-search").tooltip({
        title: App.i18n.detailView
      });
      if (App.editable) {
        this.initDraggable();
        this.draggable();
      }
      if (this.get("round").get("isEditable")) {
        this.$(".removeItem").tooltip({
          title: App.i18n.remove
        });
        return this.draggable();
      }
    },
    isDraggable: (function() {
      return App.editable && this.get('round.isNotStarted');
    }).property('App.editable', 'round.isNotStarted'),
    draggable: function() {
      var enable;
      enable = this.get('isDraggable');
      this.$('.player').draggable(enable ? "enable" : "disable");
      return this.$(".player").css("cursor", enable ? "move" : "default");
    },
    onDraggableChanged: (function() {
      return this.draggable();
    }).observes('isDraggable'),
    initDraggable: function() {
      var _this = this;
      this.$(".player").draggable({
        containment: this.get('parentView').$(),
        helper: "clone",
        revert: "invalid",
        start: function(e, _arg) {
          var helper, tds;
          helper = _arg.helper;
          $(helper).addClass("ui-draggable-helper");
          tds = $(helper).find('td');
          if (tds.length > 0) {
            $(tds[0]).empty();
            $(tds[1]).empty();
            $(tds[3]).empty();
            return $(tds[4]).empty();
          }
        },
        stop: function() {
          return setTimeout((function() {
            return _this.draggable();
          }), 20);
        }
      });
      return this.$(".player").droppable({
        drop: function(event, ui) {
          var dragElement, dropElement;
          setTimeout((function() {
            return _this.draggable();
          }), 20);
          dragElement = $(ui.draggable[0]);
          dropElement = $(event.target);
          return _this.get("round").swapPlayers([parseInt(dragElement.find("#itemIndex")[0].textContent), parseInt(dragElement.find("#playerIndex")[0].textContent)], [parseInt(dropElement.find("#itemIndex")[0].textContent), parseInt(dropElement.find("#playerIndex")[0].textContent)]);
        }
      });
    }
  });

  App.templates.roundSetting = "\n<div id=\"qualifierPopover\" class=\"hide\">\n  <ul>\n    {{#each qualifier in round.qualifiers}}\n      <li>{{qualifier.name}}<br /></li>\n    {{/each}}\n  </ul>\n</div>\n\n\n\n<div class=\"roundName\">&nbsp;{{round.name}}</div>\n\n<div id=\"settings\">\n<button type=\"button\" class=\"close\"><i class=\"fa fa-times-circle\"></i></button>\n  <form role=\"form\" style=\"float: left\">\n    <div>\n      <label style=\"\">Name</label>\n      {{view Em.TextField classNames=\"s form-control\" valueBinding=\"round.name\"}}\n    </div>\n  </form>\n  <form role=\"form\" style=\"float: left\">\n    <div>\n      <label>{{App.i18n.games}}</label>\n      {{view App.NumberField classNames=\"form-control xs\" editableBinding=\"round.isEditable\" valueBinding=\"round.matchesPerGame\"}}\n    </div>\n  </form>\n  <form role=\"form\" style=\"float: left\">\n      <label>{{App.i18n.actions}}</label>\n    <div>\n    <button class=\"btn btn-inverse\" {{action \"shuffle\" target=\"view\"}}><i class=\"fa fa-random\"></i>{{App.i18n.shuffle}}</button>\n    <button class=\"btn btn-inverse\" {{action \"addItem\" target=\"round\"}}><i class=\"fa fa-plus\"></i>{{round._itemLabel}}</button>\n    </div>\n  </form>\n\n</div>";

  App.RoundSetting = Em.View.extend({
    template: Ember.Handlebars.compile(App.templates.roundSetting),
    classNames: ["roundSetting box"],
    round: null,
    didInsertElement: function() {
      var _this = this;
      this.$(".close").click(function() {
        return _this.$("#settings").hide("medium");
      });
      if (App.editable) {
        return this.$(".roundName").click(function() {
          if (_this.$("#settings").is(":visible")) {
            return _this.$("#settings").hide("medium");
          } else {
            return _this.$("#settings").show("medium");
          }
        });
      }
    },
    shuffle: function() {
      var _this = this;
      if (true) {
        return App.Popup.showQuestion({
          title: App.i18n.shufflePlayers,
          bodyContent: App.i18n.shufflePlayersDescription,
          onConfirm: function() {
            return _this.round.shuffle();
          }
        });
      } else {
        return this.round.shuffle();
      }
    }
  });

  App.RoundView = Em.View.extend({
    template: Ember.Handlebars.compile("{{view App.RoundSetting roundBinding=\"round\"}}\n<div class=\"box toolbar\"> \n  <button class=\"btn-inverse\" id=\"openDetailView\"><i class=\"fa fa-search\"></i></button>\n  <!-- <i class=\"fa fa-chevron-up\" {{action \"toggleRound\" target=\"view\"}} id=\"toggleRound\"></i> -->\n</div>\n\n{{#each game in round.items}}\n  {{view App.GameView gameBinding=\"game\"}}\n{{/each}}"),
    classNames: ["round"],
    classNameBindings: ["roundMargin"],
    round: null,
    onRoundItemsChanged: (function() {
      return $("body").children(".tooltip").remove();
    }).observes("round.items.@each"),
    didInsertElement: function() {
      var _this = this;
      return this.$("#openDetailView").click(function() {
        return App.RoundDetailView.create({
          round: _this.round
        });
      });
    },
    roundMargin: (function() {
      var isValid, prevRound, round, roundIndex;
      roundIndex = 0;
      round = this.round;
      while (round && round.isKoRound && round.koRoundsBefore() > 0) {
        prevRound = round._previousRound;
        isValid = (round.items.length / prevRound.items.length) === 0.5;
        if (!isValid) {
          break;
        }
        roundIndex++;
        round = prevRound;
      }
      return "round-" + roundIndex;
    }).property("round.items.@each"),
    toggleRound: function() {
      if (this.$("#toggleRound").attr("class") === "fa fa-chevron-down") {
        this.$(".roundItem").show("medium");
        this.$().css("min-height", "130px");
        return this.$("#toggleRound").attr("class", "fa fa-chevron-up");
      } else {
        this.$(".roundItem").hide("medium");
        this.$("#settings .close").click();
        this.$().css("min-height", "0px");
        return this.$("#toggleRound").attr("class", "fa fa-chevron-down");
      }
    }
  });

  App.templates.groupRound = "{{view App.RoundSetting roundBinding=\"round\"}}\n\n<div class=\"box toolbar\">\n      <button class=\"btn-inverse\" id=\"showTables\" style=\"display: none\" {{action \"displayTables\" target=\"view\"}}>\n        <i class=\"fa fa-table\"></i>\n      </button>\n      <button class=\"btn-inverse\" id=\"showGames\" {{action \"displayGames\" target=\"view\"}}>\n        <i class=\"fa fa-list\"></i>\n      </button>\n      <button class=\"btn-inverse\" id=\"openDetailView\">\n        <i class=\"fa fa-search\"></i>\n      </button>\n  <!--<i class=\"fa fa-chevron-up\" {{action \"toggleRound\" target=\"view\"}} id=\"toggleRound\"></i>-->\n</div>\n\n{{#each group in round.items}}\n  {{view App.GroupView groupBinding=\"group\" showTablesBinding=\"view.showTables\"}}\n{{/each}}";

  App.GroupRoundView = App.RoundView.extend({
    template: Ember.Handlebars.compile(App.templates.groupRound),
    showTables: true,
    didInsertElement: function() {
      this._super();
      this.$("#showTables").tooltip({
        title: App.i18n.table,
        placement: 'left'
      });
      return this.$("#showGames").tooltip({
        title: App.i18n.schedule,
        placement: 'left'
      });
    },
    displayTables: function() {
      this.set("showTables", true);
      this.$("#showTables").removeClass('hide');
      this.$("#showTables").hide();
      return this.$("#showGames").show();
    },
    displayGames: function() {
      this.set("showTables", false);
      this.$("#showTables").show();
      this.$("#showGames").removeClass('hide');
      return this.$("#showGames").hide();
    }
  });

  App.templates.group = "<table class=\"round-item-table noPadding box\" id=\"groupTable\">\n  <col width=\"5px\" />\n  <col width=\"18px\" />\n  <col width=\"127px\" />\n  <col width=\"40px\" />\n  <col width=\"20px\" />\n<thead>\n  <th colspan=\"5\">\n    {{view App.DynamicTextField valueBinding=\"group.name\" editableBinding=\"App.editable\"}}\n\n    <span class=\"actionIcons\">\n      {{#if App.editable}}\n        <i class=\"fa fa-search\" {{action \"openGroupView\" target=\"view\"}}></i>\n      {{/if}}\n      {{#if view.round.isEditable}}\n        <i class=\"fa fa-sort-up increaseQualifierCount\" {{action \"increaseQualifierCount\" target=\"group\"}}></i>\n        <i class=\"fa fa-sort-down decreaseQualifierCount\" {{action \"decreaseQualifierCount\" target=\"group\"}}></i>\n        <i class=\"fa fa-plus-circle increaseGroupsize\" {{action \"addPlayer\" target=\"group\"}}></i>\n        <i class=\"fa fa-minus-circle decreaseGroupsize\" {{action \"removeLastPlayer\" target=\"group\"}}></i>\n        <i class=\"fa fa-times removeItem\" {{action \"remove\" target=\"group\"}}></i>\n      {{/if}}\n    </span>\n  </th>\n</thead>\n<tbody>\n  {{#each group.table}}\n    <tr {{bind-attr class=\"qualified:qualified :player\"}}>\n    <td></td>\n    <td class=\"tableCell\" style=\"text-align: center; vertical-align: middle\">\n      <div id=\"itemIndex\" class=\"hide\">{{view.groupIndex}}</div><div id=\"playerIndex\" class=\"hide\">{{index}}</div>\n      {{rank}}.\n    </td>\n    <td class=\"tableCell\" style=\"max-width: 130px\">\n      {{#if App.editable}}\n        {{view App.DynamicTextField valueBinding=\"player.name\" editableBinding=\"player.editable\"}}\n      {{else}}\n        {{player.name}}\n      {{/if}}\n    </td>\n    <td class=\"tableCell\" style=\"text-align: center; vertical-align: middle\">{{goals}} : {{goalsAgainst}}</td>\n    <td class=\"tableCell\" style=\"text-align: center; vertical-align: middle; font-weight: bold;\">{{points}}</td>\n  </tr>\n  {{/each}}\n</tbody>\n</table>\n\n<table class=\"table round-item-table noPadding groupGames box hide\" id=\"groupGames\">\n<col width=\"80px\" />\n<col width=\"8px\" />\n<col width=\"80px\" />\n<col width=\"50px\" />\n<thead>\n  <th colspan=\"4\">\n    {{view App.DynamicTextField valueBinding=\"group.name\" editableBinding=\"App.editable\"}}\n  </th>\n</thead>\n{{#each view.games}}\n{{#if newRound}}\n  <tr>\n    <td colspan=\"9\" class=\"roundSeperator\"></td>\n  </tr>\n{{/if}}\n<tr class=\"game\">\n  <td title=\"{{unbound game.player1.name}}\" style=\"text-align: right; padding-left: 3px !important\" class=\"tableCell\">\n    <div id=\"gameIndex\" class=\"hide\">{{gameIndex}}</div>\n    {{game.player1.name}}\n  </td>\n  <td style=\"text-align: center\" class=\"tableCell\">:</td>\n  <td class=\"tableCell\" title=\"{{unbound game.player2.name}}\">\n    {{game.player2.name}}\n  </td>\n  <td class=\"tableCell\" style=\"text-align: center\">\n    {{view App.NumberField editableBinding=\"App.editable\" valueBinding=\"game.result1\"}} : {{view App.NumberField valueBinding=\"game.result2\" editableBinding=\"App.editable\"}}\n  </td>\n</tr>\n{{/each}}\n</table>";

  App.GroupView = App.RoundItemView.extend({
    template: Ember.Handlebars.compile(App.templates.group),
    classNames: ['group roundItem'],
    round: (function() {
      var _ref;
      return (_ref = this.group) != null ? _ref._round : void 0;
    }).property("group._round"),
    didInsertElement: function() {
      var _this = this;
      this._super();
      this.$(".increaseGroupsize").tooltip({
        title: App.i18n.groupSizeUp
      });
      this.$(".decreaseGroupsize").tooltip({
        title: App.i18n.groupSizeDown
      });
      this.$(".increaseQualifierCount").tooltip({
        title: App.i18n.qualifiersUp
      });
      this.$(".decreaseQualifierCount").tooltip({
        title: App.i18n.qualifiersDow
      });
      this.toggleTableGames();
      if (App.editable) {
        return this.initGameDraggable();
      } else {
        this.$('#groupTable').addClass('blurringBox');
        this.$('#groupGames').addClass('blurringBox');
        this.$('#groupTable').click(function() {
          return _this.openGroupView();
        });
        return this.$('#groupGames').click(function() {
          return _this.openGroupView();
        });
      }
    },
    onRedrawTable: (function() {
      var _this = this;
      if (this.get("isDraggable")) {
        return setTimeout((function() {
          return _this.initDraggable();
        }), 50);
      }
    }).observes("group.table"),
    onRedrawGames: (function() {
      var _this = this;
      if (App.editable) {
        return setTimeout((function() {
          return _this.initGameDraggable();
        }), 50);
      }
    }).observes("games"),
    toggleTableGames: (function() {
      if (this.get("showTables")) {
        return this.toggle("#groupGames", "#groupTable");
      } else {
        return this.toggle("#groupTable", "#groupGames");
      }
    }).observes("showTables"),
    openGroupView: function() {
      return App.RoundItemDetailView.create({
        roundItem: this.group,
        table: true
      });
    },
    toggle: function(outId, inId) {
      var _this = this;
      return this.$(outId).fadeOut("fast", function() {
        _this.$(inId).removeClass('hide');
        return _this.$(inId).fadeIn("medium");
      });
    },
    groupIndex: (function() {
      return this.group._round.items.indexOf(this.group);
    }).property("group.round.items.@each"),
    games: (function() {
      var games, gamesPerRound, index, _i, _ref;
      games = [];
      gamesPerRound = Math.floor(this.group.players.get("length") / 2);
      for (index = _i = 0, _ref = this.group.games.get("length") - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; index = 0 <= _ref ? ++_i : --_i) {
        games.pushObject({
          game: this.get("group.games").objectAt(index),
          gameIndex: index,
          newRound: index !== 0 && (index + gamesPerRound) % gamesPerRound === 0
        });
      }
      return games;
    }).property("group.games.@each"),
    initGameDraggable: function() {
      var _this = this;
      this.$(".game").css("cursor", "move");
      this.$(".game").draggable({
        containment: this.$(),
        helper: 'clone',
        revert: 'invalid',
        start: function(e, _arg) {
          var helper;
          helper = _arg.helper;
          return $(helper).addClass("ui-draggable-helper");
        }
      });
      return this.$(".game").droppable({
        drop: function(event, ui) {
          var dragElement, dropElement;
          dragElement = $(ui.draggable[0]);
          dropElement = $(event.target);
          return _this.get("group").swapGames(parseInt(dragElement.find("#gameIndex")[0].textContent), parseInt(dropElement.find("#gameIndex")[0].textContent));
        }
      });
    }
  });

  App.templates.game = "\n<table {{bind-attr class=\":box game.itemId :round-item-table :noPadding\"}} cellpadding=\"2\" width=\"100%\" id=\"gamesTable\">\n  <thead>\n    <th colspan=\"10\">\n      <span>{{view App.DynamicTextField valueBinding=\"game.name\" editableBinding=\"App.editable\"}}</span>\n\n      <span class=\"actionIcons\">\n        {{#if App.editable}}\n          <i class=\"fa fa-search\" {{action \"openGameView\" target=\"view\"}}></i>\n        {{/if}}\n        {{#if view.round.isEditable}}\n          <i class=\"fa fa-times removeItem\" {{action \"remove\" target=\"game\"}}></i>\n        {{/if}}\n      </span>\n    </th>\n  </thead>\n  <tr>\n    <td style=\"width: 5px\">&nbsp;</td>\n    <td style=\"max-width: 110px; width: 110px\" class=\"player tableCellBottom\" title=\"{{unbound game.player1.name}}\">\n      <div id=\"itemIndex\" class=\"hide\">{{view.gameIndex}}</div><div id=\"playerIndex\" class=\"hide\">0</div>\n      {{#if App.editable}}\n        {{view App.DynamicTextField valueBinding=\"game.player1.name\" editableBinding=\"game.player1.editable\"}}\n      {{else}}\n        {{game.player1.name}}\n      {{/if}}\n    </td>\n    {{#each g in game.games}}\n\n      <td class=\"tableCellBottom\">\n        {{view App.GameResultView playerBinding=\"game.player1\" gBinding=\"g\"}}\n      </td>\n    {{/each}}\n  </tr>\n  <tr>\n    <td style=\"width: 5px\">&nbsp;</td>\n    <td style=\"max-width: 110px; width: 110px\" class=\"player tableCellTop\" title=\"{{unbound game.player2.name}}\">\n      <div id=\"itemIndex\" class=\"hide\">{{view.gameIndex}}</div><div id=\"playerIndex\" class=\"hide\">1</div>\n      {{#if App.editable}}\n        {{view App.DynamicTextField valueBinding=\"game.player2.name\" editableBinding=\"game.player2.editable\"}}\n      {{else}}\n        {{game.player2.name}}\n      {{/if}}\n    </td>\n    {{#each g in game.games}}\n      <td class=\"tableCellTop\">\n        {{view App.GameResultView playerBinding=\"game.player2\" gBinding=\"g\"}}\n      </td>\n    {{/each}}\n  </tr>\n</table>";

  App.GameView = App.RoundItemView.extend({
    template: Ember.Handlebars.compile(App.templates.game),
    classNames: ['roundItem'],
    didInsertElement: function() {
      var _this = this;
      this._super();
      if (!App.editable) {
        this.$('#gamesTable').addClass('blurringBox');
        return this.$('#gamesTable').click(function() {
          return _this.openGameView();
        });
      }
    },
    openGameView: function() {
      return App.RoundItemDetailView.create({
        roundItem: this.get("game"),
        table: false
      });
    },
    round: (function() {
      var _ref;
      return (_ref = this.game) != null ? _ref._round : void 0;
    }).property("game._round"),
    gameIndex: (function() {
      return this.game._round.items.indexOf(this.game);
    }).property("game._round.items.@each"),
    itemId: (function() {
      return this.game.getId();
    }).property("game._round.items.@each")
  });

  App.GameResultView = Em.View.extend({
    template: Ember.Handlebars.compile("{{view App.NumberField valueBinding=\"view.result\" editableBinding=\"App.editable\"}}"),
    result: (function(key, value) {
      var index;
      if (this.get("g.player1") === this.get("player")) {
        index = "1";
      } else {
        index = "2";
      }
      if (arguments.length === 1) {
        return this.get("g.result" + index);
      } else {
        return this.get("g").set("result" + index, value);
      }
    }).property("player", "g.result1", "g.result2")
  });

  App.NumberField = Ember.TextField.extend({
    classNames: ['result-textfield'],
    editable: true,
    didInsertElement: function() {
      return this.onEditableChange();
    },
    onValueChanged: (function() {
      return this.set('value', this.onlyNumber(this.get('value')));
    }).observes("value"),
    onEditableChange: (function() {
      return this.$().attr("disabled", !this.get("editable"));
    }).observes("editable"),
    onlyNumber: function(input) {
      if (input) {
        return input.replace(/[^\d]/g, "");
      }
    }
  });

  App.SearchTextField = Ember.View.extend({
    classNames: ['btn-group', 'noPrint'],
    template: Ember.Handlebars.compile("{{view Em.TextField classNames=\"form-control\" valueBinding=\"view.value\" placeholderBinding=\"view.placeholder\" }}\n<i class=\"filter-input-close-button fa fa-times\" {{action clearInput target=\"view\"}}></i>"),
    init: function() {
      return this._super();
    },
    clearInput: function() {
      return this.set('value', null);
    },
    showCloseButton: function(visiblie) {
      if (visiblie) {
        return this.$(".filter-input-close-button").show();
      } else {
        return this.$(".filter-input-close-button").hide();
      }
    },
    didInsertElement: function() {
      return this.showCloseButton();
    },
    onValueChanged: (function() {
      return this.showCloseButton(this.get('value'));
    }).observes("value")
  });

  App.FilterButton = Ember.View.extend({
    classNames: ['btn-group'],
    content: [],
    value: '',
    template: Ember.Handlebars.compile("<button type=\"button\" class=\"btn btn-inverse dropdown-toggle noPrint\" data-toggle=\"dropdown\">\n  <i class=\"fa fa-filter\"></i>{{view.buttonLabel}} <span class=\"caret\"></span>\n</button>\n<ul class=\"dropdown-menu\" role=\"menu\">\n  {{#each view.content}}\n    <li><a {{action \"select\" this target=\"view\"}} href=\"#\">{{label}}</a></li>\n  {{/each}}\n</ul>"),
    init: function() {
      this._super();
      return this.set('buttonLabel', this.get('value'));
    },
    select: function(selected) {
      this.set('buttonLabel', selected.label);
      return this.set('value', selected.id);
    },
    didInsertElement: function() {}
  });

  App.DynamicTypeAheadTextField = Em.TextField.extend({
    attribute: null,
    classNames: ['l'],
    focusIn: function() {
      var game, values;
      this._super();
      values = (function() {
        var _i, _len, _ref, _results;
        _ref = App.Tournament.get("games");
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          game = _ref[_i];
          _results.push(game[this.attribute.id]);
        }
        return _results;
      }).call(this);
      return this.$().typeahead({
        source: _.uniq(_.compact(values))
      });
    }
  });

  App.Alert = {
    open: function(title, text) {
      $(".alert").alert('close');
      return $("body").append(this.template.replace("###text###", text).replace("###title###", title));
    },
    openWarning: function(text) {
      return App.Alert.open("Warning!", text);
    },
    template: "<div class=\"alert alert-block\" style=\"position: fixed; top: 40px;\">\n  <button class=\"close\" data-dismiss=\"alert\" type=\"button\">×</button>\n  <h4 class=\"alert-heading\">###title###</h4>\n  ###text###\n</div>"
  };

  App.DetailView = Em.View.extend({
    classNames: ['detailView'],
    layout: Ember.Handlebars.compile("<span title=\"close\" class=\"closeButton right noPrint\">\n  <i class=\"fa fa-times-circle\"></i>\n</span>\n<div class=\"detailContent\">{{yield}}</div>"),
    didInsertElement: function() {
      var container,
        _this = this;
      this._super();
      this.$().hide();
      this.$("rel[tooltip]").tooltip();
      App.BracketLineDrawer.hide();
      container = this.getContainer();
      return container.fadeOut('medium', function() {
        $(".navbar-static-top").addClass("visible-lg");
        return _this.$().fadeIn('medium', function() {
          return _this.initExitableView();
        });
      });
    },
    init: function() {
      var detailView, _i, _len, _ref;
      this._super();
      _ref = App.openDetailViews;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        detailView = _ref[_i];
        detailView.hide();
      }
      App.openDetailViews.pushObject(this);
      return this.appendTo("body");
    },
    initExitableView: function() {
      var _this = this;
      $(document).bind("keydown." + this.get('elementId'), function(e) {
        if (e.keyCode === 27 && _this) {
          e.preventDefault();
          if (_this === _.last(App.openDetailViews)) {
            $(document).unbind("keydown." + _this.get('elementId'));
            return _this.destroy();
          }
        }
      });
      return this.$('.closeButton').click(function() {
        return _this.destroy();
      });
    },
    hide: function() {
      return this.$().hide();
    },
    show: function() {
      return this.$().fadeIn('medium');
    },
    getContainer: function() {
      if ($(".tournament").exists()) {
        return $(".tournament");
      }
      if ($("#players-container").exists()) {
        return $("#players-container");
      }
      throw 'no container found';
    },
    destroy: function() {
      var lastDetailView,
        _this = this;
      App.openDetailViews.removeObject(this);
      lastDetailView = _.last(App.openDetailViews);
      if (lastDetailView) {
        lastDetailView.$().show();
      }
      this.$().fadeOut('medium', function() {
        if (!lastDetailView) {
          $(".navbar-static-top").removeClass("visible-lg");
          _this.getContainer().fadeIn('slow', function() {});
          return App.BracketLineDrawer.show();
        }
      });
      this.destroyElement();
      return this._super();
    }
  });

  App.templates.gamesDetail = "<div class=\"roundItemTitle\">\n  <div class=\"roundItemTitleLabel\">\n    {{#if view.roundItem}}\n      <span class=\"left noPrint\" title=\"previous\" {{action \"navigateToLeft\" target=\"view\"}}>\n        <i class=\"fa fa-arrow-circle-left\"></i>\n      </span>\n\n      <span class=\"round-item-name\">{{view.roundItem.name}}</span>\n\n      <span class=\"right noPrint\" title=\"next\" {{action \"navigateToRight\" target=\"view\"}}>\n        <i class=\"fa fa-arrow-circle-right\"></i>\n      </span>\n    {{/if}}\n  </div>\n</div>\n  <div class=\"noPrint actionButtons\">\n    <span title=\"print\" class=\"printView hidden-xs hidden-sm\" {{action \"printView\" target=\"view\"}}>\n      <i class=\"fa fa-print\"></i>\n    </span><!--\n    <span title=\"prefill Attributes\" class=\"carousel-control prefillAttributesView\" {{action \"prefillAttributes\" target=\"view\"}}>\n      <i class=\"fa fa-check\"></i>\n    </span>-->\n  </div>\n\n  <div class=\"container\">\n  <div class=\"row\">\n{{#if view.table}}\n<fieldset>\n  <legend>{{App.i18n.table}}</legend>\n\n  <table class=\"table tableTable col-md-8 col-xs-12\">\n    <thead>\n      <tr>\n        <th style=\"width: 5px\"></th>\n        <th width=\"20px\">{{App.i18n.rank}}</th>\n        <th style=\"text-align: left\">Name</th>\n        <th>{{App.i18n.games}}</th>\n        <th class=\"hidden-xs\" style=\"cursor: help\" title=\"{{unbound App.i18n.wins}}\">{{App.i18n.winsShort}}</th>\n        <th class=\"hidden-xs\" style=\"cursor: help\" title=\"{{unbound App.i18n.draws}}\">{{App.i18n.drawsShort}}</th>\n        <th class=\"hidden-xs\" style=\"cursor: help\" title=\"{{unbound App.i18n.defeats}}\">{{App.i18n.defeatsShort}}</th>\n        <th style=\"cursor: help\" title=\"{{unbound App.i18n.goals}}\">{{App.i18n.goalsShort}}</th>\n        <th style=\"cursor: help\" class=\"hidden-xs\" title=\"{{unbound App.i18n.difference}}\">+/-</th>\n        <th>{{App.i18n.points}}</th>\n      </tr>\n    </thead>\n    <tbody>\n      {{#each view.roundItem.table}}\n        <tr {{bind-attr class=\":player qualified:qualified\"}} >\n        <td></td>\n        <td class=\"rank-cell\">\n          {{rank}}.\n        </td>\n        <td style=\"text-align: left\">\n          {{#if App.editable}}\n            {{view App.DynamicTextField valueBinding=\"player.name\" classNames=\"xl\" editableBinding=\"player.editable\"}}\n          {{else}}\n            <div class=\"input-padding\"><a href=\"#\" {{action \"openPlayerView\" player target=\"view\"}}>{{player.name}}</a></div>\n          {{/if}}\n        </td>\n        <td>{{games}}</td>\n        <td class=\"hidden-xs\">{{wins}}</td>\n        <td class=\"hidden-xs\">{{draws}}</td>\n        <td class=\"hidden-xs\">{{defeats}}</td>\n        <td>{{goals}} : {{goalsAgainst}}</td>\n        <td class=\"hidden-xs\">{{difference}}</td>\n        <td><b>{{points}}</b></td>\n      </tr>\n      {{/each}}\n    </tbody>\n  </table>\n</fieldset>\n<br />\n{{/if}}\n<fieldset>\n  <legend>{{App.i18n.schedule}}\n    <span style=\"font-size: 1rem; float:right; margin-bottom: 5px;\" class=\"hidden-xs\" class=\"noPrint\">\n      {{view App.FilterButton contentBinding=\"view.filterOptions\" valueBinding=\"view.gamesPlayedFilter\"}}\n      {{view App.SearchTextField valueBinding=\"view.gameFilter\" placeholder=\"Filter ...\"}}\n    </span>\n  </legend>\n  <table class=\"table tableSchedule\">\n    <thead class=\"hidden-xs\">\n      <tr>\n        <th class=\"hidden-xs\" width=\"70px\"></th>\n        <th class=\"hidden-xs\"></th>\n        <th style=\"text-align: left\">{{App.i18n.home}}</th>\n        {{#if App.editable}}\n          <th></th>\n        {{/if}}\n        <th style=\"text-align: left\">{{App.i18n.guest}}</th>\n        {{#each attribute in App.Tournament.gameAttributes}}\n          <th class=\"hidden-xs\">{{attribute.name}}</th>\n        {{/each}}\n        <th>{{App.i18n.result}}</th>\n      </tr>\n    </thead>\n    {{#each matchday in view.filteredGames}}\n      <tbody style=\"page-break-after: always\">\n      <tr class=\"matchday-separator\"><td colspan=\"15\" class=\"matchday-separator\">{{matchday.matchDay}}. {{App.i18n.matchday}}</td></tr>\n      {{#each game in matchday.games}}\n        <tr>\n          <td class=\"hidden-xs\"></td>\n          <td class=\"hidden-xs rank-cell\">{{game._roundItemName}}</td>\n          <td {{bind-attr class=\"game.player1Wins:winner\"}}>\n            <a href=\"#\" {{action \"openPlayerView\" game.player1 target=\"view\"}}>{{game.player1.name}}</a>\n          </td>\n          {{#if App.editable}}\n            <td><i class=\"fa fa-exchange\" title=\"{{unbound App.i18n.swapPlayers}}\"{{action swapPlayers target=\"game\"}}></i></td>\n          {{/if}}\n          <td {{bind-attr class=\"game.player2Wins:winner\"}}>\n            <a href=\"#\" {{action \"openPlayerView\" game.player2 target=\"view\"}}>{{game.player2.name}}</a>\n          </td>\n          {{#each attribute in App.Tournament.gameAttributes}}\n            {{view App.GameAttributeValueView classNames=\"hidden-xs\" attributeBinding=\"attribute\" gameBinding=\"game\"}}\n          {{/each}}\n          <td class=\"center\">\n          {{#if App.editable}}\n              <div class=\"result-container\">\n              {{view App.NumberField classNames=\"form-control\" editableBinding=\"App.editable\" valueBinding=\"game.result1\"}}\n              </div>\n              &nbsp;\n              <div class=\"result-container\">\n              {{view App.NumberField classNames=\"form-control\" editableBinding=\"App.editable\" valueBinding=\"game.result2\"}}\n              </div>\n          {{else}}\n            {{#if game.isCompleted}}\n              <b>{{game.result1}} : {{game.result2}}</b>\n            {{else}}\n              <b>-&nbsp;:&nbsp;-</b>\n            {{/if}}\n          {{/if}}\n          </td>\n        </tr>\n      {{/each}}\n      </tbody>\n    {{/each}}\n  </table>\n  <div style=\"text-align: right\" class=\"noPrint\"><em>{{view.gamesCount}} {{App.i18n.games}}</em></div>\n</fieldset>\n  </div></div>";

  App.GamesDetailView = App.DetailView.extend({
    template: Ember.Handlebars.compile(App.templates.gamesDetail),
    gameFilter: "",
    gamePlayedFilter: void 0,
    init: function() {
      this._super();
      return this.filterOptions = [
        {
          id: void 0,
          label: App.i18n.all
        }, {
          id: true,
          label: App.i18n.played
        }, {
          id: false,
          label: App.i18n.open
        }
      ];
    },
    printView: function() {
      return window.print();
    },
    openPlayerView: function(player) {
      return App.PlayerDetailView.create({
        player: player
      });
    },
    gamesCount: (function() {
      return this.get('filteredGames').reduce(function(count, matchDay) {
        return count += matchDay.games.length;
      }, 0);
    }).property("filteredGames")
  });

  App.RoundDetailView = App.GamesDetailView.extend({
    round: null,
    table: false,
    didInsertElement: function() {
      this._super();
      return this.$('.roundItemTitle').append("" + this.round.name);
    },
    filteredGames: (function() {
      var _this = this;
      return this.get("round.matchDays").map(function(matchDay) {
        return Em.Object.create({
          games: App.utils.filterGames({
            search: _this.get("gameFilter"),
            played: _this.get("gamesPlayedFilter")
          }, matchDay.games),
          matchDay: matchDay.matchDay
        });
      });
    }).property("gameFilter", "gamesPlayedFilter", "round.games.@each"),
    prefillAttributes: function() {
      return App.GameAttributePrefillPopup.open(this.get("round.games"));
    }
  });

  App.RoundItemDetailView = App.GamesDetailView.extend({
    roundItem: null,
    navigateToRight: function() {
      return this.navigate(1);
    },
    navigateToLeft: function() {
      return this.navigate(-1);
    },
    navigate: function(offset) {
      var index, length, newRoundItem,
        _this = this;
      length = this.roundItem._round.items.get("length");
      index = this.roundItem._round.items.indexOf(this.roundItem);
      index += offset;
      if (index < 0) {
        index = length - 1;
      }
      if (index >= length) {
        index = 0;
      }
      newRoundItem = this.roundItem._round.items.objectAt(index);
      return this.$('.detailContent').fadeOut('medium', function() {
        _this.set("roundItem", newRoundItem);
        return _this.$('.detailContent').fadeIn('medium');
      });
    },
    prefillAttributes: function() {
      return App.GameAttributePrefillPopup.open(this.get("roundItem.games"));
    },
    filteredGames: (function() {
      var _this = this;
      return this.get("roundItem.matchDays").map(function(matchDay) {
        return Em.Object.create({
          games: App.utils.filterGames({
            search: _this.get("gameFilter"),
            played: _this.get("gamesPlayedFilter")
          }, matchDay.games),
          matchDay: matchDay.matchDay
        });
      });
    }).property("gameFilter", "gamesPlayedFilter", "roundItem.games.@each")
  });

  App.templates.playerDetail = "<div class=\"roundItemTitle\">\n  <div class=\"roundItemTitleLabel\">\n      <span class=\"round-item-name\">{{view.player.name}}</span>\n  </div>\n</div>\n\n\n<div class=\"container\">\n<div class=\"row\">\n<fieldset>\n  <legend>{{App.i18n.statistic}}</legend>\n  <div class=\"col-md-6\">\n    <div id=\"win-chart\" class=\"center\"></div>\n  </div>\n  <div class=\"col-md-6\">\n      <div>\n        <b>{{App.i18n.games}}</b>\n        <div style=\"display: inline-block; float: right; font-size: 12px\">\n          {{view.statistics.games}}/{{view.statistics.totalGames}}\n        </div>\n      <div class=\"progress\">\n          <div class=\"progress-bar progress-bar-success\" style=\"width: {{unbound view.statistics.gamesCompletion}}%\"></div>\n        </div>\n        </div>\n        <br /> <br />\n    <dl class=\"dl-horizontal\">\n    <dt>{{App.i18n.goals}}</dt>\n    <dd>{{view.statistics.goals}}&nbsp;&nbsp;{{#if view.statistics.hasPlayedGames}}(&oslash;&nbsp;{{view.statistics.goalsAvg}}){{/if}}<dd>\n    <dt>{{App.i18n.goalsAgainst}}</dt>\n    <dd>{{view.statistics.goalsAgainst}}&nbsp;&nbsp;{{#if view.statistics.hasPlayedGames}}(&oslash;&nbsp;{{view.statistics.goalsAgainstAvg}}){{/if}}</dd>\n    </dl>\n  </div>\n</fieldset>\n</div>\n<div class=\"row\">\n<fieldset>\n  <legend>{{App.i18n.games}}</legend>\n\n  <table class=\"table tableSchedule\">\n    <thead>\n      <tr>\n        <th class=\"hidden-xs\" width=\"70px\"></th>\n        <th class=\"hidden-xs\"></th>\n        <th class=\"left\">{{App.i18n.home}}</th>\n        {{#if App.editable}}\n          <th></th>\n        {{/if}}\n        <th class=\"left\">{{App.i18n.guest}}</th>\n        {{#each attribute in App.Tournament.gameAttributes}}\n          <th class=\"hidden-xs\">{{attribute.name}}</th>\n        {{/each}}\n        <th>{{App.i18n.result}}</th>\n      </tr>\n    </thead>\n    {{#each round in view.rounds}}\n      <tr class=\"matchday-separator\"><td colspan=\"15\" class=\"matchday-separator\">{{round.round.name}}</td></tr>\n      {{#each game in round.games}}\n        <tr>\n          <td class=\"hidden-xs\"></td>\n          <td class=\"hidden-xs\">{{game._roundItemName}}</td>\n          <td {{bind-attr class=\"game.player1Wins:winner\"}}>\n            {{game.player1.name}}\n          </td>\n          {{#if App.editable}}\n            <td><i class=\"icon-exchange\" title=\"{{unbound App.i18n.swapPlayers}}\"{{action swapPlayers target=\"game\"}}></i></td>\n          {{/if}}\n          <td {{bind-attr class=\"game.player2Wins:winner\"}}>\n            {{game.player2.name}}\n          </td>\n          {{#each attribute in App.Tournament.gameAttributes}}\n            {{view App.GameAttributeValueView classNames=\"hidden-xs\" attributeBinding=\"attribute\" gameBinding=\"game\"}}\n          {{/each}}\n          <td style=\"text-align: center\">\n          {{#if App.editable}}\n              <div class=\"result-container\">\n              {{view App.NumberField classNames=\"form-control\" editableBinding=\"App.editable\" valueBinding=\"game.result1\"}}\n              </div>\n              &nbsp;\n              <div class=\"result-container\">\n              {{view App.NumberField classNames=\"form-control\" editableBinding=\"App.editable\" valueBinding=\"game.result2\"}}\n              </div>\n          {{else}}\n            {{#if game.isCompleted}}\n              <b>{{game.result1}} : {{game.result2}}</b>\n            {{else}}\n              <b>-&nbsp;:&nbsp;-</b>\n            {{/if}}\n          {{/if}}\n          </td>\n        </tr>\n      {{/each}}\n    {{/each}}\n  </table>\n  </div></div>";

  App.PlayerDetailView = App.DetailView.extend({
    template: Ember.Handlebars.compile(App.templates.playerDetail),
    player: null,
    statistics: null,
    rounds: [],
    init: function() {
      this._super();
      this.set('rounds', App.Tournament.getGamesByPlayer(this.player));
      return this.setStatistics();
    },
    didInsertElement: function() {
      this._super();
      return this.renderDonutChart();
    },
    renderDonutChart: function() {
      var arc, color, data, g, height, noGames, pie, radius, svg, width;
      width = 260;
      height = 200;
      radius = Math.min(width, height) / 2;
      color = d3.scale.ordinal().range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);
      arc = d3.svg.arc().outerRadius(radius - 10).innerRadius(radius - 70);
      pie = d3.layout.pie().sort(null).value(function(d) {
        return d.value;
      });
      svg = d3.select("#win-chart").append("svg").attr("width", width).attr("height", height).append("g").attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
      data = [
        {
          label: App.i18n.wins,
          value: this.statistics.get('wins')
        }, {
          label: App.i18n.draws,
          value: this.statistics.get('draws')
        }, {
          label: App.i18n.defeats,
          value: this.statistics.get('defeats')
        }
      ];
      data = data.filter(function(value) {
        return value.value > 0;
      });
      noGames = false;
      if (data.length === 0) {
        noGames = true;
        data.push({
          label: App.i18n.games,
          value: 1
        });
      }
      g = svg.selectAll(".arc").data(pie(data)).enter().append("g").attr("class", "arc");
      g.append("path").attr("d", arc).style("fill", function(d, i) {
        return color(i);
      });
      return g.append("text").attr("transform", function(d) {
        return "translate(" + arc.centroid(d) + ")";
      }).attr("dy", ".35em").style("text-anchor", "middle").text(function(d, i) {
        if (noGames) {
          data[i].value = 0;
        }
        return data[i].label + ': ' + data[i].value;
      });
    },
    setStatistics: function() {
      var statistics, stats,
        _this = this;
      stats = {
        totalGames: 0,
        games: 0,
        goals: 0,
        goalsAgainst: 0,
        wins: 0,
        draws: 0,
        defeats: 0
      };
      statistics = App.Tournament.get('games').reduce(function(statistics, game) {
        if (!game.get('players').contains(_this.player)) {
          return statistics;
        }
        if (game.get('isCompleted')) {
          statistics.games++;
          switch (game.getWinner()) {
            case _this.player:
              statistics.wins++;
              break;
            case false:
              statistics.draws++;
              break;
            default:
              statistics.defeats++;
          }
          statistics.goals += game.getGoalsByPlayer(_this.player);
          statistics.goalsAgainst += game.getGoalsAgainstByPlayer(_this.player);
        }
        statistics.totalGames++;
        return statistics;
      }, stats);
      statistics.gamesCompletion = 100 * statistics.games / statistics.totalGames;
      statistics.hasPlayedGames = statistics.games > 0;
      if (statistics.hasPlayedGames) {
        statistics.goalsAvg = Math.round(statistics.goals / statistics.games * 100) / 100;
        statistics.goalsAgainstAvg = Math.round(statistics.goalsAgainst / statistics.games * 100) / 100;
      }
      return this.set('statistics', Ember.Object.create(statistics));
    }
  });

  App.GameAttributeValueView = Ember.View.extend({
    template: Ember.Handlebars.compile("{{#if view.attribute.isCheckbox}}\n  {{#if App.editable}}\n    {{view Ember.Checkbox checkedBinding=\"view.gameValue\"}}\n  {{else}}\n    {{#if view.gameValue}}\n      <i class=\"fa fa-check\" />\n    {{/if}}\n  {{/if}}\n{{else}}\n  {{#if view.attribute.isResult}}\n    {{#if App.editable}}\n      <div class=\"result-container\">\n        {{view App.NumberField classNames=\"form-control\" valueBinding=\"view.resultGameValue1\"}}\n      </div>\n      <div class=\"result-container\">\n        {{view App.NumberField classNames=\"form-control\" valueBinding=\"view.resultGameValue2\"}}\n      </div>\n    {{else}}\n      {{view.gameValue}}\n    {{/if}}\n  {{else}}\n    {{#if view.attribute.isNumber}}\n      {{#if App.editable}}\n        {{view App.NumberField classNames=\"form-control xs\" valueBinding=\"view.gameValue\"}}\n      {{else}}\n        {{view.gameValue}}\n      {{/if}}\n    {{else}}\n      {{#if view.attribute.isTextfield}}\n        {{#if App.editable}}\n          {{view App.DynamicTypeAheadTextField classNames=\"form-control\" attributeBinding=\"attribute\" valueBinding=\"view.gameValue\"}}\n        {{else}}\n          {{view.gameValue}}\n        {{/if}}\n      {{/if}}\n    {{/if}}\n  {{/if}}\n{{/if}}"),
    tagName: 'td',
    game: null,
    attribute: null,
    classNames: ['center'],
    didInsertElement: function() {
      if (this.get("attribute.isDate")) {
        this.$(".dateTextBox").datepicker();
      }
      if (this.get("attribute.isTime")) {
        return this.$(".timeTextBox").timepicker();
      }
    },
    gameValue: (function(key, value) {
      if (arguments.length === 1) {
        return this.get("game")[this.get("attribute.id")];
      } else {
        return this.get("game").set(this.get("attribute.id"), value);
      }
    }).property("member", "attribute.name"),
    resultGameValue1: (function(key, value) {
      var splitted;
      splitted = this.resultSplitted();
      if (arguments.length === 1) {
        return splitted[0];
      } else {
        if (value == null) {
          value = "";
        }
        return this.get("game").set(this.get("attribute.id"), "" + value + ":" + splitted[1]);
      }
    }).property("member", "attribute.name", "game._playersSwapped"),
    resultGameValue2: (function(key, value) {
      var splitted;
      splitted = this.resultSplitted();
      if (arguments.length === 1) {
        return splitted[1];
      } else {
        if (value == null) {
          value = "";
        }
        return this.get("game").set(this.get("attribute.id"), "" + splitted[0] + ":" + value);
      }
    }).property("member", "attribute.name", "game._playersSwapped"),
    resultSplitted: function() {
      var currentValue, splitted;
      currentValue = this.get("game")[this.get("attribute.id")];
      if (!currentValue) {
        currentValue = "";
      }
      splitted = currentValue.split(":");
      if (splitted.length === !2) {
        currentValue = ":";
        splitted = currentValue.split(":");
      }
      return splitted;
    }
  });

  App.GameAttributePrefillPopup = {
    games: [],
    open: function(games) {
      this.games = games;
      return App.Popup.show({
        title: App.i18n.prefillAttributes,
        actions: [
          {
            closePopup: false,
            label: App.i18n.prefill,
            action: function() {}
          }
        ],
        bodyContent: "hallo: asldkfj asdrjc asdlfkj Rcihasd flkdrj csdhf l"
      });
    }
  };

  App.templates.tournamentPopup = "\n<div class=\"roundItemTitle\">\n  <div class=\"roundItemTitleLabel\">\n      <span class=\"round-item-name\">{{App.i18n.settings}}</span>\n  </div>\n</div>\n\n<!--\nmenu erreichbar �ber Gruppen�bersicht, Spielplan\nReturn-Icon links oben\nmenu: \n- standings, games settings\n- TimeCalculations\n- Punkteberechnung\n\n-->\n\n\n  <div class=\"container\">\n  <div class=\"row\" style=\"margin: 0; padding: 0\">\n  <div class=\"col-md-2\">\n    <ul id=\"settings-navigation\" class=\"nav nav-list\">\n      <li class=\"nav-header\">Navigation</li>\n      <li class=\"active\"><a href=\"#\" data-target=\"#main-settings\">{{App.i18n.pointsModus}}</a></li>\n      <li><a href=\"#\" data-target=\"#gameAttributes\">{{App.i18n.gameAttributes}}</a></li>\n      <li><a href=\"#\" data-target=\"#scheduling\">{{App.i18n.timeCalculation}}</a></li>\n  </ul> \n    \n  </div>\n  <div class=\"col-md-10\">\n  <div class=\"tab-content\">\n  <div id=\"main-settings\" class=\"tab-pane active\">\n<form class=\"form-horizontal\" role=\"form\">\n<fieldset>\n  <legend>{{App.i18n.groupStage}}</legend>\n<div class=\"form-group\">\n  <label class=\"control-label col-sm-2\" for=\"pointsPerWin\">{{App.i18n.pointsPerWin}}</label>\n  <div class=\"col-sm-10 col-md-1\">\n    {{view App.NumberField id=\"pointsPerWin\" classNames=\"form-control\" valueBinding=\"App.Tournament.winPoints\"}}\n  </div>\n</div>\n<div class=\"form-group\">\n  <label class=\"control-label col-sm-2\" for=\"pointsPerDraw\">{{App.i18n.pointsPerDraw}}</label>\n  <div class=\"col-sm-10 col-md-1\">\n    {{view App.NumberField id=\"pointsPerDraw\" classNames=\"form-control\" valueBinding=\"App.Tournament.drawPoints\"}}\n\n    <i rel=\"popover\" ref=\"points-per-draw\" class=\"hide fa fa-info-circle\" data-title=\"{{unbound App.i18n.pointsPerDraw}}\"></i>\n    <div id=\"points-per-draw\" class=\"hide\">{{App.i18n.pointsPerDrawHelp}}</div>\n  </div>\n</div>\n</fieldset>\n<fieldset>\n  <legend>{{App.i18n.koRound}}</legend>\n  <div class=\"form-group\">\n  <label class=\"control-label col-sm-2\" for=\"qualifierModus\">Modus</label>\n  <div class=\"col-sm-10 col-md-2\">\n    {{view Ember.Select id=\"qualifierModus\" contentBinding=\"view.qualifierModiOptions\" classNames=\"form-control\" \n        optionValuePath=\"content.id\" optionLabelPath=\"content.label\" valueBinding=\"App.Tournament.qualifierModus\"}}\n  </div>\n</div>\n</fieldset>\n\n  </form>\n  </div>\n  <div id=\"gameAttributes\" class=\"tab-pane\">\n<fieldset>\n  <legend>{{App.i18n.gameAttributes}}</legend>\n  <table class=\"table table-striped\">\n    <thead>\n    <tr>\n      <th style=\"text-align: left\">Name</th>\n      <th style=\"text-align: left\">Typ</th>\n      <th></th>\n    </tr>\n    </thead>\n    {{#each gameAttribute in App.Tournament.gameAttributes}}\n    <tr>\n      <td><div class=\"col-md-4\">{{view Em.TextField valueBinding=\"gameAttribute.name\" classNames=\"form-control\"}}</div></td>\n      <td><div class=\"col-md-6\">{{view Ember.Select contentBinding=\"view.gameAttributeOptions\" classNames=\"form-control\"\n        optionValuePath=\"content.type\" optionLabelPath=\"content.label\" valueBinding=\"gameAttribute.type\"}}</div></td>\n      <td>\n        <button class=\"btn btn-inverse\" rel=\"tooltip\" title=\"{{unbound App.i18n.deleteGameAttribute}}\" {{action \"remove\" target=\"gameAttribute\"}} type=\"button\">\n          <i class=\"fa fa-times\"></i>\n        </button>\n      </td>\n    </tr>\n    {{/each}}\n  </table>\n<span class='btn btn-inverse' {{action \"addAttribute\" target=\"view\"}}><i class=\"fa fa-plus\"></i>&nbsp;{{App.i18n.addAttribute}}</span>\n</fieldset>\n</div>\n\n  <div id=\"scheduling\" class=\"tab-pane\">\n    <fieldset>\n      <legend>{{App.i18n.timeCalculation}}</legend>\n      <form class=\"form-horizontal\">\n        <div class=\"form-group\">\n          <label class=\"control-label col-sm-2\" for=\"timePerGame\">{{App.i18n.timePerGame}}</label>\n          <div class=\"col-sm-10 col-md-1\">\n            {{view App.NumberField classNames=\"form-control\" id=\"timePerGame\" valueBinding=\"App.Tournament.timePerGame\"}}\n          </div>\n        </div>\n\n        <div class=\"form-group\">\n          <label class=\"control-label col-sm-2\" for=\"gamesParallel\">{{App.i18n.gamesParallel}}</label>\n          <div class=\"col-sm-10 col-md-1\">\n            {{view App.NumberField classNames=\"form-control\" id=\"gamesParallel\" valueBinding=\"App.Tournament.gamesParallel\"}}\n          </div>\n        </div>\n      </form>\n      <dl class=\"dl-horizontal\">\n        <dt>Rounds</dt>\n        <dd>{{view.roundCount}}</dd>\n        <dt>Total Games</dt>\n        <dd>{{view.gamesCount}}</dd>\n        <dt>Estimated total time</dt>\n        <dd>{{view.timeCount}} min</dd>\n      </dl>\n    </fieldset>\n  </div>\n</div>\n  </div>\n  </div>\n  </div>\n";

  App.TournamentSettings = App.DetailView.extend({
    template: Ember.Handlebars.compile(App.templates.tournamentPopup),
    tournament: null,
    didInsertElement: function() {
      this._super();
      this.$("[rel=popover]").popover({
        html: true,
        trigger: "hover",
        content: function() {
          return $("#" + ($(this).attr('ref'))).html();
        }
      });
      return this.$('#settings-navigation a').click(function(event) {
        event.preventDefault();
        console.debug(this);
        return $(this).tab('show');
      });
    },
    addAttribute: function() {
      return App.Tournament.gameAttributes.pushObject(App.GameAttribute.create());
    },
    roundCount: (function() {
      return this.get('tournament.length');
    }).property('tournament.@each'),
    gamesCount: (function() {
      return this.get('tournament').reduce(function(count, item) {
        return count += item.get('games.length');
      }, 0);
    }).property('tournament.@each'),
    timeCount: (function() {
      var minutes;
      minutes = this.get('gamesCount') * this.get('tournament.timePerGame') / this.get('tournament.gamesParallel');
      return minutes.toFixed();
    }).property('gamesCount', 'tournament.timePerGame', 'tournament.gamesParallel'),
    gameAttributeOptions: (function() {
      return [
        Em.Object.create({
          type: "checkbox",
          label: "Checkbox"
        }), Em.Object.create({
          type: "textfield",
          label: App.i18n.textfield
        }), Em.Object.create({
          type: "result",
          label: App.i18n.result
        }), Em.Object.create({
          type: "number",
          label: App.i18n.number
        })
      ];
    }).property(),
    qualifierModiOptions: (function() {
      return [App.qualifierModi.BEST_OF, App.qualifierModi.AGGREGATE];
    }).property()
  });

  App.IconButtonComponent = Ember.Component.extend({
    template: Ember.Handlebars.compile("<h5>\n  halllllllllllllllllllllllllllllo\n</h5>\nalsdkf")
  });

  App.PlayerLinkComponent = Ember.Component.extend({
    template: Ember.Handlebars.compile("<h5>\n  halllllllllllllllllllllllllllllo\n</h5>\nalsdkf"),
    didInsertElement: function() {
      return console.debug('huhu');
    }
  });

}).call(this);
