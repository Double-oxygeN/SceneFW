import asyncdispatch
import scenefw
import ../components/samplecomp1
import ../mails/samplemail1

scene(SampleScene7, SampleComp1):
  var counter: Natural

  start:
    self.counter = 0

    self.disableTransition()

    proc foo {.async.} =
      echo "sleep start"
      await sleepAsync(500)
      echo "sleep end"
      self.enableTransition()

    asyncCheck foo()

  update:
    inc self.counter

    self.transitionTo("SampleScene8", newSampleMail1(self.counter))

  draw:
    component.logInteger self.counter
