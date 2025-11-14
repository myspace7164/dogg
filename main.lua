-- TODO Implement cards
-- TODO Implement board
-- TODO Implement players
--

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local n_players = 4
local murmeln = {}
local board = {}
local colors = {
	{1, 0, 0},
	{0, 0, 1},
	{0, 1, 0},
	{1, 1, 1}
}
active_player = 1

function love.load()
	Object = require "classic"
	require "brett"
	brett = Brett()

	require "murmel"

	-- Player 1
	table.insert(murmeln, Murmel(0.5 * screenWidth + -1 * 25, screenHeight - 15, colors[1]))
	table.insert(murmeln, Murmel(0.5 * screenWidth + -2 * 25, screenHeight - 15, colors[1]))
	table.insert(murmeln, Murmel(0.5 * screenWidth + -3 * 25, screenHeight - 15, colors[1]))
	table.insert(murmeln, Murmel(0.5 * screenWidth + -4 * 25, screenHeight - 15, colors[1]))

	-- Player 2
	table.insert(murmeln, Murmel(0.5 * screenWidth + 0 * 25, 15, colors[2]))
	table.insert(murmeln, Murmel(0.5 * screenWidth + 1 * 25, 15, colors[2]))
	table.insert(murmeln, Murmel(0.5 * screenWidth + 2 * 25, 15, colors[2]))
	table.insert(murmeln, Murmel(0.5 * screenWidth + 3 * 25, 15, colors[2]))

	-- Player 3
	table.insert(murmeln, Murmel(15, 0.5 * screenHeight - 1 * 25, colors[3]))
	table.insert(murmeln, Murmel(15, 0.5 * screenHeight - 2 * 25, colors[3]))
	table.insert(murmeln, Murmel(15, 0.5 * screenHeight - 3 * 25, colors[3]))
	table.insert(murmeln, Murmel(15, 0.5 * screenHeight - 4 * 25, colors[3]))

	-- Player 4
	table.insert(murmeln, Murmel(screenWidth - 15, 0.5 * screenHeight + 0 * 25, colors[4]))
	table.insert(murmeln, Murmel(screenWidth - 15, 0.5 * screenHeight + 1 * 25, colors[4]))
	table.insert(murmeln, Murmel(screenWidth - 15, 0.5 * screenHeight + 2 * 25, colors[4]))
	table.insert(murmeln, Murmel(screenWidth - 15, 0.5 * screenHeight + 3 * 25, colors[4]))

	murmeln[4].pulsating = true
	-- karten
	-- würfel
end

function love.update(dt)
	for _, murmel in ipairs(murmeln) do
		if murmel.pulsating then
			pulse(murmel, dt)
		end
		if murmel.dragging then
			local mouse_x = love.mouse.getX()
			local mouse_y = love.mouse.getY()
			for _, spielfeld in ipairs(brett.spielfelder) do
				if (spielfeld.x - mouse_x)^2 + (spielfeld.y - mouse_y)^2 <= (1.5 * murmel.radius)^2 then
					murmel.target_transform.x = spielfeld.x
					murmel.target_transform.y = spielfeld.y
					break
				else
					murmel.target_transform.x = mouse_x
					murmel.target_transform.y = mouse_y
				end
			end
		end
		if murmel.going_home then
			murmel.target_transform.x = murmel.home.x
			murmel.target_transform.y = murmel.home.y
			if math.abs(murmel.transform.x - murmel.home.x) < 3 and math.abs(murmel.transform.y - murmel.home.y) < 3 then
				murmel.going_home = false
				murmel.transform.x = murmel.home.x
				murmel.transform.y = murmel.home.y
			end
		end
		move(murmel, dt)
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
	brett:draw()
	for _, murmel in ipairs(murmeln) do
		murmel:draw()
	end
end

function love.mousepressed(x, y)
	for _, murmel in ipairs(murmeln) do
		if (x - murmel.transform.x)^2 + (y - murmel.transform.y)^2 <= murmel.radius^2 then
			murmel.dragging = true
		end
	end
end

function love.mousereleased()
	for _, murmel in ipairs(murmeln) do
		if murmel.dragging then
			murmel.dragging = false
			murmel.going_home = true
		end
	end
end
