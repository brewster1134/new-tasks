class New::GithubTask < New::Task
  @@description = 'Create a new version tag and push code to Github'
  @@options = {
    :remote => {
      :default => 'origin'
    },
    :branch => {
      :default => 'master'
    }
  }

  def verify
    # make sure git is installed
    `git --version`
    unless $?.success?
      raise S.ay('Git is not installed', :fail)
    end

    # check git status
    git_status = `git status`
    if !git_status.include? 'On branch master'
      raise S.ay('Git: You must release from the master branch. Run `git checkout master`', :fail)
    elsif !git_status.include? 'Your branch is up-to-date with'
      raise S.ay('Git: You must be up to date with your remote branch. Run `git pull`', :fail)
    elsif !git_status.include? 'nothing to commit, working directory clean'
      raise S.ay('Git: Stash or commit your changes. Working directory must be clean', :fail)
    end
  end

  def run
    commit_changes
  end

private

  # commits any changes to the repo made from other tasks
  #
  def commit_changes
    # add all changes from other tasks
    system "git add -A #{SILENCE}"

    # create new commit with new version and changelog
    system "git commit -m $'#{commit_message}' #{SILENCE}"

    # create a new tag for the version
    system "git tag #{@options[:version]} #{SILENCE}"

    # push the code to the tag and the remote branch
    system "git push #{@options[:task_options][:remote]} #{@options[:version]} #{SILENCE}"
    system "git push #{@options[:task_options][:remote]} #{@options[:task_options][:branch]} #{SILENCE}"
  end

  def commit_message
    messages_string = @options[:version].dup.to_s
    messages_string << "\n"

    # add bulleted list of changelog entries
    messages_string << @options[:changelog].map{ |e| "* #{e}" }.join("\n")
    messages_string << "\n"
  end
end
