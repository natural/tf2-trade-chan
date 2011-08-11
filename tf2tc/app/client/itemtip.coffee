##
# item tooltip:
#
# this module exports two functions, show and hide, for mouse hover
# events over game items.  the client application associates the mouse
# events for div.item elements with these routines.


exports.hide = (e) ->
    $('#itemtip').hide()


exports.show = (e) ->
    tip = exports.hide()
    item = $ e.currentTarget
    sdef = item.data 'schema-defn'

    if !sdef
        return

    idef = item.data 'item-defn'
    ns = e.data.namespace
    util = SS.client.util
    vals = defaults()
    iuid = idef.id

    # determine the item name
    type = sdef.item_type_name
                .replace('TF_Wearable_Hat', 'Wearable Item')
                .replace('TF_LockedCrate', 'Crate')
    vals.level = "Level #{idef.level} #{type}" if idef.level?
    if idef.custom_name
        vals.name =  "\"#{idef.custom_name}\""
    else
        # this could be better
        vals.name = sdef.item_name
    vals.name = "#{ns.schema_qualities[idef.quality]} " + vals.name if idef.quality in [1, 3, 5, 11]

    # clear the quality classes and add the correct one
    $('.name', tip).resetQualityClasses("qual-text-#{idef.quality or 6}")

    # clear the crafter value.  nb: crafter isn't set via the 'vals'
    # object because of the async lookup
    $('.crafter', tip).text ''

    # set the control text
    ctrl_text = ->
        i = JSON.stringify idef, null, 2
        s = JSON.stringify sdef, null, 2
        "item: #{i}\n\nschema: #{s}"
    vals.ctrl = "<pre>#{ctrl_text()}</pre>" if e.ctrlKey

    if idef.attributes
        for adef in idef.attributes.attribute
            sadef = ns.schema_attribs[adef.defindex]
            extra = util.attrFormat sadef, adef.value
            etype = if sadef then sadef.effect_type else null
            switch adef.defindex
                when 134 # effect name
                    vals[etype] = util.attrFormat sadef, util.effectNames[adef.float_value]

                when 186 # gift
                    acc = util.formats.value_is_account_id adef.value
                    $('.crafter', tip).text "Gift from #{acc}."
                    util.readProfile acc, (p, id=iuid) ->
                        $('.crafter', tip).text "Gift from #{p.personaname}." if id==idef.id

                when 187 # crate series
                    vals[etype] = util.attrFormat sadef, adef.float_value

                when 214 # kill eater
                    vals.killeater = "Kills: #{adef.value}"
                    vals.name = vals.name.replace 'Strange', util.strangeName(adef.value)

                when 228 # craft name
                    acc = util.formats.value_is_account_id adef.value
                    $('.crafter', tip).text "Crafted by #{acc}."
                    util.readProfile acc, (p, id=iuid) ->
                        $('.crafter', tip).text "Crafted by #{p.personaname}." if id==idef.id

                when 229 # craft number
                    vals.name = "#{vals.name} ##{adef.value}"

                else
                    vals[etype] += "<br>#{extra}" if extra

    if sdef.attributes
        skips = ['set_employee_number', 'supply_crate_series']
        for atyp in sdef.attributes.attribute
            sadef = ns.schema_attribs[atyp.name]
            if sadef and sadef.attribute_class not in skips
                text = util.attrFormat sadef, atyp.value
                curr = vals[sadef.effect_type]
                vals[sadef.effect_type] = if curr then "#{curr}<br>#{text}" else text

    # reset the item description
    if sdef.item_description or idef.custom_desc
        desc = if idef.custom_desc then "\"#{idef.custom_desc}\"" else sdef.item_description
        if desc.indexOf('\n') > -1
            desc = desc.replace(/\n/g, '<br>')
        else
            desc = desc.wordwrap(64)
        vals.alt = if vals.alt then "#{vals.alt} <br> #{desc}" else desc


    # set limited use count
    if idef.defindex in (t.defindex for t in ns.schema_tools()) or idef.defindex in (t.defindex for t in ns.schema_actions())
        if idef.quantity?
            vals.limiteduse = "<br>This is a limited use item.  Uses: #{idef.quantity}"

    # set the untradable text
    if idef.flag_cannot_trade
        vals.untradable = '<br>( Not Tradable )'

    # set the values
    for k, v of vals
        $(".#{k}", tip).html v

    # position and show
    left = item.offset().left + (item.width()/2) - (tip.width()/2)
    top = item.offset().top + item.height()
    tip.css {left:Math.max(0, left), top:top}
    tip.show()



defaults = ->
    alt: ''
    ctrl: ''
    killeater: ''
    level: ''
    limiteduse: ''
    name: ''
    negative: ''
    neutral:''
    positive: ''
    untradable: ''
