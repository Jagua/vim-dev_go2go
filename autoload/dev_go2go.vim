let s:save_cpoptions = &cpoptions
set cpoptions&vim


let s:root_path = expand('<sfile>:p:h:h')


function dev_go2go#install() abort
  let l:ext = has('win32') ? 'cmd' : 'sh'
  let l:installer_path = printf('%s/dev_go2go_installer/dev_go2go.%s', s:root_path, l:ext)
  let l:cmd = [l:installer_path, 'all']
  let l:res = term_start(l:cmd)
endfunction


let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
