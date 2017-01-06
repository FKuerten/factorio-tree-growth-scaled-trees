require "tree-growth-lib/constants"

local sqrt = math.sqrt
local round = function(x) return math.floor(x+0.5) end

function addSeedToMinable(baseName, minable)
  minable.results = {
    {type = "item", name=minable.result, amount=minable.count},
    {type = "item", name=baseName .. "-seed", amount=1},
  }
  minable.count = nil
  minable.result = nil
end

function mutateTree(options, baseName, tree)
  local suffix = options.suffix or ("-" .. options.id)
  local areaScale = options.areaScale
  local newName = baseName .. suffix
  local isFirst = options.first
  local isLast = not (options.next and options.next[1])

  tree.name = newName
  -- assign group
  if isFirst then
    tree.subgroup = tree_growth.groups.sapling -- todo why is this an item subgroup?
  elseif not isLast then
    tree.subgroup = tree_growth.groups.intermediate
  else
    tree.subgroup = tree_growth.groups.mature
  end

  -- only mature trees will be autoplaced
  if not isLast then
    tree.autoplace = nil
  end

  -- since saplings can actually be placed we want to place them on the grid
  if isFirst then
      tree.flags = {"placeable-neutral", "breaths-air"}
  end

  -- saplings return the item, intermediate trees return wood, mature trees have seeds
  if isFirst then
    tree.minable = {
      count = 1,
      mining_particle = "wooden-particle",
      mining_time = 0.1,
      result = newName,
    }
    tree.corpse = nil
    tree.remains_when_mined = nil
  elseif not isLast then
    tree.minable.count = round(tree.minable.count * areaScale)
  else
    addSeedToMinable(baseName, tree.minable)
  end

  if areaScale ~= 1 then
    tree.emissions_per_tick = tree.emissions_per_tick * areaScale
    tree.max_health = round(tree.max_health * areaScale)
    tree.collision_box = scaledBox(tree.collision_box, sqrt(areaScale))
    tree.selection_box = scaledBox(tree.selection_box, sqrt(areaScale))
    if tree.drawing_box then
      tree.drawing_box = scaledBox(tree.drawing_box, sqrt(areaScale))
    end
    if tree.pictures then
      tree.pictures = scaledPictures(tree.pictures, areaScale)
    end
    if tree.variations then
      tree.variations = scaledVariations(tree.variations, options.particleSuffix or "", areaScale)
    end
  end

  if not isLast then
    local nextTrees = {}
    for i, data in ipairs(options.next) do
      assert((data.minDelay and data.maxDelay) or data.delay, "need to specify at minDelay and maxDelay or delay")
      nextTrees[i] = {
        name = baseName .. data.suffix,
        minDelay = data.minDelay or data.delay,
        maxDelay = data.maxDelay or data.delay,
        probability = data.probability,
      }
    end
    tree.order = serpent.dump(nextTrees)
  else
    tree.order = nil
  end
end
