-- Hammerspoon Window Layouts — refactored and cleaned

-- Instant moves/snaps feel better for tiling
hs.window.animationDuration = 0

-- Common modifiers for window moves
local hyper = {"cmd", "alt"}

-- Layout container relative to screen (centered box)
local CONTAINER_W, CONTAINER_H = 0.8, 0.9
local WIDTH_RATIOS = { 1/3, 1/2, 2/3 } -- cycle order; add 1/4, 3/4, etc. as needed

-- Compute a frame inside a centered container, with optional subdivision
local function layoutFrame(screenFrame, containerW, containerH, pos)
  local f = {
    x = screenFrame.x + (screenFrame.w * (1 - containerW)) / 2,
    y = screenFrame.y + (screenFrame.h * (1 - containerH)) / 2,
    w = screenFrame.w * containerW,
    h = screenFrame.h * containerH,
  }

  if pos == "left" then
    f.w = f.w / 2
  elseif pos == "right" then
    f.w = f.w / 2
    f.x = f.x + f.w
  elseif pos == "tl" then
    f.w = f.w / 2; f.h = f.h / 2
  elseif pos == "tr" then
    f.w = f.w / 2; f.h = f.h / 2; f.x = f.x + f.w
  elseif pos == "bl" then
    f.w = f.w / 2; f.h = f.h / 2; f.y = f.y + f.h
  elseif pos == "br" then
    f.w = f.w / 2; f.h = f.h / 2; f.y = f.y + f.h; f.x = f.x + f.w
  end

  return f
end

local function place(pos, containerW, containerH)
  local win = hs.window.focusedWindow()
  if not win then return end
  local max = win:screen():frame()
  containerW = containerW or CONTAINER_W
  containerH = containerH or CONTAINER_H
  local f = layoutFrame(max, containerW, containerH, pos)
  win:setFrame(f, 0)
end

local function approxEq(a, b, eps)
  eps = eps or 0.02
  return math.abs(a - b) <= eps
end

local function closestWidthIndex(ratio)
  local bestIndex = 1
  local bestDelta = math.huge

  for i, widthRatio in ipairs(WIDTH_RATIOS) do
    local delta = math.abs(ratio - widthRatio)
    if delta < bestDelta then
      bestDelta = delta
      bestIndex = i
    end
  end

  return bestIndex
end

local widthDirections = {}

local function nextWidthRatio(sequenceKey, ratio)
  local currentIndex = closestWidthIndex(ratio)
  local direction = widthDirections[sequenceKey] or 1

  if currentIndex == #WIDTH_RATIOS then
    direction = -1
  elseif currentIndex == 1 then
    direction = 1
  end

  local nextIndex = currentIndex + direction
  widthDirections[sequenceKey] = direction
  return WIDTH_RATIOS[nextIndex]
end

local function frameForSideInRect(rect, side, widthRatio)
  local w = rect.w * widthRatio
  local x = (side == "left") and rect.x or (rect.x + rect.w - w)
  return { x = x, y = rect.y, w = w, h = rect.h }
end

local function sideForFrameInRect(frame, rect)
  if approxEq(frame.x, rect.x, 2) then
    return "left"
  end

  if approxEq(frame.x + frame.w, rect.x + rect.w, 2) then
    return "right"
  end
end

local function moveOrCycleWidthInRect(targetSide, rect, sequenceKey)
  local win = hs.window.focusedWindow()
  if not win then return end

  local cur = win:frame()
  local curRatio = cur.w / rect.w
  local curSide = sideForFrameInRect(cur, rect)
  local targetRatio = curRatio

  if curSide == targetSide then
    targetRatio = nextWidthRatio(sequenceKey, curRatio)
  end

  win:setFrame(frameForSideInRect(rect, targetSide, targetRatio), 0)
end

-- Keybindings (same behaviors, less repetition)
hs.hotkey.bind(hyper, "return", function() place("center") end) -- centered 0.8w x 0.9h
-- cmd+alt + left/right: same side cycles configured widths; opposite side keeps width
hs.hotkey.bind(hyper, "left",   function()
  local win = hs.window.focusedWindow(); if not win then return end
  local max = win:screen():frame()
  local rect = layoutFrame(max, CONTAINER_W, CONTAINER_H, "center")
  moveOrCycleWidthInRect("left", rect, "container")
end)
hs.hotkey.bind(hyper, "right",  function()
  local win = hs.window.focusedWindow(); if not win then return end
  local max = win:screen():frame()
  local rect = layoutFrame(max, CONTAINER_W, CONTAINER_H, "center")
  moveOrCycleWidthInRect("right", rect, "container")
end)
hs.hotkey.bind(hyper, "a",      function() place("tl")     end) -- top-left quadrant
hs.hotkey.bind(hyper, "s",      function() place("tr")     end) -- top-right quadrant
hs.hotkey.bind(hyper, "z",      function() place("bl")     end) -- bottom-left quadrant
hs.hotkey.bind(hyper, "x",      function() place("br")     end) -- bottom-right quadrant

-- Full-screen grid equivalents on ctrl+option (no container; uses full screen)
local hyperFull = {"ctrl", "alt"}
hs.hotkey.bind(hyperFull, "return", function() place("center", 1.0, 1.0) end) -- full screen center op
-- ctrl+alt + left/right: same side cycles configured widths; opposite side keeps width
hs.hotkey.bind(hyperFull, "left",   function()
  local win = hs.window.focusedWindow(); if not win then return end
  moveOrCycleWidthInRect("left", win:screen():frame(), "full")
end)
hs.hotkey.bind(hyperFull, "right",  function()
  local win = hs.window.focusedWindow(); if not win then return end
  moveOrCycleWidthInRect("right", win:screen():frame(), "full")
end)
hs.hotkey.bind(hyperFull, "a",      function() place("tl",     1.0, 1.0) end) -- top-left quadrant
hs.hotkey.bind(hyperFull, "s",      function() place("tr",     1.0, 1.0) end) -- top-right quadrant
hs.hotkey.bind(hyperFull, "z",      function() place("bl",     1.0, 1.0) end) -- bottom-left quadrant
hs.hotkey.bind(hyperFull, "x",      function() place("br",     1.0, 1.0) end) -- bottom-right quadrant

-- Move focused window to previous/next monitor (shift+ctrl+alt + left/right)
local hyperScreen = {"shift", "ctrl", "alt"}
local function moveFocusedToScreen(getScreenFn)
  local win = hs.window.focusedWindow()
  if not win then return end
  local curScreen = win:screen()
  if not curScreen then return end
  local target = getScreenFn(curScreen)
  if target and target ~= curScreen then
    win:moveToScreen(target)
  end
end

hs.hotkey.bind(hyperScreen, "left", function()
  moveFocusedToScreen(function(s) return s:previous() end)
end)
hs.hotkey.bind(hyperScreen, "right", function()
  moveFocusedToScreen(function(s) return s:next() end)
end)

-- Auto-reload on changes to ~/.hammerspoon and show a small confirmation
local function shouldReload(files)
  for _, file in ipairs(files) do
    if file:sub(-4) == ".lua" then return true end
  end
  return false
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function(files)
  if shouldReload(files) then hs.reload() end
end):start()

hs.alert.show("Hammerspoon config loaded")
