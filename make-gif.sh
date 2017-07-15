ffmpeg -i Today_at_Wimbledon_2017_-_8._Day_8_Highlights_b08y32z0_original.mp4 -ss 00:58:08 -to 00:58:36 cut.mp4
ffmpeg -i cut.mp4 -ss 00:00:03 -to 00:00:05 cut-short.mp4
ffmpeg -y -i cut-short.mp4 -vf fps=10,scale=320:-1:flags=lanczos,palettegen palette_short_320.png
ffmpeg -i cut-short.mp4 -i palette_short_320.png -filter_complex "fps=10,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" poncho_short_320.gif

