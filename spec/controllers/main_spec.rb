require File.dirname(__FILE__) + '/../spec_helper'

describe "Wiki::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { add_slice(:Wiki) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(Wiki::Main, :index)
    controller.slice.should == Wiki
    controller.slice.should == Wiki::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(Wiki::Main, :index)
    controller.status.should == 200
    controller.body.should contain('Wiki')
  end
  
  it "should work with the default route" do
    controller = get("/wiki/main/index")
    controller.should be_kind_of(Wiki::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/wiki/index.html")
    controller.should be_kind_of(Wiki::Main)
    controller.action_name.should == 'index'
  end
    
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(Wiki::Main, 'index')
    
    url = controller.url(:wiki_default, :controller => 'main', :action => 'show', :format => 'html')
    url.should == "/wiki/main/show.html"
    controller.slice_url(:controller => 'main', :action => 'show', :format => 'html').should == url
    
    url = controller.url(:wiki_index, :format => 'html')
    url.should == "/wiki/index.html"
    controller.slice_url(:index, :format => 'html').should == url
    
    url = controller.url(:wiki_home)
    url.should == "/wiki/"
    controller.slice_url(:home).should == url
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(Wiki::Main, :index)
    controller.public_path_for(:image).should == "/slices/wiki/images"
    controller.public_path_for(:javascript).should == "/slices/wiki/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/wiki/stylesheets"
    
    controller.image_path.should == "/slices/wiki/images"
    controller.javascript_path.should == "/slices/wiki/javascripts"
    controller.stylesheet_path.should == "/slices/wiki/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    Wiki::Main._template_root.should == Wiki.dir_for(:view)
    Wiki::Main._template_root.should == Wiki::Application._template_root
  end

end