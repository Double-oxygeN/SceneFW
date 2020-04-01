import scenefw
import ../components/samplecomp1

scene SampleScene9, SampleComp1:
  start:
    discard

  update:
    self.transitionTo("SampleScene10")

  draw:
    component.logInteger 9
