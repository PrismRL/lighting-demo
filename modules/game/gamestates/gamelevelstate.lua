local controls = require "controls"

--- @class GameLevelState : LevelState
--- @overload fun(display: Display): GameLevelState
local GameLevelState = spectrum.gamestates.LevelState:extend "GameLevelState"

--- @param display Display
function GameLevelState:__new(display)
   local builder = prism.LevelBuilder()

   builder:rectangle("line", 0, 0, 32, 32, prism.cells.Wall)
   builder:rectangle("fill", 1, 1, 31, 31, prism.cells.Floor)
   builder:rectangle("fill", 5, 5, 7, 7, prism.cells.Wall)
   builder:rectangle("fill", 20, 20, 25, 25, prism.cells.Pit)

   builder:addActor(prism.actors.Player(), 12, 12)
   builder:addActor(prism.actors.Torch(), 20, 17)

   -- Keep a reference to the light system
   self.lightSystem = prism.systems.LightSystem()
   -- Add the light system as well as the light sight system, an extension of the sight system that
   -- limits sight by the lighting.
   builder:addSystems(prism.systems.SensesSystem(), prism.systems.LightSightSystem(), self.lightSystem)

   -- A (display) pass modifies an entity's drawable before it's drawn to the display.
   -- We provide a reasonable default pass that applies light values to entities. Extend or create your own
   -- pass to modify how lighting gets drawn!
   self.lightPass = spectrum.passes.SightLightPass(self.lightSystem)

   -- Add the lighting render pass to the display. Without this, everything would
   -- get drawn with their normal color but with light sight applied.
   display:pushPass(self.lightPass)

   self.super.__new(self, builder:build(prism.cells.Wall), display)
end

function GameLevelState:update(dt)
   GameLevelState.super.update(self, dt)
   self.lightSystem:update(dt)
end

function GameLevelState:handleMessage(message)
   self.super.handleMessage(self, message)
end

function GameLevelState:updateDecision(dt, owner, decision)
   controls:update()

   if controls.move.pressed then
      local destination = owner:getPosition() + controls.move.vector
      local move = prism.actions.Move(owner, destination)
      if self:setAction(move) then return end
   end

   if controls.wait.pressed then self:setAction(prism.actions.Wait(owner)) end
end

function GameLevelState:draw()
   self.display:clear()

   local player = self.level:query(prism.components.PlayerController):first()

   if not player then
      self.display:putLevel(self.level)
   else
      local position = player:expectPosition()

      local x, y = self.display:getCenterOffset(position:decompose())
      self.display:setCamera(x, y)

      local primary, secondary = self:getSenses()
      self.display:beginCamera()
      -- The light pass requires an actor to act as the perspective!
      self.lightPass:setPlayer(player)
      self.display:putSenses(primary, secondary, self.level)
      self.display:endCamera()
   end

   self.display:draw()
end

function GameLevelState:resume()
   self.level:getSystem(prism.systems.SensesSystem):postInitialize(self.level)
end

return GameLevelState
