require 'new'
require_relative 'git_task'

describe New::GitTask do
  before do
    @gem = New::GitTask.new 'github', Dir.pwd

    @gem.options = {
      :name => 'Name',
      :version => '1.2.3',
      :changelog => [
        'foo',
        'bar'
      ],
      :task_options => {
        :remotes => [
          {
            :repo => 'origin',
            :branch => 'master'
          },
          {
            :repo => 'origin2',
            :branch => 'master2'
          },
        ]
      }
    }
  end

  describe '#commit_message' do
    it 'should contain the version and changelog' do
      expect(@gem.send(:commit_message)).to eq "1.2.3\n* foo\n* bar\n"
    end
  end
end
