# Copyright 2020 Double-oxygeN
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import tables, times, std/monotimes
when defined(js):
  import dom
else:
  import os
import transitions, scenes, components, scenemails

type
  Scene = BaseScene

  Game* = ref object of RootObj
    component: Component
    sceneTable: TableRef[string, Scene]
    firstSceneId: string
    strictFps: bool
    framesPerSecond: Natural


proc newGame*: Game =
  ## Create new game object.
  ## No scenes are set and frames-per-second (FPS) is set at 60.
  result = Game(sceneTable: newTable[string, Scene]())
  result.strictFps = true
  result.framesPerSecond = 60


proc setFramesPerSecond*(self: Game; fps: Positive): Natural {.discardable.} =
  ## Set frames-per-second at a specific value.
  ## It returns previous FPS.
  result = self.framesPerSecond
  self.framesPerSecond = fps
  self.strictFps = true


proc unsetFramesPerSecond*(self: Game): Natural {.discardable.} =
  ## Ignore frames-per-second (FPS).
  ## It returns previous FPS.
  result = self.framesPerSecond
  self.framesPerSecond = 0
  self.strictFps = false


proc addScene*(self: Game; sceneId: string; scene: Scene; isFirstScene: bool = false) =
  ## Register new scene with scene id.
  self.sceneTable[sceneId] = scene
  if isFirstScene: self.firstSceneId = sceneId


proc countScenes*(self: Game): int =
  ## Count registered scenes.
  result = self.sceneTable.len


proc start*(self: Game) =
  ## Start the game.
  init self.component
  defer: finalize self.component

  var currentScene: Scene = self.sceneTable[self.firstSceneId]
  currentScene.init(self.component)

  var
    quitFlag: bool = false
    speedUpFlag: bool = false
    frameCount = 1'i64

  let
    msecPerFrame = 1e3 / self.framesPerSecond.toBiggestFloat()
    startMonoTime = getMonoTime()

  while not quitFlag:
    currentScene.resetTransition()

    if not speedUpFlag:
      currentScene.draw(self.component)

    currentScene.update(self.component)

    case currentScene.transitionKind
    of tkStay:
      discard

    of tkNextScene:
      let
        nextScene = self.sceneTable[currentScene.mail.nextSceneId]
        mail = currentScene.mail

      nextScene.init(self.component, mail)

      currentScene = nextScene

    of tkQuit:
      quitFlag = true

    if self.strictFps:
      let
        limitMsec = (msecPerFrame * frameCount.toBiggestFloat()).toBiggestInt()
        monoTimeNow = getMonoTime()
        elapsedMsec = (monoTimeNow - startMonoTime).inMilliseconds()

      if elapsedMsec <= limitMsec:
        speedUpFlag = false
        if limitMsec - elapsedMsec > 1:
          sleep((limitMsec - elapsedMsec).int - 1)

      else:
        speedUpFlag = true

    inc frameCount
