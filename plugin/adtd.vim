if exists('g:loaded_adtd')
  finish
endif
let g:loaded_adtd = 1
command! -nargs=0 Tsad call adtd#getAllTask() 
command! -nargs=0 Tsl  call adtd#addTask()
