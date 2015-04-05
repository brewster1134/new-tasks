class New::ChangelogTask < New::Task
  @@description = 'Maintain a markdown formatted CHANGELOG in the root of your project'
  @@options = {
    :file_name => {
      :description => 'Name of your changelog file',
      :default => 'CHANGELOG.md'
    }
  }

  def run
    changelog_file = File.join(Dir.pwd, @options[:task_options][:file_name])
    changelog_string = File.read(changelog_file) rescue ''

    # build new string
    new_changelog_string = "###### #{@options[:version]}\n"
    @options[:changelog].each do |log|
      new_changelog_string << "* #{log}\n"
    end

    # add previous changelog
    new_changelog_string << "\n"
    new_changelog_string << changelog_string

    # write new string
    File.open changelog_file, 'w+' do |f|
      f.write new_changelog_string
    end
  end
end
