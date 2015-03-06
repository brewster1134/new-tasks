class New::BowerTask < New::Task
  @@description = 'Register a Bower package'
  @@options = {
    :name => {
      :description => 'A unique name for the Bower registry (github.com/bower/bower.json-spec#name)',
      :required => true,
      :type => String,
      :validation => /[a-z0-9\-\.]/ # does not restrict ALL cases
    },
    :name => {
      :description => 'A unique name for the Bower registry (github.com/bower/bower.json-spec#name)',
      :required => true,
      :type => String,
      :validation => /[a-z0-9\-\.]/ # does not restrict ALL cases
    },
  }

  def run options
    # if package isnt already registered, register it
    unless package_registered? options.name
      `bower register #{options.name}`
    end
  end

private

  def package_registered? name
    `bower info #{name}`
    $?.success?
  end
end
