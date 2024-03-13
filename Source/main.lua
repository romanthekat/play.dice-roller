import "CoreLibs/object"
import "CoreLibs/graphics"
import 'text'

---- initialisation
local dices = {2, 4, 6, 8, 10, 12, 20, 100}
local diceIndex = 3

local newRoll = false
local roll = 0
local prevRoll = 0
local rollCount = 0
local total = 0

local prevRollsLine = ""
local text = {}
-- view
-- playdate.display.setRefreshRate(30)

gfx = playdate.graphics
font = gfx.font.new('fonts/Roobert/Roobert-20-Medium-table-32-32.png')   

-- code
gfx.setColor(gfx.kColorWhite)
gfx.setFont(font)

math.randomseed(playdate.getSecondsSinceEpoch())
---- initialisation finished

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

   if newRoll and prevRoll > 0 then
      if #prevRollsLine > 16 then
         prevRollsLine = string.sub(prevRollsLine, 1, 16)
      end 
      prevRollsLine = prevRoll .. " " .. prevRollsLine 
      newRoll = false
   end
      
   text[1] = prepareDiceLine(diceIndex)
   text[2] = "rolls(x" .. rollCount .. "): [" .. roll .. "] " .. prevRollsLine
   text[3] = "sum: " .. total
   text[4] = "two max: " .. math.max(roll, prevRoll) .. ", min: " .. math.min(roll, prevRoll)
   text[5] = "       sum: " .. roll + prevRoll .. ", sub: " .. prevRoll - roll
      
   drawText(text, 1)
   
   playdate.stop()
   playdate.display.flush()
    -- gfx.sprite.update()
    -- playdate.timer.updateTimers()
end

function playdate.leftButtonDown()
   diceIndex -= 1
   if diceIndex <= 0 then
       diceIndex = 1
   end
   
   playdate.start()
end


function playdate.rightButtonDown()
   diceIndex += 1
   if diceIndex > #dices then
       diceIndex = #dices
   end
   
   playdate.start()
end

function playdate.AButtonDown()
   newRoll = true
   
   rollCount += 1
   prevRoll = roll
   roll = math.random(1, dices[diceIndex])
   
   total += roll
   
   playdate.start()
end

function playdate.BButtonDown()
   rollCount = 0
   roll = 0
   prevRoll = 0
   total = 0
   prevRollsLine = ""
   
   playdate.start()
end

function playdate.gameWillTerminate()
   
end

function playdate.deviceWillSleep()

end