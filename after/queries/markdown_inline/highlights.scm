; extends

; Captures the literal @ token that precedes a file mention.
; Full @filename highlighting is handled by lua/custom/at-file-highlight.lua
; which uses the markdown parse tree to skip code blocks before applying extmarks.
("@" @at_file.marker)
