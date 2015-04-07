class New::GitTask < New::Task
  @@description = 'Create a new version tag and push code to git'
  @@options = {
    :remotes => {
      :description => 'Any array of objects with repo/branch combinations to push to',
      :type => Array,
      :validation => [:repo, :branch],
      :default => [
        {
          :repo => 'origin',
          :branch => 'master'
        }
      ]
    }
  }

  def verify
    unless run_command 'git --version'
      raise S.ay 'Git is not installed', :error
    end

    # check options
    @options[:task_options][:remotes].each do |remote|
      if !remote[:repo] || remote[:repo].empty? || !remote[:branch] || remote[:branch].empty?
        raise S.ay "Git: Your remote must have a repo (#{remote[:repo]}) and branch (#{remote[:branch]}) defined. ", :error
      end
    end

    # check git status
    git_status = `git status`
    if !git_status.include? 'On branch master'
      raise S.ay 'Git: You must release from the master branch. Run `git checkout master`', :error
    elsif !git_status.include? 'Your branch is up-to-date with'
      raise S.ay 'Git: You must be up to date with your remote branch. Run `git pull`', :error
    elsif !git_status.include? 'nothing to commit, working directory clean'
      raise S.ay 'Git: Stash or commit your changes. Working directory must be clean', :error
    end
  end

  def run
    git_local
    git_remote
  end

private

  # commits any changes to the repo made from other tasks
  #
  def git_local
    S.ay 'Preparing local git repo:', :highlight_key

    # add all changes from other tasks
    run_command 'git add -A'

    # create new commit with new version and changelog
    run_command "git commit -m $'#{commit_message}'"

    # create a new tag for the version
    run_command "git tag #{@options[:version]}"

    S.ay 'OK', :highlight_value
  end

  def git_remote
    @options[:task_options][:remotes].each do |remote|
      S.ay "Pushing to `#{remote[:repo].green}/#{remote[:branch].green}`:", :highlight_key

      # push tag to remote
      run_command "git push #{remote[:repo]} #{@options[:version]}"

      # push to specified branch
      run_command "git push #{remote[:repo]} #{remote[:branch]}"

      S.ay 'OK', :highlight_value
    end
  end

  def commit_message
    messages_string = @options[:version].dup.to_s
    messages_string << "\n"

    # add bulleted list of changelog entries
    messages_string << @options[:changelog].map{ |e| "* #{e}" }.join("\n")
    messages_string << "\n"
  end
end
