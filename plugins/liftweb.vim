" liftweb.vim - Detect a liftweb application
" Author:       Antonio Salazar Carodozo <savedfastcool+vim@gmail.com>,
" GetLatestVimScripts: 1567 1 :AutoInstall: liftweb.vim
" URL:          http://shadowfiend.posterous.com/

" Install this file as plugin/liftweb.vim. 

" ============================================================================

if !exists("g:SetupScala")
  runtime! autoload/liftweb.vim

  call g:SetupLiftweb()
  autocmd BufNewFile,BufRead * call g:UpdateLiftwebPackagePrefix()
endif


