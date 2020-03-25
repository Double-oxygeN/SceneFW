import scenefw
import ../components/samplecomp1
import ../mails/samplemail2

scene(SampleScene6, SampleComp1):
  var
    counter: Natural
    flag: bool

  init[SampleMail2]:
    self.counter = mail.counter
    self.flag = mail.flag

  update:
    if self.flag:
      self.quit()

    elif self.counter >= 2_200:
      self.transitionTo("SampleScene4", newSampleMail2(self.counter, true))

    inc self.counter, 200

  draw:
    component.logInteger -6
    component.logInteger self.counter
