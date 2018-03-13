function DontSpawn(value)
  local rv = ToClient_DontSpawn(value, false)
  if 0 == rv then
    _PA_LOG("DontSpawn", "CharacterKey : " .. tostring(value) .. "Success")
  else
    _PA_LOG("DontSpawn", "CharacterKey : " .. tostring(value) .. " Failed")
  end
end
function DontSpawnLoop(startValue, endValue)
  for ii = startValue, endValue do
    DontSpawn(ii)
  end
end
function QADontSpawn()
  DontSpawn(100)
  DontSpawnLoop(200, 300)
end
