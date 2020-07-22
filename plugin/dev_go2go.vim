if exists('g:loaded_dev_go2go')
  finish
endif
let g:loaded_dev_go2go = 1


let s:save_cpoptions = &cpoptions
set cpoptions&vim


command! -nargs=0 DevGo2GoInstall call dev_go2go#install()


let s:base_dirpath = has('win32')
      \ ? expand('$LOCALAPPDATA/vim-dev_go2go')
      \ : isdirectory($XDG_DATA_HOME)
      \ ? expand('$XDG_DATA_HOME/vim-dev_go2go')
      \ : expand('$HOME/.local/share/vim-dev_go2go')

let s:gopls_filepath = printf('%s/bin/gopls', s:base_dirpath)

if executable(s:gopls_filepath)
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'gopls_dev_go2go',
        \ 'cmd': {server_info -> [s:gopls_filepath]},
        \ 'whitelist': ['go2'],
        \ })
endif


let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
