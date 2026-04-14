-- TODO Implement cards
--
local logger = require("logger")

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
logger:info("screenWidth=%d, screenHeight=%d", screenWidth, screenHeight)

local n_players         = 4
local murmeln           = {}
local cards             = {}
local board             = {}
local players           = {}
local colors            = {
  { 1, 0, 0 }, -- red
  { 0, 0, 1 }, -- blue
  { 0, 1, 0 }, -- green
  { 1, 1, 1 }  -- white
}
local active_player     = 1
local object_dragging   = {}
local object_going_home = {}

function love.load()
  logger:debug("love.load")

  require "board"
  board = Board()

  require "marble"

  -- TODO make player init dynamic
  require "players"
  players = Players(4)

  -- Player 1
  table.insert(murmeln, Murmel(0.5 * screenWidth + -1 * 25, screenHeight - 15, colors[1], board.spielfelder))
  table.insert(murmeln, Murmel(0.5 * screenWidth + -2 * 25, screenHeight - 15, colors[1], board.spielfelder))
  table.insert(murmeln, Murmel(0.5 * screenWidth + -3 * 25, screenHeight - 15, colors[1], board.spielfelder))
  table.insert(murmeln, Murmel(0.5 * screenWidth + -4 * 25, screenHeight - 15, colors[1], board.spielfelder))

  -- Player 2
  table.insert(murmeln, Murmel(0.5 * screenWidth + 0 * 25, 15, colors[2], board.spielfelder))
  table.insert(murmeln, Murmel(0.5 * screenWidth + 1 * 25, 15, colors[2], board.spielfelder))
  table.insert(murmeln, Murmel(0.5 * screenWidth + 2 * 25, 15, colors[2], board.spielfelder))
  table.insert(murmeln, Murmel(0.5 * screenWidth + 3 * 25, 15, colors[2], board.spielfelder))

  -- Player 3
  table.insert(murmeln, Murmel(15, 0.5 * screenHeight - 1 * 25, colors[3], board.spielfelder))
  table.insert(murmeln, Murmel(15, 0.5 * screenHeight - 2 * 25, colors[3], board.spielfelder))
  table.insert(murmeln, Murmel(15, 0.5 * screenHeight - 3 * 25, colors[3], board.spielfelder))
  table.insert(murmeln, Murmel(15, 0.5 * screenHeight - 4 * 25, colors[3], board.spielfelder))

  -- Player 4
  table.insert(murmeln, Murmel(screenWidth - 15, 0.5 * screenHeight + 0 * 25, colors[4], board.spielfelder))
  table.insert(murmeln, Murmel(screenWidth - 15, 0.5 * screenHeight + 1 * 25, colors[4], board.spielfelder))
  table.insert(murmeln, Murmel(screenWidth - 15, 0.5 * screenHeight + 2 * 25, colors[4], board.spielfelder))
  table.insert(murmeln, Murmel(screenWidth - 15, 0.5 * screenHeight + 3 * 25, colors[4], board.spielfelder))

  murmeln[4].pulsating = true

  require "cards"

  cards = Cards()

  -- three time's the charm
  cards:shuffle()
  cards:shuffle()
  cards:shuffle()

  cards:layoutGrid()

  -- würfel
end

function love.update(dt)
  for _, murmel in ipairs(murmeln) do
    if murmel.pulsating then
      pulse(murmel, dt)
    end
  end

  if next(object_dragging) ~= nil then
    if object_dragging.dragging then
      object_dragging:drag(love.mouse.getX(), love.mouse.getY())
    elseif object_dragging.going_home then
      go_home(object_dragging)
    end
    move(object_dragging, dt)
  end
end

function go_home(object)
  object.target_transform.x = object.home.x
  object.target_transform.y = object.home.y
  if math.abs(object.transform.x - object.home.x) < 3 and math.abs(object.transform.y - object.home.y) < 3 then
    object.going_home = false
    object.transform.x = object.home.x
    object.transform.y = object.home.y
  end
end

function pulse(obj, dt)
  local velocity = 5
  if obj.pulse_radius >= obj.max_pulse_radius then
    obj.pulse_direction = -1
  elseif obj.pulse_radius <= obj.radius then
    obj.pulse_direction = 1
  end
  obj.pulse_radius = obj.pulse_radius + obj.pulse_direction * velocity * dt
end

function move(obj, dt)
  local momentum = 0.75
  local max_velocity = 10
  if (obj.target_transform.x ~= obj.transform.x or obj.velocity.x ~= 0) or
      (obj.target_transform.y ~= obj.transform.y or obj.velocity.y ~= 0) then
    obj.velocity.x = momentum * obj.velocity.x +
        (1 - momentum) * (obj.target_transform.x - obj.transform.x) * 30 * dt
    obj.velocity.y = momentum * obj.velocity.y +
        (1 - momentum) * (obj.target_transform.y - obj.transform.y) * 30 * dt
    obj.transform.x = obj.transform.x + obj.velocity.x
    obj.transform.y = obj.transform.y + obj.velocity.y

    local velocity = math.sqrt(obj.velocity.x ^ 2 + obj.velocity.y ^ 2)
    if velocity > max_velocity then
      obj.velocity.x = max_velocity * obj.velocity.x / velocity
      obj.velocity.y = max_velocity * obj.velocity.y / velocity
    end
  end
end

function love.draw()
  board:draw()

  for _, murmel in ipairs(murmeln) do
    murmel:draw()
  end

  for _, card in ipairs(cards.stack) do
    card:draw()
  end

  local x = screenWidth - (screenWidth / 10)
  local y = screenHeight - (screenHeight / 20)
  local w = screenWidth / 10
  local h = screenHeight / 20

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", x, y, w, h, 5, 5, 10)
  love.graphics.setColor({ 0, 0, 0 })
  love.graphics.print("Reset grid", x, y)

  x = screenWidth - (2 * screenWidth / 10)

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", x, y, w, h, 5, 5, 10)
  love.graphics.setColor({ 0, 0, 0 })
  love.graphics.print("Shuffle", x, y)
end

function love.mousepressed(x, y)
  if x > screenWidth - (screenWidth / 10) and y > screenHeight - (screenHeight / 20) then
    cards:layoutGrid()
    return
  end

  if x > screenWidth - (2 * screenWidth / 10) and y > screenHeight - (screenHeight / 20) then
    cards:shuffle()
    return
  end

  for _, murmel in ipairs(murmeln) do
    if murmel:in_region(x, y) then
      object_dragging = murmel
      object_dragging.dragging = true
      return
    end
  end

  for _, karte in ipairs(cards.stack) do
    if karte:inRegion(x, y) then
      object_dragging = karte
      object_dragging.dragging = true
      return
    end
  end
end

function love.mousereleased()
  if next(object_dragging) ~= nil then
    object_dragging.dragging = false
    object_dragging.going_home = true
    if object_dragging.lazy then
      object_dragging.velocity = { x = 0, y = 0 }
      object_dragging.home = object_dragging.transform
    end
  end
end
