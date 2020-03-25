import scenefw
import ../components/canvascomp

scene Scene1, CanvasComp:
  var counter: Natural

  start:
    self.counter = 0

  update:
    inc self.counter

  draw:
    component.fillColor "hsl(" & $self.counter & " 80% 60%)"
