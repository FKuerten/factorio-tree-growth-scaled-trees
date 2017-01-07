require "util/entities"
require "util/tree"
require "config"

-- @param options a tree entity option table
-- @param an old tree
createEntityFromTree = function(options, oldTree)
  local baseName = oldTree.name
  local newTree = table.deepcopy(oldTree)
  mutateTree(options, baseName, newTree)

  data:extend({newTree})
  return newTree
end

function createTreeEntityHierarchyForTree(configuration, oldTree)
  for _, optionsTable in pairs(configuration) do
    createEntityFromTree(optionsTable, oldTree)
  end

  tree_growth.defineTreeUpgrades({}, baseName, oldTree)
end
