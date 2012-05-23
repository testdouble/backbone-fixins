class App.ComplexSuperView extends Backbone.Fixins.SuperView
  template: "templates/some_complex_view"

  initialize: ->
    @bind('rendered', @appendEvenMoreFinePrint)

  templateContext: ->
    typeOfClass: "super complex"

  renderFinePrint: ->
    @$el.append('<div>*fine print, though.</div>')

  appendEvenMoreFinePrint: ->
    @$el.append('<div>*yet finer print.</div>')
