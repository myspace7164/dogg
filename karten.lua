Object = require "classic"
Karten = Object.extend(Object)
Karte = Object.extend(Object)
color = { kreuz = { 0, 0, 0 }, schaufel = { 0, 0, 0 }, herz = { 1, 0, 0 }, ecke = { 1, 0, 0 } }

function Karte.new(self, farbe, wert)
	self.farbe = farbe
	self.wert = wert
	self.width = 20
	self.height = 50
	self.transform = {
		x = 0,
		y = 0,
	}
	self.target_transform = {
		x = 0,
		y = 0,
	}
	self.velocity = {
		x = 0,
		y = 0,
	}
	self.home = {
		x = 0,
		y = 0,
	}
	self.going_home = false
end

function Karte.in_region(self, x, y)
	if (self.transform.x <= x and x <= self.transform.x + self.width) and (self.transform.y <= y and y <= self.transform.y + self.height) then
		return true
	else
		return false
	end
end

function Karte.draw(self)
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", self.transform.x, self.transform.y, self.width, self.height, 5, 5, 10)
	love.graphics.setColor(color[self.farbe])
	love.graphics.print(string.sub(self.farbe, 1, 1), self.transform.x, self.transform.y)
	love.graphics.print(self.wert, self.transform.x, self.transform.y + 10)
end

function Karten.new(self)
	self.karten = {}
	local farben = { "kreuz", "schaufel", "herz", "ecke" }
	local werte = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 }

	for _, farbe in ipairs(farben) do
		for _, wert in ipairs(werte) do
			table.insert(self.karten, Karte(farbe, wert))
		end
	end
	-- TODO jokers
	-- TODO 2nd set of cards

	shuffle(self.karten)
end

-- Uses the Fisher–Yates shuffle algorithm
function shuffle(karten)
	for i_karte = #karten, 2, -1 do
		local j_karte = math.random(1, i_karte)
		karten[i_karte], karten[j_karte] = karten[j_karte], karten[i_karte]
	end
end

function Karte.drag(self, mouse_x, mouse_y)
	self.target_transform.x = mouse_x - self.width / 2
	self.target_transform.y = mouse_y - self.height / 2
end
