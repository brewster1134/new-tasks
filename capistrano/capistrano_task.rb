class New::CapistranoTask < New::Task
  @@description = 'Deploy with Capistrano'
  @@options = {
    :environment => {
      :description => 'Name of the environment you want to deploy to',
      :required => true
    }
  }

  def verify
    unless run_command 'cap -v'
      raise S.ay 'Capistrano is not installed. Run `gem install capistrano`', :error
    end

    # make sure capistrano files exist
    unless
        File.exist?(File.join(Dir.pwd, 'Capfile')) &&
        File.exist?(File.join(Dir.pwd, 'config', 'deploy')) &&
        File.exist?(File.join(Dir.pwd, 'config', 'deploy', "#{@options[:task_options][:environment]}"))
      raise S.ay 'Project is not setup to use Capistrano. Run `bundle exec cap install`', :error
    end
  end

  def run
    # if bundler is installed, use it
    command = run_command('bundle -v') ? 'bundle exec ' : ''
    command += "#{@options[:task_options][:environment]} deploy"
    run_command command
  end
end
