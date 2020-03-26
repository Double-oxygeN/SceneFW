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

import private/locale

when docLocale == "en":
  ## Game.

elif docLocale == "ja":
  ## ゲーム。

import tables
when defined(js):
  from dom import window, requestAnimationFrame
  import private/zerotimeout
else:
  from os import sleep
import fpscontroller, transitions, scenes, components, scenemails

type
  Scene = BaseScene

  Game* = ref object of RootObj
    component: Component
    sceneTable: TableRef[string, Scene]
    firstSceneId: string
    strictFps: bool
    framesPerSecond: Natural


proc newGame*(component: Component): Game =
  when docLocale == "en":
    ## Create new game object.
    ## No scenes are set and frames-per-second (FPS) is set at 60.

  elif docLocale == "ja":
    ## ゲームオブジェクトを新規作成する。
    ## シーンは1つも設定されておらず，FPSは60に設定されている。

  result = Game(
    sceneTable: newTable[string, Scene](),
    component: component,
    strictFps: true,
    framesPerSecond: 60)


proc setFramesPerSecond*(self: Game; fps: Positive): Natural {.discardable.} =
  when docLocale == "en":
    ## Set frames-per-second at a specific value.
    ## It returns previous FPS.

  elif docLocale == "ja":
    ## FPSを特定の値に設定する。
    ## 以前のFPSの値を返す。

  result = self.framesPerSecond
  self.framesPerSecond = fps
  self.strictFps = true


proc unsetFramesPerSecond*(self: Game): Natural {.discardable.} =
  when docLocale == "en":
    ## Ignore frames-per-second (FPS).
    ## It returns previous FPS.

  elif docLocale == "ja":
    ## FPSを無視する。
    ## 以前のFPSの値を返す。

  result = self.framesPerSecond
  self.framesPerSecond = 0
  self.strictFps = false


proc addScene*(self: Game; sceneId: string; scene: Scene; isFirstScene: bool = false) =
  when docLocale == "en":
    ## Register new scene with scene id.

  elif docLocale == "ja":
    ## IDとともにシーンを新たに登録する。

  self.sceneTable[sceneId] = scene
  if isFirstScene: self.firstSceneId = sceneId


proc countScenes*(self: Game): int =
  when docLocale == "en":
    ## Count registered scenes.

  elif docLocale == "ja":
    ## 登録済みのシーンの数を数える。

  result = self.sceneTable.len


proc start*(self: Game) =
  when docLocale == "en":
    ## Start the game.

  elif docLocale == "ja":
    ## ゲームを開始する。

  var speedUpFlag = false
  when defined(js):
    var speedDownFlag = false
  let fpsCon = newFpsController(self.framesPerSecond)

  type LoopCallee = (proc (recur: (proc () {.closure.})) {.closure.})

  proc loop(callee: LoopCallee) =
    when defined(js):
      if speedUpFlag:
        setZeroTimeout do ():
          callee do ():
            loop(callee)

      else:
        discard window.requestAnimationFrame do (elapsedTimeMillis: float):
          if speedDownFlag:
            loop(callee)
            speedDownFlag = fpsCon.getGap() > (fpsCon.msecPerFrame / 2).toBiggestInt()

          else:
            callee do ():
              loop(callee)

    else:
      var quitFlag = false

      while not quitFlag:
        quitFlag = true
        callee do ():
          quitFlag = false


  init self.component
  defer: finalize self.component

  var currentScene: Scene = self.sceneTable[self.firstSceneId]
  currentScene.init(self.component)

  fpsCon.start()

  loop do (recur: auto):
    currentScene.resetTransition()

    # Draw phase
    self.component.beforeDraw()
    if not speedUpFlag:
      currentScene.draw(self.component)
      self.component.afterDraw()

    # Update phase
    self.component.beforeUpdate()
    currentScene.update(self.component)
    self.component.afterUpdate()

    # End of frame
    inc fpsCon
    if self.strictFps:
      let gapMsec = fpsCon.getGap()

      speedUpFlag = gapMsec < 0
      when defined(js):
        speedDownFlag = gapMsec > (fpsCon.msecPerFrame / 2).toBiggestInt()

      else:
        if gapMsec > 1: sleep(gapMsec.int - 1)

    # Transition phase
    case currentScene.transitionKind
    of tkStay:
      recur()

    of tkNextScene:
      while currentScene.transitionKind == tkNextScene:
        let
          mail = currentScene.mail
          nextScene = self.sceneTable[mail.nextSceneId]

        nextScene.resetTransition()
        nextScene.init(self.component, mail)
        currentScene = nextScene

      recur()

    of tkQuit:
      discard
