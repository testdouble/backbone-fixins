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

Intended to be a view from which each application view will extend in order to DRY
  up the typical housekeeping normally carried out by Backbone.View subclasses (e.g.
  find template, plug in serialized context, render markup into element)

###

class Backbone.Fixins.SuperView extends Backbone.View
  render: ->
    template = config.templateFunction(superView.locateTemplate(@))
    context = superView.templateContext(@)
    @$el.html(template(context))

    for f in _(@).functions()
      @[f]() if fixins.helpers.startsWith(f, butIsntExactly: "render")

    @trigger('rendered')

superView =
  templateContext: (view) ->
    if view.templateContext?
      view.templateContext?() or view.templateContext
    else
      config.defaultTemplateContext(view)
  locateTemplate: (view) ->
    if view.template?
      view.template?() or view.template
    else
      config.defaultTemplateLocator(view)

###
Extendable Configuration.

Feel free to override the configuration to suit your project's needs.

Examples:
 - Suppose you want to grab your template functions from <script> elements on the DOM
   and compile them with underscore's _.template(). You could:

    Backbone.fixins.configure({
      templateFunction: function(name){
        templateSource = $('script[type="text/html"]#'+name).html();
        return _.template(templateSource);
      },
      defaultTemplateLocator: function(view){
        return Backbone.Fixins.helpers.constructorNameOf(view);
      }
    });

###

config = ogConfig =
  templateFunction: (name) ->
    root.JST[name]
  defaultTemplateContext: (view) ->
    (view.model or view.collection)?.toJSON() or {}
  defaultTemplateLocator: (view) ->
    name = fixins.helpers.constructorNameOf(view)
    "templates/#{fixins.helpers.titleToSnakeCase(name)}"

Backbone.Fixins.configure = (customConfigurationObject) ->
  config = fixins.helpers.merge(config, customConfigurationObject)

Backbone.Fixins.resetConfiguration = ->
  config = ogConfig

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
  merge: (orig, newStuff) ->
    _(orig).chain().clone().extend(newStuff).value()

