vim -c 'set shortmess=at' +PlugInstall! +qall

# change vim-buffergator keymap for opening from viewport
 modify the file ~/.vim/plugged/vim-buffergator/autoload/buffergator.vim
 /Selection: show target and switch focus

# default
noremap <buffer> <silent> o           :<C-U>call b:buffergator_catalog_viewer.visit_target(!g:buffergator_autodismiss_on_select, 0, "")<CR>
noremap <buffer> <silent> O           :<C-U>call b:buffergator_catalog_viewer.visit_target(1, 1, "")<CR>

# change to
noremap <buffer> <silent> O           :<C-U>call b:buffergator_catalog_viewer.visit_target(!g:buffergator_autodismiss_on_select, 0, "")<CR>
noremap <buffer> <silent> o           :<C-U>call b:buffergator_catalog_viewer.visit_target(1, 1, "")<CR>
