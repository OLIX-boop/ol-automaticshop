ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end) 

RegisterServerEvent("ol-vending:buyItem")
AddEventHandler("ol-vending:buyItem", function(price, amount, item, label)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not price then
		print((_U('debug')):format(xPlayer.identifier))
		return
	end


	price = ESX.Math.Round(price * amount)
	finalprice = ESX.Math.GroupDigits(price)

	
		xPlayer.removeMoney(price)
		xPlayer.addInventoryItem(item, amount)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Hai comprato ".. amount .. " " .. label .. " per $" .. finalprice)
end)
