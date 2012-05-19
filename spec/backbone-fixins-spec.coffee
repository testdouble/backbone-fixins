root = this

describe "Backbone.Fixins.SuperView", ->
  describe "subview classes", ->
    Given -> @model = jasmine.createStubObj('model', toJSON: "some JSON")
    Given -> fakeJST('templates/sub_view').when("some JSON").thenReturn('<div class="HTML"></div>')

    context "the simplest view", ->
      Given -> @subView = class SubView extends Backbone.Fixins.SuperView
      Given -> @subject = new @subView(model: @model)
      When -> @subject.render()
      Then -> @subject.$('.HTML').length == 1

    context "a view that has some extra render-time behavior", ->
      Given -> @subView = class SubView extends Backbone.Fixins.SuperView
        renderSomeDetail: ->
      Given -> @subject = new @subView(model: @model)
      Given -> spyOn(@subject, "renderSomeDetail")
      When -> @subject.render()
      Then -> expect(@subject.renderSomeDetail).toHaveBeenCalled()

    context "a view that needs to dynamically bind post-render behavior", ->
      spy = null
      Given -> spy = jasmine.createSpy()
      Given -> @subView = class SubView extends Backbone.Fixins.SuperView
        initialize: ->
          @bind('rendered', @fooPants)
        fooPants: spy
      Given -> @subject = new @subView(model: @model)
      When -> @subject.render()
      Then -> expect(spy).toHaveBeenCalled()


    context "manually specifying a template name in the subview", ->

      sharedExamplesFor "rendering a custom template", ->
        Given -> fakeJST('dont_tell_me_where_to_stick_my_template').when("some JSON").thenReturn('<div class="myHTML"></div>')
        Given -> @subject = new @subView(model: @model)
        When -> @subject.render()
        Then -> @subject.$('.myHTML').length == 1

      context "as a string", ->
        Given -> @subView = class SubView extends Backbone.Fixins.SuperView
          template: "dont_tell_me_where_to_stick_my_template"
        itBehavesLike "rendering a custom template"

      context "as a function", ->
        Given -> @subView = class SubView extends Backbone.Fixins.SuperView
          template: -> "dont_tell_me_where_to_stick_my_template"
        itBehavesLike "rendering a custom template"

#    context "a view with a collection instead of a model", pending
#    context "a view with deeply nested namespace", pending
#    context "manually specifying a way to retrieve templates", pending

