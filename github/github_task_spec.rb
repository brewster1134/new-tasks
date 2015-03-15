require 'new'
require_relative 'github_task'

describe New::GithubTask do
  before do
    @gem = New::GithubTask.new 'github', Dir.pwd
    allow(@gem).to receive(:commit_changes)

    @gem.run({
      :name => 'Name',
      :version => '1.2.3',
      :changelog => [
        'foo',
        'bar'
      ],
      :task_options => {
        :github => {
          :remote => 'origin',
          :branch => 'master'
        }
      }
    })
  end

  describe '#commit_message' do
    it 'should contain the version and changelog' do
      expect(@gem.send(:commit_message)).to eq "1.2.3\n* foo\n* bar\n"
    end
  end
end
