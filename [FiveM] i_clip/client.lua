RegisterNetEvent('stop_save_record')
AddEventHandler('stop_save_record', function()
	if(IsRecording()) then StopRecordingAndSaveClip() end
end)

RegisterNetEvent('stop_discard_record')
AddEventHandler('stop_discard_record', function()
	if(IsRecording()) then StopRecordingAndDiscardClip() end
end)

RegisterNetEvent('start_record_replay')
AddEventHandler('start_record_replay', function()
	if(not IsRecording()) then StartRecording(0) end
end)

RegisterNetEvent('start_record')
AddEventHandler('start_record', function()
	if(not IsRecording()) then StartRecording(1) end
end)
