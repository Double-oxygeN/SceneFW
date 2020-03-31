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

when defined(js):
  type Lock = object
  template withLock(a: Lock; body: untyped): untyped = body
else:
  import locks

import private/locale

when docLocale == "en":
  ## Scenes.

elif docLocale == "ja":
  ## シーン。

import effects, transitions, components, scenemails

type
  BaseScene* = ref object of RootObj
    ## Every scene is created with extending this.
    transitionKind: TransitionKind
    mail: SceneMail
    transitionLock: bool
    transitionLockLock: Lock


proc transitionKind*(self: BaseScene): TransitionKind = self.transitionKind
proc mail*(self: BaseScene): SceneMail = self.mail


proc isTransitionLocked*(self: BaseScene): bool =
  withLock(self.transitionLockLock):
    result = self.transitionLock


proc enableTransition*(self: BaseScene) =
  withLock(self.transitionLockLock):
    self.transitionLock = off


proc disableTransition*(self: BaseScene) =
  withLock(self.transitionLockLock):
    self.transitionLock = on


proc resetTransition*(self: BaseScene) =
  self.transitionKind = tkStay
  self.mail = nil


proc transitionTo*(self: BaseScene; nextSceneId: string; mail: SceneMail) =
  self.transitionKind = tkNextScene
  self.mail = mail
  self.mail.nextSceneId = nextSceneId


proc quit*(self: BaseScene) =
  self.transitionKind = tkQuit
  self.mail = nil


method init*(self: BaseScene; component: Component) {.base, tags: [RootEffect].} =
  when docLocale == "en":
    ## Initialize the scene.
    ## This method is called when the game begins.

  elif docLocale == "ja":
    ## シーンを初期化する。
    ## このメソッドはゲーム開始時に呼び出される。

  discard


method init*(self: BaseScene; component: Component; recvMail: SceneMail) {.base, tags: [RootEffect].} =
  when docLocale == "en":
    ## Initialize the scene with the mail sent by the previous scene.
    ## This method is called whenever the scene begins.

  elif docLocale == "ja":
    ## 前のシーンから送られてきたシーンメールを使ってシーンを初期化する。
    ## このメソッドはシーン開始時に毎回呼び出される。

  discard


method update*(self: BaseScene; component: Component) {.base, tags: [RootEffect].} =
  when docLocale == "en":
    ## Update the scene.
    ## This method is called in every frame.

  elif docLocale == "ja":
    ## シーンを更新する。
    ## このメソッドは毎フレーム呼び出される。

  discard


method draw*(self: BaseScene; component: Component) {.base, tags: [RootEffect, WaqwaDrawEffect].} =
  when docLocale == "en":
    ## Output the scene to the display.
    ## This method is called at most once in a frame.

  elif docLocale == "ja":
    ## シーンを画面に出力する。
    ## このメソッドは各フレームに最大で1回まで呼び出される。

  discard
