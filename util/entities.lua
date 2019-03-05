local sqrt = math.sqrt
local round = function(x) return math.floor(x+0.5) end

scaledBox = function(oldBox, linScale)
  local newBox = {}
  for k,v in ipairs(oldBox) do
    local n = {}
    for kk,vv in ipairs(v) do
      n[kk] = vv * linScale
    end
    newBox[k] = n
  end
  return newBox
end

scaledPicture = function(oldPic, scale)
  local linScale = sqrt(scale)
  local newPic = table.deepcopy(oldPic)
  if oldPic.shift then
    newPic.shift = { oldPic.shift[1] * linScale, oldPic.shift[2] * linScale}
  end
  newPic.scale = linScale
  return newPic
end

scaledAnimation = function(oldAnimation, areaScale)
  local lenScale = sqrt(areaScale)
  local newAnimation = table.deepcopy(oldAnimation)
  if oldAnimation.shift then
    newAnimation.shift = { oldAnimation.shift[1] * lenScale, oldAnimation.shift[2] * lenScale}
  end
  newAnimation.scale = lenScale

  if oldAnimation.hr_version then
    newAnimation.hr_version = scaledAnimation(oldAnimation.hr_version, areaScale)
  end

  return newAnimation
end

scaledCreateParticleTriggerEffectItem = function(oldCreateParticleTriggerEffectItem, suffix, areaScale)
  local lenScale = sqrt(areaScale)
  local newCreateParticleTriggerEffectItem = table.deepcopy(oldCreateParticleTriggerEffectItem)
  for k, v in pairs({'initial_height', 'initial_height_deviation', 'initial_vertical_speed', 'initial_vertical_speed', 'speed_from_center', 'speed_from_center_deviation'}) do
    if oldCreateParticleTriggerEffectItem[k] then
      newCreateParticleTriggerEffectItem[k] = v * lenScale
    end
  end
  newCreateParticleTriggerEffectItem.entity_name = oldCreateParticleTriggerEffectItem.entity_name .. suffix
  newCreateParticleTriggerEffectItem.offset_deviation = scaledBox(oldCreateParticleTriggerEffectItem.offset_deviation, lenScale)
  return newCreateParticleTriggerEffectItem
end

--deprecated
scaledPictures = function(oldPictures, scale)
  local pictures = {}
  for i, oldPic in ipairs(oldPictures) do
    pictures[i] = scaledPicture(oldPic, scale)
  end
  return pictures
end

scaledSpriteVariations = function(oldSpriteVariations, areaScale)
  local newSpriteVariations = {}
  for i, oldSprite in ipairs(oldSpriteVariations) do
    newSpriteVariations[i] = scaledPicture(oldSprite, areaScale)
  end
  return newSpriteVariations
end

scaledTreePrototypeVariations = function(oldTreePrototypeVariations, suffix, areaScale)
  local newTreePrototypeVariations = {}
  for i, oldTreePrototypeVariation in ipairs(oldTreePrototypeVariations) do
    local newTreePrototypeVariation = {}
    for k, oldPic in pairs(oldTreePrototypeVariation) do
      local type = oldPic.type
      if not type then
        newTreePrototypeVariation[k] = scaledAnimation(oldPic, areaScale)
      elseif type == "create-particle" then
        newTreePrototypeVariation[k] = scaledCreateParticleTriggerEffectItem(oldPic, suffix, areaScale)
      end
    end
    newTreePrototypeVariations[i] = newTreePrototypeVariation
  end
  return newTreePrototypeVariations
end
