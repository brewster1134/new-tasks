# Gem New Task

### Requirements
* [ruby gems](https://github.com/rubygems/rubygems)

### Options
* __`summary`__: A short summary of this gem's description
* __`authors`__: Author names
* `name`: A unique gem name to publish to RubyGems
* `files`: Unix globs of files to include in the gem
* `gemspec`: An object with any additional supported gemspec attributes

```yaml
tasks:
  gem:
    summary: My gem description
    name: Foo
    authors:
      - John Smith
    files:
      - '**/*'
    gemspec:
      license: MIT
```
