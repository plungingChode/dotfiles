local M = {}

--- Check if a `table` contains any values from `values`.
---
---@param table table the table to check againts
---@param values table the values to check
---@return boolean 
function M.table_contains(table, values)
  for _, has in ipairs(table) do
    for _, v in ipairs(values) do
      if has == v then
        return true
      end
    end
  end
  return false
end

return M
