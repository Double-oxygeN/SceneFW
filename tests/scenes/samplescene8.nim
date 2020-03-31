import scenefw
import ../components/samplecomp1
import ../mails/samplemail1

scene(SampleScene8, SampleComp1):
  var counter: Natural

  init[SampleMail1]:
    self.counter = mail.counter

  update:
    if self.counter >= 12:
      self.quit()

    inc self.counter

  draw:
    component.logInteger self.counter
