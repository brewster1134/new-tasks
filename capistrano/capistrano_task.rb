class New::CapistranoTask < New::Task
  @@description = 'Deploy with Capistrano'
  @@options = {
    :environment => {
      :required => true
    }
  }

  def run options
    system "bundle exec cap #{options[:task_options][:environment]} deploy"
  end
end
