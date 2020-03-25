import unittest
import scenefw

import components/samplecomp1
import scenes/samplescene1

suite "Test Sample1":
  test "Game works properly":
    let
      component = newSampleComp1()
      game = newGame(component)

    game.addScene("SampleScene1", newSampleScene1(), isFirstScene = true)

    game.unsetFramesPerSecond()
    game.start()

    check component.log == @[
      "init",
      "beforeDraw", "0", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "1", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "2", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "3", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "4", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "5", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "6", "afterDraw", "beforeUpdate", "afterUpdate",
      "finalize"
    ]
