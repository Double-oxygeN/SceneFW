import scenefw
import ../components/divprintercomp

scene Scene1, DivPrinterComp:
  var counter: int

  start:
    self.counter = 0

  update:
    if self.counter >= 15:
      self.quit()

    inc self.counter

  draw:
    component.print "Hello", self.counter
