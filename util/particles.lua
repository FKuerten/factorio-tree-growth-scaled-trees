
local function createParticles(suffix, areaScale)
  data:extend({
    scaledParticle(data.raw["leaf-particle"]["leaf-particle"], suffix, areaScale),
    scaledParticle(data.raw["particle"]["branch-particle"], suffix, areaScale),
  })
end

return createParticles
