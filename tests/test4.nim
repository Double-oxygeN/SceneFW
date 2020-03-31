import unittest
import scenefw

import components/samplecomp1
import scenes/[samplescene7, samplescene8]

suite "Test Sample4":
  test "Asynchronous procs":
    let
      component = newSampleComp1()
      game = newGame(component)

    game.addScene("SampleScene7", newSampleScene7(), isFirstScene = true)
    game.addScene("SampleScene8", newSampleScene8())

    game.setFramesPerSecond(20)
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
      "beforeDraw", "7", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "8", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "9", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "10", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "11", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "12", "afterDraw", "beforeUpdate", "afterUpdate",
      "finalize"
    ]
