require "voxdefs"("C:\\MyFiles\\Folders\\Voxel Engine\\game\\files\\v24-pr")

local image = require "libpng:image"

print("Reading templates")
local square_1 = image.from_png("libpng:square_1.png")
local square_2 = image.from_png("libpng:square_2.png")
local i = image:new(10, 10)

print("Editing")
i:place(square_1, 3, 3, 1, 1, 0, 0)
i:place(square_2, 0, 0, 4, 4, 5, 5)

print("Writing")
i:to_png("libpng:test.png")