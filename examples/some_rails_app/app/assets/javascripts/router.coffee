class App.Router extends Backbone.Router
  routes:
    "super_view/simple": "simpleSuperView"
    "*path": "index"

  initialize: ->
    @root = $('#application')[0]

  index: ->
    new App.IndexView(el: @root).render()

  simpleSuperView: ->
    new App.SimpleSuperView(el: @root).render()
