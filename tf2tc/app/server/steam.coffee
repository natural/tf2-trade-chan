## steam apis
#

http = require 'http'
libxmljs = require 'libxmljs'
ext = require './schema_ext'
utils = require './utils'

exports.actions =
    schema: (cb) ->
        o = urls.schema SS.config.local.steam_api_key
        schemaTweak = (d) ->
            sch = JSON.parse d
            sch.ext =
                groups: ext.actions.allGroups()
                quals: ext.actions.qualCycle()
            ks = (Number(k) for k, j of imgFixes)
            for k, n of sch.result.items.item
                if n.defindex in ks
                    n.image_url = imgFixes[n.defindex]
            sch
        get o, schemaTweak, cb

    items: (params, cb) ->
        o = urls.items params.id64, SS.config.local.steam_api_key
        get o, JSON.parse, cb

    profile: (params, cb) ->
        o = urls.profile params.id64, SS.config.local.steam_api_key
        get o, JSON.parse, (d) ->
            try
                profile = d.response.players.player[0]
                profile.steamid = params.id64
                cb profile
            catch err
                cb {}

    status: (params, cb) ->
        o = urls.status params.id64
        get o, statusKeys, cb

    news: (cb) ->
        o = urls.news 5, 256
        get o, JSON.parse, (d) ->
            news = d.appnews.newsitems.newsitem
            cb(news)


httpGet = (options, cb) ->
    options.method = 'GET'
    req = http.request(options, cb)
    #req.connection.setTimeout 2*250
    req.end()
    req



get = (opts, parse, cb) ->
    key = "#{opts.host}#{opts.path}"
    R.get key, (err, val) ->
        if val
            utils.log "steam data cache hit #{key}"
            cb(if parse then parse val else val)
        else
            utils.log "steam data cache miss #{key}"
            req = httpGet opts, (res) ->
                res.setEncoding 'utf8'
                chunks = []
                res.on 'data', (c) ->
                    chunks.push(c)
                res.on 'end', (e) ->
                    cb null
                res.on 'end', () ->
                    if res.statusCode == 200
                        str = chunks.join ''
                        R.setex key, opts.ttl, str, (e, x) ->
                            cb(if parse then parse str else str)
                    else
                        cb null



urls =
    schema: (key) ->
        host: 'api.steampowered.com'
        path: "/ITFItems_440/GetSchema/v0001/?format=json&language=en&key=#{key}"
        port: 80
        ttl: 60*60

    items: (id64, key) ->
        host: 'api.steampowered.com'
        path: "/ITFItems_440/GetPlayerItems/v0001/?key=#{key}&SteamID=#{id64}"
        port: 80
        ttl: 60*5

    profile: (id64, key) ->
        host: 'api.steampowered.com'
        path: "/ISteamUser/GetPlayerSummaries/v0001/?key=#{key}&steamids=#{id64}"
        port: 80
        ttl: 60*10

    status: (id64) ->
        host: 'steamcommunity.com'
        path: "/profiles/#{id64}/?xml=1"
        port: 80
        ttl: 60*5

    news: (count, max) ->
        host: 'api.steampowered.com'
        path: "/ISteamNews/GetNewsForApp/v0001/?appid=440&count=#{count}&maxlength=#{max}&format=json"
        port: 80
        ttl: 60*15


statusKeys = (v) ->
    x = libxmljs.parseXmlString(v)
    name: x.get('//steamID').text()
    state: x.get('//onlineState').text()
    avatarFull: x.get('//avatarFull').text()
    avatarIcon: x.get('//avatarIcon').text()
    avatarMedium: x.get('//avatarMedium').text()
    stateMessage: x.get('//stateMessage').text()


imgFixes =
    5027: '/images/paints/TF_Tool_PaintCan_1.png'      # Indubitably Green
    5028: '/images/paints/TF_Tool_PaintCan_2.png'      # Zephaniah's Greed
    5029: '/images/paints/TF_Tool_PaintCan_3.png'      # Noble Hatter's Violet
    5030: '/images/paints/TF_Tool_PaintCan_4.png'      # Color No. 216-190-216
    5031: '/images/paints/TF_Tool_PaintCan_5.png'      # A Deep Commitment to Purple
    5032: '/images/paints/TF_Tool_PaintCan_6.png'      # Mann Co. Orange
    5033: '/images/paints/TF_Tool_PaintCan_7.png'      # Muskelmannbraun
    5034: '/images/paints/TF_Tool_PaintCan_8.png'      # Peculiarly Drab Tincture
    5035: '/images/paints/TF_Tool_PaintCan_9.png'      # Radigan Conagher Brown
    5036: '/images/paints/TF_Tool_PaintCan_10.png'     # Ye Olde Rustic Colour
    5037: '/images/paints/TF_Tool_PaintCan_11.png'     # Australium Gold
    5038: '/images/paints/TF_Tool_PaintCan_12.png'     # Aged Moustache Grey
    5039: '/images/paints/TF_Tool_PaintCan_13.png'     # An Extraordinary Abundance of Tinge
    5040: '/images/paints/TF_Tool_PaintCan_14.png'     # A Distinctive Lack of Hue
    5051: '/images/paints/TF_Tool_PaintCan_15.png'     # Pink as Hell
    5052: '/images/paints/TF_Tool_PaintCan_16.png'     # A Color Similar to Slate
    5053: '/images/paints/TF_Tool_PaintCan_17.png'     # Drably Olive
    5054: '/images/paints/TF_Tool_PaintCan_18.png'     # The Bitter Taste of Defeat and Lime
    5055: '/images/paints/TF_Tool_PaintCan_19.png'     # The Color of a Gentlemann's Business Pants
    5056: '/images/paints/TF_Tool_PaintCan_20.png'     # Dark Salmon Injustice
    5060: '/images/paints/TF_Tool_PaintCan_5060.png'   # operators overalls
    5061: '/images/paints/TF_Tool_PaintCan_5061.png'   # waterlogged lab coat
    5062: '/images/paints/TF_Tool_PaintCan_5062.png'   # balaclavas are forever
    5063: '/images/paints/TF_Tool_PaintCan_5063.png'   # air of debonair
    5064: '/images/paints/TF_Tool_PaintCan_5064.png'   # value of teamwork
    5065: '/images/paints/TF_Tool_PaintCan_5065.png'   # cream spirit
