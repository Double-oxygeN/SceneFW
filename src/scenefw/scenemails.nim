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

elif docLocale == "ja":
  ## メールとは2シーン間でやり取りされるメッセージのこと。
  ## ``SceneMail`` は抽象型である。
  ## そのため，フレームワーク利用者は状況に応じて具体的な構造を実装しなければならない。
  ##
  ## 概要
  ## ====
  ##
  ## メールとは2シーン間のみで共有される情報のことである。
  ##
  ## .. **TODO: Add a figure here**
  ##
  ## 例
  ## ====
  ##
  ## ``ExScene1`` と ``ExScene2`` の2つのシーンがあると考える。
  ## ``ExScene1`` から ``ExScene2`` へと遷移を行う際に，以下のようなデータを共有したいとする：
  ##
  ## - ``sock`` ： ``AsyncSocket`` 型のデータ
  ## - ``username`` ： ``string`` 型のデータ
  ##
  ## このとき， ``ExMail1`` を以下のように実装することを推奨する：
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
  ## ``ExScene1`` は次のようにして情報を送る：
  ##
  ## .. code:: nim
  ##
  ##   method update(self: ExScene1; component: ExComponent) =
  ##     # ...
  ##     self.transitionTo("ExScene2", newExMail(self.sock, self.username))
  ##     # ...
  ##
  ## そして ``ExScene2`` では送られてきた ``ExMail1`` を次のように受け取る：
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
