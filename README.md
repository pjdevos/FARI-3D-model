# FARI Experience Hub – 3D model

A browser model of the FARI AI Experience Center in Brussels (FARI – AI for the Common Good Institute, ULB/VUB):
the double-height atrium with its galleries and arch wall, the entrance porch, the red staircase, Meeting room 1,
meeting room "Annemie" and the FARI office. Look around in **Orbit** mode or walk through it at eye height in **Walk**
mode. It is a sketch built from a floor plan and photos, not a survey: the first floor (3.36 m, 21 stair risers of
16 cm) is counted on site, most other dimensions are estimated.

Everything is in one file, `index.html`, using [three.js](https://threejs.org/) 0.160.0 from the jsDelivr CDN.

## Running it

Browsers do not allow a page opened straight from disk (`file://`) to put separate image files on 3D screens, so
the photos on the screens stay empty that way. Either:

- **Serve the folder** over http and open `http://localhost:8317/`. On Windows, without Python or Node:
  `powershell -ExecutionPolicy Bypass -File .claude/serve.ps1` (any static web server works too); or
- **Build a single file** with the photos embedded, which works when opened from disk:
  `powershell -ExecutionPolicy Bypass -File .claude/export.ps1` writes `FARI Experience Hub - <date>.html`.

Published with GitHub Pages it works as is.

## Controls

- **Orbit:** drag to orbit, scroll or pinch to zoom, right-drag or two-finger drag to pan.
- **Walk:** drag to look, `W A S D`, `Z Q S D` or the arrow keys to walk, `Shift` to run, `Esc` to leave; on a touch
  screen, a stick. Take the red stair to the first floor.
- Click a photo on a screen to see it large with its caption. Click Carl's knee scooter (or press `E` next to it)
  to ride it. It does not do stairs.

## Photos on the screens

Every screen in the model is a numbered photo frame. To put a photo on screen *n*, add it to `assets/screens/` and
add an entry to `SCREEN_PHOTOS` in `index.html`:

```js
{ screen: 7, src: 'assets/screens/photo.jpg', caption: 'Caption exactly as supplied', alt: 'What the photo shows' },
```

## Code notes

- Plan coordinates in metres: the inner entrance door is at z = 0, the atrium runs towards −z, +x is on your right
  as you walk in, and the two street facades fan out at ±19.5°. `onR(t, n)` and `onL(t, n)` give a point t metres
  along a facade and n metres in from the glass.
- The red stair niche is built in its own frame and turned parallel to the left facade (`NT`, `NI`, `inNiche`).
- Walking uses simple collision data: `colSeg`/`colBox` for walls and furniture, `SURF` for everything you can
  stand on.
