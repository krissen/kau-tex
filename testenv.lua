-- Log normalisation shared by every subproject's build.lua.
--
-- The packages are developed on macOS, where the KAU fonts (Helvetica Neue)
-- are installed, and checked in CI on Linux, where they are not. On top of
-- l3build's own normalisation this removes what depends on the machine
-- rather than on the package, so one set of .tlg files holds on both:
--
--   * LaTeX font info and font warnings: the font names differ when the
--     KAU fonts are missing, and so does the substitution warning.
--   * the values in tikzflora's "flora:" lines: the coverage is measured
--     against the typeset text and so follows the font metrics. The line
--     itself stays, so the test still shows that the flora was painted.
--   * where page markers wrap: "[2", "]" and the files read with a page
--     each get their own line, so a line break TeX places differently
--     between TeX Live versions no longer counts.
--
-- Font availability is therefore not tested here; that is a property of
-- the machine, not of the packages.

local function normalize(content)
  local out = {}
  local in_font = false
  for line in content:gmatch("([^\n]*)\n") do
    if line:match("^LaTeX Font Info:") or line:match("^LaTeX Font Warning:") then
      in_font = true
    elseif in_font and line:match("^%(Font%)") then
      -- continuation of the font message above
    else
      in_font = false
      line = line:gsub("flora: coverage %d+%.%d+", "flora: coverage ...")
      line = line:gsub("flora: %d+ painted objects", "flora: ... painted objects")
      line = line:gsub("%s*(%[%d+)", "\n%1"):gsub("%]%s*", "]\n")
      for piece in (line .. "\n"):gmatch("([^\n]*)\n") do
        piece = piece:gsub("^%s+", ""):gsub("%s+$", "")
        if piece ~= "" then out[#out + 1] = piece end
      end
    end
  end
  return table.concat(out, "\n") .. "\n"
end

local function rewrite_portable(source, result, engine, errlevels)
  rewrite_log(source, result, engine, errlevels)
  local f = assert(io.open(result, "rb"))
  local content = f:read("a")
  f:close()
  f = assert(io.open(result, "wb"))
  f:write(normalize(content))
  f:close()
end

test_types = test_types or {}
test_types.log = {
  test = ".lvt",
  generated = ".log",
  reference = ".tlg",
  expectation = ".lve",
  compare = compare_tlg,
  rewrite = rewrite_portable,
}
