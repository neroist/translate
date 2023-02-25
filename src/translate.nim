import std/asyncdispatch
import std/strformat
import std/random

import nimtranslate
import uing/genui
import uing

import "languages.nim"

randomize()

var
  window: Window
  fromLangBox, toLangBox: EditableCombobox
  fromEntry, toEntry: MultilineEntry

proc translate(_: Button) = 
  var fromLang = fromLangBox.text

  let  
    toLang = toLangBox.text
    fromText = fromEntry.text

  if fromLang notin supportedLanguages:
    fromLang = "auto"

  if toLang notin supportedLanguages:
    window.error(
      "Language Unsupported", 
      fmt("The language \"{toLang}\" is unsupported.")
    )
    
    return

  let translator = newTranslator(fromLang, toLang)

  try:
    toEntry.text = waitFor(translator.translate(fromText, fromLang, toLang)).text
  except:
    window.error("Error", getCurrentExceptionMsg())

proc main =
  genui:
    window%Window("Translate", width = 800, height = 600):
      VerticalBox(padded = true):
        Grid(padded = true):
          Label("From Language:")[0, 0, 2, 1, false, AlignStart, false, AlignCenter]
          Label("To Language:")[2, 0, 1, 1, false, AlignStart, false, AlignCenter]

          fromLangBox%EditableCombobox(supportedLanguages)[0, 1, 1, 1, false, AlignStart, false, AlignCenter]
          Label(" ---> ")[1, 1, 1, 1, true, AlignCenter, false, AlignCenter]
          toLangBox%EditableCombobox(supportedLanguages)[2, 1, 1, 1, false, AlignStart, false, AlignCenter]

        HorizontalBox(padded = true)[stretchy = true]:
          fromEntry%MultilineEntry()[stretchy = true]
          VerticalSeparator()
          toEntry%MultilineEntry()[stretchy = true]

        HorizontalBox(padded = true):
          Button("Translate!", onclick = translate)[stretchy = true]

  fromLangBox.text = "auto"
  toLangBox.text = sample(supportedLanguages)

  # make the entry read-only without it being grey
  toEntry.onchanged = proc (entry: MultilineEntry) = clear entry

  window.margined = true

  show window
  mainLoop()

init()
main()
