Karten = Object.extend(Object)
Karte = Object.extend(Object)
color = {kreuz = {0, 0, 0}, schaufel = {0, 0, 0}, herz = {1, 0, 0}, ecke = {1, 0 ,0}}

function Karte.new(self, farbe, wert)
	self.farbe = farbe
	self.wert = wert
	self.x = 0
	self.y = 0
end

function Karte.draw(self)
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", self.x, self.y, 20, 50, 5, 5, 10)
	love.graphics.setColor(color[self.farbe])
	love.graphics.print(string.sub(self.farbe, 1, 1), self.x, self.y)
	love.graphics.print(self.wert, self.x, self.y + 10)
end

function Karten.new(self)
	self.karten = {}
	local farben = {"kreuz", "schaufel", "herz", "ecke"}
	local werte = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}

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
