# GEM TASK

###### gemspec attributes

You can add any of the supported gemspec attributes to your project's `.new` configuration file.

```yaml
tasks:
  gem:
    author: Brewster
    summary: My gem summary
    files:
      - 'lib/**/*.rb'
    test_files:
      - 'spec/**/*.rb'
```

A full list can be found here http://guides.rubygems.org/specification-reference

The following attributes are required

* author
* summary
* files

The following attributes expect arrays of unix glob patterns

* files
* test_files
* extra_rdoc_files

The following attributes are automatically set.

* name
* version
* date
