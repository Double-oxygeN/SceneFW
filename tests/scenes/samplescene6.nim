import scenefw
import ../components/samplecomp1
import ../mails/samplemail2

type
  SampleScene6* = ref object of BaseScene
    counter: Natural
    flag: bool


method visitInit(self: Component; scene: SampleScene6; mail: SceneMail) {.base, tags: [IOEffect].} =
  discard


method visitInit(self: SceneMail; scene: SampleScene6; component: SampleComp1) {.base, tags: [IOEffect].} =
  discard


proc init(self: SampleScene6; component: SampleComp1; mail: SampleMail2) {.tags: [IOEffect].} =
  self.counter = mail.counter
  self.flag = mail.flag


method visitInit(self: SampleComp1; scene: SampleScene6; mail: SceneMail) =
  mail.visitInit(scene, self)


method visitInit(self: SampleMail2; scene: SampleScene6; component: SampleComp1) =
  scene.init(component, self)


method init(self: SampleScene6; component: Component; mail: SceneMail) =
  component.visitInit(self, mail)


method visitUpdate(self: Component; scene: SampleScene6) {.base, tags: [IOEffect].} =
  discard


proc update(self: SampleScene6; component: SampleComp1) {.tags: [IOEffect].} =
  if self.flag:
    self.quit()

  elif self.counter >= 2_200:
    self.transitionTo("SampleScene4", newSampleMail2(self.counter, true))

  inc self.counter, 200


method visitUpdate(self: SampleComp1; scene: SampleScene6) =
  scene.update(self)


method update(self: SampleScene6; component: Component) =
  component.visitUpdate(self)


method visitDraw(self: Component; scene: SampleScene6) {.base, tags: [IOEffect, WaqwaDrawEffect].} =
  discard


proc draw(self: SampleScene6; component: SampleComp1) {.tags: [IOEffect, WaqwaDrawEffect].} =
  component.logInteger -6
  component.logInteger self.counter


method visitDraw(self: SampleComp1; scene: SampleScene6) =
  scene.draw(self)


method draw(self: SampleScene6; component: Component) =
  component.visitDraw(self)
