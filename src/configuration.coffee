###
Extendable Configuration.

Feel free to override the configuration to suit your project's needs.

Examples:
 - Suppose you want to grab your template functions from <script> elements on the DOM
   and compile them with underscore's _.template(). You could:

    Backbone.Fixins.configure({
      templateFunction: function(name){
        templateSource = $('script[type="text/html"]#'+name).html();
        return _.template(templateSource);
      },
      defaultTemplateLocator: function(view){
        return Backbone.Fixins.helpers.constructorNameOf(view);
      }
    });

###

root = this

Backbone.Fixins.configuration = ogConfig =
  templateFunction: (name) ->
    root.JST[name]
  defaultTemplateContext: (view) ->
    (view.model or view.collection)?.toJSON() or {}
  defaultTemplateLocator: (view) ->
    name = Backbone.Fixins.helpers.constructorNameOf(view)
    "templates/#{Backbone.Fixins.helpers.titleToSnakeCase(name)}"

Backbone.Fixins.configure = (customConfigurationObject) ->
  Backbone.Fixins.configuration = Backbone.Fixins.helpers.merge(Backbone.Fixins.configuration, customConfigurationObject)

Backbone.Fixins.resetConfiguration = ->
  Backbone.Fixins.configuration = ogConfig