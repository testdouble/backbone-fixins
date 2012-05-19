###
backbone-fixins @@VERSION@@
Boilerplate that strengthens your backbone
site: https://github.com/testdouble/backbone-fixins
###

root = this
Backbone = root.Backbone

unless Backbone? then throw "backbone-fixins requires Backbone. Make sure you load Backbone first"

fixins = Backbone.Fixins ||= {}

###
Backbone.Fixins.SuperView

Intended to be a view you can extend that does the typical housekeeping
  of any application-owned view (find template, plug in serialized context, render into element)
###

class Backbone.Fixins.SuperView extends Backbone.View
  render: ->
    template = config.templateFunction(config.locateTemplate(@))
    context = config.templateContext(@)
    @$el.html(template(context))

    for f in _(@).functions()
      @[f]() if fixins.helpers.startsWith(f, butIsntExactly: "render")

    @trigger('rendered')


###
Extendable Configuration.

Feel free to extend the configuration to suit your project's needs.

For example, you might write: ???
###

# Backbone.Fixins.configure = (customConfigurationObject) ->
#   config = _(config).extend(customConfigurationObject)


config =
  templateFunction: (name) ->
    root.JST[name]
  locateTemplate: (view) ->
    if view.template?
      view.template?() or view.template
    else
      name = fixins.helpers.constructorNameOf(view)
      "templates/#{fixins.helpers.titleToSnakeCase(name)}"
  templateContext: (view) ->
    if view.templateContext?
      view.templateContext?() or view.templateContext
    else
     (view.model or view.collection)?.toJSON() or {}

###
# Random helpers. Pretend these are private, but I won't hide them
#   in the event you have a really good reason to override them.
###

fixins.helpers =
  constructorNameOf: (obj) ->
    results = /function (.{1,})\(/.exec(obj.constructor.toString())
    (if (results and results.length > 1) then results[1] else "")
  titleToSnakeCase: (titleCasedString) ->
    titleCasedString.replace(/([a-z\d])([A-Z]+)/g, '$1_$2').replace(/[-\s]+/g, '_').toLowerCase();
  startsWith: (str, options) ->
    starts = options.butIsntExactly
    str.length > starts.length and str.substr(0, starts.length) is starts

