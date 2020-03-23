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

import times, std/monotimes

type
  FpsController* = ref object of RootObj
    startTime: MonoTime
    framesPerSecond: Natural
    msecPerFrame: float
    frameCounter: Natural

proc newFpsController*(framesPerSecond: Natural): FpsController =
  result = FpsController(framesPerSecond: framesPerSecond)
  if framesPerSecond > 0:
    result.msecPerFrame = 1e3 / framesPerSecond.toBiggestFloat()


proc start*(self: FpsController) =
  self.startTime = getMonoTime()
  self.frameCounter = 0


proc inc*(self: FpsController) =
  inc self.frameCounter


proc frame*(self: FpsController): Natural =
  self.frameCounter


proc msecPerFrame*(self: FpsController): BiggestFloat =
  self.msecPerFrame


proc getGap*(self: FpsController): int64 =
  let
    limitMsec = (self.frameCounter.toBiggestFloat() * self.msecPerFrame).toBiggestInt()
    monotimeNow = getMonoTime()
    elapsedMsec = (monotimeNow - self.startTime).inMilliseconds()

  result = limitMsec - elapsedMsec
