local cmp = require('cmp')
local util = require('vim.lsp.util')

local source = {}

local function buildDocumentation(word)
  local document = {}

  local list_tags_ok, tags = pcall("vim.fn.taglist", word)
  if not list_tags_ok then
    return ""
  end

  local doc = ''
  for i, tag in ipairs(tags) do
    if 10 < i then
      table.insert(document, ('...and %d more'):format(#tags - 10))
      break
    end
    doc =  tag.filename .. ' [' .. tag.kind .. ']'
    doc =  '# ' .. tag.filename .. ' [' .. tag.kind .. ']'
    if #tag.cmd >= 5 and tag.signature == nil then
      doc = doc .. '\n  __' .. tag.cmd:sub(3, -3):gsub('%s+', ' ') .. '__'
    end
    if tag.access ~= nil then
      doc = doc .. '\n  ' .. tag.access
    end
    if tag.implementation ~= nil then
      doc = doc .. '\n  impl: _' .. tag.implementation .. '_'
    end
    if tag.inherits ~= nil then
      doc = doc .. '\n  ' .. tag.inherits
    end
    if tag.signature ~= nil then
      doc = doc .. '\n  sign: _' .. tag.name .. tag.signature .. '_'
    end
    if tag.scope ~= nil then
      doc = doc .. '\n  ' .. tag.scope
    end
    if tag.struct ~= nil then
      doc = doc .. '\n  in ' .. tag.struct
    end
    if tag.class ~= nil then
      doc = doc .. '\n  in ' .. tag.class
    end
    if tag.enum ~= nil then
      doc = doc .. '\n  in ' .. tag.enum
    end
    table.insert(document, doc)
  end

  local formartDocument = util.convert_input_to_markdown_lines(document)
  return table.concat(formartDocument, '\n')
end

source.new = function()
  return setmetatable({}, { __index = source })
end

source.get_keyword_pattern = function()
  return '\\%([^[:alnum:][:blank:]]\\|\\k\\+\\)'
end

function source:get_debug_name()
  return 'tags'
end

function source:complete(request, callback)
  local items = {}
  vim.defer_fn(vim.schedule_wrap(function()
    local input = string.sub(request.context.cursor_before_line, request.offset)
    local _, tags = pcall(function()
      return vim.fn.getcompletion(input, "tag")
    end)

    if type(tags) ~= 'table' then
      return {}
    end
    tags = tags or {}
    for _, value in pairs(tags) do
      local item = {
        word =  value,
        label =  value,
        kind = cmp.lsp.CompletionItemKind.Tag,
      }
      items[#items+1] = item
    end

    callback({
      items = items,
      isIncomplete = true
    })
  end), 100)
end

function source:resolve(completion_item, callback)
  completion_item.documentation = {
    kind = cmp.lsp.MarkupKind.Markdown,
    value = buildDocumentation(completion_item.word)
  }

  callback(completion_item)
end

function source:is_available()
  return true
end

return source
