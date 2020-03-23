import scenefw
import ../components/canvascomp

type
  Scene1* = ref object of BaseScene
    counter: Natural

proc newScene1*: Scene1 =
  Scene1(counter: 0)


method visitInit(self: Component; scene: Scene1) {.base, tags: [IOEffect].} =
  discard


proc init(self: Scene1; component: CanvasComp) {.tags: [IOEffect].} =
  self.counter = 0


method visitInit(self: CanvasComp; scene: Scene1) =
  scene.init(self)


method init(self: Scene1; component: Component) =
  component.visitInit(self)


method visitUpdate(self: Component; scene: Scene1) {.base, tags: [IOEffect].} =
  discard


proc update(self: Scene1; component: CanvasComp) {.tags: [IOEffect].} =
  inc self.counter


method visitUpdate(self: CanvasComp; scene: Scene1) =
  scene.update(self)


method update(self: Scene1; component: Component) =
  component.visitUpdate(self)


method visitDraw(self: Component; scene: Scene1) {.base, tags: [IOEffect, WaqwaDrawEffect].} =
  discard


proc draw(self: Scene1; component: CanvasComp) {.tags: [IOEffect, WaqwaDrawEffect].} =
  component.fillColor("hsl(" & $self.counter & " 80% 60%)")


method visitDraw(self: CanvasComp; scene: Scene1) =
  scene.draw(self)


method draw(self: Scene1; component: Component) =
  component.visitDraw(self)
