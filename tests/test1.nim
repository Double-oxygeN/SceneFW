import unittest
import scenefw

import components/samplecomp1
import scenes/samplescene1

suite "Test Sample1":
  test "Game ends properly":
    let
      component = newSampleComp1()
      game = newGame(component)

    game.addScene("SampleScene1", new SampleScene1, isFirstScene = true)

    game.unsetFramesPerSecond()
    game.start()
