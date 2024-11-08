local data_buffer = require "core:data_buffer"
local image = require "libpng:image"

require "libpng:png/decode/png"

local png_reader = { }

function png_reader.read_from_file_to_image(path)
	return png_reader.read_from_buffer_to_image(data_buffer(file.read_bytes(path)))
end

function png_reader.read_from_buffer_to_image(buffer)
	local width, height, pixels = png_reader.read_from_buffer(buffer)

	return image:new(width, height, pixels)
end

function png_reader.read_from_file(path)
	return png_reader.read_from_buffer(data_buffer(file.read_bytes(path)))
end

function png_reader.read_from_buffer(buffer)
	local str = ""

	local bytes = buffer:get_bytes()

	for i = 1, #bytes do
		str = str..string.char(bytes[i])
	end

	local img = pngImage(str)

	local width = img.width
	local height = img.height
	local pixels = { }

	local pixel

	for y = 1, height do
		for x = 1, width do
			pixel = img:getPixel(x, y)

			pixels[x+(y-1)*width] = { pixel.R, pixel.G, pixel.B, pixel.A }
		end
	end

	return width, height, pixels
end

return png_reader