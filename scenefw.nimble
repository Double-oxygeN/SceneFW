# Package

version       = "0.1.0"
author        = "Double_oxygeN"
description   = "Scene-oriented programming framework for game development"
license       = "Apache-2.0"
srcDir        = "src"



# Dependencies

requires "nim >= 1.0.6"


# Tasks

task docx, "Generate documentations":
  exec "nim doc --project --outDir:docs --git.url:https://github.com/Double-oxygeN/SceneFW --git.commit:master src/scenefw"
