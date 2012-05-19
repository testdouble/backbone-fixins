root = this

root.context = root.describe
root.xcontext = root.xdescribe

#shared example groups
sharedExamples = {}
root.sharedExamplesFor = (name, behavior) ->
  throw "Woah, you already have shared examples named \"#{name}\"" if sharedExamples[name]?
  sharedExamples[name] = behavior

root.itBehavesLike = (name) ->
  throw "No shared examples found named \"#{name}\"!" unless sharedExamples[name]?
  sharedExamples[name]()

#matchers
beforeEach ->
  @addMatchers
    toHas: (selector) ->
      $(@actual).find(selector).length > 0


#pending specs
root.pending = ->
  Then -> console.log "PENDING: #{@suite.description}"

# faking templates
root.fakeJST = (name) ->
  _(jasmine.createSpy()).tap (spy) ->
    fake(root.JST ||= {}, name, spy)

# fake(owner, name, fakeThing)
#  lets you fake something that's global
#  but still cleans up after specs run
unfakes = []
root.fake = (owner, thingToFake, newThing) ->
  originalThing = owner[thingToFake]
  owner[thingToFake] = newThing
  unfakes.push ->
    owner[thingToFake] = originalThing
afterEach ->
  _(unfakes).each (u) -> u()
  unfakes = []


