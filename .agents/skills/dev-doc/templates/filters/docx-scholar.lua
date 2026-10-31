-- DOCX scholarly structure: Figure/Table numbers + export-time cross-refs.
-- Cross-ref syntax (no @ — citeproc owns @keys): {fig:label} {tbl:label} {sec:label}
-- Two-pass: number structure first, then resolve xrefs in paragraphs.

local figures = {}
local tables = {}
local sections = {}
local fig_count = 0
local tbl_count = 0
local sec_counters = { 0, 0, 0, 0, 0, 0 }

local function is_docx()
  return FORMAT == "docx"
end

local function stringify(xs)
  return pandoc.utils.stringify(xs or {})
end

local function number_header(el)
  local level = el.level
  sec_counters[level] = (sec_counters[level] or 0) + 1
  for i = level + 1, 6 do
    sec_counters[i] = 0
  end
  local parts = {}
  for i = 1, level do
    table.insert(parts, tostring(sec_counters[i]))
  end
  local num = table.concat(parts, ".")
  local id = el.identifier or ""
  local title = stringify(el.content)
  local display = num .. " " .. title
  if id ~= "" then
    sections[id] = display
    sections["sec:" .. id] = display
    local bare = id:gsub("^sec:", "")
    sections[bare] = display
    sections["sec:" .. bare] = display
  end
  return el
end

local function number_figure(el)
  fig_count = fig_count + 1
  local n = fig_count
  local id = el.identifier or ""
  if id ~= "" then
    figures[id] = n
    local bare = id:gsub("^fig:", "")
    figures[bare] = n
    figures["fig:" .. bare] = n
  end
  local cap = stringify(el.caption and el.caption.long or {})
  cap = cap:gsub("^Figure%s+%d+%.%s*", "")
  el.caption.long = { pandoc.Plain({ pandoc.Str(string.format("Figure %d. %s", n, cap)) }) }
  return el
end

local function number_table(el)
  local cap_blocks = el.caption and el.caption.long or nil
  if cap_blocks == nil or #cap_blocks == 0 then
    return el
  end
  tbl_count = tbl_count + 1
  local n = tbl_count
  local id = el.attr and el.attr.identifier or ""
  if id ~= nil and id ~= "" then
    tables[id] = n
    local bare = id:gsub("^tbl:", "")
    tables[bare] = n
    tables["tbl:" .. bare] = n
  end
  local text = stringify(cap_blocks)
  if not text:match("^Table%s+%d+") then
    local prefix = pandoc.Str(string.format("Table %d. ", n))
    local first = cap_blocks[1]
    if first and (first.t == "Plain" or first.t == "Para") then
      table.insert(first.content, 1, prefix)
    else
      table.insert(cap_blocks, 1, pandoc.Plain({ prefix }))
    end
  end
  return el
end

local function lookup_fig(lab)
  return figures[lab] or figures["fig:" .. lab] or figures[lab:gsub("^fig:", "")]
end

local function lookup_tbl(lab)
  return tables[lab] or tables["tbl:" .. lab] or tables[lab:gsub("^tbl:", "")]
end

local function lookup_sec(lab)
  return sections[lab] or sections["sec:" .. lab] or sections[lab:gsub("^sec:", "")]
end

local function replace_xrefs_in_inlines(inlines)
  local out = {}
  for _, inl in ipairs(inlines) do
    if inl.t == "Str" then
      local s = inl.text
      local i = 1
      while true do
        local a, b, kind, lab = s:find("%{(%w+):([%w_:%-]+)%}", i)
        if not a then
          if i <= #s then
            table.insert(out, pandoc.Str(s:sub(i)))
          end
          break
        end
        if a > i then
          table.insert(out, pandoc.Str(s:sub(i, a - 1)))
        end
        local repl
        if kind == "fig" then
          local n = lookup_fig(lab)
          repl = n and ("Figure " .. tostring(n)) or ("[missing figure:" .. lab .. "]")
        elseif kind == "tbl" then
          local n = lookup_tbl(lab)
          repl = n and ("Table " .. tostring(n)) or ("[missing table:" .. lab .. "]")
        elseif kind == "sec" then
          local d = lookup_sec(lab)
          repl = d and ("§" .. d) or ("[missing section:" .. lab .. "]")
        else
          repl = "{" .. kind .. ":" .. lab .. "}"
        end
        table.insert(out, pandoc.Strong({ pandoc.Str(repl) }))
        i = b + 1
      end
    else
      table.insert(out, inl)
    end
  end
  return out
end

local function xref_para(el)
  el.content = replace_xrefs_in_inlines(el.content)
  return el
end

function Pandoc(doc)
  if not is_docx() then
    return doc
  end
  doc = doc:walk({
    Header = number_header,
    Figure = number_figure,
    Table = number_table,
  })
  doc = doc:walk({
    Para = xref_para,
    Plain = xref_para,
  })
  return doc
end
