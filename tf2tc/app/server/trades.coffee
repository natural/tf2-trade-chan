## server-side module for trades
#
utils = require './utils'


exports.actions =
    userTrades: (params, cb) ->
        @getSession (session) ->
            if not session.user.loggedIn()
                cb {success:false, trades:null}

            user = if params.user? then params.user else session.user_id
            uid = utils.uidFromOpenId user
            getUserTrades uid, (trades) ->
                cb {success:true, trades:trades}

    publish: (params, cb) ->
        @getSession (session) ->
            if not session.user.loggedIn()
                cb {success:false, tid:null}

            uid = utils.uidFromOpenId session.user_id
            have = if params.have then (p for p in params.have when p) else []
            want = if params.want then (p for p in params.want when p) else []
            text = params.text or ''

            if not params.tid
                addTrade uid, have, want, text, (tid) ->
                    cb {success:true, tid:tid}

            else if params.tid and not have.length
                deleteTrade uid, params.tid, (trade) ->
                    cb {success:true, tid:params.tid}

            else
                updateTrade params.tid, have, want, text, () ->
                    cb {success:true, tid:params.tid}


addTrade = (uid, have, want, text, next) ->
    newTradeId uid, (tid) ->
        putTradePayload tid, have, want, text, (okay) ->
            for item in have
                fillTradeBuckets item, tid, ->
            next(tid)


deleteTrade = (uid, tid, next) ->
    getTrades [tid], (trades) ->
        R.lrem keys.userTrades(uid), 0, tid, () ->
            R.del keys.trade(tid), (err, count) ->
                trade = trades[tid]
                have = JSON.parse(trade).have
                for item in have
                    drainTradeBuckets item, tid, ->
                next()


updateTrade = (tid, have, want, text, next) ->
    getTrades [tid], (trades) ->
        trade = trades[tid]
        ## drain the buckets for the old have list
        for item in JSON.parse(trade).have
            drainTradeBuckets item, tid, ->
        putTradePayload tid, have, want, text, (okay) ->
            for item in have
                fillTradeBuckets item, tid, ->
            next()


getUserTrades = (uid, next) ->
    k = keys.userTrades uid
    R.lrange k, 0, -1, (err, ids) ->
        getTrades ids, (trades) ->
            next trades


getTrades = (tids, next) ->
    ks = (keys.trade(i) for i in tids)
    R.mget ks, (err, vals) ->
        trades = {}
        for id in tids
            v = vals[tids.indexOf(id)]
            trades[id.split(':').pop()] = v if v
        next trades


putTradePayload = (tid, have, want, text, next) ->
    k = keys.trade tid
    v = JSON.stringify {have:have, want:want, text:text}
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
            R.lpush keys.userTrades(uid), tid, (e, v) ->
                if not e and v?
                    next tid


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
