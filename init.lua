local obj = {}

obj.name = 'Keychord add-on for EWOM spoon'
obj.version = '0.1.0'
obj.author = 'zk-phi'
obj.license = 'MIT'
obj.homepage = 'https://github.com/zk-phi/EWOMKeychord.spoon'

local MODFLAGS =
  hs.eventtap.event.rawFlagMasks.alternate |
  hs.eventtap.event.rawFlagMasks.command |
  hs.eventtap.event.rawFlagMasks.control |
  hs.eventtap.event.rawFlagMasks.shift |
  hs.eventtap.event.rawFlagMasks.deviceRightAlternate |
  hs.eventtap.event.rawFlagMasks.deviceRightCommand |
  hs.eventtap.event.rawFlagMasks.deviceRightControl |
  hs.eventtap.event.rawFlagMasks.deviceRightShift

obj.DELAY = 0.2
obj._EWOM = nil

-- { evt, timer, arg, config = { code, fn }[] }
obj.pending = nil

local function keychordFail ()
  obj.pending.timer:stop()
  obj._EWOM.sendSyntheticEvent(obj.pending.evt)
  obj.pending = nil
end

local function keychordSucceed (fn, evt)
  obj.pending.timer:stop()
  fn(obj.pending.arg, evt)
end

local function preCommandHook (evt)
  if not obj.pending then
    return
  end
  local flags = evt:rawFlags() & MODFLAGS
  if flags > 0 then
    return keychordFail()
  end
  local code = evt:getKeyCode()
  for i = 1, #obj.pending.config do
    if hs.keycodes.map[obj.pending.config[i][1]] == code then
      return keychordSucceed(obj.pending.config[i][2], evt)
    end
  end
  return keychordFail()
end

function obj.cmd (config)
  return function (arg, evt)
    if not obj.pending then
      local timer = hs.timer.doAfter(obj.DELAY, keychordFail)
      obj.pending = { evt = evt, timer = timer, arg = arg, config = config }
    else
      obj.pending = nil
    end
  end
end

function obj.attach (EWOM)
  obj._EWOM = EWOM
  EWOM.addHook(EWOM.preCommandHook, preCommandHook)
end

return obj
