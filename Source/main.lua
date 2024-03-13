import "CoreLibs/object"
import "CoreLibs/graphics"
import 'text'

---- initialisation
local text = {}
local diceIndex = 1

local newRoll = false
local rollCount = 0
local roll = 0
local prevRoll = 0
local prevRollsLine = ""
local total = 0

-- view
-- playdate.display.setRefreshRate(20)

gfx = playdate.graphics
font = gfx.font.new('fonts/Roobert/Roobert-20-Medium-table-32-32.png')   
local needRefresh = true
local crankStepPerLine = 7

-- code
gfx.setColor(gfx.kColorWhite)
gfx.setFont(font)

math.randomseed(playdate.getSecondsSinceEpoch())
---- initialisation finished

local dices = {2, 4, 6, 8, 10, 12, 20, 100}
function prepareDiceLine(diceIndex)
   local result = ""
   
   for i = 1, #dices do
      local dice = dices[i]
      
      if i == diceIndex then
         result = result .. "["
      end
      
      result = result .. "d"
      result = result .. dice
      
      if i == diceIndex then
         result = result .. "]"
      end

      result = result .. " "
   end
   
   return result
end

function prepareRollLine(rollLine)
   
end

function playdate.update() 
   -- playdate.drawFPS(385, 0) 

   if needRefresh then
      if newRoll and prevRoll > 0 then
         prevRollsLine = prevRoll .. " " .. prevRollsLine --todo: truncate excess line
         newRoll = false
      end
      
      text[1] = prepareDiceLine(diceIndex)
      text[2] = "roll(x" .. rollCount .. "): [" .. roll .. "] " .. prevRollsLine
      text[3] = "sum: " .. total
      text[4] = "two max: " .. math.max(roll, prevRoll)
      text[5] = "two min: " .. math.min(roll, prevRoll)
      text[6] = "two sum: " .. roll + prevRoll
      text[7] = "two sub: " .. prevRoll - roll
      
      drawText(text, 1)
      needRefresh = false
   end
   
   local newdiceIndex = handleContiniousInput(diceIndex)
   if newdiceIndex ~= diceIndex then 
      diceIndex = newdiceIndex
      needRefresh = true
   end

    -- gfx.sprite.update()
    -- playdate.timer.updateTimers()
end

function handleContiniousInput(diceIndex)
   if not playdate.isCrankDocked() then
      local crankChange = playdate.getCrankChange() 
      local crankMoved = math.abs(crankChange) > crankStepPerLine
      if crankMoved and crankChange < 0 then
         diceIndex -= 1
      end
      if crankMoved and crankChange > 0 then
          diceIndex += 1
      end
   end
   
   if playdate.buttonJustPressed(playdate.kButtonLeft) then
      diceIndex -= 1
   end
   if playdate.buttonJustPressed(playdate.kButtonRight) then
       diceIndex += 1
   end
   
   if diceIndex > #dices then
       diceIndex = #dices
   end
   if diceIndex <= 0 then
       diceIndex = 1
   end	 
   
   return diceIndex
end

function playdate.upButtonUp()

end

function playdate.downButtonUp()

end

function playdate.AButtonDown()
   newRoll = true
   needRefresh = true
   
   rollCount += 1
   prevRoll = roll
   roll = math.random(1, dices[diceIndex])
   
   total += roll
end

function playdate.BButtonDown()
   needRefresh = true
   
   rollCount = 0
   roll = 0
   prevRoll = 0
   total = 0
   prevRollsLine = ""
end

function playdate.gameWillTerminate()
   
end

function playdate.deviceWillSleep()

end