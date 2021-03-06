require 'bundler'

class New::GemTask < New::Task
  @@description = 'Publish gem to rubygems'
  @@options = {
    :name => {
      :description => 'A unique gem name to publish to RubyGems'
    },
    :summary => {
      :description => "A short summary of this gem's description",
      :required => true
    },
    :files => {
      :description => 'Unix globs of files to include in the gem',
      :type => Array,
      :default => ['**/*','**/.*']
    },
    :authors => {
      :description => 'Author names',
      :type => Array,
      :required => true
    },
    :gemspec => {
      :description => 'An object with any additional supported gemspec attributes (guides.rubygems.org/specification-reference)',
      :type => Hash,
      :default => {}
    }
  }

  def verify
    unless run_command 'gem -v'
      raise S.ay 'RubyGems is not installed. Make sure you can run `gem -v`', :error
    end
  end

  def run
    @gemspec_string = ''
    @dependencies = {
      :runtime => {},
      :development => {}
    }

    build_attributes
    build_glob_attributes
    build_dependency_attributes

    validate_gemspec

    build_gemspec_string
    write_gemspec
    push_gem
    cleanup
  end

private

  def build_attributes
    @gemspec = @options[:task_options].delete(:gemspec)
    @gemspec[:name] = @options[:task_options][:name] || @options[:name]
    @gemspec[:version] = @options[:version]
    @gemspec[:date] = Date.today.to_s
    @gemspec[:summary] = @options[:task_options].delete(:summary)
    @gemspec[:files] = @options[:task_options].delete(:files)
    @gemspec[:authors] = @options[:task_options].delete(:authors)
  end

  # Build glob-based attributes into file lists
  #
  def build_glob_attributes
    # set array of gemspec attributes that expect glob patterns
    glob_attributes = [:files, :extra_rdoc_files]

    # if any glob attributes are defined, convert the globs to a file list
    (glob_attributes & @gemspec.keys).each do |glob_option|
      glob_array = []
      @gemspec[glob_option].each do |glob|
        glob_array += Dir[glob]
      end

      # only include files
      @gemspec[glob_option] = glob_array.select{ |f| File.file?(f) }
    end
  end

  # Extract dependencies based on the Gemfile to be used in the gemspec
  #
  def build_dependency_attributes
    gemfile = File.join(Dir.pwd, 'Gemfile')
    return unless File.file? gemfile

    bundler = Bundler::Dsl.new
    bundler.eval_gemfile gemfile

    # loop through the required gems and find default and development gems
    bundler.dependencies.each do |gem|
      if gem.groups.include? :default
        @dependencies[:runtime][gem.name] = gem.requirements_list.first
      else
        @dependencies[:development][gem.name] = gem.requirements_list.first
      end
    end
  end

  # validate required attributes to build a gem are set
  #
  def validate_gemspec
    unless @gemspec[:summary]
      S.ay "Value for `summary` is missing. Make sure to set `tasks > gem > summary` in your project's Newfile", :error
      exit
    end

    unless @gemspec[:author] || @gemspec[:authors]
      S.ay "Value for `author`/`authors` is missing. Make sure to set `tasks > gem > authors` in your project's Newfile'", :error
      exit
    end
  end

  def build_gemspec_string
    @gemspec.each do |key, val|
      val = "'#{val}'" if val.is_a? String
      @gemspec_string << "  s.#{key} = #{val}\n"
    end

    @dependencies[:runtime].each do |key, val|
      @gemspec_string << "  s.add_runtime_dependency '#{key}', '#{val}'\n"
    end

    @dependencies[:development].each do |key, val|
      @gemspec_string << "  s.add_development_dependency '#{key}', '#{val}'\n"
    end
  end

  # create a .gemspec file and save it to the project root
  #
  def write_gemspec
    gemspec = File.join(Dir.pwd, '.gemspec')

    File.open gemspec, 'w+' do |f|
      f.write "# coding: utf-8\n"
      f.write "Gem::Specification.new do |s|\n"
      f.write @gemspec_string
      f.write "end\n"
    end
  end

  # push gem to rubygems
  #
  def push_gem
    run_command 'gem build .gemspec'
    run_command "gem push #{@gemspec[:name]}-#{@gemspec[:version]}.gem"
  end

  def cleanup
    FileUtils.rm "#{@gemspec[:name]}-#{@gemspec[:version]}.gem"
  end
end
