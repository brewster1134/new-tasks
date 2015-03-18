require 'new'
require_relative 'changelog_task'

describe New::ChangelogTask do
  before do
    @pwd = Dir.pwd
    @gem = New::ChangelogTask.new('gem', @pwd)

    FileUtils.chdir root('tmp')

    # run twice to create 2 versions in the changelog
    @gem.options = {
      :name => 'Name',
      :version => '1.2.3',
      :task_options => {
        :file_name => 'CHANGELOG.md'
      },
      :changelog => [
        'Foo 1',
        'Bar 1'
      ]
    }
    @gem.run

    @gem.options = {
      :name => 'Name',
      :version => '1.2.4',
      :task_options => {
        :file_name => 'CHANGELOG.md'
      },
      :changelog => [
        'Foo 2',
        'Bar 2'
      ]
    }
    @gem.run
  end

  after do
    FileUtils.rm root('tmp', 'CHANGELOG.md')
  end

  it 'should prepend versions to a changelog' do
    expect(File.read(root('tmp', 'CHANGELOG.md'))).to eq "###### 1.2.4\n* Foo 2\n* Bar 2\n\n###### 1.2.3\n* Foo 1\n* Bar 1\n\n"
  end
end
