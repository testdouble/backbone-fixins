root = this

describe "Backbone.Fixins.SuperView", ->
  describe "subview classes", ->
    Given -> @subView = class SubView extends Backbone.Fixins.SuperView
    Given -> @model = jasmine.createStubObj('model', toJSON: "some JSON")
    Given -> @fakeJst = fakeJST('templates/sub_view').when("some JSON").thenReturn('<div class="HTML"></div>')

    context "the simplest view", ->
      Given -> @subject = new @subView(model: @model)
      When -> @subject.render()
      Then -> expect(@subject.el).toHas('.HTML')

    describe "the context object passed into the template", ->
      context "a view with a collection (but no model)", ->
        Given -> @subject = new @subView(collection: @model)
        When -> @subject.render()
        Then -> expect(@subject.el).toHas('.HTML')

      context "a view with neither collection nor model", ->
        Given -> @fakeJst.when({}).thenReturn('<div class="moarHTML"></div>')
        Given -> @subject = new @subView()
        When -> @subject.render()
        Then -> expect(@subject.el).toHas('.moarHTML')

      context "a view with a custom templateContext", ->
        sharedExamplesFor "a custom templateContext", ->
          Given -> @fakeJst.when("custom JSON").thenReturn('<div class="lolhtml"></div>')
          Given -> @subject = new @subView(model: @model)
          When -> @subject.render()
          Then -> expect(@subject.el).toHas('.lolhtml')

        context "as a function", ->
          Given -> @subView = class SubView extends Backbone.Fixins.SuperView
            templateContext: -> "custom JSON"
          itBehavesLike "a custom templateContext"

        context "as a string", ->
          Given -> @subView = class SubView extends Backbone.Fixins.SuperView
            templateContext: "custom JSON"
          itBehavesLike "a custom templateContext"


    describe "render-time behaviors", ->
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
        Then -> expect(@subject.el).toHas('.myHTML')

      context "as a string", ->
        Given -> @subView = class SubView extends Backbone.Fixins.SuperView
          template: "dont_tell_me_where_to_stick_my_template"
        itBehavesLike "rendering a custom template"

      context "as a function", ->
        Given -> @subView = class SubView extends Backbone.Fixins.SuperView
          template: -> "dont_tell_me_where_to_stick_my_template"
        itBehavesLike "rendering a custom template"

#    context "a view with deeply nested namespace", pending

    context "manually specifying a way to retrieve templates", ->
      Given -> Backbone.Fixins.configure
        templateFunction: (name) ->
          templateSource = $("#" + name).html()
          _.template templateSource
        defaultTemplateLocator: (view) ->
          Backbone.Fixins.helpers.constructorNameOf(view);

       Given -> affix('#SubView').html('<div class="specialHTML"></div>')
       Given -> @subject = new @subView(model: @model)
       When -> @subject.render()
       Then -> expect(@subject.el).toHas('.specialHTML')

       describe "resetting configuration overrides", ->
         Given -> Backbone.Fixins.resetConfiguration()
         When -> @subject.render()
         Then -> expect(@subject.el).toHas('.HTML')

