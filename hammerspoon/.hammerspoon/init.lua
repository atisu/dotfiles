-- Hammerspoon Window Layouts — refactored and cleaned

-- Instant moves/snaps feel better for tiling
hs.window.animationDuration = 0

-- Common modifiers for window moves
local hyper = {"cmd", "alt"}

-- Layout container relative to screen (centered box)
local CONTAINER_W, CONTAINER_H = 0.8, 0.9
local WIDTH_SMALL, WIDTH_LARGE = 0.50, 0.66

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

-- Helpers to toggle width between 50% and 66% anchored to left/right
local function approxEq(a, b, eps)
  eps = eps or 0.02
  return math.abs(a - b) <= eps
end

local function frameForSide(max, side, wRatio, hRatio)
  local w = max.w * wRatio
  local h = max.h * hRatio
  local x = (side == "left") and max.x or (max.x + max.w - w)
  local y = max.y + (max.h - h) / 2 -- vertically center when not full height
  return { x = x, y = y, w = w, h = h }
end

local function toggleWidth(side, heightRatio)
  local win = hs.window.focusedWindow()
  if not win then return end
  local max = win:screen():frame()
  local cur = win:frame()
  local curRatio = cur.w / max.w
  local target = approxEq(curRatio, WIDTH_SMALL) and WIDTH_LARGE or WIDTH_SMALL
  local hRatio = heightRatio or 1.0
  local f = frameForSide(max, side, target, hRatio)
  win:setFrame(f, 0)
end

-- Toggle widths within an arbitrary rect (e.g., centered container)
local function toggleWidthInRect(side, rect)
  local win = hs.window.focusedWindow()
  if not win then return end
  local cur = win:frame()
  local curRel = cur.w / rect.w
  local targetRel = approxEq(curRel, WIDTH_LARGE) and WIDTH_SMALL or WIDTH_LARGE
  local w = rect.w * targetRel
  local h = rect.h
  local x = (side == "left") and rect.x or (rect.x + rect.w - w)
  local y = rect.y
  win:setFrame({ x = x, y = y, w = w, h = h }, 0)
end

-- Keybindings (same behaviors, less repetition)
hs.hotkey.bind(hyper, "return", function() place("center") end) -- centered 0.8w x 0.9h
-- cmd+alt + left/right: cycle widths 50% <-> 66% within container
hs.hotkey.bind(hyper, "left",   function()
  local win = hs.window.focusedWindow(); if not win then return end
  local max = win:screen():frame()
  local rect = layoutFrame(max, CONTAINER_W, CONTAINER_H, "center")
  toggleWidthInRect("left", rect)
end)
hs.hotkey.bind(hyper, "right",  function()
  local win = hs.window.focusedWindow(); if not win then return end
  local max = win:screen():frame()
  local rect = layoutFrame(max, CONTAINER_W, CONTAINER_H, "center")
  toggleWidthInRect("right", rect)
end)
hs.hotkey.bind(hyper, "a",      function() place("tl")     end) -- top-left quadrant
hs.hotkey.bind(hyper, "s",      function() place("tr")     end) -- top-right quadrant
hs.hotkey.bind(hyper, "z",      function() place("bl")     end) -- bottom-left quadrant
hs.hotkey.bind(hyper, "x",      function() place("br")     end) -- bottom-right quadrant

-- Full-screen grid equivalents on ctrl+option (no container; uses full screen)
local hyperFull = {"ctrl", "alt"}
hs.hotkey.bind(hyperFull, "return", function() place("center", 1.0, 1.0) end) -- full screen center op
-- ctrl+alt + left/right: cycle widths 50% <-> 66% (full height)
hs.hotkey.bind(hyperFull, "left",   function() toggleWidth("left",  1.0) end)
hs.hotkey.bind(hyperFull, "right",  function() toggleWidth("right", 1.0) end)
hs.hotkey.bind(hyperFull, "a",      function() place("tl",     1.0, 1.0) end) -- top-left quadrant
hs.hotkey.bind(hyperFull, "s",      function() place("tr",     1.0, 1.0) end) -- top-right quadrant
hs.hotkey.bind(hyperFull, "z",      function() place("bl",     1.0, 1.0) end) -- bottom-left quadrant
hs.hotkey.bind(hyperFull, "x",      function() place("br",     1.0, 1.0) end) -- bottom-right quadrant

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
