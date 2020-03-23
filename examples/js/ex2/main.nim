import dom
import scenefw
import ../components/canvascomp
import scene1

when isMainModule:
  let
    comp = newCanvasComp("scenefw")
    game = newGame(comp)

  game.addScene("Scene1", newScene1(), true)

  game.start()
