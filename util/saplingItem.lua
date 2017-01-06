require "tree-growth-lib/constants"
require "config"

function createSaplingItemFromTree(tree)
  local name = tree.name .. "-sapling"
  local saplingItem = {
    type = "item",
    name = name,
    icon = tree.icon,
    flags = {"goes-to-main-inventory"},
    subgroup = tree_growth.groups.sapling,
    order = tree.order,
    place_result = name,
    fuel_value = "1MJ", -- todo
    stack_size = 50,
  }
  data:extend({saplingItem})
  return saplingItem
end
