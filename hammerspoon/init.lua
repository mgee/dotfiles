require 'action'
require 'hotkey_modal'
require 'profile'

----------------------------------------------------------------------------------------------------
-- Profiles
----------------------------------------------------------------------------------------------------
hs.hints.fontName = "PragmataPro"
hs.hints.fontSize = 22

hs.grid.setMargins({0, 0})
hs.grid.setGrid({6, 4})
--hs.grid.ui.fontName = "PragmataPro"
hs.grid.HINTS = {
  {'f1','f2','f3','f4','f5','f6','f7','f8'},
  {'1','2','3','4','5','6','7','8'},
  {'Q','W','E','R','T','Z','U','I'},
  {'A','S','D','F','G','H','J','K'},
  {'Y','X','C','V','B','N','M',','}
}

local home = Profile.new('Home', {69671680}, {
  ["Atom"]          = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["Google Chrome"] = {Action.MoveToScreen.new(2), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["iTunes"]        = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["Mail"]          = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["Reeder"]        = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["Safari"]        = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["SourceTree"]    = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["Spotify"]       = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.8, 1.0)},
  ["Terminal"]      = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.5, 0.5, 0.5, 0.5)},
  ["TextMate"]      = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.5, 0.0, 0.5, 1.0)},
  ["Xcode"]         = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["_"]             = {Action.Snap.new()}
})

----------------------------------------------------------------------------------------------------

local work = Profile.new('Work', {69732352, 188898833, 188898834, 188915586}, {
  ["Atom"]              = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["Dash"]              = {Action.MoveToScreen.new(2), Action.MoveToUnit.new(0.0, 0.0, 0.5, 1.0)},
  ["Google Chrome"]     = {Action.MoveToScreen.new(2), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["iTunes"]            = {Action.Close.new()},
  ["Parallels Desktop"] = {Action.MoveToScreen.new(2), Action.FullScreen.new()},
  ["Safari"]            = {Action.MoveToScreen.new(2), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["SourceTree"]        = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["Terminal"]          = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.5, 0.5, 0.5, 0.5)},
  ["TextMate"]          = {Action.MoveToScreen.new(2), Action.MoveToUnit.new(0.5, 0.0, 0.5, 1.0)},
  ["Tower"]             = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["Xcode"]             = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["_"]                 = {Action.Snap.new()}
})

----------------------------------------------------------------------------------------------------
-- Hotkey Bindings
----------------------------------------------------------------------------------------------------

local mash = {'ctrl', 'alt'}

hs.hotkey.bind(mash, 'UP', function() Action.Maximize.new():perform() end)
hs.hotkey.bind(mash, 'DOWN', function() Action.MoveToNextScreen.new():perform() end)
hs.hotkey.bind(mash, 'LEFT', function() Action.MoveToUnit.new(0.0, 0.0, 0.5, 1.0):perform() end)
hs.hotkey.bind(mash, 'RIGHT', function() Action.MoveToUnit.new(0.5, 0.0, 0.5, 1.0):perform() end)
hs.hotkey.bind(mash, 'SPACE', function() utils.snapAll() end)
hs.hotkey.bind(mash, 'H', function() hs.hints.windowHints() end)
hs.hotkey.bind(mash, 'G', function() hs.grid.show() end)
hs.hotkey.bind(mash, '^', function() Profile.activateActiveProfile() end)

local position = HotkeyModal.new('Position', mash, '1')
position:bind({}, 'UP', function() utils.positionBottomLeft() end)
position:bind({}, 'DOWN', function() utils.positionBottomRight() end)
position:bind({}, 'LEFT', function() utils.positionTopLeft() end)
position:bind({}, 'RIGHT', function() utils.positionTopRight() end)
position:bind({}, 'RETURN', function() position:exit() end)

local resize = HotkeyModal.new('Resize', mash, '2')
resize:bind({}, 'UP', function() hs.grid.resizeWindowShorter() end)
resize:bind({}, 'DOWN', function() hs.grid.resizeWindowTaller() end)
resize:bind({}, 'LEFT', function() hs.grid.resizeWindowThinner() end)
resize:bind({}, 'RIGHT', function() hs.grid.resizeWindowWider() end)
resize:bind({}, 'RETURN', function() resize:exit() end)

local move = HotkeyModal.new('Move', mash, '3')
move:bind({}, 'UP', function() hs.grid.pushWindowUp() end)
move:bind({}, 'DOWN', function() hs.grid.pushWindowDown() end)
move:bind({}, 'LEFT', function() hs.grid.pushWindowLeft() end)
move:bind({}, 'RIGHT', function() hs.grid.pushWindowRight() end)
move:bind({}, 'RETURN', function() move:exit() end)

local appShortcuts = {
  ['a'] = 'Atom',
  ['c'] = 'Google Chrome',
  ['d'] = 'Dash',
  ['e'] = 'TextMate',
  ['f'] = 'Finder',
  ['g'] = 'Tower',
  ['m'] = 'iTunes',
  ['p'] = 'Parallels Desktop',
  ['t'] = 'Terminal',
  ['x'] = 'Xcode',
}

for shortcut, appName in pairs(appShortcuts) do
  hs.hotkey.bind({'alt', 'cmd'}, shortcut, function() hs.application.launchOrFocus(appName) end)
end

----------------------------------------------------------------------------------------------------
-- Settings and Watcher
----------------------------------------------------------------------------------------------------
hs.window.animationDuration = 0.1

hs.application.watcher.new(
  function(appName, event)
    if event == hs.application.watcher.launched then
      local profile = Profile.activeProfile()
      local app = hs.appfinder.appFromName(appName)
      if profile and app then profile:activateFor(app) end
    end
  end
):start()

hs.screen.watcher.new(function() Profile.activateActiveProfile() end):start()
hs.pathwatcher.new(hs.configdir, function(files) hs.reload() end):start()

hs.alert("Hammerspoon loaded", 1)

Profile.activateActiveProfile()
