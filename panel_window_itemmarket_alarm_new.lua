Panel_Window_ItemMarketAlarmList_New:SetShow(false)
local PaGlobal_ItemMarket_Alarm = {
  _ui = {
    _closeBtn = UI.getChildControl(Panel_Window_ItemMarketAlarmList_New, "Button_Win_Close"),
    _alramList = UI.getChildControl(Panel_Window_ItemMarketAlarmList_New, "List2_RegistItmeList"),
    _descBg = UI.getChildControl(Panel_Window_ItemMarketAlarmList_New, "Static_DescBg"),
    _checkRemainMsg = UI.getChildControl(Panel_Window_ItemMarketAlarmList_New, "CheckButton_RemainMessage"),
    _desc = nil
  },
  _currentCount = 0,
  _maxCount = 20,
  _content = {}
}
function PaGlobal_ItemMarket_Alarm:Init()
  self._ui._desc = UI.getChildControl(self._ui._descBg, "StaticText_Desc")
  self._ui._desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._desc:SetText(self._ui._desc:GetText())
  local bgSizeY = math.max(self._ui._descBg:GetSizeY(), self._ui._desc:GetTextSizeY() + 10)
  self._ui._descBg:SetSize(self._ui._descBg:GetSizeX(), bgSizeY)
  Panel_Window_ItemMarketAlarmList_New:SetSize(Panel_Window_ItemMarketAlarmList_New:GetSizeX(), bgSizeY + 335)
  self._ui._desc:ComputePos()
  self._ui._closeBtn:addInputEvent("Mouse_LUp", "ItemMarket_AlarmList_Close()")
  self._ui._checkRemainMsg:addInputEvent("Mouse_LUp", "PaGlobal_ItemMarket_Alarm_SetCheck()")
  local alarmState = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ItemMarketAlarm)
  if 0 == alarmState then
    self._ui._checkRemainMsg:SetCheck(true)
  elseif 1 == alarmState then
    self._ui._checkRemainMsg:SetCheck(true)
  else
    self._ui._checkRemainMsg:SetCheck(false)
  end
  self._ui._alramList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "ItemMarket_AlarmList_ControlCreate")
  self._ui._alramList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  registerEvent("FromClient_NotifySellByreservation", "FromClient_NotifySellByreservation")
  registerEvent("onScreenResize", "Panel_ItemMarketAlarmList_New_Repos")
  Panel_Window_ItemMarketAlarmList_New:RegisterShowEventFunc(true, "Panel_ItemMarketAlarmList_New_ShowAni()")
  Panel_Window_ItemMarketAlarmList_New:RegisterShowEventFunc(false, "Panel_ItemMarketAlarmList_New_HideAni()")
end
function Panel_ItemMarketAlarmList_New_ShowAni()
end
function Panel_ItemMarketAlarmList_New_HideAni()
end
function PaGlobal_ItemMarket_Alarm_SetCheck()
  if PaGlobal_ItemMarket_Alarm._ui._checkRemainMsg:IsCheck() then
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ItemMarketAlarm, 1, CppEnums.VariableStorageType.eVariableStorageType_User)
  else
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ItemMarketAlarm, 2, CppEnums.VariableStorageType.eVariableStorageType_User)
  end
end
function ItemMarket_AlarmList_ControlCreate(content, key)
  local self = PaGlobal_ItemMarket_Alarm
  local recentBg = UI.getChildControl(content, "Static_RecentRegistBg")
  local alarmType = UI.getChildControl(content, "StaticText_AlarmType")
  local desc = UI.getChildControl(content, "StaticText_Desc")
  local btnCancel = UI.getChildControl(content, "Button_AlarmCancel")
  desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  btnCancel:SetShow(false)
  local index = Int64toInt32(key)
  local info = toClient_GetItemMarketFavoriteItemAlarmRecode(index)
  if nil == info then
    return
  end
  local itemSSW = getItemEnchantStaticStatus(info:getItemEnchantKey())
  if nil == itemSSW then
    return
  end
  local itemName = FGlobal_ChangeItemNameColorByGrade(info:getItemEnchantKey())
  if true == info:isSoldOut() then
    alarmType:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ALARM_SOLDOUTTITLE"))
    desc:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ALARM_SOLDOUTDESC", "time", info:getAlarmTime(), "itemName", itemName))
  else
    alarmType:SetText("")
    desc:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ALARM_CANCELDESC", "time", info:getAlarmTime(), "itemName", itemName))
    if PaGlobal_ItemMarket_Alarm:checkItmeKey(info:getItemEnchantKey()) then
      btnCancel:SetShow(true)
      btnCancel:addInputEvent("Mouse_LUp", "PaGlobal_ItemMarket_Alarm_Delete(" .. index .. ")")
    else
      alarmType:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ALARM_CANCELTITLE"))
    end
  end
  recentBg:SetShow(index == self._currentCount)
end
function PaGlobal_ItemMarket_Alarm_Delete(index)
  local self = PaGlobal_ItemMarket_Alarm
  local info = toClient_GetItemMarketFavoriteItemAlarmRecode(index)
  if nil == info then
    return
  end
  local enchantItemKey = info:getItemEnchantKey()
  local function doDelete()
    if nil ~= enchantItemKey:get() then
      toClient_EraseItemMarketFavoriteItem(enchantItemKey:get())
      PaGlobal_ItemMarket_Alarm:Reload()
    end
  end
  local itemSSW = getItemEnchantStaticStatus(enchantItemKey)
  if nil == itemSSW then
    return
  end
  local itemName = FGlobal_ChangeItemNameColorByGrade(enchantItemKey)
  local _contenet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ALARM_CANCELMSG", "itemName", itemName)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ALARM_CANCELMSGTITLE"),
    content = _contenet,
    functionYes = doDelete,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FGlobal_ChangeItemNameColorByGrade(enchantItemKey)
  local self = PaGlobal_ItemMarket_Alarm
  local itemSSW = getItemEnchantStaticStatus(enchantItemKey)
  if nil == itemSSW then
    return
  end
  local name = itemSSW:getName()
  local itemGrade = itemSSW:getGradeType()
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
    if 1 == enchantLevel then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_16") .. " " .. name
    elseif 2 == enchantLevel then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_17") .. " " .. name
    elseif 3 == enchantLevel then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_18") .. " " .. name
    elseif 4 == enchantLevel then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_19") .. " " .. name
    elseif 5 == enchantLevel then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_20") .. " " .. name
    end
  elseif enchantLevel > 0 and enchantLevel < 16 then
    name = "+" .. tostring(enchantLevel) .. " " .. name
  elseif 16 == enchantLevel then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_16") .. " " .. name
  elseif 17 == enchantLevel then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_17") .. " " .. name
  elseif 18 == enchantLevel then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_18") .. " " .. name
  elseif 19 == enchantLevel then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_19") .. " " .. name
  elseif 20 == enchantLevel then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_20") .. " " .. name
  end
  local colorName = ""
  if 0 == itemGrade then
    colorName = "<PAColor0xffffffff>[" .. name .. "]<PAOldColor>"
  elseif 1 == itemGrade then
    colorName = "<PAColor0xff5dff70>[" .. name .. "]<PAOldColor>"
  elseif 2 == itemGrade then
    colorName = "<PAColor0xff4b97ff>[" .. name .. "]<PAOldColor>"
  elseif 3 == itemGrade then
    colorName = "<PAColor0xffffc832>[" .. name .. "]<PAOldColor>"
  elseif 4 == itemGrade then
    colorName = "<PAColor0xffff6c00>[" .. name .. "]<PAOldColor>"
  else
    colorName = "<PAColor0xffffffff>[" .. name .. "]<PAOldColor>"
  end
  return colorName
end
function PaGlobal_ItemMarket_Alarm:Update(enchantItemKey, playerName)
  local isSoldOut = nil ~= playerName
  toClient_AddItemMarketFavoriteItemAlarmRecode(enchantItemKey, getTimeYearMonthDayHourMinSecByTTime64(getUtc64()), isSoldOut)
  if true == Panel_Window_ItemMarketAlarmList_New:GetShow() then
    self:Reload()
  end
  FGlobal_ItemMarket_NewAlarmShow(enchantItemKey, playerName)
end
function PaGlobal_ItemMarket_Alarm:Reload()
  self._ui._alramList:getElementManager():clearKey()
  for index = toClient_GetItemMarketFavoriteItemAlarmRecodeSize() - 1, 0, -1 do
    self._ui._alramList:getElementManager():pushKey(toInt64(0, index))
  end
end
function FromClient_NotifySellByreservation(characterName, enchantItemKey)
  PaGlobal_ItemMarket_Alarm:Update(ItemEnchantKey(enchantItemKey), characterName)
end
function PaGlobal_ItemMarket_Alarm:checkItmeKey(enchantItemKey)
  local inputKey = enchantItemKey:get()
  local myCount = toClient_GetItemMarketFavoriteItemListSize()
  if myCount > 0 then
    for idx = 0, myCount - 1 do
      local myEnchantItemKey = toClient_GetItemMarketFavoriteItem(idx)
      local compareKey = myEnchantItemKey:get()
      if compareKey == inputKey then
        return true
      end
    end
  end
  return false
end
function FGlobal_ItemMarketAlarm_Open(enchantItemKey)
  if PaGlobal_ItemMarket_Alarm:checkItmeKey(enchantItemKey) then
    PaGlobal_ItemMarket_Alarm:Update(enchantItemKey)
  end
end
function FGlobal_ItemMarketAlarmList_New_Open()
  Panel_Window_ItemMarketAlarmList_New:SetShow(true, true)
  PaGlobal_ItemMarket_Alarm:Reload()
end
function ItemMarket_AlarmList_Close()
  Panel_Window_ItemMarketAlarmList_New:SetShow(false, false)
end
function FGlobal_ItemMarketAlarm_CheckState()
  return PaGlobal_ItemMarket_Alarm._ui._checkRemainMsg:IsCheck()
end
function Panel_ItemMarketAlarmList_New_Repos()
  Panel_Window_ItemMarketAlarmList_New:SetPosX(getScreenSizeX() - Panel_Window_ItemMarketAlarmList_New:GetSizeX() - 20)
  Panel_Window_ItemMarketAlarmList_New:SetPosY(getScreenSizeY() - Panel_Window_ItemMarketAlarmList_New:GetSizeY() - 100)
end
function FGlobal_ItemMarketAlarm_LuaLoadComplete()
  PaGlobal_ItemMarket_Alarm:Init()
  PaGlobal_ItemMarket_Alarm._unreadCount = 0
  if 0 < toClient_GetItemMarketFavoriteItemAlarmRecodeSize() then
    FGlobal_ItemMarket_AlarmIcon_Show()
  end
end
registerEvent("FromClient_luaLoadComplete", "FGlobal_ItemMarketAlarm_LuaLoadComplete")
