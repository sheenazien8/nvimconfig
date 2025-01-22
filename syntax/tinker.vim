" Vim syntax file
" Language: Tinker
" Filename extension: .tinker
" Maintainer: [Your Name]
" Last Change: [Current Date]

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" Allow use of line continuation
let s:cpo_save = &cpoptions
set cpoptions&vim

" Syntax definitions based on the provided CSS-like color scheme
" Define keywords, strings, comments, etc. with similar color mapping

" Strings
syn region tinkerString start=+"+ end=+"+ contains=tinkerEscape
syn region tinkerString start=+'+ end=+'+ contains=tinkerEscape
syn match tinkerEscape "\\." contained

" Numbers
syn match tinkerNumber "\<\d\+\>"
syn match tinkerNumber "\<\d\+\.\d\+\>"

" Comments
syn region tinkerComment start="//" end="$" contains=tinkerTodo
syn region tinkerComment start="/\*" end="\*/" contains=tinkerTodo

" Keywords with color mapping similar to the CSS
syn keyword tinkerKeyword private protected public class interface
syn keyword tinkerType int string float bool array object
syn keyword tinkerConstant true false null
syn keyword tinkerTodo contained TODO FIXME NOTE

" Namespaces and references
syn match tinkerNamespace "\(\k\+\.\)\+"
syn match tinkerReference "&\k\+"

" Highlighting groups
hi def link tinkerString String
hi def link tinkerNumber Number
hi def link tinkerComment Comment
hi def link tinkerKeyword Keyword
hi def link tinkerType Type
hi def link tinkerConstant Constant
hi def link tinkerTodo Todo
hi def link tinkerNamespace Identifier
hi def link tinkerReference Special
hi def link tinkerEscape Special

" Custom colors inspired by the provided CSS
hi String ctermfg=Green guifg=#629755
hi Keyword ctermfg=DarkRed guifg=#CC7832
hi Type ctermfg=Black guifg=#262626
hi Comment ctermfg=Blue guifg=#6897BB
hi Identifier ctermfg=DarkGreen guifg=#789339
hi Special ctermfg=DarkGray guifg=#6E6E6E

let b:current_syntax = "tinker"

let &cpoptions = s:cpo_save
unlet s:cpo_save

" Place this file in ~/.config/nvim/syntax/tinker.vim
" And add the following to your ~/.config/nvim/ftdetect/tinker.vim:
" augroup filetypedetect
"   au BufRead,BufNewFile *.tinker setfiletype tinker
" augroup END
