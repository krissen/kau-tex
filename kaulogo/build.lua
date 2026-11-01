module = "kaulogo"
pkgversion = "2026-11-01"
pkgdate = "2026-11-01"
installfiles = {"*.sty", "*.pdf", "*.png"}
sourcefiles = {"*.sty", "*.pdf", "*.png"}
-- Keep the bundled source PDFs: l3build's default cleanfiles deletes *.pdf.
cleanfiles = {"*.log", "*.zip"}
checkengines = {"luatex"}
stdengine = "luatex"
