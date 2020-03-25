import unittest
import scenefw

import components/samplecomp1
import scenes/[samplescene2, samplescene3]

suite "Test Sample2":
  test "Send mails properly":
    let
      component = newSampleComp1()
      game = newGame(component)

    game.addScene("SampleScene2", newSampleScene2(), isFirstScene = true)
    game.addScene("SampleScene3", newSampleScene3())

    game.unsetFramesPerSecond()
    game.start()

    check component.log == @[
      "init",
      "beforeDraw", "-2", "10", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-2", "11", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-2", "12", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-2", "13", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-2", "14", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-2", "15", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-2", "16", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-2", "17", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-2", "18", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-2", "19", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-2", "20", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-3", "20", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-3", "22", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-3", "24", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-3", "26", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-3", "28", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-3", "30", "afterDraw", "beforeUpdate", "afterUpdate",
      "beforeDraw", "-2", "30", "afterDraw", "beforeUpdate", "afterUpdate",
      "finalize"
    ]
