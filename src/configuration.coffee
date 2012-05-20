###
Extendable Configuration.

Feel free to override the configuration to suit your project's needs.

###

root = this
fixins = root.Backbone.Fixins

fixins.configuration = ogConfig =
  templateFunction: (name) ->
    root.JST[name]
  defaultTemplateContext: (view) ->
    (view.model or view.collection)?.toJSON() or {}
  defaultTemplateLocator: (view) ->
    name = fixins.helpers.constructorNameOf(view)
    "templates/#{fixins.helpers.titleToSnakeCase(name)}"

fixins.configure = (customConfigurationObject) ->
  fixins.configuration = fixins.helpers.merge(fixins.configuration, customConfigurationObject)

fixins.resetConfiguration = ->
  fixins.configuration = ogConfig