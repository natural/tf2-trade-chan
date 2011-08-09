class Set
    constructor: (values) ->
        @m = []
        @update values or []

    add: (value) ->
        if value not in @m
            @m.push value
        @

    update: (values) ->
        for k in values
            @add k
        @

    clear: ->
        @m = []

    contains: (value) ->
        value in @m

    copy: ->
        new Set [a for a in @m]

    difference: (other) ->
        x = new Set
        other = asSet other
        for k in @m
            if not other.contains k
                x.add k
        x

    members: ->
        @m

    remove: (value) ->
        p = @m.indexOf value
        if p > -1
            @m.splice p, 1
        @

    intersection: (other) ->
        x = new Set
        other = asSet other
        for k in @m
            if other.contains k
                x.add k
        x

    union: (other) ->
        x = new Set
        other = asSet other
        x.update @members()
        x.update other.members()
        x




module.exports = Set if module?

asSet = (v) ->
    if v.members
        v
    else if v.splice
        new Set v
    else
        new Set [a for a of v]


asArray = (v) ->
    if v.splice
        v
    else
        [v]