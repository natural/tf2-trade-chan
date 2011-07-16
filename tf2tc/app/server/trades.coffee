
exports.actions =
    publish: (params, cb) ->
        if not @session.user.loggedIn()
            cb {success:false}
        have = params.have
        want = params.want
        uid = uid_from_openid @session.user_id
        ## generate trade id
        next_trade_id uid, (trade_id) ->
            console.log "TRADE ID #{trade_id} FOR USER #{uid}"

        ## for each have.defindex, place the trade id into each defindex:quality bucket
        ## for each have.defindex, publish the trade to each ???:quality channel

        cb {success:true}


keys =
    global_trade: 'tf2tc:trade_counter'
    user_trades: (uid) ->
        "tid:#{uid}"


uid_from_openid = (openid) ->
    openid.split('/').pop()


next_trade_id = (uid, next) ->
    R.incr keys.global_trade, (err, tid) ->
        if not err and tid?
            ## need to add hook to session disconnect to remove
            ## the user trade key "tid:#{uid}"

            ## set the user:#{tradeid} key to the trade (as string)
            R.lpush keys.user_trades(uid), tid, (e, v) ->
                if not e and v?
                    next(tid)
