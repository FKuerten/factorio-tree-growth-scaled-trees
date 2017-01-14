require "util/entities"
local mutateTree = require "util/tree"
require "config"

-- @param options a tree entity option table
-- @param an old tree
local createEntityFromTree = function(options, oldTree)
  local baseName = oldTree.name
  local newTree = table.deepcopy(oldTree)
  mutateTree(options, baseName, newTree)
  data:extend({newTree})
  return newTree
end

local function createTreeEntityHierarchyForTree(configuration, oldTree)
  local baseName = oldTree.name
  for _, optionsTable in pairs(configuration) do
    createEntityFromTree(optionsTable, oldTree)
  end
  for _, options in pairs(configuration) do
    local suffix = options.suffix or ("-" .. options.id)
    local newName = baseName .. suffix
    for _, v in pairs(options.next) do
      tree_growth.core.registerUpgrade(newName, baseName .. v.suffix, v.probability, v.minDelay, v.maxDelay)
    end
  end
end

return createTreeEntityHierarchyForTree
