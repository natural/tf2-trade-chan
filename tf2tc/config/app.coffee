# Main Application Config
# -----------------------
# Optional config files can be added to /config/environments/<SS_ENV>.coffee (e.g. /config/environments/development.coffee)
# giving you the opportunity to override each setting on a per-environment basis
# Tip: Type 'SS.config' into the SocketStream Console to see the full list of possible config options and view the current settings

fs = require('fs')


exports.config =

  # HTTP server (becomes secondary server when HTTPS is enabled)
  http:
    port:         3000
    hostname:     "0.0.0.0"

  # HTTPS server (becomes primary server if enabled)
  https:
    enabled:      false
    port:         443
    domain:       "www.socketstream.org"

  # HTTP(S) request-based API
  api:
    enabled:      true
    prefix:       'api'
    https_only:   false

  # Show customizable 'Incompatible Browser' page if browser does not support websockets
  browser_check:
    enabled:      false
    strict:       true


  openid_auth:
    verify_path: '/verify'
    authen_path: '/authenticate'
    success_path: '/'
    failure_path: '/'
    logout_path: '/logout'
    provider_url: 'https://steamcommunity.com/openid/'

  keygrip:
    keys: JSON.parse( fs.readFileSync('cookie_keys.nodist', 'utf8') )

  local:
    steam_api_key: fs.readFileSync('steam_api_key.nodist', 'utf8')
