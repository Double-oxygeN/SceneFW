import scenefw

type
  SampleComp1* = ref object of Component
    log: seq[string]


proc log*(self: SampleComp1): seq[string] = self.log


proc newSampleComp1*: SampleComp1 =
  SampleComp1(log: @[])


proc logInteger*(self: SampleComp1; i: int) {.tags: [WriteIOEffect, WaqwaDrawEffect].} =
  stdout.writeLine i
  self.log.add $i


method init*(self: SampleComp1) =
  stderr.writeLine "[SampleComp1] init"
  self.log.add "init"


method finalize(self: SampleComp1) =
  stderr.writeLine "[SampleComp1] finalize"
  self.log.add "finalize"


method beforeDraw(self: SampleComp1) =
  stderr.writeLine "[SampleComp1] beforeDraw"
  self.log.add "beforeDraw"


method afterDraw(self: SampleComp1) =
  stderr.writeLine "[SampleComp1] afterDraw"
  self.log.add "afterDraw"


method beforeUpdate(self: SampleComp1) =
  stderr.writeLine "[SampleComp1] beforeUpdate"
  self.log.add "beforeUpdate"


method afterUpdate(self: SampleComp1) =
  stderr.writeLine "[SampleComp1] afterUpdate"
  self.log.add "afterUpdate"
