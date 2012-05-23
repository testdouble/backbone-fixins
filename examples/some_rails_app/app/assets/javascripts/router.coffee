class App.Router extends Backbone.Router
  routes:
    "super_view/simple": "simpleSuperView"
    "super_view/complex": "complexSuperView"
    "super_view/customized": "customizedSuperView"
    "*path": "index"

  initialize: ->
    @root = $('#application')[0]

  index: ->
    new App.IndexView(el: @root).render()

  simpleSuperView: ->
    new App.SimpleSuperView(el: @root).render()

  complexSuperView: ->
    new App.ComplexSuperView(el: @root).render()

  customizedSuperView: ->
    Backbone.Fixins.configure
      defaultTemplateLocator: (view) ->
        "##{Backbone.Fixins.helpers.constructorNameOf(view)}Template"
      templateFunction: (locator) ->
        _.template($(locator).html())
      defaultTemplateContext: (view) ->
        label: "quite customized"

    $underscoreTemplate = $("""
      <script id="CustomizedSuperViewTemplate" type="text/html">
        <div>
          I'm a <%= label %> use of Backbone.Fixins.SuperView!
        </div>
        <div>
          <a href="#">&lt;- Back</a>
        </div>
      </script>
      """).appendTo('body')

    new App.CustomizedSuperView(el: @root).render()

    $underscoreTemplate.remove()
    Backbone.Fixins.resetConfiguration()