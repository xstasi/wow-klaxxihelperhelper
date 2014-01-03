-- insantiate dbm mod for dbm helpers
local mod = DBM:NewMod('blah' .. math.random(0, 123456), 'blah')

-- create namespace (should be onload/xml)
if not KlaxxiHH then KlaxxiHH = {} end

KlaxxiHH.OutWarning = mod:NewSpecialWarning('Move away from others!')

-- debugging stuff
if not KlaxxiHH.Camp then KlaxxiHH.Camp = 'dummy' end
print( KlaxxiHH.Camp )
print( KlaxxiHH.LiteralCamp )

-- Addon frame
if not KlaxxiHHFrame then  CreateFrame("Frame", "KlaxxiHHFrame", UIParent)
end

-- Raid marker => name translator
function KlaxxiHH.MarkerTranslator(marker)
   local marker_number  = string.sub(marker,4,4)
   if marker_number == "6" then return "square" end
   if marker_number == "4" then return "triangle" end
   if marker_number == "7" then return "cross" end
   if marker_number == "1" then return "star" end
end

-- Handler for incoming whispers
function KlaxxiHH.WhisperHandler(self, event, ...)
   -- If we receive a whisper
   if(event == 'CHAT_MSG_WHISPER') then
      local msg, sender = ...
      -- If it contains "Your camp is", store the camp name
      if string.find(msg, "Your camp is ") then
         KlaxxiHH.Camp = string.sub(msg, strlen("Your camp is ") + 1)
         KlaxxiHH.LiteralCamp = KlaxxiHH.MarkerTranslator(KlaxxiHH.Camp)
         print("Got camp: " .. KlaxxiHH.Camp .. " (" .. KlaxxiHH.LiteralCamp .. "), sender: " .. sender )
         KlaxxiHH.MoveWarning = mod:NewSpecialWarning('Move to ' .. KlaxxiHH.LiteralCamp .. '!')
      elseif string.find(msg, "TO THE CAMP!") then
         KlaxxiHH.MoveWarning:Show()
      elseif string.find(msg, "GET OUT!") then
         KlaxxiHH.OutWarning:Show()
      else
         print("not matched")
      end
   end
end    

-- Hook to whispers
KlaxxiHHFrame:RegisterEvent('CHAT_MSG_WHISPER')
KlaxxiHHFrame:SetScript("OnEvent", KlaxxiHH.WhisperHandler)

-- KlaxxiHHFrame:UnregisterEvent('CHAT_MSG_WHISPER_INFORM')
