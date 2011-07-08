## steam apis
http = require('http')
libxmljs = require('libxmljs')

exports.actions =
  schema: (cb) ->
    o = urls.schema SS.config.local.steam_api_key
    get o, JSON.parse, cb

  items: (params, cb) ->
    o = urls.items params.id64, SS.config.local.steam_api_key
    get o, JSON.parse, cb

  profile: (params, cb) ->
    o = urls.profile params.id64, SS.config.local.steam_api_key
    get o, JSON.parse, (d) ->
      profile = d.response.players.player[0]
      profile.steamid = params.id64
      cb(profile)

  status: (params, cb) ->
    o = urls.status params.id64
    get o, parseStatus, cb

  news: (cb) ->
    o = urls.news 5, 256
    get o, JSON.parse, (d) ->
      news = d.appnews.newsitems.newsitem
      cb(news)


get = (opts, parse, cb) ->
  key = "#{opts.host}#{opts.path}"

  R.get key, (err, val) ->
    if val
      console.log 'cache hit', key
      cb if parse then parse val else val
    else
      console.log 'cache miss', key
      http.get opts, (res) ->
        res.setEncoding 'utf8'
        chunks = []
        res.on 'data', (c) ->
          chunks.push(c)
        res.on 'end', () ->
          str = chunks.join('')
          R.set key, str, (e, x) ->
            R.expire(key, 60*10)
            cb if parse then parse str else str


parseStatus = (v) ->
  x = libxmljs.parseXmlString(v)
  name: x.get('//steamID').text()
  state: x.get('//onlineState').text()
  avatar_full: x.get('//avatarFull').text()
  avatar_icon: x.get('//avatarIcon').text()
  avatar_medium: x.get('//avatarMedium').text()
  state_message: x.get('//stateMessage').text()


urls =
  schema: (key) ->
    host: 'api.steampowered.com'
    path: "/ITFItems_440/GetSchema/v0001/?format=json&language=en&key=#{key}"
    port: 80

  items: (id64, key) ->
    host: 'api.steampowered.com'
    path: "/ITFItems_440/GetPlayerItems/v0001/?key=#{key}&SteamID=#{id64}"
    port: 80

  profile: (id64, key) ->
    host: 'api.steampowered.com'
    path: "/ISteamUser/GetPlayerSummaries/v0001/?key=#{key}&steamids=#{id64}"
    port: 80

  status: (id64) ->
    host: 'steamcommunity.com'
    path: "/profiles/#{id64}/?xml=1"
    port: 80

  news: (count, max) ->
    host: 'api.steampowered.com'
    path: "/ISteamNews/GetNewsForApp/v0001/?appid=440&count=#{count}&maxlength=#{max}&format=json"
    port: 80
