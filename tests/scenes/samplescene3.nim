import scenefw
import ../components/samplecomp1
import ../mails/samplemail1

type
  SampleScene3* = ref object of BaseScene
    counter: Natural


method visitInit(self: Component; scene: SampleScene3; mail: SceneMail) {.base, tags: [IOEffect].} =
  discard


method visitInit(self: SceneMail; scene: SampleScene3; component: SampleComp1) {.base, tags: [IOEffect].} =
  discard


proc init(self: SampleScene3; component: SampleComp1; mail: SampleMail1) {.tags: [IOEffect].} =
  self.counter = mail.counter


method visitInit(self: SampleComp1; scene: SampleScene3; mail: SceneMail) =
  mail.visitInit(scene, self)


method visitInit(self: SampleMail1; scene: SampleScene3; component: SampleComp1) =
  scene.init(component, self)


method init(self: SampleScene3; component: Component; mail: SceneMail) =
  component.visitInit(self, mail)


method visitUpdate(self: Component; scene: SampleScene3) {.base, tags: [IOEffect].} =
  discard


proc update(self: SampleScene3; component: SampleComp1) {.tags: [IOEffect].} =
  if self.counter >= 40:
    self.transitionTo("SampleScene2", newSampleMail1(self.counter))

  inc self.counter, 2


method visitUpdate(self: SampleComp1; scene: SampleScene3) =
  scene.update(self)


method update(self: SampleScene3; component: Component) =
  component.visitUpdate(self)


method visitDraw(self: Component; scene: SampleScene3) {.base, tags: [IOEffect, WaqwaDrawEffect].} =
  discard


proc draw(self: SampleScene3; component: SampleComp1) {.tags: [IOEffect, WaqwaDrawEffect].} =
  component.print self.counter


method visitDraw(self: SampleComp1; scene: SampleScene3) =
  scene.draw(self)


method draw(self: SampleScene3; component: Component) =
  component.visitDraw(self)
