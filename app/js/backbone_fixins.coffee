root = this

unless root.Backbone? then throw "backbone-fixins requires Backbone. Make sure you load Backbone first"

root.Backbone.Fixins ||= {}



