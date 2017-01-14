local createTreeEntityHierarchyForTree = require "prototypes/treeEntities"
local createSaplingItemFromTree = require "util/saplingItem"
local createParticles = require "util/particles"
local configuration = require "config"

-- Create particles for small trees
for _, optionsTable in pairs(configuration.particles) do
  local suffix = optionsTable.suffix or ("-" .. optionsTable.id)
  createParticles(optionsTable.suffix, optionsTable.areaScale)
end

-- Loop over all existing trees
local oldTrees = data.raw.tree
for _, oldTree in pairs(oldTrees) do
  local skip = false

  if oldTree.subgroup ~= "trees" then
    skip = true
  end

  if not skip then
    createSaplingItemFromTree(oldTree)
    createTreeEntityHierarchyForTree(configuration.treeEntities, oldTree)
  end
end
