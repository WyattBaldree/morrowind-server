Menus["survive hunger"] = {
    text = color.Gold .. "Do you want\n" .. color.LightGreen ..
    "eat\n" .. color.Gold .. "this food ?\n" ..
        color.White .. "...",
    buttons = {           
        { caption = "yes",
            destinations = {
        menuHelper.destinations.setDefault(nil,
        { 
          menuHelper.effects.runGlobalFunction("TrueSurvive", "OnHungerObject", 
          {
                        menuHelper.variables.currentPid()
                    }),
                    menuHelper.effects.runGlobalFunction("logicHandler", "DeleteObjectForEveryone",
                    {
                        menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        },            
        { caption = "no",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

Menus["survive drink"] = {
    text = color.Gold .. "Do you want\n" .. color.LightGreen ..
    "drink\n" .. color.Gold .. "the contained ?\n" ..
        color.White .. "...",
    buttons = {                        
        { caption = "yes",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("TrueSurvive", "OnDrinkObject", 
                    {
                        menuHelper.variables.currentPid()
                    }),
                    menuHelper.effects.runGlobalFunction("logicHandler", "DeleteObjectForEveryone",
                    {
                        menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        },            
        { caption = "no",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

Menus["survive drink active"] = {
    text = color.Gold .. "Do you want\n" .. color.LightGreen ..
    "drink\n" .. color.Gold .. "the contained ?\n" ..
        color.White .. "...",
    buttons = {                        
        { caption = "oui",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("TrueSurvive", "OnDrinkObject", 
                    {
                        menuHelper.variables.currentPid()
                    })
                })
            }
        },            
        { caption = "non",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

Menus["survive sleep"] = {
    text = color.Gold .. "Do you want\n" .. color.LightGreen ..
    "sleep\n" .. color.Gold .. "in this bed\n" ..
        color.White .. "...",
    buttons = {           
        { caption = "yes",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
        menuHelper.effects.runGlobalFunction("TrueSurvive", "OnSleepObject", 
          {menuHelper.variables.currentPid()})
                })
            }
        },      
        { caption = "no",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
                menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}