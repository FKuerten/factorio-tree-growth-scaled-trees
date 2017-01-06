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

scaledCreateParticle = function(oldPic, suffix, scale)
  local linScale = sqrt(scale)
  local type = oldPic.type
  local newPic = table.deepcopy(oldPic)
  newPic.entity_name = oldPic.entity_name .. suffix
  newPic.offset_deviation = scaledBox(oldPic.offset_deviation, linScale)
  newPic.initial_height = oldPic.initial_height * linScale
  newPic.initial_height_deviation = oldPic.initial_height_deviation * linScale
  newPic.speed_from_center = oldPic.speed_from_center * linScale
  newPic.scale = linScale
  return newPic
end

scaledPictures = function(oldPictures, scale)
  local pictures = {}
  for i, oldPic in ipairs(oldPictures) do
    pictures[i] = scaledPicture(oldPic, scale)
  end
  return pictures
end

scaledVariations = function(oldVariations, suffix, scale)
  local newVariations = {}
  for i, oldVariation in ipairs(oldVariations) do
    local newVariation = {}
    for k, oldPic in pairs(oldVariation) do
      local type = oldPic.type
      if not type then
        newVariation[k] = scaledPicture(oldPic, scale)
      elseif type == "create-particle" then
        newVariation[k] = scaledCreateParticle(oldPic, suffix, scale)
      end
    end
    newVariations[i] = newVariation
  end
  return newVariations
end
