-- Since our plugin has multiple pages, we need to define some variables to help us dynamically draw the UI based on page and property selections
local CurrentPage = pagenames[props["page_index"].Value] -- This variable can be used to only draw the ctls you want on that page
local inpnum = props["Inputs"].Value -- Sizes of certain elements can be dynamic based on how many channels there are
local btn_style = props["Button Styles"].Value -- We will set button style based on what the user has selected in the Properties pane

if CurrentPage == "Mixer" then -- Anything below here is only drawn on the "Mixer" page
  layout["code"] = {Style = "Text",Position = {0,0},Size = {5,5}}
  for i=1,inpnum do
    -- Since Lua in Q-Sys compiles into C, there are some quirks to consider here
    -- If you only have a singular control ("Input 1"), the control exists just as that
    -- If, however, you have multiple controls ("Input 1","Input 2"), the controls are captured in an array
    -- The tostring() call below handles when there is only one input (inpnum==1) and the control is not captured in an array
    -- The below logic allows us to accommdate both scenarios: a single control or an array of controls
    local ctl_str = tostring(inpnum==1 and "" or " "..i)
    -- This format is the same as table.insert(layout,'your control stuff here')
    -- Since Q-Sys already knows these controls exist, what their names are, and expects us to define their layout, we can use this shorthand method
    -- Please note that this will NOT work for non-control graphical elements, as they don't already have a 'Name' defined for Q-Sys
    layout["EQBypass"..ctl_str] = 
    {
      PrettyName = string.format("EQ~Input %i~Bypass",i),-- The tilde (~) creates a folder for the pins. This can help keep your pins organized and the property pane looking clean
      Style = "Button",
      ButtonStyle = "Toggle",
      ButtonVisualStyle = btn_style,
      Color = {242,137,174},
      UnlinkOffColor = false,
      -- Notice below I am using i to determine the position dynamically: 55 is the X position of the first ctl, and 49 is the distance to the next X value. 
      -- Multiply by i-1 so the addition begins with the second ctl instead of the first. Thus, if i==2, we will multiply 49 by and add that to 55, giving us the X value of our second ctl
      -- This is a valuable technique if you want to offer a plugin that is not only dynamic, but configurable by the end-user
      Position = {55+49*(i-1),32}, 
      Size = {36,16},
    }
    layout["EQFrequency"..ctl_str] = 
    {
      PrettyName = string.format("EQ~Input %i~Frequency",i),
      Style = "Knob",
      Position = {55+49*(i-1),48},
      Size = {36,36}
    }
    layout["EQGain"..ctl_str] = 
    {
      PrettyName = string.format("EQ~Input %i~Gain",i),
      Style = "Knob",
      Position = {55+49*(i-1),84},
      Size = {36,36}
    }
    layout["EQBandwidth"..ctl_str] = 
    {
      PrettyName = string.format("EQ~Input %i~Bandwidth",i),
      Style = "Knob",
      Position = {55+49*(i-1),120},
      Size = {36,36}
    }
    layout["EQType"..ctl_str] = 
    {
      PrettyName = string.format("EQ~Input %i~Type",i),
      Style = "ComboBox",
      Position = {55+49*(i-1),156},
      Size = {36,16}
    }
    layout["Clip"..ctl_str] = 
    {
      PrettyName = string.format("Inputs~Input %i~Clip",i),
      Style = "LED",
      Color = Colors.Red,
      UnlinkOffColor = false,
      Position = {64+49*(i-1),202},
      Size = {16,16}
    }
    layout["Gain"..ctl_str] = 
    {
      PrettyName = string.format("Inputs~Input %i~Gain",i), 
      Style = "Fader",
      Position = {55+49*(i-1),218},
      Size = {36,112}
    }
    layout["Solo"..ctl_str] = 
    {
      PrettyName = string.format("Inputs~Input %i~Solo",i),
      Style = "Button",
      ButtonStyle = "Toggle",
      ButtonVisualStyle = btn_style,
      Color = {0,159,60},
      UnlinkOffColor = false,
      Position = {55+49*(i-1),330},
      Size = {36,16},
    }
    layout["Mute"..ctl_str] = 
    {
      PrettyName = string.format("Inputs~Input %i~Mute",i),
      Style = "Button",
      ButtonStyle = "Toggle",
      ButtonVisualStyle = btn_style,
      Color = {223,0,36},
      UnlinkOffColor = false,
      Position = {55+49*(i-1),346},
      Size = {36,16}
    }
    layout["ChannelName"..ctl_str] = 
    {
      PrettyName = string.format("Inputs~Input %i~Label",i),
      Style = "Text",
      StrokeWidth = 2,
      StrokeColor = Colors.Black, 
      FontSize = 12,
      Position = {55+49*(i-1),362},
      Size = {36,18},
    }
  end

  graphics = { -- All of these graphics are drawn only if the current page is "Mixer"
    {
      Type = "Groupbox", -- This is the overall groupbox that will give the plugin a more 'contained' look
      Fill = Colors.White,
      CornerRadius = 8,
      StrokeColor = Colors.Black,
      StrokeWidth = 1,
      Position = {0,0},
      Size = {104+49*(inpnum-1),393} -- The width of the main GroupBox is dependent on how many channels the user specified. More channels means a wider group box
    },
    -- I've collapsed other graphic properties into single lines to save space. Saving space isn't a top priority, but it can make your file look more clean and save space.
    -- Keep in mind that while this will save space, it is inherently more difficult to follow and you sacrifice readability
    {Type = "GroupBox",Text = "EQ",HTextAlign = "Left",CornerRadius = 8,StrokeColor = Colors.Black,StrokeWidth = 1,Position = {6,9},Size = {92+49*(inpnum-1),169}},
    {Type = "GroupBox",Text = "Inputs",HTextAlign = "Left",CornerRadius = 8,StrokeColor = Colors.Black,StrokeWidth = 1,Position = {6,182},Size = {92+49*(inpnum-1),203}},
  }

  -- Since our labels have few properties that are different, we can put those differences in a table and iterate over it rather than type each one out individually
  local labels = { 
    Text = {"Bypass","Frequency","Gain","Bandwidth (oct)","Type","Clip","Gain","Solo","Mute","Label"},
    PosY = {32,48,84,120,156,201,218,330,347,362},
    SizeY = {16,36,36,36,16,17,112,17,17,17}
    }
  for i=1,#labels.Text do 
    table.insert(graphics,
      {
        Type = "Text",
        Text = labels.Text[i],
        Font = "Roboto",
        FontSize = 9,
        HTextAlign = "Center",
        Color = Colors.Black,
        Fill = Colors.White,
        Position = {8,labels.PosY[i]},
        Size = {47,labels.SizeY[i]}
      })
  end
  for i=1,inpnum do
    table.insert(graphics,
      {
        Type = "Text",
        Text = string.format("CH %i",i),
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Bold",
        HTextAlign = "Center",
        Color = Colors.Black,
        Position = {55+49*(inpnum-1),362},
        Size = {36,17},
      })
  end

elseif CurrentPage == "Video Switcher" then -- Anything below here is only drawn on the "Configuration" page

  layout["Status"] = 
  {
    PrettyName = "Status",
    Style = "Indicator",
    Position = {172,52},
    Size = {92,18},
  }
  layout["Connect"] = 
  {
    PrettyName = "Connect",
    Style = "Button",
    ButtonStyle = "Toggle",
    ButtonVisualStyle = btn_style,
    CornerRadius = 2,
    Legend = "Connect",
    FontSize = 11,
    Color = Colors.Green,
    UnlinkOffColor = false,
    Position = {172,34},
    Size = {92,18}
  }
  layout["Port"] = 
  {
    PrettyName = "Port",
    Style = "TextBox",
    TextBoxStyle = "Meter",
    Position = {172,18},
    Size = {92,18},
  }

  local legends = {"TV","DVR","PC 1","PC 2","HDMI 1","HDMI 2"}
  -- Using for loops can save a lot of time and energy. Notice here that there is a for loop nested within a for loop in order to draw a set of inputs for each output
  -- Keep in mind that 'i' and 'j' were arbitrary variables I chose. You could use "inputs" and "channel" if you felt so inclined
  for i=1,#legends do 
    for j=1,2 do
      local inputs = string.format("Output%iInput ",j)
      layout[inputs..i] =
      {
        PrettyName = string.format("Display %i~Input %i",j,i), -- Notice the tilde here again. This will help keep our Control Pins organized
        Style = "Button",
        ButtonStyle = "Trigger",
        ButtonVisualStyle = btn_style,
        Legend = legends[i],
        FontSize = 8,
        Color = {73,127,191},
        OffColor = {30,58,91},
        UnlinkOffColor = false,
        Position = {36+36*(i-1),140+154*(j-1)}, 
        --[[
            We can use i and j to set positions, similar to some of our methods previously in the plugin
            Generally speaking, you'll multiply the width (or difference in position) of the ctls by the variable, then add or subtract the appropriate difference for the first control. 
            In the above example, the input buttons have a width of 36, which is how much their X positions will increase by, since they are flush. We can multiply that width/X position variance
            by how many buttons we have (i), and just add the 7 for the first button whose X position value is 43 (43-36=7). For the Y position, simply take the difference between your 
            first row of inputs' Y position and the second rows' Y position. Since we only want to add the 60 for the second row, we can subtract 1 from j and thus only when j>=2 will
            the Y position increase by 60.
          ]]
        Size = {36,16},
      }
    end
  end

  for i=1,2 do
    layout["Power "..i] =
    {
      PrettyName = string.format("Display %i~Power",i),
      Style = "Button",
      ButtonStyle = "Toggle",
      ButtonVisualStyle = btn_style,
      Legend = "Power",
      FontSize = 9,
      CornerRadius = 10,
      Color = Colors.Green,
      UnlinkOffColor = true,
      OffColor = Colors.Red,
      Position = {72,91+154*(i-1)},
      Size = {144,26},
    }

    layout["ImageAdjustRed "..i] = {PrettyName = string.format("Display %i~Red",i),Style = "Knob",Position = {36,181+154*(i-1)},Size = {36,36}}
    layout["ImageAdjustGreen "..i] = {PrettyName = string.format("Display %i~Green",i),Style = "Knob",Position = {93,181+154*(i-1)},Size = {36,36}}
    layout["ImageAdjustBlue "..i] = {PrettyName = string.format("Display %i~Blue",i),Style = "Knob",Position = {150,181+154*(i-1)},Size = {36,36}}
    layout["RGBSave "..i] = {PrettyName=string.format("Display %i~RGB Save",i),Style="Button",ButtonStyle="Trigger",ButtonVisualStyle=btn_style,Legend="Save",CornerRadius=2,Color={254,248,134},Position={197,181+154*(i-1)},Size={55,16}}
    layout["RGBRecall "..i] = {PrettyName=string.format("Display %i~RGB Recall",i),Style="Button",ButtonStyle="Trigger",ButtonVisualStyle=btn_style,Legend="Recall",CornerRadius=2,Color={254,248,134},Position={197,197+154*(i-1)},Size={55,16}}
  end

  graphics = {
    {
      Type = "GroupBox",
      Fill = Colors.White,
      CornerRadius = 8,
      StrokeColor = Colors.Black,
      StrokeWidth = 1,
      Position = {0,0},
      Size = {284,393}
    },
    -- Once again, graphic properties below are collapsed into single lines, but this is not a requirement. You can type them out as the groupbox is above
    {Type = "GroupBox",Text = "Connection",HTextAlign = "Left",Fill = Colors.White,CornerRadius = 8,StrokeColor = Colors.Black,StrokeWidth = 1,Position = {8,6},Size = {267,75}},
    {Type = "GroupBox",Text = "Display 1",HTextAlign = "Left",Fill = Colors.White,CornerRadius = 8,StrokeColor = Colors.Black,StrokeWidth = 1,Position = {8,85},Size = {267,148}},
    {Type = "GroupBox",Text = "Display 2",HTextAlign = "Left",Fill = Colors.White,CornerRadius = 8,StrokeColor = Colors.Black,StrokeWidth = 1,Position = {8,239},Size = {267,148}},
    {Type = "Text",Text = "Status",Font = "Roboto",FontSize = 10,HTextAlign = "Center",Color = Colors.Black,Position = {136,52},Size = {36,18}},
    {Type = "Text",Text = "Port",Font = "Roboto",FontSize = 10,HTextAlign = "Center",Color = Colors.Black,Position = {136,16},Size = {36,18}},

    -- You can have a JPEG, PNG, or SVG in your plugin, and they will draw in the sequence you draw them in this file (based on 'Z' order)
    -- The below image is encoded by the compiler when we build our plugin
    -- Simply specify where on your machine the image lives, and the compiler will do the rest
    -- The .qplug file will only display the base64 encoded data
    { 
      Type = "Svg",
      Image = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz48c3ZnIHZlcnNpb249IjEuMSIgaWQ9IkxheWVyXzEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgMTE1IDM2IiBzdHlsZT0iZW5hYmxlLWJhY2tncm91bmQ6bmV3IDAgMCAxMTUgMzY7IiB4bWw6c3BhY2U9InByZXNlcnZlIj48c3R5bGUgdHlwZT0idGV4dC9jc3MiPi5zdDB7ZmlsbDojMDA3QkMyO308L3N0eWxlPjx0aXRsZT5Bc3NldCAxPC90aXRsZT48Zz48ZyBpZD0iTGF5ZXJfMS0yIj48ZyBpZD0iUVNDX0xvZ29zIj48ZyBpZD0iUVNDX0xvZ29fLV9CbHVlIj48ZyBpZD0iUVNDX0xvZ28iPjxwYXRoIGNsYXNzPSJzdDAiIGQ9Ik03Ni41LDI2LjVjLTAuNiwzLjctMi4xLDUuNi00LjcsNS42SDQyLjFjLTEsMC0xLjItMC40LTEuMi0xLjh2LTIuOWMwLTEuMSwwLjMtMS41LDEtMS41aDI0YzAuOSwwLDEtMC4yLDEtMS42di0zLjVjMC0xLjItMC4yLTEuNC0wLjktMS40SDQ1LjdjLTIuOSwwLTQuNS0xLjktNS02LjNjLTAuMy0yLjUtMC4zLTQuOSwwLjEtNy40QzQxLjQsMS45LDQyLjksMCw0NS41LDBjMTAsMCwxOS45LDAsMjkuOSwwYzAuOCwwLDEuMSwwLjQsMS4xLDEuN3MwLDIuMywwLDMuNWMwLDAuOS0wLjMsMS40LTAuOSwxLjRINTEuNGMtMC45LDAtMSwwLjItMSwxLjZ2My4xYzAsMS4yLDAuMiwxLjUsMSwxLjVoMTUuOGMxLjYsMCwzLjIsMCw0LjgsMGMyLjUsMCw0LDEuOCw0LjYsNS41Qzc3LDIxLDc3LDIzLjgsNzYuNSwyNi41eiIvPjxwYXRoIGNsYXNzPSJzdDAiIGQ9Ik0zOCw2LjVjMC0wLjQsMC0wLjcsMC0xLjFjMC0xLjYtMC42LTMuMi0xLjgtNC4zYy0xLTAuOC0yLjItMS4yLTMuNS0xLjFjLTQuMywwLTguNiwwLTEyLjgsMEg2LjNjLTIsMC0zLjUsMS40LTQuNiw0Yy0xLjIsMy4yLTEuNCw2LjgtMS42LDEwLjNjLTAuMSwyLjYsMCw1LjEsMC4zLDcuNmMwLjEsMS42LDAuNCwzLjIsMC45LDQuOGMxLDMuNiwyLjcsNS41LDUuMyw1LjRjNC4xLTAuMSw4LjEsMCwxMi4yLDBjMSwwLDIuMSwwLDMuMiwwYzAuNCwwLDAuNiwwLjIsMC41LDAuOHMwLDEuNSwwLDIuMmMwLDAuNiwwLjIsMC45LDAuNiwwLjljMiwwLDQsMCw2LjEsMGMwLjQsMCwwLjYtMC4zLDAuNi0wLjlzMC0xLjQsMC0yLjFzMC4xLTAuOSwwLjYtMC45YzEuNCwwLjEsMi44LDAuMSw0LjItMC4yYzItMC41LDMuNi0yLjMsMy42LTYuM0MzOCwxOS4zLDM4LDEyLjksMzgsNi41eiBNMzIuNSwyMy41YzAsMS4zLTAuNCwxLjktMS4yLDEuOWMtMC40LDAtMC44LDAtMS4yLDBzLTAuNS0wLjItMC40LTAuN2MwLTAuOCwwLTEuNSwwLTIuM2MwLTAuNS0wLjEtMC44LTAuNS0wLjhoLTYuMmMtMC40LDAtMC41LDAuMi0wLjUsMC43YzAsMC44LDAsMS41LDAsMi4zYzAsMC42LTAuMSwwLjctMC41LDAuN2MtMiwwLTMuOSwwLTUuOSwwaC01LjdjLTAuOSwwLTEuMi0wLjUtMS4yLTEuOVY4LjFjMC0xLjMsMC40LTEuOSwxLjItMS45aDIxYzAuOSwwLDEuMiwwLjYsMS4yLDEuOUwzMi41LDIzLjVMMzIuNSwyMy41eiIvPjxwYXRoIGNsYXNzPSJzdDAiIGQ9Ik0xMTUsMjcuMnYzLjVjMCwxLjEtMC4yLDEuNC0wLjksMS40SDk5LjRjLTQuNiwwLTkuMi0wLjEtMTMuOCwwYy0zLjEsMC4xLTQuOC0yLjQtNS42LTYuM2MtMC41LTIuNi0wLjgtNS4yLTAuOC03LjhjLTAuMi0zLjYsMC4xLTcuMiwwLjYtMTAuN2MwLjMtMi4xLDEtNC4xLDIuMy01LjljMC44LTEsMi0xLjUsMy4yLTEuNUgxMTRjMC44LDAsMSwwLjMsMSwxLjV2My43YzAsMC45LTAuMiwxLjItMC44LDEuM0g4OS4zYy0wLjksMC0xLDAuMi0xLDEuNVYyNGMwLDEuNCwwLjEsMS42LDEsMS42aDI0LjZDMTE0LjksMjUuNiwxMTUsMjUuOCwxMTUsMjcuMnoiLz48L2c+PC9nPjwvZz48L2c+PC9nPjwvc3ZnPg==",
      Position = {21,34},
      Size = {115,36}
    },
  }

  for i=1,2 do
    table.insert(graphics,
    {
      Type = "Header",
      Text = "Input Select",
      HTextAlign = "Center",
      Color = Colors.Black,
      FontSize = 12,
      Position = {36,124+154*(i-1)},
      Size = {216,10},
    })
    table.insert(graphics,
    {
      Type = "Header",
      Text = "Image Adjust",
      HTextAlign = "Center",
      Color = Colors.Black,
      FontSize = 12,
      Position = {36,168+154*(i-1)},
      Size = {216,10},
    })

    table.insert(graphics,{Type = "Text",Text = "Red",FontSize = 8,HTextAlign = "Center",Color = Colors.Black,Position = {36,211+154*(i-1)},Size = {36,16}})
    table.insert(graphics,{Type = "Text",Text = "Green",FontSize = 8,HTextAlign = "Center",Color = Colors.Black,Position = {93,211+154*(i-1)},Size = {36,16}})
    table.insert(graphics,{Type = "Text",Text = "Blue",FontSize = 8,HTextAlign = "Center",Color = Colors.Black,Position ={150,211+154*(i-1)},Size = {36,16}})
  end
end