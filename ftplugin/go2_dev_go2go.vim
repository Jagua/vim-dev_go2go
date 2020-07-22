if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1


runtime! ftplugin/go.vim


setlocal noexpandtab tabstop=4 shiftwidth=0


let s:base_dirpath = has('win32')
      \ ? expand('$LOCALAPPDATA/vim-dev_go2go')
      \ : isdirectory($XDG_DATA_HOME)
      \ ? expand('$XDG_DATA_HOME/vim-dev_go2go')
      \ : expand('$HOME/.local/share/vim-dev_go2go')

let s:go2go_filepath = printf('%s/bin/go2go', s:base_dirpath)

let b:quickrun_config = {
      \ 'command' : s:go2go_filepath,
      \ 'exec' : '%c run %s:p:t %a',
      \ 'tempfile': '%{tempname()}.go2',
      \ 'hook/cd/directory': '%S:p:h',
      \}
