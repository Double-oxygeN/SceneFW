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

## Scenes.

import effects, transitions, components, scenemails

type
  BaseScene* = ref object of RootObj
    ## Every scene is created with extending this.
    transitionKind: TransitionKind
    mail: SceneMail


proc transitionKind*(self: BaseScene): TransitionKind = self.transitionKind
proc mail*(self: BaseScene): SceneMail = self.mail


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


method init*(self: BaseScene; component: Component) {.base, tags: [IOEffect].} =
  ## Initialize the scene.
  ## This method is called when the game begins.
  discard


method init*(self: BaseScene; component: Component; recvMail: SceneMail) {.base, tags: [IOEffect].} =
  ## Initialize the scene with the mail sent by the previous scene.
  ## This method is called whenever the scene begins.
  discard


method update*(self: BaseScene; component: Component) {.base, tags: [IOEffect].} =
  ## Update the scene.
  ## This method is called in every frame.
  discard


method draw*(self: BaseScene; component: Component) {.base, tags: [IOEffect, WaqwaDrawEffect].} =
  ## Output the scene to the display.
  ## This method is called at most once in a frame.
  discard
