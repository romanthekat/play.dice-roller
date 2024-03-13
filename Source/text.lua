screenWidth, screenHeight = playdate.display.getSize()

linesPerScreen = 11
extraScrollLines = 4

local lineHeight = 32

--- Draws an arbitrary text, starting with line number
function drawText(text, lineNumber)
	gfx.clear()
		
	local screenLine = 1
	while screenLine <= linesPerScreen do
		if lineNumber <= #text then
			line = text[lineNumber]
			local x = 2
			local y = (screenLine-1)*lineHeight
				
			-- printedLength, printedHeight = gfx.drawTextInRect(line, x, y, 400, 240) 
			printedLength, printedHeight = gfx.drawText(line, x, y) 
				
			-- if more than 1 line were drawn, ideally shouldn't happen ever, get rid of this logic?
			if printedHeight > lineHeight then
				screenLine += printedHeight //= lineHeight - 1
			end
		end
			
		lineNumber += 1
		screenLine += 1
	end
	
	playdate.display.flush()
	
	return lineNumber >= #text
end
