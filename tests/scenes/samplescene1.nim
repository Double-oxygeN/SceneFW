import scenefw
import ../components/samplecomp1

scene(SampleScene1, SampleComp1):
  var counter: Natural

  start:
    self.counter = 0

  update:
    if self.counter >= 6:
      self.quit()

    inc self.counter

  draw:
    component.logInteger self.counter
