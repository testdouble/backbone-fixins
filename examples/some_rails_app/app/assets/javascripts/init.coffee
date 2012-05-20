root = this

root.App ||= {}

$ ->
  root.router = new App.Router
  Backbone.history.start()