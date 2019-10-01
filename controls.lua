  local ch_count = props["Inputs"].Value -- Setting this property to a variable will save us typing time below, setting the count of controls to the number of inputs the user has defined
  -- Add comments like the one below to make it easier to find things in your code
  -- If anyone ever has to search through or modify your code, they will thank you for this!
  table.insert(ctrls,{Name = "code",ControlType = "Text",UserPin = true,PinStyle ="Input",Count = 1})
  -- Mixer Page Controls
  -- EQ Controls
  table.insert(ctrls,
    {
      Name = "EQBypass", -- Make your control names as obvious and simple as possible. You can always set shorter variables for them in your runtime code
      ControlType = "Button",
      ButtonType = "Toggle",
      UserPin = true, -- UserPin allows pin choice to be added to the Control Pins section of the Properties. Setting UserPin=false while specifying PinStyle means the pin is present with no option to remove it
      PinStyle = "Both",-- Omitting this parameter and UserPin will prevent a pin and will not add it to the Control Pins list
      Count = ch_count, -- Here we call the above value set in the Properties pane by the user to determine how many of these controls we need. 
    }
  )
  table.insert(ctrls,
    {
      Name = "EQFrequency",
      ControlType = "Knob",
      ControlUnit = "Hz",
      Min = 10, -- On controls with ControlUnit, set a Min and Max value
      Max = 20000,
      UserPin = true,
      PinStyle = "Both",
      Count = ch_count,
    }
  )
  table.insert(ctrls,
    {
      Name = "EQGain",
      ControlType = "Knob",
      ControlUnit = "dB",
      Min = -100,
      Max = 10,
      UserPin = true,
      PinStyle = "Both",
      Count = ch_count,
    }
  )
  table.insert(ctrls,
    {
      Name = "EQBandwidth",
      ControlType = "Knob",
      ControlUnit = "Float", -- Since we want a Min/Max with decimal points, we need to specify the ControlUnit as Float instead of Integer
      Min = 0.010,
      Max = 3.00,
      UserPin = true,
      PinStyle = "Both",
      Count = ch_count,
    }
  )
  table.insert(ctrls,
   {
      Name = "EQType",
      ControlType = "Text",
      UserPin = true,
      PinStyle = "Both",
      Count = ch_count,
    } 
  )
  -- Mixer Controls
  table.insert(ctrls,
   {
      Name = "Gain",
      ControlType = "Knob",
      ControlUnit = "dB",
      Min = -20,
      Max = 10,
      PinStyle = "Both",
      UserPin = true,
      Count = ch_count, 
    }
  )
  table.insert(ctrls,
    {
      Name = "Mute",
      ControlType = "Button",
      ButtonType = "Toggle",
      PinStyle = "Both",
      UserPin = true,
      Count = ch_count, 
    }
  )
  table.insert(ctrls,
    {
      Name = "Solo",
      ControlType = "Button",
      ButtonType = "Toggle",
      PinStyle = "Both",
      UserPin = true,
      Count = ch_count,
    }
  )
  table.insert(ctrls,
   {
      Name = "ChannelName",
      ControlType = "Text",
      UserPin = true,
      PinStyle = "Both",
      Count = ch_count, 
    }
  )
  table.insert(ctrls,
   {
      Name = "Clip",
      ControlType = "Indicator",
      IndicatorType = "LED",
      PinStyle = "Both",
      UserPin = true,
      Count = ch_count,
    }
  )
  -- Video Switcher Page Controls
  table.insert(ctrls,
    {
      Name = "Status",
      ControlType = "Indicator",
      IndicatorType = "Status",
      Count = 1
    }
  )
  table.insert(ctrls,
    {
      Name = "Connect",
      ControlType = "Button",
      ButtonType = "Toggle",
      UserPin = true,
      PinStyle = "Both",
      Count = 1
    }
  )
  table.insert(ctrls,
    {
      Name = "Port",
      ControlType = "Knob",
      ControlUnit = "Integer",
      Min = 1,
      Max = 65535,
      UserPin = true,
      PinStyle = "Both",
      Count = 1,
    }
  )
  -- Since we are populating these controls for two different displays, we can do it quickly with a 'for' loop
  -- This is good practice for controls that have multiple congruent, or even similar, property values, and it makes your code more extensible.
  -- Keep in mind that the use of variable 'j' here is completely arbitrary and you can use variables more intuitive to you when writing your plugin i.e. for control_num=1,2 do
  table.insert(ctrls,
    {
      Name = "Power",
      ControlType = "Button",
      ButtonType = "Toggle",
      UserPin = true,
      PinStyle = "Both",
      Count = 2,
    })
  table.insert(ctrls,
    {
    Name = "ImageAdjustRed",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Min = 0,
    Max = 255,
    UserPin = true,
    PinStyle = "Both",
    Count = 2,
  })
  table.insert(ctrls,
    {
    Name = "ImageAdjustGreen",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Min = 0,
    Max = 255,
    UserPin = true,
    PinStyle = "Both",
    Count = 2,
  })
  table.insert(ctrls,
    {
    Name = "ImageAdjustBlue",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Min = 0,
    Max = 255,
    UserPin = true,
    PinStyle = "Both",
    Count = 2,
  })
  table.insert(ctrls,
  {
    Name = "RGBSave",
    ControlType = "Button",
    ButtonType = "Trigger",
    UserPin = true,
    PinStyle = "Both",
    Count = 2
  })
  table.insert(ctrls,
  {
    Name = "RGBRecall",
    ControlType = "Button",
    ButtonType = "Trigger",
    UserPin = true,
    PinStyle = "Both",
    Count = 2
  })
  -- I've nested a 'for' within another here to quickly populate the same inputs for two different outputs
  -- Once again, the use of 'i' as my iterator is completely arbitrary. You could use something like 'inputs' if that is more intuitive for you
  for i=1,2 do
    table.insert(ctrls,
    {
      Name = string.format("Output%iInput",i),
      ControlType = "Button",
      ButtonType = "Trigger",
      UserPin = true,
      PinStyle = "Both",
      Count = 6
    })
  end