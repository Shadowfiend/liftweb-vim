" liftweb.vim - functions
" Author:       Antonio Salazar Carodozo <savedfastcool+vim@gmail.com>,
" GetLatestVimScripts: 2962 1 :AutoInstall: liftweb.vim
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

let g:liftweb_enabled = 0

function! g:liftweb_OpenTypeInPackage(package, type)
  let s:fname = "src/main/scala/" . g:liftweb_packagePrefix . '/' . a:package . '/' .
              \ substitute(a:type, "\\.scala$", "", "") . '.scala'
  
  execute ":e " . escape(s:fname, " ")
endfunction

function! s:CommandForType(type)
  let s:upperType = substitute(a:type, ".*", "\\u\\0", "")

  execute ':command -nargs=1 -complete=customlist,g:liftweb_Complete' . s:upperType . ' '
            \ 'L'. a:type . ' call g:liftweb_OpenTypeInPackage("' . escape(a:type, '"') . '", <f-args>)'
endfunction

function! g:liftweb_CompleteModel(ArgLead, CmdLine, CursorPos)
  return s:CompleteType("model", ["Model"], a:ArgLead)
endfunction

function! g:liftweb_CompleteSnippet(ArgLead, CmdLine, CursorPos)
  return s:CompleteType("snippet", ["Snip", "Snippet"], a:ArgLead)
endfunction

function! g:liftweb_CompleteActor(ArgLead, CmdLine, CursorPos)
  return s:CompleteType("actor", ["Actor"], a:ArgLead)
endfunction

function! g:liftweb_CompleteComet(ArgLead, CmdLine, CursorPos)
  return s:CompleteType("comet", ["Comet"], a:ArgLead)
endfunction

function! s:CompleteType(type, suffixes, toComplete)
  if (!g:liftweb_enabled)
    return
  endif

  if match(a:toComplete, ".*\\..*$") != -1
    let s:ending = substitute(a:toComplete, ".*\\(\\..*$\\)", "\\1", "")
  else
    let s:ending = ""
  end
  let s:endinglessComplete = substitute(a:toComplete, s:ending . "$", "", "")
  let s:completionTarget = s:endinglessComplete . "*.scala"

  let s:prefix = 'src/main/scala/' . g:liftweb_packagePrefix . '/' . a:type . '/**/'
  let s:completions = split(glob(s:prefix . s:completionTarget), "\n")
  for suffix in a:suffixes
    let s:completions +=  split(glob(s:prefix . s:endinglessComplete . suffix . "*.scala"), "\n")
  endfor

  let s:completions = map(s:completions, 'substitute(v:val, "src/main/scala/' . g:liftweb_packagePrefix . '/' . a:type . '/", "", "")')

  return s:completions
endfunction

function! s:OpenView(viewName)
  if (!g:liftweb_enabled)
    return
  endif

  let s:viewName = substitute(a:viewName, "\\.html$", "", "") . ".html"
  let s:view = glob('src/main/webapp/' . s:viewName)
  if !strlen(s:view)
    let s:viewList = split(glob('src/main/webapp/**/' . s:viewName), "\n")

    if empty(s:viewList)
      return
    else
      let s:view = s:viewList[0]
    endif
  endif

  execute ":edit " . escape(s:view, " ")
endfunction

function s:OpenTestForClass()
  if (!g:liftweb_enabled)
    return
  endif

  let s:classFile = expand('%')
  let s:testFile = substitute(substitute(s:classFile, "main", "test", ""),
                            \ "\\.scala", "Test.scala", "")

  execute ":edit " . escape(s:testFile, " ")
endfunction

function s:OpenClassForTest()
  if (!g:liftweb_enabled)
    return
  endif

  let s:testFile = expand('%')

  let s:classFile = substitute(substitute(s:testFile, "test", "main", ""),
                             \ "Test\\.scala", ".scala", "")

  execute ":edit " . escape(s:classFile, " ")
endfunction

function! s:CompleteView(ArgLead, CmdLine, CursorPos)
  if (!g:liftweb_enabled)
    return
  endif

  let s:isHtml = match(a:ArgLead, "\.html$") != -1

  if s:isHtml
    let s:views =  split(glob('src/main/webapp/**/' . a:ArgLead), "\n")
  else
    let s:views = split(glob('src/main/webapp/**/' . a:ArgLead . "*.html"), "\n")
  endif

  let s:views = map(s:views, 'substitute(v:val, "src/main/webapp/", "", "")')

  return s:views
endfunction

function! g:SetupLiftweb()
  if exists("g:liftweb_setup")
    return
  endif

  let g:liftweb_setup = 1

  command Lspec call s:OpenTestForClass()
  command Ltest Lspec
  command Lclass call s:OpenClassForTest()
  " command-completion-custom

  call s:CommandForType("model")
  call s:CommandForType("snippet")
  call s:CommandForType("actor")
  call s:CommandForType("comet")

  command -nargs=1 -complete=customlist,s:CompleteView Lview call s:OpenView(<f-args>)
endfunction

function! g:UpdateLiftwebPackagePrefix()
  let g:liftweb_enabled = 1

  let s:curFile = expand('%:p')
  if !isdirectory(s:curFile)
    let s:curFile = expand('%:p:h')
  endif

  if match(s:curFile, "src/main") != -1
    let g:liftweb_rootDir = substitute(s:curFile, "src/main.*$", "", "")
  elseif match(s:curFile, "src/test") != -1
    let g:liftweb_rootDir = substitute(s:curFile, "src/test.*$", "", "")
  elseif match(s:curFile, "src") != -1 && (isdirectory(s:curFile . "/main") || isdirectory(s:curFile . "/test"))
    let g:liftweb_rootDir = substitute(s:curFile, "src$", "", "")
  else
    let g:liftweb_rootDir = s:curFile

    if strlen(finddir("src/main/scala", g:liftweb_rootDir)) == 0
      let g:liftweb_enabled = 0
      return
    endif
  endif

  execute "cd " . escape(g:liftweb_rootDir, " ")
  let s:fullPath = finddir("snippet", g:liftweb_rootDir . "/src/main/scala/**")
  if strlen(s:fullPath) == 0
    let s:fullPath = finddir("comet", g:liftweb_rootDir . "/src/main/scala/**")
  endif
  if strlen(s:fullPath) == 0
    let s:fullPath = finddir("model", g:liftweb_rootDir . "/src/main/scala/**")
  endif

  if strlen(s:fullPath) == 0
    echo finddir("model", g:liftweb_rootDir . "/src/main/scala/**")
    let g:liftweb_enabled = 0
    return
  end

  let g:liftweb_packagePrefix = substitute(
      \ substitute(
                \ substitute(s:fullPath, g:liftweb_rootDir, "", ""),
                  \ "src/main/scala/", "", ""),
      \ "/[^/]*$", "", "")
endfunction
