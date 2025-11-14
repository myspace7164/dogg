Brett = Object.extend(Object)

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local xc = 0.5 * screenWidth
local yc = 0.5 * screenHeight
local a = 0.25 * screenWidth
local b = 0.25 * screenHeight

local function segment_to_xy(scale, rad)
	return xc + scale * a * math.cos(math.rad(rad)), yc + scale * b * math.sin(math.rad(rad))
end

function Brett.new(self)
	self.spielfelder = {}
	self.radius = 10
	self.segments = 100

	local segments = {
		{scale = 1.0, rad = 0 * 90 / 8},
		{scale = 1.0, rad = 1 * 90 / 8},
		{scale = 1.0, rad = 2 * 90 / 8},
		{scale = 1.2, rad = 2 * 90 / 8},
		{scale = 1.4, rad = 2 * 90 / 8},
		{scale = 1.6, rad = 2 * 90 / 8},
		{scale = 1.8, rad = 2 * 90 / 8},
		{scale = 1.8, rad = 3 * 90 / 8},
		{scale = 1.8, rad = 4 * 90 / 8},
		{scale = 1.8, rad = 5 * 90 / 8},
		{scale = 1.8, rad = 6 * 90 / 8},
		{scale = 1.6, rad = 6 * 90 / 8},
		{scale = 1.4, rad = 6 * 90 / 8},
		{scale = 1.2, rad = 6 * 90 / 8},
		{scale = 1.0, rad = 6 * 90 / 8},
		{scale = 1.0, rad = 7 * 90 / 8},
	}
	local segments_xy = {}
	for i_segment, segment in ipairs(segments) do
		local x
		local y
		x, y = segment_to_xy(segment.scale, segment.rad)

		local color = {1, 1, 1}
		table.insert(self.spielfelder, {color = color, x = x, y = y})

		if i_segment == 7 then
			color = {1, 0, 0}
		end
		x, y = segment_to_xy(segment.scale, segment.rad + 90)
		table.insert(self.spielfelder, {color = color, x = x, y = y})

		if i_segment == 7 then
			color = {0, 1, 0}
		end
		x, y = segment_to_xy(segment.scale, segment.rad + 180)
		table.insert(self.spielfelder, {color = color, x = x, y = y})

		if i_segment == 7 then
			color = {0, 0, 1}
		end
		x, y = segment_to_xy(segment.scale, segment.rad + 270)
		table.insert(self.spielfelder, {color = color, x = x, y = y})
	end
end

function Brett.draw(self)
	for _, spielfeld in ipairs(self.spielfelder) do
		love.graphics.setColor(spielfeld.color)
		love.graphics.circle("line", spielfeld.x, spielfeld.y, self.radius, self.segments)
	end 
end
