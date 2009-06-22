syntax on

map <F4> :Ex<cr>
map! ii <Esc>

vmap <F4> <esc>:Ex<cr>i
imap <F4> <esc>:Ex<cr>i

set wildmenu
set wcm=<Tab>
menu Encoding.utf-8 :e ++enc=utf8 <CR>
menu Encoding.windows-1251 :e ++enc=cp1251<CR>
menu Encoding.koi8-r :e ++enc=koi8-r<CR>
menu Encoding.cp866 :e ++enc=cp866<CR>
map <F6> :emenu Encoding.<TAB>

" " убираем режим замены
imap >Ins> <Esc>i

" " Редко когда надо [ без пары =)
"imap [ []<LEFT>
" " Аналогично и для {
"imap {<CR> {<CR>}<Esc>O

" " Автозавершение слов по tab =)
function InsertTabWrapper()
let col = col('.') - 1
if !col || getline('.')[col - 1] !~ '\k'
 return "\<tab>"
   else
    return "\<c-p>"
endif
endfunction
imap <tab> <c-r>=InsertTabWrapper()<cr>
" Слова откуда будем завершать
set complete=""
" Из текущего буфера
set complete+=.
" " Из словаря
set complete+=k
" " Из других открытых буферов
set complete+=b
" " из тегов 
set complete+=t

"поиск и замена слова под курсором
nmap ; :%s/\<<c-r>=expand("<cword>")<cr>\>/
" highlight trailing spaces
au BufNewFile,BufRead * let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)
" highlight tabs between spaces
au BufNewFile,BufRead * let b:mtabbeforesp=matchadd('ErrorMsg', '\v(\t+)\ze( +)', -1)
au BufNewFile,BufRead * let b:mtabaftersp=matchadd('ErrorMsg', '\v( +)\zs(\t+)', -1)
"folding comments
set fdm=expr
set fde=getline(v:lnum)=~'^\\s*#'?1:getline(prevnonblank(v:lnum))=~'^\\s*#'?1:getline(nextnonblank(v:lnum))=~'^\\s*#'?1:0
