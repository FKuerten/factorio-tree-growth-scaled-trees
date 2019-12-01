local createTreeEntityHierarchyForTree = require "prototypes/treeEntities"
local createSaplingItemFromTree = require "util/saplingItem"
local createParticles = require "util/particles"
local configuration = require "config"
local mutateTree = require "util/tree"

-- Create particles for small trees
for _, optionsTable in pairs(configuration.particles) do
  local suffix = optionsTable.suffix or ("-" .. optionsTable.id)
  createParticles(optionsTable.suffix, optionsTable.areaScale)
end

-- Industrial Revolution Compatibility
if mods['IndustrialRevolution'] then
  do
    local baseName = 'tree-04'
    local newTree = table.deepcopy(data.raw.tree[baseName])
    mutateTree(configuration.saplingDefinition, baseName, newTree)
    data:extend({newTree})
  end
  do
    local baseName = 'deadlock-rubber-tree'
    local newTree = table.deepcopy(data.raw.tree[baseName])
    mutateTree(configuration.saplingDefinition, baseName, newTree)
    data:extend({newTree})
  end
end

-- Loop over all existing trees
local oldTrees = data.raw.tree
for _, oldTree in pairs(oldTrees) do
  local skip = false

  if oldTree.subgroup ~= "trees" then
    skip = true
  end
  
  if oldTree.name:find("dead") or oldTree.name:find("dry") then
    skip = true
  end

  if not skip then
    if mods['IndustrialRevolution'] then
      createTreeEntityHierarchyForTree(configuration.treeEntities, oldTree)
      for _, v in pairs(configuration.saplingDefinition.next) do
        local saplingEntityName = (oldTree.name == "deadlock-rubber-tree") and "deadlock-rubber-tree-sapling" or "tree-04-sapling"
        tree_growth.core.registerUpgrade{base = saplingEntityName, upgrade = oldTree.name .. v.suffix, probability = v.probability, minDelay = v.minDelay, maxDelay = v.maxDelay, variations="id"}
      end
    else
      createSaplingItemFromTree(oldTree)
      createTreeEntityHierarchyForTree(configuration.treeEntities, oldTree)
    end
  end
end
