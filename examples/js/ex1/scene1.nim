import scenefw
import ../components/divprintercomp

type
  Scene1* = ref object of BaseScene
    counter: Natural

proc newScene1*: Scene1 =
  Scene1(counter: 0)


method visitInit(self: Component; scene: Scene1) {.base, tags: [IOEffect].} =
  discard


proc init(self: Scene1; component: DivPrinterComp) {.tags: [IOEffect].} =
  self.counter = 0


method visitInit(self: DivPrinterComp; scene: Scene1) =
  scene.init(self)


method init(self: Scene1; component: Component) =
  component.visitInit(self)


method visitUpdate(self: Component; scene: Scene1) {.base, tags: [IOEffect].} =
  discard


proc update(self: Scene1; component: DivPrinterComp) {.tags: [IOEffect].} =
  if self.counter >= 15:
    self.quit()

  inc self.counter


method visitUpdate(self: DivPrinterComp; scene: Scene1) =
  scene.update(self)


method update(self: Scene1; component: Component) =
  component.visitUpdate(self)


method visitDraw(self: Component; scene: Scene1) {.base, tags: [IOEffect, WaqwaDrawEffect].} =
  discard


proc draw(self: Scene1; component: DivPrinterComp) {.tags: [IOEffect, WaqwaDrawEffect].} =
  component.print "Hello", self.counter


method visitDraw(self: DivPrinterComp; scene: Scene1) =
  scene.draw(self)


method draw(self: Scene1; component: Component) =
  component.visitDraw(self)
