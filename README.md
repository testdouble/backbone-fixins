# backbone-fixins

[![Build Status](https://secure.travis-ci.org/testdouble/backbone-fixins.png)](http://travis-ci.org/testdouble/backbone-fixins)

A common complaint directed at [Backbone.js](https://github.com/documentcloud/backbone) is that it's hard to get up-and-running without a significant amount of general boilerplate code. On one hand, Backbone's minimalism is its greatest strength. On the other hand, it doesn't make sense for our applications to solve problems that are outside of their domain, and it makes even less sense to solve the same problems in each new application we write.

This project doesn't aim to saddle users with a new Backbone meta-framework. But neither does it have the luxury of being so focused as to only tackle one feature or problem (like [backbone-localstorage](https://github.com/jeromegn/Backbone.localStorage), [backbone.layoutmanager](https://github.com/tbranyen/backbone.layoutmanager), or [backbone-relational](https://github.com/PaulUithol/Backbone-relational) do). Instead, backbone-fixins will only ever be a handful of little, easy-to-discard boilerplate utilities. The only motivation here is to help new applications get up-and-running a little more quickly.

# Components

Right now it's just the SuperView. I've got short-term plans to add a generic CollectionView and a mixin that aid in model validation.

## Backbone.Fixins.SuperView

Most basic Backbone views do the following:

1. Override the `#render` function
2. Grab a compiled template
3. Generate HTML by passing a context object to the template; usually by serializing the view's `model` property as JSON.
4. Render that HTML into the View's `el` element.

And while this works fine, I'm sick of writing code to do it. First, none of this is a domain concern... it's a concern shared by nearly *every* view—why not DRY this up and get it out of the way? Second, overridden `render` functions don't age gracefully, in my experience.

As most Views mature, "render-time" behavior is often just tacked on at the end of the `render` function. Because this violates [SRP](http://en.wikipedia.org/wiki/Single_responsibility_principle), it makes for complex unit tests and complicates performance optimizations that try to minimize calls to `render`. The `Backbone.Fixins.SuperView` intends to discourage users from coupling render behaviors from the start.

So here's an example Backbone view that extends from `Backbone.Fixins.SuperView`:

``` coffee
class MyView extends Backbone.Fixins.SuperView
  renderJQueryAccordion: ->
```

Invoking `new MyView(model: new Backbone.Model).render()` will do a lot for you:

1. By default, it'll look for a template function at `JST['templates/my_view']`.
2. It will invoke the template by passing it the view's `model.toJSON()`.
3. It will render the resulting HTML into the view's `el` element.
4. It will invoke the view's `renderJQueryAccordion` function, because the function's name started with the word "render".
5. It will trigger a `"rendered"` event on the view, so that additional post-render behavior can be added dynamically without tempting the user to override the `render` function

In case you missed it, that means that in addition to making some logical assumptions, two new conventions can help you avoid coupling behaviors that only have rendering in common.

* Any view may define any number of methods that start with the word "render", and they'll each be called immediately after the template is re-rendered. But the methods are still available to be bound to other events to allow small aspects of the view to be re-rendered without a more-expensive call to the `render` function.

* After each render is completed, views will emit a "rendered" event that anything else can bind to.

### SuperView customization

Of course, not all views will be the same. They can optionally define these attributes to alter the behavior of the SuperView:

* `template` - *function or string* - the locator of the view (e.g. "templates/popups/panda_view")
* `templateContext` - *function or object* - the object to be passed to the compiled

If your application won't be using `JST`, you'll need to override the `templateFunction` configuration (see below).

## Application-wide Configuration

Since many folks don't use a server-side template compilation tool that gives them a handy `JST` object, most of the interesting bits are configurable.

By passing in a configuration object to `Backbone.fixins.configure()`, some default behavior can be overridden.

Current application-wide options include:

* `defaultTemplateLocator` - *function(view)* - given a view, find the *locator* of the template. (default: "templates/view_name_in_snake_case")
* `templateFunction` - *function(locator)* - given a locator, return a  compiled template function (default: the function at `JST[locator]`)
* `defaultTemplateContext` - *function(view)* - given a view, return whatever object should be handed to the compiled template function. (default: `model.toJSON()`)

You can also reset the default configuration with `Backbone.Fixins.resetConfiguration`

### Example configuration

Suppose you want to grab your template functions from `<script>` elements on the DOM and compile them with underscore''s _.template(). You might override the configuration like this:

``` javascript
Backbone.fixins.configure({
  templateFunction: function(name){
    templateSource = $('script[type="text/html"]#'+name).html();
    return _.template(templateSource);
  },
  defaultTemplateLocator: function(view){
    return Backbone.Fixins.helpers.constructorNameOf(view);
  }
});
```

(Fair warning: this is a contrived example as it will inefficiently re-compile the template on each `render` invocation).