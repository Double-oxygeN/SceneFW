import unittest
import scenefw

import components/samplecomp1
import scenes/[samplescene9, samplescene10]

suite "Test Sample5":
  test "Default initialization":
    let
      component = newSampleComp1()
      game = newGame(component)

    game.addScene("SampleScene9", newSampleScene9(), isFirstScene = true)
    game.addScene("SampleScene10", newSampleScene10())

    game.start()

    check component.log == @[
      "init",
      "beforeDraw", "9", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "10", "afterDraw", "beforeUpdate", "afterUpdate",
      "finalize"
    ]
