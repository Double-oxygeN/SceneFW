import dom
import scenefw
import ../components/divprintercomp
import scene1

when isMainModule:
  let
    comp = newDivPrinterComp(document.getElementById("scenefw"))
    game = newGame(comp)

  game.addScene("Scene1", newScene1(), true)

  game.start()
