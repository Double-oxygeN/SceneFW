import scenefw
import ../components/samplecomp1
import ../mails/samplemail2

scene(SampleScene5, SampleComp1):
  var counter: Natural

  init[SampleMail2]:
    self.counter = mail.counter

    if mail.flag:
      self.transitionTo("SampleScene6", newSampleMail2(self.counter * 10, true))

  update:
    if self.counter >= 1_800:
      self.transitionTo("SampleScene6", newSampleMail2(self.counter, false))

    inc self.counter, 50

  draw:
    component.logInteger -5
    component.logInteger self.counter
