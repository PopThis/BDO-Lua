Panel_Combo_Guide:SetShow(false)
local isAbleConsolePadGroup = ToClient_IsContentsGroupOpen("282")
PaGlobal_ConsoleKeyFirstCombo = {
  _firstButton = {
    [0] = "LT",
    [1] = "RT",
    [2] = "LB",
    [3] = "RB"
  },
  _secondButton = {
    [0] = "FRONT",
    [1] = "RIGHT",
    [2] = "BACK",
    [3] = "LEFT"
  },
  _thirdButton = {
    [0] = "X",
    [1] = "Y",
    [2] = "A",
    [3] = "B"
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _skillSlotConfig = {
    createIcon = true,
    createEffect = true,
    createFG = true,
    createFGDisabled = true,
    createFG_Passive = true,
    createMinus = true,
    createLevel = true,
    createLearnButton = true,
    createTestimonial = true,
    createLockIcon = true,
    createMouseOver = true,
    template = {
      effect = UI.getChildControl(Panel_Window_Skill, "Static_Icon_Skill_Effect"),
      iconFG = UI.getChildControl(Panel_Window_Skill, "Static_Icon_FG"),
      iconFGDisabled = UI.getChildControl(Panel_Window_Skill, "Static_Icon_FG_DISABLE"),
      iconFG_Passive = UI.getChildControl(Panel_Window_Skill, "Static_Icon_BG"),
      iconMinus = UI.getChildControl(Panel_Window_Skill, "Static_Icon_Skill_EffectMinus"),
      learnButton = UI.getChildControl(Panel_Window_Skill, "Button_Skill_Point"),
      mouseOverButton = UI.getChildControl(Panel_Window_Skill, "Button_Skill_OverMouse"),
      testimonial = UI.getChildControl(Panel_Window_Skill, "Static_Skill_Effect"),
      lockIcon = UI.getChildControl(Panel_Window_Skill, "Static_SkillLockIcon")
    }
  },
  _comboData = {
    [0] = {},
    [1] = {},
    [2] = {}
  },
  _consolePage = 0,
  _maxNextSkillList = 50,
  _skillMaxKeyCount = 3,
  _buttonMaxCount = 4,
  _buttonIndex = 0,
  _showControlIndex = 0,
  _currentTime = 0,
  _isGuide = false,
  _differentSkillCount = 0,
  _sameSKillData = {},
  _sameCount = 0,
  _weaponType = 0,
  _buttonKey = {},
  _showSkillData = {},
  _slots = Array.new()
}
function PaGlobal_ConsoleKeyFirstCombo:initialize()
  for index = 0, self._maxNextSkillList - 1 do
    local slot = {}
    slot._skillIcon = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_SkillIcon", Panel_Combo_Guide, "skillComboCommand_SkillIcon_" .. index)
    slot._line = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_Line", slot._skillIcon, "skillComboCommand_Line_" .. index)
    slot._skillName = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "StaticText_NormalSkillName", slot._skillIcon, "skillComboCommand_normalSkillName_" .. index)
    slot._RB = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_RB", slot._skillIcon, "skillComboCommand_RB_" .. index)
    slot._LB = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_LB", slot._skillIcon, "skillComboCommand_LB_" .. index)
    slot._RT = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_RT", slot._skillIcon, "skillComboCommand_RT_" .. index)
    slot._LT = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_LT", slot._skillIcon, "skillComboCommand_LT_" .. index)
    slot._AnalogUp = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_AnalogL_Up", slot._skillIcon, "skillComboCommand_CrossUp_" .. index)
    slot._AnalogRight = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_AnalogL_Right", slot._skillIcon, "skillComboCommand_CrossRight_" .. index)
    slot._AnalogDown = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_AnalogL_Down", slot._skillIcon, "skillComboCommand_CrossDown_" .. index)
    slot._AnalogLeft = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_AnalogL_Left", slot._skillIcon, "skillComboCommand_CrossLeft_" .. index)
    slot._x = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_X", slot._skillIcon, "skillComboCommand_X_" .. index)
    slot._y = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_Y", slot._skillIcon, "skillComboCommand_Y_" .. index)
    slot._a = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_A", slot._skillIcon, "skillComboCommand_A_" .. index)
    slot._b = UI.createAndCopyBasePropertyControl(Panel_Combo_Guide, "Static_B", slot._skillIcon, "skillComboCommand_B" .. index)
    for _, v in pairs(slot) do
      v:SetShow(false)
    end
    self._slots[index] = slot
  end
end
function PaGlobal_ConsoleKeyFirstCombo:showToggle()
  if Panel_Combo_Guide:GetShow() then
    self:close()
  else
    self:open()
    self:update(1)
  end
end
function PaGlobal_ConsoleKeyFirstCombo:open()
  Panel_Combo_Guide:SetShow(true)
  self._sameCount = 0
  self._sameSKillData = {}
end
function PaGlobal_ConsoleKeyFirstCombo:close()
  for index = 0, self._maxNextSkillList - 1 do
    if nil ~= self._showSkillData[index] then
      self._showSkillData[index]:SetShow(false)
    end
    if nil ~= self._slots[index]._skillIcon then
      self._slots[index]._skillIcon:SetShow(false)
    end
  end
  Panel_Combo_Guide:SetShow(false)
end
function PaGlobal_ConsoleKeyFirstCombo:update(firstWeaponType)
  local normalSkillCount = selfPlayerFirstSkillConsoleKeySize(1)
  local awakenSkillCount = selfPlayerFirstSkillConsoleKeySize(2)
  self._normalSameCount = 0
  self._awakenSameCount = 0
  self._sameSKillData = {}
  if 1 == firstWeaponType then
    for index = 0, normalSkillCount - 1 do
      local buttonKey = selfPlayerFirstSkillConsoleKeyList(1, index)
      local skillNo = selfPlayerFirstSkillConsoleSkillNo(1, index)
      if 0 ~= skillNo then
        local skillWrapper = getSkillTypeStaticStatus(skillNo)
        if nil ~= skillWrapper then
          PaGlobal_ConsoleKeyFirstCombo:setSkill(skillWrapper, index, 1, skillNo, firstWeaponType)
        end
      end
    end
  elseif 2 == firstWeaponType then
    for index = 0, awakenSkillCount - 1 do
      local buttonKey = selfPlayerFirstSkillConsoleKeyList(2, index)
      local skillNo = selfPlayerFirstSkillConsoleSkillNo(2, index)
      if 0 ~= skillNo then
        local skillWrapper = getSkillTypeStaticStatus(skillNo)
        if nil ~= skillWrapper then
          PaGlobal_ConsoleKeyFirstCombo:setSkill(skillWrapper, index, 2, skillNo, firstWeaponType)
        end
      end
    end
  end
end
function PaGlobal_ConsoleKeyFirstCombo:findSkill(firstWeaponType, isNextSkill)
  local normalSkillCount = selfPlayerFirstSkillConsoleKeySize(1)
  local awakenSkillCount = selfPlayerFirstSkillConsoleKeySize(2)
  local skillCount = normalSkillCount + awakenSkillCount
  local buttonKey
  local skillNo = -1
  local weaponType = 0
  local skillIndex = -1
  for index = 0, skillCount - 1 do
    if index < normalSkillCount then
      skillIndex = index
      buttonKey = selfPlayerFirstSkillConsoleKeyList(1, skillIndex)
      skillNo = selfPlayerFirstSkillConsoleSkillNo(1, skillIndex)
      weaponType = 1
    else
      skillIndex = index - normalSkillCount
      buttonKey = selfPlayerFirstSkillConsoleKeyList(2, skillIndex)
      skillNo = selfPlayerFirstSkillConsoleSkillNo(2, skillIndex)
      weaponType = 2
    end
    if index == awakenSkillCount - 1 then
      isLast = true
    end
    if 0 ~= skillNo then
      local skillWrapper = getSkillTypeStaticStatus(skillNo)
      if nil ~= skillWrapper then
        PaGlobal_ConsoleKeyFirstCombo:setSkill(skillWrapper, skillIndex, weaponType, skillNo, firstWeaponType, isNextSkill)
      end
    end
  end
end
function PaGlobal_ConsoleKeyFirstCombo:setSkill(skillWrapper, index, weaponType, skillNo, firstWeaponType, isNextSkill)
  local isSame = false
  local firstKey = selfPlayerFirstSkillConsoleKeyList(firstWeaponType, index)
  PaGlobal_ConsoleKeyCombo:findFirstCombo(firstKey, skillWrapper, skillNo, index, weaponType)
  if isNextSkill then
    return
  end
  if 20 <= self._sameCount then
    return
  end
  for count = 0, self._sameCount - 1 do
    if self._sameSKillData[count] == skillNo then
      isSame = true
    end
  end
  if false == isSame then
    local buttonKey = selfPlayerFirstSkillConsoleKeyList(weaponType, index)
    self._sameSKillData[self._sameCount] = skillNo
    local iconPath = skillWrapper:getIconPath()
    self._slots[self._sameCount]._skillIcon:ChangeTextureInfoName("Icon/" .. iconPath)
    self._slots[self._sameCount]._skillIcon:SetShow(true)
    self._slots[self._sameCount]._skillIcon:SetPosX(20 + math.floor(self._sameCount / 5) * 260)
    self._slots[self._sameCount]._skillIcon:SetPosY(self._sameCount % 5 * (self._slots[self._sameCount]._skillIcon:GetSizeY() + 36) + 200)
    self._slots[self._sameCount]._skillName:SetShow(true)
    self._slots[self._sameCount]._skillName:SetText(skillWrapper:getName())
    self._buttonIndex = 0
    self._buttonKey[self._sameCount] = buttonKey
    for buttonIndex = 0, self._skillMaxKeyCount - 1 do
      local isFind = PaGlobal_ConsoleKeyFirstCombo:findCommand(self._sameCount, buttonKey, buttonIndex, weaponType)
      if isFind then
        self._buttonIndex = self._buttonIndex + 1
      end
    end
    self._sameCount = self._sameCount + 1
  end
end
function PaGlobal_ConsoleKeyFirstCombo:findCommand(index, buttonKey, buttonIndex, weaponType)
  local button = {}
  if 0 == buttonIndex then
    button = self._firstButton
  elseif 1 == buttonIndex then
    button = self._secondButton
  elseif 2 == buttonIndex then
    button = self._thirdButton
  end
  local isFind = false
  for buttonCount = 0, self._buttonMaxCount - 1 do
    local startIndex, endIndex = string.find(self._buttonKey[index], button[buttonCount])
    if nil ~= startIndex and nil ~= endIndex then
      local command = string.sub(self._buttonKey[index], startIndex, endIndex)
      self._buttonKey[index] = string.gsub(self._buttonKey[index], command, "", 1)
      PaGlobal_ConsoleKeyFirstCombo:showCommand(index, command, weaponType)
      isFind = true
    end
  end
  return isFind
end
function PaGlobal_ConsoleKeyFirstCombo:showCommand(index, command, weaponType)
  if "LT" == command then
    PaGlobal_ConsoleKeyFirstCombo:setPosCommand(index, self._slots[index]._LT, 0, weaponType)
  elseif "RT" == command then
    PaGlobal_ConsoleKeyFirstCombo:setPosCommand(index, self._slots[index]._RT, 0, weaponType)
  elseif "LB" == command then
    PaGlobal_ConsoleKeyFirstCombo:setPosCommand(index, self._slots[index]._LB, 0, weaponType)
  elseif "RB" == command then
    PaGlobal_ConsoleKeyFirstCombo:setPosCommand(index, self._slots[index]._RB, 0, weaponType)
  elseif "FRONT" == command then
    PaGlobal_ConsoleKeyFirstCombo:setPosCommand(index, self._slots[index]._AnalogUp, 0, weaponType)
  elseif "RIGHT" == command then
    PaGlobal_ConsoleKeyFirstCombo:setPosCommand(index, self._slots[index]._AnalogRight, 0, weaponType)
  elseif "BACK" == command then
    PaGlobal_ConsoleKeyFirstCombo:setPosCommand(index, self._slots[index]._AnalogDown, 0, weaponType)
  elseif "LEFT" == command then
    PaGlobal_ConsoleKeyFirstCombo:setPosCommand(index, self._slots[index]._AnalogLeft, 0, weaponType)
  elseif "X" == command then
    PaGlobal_ConsoleKeyFirstCombo:setPosCommand(index, self._slots[index]._x, 1, weaponType)
  elseif "Y" == command then
    PaGlobal_ConsoleKeyFirstCombo:setPosCommand(index, self._slots[index]._y, 2, weaponType)
  elseif "A" == command then
    PaGlobal_ConsoleKeyFirstCombo:setPosCommand(index, self._slots[index]._a, 3, weaponType)
  elseif "B" == command then
    PaGlobal_ConsoleKeyFirstCombo:setPosCommand(index, self._slots[index]._b, 4, weaponType)
  end
end
function PaGlobal_ConsoleKeyFirstCombo:setPosCommand(skillIndex, control, posIndex, weaponType)
  control:SetShow(true)
  control:SetPosX(10 + 50 * (self._buttonIndex + 1))
  self._showSkillData[self._showControlIndex] = control
  self._showSkillIndex = skillIndex
  self._showControlIndex = self._showControlIndex + 1
end
function PaGlobal_ConsoleKeyFirstCombo:firstSkillListUpdate(weaponType)
  PaGlobal_ConsoleKeyFirstCombo:update(weaponType)
end
function FromClient_consoleFirstKeyList()
  if false == isAbleConsolePadGroup then
    return
  end
end
PaGlobal_ConsoleKeyFirstCombo:initialize()
