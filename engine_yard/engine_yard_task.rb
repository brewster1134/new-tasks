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
    # make sure engine yard tool is installed
    `ey -v`
    unless $?.success?
      raise S.ay('Engine Yard gem is not installed. Run `gem install engineyard`', :fail)
    end
  end

  def run
    system "ey deploy --account='#{@options[:task_options][:account]}' --app='#{@options[:task_options][:app]}' --environment='#{@options[:task_options][:environment]}'"
  end
end
