import scenefw
import ../components/samplecomp1
import ../mails/samplemail1

type
  SampleScene2* = ref object of BaseScene
    counter: Natural


method visitInit(self: Component; scene: SampleScene2) {.base, tags: [IOEffect].} =
  discard


proc init(self: SampleScene2; component: SampleComp1) {.tags: [IOEffect].} =
  self.counter = 10


method visitInit(self: SampleComp1; scene: SampleScene2) =
  scene.init(self)


method init(self: SampleScene2; component: Component) =
  component.visitInit(self)


method visitInit(self: Component; scene: SampleScene2; mail: SceneMail) {.base, tags: [IOEffect].} =
  discard


method visitInit(self: SceneMail; scene: SampleScene2; component: SampleComp1) {.base, tags: [IOEffect].} =
  discard


proc init(self: SampleScene2; component: SampleComp1; mail: SampleMail1) {.tags: [IOEffect].} =
  self.counter = mail.counter


method visitInit(self: SampleComp1; scene: SampleScene2; mail: SceneMail) =
  mail.visitInit(scene, self)


method visitInit(self: SampleMail1; scene: SampleScene2; component: SampleComp1) =
  scene.init(component, self)


method init(self: SampleScene2; component: Component; mail: SceneMail) =
  component.visitInit(self, mail)


method visitUpdate(self: Component; scene: SampleScene2) {.base, tags: [IOEffect].} =
  discard


proc update(self: SampleScene2; component: SampleComp1) {.tags: [IOEffect].} =
  if self.counter >= 25:
    self.quit()

  elif self.counter >= 20:
    self.transitionTo("SampleScene3", newSampleMail1(self.counter))

  inc self.counter


method visitUpdate(self: SampleComp1; scene: SampleScene2) =
  scene.update(self)


method update(self: SampleScene2; component: Component) =
  component.visitUpdate(self)


method visitDraw(self: Component; scene: SampleScene2) {.base, tags: [IOEffect, WaqwaDrawEffect].} =
  discard


proc draw(self: SampleScene2; component: SampleComp1) {.tags: [IOEffect, WaqwaDrawEffect].} =
  component.logInteger -2
  component.logInteger self.counter


method visitDraw(self: SampleComp1; scene: SampleScene2) =
  scene.draw(self)


method draw(self: SampleScene2; component: Component) =
  component.visitDraw(self)
