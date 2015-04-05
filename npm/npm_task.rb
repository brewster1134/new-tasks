require 'json'

class New::NpmTask < New::Task
  @@description = 'Publish npm package'
  @@options = {
    :packagejson => {
      :description => 'An object with any additional supported package.json attributes (docs.npmjs.com/files/package.json)',
      :type => Hash,
      :default => {}
    }
  }

  def verify
    unless run_command 'npm -v'
      raise S.ay 'npm is not installed. Make sure you can run `npm -v`', :error
    end
  end

  def run
    @packagejson_string = ''
    @dependencies = {
      :runtime => {},
      :development => {}
    }

    build_attributes
    write_packagejson
    push_package
  end

private

  def build_attributes
    @packagejson = @options[:task_options].delete(:packagejson)
    @packagejson[:name] = @options[:task_options][:name] || @options[:name]
    @packagejson[:version] = @options[:version]
  end

  # create a .packagejson file and save it to the project root
  #
  def write_packagejson
    packagejson = File.join(Dir.pwd, 'package.json')

    File.open packagejson, 'w+' do |f|
      JSON.pretty_generate @packagejson
    end
  end

  # push npm to rubynpms
  #
  def push_package
    run_command 'npm publish ./'
  end
end
