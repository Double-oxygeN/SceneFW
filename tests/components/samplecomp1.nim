import scenefw

type
  SampleComp1* = ref object of Component


proc newSampleComp1*: SampleComp1 =
  new SampleComp1


proc print*(self: SampleComp1; text: varargs[string, `$`]) {.tags: [WriteIOEffect, WaqwaDrawEffect].} =
  stdout.writeLine text


method init*(self: SampleComp1) =
  stderr.writeLine "[SampleComp1] init"


method finalize(self: SampleComp1) =
  stderr.writeLine "[SampleComp1] finalize"


method beforeDraw(self: SampleComp1) =
  stderr.writeLine "[SampleComp1] beforeDraw"


method afterDraw(self: SampleComp1) =
  stderr.writeLine "[SampleComp1] afterDraw"


method beforeUpdate(self: SampleComp1) =
  stderr.writeLine "[SampleComp1] beforeUpdate"


method afterUpdate(self: SampleComp1) =
  stderr.writeLine "[SampleComp1] afterUpdate"
