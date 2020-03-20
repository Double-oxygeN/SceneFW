import unittest
import scenefw, scenefw/scenemails

mail(ExMail2):
  var
    foo, bar: string
    baz: Natural
    qux: seq[char]

suite "Test for SceneMail":
  test "SceneMail definition":
    type ExMail1 = ref object of SceneMail

    check ExMail1 is SceneMail

  test "local mail macro":
    localmail(ExMail1):
      var val1: int
      var val2, val3: float

    check ExMail1 is SceneMail

    let m1 = newExMail1(42, 1.0, -1e9)
    check m1.val1 == 42
    check m1.val2 == 1.0
    check m1.val3 == -1e9

  test "mail macro":
    check ExMail2 is SceneMail

    let m2 = newExMail2("example", "", 20_000, @['H', 'e', 'l', 'l', 'o', '!'])
    check foo(m2) == "example"
    check bar(m2) == ""
    check baz(m2) == 20_000
    check qux(m2) == @['H', 'e', 'l', 'l', 'o', '!']
