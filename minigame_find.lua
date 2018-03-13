PaGlobal_MiniGame_Find = {
  _ui = {
    _baseOpenSlot = UI.getChildControl(Panel_MiniGame_Find, "Static_OpenSlot"),
    _baseCloseSlot = UI.getChildControl(Panel_MiniGame_Find, "Static_CloseSlot"),
    _closeButton = UI.getChildControl(Panel_MiniGame_Find, "Button_Win_Close"),
    _rightBG = UI.getChildControl(Panel_MiniGame_Find, "Static_RightBg"),
    _rightBottomBG = UI.getChildControl(Panel_MiniGame_Find, "Static_BottomRightBg"),
    _timerMsg = UI.getChildControl(Panel_MiniGame_MiniGameResult, "StaticText_Msg"),
    _staticObjBg = UI.getChildControl(Panel_MiniGame_Find, "Static_Body")
  },
  _config = {
    _slotCols = 16,
    _slotRows = 16,
    _slotSize = 36,
    _slotStartPosX = 13,
    _slotStartPosY = 45,
    _rewardMaxCount = 6,
    _nextGameSec = 3,
    _slotTypeDefault = 0,
    _slotTypeEmpty = 1,
    _slotTypeMain = 2,
    _slotTypeSub = 3,
    _slotTypeTrap = 5
  },
  _clickType = {LClcik = 1, RClcik = 2},
  _state = {
    None = 0,
    Play = 1,
    Wait = 2,
    Reward = 3
  },
  _rewardSlotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true
  },
  _slots = Array.new(),
  _rewardSlot = Array.new(),
  _gameState = nil,
  _readyToNextGame = false,
  _curSec = 0,
  _gameCurDepth = 0,
  _gameLastDepth = 0,
  _addSize = 16
}
function PaGlobal_MiniGame_Find:initialize()
  self._ui._rightTopBG = UI.getChildControl(self._ui._rightBG, "Static_TopBg")
  self._ui._endurance = UI.getChildControl(self._ui._rightTopBG, "StaticText_DDPercent")
  self._ui._RClickCnt = UI.getChildControl(self._ui._rightTopBG, "StaticText_RClickCount")
  self._ui._LeftValueBg = UI.getChildControl(self._ui._rightBG, "Static_LeftValueBg")
  self._ui._damageGauge = UI.getChildControl(self._ui._rightBG, "Progress2_DamageDegree")
  self._ui._slotBackground = UI.getChildControl(self._ui._rightBG, "Static_RewardSlotBg")
  self._ui._focusSlot = UI.getChildControl(self._ui._rightBG, "Static_CurrentSlotFocus")
  self._ui._gameDepth = UI.getChildControl(self._ui._rightBG, "StaticText_GradeTitle")
  self._ui._curRewardSlot = UI.getChildControl(self._ui._rightBG, "Static_CurrentSlotFocus")
  self._ui._commercialValue = UI.getChildControl(self._ui._rightBG, "StaticText_CommercialValue")
  self._ui._emptyCnt = UI.getChildControl(self._ui._LeftValueBg, "StaticText_LandCountValue")
  self._ui._subObjCnt = UI.getChildControl(self._ui._LeftValueBg, "StaticText_RootCountValue")
  self._ui._trapCnt = UI.getChildControl(self._ui._LeftValueBg, "StaticText_StoneCountValue")
  self:createSlot()
  self:createRewardSlot()
  self:registEventHandler()
  self._messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_NOREWARDALERT"),
    functionYes = FGlobal_MiniGameFind_Close,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  Panel_MiniGame_Find:SetShow(false)
end
function PaGlobal_MiniGame_Find:close()
  self._gameState = self._state.None
  Panel_MiniGame_MiniGameResult:SetShow(false)
  Panel_MiniGame_Find:SetShow(false)
  ToClient_MiniGameFindHide()
end
function PaGlobal_MiniGame_Find:createSlot()
  for col = 0, self._config._slotCols - 1 do
    self._slots[col] = Array.new()
    for row = 0, self._config._slotRows - 1 do
      local slot = {close = nil, open = nil}
      slot.close = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_MiniGame_Find, "Slot_Close_" .. col .. "_" .. row)
      slot.open = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_MiniGame_Find, "Slot_Open_" .. col .. "_" .. row)
      CopyBaseProperty(self._ui._baseCloseSlot, slot.close)
      CopyBaseProperty(self._ui._baseOpenSlot, slot.open)
      slot.close:SetSize(self._config._slotSize, self._config._slotSize)
      slot.close:SetPosX(self._config._slotStartPosX + self._config._slotSize * col)
      slot.close:SetPosY(self._config._slotStartPosY + self._config._slotSize * row)
      slot.close:SetShow(false)
      slot.close:setOnMouseCursorType(__eMouseCursorType_Dig)
      slot.close:setClickMouseCursorType(__eMouseCursorType_Dig)
      slot.open:SetSize(self._config._slotSize, self._config._slotSize)
      slot.open:SetPosX(self._config._slotStartPosX + self._config._slotSize * col)
      slot.open:SetPosY(self._config._slotStartPosY + self._config._slotSize * row)
      slot.open:SetShow(false)
      slot.open:SetEnable(false)
      slot.close:addInputEvent("Mouse_LUp", "PaGlobal_MiniGame_Find:ClickCloseSlot(" .. col .. "," .. row .. "," .. self._clickType.LClcik .. ")")
      slot.close:addInputEvent("Mouse_RUp", "PaGlobal_MiniGame_Find:ClickCloseSlot(" .. col .. "," .. row .. "," .. self._clickType.RClcik .. ")")
      self._slots[col][row] = slot
    end
  end
  self._ui._mainObjBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_MiniGame_Find, "MainObjBG")
  CopyBaseProperty(self._ui._staticObjBg, self._ui._mainObjBG)
  self._ui._mainObjBG:SetShow(false)
end
function PaGlobal_MiniGame_Find:registEventHandler()
  Panel_MiniGame_Find:RegisterUpdateFunc("FGlobal_MiniGameFind_Update")
  self._ui._closeButton:addInputEvent("Mouse_LUp", "PaGlobal_MiniGame_Find:askGameClose()")
  registerEvent("FromClient_MiniGameFindSlotShowEmpty", "FromClient_MiniGameFindSlotShowEmpty")
  registerEvent("FromClient_MiniGameFindSlotShowMain", "FromClient_MiniGameFindSlotShowMain")
  registerEvent("FromClient_MiniGameFindSlotShowMainTexture", "FromClient_MiniGameFindSlotShowMainTexture")
  registerEvent("FromClient_MiniGameFindSlotShowSub", "FromClient_MiniGameFindSlotShowSub")
  registerEvent("FromClient_MiniGameFindSlotShowTrap", "FromClient_MiniGameFindSlotShowTrap")
  registerEvent("FromClient_MiniGameFindSetShow", "FromClient_MiniGameFindSetShow")
  registerEvent("FromClient_MiniGameFindSetReward", "FromClient_MiniGameFindSetReward")
  registerEvent("FromClient_MiniGameFindSetState", "FromClient_MiniGameFindSetState")
  registerEvent("FromClient_MiniGameFindDefaultImage", "FromClient_MiniGameFindDefaultImage")
  registerEvent("FromClient_MiniGameFindDynamicInfo", "FromClient_MiniGameFindDynamicInfo")
  registerEvent("FromClient_MiniGameFindStaticInfo", "FromClient_MiniGameFindStaticInfo")
end
function PaGlobal_MiniGame_Find:ClickCloseSlot(col, row, clickType)
  local itemWrapper = ToClient_getEquipmentItem(CppEnums.EquipSlotNoClient.eEquipSlotNoSubTool)
  if itemWrapper ~= nil and 0 < itemWrapper:get():getEndurance() then
    if self._clickType.LClcik == clickType then
      audioPostEvent_SystemUi(11, 31)
    else
      audioPostEvent_SystemUi(11, 32)
      self._ui._RClickCnt:AddEffect("fUI_Light", false, 5, 0)
      if 0 >= self._tmpRClickCount then
        Proc_ShowMessage_Ack("\234\177\183\236\150\180\235\130\180\234\184\176\235\165\188 \235\170\168\235\145\144 \236\130\172\236\154\169\237\149\152\236\152\128\236\138\181\235\139\136\235\139\164.")
        return
      end
    end
    ToClient_MiniGameFindClick(col, row, clickType)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_NOREWARDALERT"))
  end
end
function PaGlobal_MiniGame_Find:endGame()
  for row = 0, self._config._slotRows - 1 do
    for col = 0, self._config._slotCols - 1 do
      local slot = self._slots[col][row]
      slot.close:SetEnable(false)
    end
  end
  audioPostEvent_SystemUi(11, 33)
end
function PaGlobal_MiniGame_Find:refresh(slotMaxCol, slotMaxRow)
  local diffCount = self._config._slotCols - slotMaxCol
  local slotSize = self._config._slotSize + 3 * diffCount
  for row = 0, self._config._slotRows - 1 do
    for col = 0, self._config._slotCols - 1 do
      local slot = self._slots[col][row]
      if slotMaxCol <= col or slotMaxRow <= row then
        slot.close:SetShow(false)
        slot.close:SetEnable(false)
        slot.open:SetShow(false)
      else
        slot.close:SetSize(slotSize, slotSize)
        slot.close:SetPosX(self._config._slotStartPosX + slotSize * col)
        slot.close:SetPosY(self._config._slotStartPosY + slotSize * row)
        slot.close:SetShow(true)
        slot.close:SetEnable(true)
        slot.open:SetSize(slotSize, slotSize)
        slot.open:SetPosX(self._config._slotStartPosX + slotSize * col)
        slot.open:SetPosY(self._config._slotStartPosY + slotSize * row)
        slot.open:SetColor(Defines.Color.C_FFFFFFFF)
        slot.open:SetShow(false)
      end
    end
  end
  self._ui._mainObjBG:SetSize(self._mainColCnt * slotSize + self._addSize, self._mainRowCnt * slotSize + self._addSize)
end
function PaGlobal_MiniGame_Find:askGameClose()
  if self._state.None == self._gameState then
    self:close()
  else
    MessageBox.showMessageBox(self._messageBoxData)
  end
end
function PaGlobal_MiniGame_Find:createRewardSlot()
  self._ui._slotBackground:SetShow(false)
  for ii = 0, self._config._rewardMaxCount - 1 do
    local slot = {}
    slot.background = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._rightBG, "RewardItemBG_" .. ii)
    CopyBaseProperty(self._ui._slotBackground, slot.background)
    slot.background:SetPosY(200 + ii * 65)
    slot.background:SetShow(true)
    SlotItem.new(slot, "RewardItemIcon_" .. ii, ii, slot.background, self._rewardSlotConfig)
    slot:createChild()
    slot.icon:SetPosX(4)
    slot.icon:SetPosY(4)
    slot.icon:SetShow(true)
    slot.icon:addInputEvent("Mouse_On", "PaGlobal_MiniGame_Find:itemTooltip_Show(" .. ii .. ")")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobal_MiniGame_Find:itemTooltip_Hide()")
    self._rewardSlot[ii] = slot
  end
end
function PaGlobal_MiniGame_Find:itemTooltip_Show(index)
  local itemSSW = getItemEnchantStaticStatus(self._rewardSlot[index].itemNo)
  if nil ~= itemSSW then
    Panel_Tooltip_Item_SetPosition(index, self._rewardSlot[index], "minigameFindReward")
    Panel_Tooltip_Item_Show(itemSSW, Panel_MiniGame_Find, true)
  end
end
function PaGlobal_MiniGame_Find:itemTooltip_Hide()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_MiniGame_Find:getRewardIndex(pct)
  if 100 == pct then
    return 0
  else
    for ii = 1, self._config._rewardMaxCount - 1 do
      if pct <= ii * 20 then
        return self._config._rewardMaxCount - ii
      end
    end
    return self._config._rewardMaxCount - 1
  end
end
function PaGlobal_MiniGame_Find:nextGameStart()
  Panel_MiniGame_MiniGameResult:SetShow(false)
  self._readyToNextGame = false
  self._gameState = self._state.None
  if self._gameCurDepth + 1 <= self._gameLastDepth then
    ToClient_MiniGameFindNext()
  end
end
function FGlobal_MiniGameFind_RefreshText()
  local self = PaGlobal_MiniGame_Find
  local itemWrapper = ToClient_getEquipmentItem(CppEnums.EquipSlotNoClient.eEquipSlotNoSubTool)
  if itemWrapper ~= nil then
    local lv = itemWrapper:get():getKey():getEnchantLevel()
    local RClickCount = ToClient_GetMiniGameToolParam(lv, 0) - self._curRClickCount
    if RClickCount ~= self._tmpRClickCount then
      self._ui._RClickCnt:AddEffect("fUI_Light", false, 5, 0)
      self._tmpRClickCount = RClickCount
    end
    if RClickCount <= 0 then
      RClickCount = 0
    end
    self._ui._RClickCnt:SetText(tostring(RClickCount))
    self._ui._endurance:SetText(tostring(itemWrapper:get():getEndurance()))
  end
end
function FGlobal_MiniGameFind_Close()
  PaGlobal_MiniGame_Find:close()
end
function FGlobal_MiniGameFind_Update(deltaTime)
  local self = PaGlobal_MiniGame_Find
  if self._gameState ~= self._state.Wait then
    return
  end
  if false == self._readyToNextGame then
    return
  end
  self._curSec = self._curSec + deltaTime
  self._ui._timerMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_LEFTTIME", "second", math.floor(self._config._nextGameSec - self._curSec + 1)))
  if self._config._nextGameSec <= self._curSec then
    self:nextGameStart()
  end
end
function FromClient_MiniGameFindSlotShowEmpty(col, row, uv0, uv1, uv2, uv3, imagePath)
  local self = PaGlobal_MiniGame_Find
  local slot = self._slots[col][row].close
  slot:ChangeTextureInfoName(imagePath)
  local xx1, yy1, xx2, yy2 = setTextureUV_Func(slot, uv0, uv1, uv2, uv3)
  slot:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  slot:setRenderTexture(slot:getBaseTexture())
  slot:SetEnable(false)
  slot:AddEffect("fUI_Minigame_Lbutton", false, 0, 0)
end
function FromClient_MiniGameFindSlotShowMain(col, row)
  local self = PaGlobal_MiniGame_Find
  local slot = self._slots[col][row].close
  if false == self._isMainLoad then
    self._ui._mainObjBG:SetPosX(slot:GetPosX() - self._addSize / 2)
    self._ui._mainObjBG:SetPosY(slot:GetPosY() - self._addSize / 2)
    self._ui._mainObjBG:SetShow(true)
    self._isMainLoad = true
  end
  slot:SetEnable(false)
end
function FromClient_MiniGameFindSlotShowMainTexture(mainColCnt, mainRowCnt, uv0, uv1, uv2, uv3, imagePath)
  local self = PaGlobal_MiniGame_Find
  self._mainColCnt = mainColCnt
  self._mainRowCnt = mainRowCnt
  self._ui._mainObjBG:ChangeTextureInfoName(imagePath)
  local xx1, yy1, xx2, yy2 = setTextureUV_Func(self._ui._mainObjBG, uv0, uv1, uv2, uv3)
  self._ui._mainObjBG:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  self._ui._mainObjBG:setRenderTexture(self._ui._mainObjBG:getBaseTexture())
end
function FromClient_MiniGameFindSlotShowSub(col, row, uv0, uv1, uv2, uv3, imagePath, isSuccess)
  local self = PaGlobal_MiniGame_Find
  local slot = self._slots[col][row].open
  slot:ChangeTextureInfoName(imagePath)
  local xx1, yy1, xx2, yy2 = setTextureUV_Func(slot, uv0, uv1, uv2, uv3)
  slot:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  slot:setRenderTexture(slot:getBaseTexture())
  if false == isSuccess then
    slot:SetMonoTone(true)
    slot:SetColor(4288256409)
  else
    slot:SetMonoTone(false)
  end
  slot:SetShow(true)
  slot:AddEffect("fUI_Minigame_Lbutton", false, 0, 0)
end
function FromClient_MiniGameFindSlotShowTrap(col, row, stoneType)
  local self = PaGlobal_MiniGame_Find
  local slot = self._slots[col][row].open
  slot:ChangeTextureInfoName("New_UI_Common_forLua/Window/MiniGame/MiniGameFind_01.dds")
  if 0 == stoneType then
    local xx1, yy1, xx2, yy2 = setTextureUV_Func(slot, 1, 295, 54, 348)
    slot:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  else
    local xx1, yy1, xx2, yy2 = setTextureUV_Func(slot, 1, 349, 54, 402)
    slot:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  end
  slot:setRenderTexture(slot:getBaseTexture())
  self._slots[col][row].open:SetShow(true)
  slot:AddEffect("fUI_Minigame_Rbutton", false, 0, 0)
  audioPostEvent_SystemUi(11, 34)
end
function FromClient_MiniGameFindDynamicInfo(damageRate, RClickCount, emptyCount, subObjCount, trapCount)
  local self = PaGlobal_MiniGame_Find
  local curPercent = damageRate / 10000
  if curPercent <= 0 then
    curPercent = 0
  end
  self._curRClickCount = RClickCount
  FGlobal_MiniGameFind_RefreshText()
  self._ui._commercialValue:SetText(string.format("\236\131\129\237\146\136\236\132\177 : %.1f", curPercent) .. "%")
  self._ui._damageGauge:SetProgressRate(curPercent)
  self._ui._damageGauge:SetCurrentProgressRate(curPercent)
  self._ui._emptyCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_COUNT", "count", emptyCount))
  self._ui._subObjCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_COUNT", "count", subObjCount))
  self._ui._trapCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_COUNT", "count", trapCount))
  if emptyCount ~= self._maxEmptyCount then
    self._ui._emptyCnt:AddEffect("UI_LevelUP_Skill", false, 5, 0)
    self._maxEmptyCount = emptyCount
  end
  if subObjCount ~= self._maxSubObjCount then
    self._ui._subObjCnt:AddEffect("UI_LevelUP_Skill", false, 5, 0)
    self._maxSubObjCount = subObjCount
  end
  if trapCount ~= self._maxTrapCount then
    self._ui._trapCnt:AddEffect("UI_LevelUP_Skill", false, 5, 0)
    self._maxTrapCount = trapCount
  end
  if curPercent ~= self._curPecent then
    self._ui._commercialValue:AddEffect("fUI_Skill_Cooltime01", false, 5, 0)
    self._curPecent = curPercent
  end
  local idx = self:getRewardIndex(curPercent)
  if idx ~= self._rewardIndex then
    self._ui._curRewardSlot:SetPosX(self._rewardSlot[idx].background:GetPosX() - 5)
    self._ui._curRewardSlot:SetPosY(self._rewardSlot[idx].background:GetPosY() - 5)
    self._rewardSlot[self._rewardIndex].icon:SetMonoTone(true)
    self._rewardIndex = idx
  end
end
function FromClient_MiniGameFindStaticInfo(damageRate, RClickCount, emptyCount, subObjCount, trapCount, gameCurDepth, gameLastDepth)
  local self = PaGlobal_MiniGame_Find
  local curPercent = damageRate / 10000
  if curPercent <= 0 then
    curPercent = 0
  end
  self._curRClickCount = 0
  self._curPecent = 100
  self._maxEmptyCount = emptyCount
  self._maxSubObjCount = subObjCount
  self._maxTrapCount = trapCount
  self._gameCurDepth = gameCurDepth
  self._gameLastDepth = gameLastDepth
  FGlobal_MiniGameFind_RefreshText()
  self._ui._commercialValue:SetText(string.format("\236\131\129\237\146\136\236\132\177 : %.1f", curPercent) .. "%")
  self._ui._damageGauge:SetProgressRate(curPercent)
  self._ui._damageGauge:SetCurrentProgressRate(curPercent)
  self._ui._emptyCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_COUNT", "count", self._maxEmptyCount))
  self._ui._subObjCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_COUNT", "count", self._maxSubObjCount))
  self._ui._trapCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_COUNT", "count", self._maxTrapCount))
  self._ui._gameDepth:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_CURRENTGRADE", "currentGrade", self._gameCurDepth, "maxGrade", self._gameLastDepth))
  local idx = self:getRewardIndex(curPercent)
  if 0 == idx then
    for ii = 0, self._config._rewardMaxCount - 1 do
      self._rewardSlot[ii].icon:SetMonoTone(false)
    end
  end
  self._ui._curRewardSlot:SetPosX(self._rewardSlot[idx].background:GetPosX() - 5)
  self._ui._curRewardSlot:SetPosY(self._rewardSlot[idx].background:GetPosY() - 5)
  self._rewardIndex = idx
end
function FromClient_MiniGameFindDefaultImage(col, row, uv0, uv1, uv2, uv3, imagePath)
  local self = PaGlobal_MiniGame_Find
  local slot = self._slots[col][row].close
  slot:ChangeTextureInfoName(imagePath)
  local xx1, yy1, xx2, yy2 = setTextureUV_Func(slot, uv0, uv1, uv2, uv3)
  slot:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  slot:setRenderTexture(slot:getBaseTexture())
end
function FromClient_MiniGameFindSetShow(col, row)
  local self = PaGlobal_MiniGame_Find
  self._tmpRClickCount = 0
  self._gameState = self._state.Play
  self:refresh(col, row)
  self._isMainLoad = false
  Panel_MiniGame_Find:SetShow(true)
end
function FromClient_MiniGameFindSetReward(rewardList)
  if nil == rewardList then
    return
  end
  local self = PaGlobal_MiniGame_Find
  for ii = 0, #rewardList do
    local itemSSW = getItemEnchantStaticStatus(rewardList[ii])
    self._rewardSlot[ii]:setItemByStaticStatus(itemSSW)
    self._rewardSlot[ii].icon:SetShow(true)
    self._rewardSlot[ii].itemNo = rewardList[ii]
  end
end
function FromClient_MiniGameFindSetState(serverState)
  local self = PaGlobal_MiniGame_Find
  self._gameState = serverState
  if serverState == self._state.None then
    self._ui._timerMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_FINISH"))
    self:endGame()
  elseif serverState == self._state.Wait then
    self._readyToNextGame = true
    self._curSec = 0
  end
  Panel_MiniGame_MiniGameResult:SetShow(true)
end
PaGlobal_MiniGame_Find:initialize()
function minigamefind()
  ToClient_MiniGameFindShow(27625)
end
