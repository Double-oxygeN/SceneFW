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

## Mail: Message between two scenes.
## ``SceneMail`` is just an abstruct type.
## Therefore, framework users have to implement concrete structure
## fitting their own situations.
##
## Overview
## ========
##
## Mail is an information shared just between two scenes.
##
## .. **TODO: Add a figure here**
##
## Example
## =======
##
## Consider that there are two scenes: ``ExScene1`` and ``ExScene2``.
## When transitioning to ``ExScene2``, ``ExScene1`` wants to share the data below:
##
## - ``sock`` of type ``AsyncSocket``
## - ``username`` of type ``string``
##
## In this situation, I recommend implementing ``ExMail1`` as below:
##
## .. code:: nim
##
##   type
##     ExMail1* = ref object of SceneMail
##       sock: AsyncSocket
##       username: string
##
##
##   proc newExMail1*(sock: AsyncSocket; username: string): ExMail1 =
##     ExMail1(sock: sock, username: username)
##
##
##   proc sock*(self: ExMail1): AsyncSocket = self.sock
##   proc username*(self: ExMail1): string = self.username
##
## ``ExScene1`` should send mail and transition like this:
##
## .. code:: nim
##
##   method update(self: ExScene1; component: ExComponent) =
##     # ...
##     self.transitionTo("ExScene2", newExMail(self.sock, self.username))
##     # ...
##
## And then ``ExScene2`` can receive ``ExMail1`` like this:
##
## .. code:: nim
##
##   method init(self: ExScene2; component: ExComponent; mail: ExMail1) =
##     self.sock = mail.sock
##     self.username = mail.username
##

type
  SceneMail* = ref object of RootObj
    ## Message between two scenes.
    nextSceneId*: string
