local data_buffer = require "core:data_buffer"

local image = { }
local textureId = 0

local function inBounds(self, x, y)
	return (x >= 0 and x <= self.width) and (y >= 0 and y <= self.height)
end

local function ensureInBounds(self, x, y)
	if not inBounds(self, x, y) then
		if not self.outOfBoundsError then return end

		error "coords out of bounds"
	end

	return true
end

local function plotLineLow(self, x0, y0, x1, y1, r, g, b, a)
    local dx = x1 - x0
    local dy = y1 - y0
    local yi = 1

    if dy < 0 then
        yi = -1
        dy = -dy
    end

    local D = (2 * dy) - dx
    local y = y0

    for x = x0, x1 do
        self:set(x, y, r, g, b, a)

        if D > 0 then
            y = y + yi
            D = D + (2 * (dy - dx))
        else
            D = D + 2*dy
        end
    end
end

local function plotLineHigh(self, x0, y0, x1, y1, r, g, b, a)
    local dx = x1 - x0
    local dy = y1 - y0
    local xi = 1

    if dx < 0 then
        xi = -1
        dx = -dx
    end

    local D = (2 * dx) - dy
    local x = x0

    for y = y0, y1 do
        self:set(x, y, r, g, b, a)

        if D > 0 then
            x = x + xi
            D = D + (2 * (dx - dy))
        else
            D = D + 2*dx
        end
    end
end

function image:place(img, srcX, srcY, lenX, lenY, destX, destY)
	for y = 0, lenY do
		for x = 0, lenX do
			local r, g, b, a = img:get(srcX + x, srcY + y)

			self:set(x + destX, y + destY, r, g, b, a)
		end
	end
end

function image:line(x1, y1, x2, y2, r, g, b, a)
    if math.abs(y2 - y1) < math.abs(x2 - x1) then
        if x1 > x2 then
            plotLineLow(self, x2, y2, x1, y1, r, g, b, a)
        else
            plotLineLow(self, x1, y1, x2, y2, r, g, b, a)
        end
    else
        if y1 > y2 then
            plotLineHigh(self, x2, y2, x1, y1, r, g, b, a)
        else
            plotLineHigh(self, x1, y1, x2, y2, r, g, b, a)
        end
    end
end

function image:fill(x1, y1, x2, y2, r, g, b, a)
	local tmp

	if y1 > y2 then
		tmp = y2
		y2 = y1
		y1 = tmp
	end

	if x1 > x2 then
		tmp = x2
		x2 = x1
		x1 = tmp
	end

	for y = y1, y2 do
		for x = x1, x2 do
			self:set(x, y, r, g, b, a)
		end
	end
end

function image:set_all(r, g, b, a)
	for i = 1, #self.pixels do
		self.pixels[i] = { r or 0, g or 0, b or 0, a or 0xFF}
	end
end

function image:set(x, y, r, g, b, a)
	if ensureInBounds(self, x, y) then
		self.pixels[x+1+y*self.width] = { r or 0, g or 0, b or 0, a or 0xFF }
	end
end

function image:get(x, y)
	if ensureInBounds(self, x, y) then
		local pixel = self.pixels[x+1+y*self.width]

		return pixel[1], pixel[2], pixel[3], pixel[4]
	end
end

function image:load(id)
	local buffer = data_buffer()

	require("libpng:png/png_writer").write_image_to_buffer(self, buffer)

	if not id then
		if not self.textureId then
			self.textureId = "libpng:runtime_"..textureId

			textureId = textureId + 1
		end

		id = self.textureId
	end

	assets.load_texture(buffer:get_bytes(), id)

	return id
end

function image:to_png(path)
	require("libpng:png/png_writer").write_image_to_file(self, path)
end

function image.from_png(path)
	return require("libpng:png/png_reader").read_from_file_to_image(path)
end

function image:to_buffer_as_png(buffer)
	if not buffer then buffer = data_buffer() end

	require("libpng:png/png_writer").write_image_to_buffer(self, buffer)

	return buffer
end

function image.from_png_buffer(buffer)
	return require("libpng:png/png_reader").read_from_buffer_to_image(buffer)
end

function image:new(width, height, pixels)
    local obj = {
        width = width,
        height = height,
        pixels = pixels,
        outOfBoundsError = false
    }

    if not pixels then
	    obj.pixels = { }

	    for i = 1, width * height do
	    	obj.pixels[i] = { 0, 0, 0, 0 }
	    end
	end

    self.__index = self
    setmetatable(obj, self)

    return obj
end

return image