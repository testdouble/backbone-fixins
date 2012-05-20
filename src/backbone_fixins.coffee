###
 backbone-fixins @@VERSION@@

 Boilerplate that strengthens your backbone

 site: https://github.com/testdouble/backbone-fixins
###

root = this

unless root.Backbone? then throw "backbone-fixins requires Backbone. Make sure you load Backbone first"

root.Backbone.Fixins ||= {}



