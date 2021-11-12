ESX = nil
local menuOpen = false
local wasOpen = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

-- Menu
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)


		for i=1, #Config.Position, 1 do
			local distance = GetDistanceBetweenCoords(coords, Config.Position[i], true)

			if distance < 1.5 then
				Draw3DText(Config.Position[i].x, Config.Position[i].y, Config.Position[i].z, _U('3dtext'))
			end

			if not menuOpen then
					
				if IsControlJustReleased(0, 38) then
					wasOpen = true
					OpenMenu()
				end
			else
					Citizen.Wait(500)
			end
		end
	end
end)


-- Create Blips
Citizen.CreateThread(function()
	for i=1, #Config.Position, 1 do
		local blip = AddBlipForCoord(Config.Position[i])

		SetBlipSprite (blip, Config.BlipSprite)
		SetBlipDisplay(blip, Config.Displate)
		SetBlipScale  (blip, Config.Scale)
		SetBlipColour (blip, Config.BlipColour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName(_U('blipname'))
		EndTextCommandSetBlipName(blip)
	end
end)

--MENU
function OpenMenu()
	ESX.UI.Menu.CloseAll()
	menuOpen = true
	local buyElements = {}
	
	for k, v in pairs(Config.Prices) do
		table.insert(buyElements, {
			label = ('%s  <span style="color:green;">%s</span>'):format(v.label, "$" .. ESX.Math.GroupDigits(v.price)),
			label2 = v.label,
			name = v.value,
			price = v.price,
		})
	end


	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ol_buy_menu', {
		title    = _U("menutitle"),
		align    = Config.MenuAlign,
		elements = buyElements
	}, function(data, menu)
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ol_buy_amount',{
					title = _U('menu_buyamount')
					},
					function(data2, menu2)
					
					local amount = tonumber(data2.value)


						menu2.close()
						if amount == nil then
							ESX.ShowNotification(_U('invalidi_quantity'))
						else
							TriggerServerEvent('ol-vending:buyItem', data.current.price, amount, data.current.name, data.current.label2)
						end

					end, function(data2, menu2)
						menu2.close()
					end)
		
		
	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end

-- DrawText3D
function Draw3DText(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end