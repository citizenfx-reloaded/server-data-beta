Citizen.CreateThread(function()	
	while true do
    Citizen.Wait(0)

    if(IsGameKeyboardKeyPressed(15)) then
      local players = GetPlayers()
      local y = 0.16		

      local possave = table.pack(GetCharCoordinates(GetPlayerChar(-1)))	
		
			DrawCurvedWindow(0.32, 0.050, 0.32, 0.06, 255)
      displaytext(0.33, 0.050, "X: " .. tostring(possave[1]), 255, 255, 255, 255) 
			displaytext(0.33, 0.070, "Y: " .. tostring(possave[2]), 255, 255, 255, 255) 
			displaytext(0.33, 0.090, "Z: " .. tostring(possave[3]), 255, 255, 255, 255) 
			
      DrawCurvedWindow(0.32, 0.130, 0.32, 0.01, 255)
			displaytext(0.33, 0.130, "Name", 255, 255, 255, 255)
			displaytext(0.57, 0.130, "ID", 255, 255, 255, 255)
			
      DrawCurvedWindow(0.32, 0.110, 0.32, 0.01, 255)
			displaytext(0.33, 0.115, "Teleport: /tp [id] or [name]", 255, 255, 255, 255)
			
      for _, player in ipairs(players) do
			  local r, g, b = GetPlayerRgbColour(player)

        if(IsNetworkPlayerActive(player)) then
          DrawCurvedWindow(0.32, y, 0.32, 0.01, 255)
          displaytext(0.33, y + 0.005, GetPlayerName(player), r, g, b, 255)   		   			  
          displaytext(0.57, y + 0.005, tostring(GetPlayerServerId(player)), r, g, b, 255)

          y = y + 0.034
        end			   
      end
    end
  end
end)

--Drawing
local function setUpDraw(width, height, r, g, b, a, isToggle, isNumber)
  SetTextFont(3)
  SetTextBackground(0)
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextEdge(0, 0, 0, 0, 255)

  SetTextColour(r, g, b, a)
  SetTextScale(width, height)
  SetTextProportional(1)

  SetTextJustify(0)
  SetTextCentre(0)

  if(isToggle) then
    SetTextRightJustify(1)
    SetTextWrap(0.0000, 0.2040)
  elseif(isNumber) then
    SetTextRightJustify(1)
    SetTextWrap(0.0000, 0.1920)
  else
    SetTextRightJustify(0)
  end

  SetTextUseUnderscore(1)
end

function displaytext(x, y, text, r, g, b, a)
  setUpDraw(0.28000000, 0.30000000, r, g, b, a, false, false)

  DisplayTextWithLiteralString(x, y, "STRING", text)
end

