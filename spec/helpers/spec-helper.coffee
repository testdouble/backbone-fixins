root = this

root.context = root.describe
root.xcontext = root.xdescribe



unfakes = []
afterEach ->
  _(unfakes).each (u) -> u()
  unfakes = []

root.fake = (owner, thingToFake, newThing) ->
  originalThing = owner[thingToFake]
  owner[thingToFake] = newThing
  unfakes.push ->
    owner[thingToFake] = originalThing
