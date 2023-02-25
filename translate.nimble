# Package

version       = "0.1.0"
author        = "Jasmine"
description   = "A translator app"
license       = "MIT"
srcDir        = "src"
bin           = @["translate"]


# Dependencies

requires "nim >= 1.6.10"
requires "https://github.com/DavideGalilei/nimtranslate"
requires "uing"
