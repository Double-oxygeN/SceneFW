import scenefw
import ../components/samplecomp1

scene SampleScene10, SampleComp1:
  init:
    discard

  update:
    self.quit()

  draw:
    component.logInteger 10
