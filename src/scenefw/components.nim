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
  ## Component.
  ## This includes window manager, image manager, sound manager, painter and so on.
  ## The implementation depends on the external libraries you choose.

elif docLocale == "ja":
  ## コンポーネント。
  ## ウィンドウ管理，画像管理，音声管理，描画などを含む。
  ## 実装は，選択する外部ライブラリに依存する。

type
  Component* = ref object of RootObj ## \
    ## Component.


method init*(self: Component) {.base.} =
  when docLocale == "en":
    ## Component initialization.
    ## This proc is called when the game starts.

  elif docLocale == "ja":
    ## コンポーネントの初期化を行う。
    ## この手続きはゲーム開始時に呼び出される。

  discard


method finalize*(self: Component) {.base.} =
  when docLocale == "en":
    ## Component finalization.
    ## This proc is called when the game ends.

  elif docLocale == "ja":
    ## コンポーネントの終了処理を行う。
    ## この手続きはゲーム終了時に呼び出される。

  discard


method beforeDraw*(self: Component) {.base.} =
  when docLocale == "en":
    ## Actions before drawing.
    ## This proc is always called as the first action in the scene flow.

  elif docLocale == "ja":
    ## 描画前処理を行う。
    ## この手続きはシーンの流れの最初に必ず呼び出される。

  discard


method afterDraw*(self: Component) {.base.} =
  when docLocale == "en":
    ## Actions after drawing.
    ## When drawing is not occurred, this proc is not called either.

  elif docLocale == "ja":
    ## 描画後処理を行う。
    ## もし描画が行われなかった場合は，この手続きも同様に呼び出されない。

  discard


method beforeUpdate*(self: Component) {.base.} =
  when docLocale == "en":
    ## Actions before update.
    ## This proc must be called after both ``beforeDraw`` and ``afterDraw``.

  elif docLocale == "ja":
    ## 更新前処理を行う。
    ## この手続きは ``beforeDraw`` と ``afterDraw`` の両方よりも後に必ず呼び出される。

  discard


method afterUpdate*(self: Component) {.base.} =
  when docLocale == "en":
    ## Actions after update.

  elif docLocale == "ja":
    ## 更新後処理を行う。

  discard
