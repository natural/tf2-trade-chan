## server-side module for trades
#
utils = require './utils'


exports.actions =
    ## pass in params.user to retrieve trades for a specific user; if
    ## params.user not given, callback receives trades for current
    ## session user.
    userTrades: (params, cb) ->
        @getSession (session) ->
            if not session.user.loggedIn()
                cb {success:false, trades:null}
            uid = utils.uidFromOpenId (if params.user? then params.user else session.user_id)
            getUserTrades uid, (ids) ->
                getTrades ids, (trades) ->
                    cb {success:true, trades:trades}


    publish: (params, cb) ->
        @getSession (session) ->
            if not session.user.loggedIn()
                cb {success:false, tid:null}

            uid = utils.uidFromOpenId session.user_id
            have = if params.have then (p for p in params.have when p) else []
            want = if params.want then (p for p in params.want when p) else []

            ## add trade
            if not params.tid
                newTradeId uid, (tid) ->
                    setTrade tid, have, want, (okay) ->
                        for item in have
                            fillTradeBuckets item, tid, ->
                        cb {success:true, tid:tid}

            ## delete trade
            else if params.tid and not have.length
                delTradeId uid, params.tid, (trade) ->
                    have = JSON.parse(trade).have
                    for item in have
                        drainTradeBuckets item, params.tid, ->
                    cb {success:true, tid:null}

            ## update trade
            else
                utils.log "UPD TRADE"
                cb {success:false, tid:null}


getUserTrades = (uid, next) ->
    k = keys.userTrades uid
    R.lrange k, 0, -1, (err, ids) ->
        next ids


getTrades = (tids, next) ->
    ks = (keys.trade(i) for i in tids)
    R.mget ks, (err, vals) ->
        trades = {}
        for id in tids
            v = vals[tids.indexOf(id)]
            trades[id.split(':').pop()] = v if v
        next trades


setTrade = (tid, have, want, next) ->
    k = keys.trade tid
    v = JSON.stringify {have:have, want:want}
    R.set k, v, () ->
        next true ## set can't fail


fillTradeBuckets = (item, tid, next) ->
    for key in keys.tradeBuckets item
        R.lpush key, tid, ->
    next()


drainTradeBuckets = (item, tid, next) ->
    for key in keys.tradeBuckets item
        R.lrem key, 0, tid, ->
    next()


newTradeId = (uid, next) ->
    R.incr keys.globalTradeCounter, (err, tid) ->
        if not err and tid?
            ## assign the tid to the user
            R.lpush keys.userTrades(uid), tid, (e, v) ->
                if not e and v?
                    next tid


delTradeId = (uid, tid, next) ->
    getTrades [tid], (trades) ->
        R.lrem keys.userTrades(uid), 0, tid, () ->
            R.del keys.trade(tid), (err, count) ->
                next trades[tid]


keys =
    ## this key is used to generate trade ids.
    globalTradeCounter: 'globalTradeCounter'

    ## given a trade id, this creates a key for it.
    trade: (id) ->
        "trade:#{id}"

    ## given a user id, this creates a key for holding the list of
    ## trades associated with the user.
    userTrades: (id) ->
        "user:#{id}:trades"

    tradeBuckets: (defn) ->
        q = if defn.quality? then defn.quality else defn.item_quality
        ["itembucket:#{defn.defindex}:#{q}"]
