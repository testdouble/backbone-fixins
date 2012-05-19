root = this

describe "Backbone.Fixins.SuperView", ->
  # class SubView extends Backbone.Fixins.SuperView
  #   template: "templates/sub_view"
  #   serialize: -> @model.toJSON()
  #   renderGlitter: ->

  Given -> root.JST ||= {}

  describe "templating", ->
    context "using the simplest possible subclass (JST, templates/)", ->
      Given -> @subView = class SubView extends Backbone.Fixins.SuperView

      Given -> @model = jasmine.createStubObj('model', toJSON: "some JSON")
      Given -> fake(JST, 'templates/sub_view', jasmine.createSpy())
      Given -> @subject = new @subView(model: @model)
      When -> @subject.render()
      Then -> expect(JST['templates/sub_view']).toHaveBeenCalledWith("some JSON")




    context "manually specifying a template name in the sub view", ->

    context "manually specifying a way to retrieve templates", ->

