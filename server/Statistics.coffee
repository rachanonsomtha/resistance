class Statistics
    ctor: (@db) ->
        @lastRefresh = 0
        
    get: (param) ->
        @refresh()
        return @stats[param] or ""
        
    refresh: ->
        now = Date.now()
        return if now - @lastRefresh < 5 * 60 * 1000   # five minute refresh period
        tables = @db.getTables()
        @lastRefresh = now
        @stats = 
            leaderboard: @getLeaderboard(tables)
            recentgames: @getRecentGames(tables)
            winrates: @getWinRates(tables)
            activity: @getActivity()
            
    getLeaderboard: (tables) ->
        now = Date.now()
        oneMonth = 30 * 24 * 3600 * 1000
        for gameplayer in tables.gamePlayers
            table.players lastGameTime, spyWin, spyGame, resistanceWin, resistanceGame
            table.games spies, resistance
            
        html = "<table><tr><th>Player</th> <th>Resistance</th> <th>Spy</th> <th>Total</th></tr>"
        filteredPlayers = tables.players
            .filter((i) => i.lastGameTime? and now - i.lastGameTime < oneMonth)
            .sort((a,b) -> a.toLowerCase().localeCompare(b.toLowerCase()))
            
        for player in filteredPlayers
            html += "<tr>" +
                "<td>#{player.Name}</td> " +
                "<td>#{@frac(player.spyWin, player.spyGame)}</td> " +
                "<td>#{@frac(player.resistanceWin, player.resistanceGame)}</td> " +
                "<td>#{@frac(player.spyWin + player.resistanceWin, player.spyGame + player.resistanceGame)}</td></tr>"
                
        html += "</table>"
        return html
        
    getRecentGames: (tables) ->
        html = "<table><tr><th>Start Time</th> <th>Type</th> <th>Duration (min)</th> <th>Resistance</th> <th>Spies</th></tr>"
        
        for i in [0 ... 25]
            game = tables.game[i]
            html += "<tr>" +
                "<td>#{game.startTime.toUTCString()}</td> " +
                "<td>#{game.type}</td> " +
                "<td>#{(game.endTime.getTime() - game.startTime.getTime()) / 60000}</td> " +
                "<td>#{game.resistance.map((i) => i.Name).join(', ')}</td> " +
                "<td>#{game.spies.map((i) => i.Name).join(', ')}</td></tr>" +
            
        html += "</table>"
        return html
        
    getWinRates: (tables) ->    
        html = "<table><tr><th></th> <th>Original</th> <th>Avalon</th> <th>Basic</th></tr>"
        html += "</table>"
        return html
        
    getActivity: (tables) ->
        html = "NYI"
        return html