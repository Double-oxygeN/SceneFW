import scenefw
import ../components/samplecomp1
import ../mails/samplemail2

scene(SampleScene4, SampleComp1):
  var counter: Natural

  start:
    self.counter = 1_200

  init[SampleMail2]:
    self.counter = mail.counter

    if mail.flag:
      self.transitionTo("SampleScene5", newSampleMail2(self.counter * 10, true))

  update:
    if self.counter >= 2_000:
      self.quit()

    elif self.counter >= 1_600:
      self.transitionTo("SampleScene5", newSampleMail2(self.counter, false))

    inc self.counter, 100

  draw:
    component.logInteger -4
    component.logInteger self.counter
