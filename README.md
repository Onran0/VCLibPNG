# VCLibPNG

![VCLibPNG](libpng/icon.png)

This content pack for [Voxel Core](https://github.com/MihailRis/VoxelEngine-Cpp) provides functionality for loading and saving **PNG** images, and also provides basic functionality for working with raster images

# Installation
Just install the latest release as a regular content pack

# Examples
```lua
local image = require "libpng:image"

local img = image.from_png("base:icon.png")

img:set_all(0xFF, 0, 0xFF)

img:fill(0, 0, 10, 5, 0, 0xFF, 0xFF, 0x32)

img:to_png("export:test.png")

local id = img:load()
```

# Documentation
[RU](docs/ru/dev)

# Libraries used
[lua-pngencoder](https://github.com/wyozi/lua-pngencoder) - for exporting to uncompressed **PNG** images  
[pngLua](https://github.com/DelusionalLogic/pngLua) - to read **PNG** images
