" liftweb.vim - functions
" Author:       Antonio Salazar Carodozo <savedfastcool+vim@gmail.com>,
" GetLatestVimScripts: 1567 1 :AutoInstall: liftweb.vim
" URL:          http://shadowfiend.posterous.com/

" Install this file as autoload/liftweb.vim. 

" ============================================================================

" model, snippet, actor, comet
" view
" spec-class switching

if exists("g:liftweb_initialized")
  finish
else
  let g:liftweb_initialized = 1
endif

let g:liftweb_packagePrefix = "com/openstudy"

function! g:liftweb_OpenTypeInPackage(package, type)
  let s:fname = "src/main/scala/" . g:liftweb_packagePrefix . '/' . a:package . '/' . a:type . '.scala'
  
  execute ":e " . escape(s:fname, " ")
endfunction

function! s:CommandForType(type)
  execute ":command -nargs=1 L" . a:type . ' call g:liftweb_OpenTypeInPackage("' . escape(a:type, '"') . '", <f-args>)'
endfunction

function! s:OpenView(viewName)
  let s:view = glob('src/main/webapp/' . a:viewName)
  if !strlen(s:view)
    let s:viewList = split(glob('src/main/webapp/**/' . a:viewName), "\n")

    if empty(s:viewList)
      return
    else
      let s:view = s:viewList[0]
    endif
  endif

  execute ":edit " . escape(s:view, " ")
endfunction

function s:OpenTestForClass()
  let s:classFile = expand('%')
  let s:testFile = substitute(substitute(s:classFile, "main", "test", ""),
                            \ "\\.scala", "Test.scala", "")

  execute ":edit " . escape(s:testFile, " ")
endfunction

function s:OpenClassForTest()
  let s:testFile = expand('%')

  let s:classFile = substitute(substitute(s:testFile, "test", "main", ""),
                             \ "Test\\.scala", ".scala", "")

  execute ":edit " . escape(s:classFile, " ")
endfunction

function! g:SetupLiftweb()

  if exists("g:liftwebInitialized")
    return
  endif

  let g:liftwebInitialized = 1

  command Lspec call s:OpenTestForClass()
  command Ltest Lspec
  command Lclass call s:OpenClassForTest()
  " command-completion-custom

  call s:CommandForType("model")
  call s:CommandForType("snippet")
  call s:CommandForType("actor")
  call s:CommandForType("comet")

  command -nargs=1 Lview call s:OpenView(<f-args>)
endfunction

