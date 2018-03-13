local panelmaxcount = 5
local customPanel = {
  [0] = nil,
  [1] = nil,
  [2] = nil,
  [3] = nil,
  [4] = nil
}
local maxgroupindex = {
  [0] = 0,
  [1] = 0,
  [2] = 0,
  [3] = 0,
  [4] = 0
}
local groupcurrentx = {
  [0] = 0,
  [1] = 0,
  [2] = 0,
  [3] = 0,
  [4] = 0
}
local groupcurrenty = {
  [0] = 0,
  [1] = 0,
  [2] = 0,
  [3] = 0,
  [4] = 0
}
function Set_CustomizationUIPanel(panelindex, panel, groupcount)
  if CppEnums.CountryType.DEV == getGameServiceType() then
    if panelindex >= panelmaxcount then
      return
    end
    customPanel[panelindex] = panel
    customPanel[panelindex]:setUsableConsolePanel(true)
    maxgroupindex[panelindex] = groupcount - 1
  end
end
function Add_CustomizationUIGroup(panelindex, groupindex, controltype, isclearcurrentindex)
  if CppEnums.CountryType.DEV == getGameServiceType() and nil ~= customPanel[panelindex] then
    local group = customPanel[panelindex]:addConsoleUIGroup(groupindex, controltype)
    if nil ~= isclearcurrentindex then
      group:setisClearCurrentIndex(isclearcurrentindex)
    end
  end
end
function Delete_CustomizationUIGroup(panelindex, groupindex, refreshGroup)
  if CppEnums.CountryType.DEV == getGameServiceType() then
    customPanel[panelindex]:deleteConsoleUIGroup(groupindex, refreshGroup)
  end
end
function Clear_CustomizationUIGroup(panelindex, groupindex)
  if CppEnums.CountryType.DEV == getGameServiceType() and nil ~= customPanel[panelindex] and groupindex <= maxgroupindex[panelindex] then
    customPanel[panelindex]:deleteConsoleUIGroup(groupindex)
  end
end
function ClearAll_CustomizationUIGroup(panelindex)
  if CppEnums.CountryType.DEV == getGameServiceType() then
    customPanel[panelindex]:clearGruop()
  end
end
function Add_CustomizationUIControl(panelindex, groupindex, x, y, xcount, ycount, control)
  if CppEnums.CountryType.DEV == getGameServiceType() then
    local group = customPanel[panelindex]:getConsoleUIGroup(groupindex)
    if nil ~= group then
      group:addControl(x, y, xcount, ycount, control)
    end
  end
end
function Set_CustomizationUIgroupcount(panelindex, groupcount)
  if CppEnums.CountryType.DEV == getGameServiceType() then
    if panelindex >= panelmaxcount then
      return
    end
    maxgroupindex[panelindex] = groupcount - 1
  end
end
function Set_CustomizationUIgroupCurrentIndex(panelindex, groupindex, indexX, indexY)
  if CppEnums.CountryType.DEV == getGameServiceType() then
    if panelindex >= panelmaxcount then
      return
    end
    local group = customPanel[panelindex]:getConsoleUIGroup(groupindex)
    group:setCurrentIndex(indexX, indexY)
  end
end
function Get_CustomizationUIgroupCurrentIndexX(panelindex, groupindex)
  if CppEnums.CountryType.DEV == getGameServiceType() then
    if panelindex >= panelmaxcount then
      return -1
    end
    local group = customPanel[panelindex]:getConsoleUIGroup(groupindex)
    if nil ~= group then
      return group:getCurrentIndexX()
    else
      return -1
    end
  end
end
function Get_CustomizationUIgroupCurrentIndexY(panelindex, groupindex)
  if CppEnums.CountryType.DEV == getGameServiceType() then
    if panelindex >= panelmaxcount then
      return -1
    end
    local group = customPanel[panelindex]:getConsoleUIGroup(groupindex)
    if nil ~= group then
      return group:getCurrentIndexY()
    else
      return -1
    end
  end
end
function Set_CustomizationUIgroupConsoleEvent(panelindex, groupindex, eventname, keytype)
  if CppEnums.CountryType.DEV == getGameServiceType() then
    if panelindex >= panelmaxcount then
      return
    end
    local group = customPanel[panelindex]:getConsoleUIGroup(groupindex)
    if nil ~= group then
      group:setConsoleKeyEventForLUA(eventname, keytype)
    end
  end
end
