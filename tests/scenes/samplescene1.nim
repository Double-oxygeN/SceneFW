import scenefw
import ../components/samplecomp1

type
  SampleScene1* = ref object of BaseScene
    counter: Natural


method visitInit(self: Component; scene: SampleScene1) {.base, tags: [IOEffect].} =
  discard


proc init(self: SampleScene1; component: SampleComp1) {.tags: [IOEffect].} =
  self.counter = 0


method visitInit(self: SampleComp1; scene: SampleScene1) =
  scene.init(self)


method init(self: SampleScene1; component: Component) =
  component.visitInit(self)


method visitUpdate(self: Component; scene: SampleScene1) {.base, tags: [IOEffect].} =
  discard


proc update(self: SampleScene1; component: SampleComp1) {.tags: [IOEffect].} =
  if self.counter >= 20:
    self.quit()

  inc self.counter


method visitUpdate(self: SampleComp1; scene: SampleScene1) =
  scene.update(self)


method update(self: SampleScene1; component: Component) =
  component.visitUpdate(self)


method visitDraw(self: Component; scene: SampleScene1) {.base, tags: [IOEffect, WaqwaDrawEffect].} =
  discard


proc draw(self: SampleScene1; component: SampleComp1) {.tags: [IOEffect, WaqwaDrawEffect].} =
  component.print self.counter


method visitDraw(self: SampleComp1; scene: SampleScene1) =
  scene.draw(self)


method draw(self: SampleScene1; component: Component) =
  component.visitDraw(self)
