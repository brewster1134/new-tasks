require 'new'
require_relative 'gem_task'

describe New::GemTask do
  before do
    allow_any_instance_of(New::GemTask).to receive(:push_gem)
    allow_any_instance_of(New::GemTask).to receive(:cleanup)

    @pwd = Dir.pwd
    FileUtils.chdir root('tmp')

    @gem = New::GemTask.new('gem', @pwd)
    @gem.run({
      :name => 'Name',
      :version => '1.2.3',
      :task_options => {
        :summary => 'Summary',
        :files => ['*'],
        :authors => ['Author'],
        :gemspec => {}
      }
    })
  end

  after do
    allow_any_instance_of(New::GemTask).to receive(:push_gem).and_call_original
    allow_any_instance_of(New::GemTask).to receive(:cleanup).and_call_original

    FileUtils.chdir @pwd
  end

  it 'should build glob attributes' do
    expect(@gem.instance_var(:gemspec)[:files]).to be_an Array
    expect(@gem.instance_var(:gemspec)[:files]).to_not including('spec')
  end

  it 'should write a gemspec string' do
    expect(@gem.instance_var(:gemspec_string)).to include('s.files = [')
    expect(@gem.instance_var(:gemspec_string)).to include("s.summary = 'Summary'")
  end

  it 'should create a .gemspec file' do
    expect(File.read(root('tmp', '.gemspec'))).to include(@gem.instance_var(:gemspec_string))
  end
end
