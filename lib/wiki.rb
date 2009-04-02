if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  require 'merb-slices'
  Merb::Plugins.add_rakefiles "wiki/merbtasks", "wiki/slicetasks", "wiki/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :wiki
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:wiki][:layout] ||= :wiki
  
  # All Slice code is expected to be namespaced inside a module
  module Wiki
    
    # Slice metadata
    self.description = "Wiki is a chunky Merb slice!"
    self.version = "0.0.1"
    self.author = "Engine Yard"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(Wiki)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :wiki_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      scope.match(%r[/wiki/revert/([^\.]+)]).to(:controller => 'main', :action => 'revert', :path => '[1]')
      scope.match(%r[/wiki/save/([^\.]+)]).to(:controller => 'main', :action => 'save', :path => '[1]')
      scope.match(%r[/wiki/edit/([^\.]+)]).to(:controller => 'main', :action => 'edit', :path => '[1]')
      scope.match(%r[/wiki/([^\.]+)]).to(:controller => 'main', :action => 'index', :path => '[1]')
      scope.match('/wiki').to(:controller => 'main', :action => 'index', :path => 'index')
    end
    
  end
  
  # Setup the slice layout for Wiki
  #
  # Use Wiki.push_path and Wiki.push_app_path
  # to set paths to wiki-level and app-level paths. Example:
  #
  # Wiki.push_path(:application, Wiki.root)
  # Wiki.push_app_path(:application, Merb.root / 'slices' / 'wiki')
  # ...
  #
  # Any component path that hasn't been set will default to Wiki.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  Wiki.setup_default_structure!
  
  # Add dependencies for other Wiki classes below. Example:
  # dependency "wiki/other"
  
end