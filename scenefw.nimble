# Package

version       = "0.1.1"
author        = "Double_oxygeN"
description   = "Scene-oriented programming framework for game development"
license       = "Apache-2.0"
srcDir        = "src"



# Dependencies

requires "nim >= 1.0.6"


# Tasks

const seeSrcOption = "--git.url:https://github.com/Double-oxygeN/SceneFW --git.commit:master"

template execGenDoc(locale: string): untyped =
  exec "nim doc --project --outDir:docs/" & locale & " -d:docLocale=" & locale & " " & seeSrcOption & " src/scenefw"

task docxen, "Generate English documentations":
  execGenDoc "en"

task docxja, "日本語のドキュメントを生成します":
  execGenDoc "ja"

task docx, "Generate documentations":
  docxenTask()
  docxjaTask()
