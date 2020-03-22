import scenefw

import dom

type
  DivPrinterComp* = ref object of Component
    targetElement: Element

proc newDivPrinterComp*(target: Element): DivPrinterComp =
  DivPrinterComp(targetElement: target)


proc print*(self: DivPrinterComp; texts: varargs[string, `$`]) {.tags: [WriteIOEffect, WaqwaDrawEffect].} =
  let divElem = document.createElement("div")
  divElem.innerHTML = ""
  for text in texts:
    divElem.innerHTML = $divElem.innerHTML & $escape(text) & " "

  self.targetElement.appendChild divElem
