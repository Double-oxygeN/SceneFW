import unittest
import scenefw

import components/samplecomp1
import scenes/[samplescene4, samplescene5, samplescene6]

suite "Test Sample3":
  test "Scene skip works":
    let
      component = newSampleComp1()
      game = newGame(component)

    game.addScene("SampleScene4", newSampleScene4(), isFirstScene = true)
    game.addScene("SampleScene5", newSampleScene5())
    game.addScene("SampleScene6", newSampleScene6())

    game.unsetFramesPerSecond()
    game.start()

    check component.log == @[
      "init",
      "beforeDraw", "-4", "1200", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-4", "1300", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-4", "1400", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-4", "1500", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-4", "1600", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-5", "1600", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-5", "1650", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-5", "1700", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-5", "1750", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-5", "1800", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-6", "1800", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-6", "2000", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-6", "2200", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-6", "220000", "afterDraw", "beforeUpdate", "afterUpdate",
      "finalize"
    ]
