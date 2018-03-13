PaGlobal_ConsoleQuickMenu = {
  _inventoryData = {},
  _skillData = {},
  _functionTypeData = {},
  _ui = {
    _staticIcon = {},
    _staticTextName = {},
    _buttonPosition = {},
    _buttonPositionIcon = {},
    _quickMenuPosition = {},
    _quickMenuPositionIcon = {}
  },
  _listMaxCount = 5,
  _curPage = 1,
  _curGroup = 0,
  _curPosition = 1,
  _curCategory = 0,
  _center = {_x = 0, _y = 0},
  _selectedIndex = 0
}
function PaGlobal_ConsoleQuickMenu:initializeUI()
  local rightBg = UI.getChildControl(Panel_QuickMenuCustom, "Static_RightBg")
  local leftBg = UI.getChildControl(Panel_QuickMenuCustom, "Static_LeftBg")
  local listBg = UI.getChildControl(rightBg, "Static_Menu")
  for ii = 1, self._listMaxCount do
    local bg = UI.getChildControl(listBg, "Static_MenuSlotBg" .. tostring(ii - 1))
    self._ui._staticIcon[ii] = UI.getChildControl(bg, "Static_MenuSlotIcon")
    self._ui._staticTextName[ii] = UI.getChildControl(bg, "StaticText_MenuName")
    self._ui._staticIcon[ii]:addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenu:registQuickMenu( " .. ii .. ")")
  end
  for ii = 1, __eQuickMenuPosition_Count do
    self._ui._buttonPosition[ii] = UI.getChildControl(leftBg, "Button_Templete" .. tostring(ii - 1))
    self._ui._buttonPosition[ii]:addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenu:setPosition( " .. ii .. ")")
    self._ui._buttonPositionIcon[ii] = UI.getChildControl(self._ui._buttonPosition[ii], "Static_Icon")
  end
  for ii = 1, __eQuickMenuPosition_Count do
    self._ui._quickMenuPosition[ii] = UI.getChildControl(Panel_QuickMenu, "Button_Templete" .. tostring(ii - 1))
    self._ui._quickMenuPositionIcon[ii] = UI.getChildControl(self._ui._quickMenuPosition[ii], "Static_Icon")
  end
  self._ui._center = UI.getChildControl(Panel_QuickMenu, "Static_CenterPoint")
  UI.getChildControl(rightBg, "RadioButton_Skill"):addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenu:CustomSettingSetCategory( " .. __eQuickMenuDataType_Skill .. ")")
  UI.getChildControl(rightBg, "RadioButton_Item"):addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenu:CustomSettingSetCategory( " .. __eQuickMenuDataType_Item .. " )")
  UI.getChildControl(rightBg, "RadioButton_Menu"):addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenu:CustomSettingSetCategory( " .. __eQuickMenuDataType_Function .. " )")
end
function PaGlobal_ConsoleQuickMenu:registQuickMenu(index)
  if __eQuickMenuDataType_Skill == self._curCategory then
    self:registSkill(index)
  elseif __eQuickMenuDataType_Item == self._curCategory then
    self:registItem(index)
  elseif __eQuickMenuDataType_Function == self._curCategory then
    self:registFunctionType(index)
  end
end
function PaGlobal_ConsoleQuickMenu:registItem(index)
  local rv = ToClient_registQuickMenuItem(self._curGroup, self._curPosition - 1, CppEnums.ItemWhereType.eInventory, self._inventoryData[self._listMaxCount * (self._curPage - 1) + index]._slotNo)
  if true == rv then
    local control = PaGlobal_ConsoleQuickMenu._ui._buttonPositionIcon[self._curPosition]
    control:ChangeTextureInfoName(self._inventoryData[self._listMaxCount * (self._curPage - 1) + index]._icon)
    control:getBaseTexture():setUV(0, 0, 1, 1)
    control:setRenderTexture(control:getBaseTexture())
  end
end
function PaGlobal_ConsoleQuickMenu:registSkill(index)
  local rv = ToClient_registQuickMenuSkill(self._curGroup, self._curPosition - 1, self._skillData[self._listMaxCount * (self._curPage - 1) + index]._skillKey)
  if true == rv then
    local control = PaGlobal_ConsoleQuickMenu._ui._buttonPositionIcon[self._curPosition]
    control:ChangeTextureInfoName(self._skillData[self._listMaxCount * (self._curPage - 1) + index]._icon)
    control:getBaseTexture():setUV(0, 0, 1, 1)
    control:setRenderTexture(control:getBaseTexture())
  end
end
function PaGlobal_ConsoleQuickMenu:registFunctionType(index)
  local rv = ToClient_registQuickMenuFunctionType(self._curGroup, self._curPosition - 1, self._functionTypeData[self._listMaxCount * (self._curPage - 1) + index]._enumType)
  if true == rv then
    local data = self._functionTypeData[self._listMaxCount * (self._curPage - 1) + index]
    local control = PaGlobal_ConsoleQuickMenu._ui._buttonPositionIcon[self._curPosition]
    control:ChangeTextureInfoName(data._icon._path)
    control:getBaseTexture():setUV(setTextureUV_Func(control, data._icon._x1, data._icon._y1, data._icon._x2, data._icon._y2))
    control:setRenderTexture(control:getBaseTexture())
  end
end
function PaGlobal_ConsoleQuickMenu:CustomSettingSetCategory(category)
  self._curPage = 1
  self._curCategory = category
  self:CustomSettingUpdateCurrentPage()
end
function PaGlobal_ConsoleQuickMenu:CustomSettingNextPage()
  if __eQuickMenuDataType_Skill == category then
    if #self._skillData < self._listMaxCount * (self._curPage + 1) then
      return
    end
  elseif __eQuickMenuDataType_Item == category then
    if #self._invetoryData < self._listMaxCount * (self._curPage + 1) then
      return
    end
  elseif __eQuickMenuDataType_Function == category and #self._functionTypeData < self._listMaxCount * (self._curPage + 1) then
    return
  end
  self._curPage = self._curPage + 1
  self:CustomSettingUpdateCurrentPage()
end
function PaGlobal_ConsoleQuickMenu:CustomSettingPrevPage()
  if 1 < self._curPage then
    self._curPage = self._curPage - 1
  end
  self:CustomSettingUpdateCurrentPage()
end
function PaGlobal_ConsoleQuickMenu:CustomSettingUpdateCurrentPage()
  for ii = 1, self._listMaxCount do
    local convertIndex = self._listMaxCount * (self._curPage - 1) + ii
    local data
    if __eQuickMenuDataType_Skill == self._curCategory then
      if convertIndex <= #self._skillData then
        data = self._skillData[convertIndex]
      else
      end
    elseif __eQuickMenuDataType_Item == self._curCategory then
      if convertIndex <= #self._inventoryData then
        data = self._inventoryData[convertIndex]
      else
      end
    else
      if __eQuickMenuDataType_Function == self._curCategory and convertIndex <= #self._functionTypeData then
        data = self._functionTypeData[convertIndex]
      else
      end
    end
    if nil ~= data then
      if __eQuickMenuDataType_Function == self._curCategory then
        local control = self._ui._staticIcon[ii]
        control:ChangeTextureInfoName(data._icon._path)
      else
        self._ui._staticIcon[ii]:ChangeTextureInfoName(data._icon)
      end
      self._ui._staticTextName[ii]:SetText(data._name)
    end
  end
end
function PaGlobal_ConsoleQuickMenu:CustomSettingDataUpdate()
  self:getInventToryData()
  self:getSkillData()
  self:getFunctionTypeData()
  for index, value in ipairs(self._inventoryData) do
    _PA_LOG("\237\155\132\236\167\132", "inventory: " .. value._whereType .. ", slotNo: " .. value._slotNo .. " name : " .. value._name .. " icon: " .. value._icon)
  end
  for index, value in ipairs(self._skillData) do
    _PA_LOG("\237\155\132\236\167\132", "_skillKey: " .. value._skillKey .. ", _skillNo: " .. value._skillNo .. " name : " .. value._name .. " icon: " .. value._icon)
  end
end
function PaGlobal_ConsoleQuickMenu:getFunctionTypeData()
  self._functionTypeData = {}
  if nil == self._functionTypeList or nil == self._functionTypeList._icon or nil == self._functionTypeList._name then
    return
  end
  for index = 0, __eQuickMenuFunctionType_Undefined do
    self._functionTypeData[#self._functionTypeData + 1] = {
      _enumType = index,
      _name = self._functionTypeList._name[index],
      _icon = self._functionTypeList._icon[index]
    }
  end
end
function PaGlobal_ConsoleQuickMenu:getInventToryData()
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return nil
  end
  self._inventoryData = {}
  local useStartSlot = inventorySlotNoUserStart()
  local inventorysize = ToClient_InventoryGetSize(CppEnums.ItemWhereType.eInventory)
  for slotNo = useStartSlot, inventorysize - 1 do
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, slotNo)
    if nil ~= itemWrapper and false == itemWrapper:empty() and true == ToClient_isVaildItemRegistQuickMenu(itemWrapper:getStaticStatus()) then
      self._inventoryData[#self._inventoryData + 1] = {
        _whereType = CppEnums.ItemWhereType.eInventory,
        _slotNo = slotNo,
        _name = itemWrapper:getStaticStatus():getName(),
        _icon = "Icon/" .. itemWrapper:getStaticStatus():getIconPath()
      }
    end
  end
  inventorysize = ToClient_InventoryGetSize(CppEnums.ItemWhereType.eCashInventory)
  for slotNo = useStartSlot, inventorysize - 1 do
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, slotNo)
    if nil ~= itemWrapper and false == itemWrapper:empty() and true == ToClient_isVaildItemRegistQuickMenu(itemWrapper:getStaticStatus()) then
      self._inventoryData[#self._inventoryData + 1] = {
        _whereType = CppEnums.ItemWhereType.eCashInventory,
        _slotNo = slotNo,
        _name = itemWrapper:getStaticStatus():getName(),
        _icon = "Icon/" .. itemWrapper:getStaticStatus():getIconPath()
      }
    end
  end
end
function PaGlobal_ConsoleQuickMenu:getSkillData()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local classType = selfPlayer:getClassType()
  if classType < 0 then
    return
  end
  self._skillData = {}
  local cellTable = getCombatSkillTree(classType)
  if nil == cellTable then
    return
  end
  self:getSkillCellTableData(cellTable)
  cellTable = getAwakeningWeaponSkillTree(classType)
  if nil == cellTable then
    return
  end
  self:getSkillCellTableData(cellTable)
end
function PaGlobal_ConsoleQuickMenu:getSkillCellTableData(cellTable)
  local cols = cellTable:capacityX()
  local rows = cellTable:capacityY()
  for row = 0, rows - 1 do
    for col = 0, cols - 1 do
      local cell = cellTable:atPointer(col, row)
      local skillNo = cell._skillNo
      if true == cell:isSkillType() then
        local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
        local skillTypeStatic = skillTypeStaticWrapper:get()
        if nil ~= skillTypeStaticWrapper and true == skillTypeStaticWrapper:isValidLocalizing() and nil ~= skillTypeStatic and true == skillTypeStatic._isSettableQuickSlot then
          local skillLevelInfo = getSkillLevelInfo(skillNo)
          local skillLearndLevel = getLearnedSkillLevel(skillTypeStaticWrapper)
          if nil ~= skillLevelInfo and true == skillLevelInfo._usable then
            self._skillData[#self._skillData + 1] = {
              _skillKey = skillLevelInfo._skillKey:get(),
              _skillNo = skillNo,
              _name = skillTypeStaticWrapper:getName(),
              _icon = "Icon/" .. skillTypeStaticWrapper:getIconPath()
            }
          end
        end
      end
    end
  end
end
function FGlobal_ConsoleQuickMenu_Update(position)
  if position >= __eQuickMenuPosition_Count then
    for ii = 1, __eQuickMenuPosition_Count do
      PaGlobal_ConsoleQuickMenu._ui._quickMenuPosition[ii]:SetMonoTone(false)
      PaGlobal_ConsoleQuickMenu._ui._quickMenuPosition[ii]:SetCheck(false)
    end
  else
    for ii = 1, __eQuickMenuPosition_Count do
      PaGlobal_ConsoleQuickMenu._ui._quickMenuPosition[ii]:SetMonoTone(true)
      PaGlobal_ConsoleQuickMenu._ui._quickMenuPosition[ii]:SetCheck(false)
    end
    PaGlobal_ConsoleQuickMenu._ui._quickMenuPosition[position + 1]:SetMonoTone(false)
    PaGlobal_ConsoleQuickMenu._ui._quickMenuPosition[position + 1]:SetCheck(true)
  end
  PaGlobal_ConsoleQuickMenu:setButtonPos(position + 1)
end
function PaGlobal_ConsoleQuickMenu:setButtonPos(selectedIndex)
  self._center.x = self._ui._center:GetPosX()
  self._center.y = self._ui._center:GetPosY()
  local angle = 2 * math.pi / 8 * 5
  local angleOffset = 2 * math.pi / 8
  for index = 1, 8 do
    angle = angle + angleOffset
    if selectedIndex == index then
      local x = 260 * math.cos(angle)
      local y = 260 * math.sin(angle)
      self._ui._quickMenuPosition[index]:SetPosX(self._center.x + x - 50)
      self._ui._quickMenuPosition[index]:SetPosY(self._center.y + y - 50)
      self._selectedIndex = index
    else
      local x = 231 * math.cos(angle)
      local y = 231 * math.sin(angle)
      self._ui._quickMenuPosition[index]:SetPosX(self._center.x + x - 50)
      self._ui._quickMenuPosition[index]:SetPosY(self._center.y + y - 50)
    end
  end
end
function PaGlobal_ConsoleQuickMenu:moveButtonAni()
  if self._selectedIndex <= 0 then
    return
  end
  local control = self._ui._quickMenuPosition[self._selectedIndex]
  local buttonMoveAni = control:addMoveAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  buttonMoveAni:SetStartPosition(control:GetPosX(), control:GetPosY())
  buttonMoveAni:SetEndPosition(self._center.x - 50, self._center.y - 50)
  buttonMoveAni.IsChangeChild = true
  control:CalcUIAniPos(buttonMoveAni)
  buttonMoveAni:SetDisableWhileAni(true)
  self._selectedIndex = 0
end
function QuickMenu_ShowAni()
  UIAni.AlphaAnimation(1, Panel_QuickMenu, 0, 0.15)
  local aniInfo1 = Panel_QuickMenu:addScaleAnimation(0, 0.15, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1)
  aniInfo1.AxisX = Panel_QuickMenu:GetSizeX() / 2
  aniInfo1.AxisY = Panel_QuickMenu:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
end
function QuickMenu_HideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Panel_QuickMenu, 0.1, 0.2)
  aniInfo:SetHideAtEnd(true)
end
function FGlobal_ConsoleQuickMenu_IsShow()
  return Panel_QuickMenu:GetShow()
end
function FGlobal_ConsoleQuickMenu_Open(currentGroup)
  if true == Panel_QuickMenuCustom:GetShow() then
    return
  end
  Panel_QuickMenu:SetShow(true, true)
  PaGlobal_ConsoleQuickMenu:SetUICurrentGroup(currentGroup)
end
function FromClient_ConsoleQuickMenu_Quit()
  PaGlobal_ConsoleQuickMenu:moveButtonAni()
  Panel_QuickMenu:SetShow(false, true)
end
function FromClient_ConsoleQuickMenu_OpenCustomPage(currentGroup)
  FromClient_ConsoleQuickMenu_Quit()
  Panel_QuickMenuCustom:SetShow(true)
  PaGlobal_ConsoleQuickMenu:CustomSettingDataUpdate()
  PaGlobal_ConsoleQuickMenu:CustomSettingUpdateCurrentPage()
  PaGlobal_ConsoleQuickMenu:SetUICusttomSettingCurrentGroup(currentGroup)
  PaGlobal_ConsoleQuickMenu._curPosition = 1
  PaGlobal_ConsoleQuickMenu._curGroup = currentGroup
end
function PaGlobal_ConsoleQuickMenu:SetUICurrentGroup(group)
  local groupInfo = self:GetCurrentGroupInfo(group)
  for position, info in ipairs(groupInfo) do
    if nil == self._ui._quickMenuPositionIcon[position] then
      _PA_LOG("\237\155\132\236\167\132", " ??? " .. position)
      return
    end
    local control = self._ui._quickMenuPositionIcon[position]
    control:ChangeTextureInfoName(info._icon)
    if nil ~= info._uv then
      control:getBaseTexture():setUV(setTextureUV_Func(control, info._uv._x1, info._uv._y1, info._uv._x2, info._uv._y2))
    else
      control:getBaseTexture():setUV(0, 0, 1, 1)
    end
    control:setRenderTexture(control:getBaseTexture())
  end
end
function PaGlobal_ConsoleQuickMenu:SetUICusttomSettingCurrentGroup(group)
  local groupInfo = self:GetCurrentGroupInfo(group)
  for position, info in ipairs(groupInfo) do
    if nil == self._ui._buttonPositionIcon[position] then
      _PA_LOG("\237\155\132\236\167\132", " ??? " .. position)
      return
    end
    local control = self._ui._buttonPositionIcon[position]
    control:ChangeTextureInfoName(info._icon)
    if nil ~= info._uv then
      control:getBaseTexture():setUV(setTextureUV_Func(control, info._uv._x1, info._uv._y1, info._uv._x2, info._uv._y2))
    else
      control:getBaseTexture():setUV(0, 0, 1, 1)
    end
    control:setRenderTexture(control:getBaseTexture())
  end
end
function PaGlobal_ConsoleQuickMenu:GetCurrentGroupInfo(group)
  local table = {}
  for position = 0, __eQuickMenuPosition_Count - 1 do
    local quickMenu = ToClient_getAtQuickMenu(group, position)
    if nil == quickMenu then
      return
    end
    local name = ""
    local icon = ""
    local uv
    if __eQuickMenuDataType_Skill == quickMenu._type then
      local skillTypeStaticWrapper = getSkillTypeStaticStatus(quickMenu._skillKey:getSkillNo())
      if nil ~= skillTypeStaticWrapper then
        name = skillTypeStaticWrapper:getName()
        icon = "Icon/" .. skillTypeStaticWrapper:getIconPath()
      end
    elseif __eQuickMenuDataType_Item == quickMenu._type then
      local itemStaticStatusWrapper = getItemEnchantStaticStatus(quickMenu._itemKey)
      if nil ~= itemStaticStatusWrapper then
        name = itemStaticStatusWrapper:getName()
        icon = "Icon/" .. itemStaticStatusWrapper:getIconPath()
      end
    elseif __eQuickMenuDataType_Function == quickMenu._type then
      name = self._functionTypeList._name[quickMenu._functionType]
      icon = self._functionTypeList._icon[quickMenu._functionType]._path
      local iconUV = self._functionTypeList._icon[quickMenu._functionType]
      uv = {
        _x1 = iconUV._x1,
        _y1 = iconUV._y1,
        _x2 = iconUV._x2,
        _y2 = iconUV._y2
      }
    end
    table[#table + 1] = {
      _name = name,
      _icon = icon,
      _uv = uv
    }
  end
  return table
end
function FromClient_ConsoleQuickMenu_luaLoadComplete()
  PaGlobal_ConsoleQuickMenu:initializeUI()
  PaGlobal_ConsoleQuickMenu:setDefaultSetting()
end
function PaGlobal_ConsoleQuickMenu:setPosition(index)
  self._curPosition = index
end
function FromClient_ConsoleQuickMenu_Open(group)
  FGlobal_ConsoleQuickMenu_Open(group)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_ConsoleQuickMenu_luaLoadComplete")
registerEvent("FromClient_ConsoleQuickMenu_Quit", "FromClient_ConsoleQuickMenu_Quit")
registerEvent("FromClient_ConsoleQuickMenu_OpenCustomPage", "FromClient_ConsoleQuickMenu_OpenCustomPage")
registerEvent("FromClient_ConsoleQuickMenu_Open", "FromClient_ConsoleQuickMenu_Open")
Panel_QuickMenu:RegisterShowEventFunc(true, "QuickMenu_ShowAni()")
Panel_QuickMenu:RegisterShowEventFunc(false, "QuickMenu_HideAni()")
function ConsoleQuickMenu_UpdatePage()
  if isPadUp(9) then
    PaGlobal_ConsoleQuickMenu:CustomSettingNextPage()
  end
  if isPadUp(8) then
    PaGlobal_ConsoleQuickMenu:CustomSettingPrevPage()
  end
  if isPadUp(22) then
    Panel_QuickMenuCustom:SetShow(false)
  end
end
Panel_QuickMenuCustom:RegisterUpdateFunc("ConsoleQuickMenu_UpdatePage")
function PaGlobal_ConsoleQuickMenu:setDefaultSetting()
  ToClient_registQuickMenuFunctionType(3, 0, __eQuickMenuFunctionType_Inventory)
  ToClient_registQuickMenuFunctionType(3, 1, __eQuickMenuFunctionType_BlackSpirit)
  ToClient_registQuickMenuFunctionType(3, 2, __eQuickMenuFunctionType_WorldMap)
  ToClient_registQuickMenuFunctionType(3, 3, __eQuickMenuFunctionType_Skill)
  ToClient_registQuickMenuFunctionType(3, 4, __eQuickMenuFunctionType_Mail)
  ToClient_registQuickMenuFunctionType(3, 5, __eQuickMenuFunctionType_CharacterChallange)
  ToClient_registQuickMenuFunctionType(3, 6, __eQuickMenuFunctionType_ItemMarket)
  ToClient_registQuickMenuFunctionType(3, 7, __eQuickMenuFunctionType_Quest)
end
