# Модуль libpng:image

## Описание

Данный модуль предоставляет базовый функционал для обработки растровых изображений. Он включает в себя функции для получения/установки определённых пикселей, заполнение определённой области на изображении указанным цветом, отрисовка линий на изображении, а также вставка других изображений.

## Функции

Создаёт пустое изображение, размерами **width x height**. Параметр **pixels** необязательный, должен быть одномерным массивом, в котором каждый элемент это массив с четырями элементам (**R, G, B, A**)
```lua
function image:new(width: integer, height: integer, pixels: table) -> image
```

Сохраняет изображение в несжатый **PNG** файл по указанному пути
```lua
function image:to_png(path: string)
```

Загружает изображение из **PNG** файла по указанному пути
```lua
function image.from_png(path: string)
```

Сохраняет изображение в несжатый **PNG** и сохраняет данные в буффер
```lua
function image:to_buffer_as_png(buffer: data_buffer)
```

Загружает изображение из буффера с **PNG** изображением
```lua
function image.from_png_buffer(buffer: data_buffer)
```

Возвращает **R, G, B, A** пикселя на указанных координатах
```lua
function image:get(x: integer, y: integer) -> integer, integer, integer, integer
```

Устанавливает **R, G, B, A** пикселя на указанных координатах
```lua
function image:set(x: integer, y: integer, r: integer, g: integer, b: integer, a: integer)
```

Устанавливает **R, G, B, A** всех пикселей в изображении на указанные
```lua
function image:set_all(r: integer, g: integer, b: integer, a: integer)
```

Заполняет прямоугольную область от **x1, y1** до **x2, y2** цветом **R, G, B, A**
```lua
function image:fill
(
	x1: integer, y1: integer,
	x2: integer, y2: integer,
	r: integer, g: integer, b: integer, a: integer
)
```

Рисует линию с цветом **R, G, B, A**, а точки линии - **x1, y1** и **x2, y2**
```lua
function image:line
(
	x1: integer, y1: integer,
	x2: integer, y2: integer,
	r: integer, g: integer, b: integer, a: integer
)
```

Размещает другое изображение на текущем

**img** - другое изображение  
**srcX, srcY** - смещение координат на другом изображении  
**lenX, lenY** - длина пикселей по **x** и **y**, отсчитываемая от **srcX, srcY**  
**destX, destY** - координаты, на которых итоговое изображение будет размещено на текущем  
```lua
function image:place
(
	img: image,
	srcX: integer, srcY: integer,
	lenX: integer, lenY: integer,
	destX: integer, destY: integer
)
```

## 0.24+

Загружает изображение в движок по указанному идентификатору **id**. Если идентификатор не указан, то возьмётся уникальный идентификатор для текущего изображения и функция его вернёт. Функция также может быть вызвана повторно, чтобы переопределить уже существующее изображение или загрузить изображение под другим идентификатором.
```lua
function image:load(id: string) -> string
```
