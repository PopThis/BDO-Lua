Panel_WIndow_NpcGift = {
  _inventoryType = 0,
  _slotNo = 0,
  _count = 0,
  _itemWrapper = nil
}
function Panel_WIndow_NpcGift:open()
  InventoryWindow_Show()
  Inventory_SetFunctor(FGlobal_Enchant_FileterForNpcGift, FGlobal_NpcGift_RClickForTargetItem, FGlobal_NpcGift_Close, nil)
end
function Panel_WIndow_NpcGift:close()
  FGlobal_NpcGift_Close()
end
function FGlobal_NpcGift_RClickForTargetItem(slotNo, itemWrapper, count, inventoryType)
  if nil == itemWrapper then
    return
  end
  local self = Panel_WIndow_NpcGift
  self._inventoryType = inventoryType
  self._slotNo = slotNo
  self._itemWrapper = itemWrapper
  if 1 == count then
    FGlobal_NpcGift_PopupMessage(count)
  else
    Panel_NumberPad_Show(true, count, 0, FGlobal_NpcGift_PopupMessage)
  end
end
function FGlobal_NpcGift_PopupMessage(count)
  local self = Panel_WIndow_NpcGift
  local itemSSW = self._itemWrapper:getStaticStatus()
  local itemName = itemSSW:getName()
  self._count = count
  local messageBoxtitle = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageBoxMemo = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NPC_GIFT_CONFIRM", "itemName", tostring(itemName), "count", tostring(count))
  local messageBoxData = {
    title = messageBoxtitle,
    content = messageBoxMemo,
    functionYes = FGlobal_NpcGift_Confirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, "middle")
end
function FGlobal_NpcGift_Confirm()
  local self = Panel_WIndow_NpcGift
  ToClient_giveNpcGift(self._inventoryType, self._slotNo, self._count)
end
function FGlobal_NpcGift_Close()
  InventoryWindow_Close()
  Inventory_SetFunctor(nil, nil, nil, nil)
end
function FGlobal_Enchant_FileterForNpcGift(slotNo, notUse_itemWrappers, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  return false == itemWrapper:checkToGiveNpc()
end
