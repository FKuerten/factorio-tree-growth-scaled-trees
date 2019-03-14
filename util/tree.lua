local sqrt = math.sqrt
local round = function(x) return math.floor(x+0.5) end

local function mutateTree(options, baseName, tree)
  local suffix = options.suffix or ("-" .. options.id)
  local areaScale = options.areaScale
  local newName = baseName .. suffix
  local isFirst = options.first
  local isLast = not (options.next and options.next[1])

  tree.name = newName

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
  elseif tree.minable then
    -- guessing no count means 1
    tree.minable.count = round((tree.minable.count or 1) * areaScale)
  end

  if areaScale ~= 1 then
    tree.emissions_per_second = tree.emissions_per_second * areaScale
    tree.max_health = round(tree.max_health * areaScale)
    --tree.collision_box = scaledBox(tree.collision_box, sqrt(areaScale))
    --tree.selection_box = scaledBox(tree.selection_box, sqrt(areaScale))
    if tree.drawing_box then
      tree.drawing_box = scaledBox(tree.drawing_box, sqrt(areaScale))
    end
    if tree.pictures then
      tree.pictures = scaledSpriteVariations(tree.pictures, areaScale)
    end
    if tree.variations then
      tree.variations = scaledTreePrototypeVariations(tree.variations, options.particleSuffix or "", areaScale)
    end
  end
end
return mutateTree
  