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

## Thanks to https://dbaron.org/log/20100309-faster-timeouts.

when not defined(js) and not defined(nimdoc):
  {.error: "This module only works on the JavaScript platform.".}

import dom

type
  MessageEvent {.importc.} = ref object of Event
    data: cstring
    source: Window

proc postMessage(w: Window; message, targetOrigin: cstring) {.importcpp, nodecl.}

const zeroTimeoutMessageName = "zero-timeout-message"
var timeouts: seq[(proc () {.closure.})] = @[]

proc setZeroTimeout*(fn: (proc () {.closure.})) =
  timeouts.add(fn)
  window.postMessage(zeroTimeoutMessageName, "*")

window.addEventListener("message") do (ev: Event):
  let mev = MessageEvent(ev)
  if mev.source == window and mev.data == zeroTimeoutMessageName:
    ev.stopPropagation()

    if timeouts.len > 0:
      let fn = timeouts[0]
      timeouts.delete(0)
      fn()
