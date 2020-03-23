import dom
import scenefw

type
  CanvasElement {.importc.} = ref object of Element
    width, height: Natural

  RenderingContext {.importc.} = ref object of RootObj

  CanvasRenderingContext2D {.importc.} = ref object of RenderingContext
    canvas: CanvasElement
    fillStyle: cstring

  CanvasComp* = ref object of Component
    targetElementId: string
    ctx: CanvasRenderingContext2D


proc getContext(canvas: CanvasElement; contextType: cstring): RenderingContext {.importjs: "#.getContext(@)".}

proc getContext2D(canvas: CanvasElement): CanvasRenderingContext2D =
  result = cast[CanvasRenderingContext2D](canvas.getContext("2d"))

proc fillRect(ctx: CanvasRenderingContext2D; x, y, width, height: cint) {.importjs: "#.fillRect(@)".}


proc newCanvasComp*(targetId: string): CanvasComp =
  CanvasComp(targetElementId: targetId)


method init(self: CanvasComp) =
  let canvasElement = cast[CanvasElement](document.createElement("canvas"))
  canvasElement.width = 600
  canvasElement.height = 600

  self.ctx = canvasElement.getContext2D()

  let targetElement = document.getElementById(self.targetElementId)
  targetElement.appendChild(canvasElement)


proc fillColor*(self: CanvasComp; color: string) {.tags: [WaqwaDrawEffect].} =
  self.ctx.fillStyle = color
  self.ctx.fillRect(0, 0, self.ctx.canvas.width.cint, self.ctx.canvas.height.cint)
