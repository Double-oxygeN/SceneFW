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

## Scene Framework (WAQWA Project)
##
## :Author: Double_oxygeN
## :License: Apache-2.0

import macros

import scenefw/components
import scenefw/effects
import scenefw/scenemails
import scenefw/scenes
import scenefw/game
import scenefw/private/locale

export WaqwaDrawEffect, WaqwaError
export Component
export SceneMail
export BaseScene, transitionTo, scenes.quit
export Game, newGame, setFramesPerSecond, unsetFramesPerSecond, addScene, countScenes, start

template mail0(mailTypeId: untyped{ident}; exportMarker: bool; contents: untyped): untyped =
  expectKind contents, nnkStmtList
  expectMinLen contents, 1

  let varDecl = nnkVarSection.newNimNode()
  for varSection in contents:
    expectKind varSection, nnkVarSection
    varSection.copyChildrenTo(varDecl)

  let
    recordList = nnkRecList.newNimNode()
    formalParams = nnkFormalParams.newTree(mailTypeId)
  varDecl.copyChildrenTo(recordList)
  varDecl.copyChildrenTo(formalParams)

  var propertiesTable = newSeq[tuple[varIdent, typeIdent: NimNode]]()
  for identDefs in varDecl:
    let typeIdent = identDefs[^2]
    for i in 0..<identDefs.len - 2:
      propertiesTable.add (identDefs[i], typeIdent)

  let typeDecl = nnkTypeSection.newTree(nnkTypeDef.newTree(
    when exportMarker: mailTypeId.postfix("*") else: mailTypeId,
    newEmptyNode(),
    nnkRefTy.newTree(nnkObjectTy.newTree(
      newEmptyNode(),
      nnkOfInherit.newTree(bindSym"SceneMail"),
      recordList))))

  var objConstr = nnkObjConstr.newTree(mailTypeId)
  for (varIdent, _) in propertiesTable:
    objConstr.add newColonExpr(varIdent, varIdent)

  let ctorProcDecl = nnkProcDef.newTree(
    when exportMarker: ident("new" & $mailTypeId).postfix("*") else: ident("new" & $mailTypeId),
    newEmptyNode(), newEmptyNode(),
    formalParams, newEmptyNode(), newEmptyNode(),
    newStmtList(objConstr)
  )

  result = newStmtList(typeDecl, ctorProcDecl)

  when exportMarker:
    for (varIdent, typeIdent) in propertiesTable:
      let getterProcDecl = nnkProcDef.newTree(
        when exportMarker: varIdent.postfix("*") else: varIdent,
        newEmptyNode(), newEmptyNode(),
        nnkFormalParams.newTree(typeIdent, nnkIdentDefs.newTree(
          ident"self", mailTypeId, newEmptyNode())),
        newEmptyNode(), newEmptyNode(),
        newStmtList(newDotExpr(ident"self", varIdent)))

      result.add getterProcDecl


macro mail*(mailTypeId: untyped{ident}; contents: untyped): untyped =
  when docLocale == "en":
    ## Mail construction macro.
    ##
    ## This macro requires type identifier (``mailTypeId``) and variable declaration (``contents``).
    ## It automatically generates a new type whose name is same as ``mailTypeId``, a constructor proc (type name with prefix ``new``) and getter procs for each property.
    ## The type inherits from ``SceneMail``.
    ## The generated type and procs are exported, so you should call this at top-level and use them in other modules.
    runnableExamples:
      mail(ExampleMail):
        var
          username: string
          score, highScore: Natural

      ## will generate
      ##
      ##   type
      ##     ExampleMail* = ref object of SceneMail
      ##       username: string
      ##       score, highScore: Natural
      ##
      ##   proc newExampleMail*(username: string; score, highScore: Natural): ExampleMail =
      ##     ExampleMail(username: username, score: score, highScore: highScore)
      ##
      ##   proc username*(self: ExampleMail): string = self.username
      ##   proc score*(self: ExampleMail): Natural = self.score
      ##   proc highScore*(self: ExampleMail): Natural = self.highScore

  elif docLocale == "ja":
    ## シーンメール構築マクロ。
    ##
    ## このマクロは型を表す識別子(``mailTypeId``)と変数宣言セクション(``contents``)を要求する。
    ## ``mailTypeId`` という名の型とそのコンストラクタ(``new`` + 型名)，およびゲッター手続きを自動生成する。
    ## 生成された型は ``SceneMail`` 型を継承する。
    ## 生成される型および手続きは全てエクスポートされるため，マクロ呼出はトップレベルで行い，他のモジュール内で使用するのが望ましい。
    runnableExamples:
      mail(ExampleMail):
        var
          username: string
          score, highScore: Natural

      ## 以下のコードを生成する：
      ##
      ##   type
      ##     ExampleMail* = ref object of SceneMail
      ##       username: string
      ##       score, highScore: Natural
      ##
      ##   proc newExampleMail*(username: string; score, highScore: Natural): ExampleMail =
      ##     ExampleMail(username: username, score: score, highScore: highScore)
      ##
      ##   proc username*(self: ExampleMail): string = self.username
      ##   proc score*(self: ExampleMail): Natural = self.score
      ##   proc highScore*(self: ExampleMail): Natural = self.highScore

  mail0(mailTypeId, true, contents)


macro localmail*(mailTypeId: untyped{ident}; contents: untyped): untyped =
  when docLocale == "en":
    ## Local mail construction macro.
    ##
    ## This macro requires type identifier (``mailTypeId``) and variable declaration (``contents``).
    ## It automatically generates a new type whose name is same as ``mailTypeId`` and a constructor proc (type name with prefix ``new``).
    ## The type inherits from ``SceneMail``.
    ## The generated type and proc are not exported when you just call this.
    runnableExamples:
      localmail(ExampleLocalMail):
        var
          username: string
          score, highScore: Natural

      ## will generate
      ##
      ##   type
      ##     ExampleLocalMail = ref object of SceneMail
      ##       username: string
      ##       score, highScore: Natural
      ##
      ##   proc newExampleLocalMail(username: string; score, highScore: Natural): ExampleLocalMail =
      ##     ExampleLocalMail(username: username, score: score, highScore: highScore)

  elif docLocale == "ja":
    ## 局所シーンメール構築マクロ。
    ##
    ## このマクロは型を表す識別子(``mailTypeId``)と変数宣言セクション(``contents``)を要求する。
    ## ``mailTypeId`` という名の型とそのコンストラクタ(``new`` + 型名)を自動生成する。
    ## 生成された型は ``SceneMail`` 型を継承する。
    ## 生成される型および手続きは，単にマクロを呼び出しただけではエクスポートされない。
    runnableExamples:
      localmail(ExampleLocalMail):
        var
          username: string
          score, highScore: Natural

      ## 以下のコードを生成する：
      ##
      ##   type
      ##     ExampleLocalMail = ref object of SceneMail
      ##       username: string
      ##       score, highScore: Natural
      ##
      ##   proc newExampleLocalMail(username: string; score, highScore: Natural): ExampleLocalMail =
      ##     ExampleLocalMail(username: username, score: score, highScore: highScore)


  mail0(mailTypeId, false, contents)


macro scene*(sceneTypeId: untyped{ident}; compType: typedesc[Component]; contents: untyped): untyped =
  when docLocale == "en":
    ## Scene construction macro.
    ##
    ## This macro requires type identifier (``sceneTypeId``), component type (``compType``) and scene definition section (``contents``).
    ## It automatically generates a new type whose name is same as ``sceneTypeId`` and a constructor proc (type name with prefix ``new``),
    ## and implements some essential methods.
    ## The type inherits from ``BaseScene``.
    ## The generated type and the constructor are exported, so you should call this at top-level and use them in other modules.
    ##
    runnableExamples:
      type
        Painter = ref object
        ExampleComp = ref object of Component
          painter: Painter

      proc draw(self: Painter; text: string) {.tags: [WaqwaDrawEffect].} = discard

      mail(ExampleMail):
        var a, b: int

      scene(ExampleScene, ExampleComp):
        ## Variables declared with var keyword become scene properties.
        ## You cannot initialize them by the constructor, so you should do that in init section.
        var
          a, b: int
          c: string

        ## Variables declared with let keyword become scene properties.
        ## You can initialize them as the arguments of the constructor.
        ## In this example, the generated constructor is
        ## `proc newExampleScene(d: range[0..100]; e: float)`.
        let
          d: range[0..100]
          e: float

        ## Statements in start section means initialization as a start scene.
        start:
          self.a = self.d
          self.b = 100 - self.d
          self.c = "po"

        ## Statements in init section means initialization after a transition.
        ## You can receive a scene mail as `mail` when you write the type name of the scene mail
        ## sent from the previous scene in the bracket.
        init[ExampleMail]:
          self.a = mail.a
          self.b = mail.b
          self.c = "po"

        ## Statements in update section means how to update the scene in a frame.
        update:
          if self.a >= 90:
            self.quit()

          inc self.a
          dec self.b

        ## Statements in draw section means how to draw the scene in a frame.
        draw:
          component.painter.draw(self.c)

  elif docLocale == "ja":
    ## シーン構築マクロ。
    ##
    ## このマクロは型を表す識別子(``sceneTypeId``)とコンポーネントの型(``compType``)，定義部(``contents``)の3つを要求する。
    ## ``sceneTypeId`` という名の型とそのコンストラクタ(``new`` + 型名)に加えて，各種メソッドを自動生成する。
    ## 生成された型は ``BaseScene`` 型を継承する。
    ## 生成される型およびコンストラクタはエクスポートされるため，マクロ呼出はトップレベルで行い，他のモジュール内で使用するのが望ましい。
    ##
    runnableExamples:
      type
        Painter = ref object
        ExampleComp = ref object of Component
          painter: Painter

      proc draw(self: Painter; text: string) {.tags: [WaqwaDrawEffect].} = discard

      mail(ExampleMail):
        var a, b: int

      scene(ExampleScene, ExampleComp):
        ## varで宣言された変数はシーンのプロパティになる。
        ## コンストラクタで初期化することはできず，initで初期化を行う。
        var
          a, b: int
          c: string

        ## letで宣言された変数はシーンのプロパティになる。
        ## コンストラクタの引数によって初期化できる。
        ## この例では，proc newExampleScene(d: range[0..100]; e: float)
        ## というコンストラクタが生成される。
        let
          d: range[0..100]
          e: float

        ## startセクションでは開始シーンの場合の初期化を行う。
        start:
          self.a = self.d
          self.b = 100 - self.d
          self.c = "po"

        ## initセクションでは遷移後の初期化を行う。
        ## 角括弧内に遷移元から送信されるシーンメールの型名を書くことで，
        ## シーンメールをmailで受け取ることができる。
        init[ExampleMail]:
          self.a = mail.a
          self.b = mail.b
          self.c = "po"

        ## updateセクションではシーンの1フレームの更新を行う。
        update:
          if self.a >= 90:
            self.quit()

          inc self.a
          dec self.b

        ## drawセクションではシーンの1フレームの描画を行う。
        draw:
          component.painter.draw(self.c)


  expectKind contents, nnkStmtList

  var
    varPropertiesTable = newSeq[tuple[varIdent, typeIdent: NimNode]]()
    letPropertiesTable = newSeq[tuple[letIdent, typeIdent: NimNode]]()
    startMethodStmt = newStmtList(nnkDiscardStmt.newTree(newEmptyNode()))
    initMethodStmtTable = newSeq[tuple[mailTypeId, initStmt: NimNode]]()
    updateMethodStmt = newStmtList(nnkDiscardStmt.newTree(newEmptyNode()))
    drawMethodStmt = newStmtList(nnkDiscardStmt.newTree(newEmptyNode()))

  let
    sceneTypeStr = $sceneTypeId
    recordList = nnkRecList.newTree()
    formalParams = nnkFormalParams.newTree(sceneTypeId)

  for content in contents:
    case content.kind
    of nnkVarSection:
      for identDefs in content:
        if identDefs[^2].kind == nnkEmpty:
          error("Type is needed.", identDefs)

        if identDefs[^1].kind != nnkEmpty:
          warning("The expression is ignored.", identDefs[^1])

        for i in 0..<identDefs.len - 2:
          varPropertiesTable.add (identDefs[i], identDefs[^2])

      content.copyChildrenTo(recordList)

    of nnkLetSection:
      for identDefs in content:
        if identDefs[^2].kind == nnkEmpty:
          error("Type is needed.", identDefs)

        if identDefs[^1].kind != nnkEmpty:
          warning("The expression is ignored.", identDefs[^1])

        for i in 0..<identDefs.len - 2:
          letPropertiesTable.add (identDefs[i], identDefs[^2])

      content.copyChildrenTo(recordList)
      content.copyChildrenTo(formalParams)

    of nnkCall:
      expectLen content, 2
      let sectionNameNode = content[0]
      case sectionNameNode.kind
      of nnkIdent:
        case strVal(sectionNameNode)
        of "start":
          startMethodStmt = content[1]

        of "init":
          initMethodStmtTable.add (bindSym"SceneMail", content[1])

        of "update":
          updateMethodStmt = content[1]

        of "draw":
          drawMethodStmt = content[1]

        else:
          error("Unsupported section name.", sectionNameNode)

      of nnkBracketExpr:
        if strVal(sectionNameNode[0]) == "init":
          let mailTypeId = sectionNameNode[1]
          initMethodStmtTable.add (mailTypeId, content[1])

        else:
          error("Unsupported section name.", sectionNameNode)

      else:
        error("Unsupported section name.", sectionNameNode)

    of nnkDiscardStmt:
      if content[0].kind != nnkEmpty:
        error("Unsupported syntax.", content[0])

    of nnkCommentStmt:
      discard

    else:
      error("Unsupported syntax.", content)

  let typeDecl = nnkTypeSection.newTree(nnkTypeDef.newTree(
    sceneTypeId.postfix("*"),
    newEmptyNode(),
    nnkRefTy.newTree(nnkObjectTy.newTree(
      newEmptyNode(),
      nnkOfInherit.newTree(bindSym"BaseScene"),
      recordList))))

  let objConstr = nnkObjConstr.newTree(sceneTypeId)
  for (letIdent, _) in letPropertiesTable:
    objConstr.add newColonExpr(letIdent, letIdent)

  let ctorProcDecl = nnkProcDef.newTree(
    ident("new" & sceneTypeStr).postfix("*"),
    newEmptyNode(), newEmptyNode(),
    formalParams, newEmptyNode(), newEmptyNode(),
    newStmtList(objConstr)
  )

  let
    selfIdent = ident"self"
    componentIdent = ident"component"

  let startMethodDecls = quote do:
    proc init(`selfIdent`: `sceneTypeId`; `componentIdent`: `compType`) {.tags: [IOEffect].} =
      `startMethodStmt`

    method visitInit(self: Component; scene: `sceneTypeId`) {.base, tags: [IOEffect].} =
      raise WaqwaError.newException("Undefined component for " & `sceneTypeStr` & ".")

    method visitInit(self: `compType`; scene: `sceneTypeId`) =
      scene.init(self)

    method init(`selfIdent`: `sceneTypeId`; component: Component) =
      component.visitInit(`selfIdent`)

  if initMethodStmtTable.len == 0:
    let undefinedInitMethodDecl = quote do:
      method init(`selfIdent`: `sceneTypeId`; component: Component; mail: SceneMail) =
        raise WaqwaError.newException("The scene " & `sceneTypeStr` & " cannot receive any mails.")

    startMethodDecls.add undefinedInitMethodDecl

  else:
    let
      mailIdent = ident"mail"
      initMethodDecls = quote do:
        method visitInit(self: Component; scene: `sceneTypeId`; mail: SceneMail) {.base, tags: [IOEffect].} =
          raise WaqwaError.newException("Undefined component for " & `sceneTypeStr` & ".")

        method visitInit(self: SceneMail; scene: `sceneTypeId`; component: `compType`) {.base, tags: [IOEffect].} =
          raise WaqwaError.newException("Received undefined mail for " & `sceneTypeStr` & ".")

        method visitInit(self: `compType`; scene: `sceneTypeId`; mail: SceneMail) =
          mail.visitInit(scene, self)

        method init(`selfIdent`: `sceneTypeId`; component: Component; mail: SceneMail) =
          component.visitInit(`selfIdent`, mail)

    for (mailTypeId, initStmt) in initMethodStmtTable:
      let initProcDecl = quote do:
        proc init(`selfIdent`: `sceneTypeId`; `componentIdent`: `compType`; `mailIdent`: `mailTypeId`) {.tags: [IOEffect].} =
          `initStmt`

        method visitInit(self: `mailTypeId`; scene: `sceneTypeId`; component: `compType`) =
          scene.init(component, self)

      initMethodDecls.add initProcDecl

    startMethodDecls.add initMethodDecls

  let updateMethodDecls = quote do:
    proc update(`selfIdent`: `sceneTypeId`; `componentIdent`: `compType`) {.tags: [IOEffect].} =
      `updateMethodStmt`

    method visitUpdate(self: Component; scene: `sceneTypeId`) {.base, tags: [IOEffect].} =
      raise WaqwaError.newException("Undefined component for " & `sceneTypeStr` & ".")

    method visitUpdate(self: `compType`; scene: `sceneTypeId`) =
      scene.update(self)

    method update(`selfIdent`: `sceneTypeId`; component: Component) =
      component.visitUpdate(`selfIdent`)

  let drawMethodDecls = quote do:
    proc draw(`selfIdent`: `sceneTypeId`; `componentIdent`: `compType`) {.tags: [IOEffect, WaqwaDrawEffect].} =
      `drawMethodStmt`

    method visitDraw(self: Component; scene: `sceneTypeId`) {.base, tags: [IOEffect, WaqwaDrawEffect].} =
      raise WaqwaError.newException("Undefined component for " & `sceneTypeStr` & ".")

    method visitDraw(self: `compType`; scene: `sceneTypeId`) =
      scene.draw(self)

    method draw(`selfIdent`: `sceneTypeId`; component: Component) =
      component.visitDraw(`selfIdent`)

  result = newStmtList(typeDecl, ctorProcDecl, startMethodDecls, updateMethodDecls, drawMethodDecls)

