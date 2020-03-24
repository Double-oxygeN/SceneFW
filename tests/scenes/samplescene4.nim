import scenefw
import ../components/samplecomp1
import ../mails/samplemail2

type
  SampleScene4* = ref object of BaseScene
    counter: Natural


method visitInit(self: Component; scene: SampleScene4) {.base, tags: [IOEffect].} =
  discard


proc init(self: SampleScene4; component: SampleComp1) {.tags: [IOEffect].} =
  self.counter = 1_200


method visitInit(self: SampleComp1; scene: SampleScene4) =
  scene.init(self)


method init(self: SampleScene4; component: Component) =
  component.visitInit(self)


method visitInit(self: Component; scene: SampleScene4; mail: SceneMail) {.base, tags: [IOEffect].} =
  discard


method visitInit(self: SceneMail; scene: SampleScene4; component: SampleComp1) {.base, tags: [IOEffect].} =
  discard


proc init(self: SampleScene4; component: SampleComp1; mail: SampleMail2) {.tags: [IOEffect].} =
  self.counter = mail.counter

  if mail.flag:
    self.transitionTo("SampleScene5", newSampleMail2(self.counter * 10, true))


method visitInit(self: SampleComp1; scene: SampleScene4; mail: SceneMail) =
  mail.visitInit(scene, self)


method visitInit(self: SampleMail2; scene: SampleScene4; component: SampleComp1) =
  scene.init(component, self)


method init(self: SampleScene4; component: Component; mail: SceneMail) =
  component.visitInit(self, mail)


method visitUpdate(self: Component; scene: SampleScene4) {.base, tags: [IOEffect].} =
  discard


proc update(self: SampleScene4; component: SampleComp1) {.tags: [IOEffect].} =
  if self.counter >= 2_000:
    self.quit()

  elif self.counter >= 1_600:
    self.transitionTo("SampleScene5", newSampleMail2(self.counter, false))

  inc self.counter, 100


method visitUpdate(self: SampleComp1; scene: SampleScene4) =
  scene.update(self)


method update(self: SampleScene4; component: Component) =
  component.visitUpdate(self)


method visitDraw(self: Component; scene: SampleScene4) {.base, tags: [IOEffect, WaqwaDrawEffect].} =
  discard


proc draw(self: SampleScene4; component: SampleComp1) {.tags: [IOEffect, WaqwaDrawEffect].} =
  component.logInteger -4
  component.logInteger self.counter


method visitDraw(self: SampleComp1; scene: SampleScene4) =
  scene.draw(self)


method draw(self: SampleScene4; component: Component) =
  component.visitDraw(self)
