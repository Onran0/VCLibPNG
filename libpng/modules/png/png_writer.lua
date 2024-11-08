local data_buffer = require "core:data_buffer"

local png_encoder = require "libpng:png/encode/png_encoder"

local alphaChannel = true
local colorModel = "rgba"

local png_writer = { }

function png_writer.write_to_file(width, height, pixels, path)
	local buffer = data_buffer()

	png_writer.write_to_buffer(width, height, pixels, buffer)

	file.write_bytes(path, buffer:get_bytes())
end

function png_writer.write_image_to_file(image, path)
	png_writer.write_to_file(image.width, image.height, image.pixels, path)
end

function png_writer.write_image_to_buffer(image, buffer)
	png_writer.write_to_buffer(image.width, image.height, image.pixels, buffer)
end

function png_writer.write_to_buffer(width, height, pixels, buffer)
	local png = png_encoder(width, height, colorModel)

	local pixel

	for i = 1, width * height do
		pixel = pixels[i]

		if alphaChannel then
			png:write(pixel)
		else
			png:write({ pixel[1], pixel[2], pixel[3] })
		end
	end

	assert(png.done)

	local data = table.concat(png.output)

	for i = 1, #data do
		buffer:put_byte(string.byte(data:sub(i, i)))
	end
end

return png_writer