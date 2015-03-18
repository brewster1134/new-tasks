class New::CapistranoTask < New::Task
  @@description = 'Deploy with Capistrano'
  @@options = {
    :environment => {
      :required => true
    }
  }

  def verify
    # make sure capistrano is installed
    `cap -v`
    unless $?.success?
      raise S.ay('Capistrano is not installed. Run `gem install capistrano`', :fail)
    end

    # make sure capistrano files are found
    unless File.exist?(File.join(Dir.pwd, 'Capfile')) && File.exist?(File.join(Dir.pwd, 'config', 'deploy'))
      raise S.ay('Project is not setup to use Capistrano. Run `bundle exec cap install`', :fail)
    end
  end

  def run
    system "bundle exec cap #{@options[:task_options][:environment]} deploy"
  end
end
