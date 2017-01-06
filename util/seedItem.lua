require "tree-growth-lib/constants"
require "config"

function createSeedItemFromTree(tree)
  local name = tree.name .. "-seed"
  local seedItem = {
    type = "item",
    name = name,
    icon = tree.icon, -- TODO better icon for seed
    flags = {"goes-to-main-inventory"},
    subgroup = configuration.groups.seed,
    order = tree.order,
    stack_size = 50,
  }
  data:extend({seedItem})
  return seedItem
end
