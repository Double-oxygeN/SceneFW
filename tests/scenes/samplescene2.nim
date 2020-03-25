import scenefw
import ../components/samplecomp1
import ../mails/samplemail1

scene(SampleScene2, SampleComp1):
  var counter: Natural

  start:
    self.counter = 10

  init[SampleMail1]:
    self.counter = mail.counter

  update:
    if self.counter >= 25:
      self.quit()

    elif self.counter >= 20:
      self.transitionTo("SampleScene3", newSampleMail1(self.counter))

    inc self.counter

  draw:
    component.logInteger -2
    component.logInteger self.counter
