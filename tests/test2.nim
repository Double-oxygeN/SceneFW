import unittest
import scenefw

import components/samplecomp1
import scenes/[samplescene2, samplescene3]

suite "Test Sample2":
  test "Game ends properly":
    let
      component = newSampleComp1()
      game = newGame(component)

    game.addScene("SampleScene2", new SampleScene2, isFirstScene = true)
    game.addScene("SampleScene3", new SampleScene3)

    game.unsetFramesPerSecond()
    game.start()
