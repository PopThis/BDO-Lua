local executeFunction = {}
function executeFunction.__eQuickMenuFunctionType_Inventory()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Inventory)
end
function executeFunction.__eQuickMenuFunctionType_BlackSpirit()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_BlackSpirit)
end
function executeFunction.__eQuickMenuFunctionType_WorldMap()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_WorldMap)
end
function executeFunction.__eQuickMenuFunctionType_Skill()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Skill)
end
function executeFunction.__eQuickMenuFunctionType_Mail()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Mail)
end
function executeFunction.__eQuickMenuFunctionType_CharacterChallange()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Present)
end
function executeFunction.__eQuickMenuFunctionType_ItemMarket()
  FGlobal_ItemMarket_Open_ForWorldMap(1, true)
  audioPostEvent_SystemUi(1, 30)
end
function executeFunction.__eQuickMenuFunctionType_Quest()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_QuestHistory)
end
function executeFunction.__eQuickMenuFunctionType_ServantCall()
end
function executeFunction.__eQuickMenuFunctionType_ServantNavi()
end
function executeFunction.__eQuickMenuFunctionType_HorseRaceInformation()
end
function executeFunction.__eQuickMenuFunctionType_HorseRaceEnterOrCancel()
end
function executeFunction.__eQuickMenuFunctionType_HouseList()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_House)
end
function executeFunction.__eQuickMenuFunctionType_WorkerList()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Worker)
end
function executeFunction.__eQuickMenuFunctionType_InstallationList()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Mail)
end
function executeFunction.__eQuickMenuFunctionType_PetList()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Pet)
end
function executeFunction.__eQuickMenuFunctionType_MaidList()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Maid)
end
function executeFunction.__eQuickMenuFunctionType_TagSetting()
end
function executeFunction.__eQuickMenuFunctionType_Tag()
end
function executeFunction.__eQuickMenuFunctionType_NpcFind()
  NpcNavi_ShowToggle()
end
function executeFunction.__eQuickMenuFunctionType_MovieGuide()
end
function executeFunction.__eQuickMenuFunctionType_Mercenary()
  FGlobal_MercenaryOpen()
end
function executeFunction.__eQuickMenuFunctionType_VillageSiegeArea()
  FGlobal_GuildWarInfo_Show()
end
function executeFunction.__eQuickMenuFunctionType_Pvp()
end
PaGlobal_ConsoleQuickMenu._functionTypeList = {}
PaGlobal_ConsoleQuickMenu._functionTypeList._executeFunction = {
  [__eQuickMenuFunctionType_Inventory] = executeFunction.__eQuickMenuFunctionType_Inventory,
  [__eQuickMenuFunctionType_BlackSpirit] = executeFunction.__eQuickMenuFunctionType_BlackSpirit,
  [__eQuickMenuFunctionType_WorldMap] = executeFunction.__eQuickMenuFunctionType_WorldMap,
  [__eQuickMenuFunctionType_Skill] = executeFunction.__eQuickMenuFunctionType_Skill,
  [__eQuickMenuFunctionType_Mail] = executeFunction.__eQuickMenuFunctionType_Mail,
  [__eQuickMenuFunctionType_CharacterChallange] = executeFunction.__eQuickMenuFunctionType_CharacterChallange,
  [__eQuickMenuFunctionType_ItemMarket] = executeFunction.__eQuickMenuFunctionType_ItemMarket,
  [__eQuickMenuFunctionType_Quest] = executeFunction.__eQuickMenuFunctionType_Quest,
  [__eQuickMenuFunctionType_ServantCall] = executeFunction.__eQuickMenuFunctionType_ServantCall,
  [__eQuickMenuFunctionType_ServantNavi] = executeFunction.__eQuickMenuFunctionType_ServantNavi,
  [__eQuickMenuFunctionType_CampActivate] = executeFunction.__eQuickMenuFunctionType_CampActivate,
  [__eQuickMenuFunctionType_CampNavi] = executeFunction.__eQuickMenuFunctionType_CampNavi,
  [__eQuickMenuFunctionType_HorseRaceInformation] = executeFunction.__eQuickMenuFunctionType_HorseRaceInformation,
  [__eQuickMenuFunctionType_HorseRaceEnterOrCancel] = executeFunction.__eQuickMenuFunctionType_HorseRaceEnterOrCancel,
  [__eQuickMenuFunctionType_HouseList] = executeFunction.__eQuickMenuFunctionType_HouseList,
  [__eQuickMenuFunctionType_WorkerList] = executeFunction.__eQuickMenuFunctionType_WorkerList,
  [__eQuickMenuFunctionType_InstallationList] = executeFunction.__eQuickMenuFunctionType_InstallationList,
  [__eQuickMenuFunctionType_PetList] = executeFunction.__eQuickMenuFunctionType_PetList,
  [__eQuickMenuFunctionType_MaidList] = executeFunction.__eQuickMenuFunctionType_MaidList,
  [__eQuickMenuFunctionType_TagSetting] = executeFunction.__eQuickMenuFunctionType_TagSetting,
  [__eQuickMenuFunctionType_Tag] = executeFunction.__eQuickMenuFunctionType_Tag,
  [__eQuickMenuFunctionType_NpcFind] = executeFunction.__eQuickMenuFunctionType_NpcFind,
  [__eQuickMenuFunctionType_MovieGuide] = executeFunction.__eQuickMenuFunctionType_MovieGuide,
  [__eQuickMenuFunctionType_Mercenary] = executeFunction.__eQuickMenuFunctionType_Mercenary,
  [__eQuickMenuFunctionType_VillageSiegeArea] = executeFunction.__eQuickMenuFunctionType_VillageSiegeArea,
  [__eQuickMenuFunctionType_Pvp] = executeFunction.__eQuickMenuFunctionType_Pvp
}
PaGlobal_ConsoleQuickMenu._functionTypeList._icon = {
  [__eQuickMenuFunctionType_Inventory] = {
    _path = "Renewal/Button/Console_Btn_ESCMenu_01.dds",
    _x1 = 449,
    _y1 = 3,
    _x2 = 509,
    _y2 = 63
  },
  [__eQuickMenuFunctionType_BlackSpirit] = {
    _path = "Renewal/Button/Console_Btn_ESCMenu.dds",
    _x1 = 2,
    _y1 = 64,
    _x2 = 62,
    _y2 = 124
  },
  [__eQuickMenuFunctionType_WorldMap] = {
    _path = "Renewal/Button/Console_Btn_ESCMenu.dds",
    _x1 = 312,
    _y1 = 2,
    _x2 = 372,
    _y2 = 62
  },
  [__eQuickMenuFunctionType_Skill] = {
    _path = "Renewal/Button/Console_Btn_ESCMenu.dds",
    _x1 = 188,
    _y1 = 2,
    _x2 = 248,
    _y2 = 62
  },
  [__eQuickMenuFunctionType_Mail] = {
    _path = "Renewal/Button/Console_Btn_ESCMenu.dds",
    _x1 = 312,
    _y1 = 64,
    _x2 = 372,
    _y2 = 124
  },
  [__eQuickMenuFunctionType_CharacterChallange] = {
    _path = "Renewal/Button/Console_Btn_ESCMenu.dds",
    _x1 = 64,
    _y1 = 2,
    _x2 = 124,
    _y2 = 62
  },
  [__eQuickMenuFunctionType_ItemMarket] = {
    _path = "Renewal/Button/Console_Btn_ESCMenu.dds",
    _x1 = 188,
    _y1 = 374,
    _x2 = 248,
    _y2 = 434
  },
  [__eQuickMenuFunctionType_Quest] = {
    _path = "Renewal/Button/Console_Btn_ESCMenu.dds",
    _x1 = 64,
    _y1 = 64,
    _x2 = 124,
    _y2 = 124
  },
  [__eQuickMenuFunctionType_ServantCall] = {_path = ""},
  [__eQuickMenuFunctionType_ServantNavi] = {_path = ""},
  [__eQuickMenuFunctionType_CampActivate] = {_path = ""},
  [__eQuickMenuFunctionType_CampNavi] = {_path = ""},
  [__eQuickMenuFunctionType_HorseRaceInformation] = {_path = ""},
  [__eQuickMenuFunctionType_HorseRaceEnterOrCancel] = {_path = ""},
  [__eQuickMenuFunctionType_HouseList] = {_path = ""},
  [__eQuickMenuFunctionType_WorkerList] = {_path = ""},
  [__eQuickMenuFunctionType_InstallationList] = {_path = ""},
  [__eQuickMenuFunctionType_PetList] = {_path = ""},
  [__eQuickMenuFunctionType_MaidList] = {_path = ""},
  [__eQuickMenuFunctionType_TagSetting] = {_path = ""},
  [__eQuickMenuFunctionType_Tag] = {_path = ""},
  [__eQuickMenuFunctionType_NpcFind] = {_path = ""},
  [__eQuickMenuFunctionType_MovieGuide] = {_path = ""},
  [__eQuickMenuFunctionType_Mercenary] = {_path = ""},
  [__eQuickMenuFunctionType_VillageSiegeArea] = {_path = ""},
  [__eQuickMenuFunctionType_Pvp] = {_path = ""}
}
PaGlobal_ConsoleQuickMenu._functionTypeList._name = {
  [__eQuickMenuFunctionType_Inventory] = "\236\157\184\235\178\164\237\134\160\235\166\172",
  [__eQuickMenuFunctionType_BlackSpirit] = "\237\157\145\236\160\149\235\160\185",
  [__eQuickMenuFunctionType_WorldMap] = "\236\155\148\235\147\156\235\167\181",
  [__eQuickMenuFunctionType_Skill] = "\236\138\164\237\130\172\236\176\189",
  [__eQuickMenuFunctionType_Mail] = "\237\142\184\236\167\128\237\149\168",
  [__eQuickMenuFunctionType_CharacterChallange] = "\235\143\132\236\160\132 \234\179\188\236\160\156 ",
  [__eQuickMenuFunctionType_ItemMarket] = "\234\177\176\235\158\152\236\134\140",
  [__eQuickMenuFunctionType_Quest] = "\236\157\152\235\162\176",
  [__eQuickMenuFunctionType_ServantCall] = "\237\131\145\236\138\185\235\172\188 \237\152\184\236\182\156",
  [__eQuickMenuFunctionType_ServantNavi] = "\237\131\145\236\138\185\235\172\188 \235\132\164\235\185\132",
  [__eQuickMenuFunctionType_CampActivate] = "\236\149\188\236\152\129\236\167\128 \237\153\156\236\132\177\237\153\148",
  [__eQuickMenuFunctionType_CampNavi] = "\236\149\188\236\152\129\236\167\128 \235\132\164\235\185\132",
  [__eQuickMenuFunctionType_HorseRaceInformation] = "\235\167\144\234\178\189\236\163\188 \236\160\149\235\179\180",
  [__eQuickMenuFunctionType_HorseRaceEnterOrCancel] = "\235\167\144\234\178\189\236\163\188 \236\176\184\234\176\128/\236\183\168\236\134\140",
  [__eQuickMenuFunctionType_HouseList] = "\236\163\188\234\177\176\236\167\128 \235\170\169\235\161\157",
  [__eQuickMenuFunctionType_WorkerList] = "\236\157\188\234\190\188 \235\170\169\235\161\157",
  [__eQuickMenuFunctionType_InstallationList] = "\237\133\131\235\176\173 \235\170\169\235\161\157",
  [__eQuickMenuFunctionType_PetList] = "\235\143\153\235\172\188 \235\170\169\235\161\157",
  [__eQuickMenuFunctionType_MaidList] = "\235\169\148\236\157\180\235\147\156 \235\170\169\235\161\157",
  [__eQuickMenuFunctionType_TagSetting] = "\237\133\140\234\183\184 \236\133\139\237\140\133",
  [__eQuickMenuFunctionType_Tag] = "\237\131\156\234\183\184",
  [__eQuickMenuFunctionType_NpcFind] = "NPC \236\176\190\234\184\176",
  [__eQuickMenuFunctionType_MovieGuide] = "\235\172\180\235\185\132 \234\176\128\236\157\180\235\147\156",
  [__eQuickMenuFunctionType_Mercenary] = "\235\175\188\235\179\145\235\140\128",
  [__eQuickMenuFunctionType_VillageSiegeArea] = "\234\177\176\236\160\144",
  [__eQuickMenuFunctionType_Pvp] = "Pvp"
}
function FromClient_ConsoleQuickMenu_ExecuteFunctionType(datatype, functionType)
  if __eQuickMenuDataType_Function ~= datatype then
    return
  end
  local executeFunc = PaGlobal_ConsoleQuickMenu._functionTypeList._executeFunction[functionType]
  if nil == executeFunc then
    _PA_LOG("\237\155\132\236\167\132", "[ConsoleQuickMenu] QuickMenu.functionType \236\151\144 \237\131\128\236\158\133\236\157\180 \236\182\148\234\176\128\235\144\152\236\151\136\236\156\188\235\169\180 PaGlobal_ConsoleQuickMenu._functionTypeList._executeFunction \236\151\144 \236\182\148\234\176\128\237\149\180 \236\163\188\236\132\184\236\154\148  ")
    return
  end
  executeFunc()
end
registerEvent("FromClient_ConsoleQuickMenu_ExecuteFunctionType", "FromClient_ConsoleQuickMenu_ExecuteFunctionType")
