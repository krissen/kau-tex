module = "kaucolors"
pkgversion = "2026-11-01"
pkgdate = "2026-11-01"
installfiles = {"*.sty"}
sourcefiles = {"*.sty"}
checkengines = {"luatex"}
stdengine = "luatex"

-- Portable logs across macOS and Linux; see ../testenv.lua.
dofile("../testenv.lua")
