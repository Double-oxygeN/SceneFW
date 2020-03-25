import scenefw
import ../components/samplecomp1
import ../mails/samplemail1

scene(SampleScene3, SampleComp1):
  var counter: Natural

  init[SampleMail1]:
    self.counter = mail.counter

  update:
    if self.counter >= 30:
      self.transitionTo("SampleScene2", newSampleMail1(self.counter))

    inc self.counter, 2

  draw:
    component.logInteger -3
    component.logInteger self.counter
