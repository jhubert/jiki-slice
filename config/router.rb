Merb::Router.prepare do
  match(%r[/revert/([^\.]+)]).to(:controller => 'wiki', :action => 'revert', :path => '[1]')
  match(%r[/save/([^\.]+)]).to(:controller => 'wiki', :action => 'save', :path => '[1]')
  match(%r[/edit/([^\.]+)]).to(:controller => 'wiki', :action => 'edit', :path => '[1]')
  match(%r[/([^\.]+)]).to(:controller => 'wiki', :action => 'index', :path => '[1]')
  match('/').to(:controller => 'wiki', :action => 'index', :path => 'index')
end