
function! s:stripslash(path)
    return fnamemodify(a:path, ':s?[/\\]$??')
endfunction

function! s:get_project_root(path) abort
    let l:path = s:stripslash(a:path)
    let l:previous_path = ""
    let l:markers = ['.git']
    while l:path != l:previous_path
        for root in l:markers
            if !empty(globpath(l:path, root, 1))
                let l:proj_dir = simplify(fnamemodify(l:path, ':p'))
                let l:proj_dir = s:stripslash(l:proj_dir)
                if l:proj_dir != ''
                    return l:proj_dir
	        endif
            endif
        endfor
        let l:previous_path = l:path
        let l:path = fnamemodify(l:path, ':h')
    endwhile
    return ''
endfunction


function! s:setup_autotab() abort
	if &buftype != ''
		return
	endif

	let b:project_root = s:get_project_root(expand('%:p:h', 1))
	if b:project_root == ''
		return
	endif
	if match(b:project_root, 'qemu') >= 0
		setlocal expandtab
		setlocal tabstop=4
		setlocal softtabstop=4
		setlocal shiftwidth=4
	endif
	if match(b:project_root, 'linux') >= 0
		setlocal noexpandtab
		setlocal tabstop=8
		setlocal softtabstop=8
		setlocal shiftwidth=8
	endif
	if match(b:project_root, 'cscope') >= 0
		setlocal noexpandtab
		setlocal tabstop=8
		setlocal softtabstop=4
		setlocal shiftwidth=4
	endif
endfunc


augroup autotab_detect
    autocmd!
    autocmd BufNewFile,BufReadPost,BufEnter *  call s:setup_autotab()
    autocmd VimEnter               *  if expand('<amatch>')==''|call s:setup_autotab()|endif
augroup end

