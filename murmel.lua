Murmel = Object.extend(Object)

function Murmel.new(self, x, y, color)
	self.color = color
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
