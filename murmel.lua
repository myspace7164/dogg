Murmel = Object.extend(Object)

function Murmel.new(self, x, y, color, spielfelder)
	self.color = color
	self.spielfelder = spielfelder
	self.transform = {
		x = x,
		y = y
	}
	self.target_transform = {
		x = x,
		y = y
	}
	self.velocity = {
		x = 0,
		y = 0
	}
	self.home = {
		x = x,
		y = y
	}

	self.going_home = false

	self.radius = 10
	self.segments = 100
	self.dragging = false

	self.pulsating = false
	self.pulse_radius = self.radius
	self.max_pulse_radius = self.radius + 5
	self.pulse_direction = 1
end

function Murmel.draw(self)
	if self.pulsating then
		love.graphics.setColor(1, 1, 1)
		love.graphics.circle("fill", self.transform.x, self.transform.y, self.pulse_radius, self.segments)
	end
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.transform.x, self.transform.y, self.radius, self.segments)
end

function Murmel.in_region(self, x, y)
	if (x - self.transform.x) ^ 2 + (y - self.transform.y) ^ 2 <= self.radius ^ 2 then
		return true
	else
		return false
	end
end

function Murmel.drag(self, mouse_x, mouse_y)
	for _, spielfeld in ipairs(self.spielfelder) do
		if (spielfeld.x - mouse_x) ^ 2 + (spielfeld.y - mouse_y) ^ 2 <= (1.5 * self.radius) ^ 2 then
			self.target_transform.x = spielfeld.x
			self.target_transform.y = spielfeld.y
			break
		else
			self.target_transform.x = mouse_x
			self.target_transform.y = mouse_y
		end
	end
end
