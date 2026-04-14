local logger = require("logger")

Object = require "classic"
Cards = Object.extend(Object)
Card = Object.extend(Object)

function Card.new(self, suit, rank)
  self.suit = suit
  self.rank = rank

  self.width = 20
  self.height = 50

  self.transform = { x = 0, y = 0 }
  self.target_transform = { x = 0, y = 0 }
  self.velocity = { x = 0, y = 0 }
  self.home = { x = 0, y = 0 }

  self.going_home = false
  self.lazy = true
end

function Card.put(self, x, y)
  self.transform.x = x
  self.transform.y = y
  self.target_transform.x = x
  self.target_transform.y = y
  self.home.x = x
  self.home.y = y
end

function Card.inRegion(self, x, y)
  if (self.transform.x <= x and x <= self.transform.x + self.width) and (self.transform.y <= y and y <= self.transform.y + self.height) then
    return true
  else
    return false
  end
end

local suit_color = {
  { 1,   0,   0 },
  { 0,   0,   0 },
  { 1,   0,   0 },
  { 0,   0,   0 },
  { 0.5, 0.5, 0.5 },
}
local suit_text = { "D", "C", "H", "S", "J" }
local suit_symbol = { "♦️", "♣️", "♥️", "♠️", "🃏" }
local rank_text = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "" }

function Card.draw(self)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", self.transform.x, self.transform.y, self.width, self.height, 5, 5, 10)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line", self.transform.x, self.transform.y, self.width, self.height, 5, 5, 10)
  love.graphics.setColor(suit_color[self.suit])
  love.graphics.print(suit_text[self.suit], self.transform.x + 3, self.transform.y)
  love.graphics.print(rank_text[self.rank], self.transform.x + 3, self.transform.y + 10)
end

function Card.log(self)
  return suit_symbol[self.suit] .. rank_text[self.rank]
end

function Cards.logStack(self)
  local msg = ""
  for i, card in ipairs(self.stack) do
    msg = msg .. card:log()
    if i ~= #self.stack then
      msg = msg .. ", "
    end
  end
  logger:debug("%s", msg)
end

function Cards.new(self)
  self.stack = {}

  -- 2x52 cards
  for _ = 1, 2 do
    for suit = 1, 4 do
      for rank = 1, 13 do
        table.insert(self.stack, Card(suit, rank))
      end
    end
  end

  -- jokers
  table.insert(self.stack, Card(5, 14))
  table.insert(self.stack, Card(5, 14))
  table.insert(self.stack, Card(5, 14))

  self:logStack()
end

function Cards.layoutGrid(self)
  logger:info("Applying grid layout")

  local ncol = 22
  local x, y

  for i, card in ipairs(self.stack) do
    x = 2 + math.fmod(i - 1, ncol) * 22
    y = 2 + math.floor(i / ncol) * 52
    card:put(x, y)

    logger:debug("grid-layout: stack[%d]: " .. card:log() .. " -> x = %d, y = %d", i, x, y)
  end
end

-- using fisher–yates shuffle algorithm
function Cards.shuffle(self)
  logger:info("Shuffeling cards")
  local j, x, y
  for i = #self.stack, 2, -1 do
    j = math.random(1, i)
    self.stack[i], self.stack[j] = self.stack[j], self.stack[i]

    x = self.stack[i].transform.x
    y = self.stack[i].transform.y
    self.stack[i]:put(self.stack[j].transform.x, self.stack[j].transform.y)
    self.stack[j]:put(x, y)
  end
  self:logStack()
end

function Card.drag(self, mouse_x, mouse_y)
  self.target_transform.x = mouse_x - self.width / 2
  self.target_transform.y = mouse_y - self.height / 2
end
