###
backbone-fixins @@VERSION@@
Boilerplate that strengthens your backbone
site: https://github.com/testdouble/backbone-fixins
###

root = this


unless root.Backbone? then throw "backbone-fixins requires Backbone. Make sure you load Backbone first"

fixins = root.Backbone.Fixins ||= {}

###
SuperView
###

class fixins.SuperView extends Backbone.View
  render: ->
    template = config.templateFunction(config.locateTemplate(@))
    context = config.templateContext(@)
    template(context)


###
Extendable Configuration.

Feel free to extend the configuration to suit your project's needs.

For example, you might write:



###

# Backbone.Fixins.configure = (customConfigurationObject) ->
#   config = _(config).extend(customConfigurationObject)

config =
  templateFunction: (name) ->
    root.JST[name]
  locateTemplate: (view) ->
    name = fixins.helpers.constructorNameOf(view)
    "templates/#{fixins.helpers.titleToSnakeCase(name)}"
  templateContext: (view) ->
    view.model.toJSON()

fixins.helpers =
  constructorNameOf: (obj) ->
    results = /function (.{1,})\(/.exec(obj.constructor.toString())
    (if (results and results.length > 1) then results[1] else "")
  titleToSnakeCase: (titleCasedString) ->
    titleCasedString.replace(/([a-z\d])([A-Z]+)/g, '$1_$2').replace(/[-\s]+/g, '_').toLowerCase();

