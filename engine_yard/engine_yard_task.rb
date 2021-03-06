class New::EngineYardTask < New::Task
  @@description = 'Deploy your Engine Yard application'
  @@options = {
    :account => {
      :description => 'Name of the account in which the application and environment can be found',
      :required => true
    },
    :app => {
      :description => 'The application to deploy',
      :required => true
    },
    :environment => {
      :description => 'The environment to which you want this application to deploy',
      :required => true
    }
  }

  def verify
    unless run_command 'ey -v'
      raise S.ay 'Engine Yard gem is not installed. Run `gem install engineyard`', :error
    end
  end

  def run
    run_command "ey deploy --account='#{@options[:task_options][:account]}' --app='#{@options[:task_options][:app]}' --environment='#{@options[:task_options][:environment]}'"
  end
end
