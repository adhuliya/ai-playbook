-- Precise DOCX filter:
-- * tables → TableGrid (header fill/bold from reference style)
-- * code → numbered lines kept as SourceCode paragraphs (shaded box), NOT a data table

local function split_lines(text)
  local lines = {}
  if text == "" then
    return { "" }
  end
  for line in (text .. "\n"):gmatch("(.-)\n") do
    table.insert(lines, line)
  end
  return lines
end

function Table(el)
  if FORMAT ~= "docx" then
    return nil
  end
  el.attr = el.attr or pandoc.Attr()
  el.attr.attributes["custom-style"] = "TableGrid"
  return el
end

function CodeBlock(el)
  if FORMAT ~= "docx" then
    return nil
  end
  if el.classes:includes("unnumbered") then
    return nil
  end

  local blocks = {}
  local lines = split_lines(el.text)
  local width = #tostring(#lines)
  for i, line in ipairs(lines) do
    local prefix = string.format("%" .. width .. "d│ ", i)
    local para = pandoc.Para({ pandoc.Code(prefix .. line) })
    table.insert(
      blocks,
      pandoc.Div({ para }, pandoc.Attr("", {}, { ["custom-style"] = "Source Code" }))
    )
  end
  return blocks
end
