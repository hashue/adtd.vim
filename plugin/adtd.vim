if exists('g:loaded_adtd')
  finish
endif
let g:loaded_adtd = 1
command! -nargs=0 Tsl call adtd#getAllTask('list') 
command! -nargs=0 Tsad  call adtd#addTask()
command  -nargs=0 Tsdel call adtd#getAllTask('delete')
