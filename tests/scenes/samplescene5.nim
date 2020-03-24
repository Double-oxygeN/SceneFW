import scenefw
import ../components/samplecomp1
import ../mails/samplemail2

type
  SampleScene5* = ref object of BaseScene
    counter: Natural


method visitInit(self: Component; scene: SampleScene5; mail: SceneMail) {.base, tags: [IOEffect].} =
  discard


method visitInit(self: SceneMail; scene: SampleScene5; component: SampleComp1) {.base, tags: [IOEffect].} =
  discard


proc init(self: SampleScene5; component: SampleComp1; mail: SampleMail2) {.tags: [IOEffect].} =
  self.counter = mail.counter

  if mail.flag:
    self.transitionTo("SampleScene6", newSampleMail2(self.counter * 10, true))


method visitInit(self: SampleComp1; scene: SampleScene5; mail: SceneMail) =
  mail.visitInit(scene, self)


method visitInit(self: SampleMail2; scene: SampleScene5; component: SampleComp1) =
  scene.init(component, self)


method init(self: SampleScene5; component: Component; mail: SceneMail) =
  component.visitInit(self, mail)


method visitUpdate(self: Component; scene: SampleScene5) {.base, tags: [IOEffect].} =
  discard


proc update(self: SampleScene5; component: SampleComp1) {.tags: [IOEffect].} =
  if self.counter >= 1_800:
    self.transitionTo("SampleScene6", newSampleMail2(self.counter, false))

  inc self.counter, 50


method visitUpdate(self: SampleComp1; scene: SampleScene5) =
  scene.update(self)


method update(self: SampleScene5; component: Component) =
  component.visitUpdate(self)


method visitDraw(self: Component; scene: SampleScene5) {.base, tags: [IOEffect, WaqwaDrawEffect].} =
  discard


proc draw(self: SampleScene5; component: SampleComp1) {.tags: [IOEffect, WaqwaDrawEffect].} =
  component.logInteger -5
  component.logInteger self.counter


method visitDraw(self: SampleComp1; scene: SampleScene5) =
  scene.draw(self)


method draw(self: SampleScene5; component: Component) =
  component.visitDraw(self)
