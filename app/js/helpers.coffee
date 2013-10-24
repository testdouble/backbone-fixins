###
# Random helpers. Pretend these are private, but I won't hide them
#   in the event you have a really good reason to override them.
###

Backbone.Fixins.helpers =
  constructorNameOf: (obj) ->
    results = /function (.{1,})\(/.exec(obj.constructor.toString())
    (if (results and results.length > 1) then results[1] else "")
  titleToSnakeCase: (titleCasedString) ->
    titleCasedString.replace(/([a-z\d])([A-Z]+)/g, '$1_$2').replace(/[-\s]+/g, '_').toLowerCase();
  startsWith: (str, options) ->
    starts = options.butIsntExactly
    str.length > starts.length and str.substr(0, starts.length) is starts
  merge: (orig, newStuff) ->
    _(orig).chain().clone().extend(newStuff).value()

