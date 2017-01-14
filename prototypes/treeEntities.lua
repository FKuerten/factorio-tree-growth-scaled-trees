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
  for _, optionsTable in pairs(configuration) do
    createEntityFromTree(optionsTable, oldTree)
  end

  tree_growth.defineTreeUpgrades({}, baseName, oldTree)
end
return createTreeEntityHierarchyForTree
