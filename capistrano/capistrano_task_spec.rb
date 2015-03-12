require 'new'
require_relative 'capistrano_task'

describe New::CapistranoTask do
  before do
    @gem = New::CapistranoTask.new 'capistrano', Dir.pwd
    @gem.run({
      :name => 'Name',
      :version => '1.2.3',
      :task_options => {
        :capistrano => {
          :name => 'Bower Name'
        }
      }
    })
  end
end
