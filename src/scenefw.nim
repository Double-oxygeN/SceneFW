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
import scenefw/private/locale

export WaqwaDrawEffect, WaqwaError
export Component

template mail0(mailTypeId: untyped{ident}; exportMarker: bool = true; contents: untyped): untyped =
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
    ## シーンメール構成マクロ。
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
    ## 局所シーンメール構成マクロ。
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
