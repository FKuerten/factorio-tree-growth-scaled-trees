-- We need smaller particles for smaller trees
local function scaleParticle(oldParticle, suffix, areaScale)
  local newParticle = table.deepcopy(oldParticle)
  newParticle.name = oldParticle.name .. suffix
  newParticle.pictures = scaledPictures(oldParticle.pictures, areaScale)
  newParticle.shadows = scaledPictures(oldParticle.shadows, areaScale)
  return newParticle
end

function createParticles(suffix, areaScale)
  data:extend({
    scaleParticle(data.raw["leaf-particle"]["leaf-particle"], suffix, areaScale),
    scaleParticle(data.raw["particle"]["branch-particle"], suffix, areaScale),
  })
end