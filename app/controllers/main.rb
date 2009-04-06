require 'RedCloth'

class JikiSlice::Main < JikiSlice::Application
  VERSION_REGEX = /_v[1-9][0-9]*/
  before :setup

  def index
    if File.exist?(@wiki_file)
      @timestamp = File.stat(@wiki_file).mtime
      render RedCloth.new(File.read(@wiki_file)).gsub(/\[\[(.*?)\]\]/) { |u| y = $1.clone; "<a href=\"/wiki/#{$1.gsub(/[^\w\d\-\s]/,'').gsub(/\s/,'-')}\">#{y}</a>" }.to_html
    else
      return redirect page_url(:show,params[:path].sub(VERSION_REGEX,'')) if is_version? && is_latest?
      raise 'That version does not exist' if is_version?
      render "#{params[:path]} does not exist: <a href=\"#{page_url(:edit,params[:path])}\">Create</a>?"
    end
  end

  def edit
    raise 'You can not edit a version backup' unless is_latest?
    render File.exist?(@wiki_file) ? File.read(@wiki_file).strip : ''
  end

  def save
    raise 'You can not edit a version backup' unless is_latest?
    if content = params['content']
      dir = File.dirname(@wiki_file)
      FileUtils.mkdir_p(dir)
      backup_wiki_file
      File.open(@wiki_file, 'w') do |file|
        file.write(content)
        file.write("\n")
      end
    end
    redirect page_url(:show,params[:path])
  end

  def revert
    revert_to = @wiki_file.sub('.wiki',"_v#{params[:version]}.wiki")
    if File.exist?(revert_to)
      backup_wiki_file
      FileUtils.cp(revert_to,@wiki_file)
    else
      raise 'Unable to find that version of the file'
    end
    redirect page_url(:show,params[:path])
  end

  private

  def setup
    @path = params[:path]
    @latest_path = params[:path].sub(VERSION_REGEX,'')
    @wiki_file = "#{Merb.root}/data/#{@path}.wiki"
    @current_version = current_version
    @latest_version = latest_version
  end

  def is_latest?
    @current_version == @latest_version
  end

  def is_version?
    @path != @latest_path
  end

  def backup_wiki_file
    FileUtils.mv(@wiki_file,@wiki_file.sub('.wiki',"_v#{latest_version}.wiki")) if File.exist?(@wiki_file)
  end

  def current_version
    v = params[:path].scan(/_v([1-9][0-9]*)/)
    v = [latest_version] if v.blank?
    v.flatten.first.to_i
  end

  def latest_version
    x = 1
    x += 1 while(File.exist?(@wiki_file.sub(VERSION_REGEX,'').sub('.wiki',"_v#{x}.wiki")))
    x
  end

end