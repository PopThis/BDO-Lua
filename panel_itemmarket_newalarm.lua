Panel_ItemMarket_NewAlarm:SetShow(false)
local PaGlobal_ItemMarket_NewAlarm = {
  _ui = {
    _bg = UI.getChildControl(Panel_ItemMarket_NewAlarm, "Static_Bg"),
    _date = UI.getChildControl(Panel_ItemMarket_NewAlarm, "StaticText_Date"),
    _desc = UI.getChildControl(Panel_ItemMarket_NewAlarm, "StaticText_Desc")
  },
  _aniTime = 0,
  _maxTime = 5
}
function PaGlobal_ItemMarket_NewAlarm:Init()
  self._ui._desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._bg:addInputEvent("Mouse_LUp", "FGlobal_ItemMarketAlarmList_New_Open()")
  Panel_ItemMarket_NewAlarm:RegisterUpdateFunc("UpdateFunc_checkAlramAnimation")
end
function PaGlobal_ItemMarket_NewAlarm:ShowAni()
  local alarmMoveAni = Panel_ItemMarket_NewAlarm:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  alarmMoveAni:SetStartPosition(getScreenSizeX() + 10, getScreenSizeY() - Panel_ItemMarket_NewAlarm:GetSizeY() - 80)
  alarmMoveAni:SetEndPosition(getScreenSizeX() - Panel_ItemMarket_NewAlarm:GetSizeX() - 20, getScreenSizeY() - Panel_ItemMarket_NewAlarm:GetSizeY() - 80)
  alarmMoveAni.IsChangeChild = true
  Panel_ItemMarket_NewAlarm:CalcUIAniPos(alarmMoveAni)
  alarmMoveAni:SetDisableWhileAni(true)
end
function PaGlobal_ItemMarket_NewAlarm:HideAni()
  local alarmMoveAni = Panel_ItemMarket_NewAlarm:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  alarmMoveAni:SetStartPosition(Panel_ItemMarket_NewAlarm:GetPosX(), getScreenSizeY() - Panel_ItemMarket_NewAlarm:GetSizeY() - 80)
  alarmMoveAni:SetEndPosition(getScreenSizeX() + 10, getScreenSizeY() - Panel_ItemMarket_NewAlarm:GetSizeY() - 80)
  alarmMoveAni.IsChangeChild = true
  Panel_ItemMarket_NewAlarm:CalcUIAniPos(alarmMoveAni)
  alarmMoveAni:SetDisableWhileAni(true)
  alarmMoveAni:SetHideAtEnd(true)
  alarmMoveAni:SetDisableWhileAni(true)
end
function FGlobal_ItemMarket_NewAlarmShow(enchantItemKey, playerName)
  local self = PaGlobal_ItemMarket_NewAlarm
  local itemSSW = getItemEnchantStaticStatus(enchantItemKey)
  if nil == itemSSW then
    return
  end
  local itemName = FGlobal_ChangeItemNameColorByGrade(enchantItemKey)
  if nil ~= playerName then
    self._ui._desc:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ITEMMARKET_SELLBYPREBID_ALARMMSG", "itemName", itemName, "playerName", playerName))
  else
    self._ui._desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGIST_ALARMMSG", "itemName", itemName))
  end
  self._ui._date:SetText(getTimeYearMonthDayHourMinSecByTTime64(getUtc64()))
  Panel_ItemMarket_NewAlarm:SetShow(true)
  self._aniTime = 0
  self:ShowAni()
  FGlobal_ItemMarket_AlarmIcon_Show()
end
function UpdateFunc_checkAlramAnimation(deltaTime)
  if FGlobal_ItemMarketAlarm_CheckState() then
    return
  end
  local self = PaGlobal_ItemMarket_NewAlarm
  self._aniTime = self._aniTime + deltaTime
  if self._maxTime < self._aniTime then
    PaGlobal_ItemMarket_NewAlarm:HideAni()
    self._aniTime = 0
  end
end
PaGlobal_ItemMarket_NewAlarm:Init()
