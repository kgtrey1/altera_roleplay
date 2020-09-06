ARP.Streaming.RequestModel = function(modelHash, cb)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if (not HasModelLoaded(modelHash)) then
		RequestModel(modelHash)
		while (not HasModelLoaded(modelHash)) do
			Citizen.Wait(1)
		end
	end
	if (cb ~= nil) then
		cb()
	end
end

ARP.Streaming.RequestAnimSet = function(animSet, cb)
	if (not HasAnimSetLoaded(animSet)) then
		RequestAnimSet(animSet)
		while (not HasAnimSetLoaded(animSet)) do
			Citizen.Wait(1)
		end
	end
	if (cb ~= nil) then
		cb()
	end
end

ARP.Streaming.RequestAnimDict = function(animDict, cb)
	if (not HasAnimDictLoaded(animDict)) then
		RequestAnimDict(animDict)
		while (not HasAnimDictLoaded(animDict)) do
			Citizen.Wait(1)
		end
	end
	if (cb ~= nil) then
		cb()
	end
end