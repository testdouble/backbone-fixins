###
Backbone.Fixins.SuperView

Intended to be a view from which each application view will extend in order to DRY
  up the typical housekeeping normally carried out by Backbone.View subclasses (e.g.
  find template, plug in serialized context, render markup into element)

###

root = this
fixins = root.Backbone.Fixins

class Backbone.Fixins.SuperView extends root.Backbone.View
  render: ->
    template = fixins.configuration.templateFunction(superView.locateTemplate(@))
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
      fixins.configuration.defaultTemplateContext(view)
  locateTemplate: (view) ->
    if view.template?
      view.template?() or view.template
    else
      fixins.configuration.defaultTemplateLocator(view)
