
exports.strange_text = (c) ->
    t = ''
    t = 'Strange'              if 0 <= c <= 10
    t = 'Unremarkable'         if 10 <= c < 25
    t = 'Scarcely Lethal'      if 25 <= c < 45
    t = 'Mildly Menacing'      if 45 <= c < 70
    t = 'Somewhat Threatening' if 70 <= c < 100
    t = 'Uncharitable'         if 100 <= c < 135
    t = 'Notably Dangerous'    if 135 <= c < 175
    t = 'Sufficiently Lethal'  if 175 <= c < 225
    t = 'Truly Feared'         if 225 <= c < 275
    t = 'Spectacularly Lethal' if 275 <= c < 350
    t = 'Gore-Spattered'       if 350 <= c < 500
    t = 'Wicked Nasty'         if 500 <= c < 750
    t = 'Positively Inhumane'  if 750 <= c < 999
    t = 'Totally Ordinary'     if 999 <= c < 1000
    t = 'Face-Melting'         if 1000 <= c < 1500
    t = 'Rage-Inducing'        if 1500 <= c < 2500
    t = 'Server-Clearing'      if 2500 <= c < 5000
    t = 'Epic'                 if 5000 <= c < 7500
    t = 'Legendary'            if 7500 <= c < 7616
    t = 'Australian'           if 7616 <= c < 8500
    t = "Hale's Own"           if 8500 <= c < 10000
    t


exports.item_effects =
    4:  'Community Sparkle'
    5:  'Holy Glow'
    6:  'Green Confetti'
    7:  'Purple Confetti'
    8:  'Haunted Ghosts'
    9:  'Green Energy'
    10: 'Purple Energy'
    11: 'Circling TF Logo'
    12: 'Massed Flies'
    13: 'Burning Flames'
    14: 'Scorching Flames'
    15: 'Searing Plasma'
    16: 'Vivid Plasma'
    17: 'Sunbeams'
    18: 'Circling Peace Sign'
    19: 'Circling Heart'
    20: 'Map Stamps'


exports.value_format_map =
  value_is_additive: (a) -> a
  value_is_particle_index: (a) -> a
  value_is_or: (a) -> a
  value_is_percentage: (v) -> Math.round(v*100 - 100)
  value_is_inverted_percentage: (v) -> Math.round(100 - (v*100))
  value_is_additive_percentage: (v) -> Math.round(100*v)
  value_is_date: (v) -> new Date(v * 1000)
  value_is_account_id: (v) -> '7656' + (v + 1197960265728)


profile_cache = {}

exports.get_profile = (id64, cb) ->
    if profile_cache[id64]
        cb profile_cache[id64]
    else
        SS.server.app.user_profile id64:id64, (p) ->
            profile_cache[id64] = p
            cb p


exports.format_schema_attr = (def, val) ->
    line = if (def and def.description_string) then def.description_string.replace(/\n/gi, '<br />') else ''
    ## we only sub one '%s1'; that's the most there is (as of oct 2010)
    if line.indexOf('%s1') > -1
        line = line.replace('%s1', exports.value_format_map[def['description_format']](val))
    if line.indexOf('Attrib_') > -1
        line = ''
    line





exports.make_backpack = (ns, bp) ->
    ns.backpack = bp
    ns.backpack_items = items = {} # backpack item mapping by defindex
    for item in bp.result.items.item
        do (item) -> items[item.inventory & 0xFFFF] = item


exports.make_schema = (ns, sch) ->
    ns.schema = sch
    ns.schema_items = items = {} # schema item mapping by defindex
    for item in sch.result.items.item
        do (item) -> items[item.defindex] = item

    ns.schema_attribs = attribs = {}
    for attr in sch.result.attributes.attribute
        do (attr) ->
            attribs[attr.name] = attr
            attribs[attr.defindex] = attr

    ns.schema_qualities = quals = {}
    for name, idx of sch.result.qualities
        do (name, idx) ->
            quals[idx] = sch.result.qualityNames[name]

    ns.schema_actions = -> (i for i in sch.result.items.item when i.item_slot=='action')
    ns.schema_tools = ->   (i for i in sch.result.items.item when i.craft_class=='tool')
