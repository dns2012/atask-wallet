# frozen_string_literal: true

require_relative "lib/atask_stock/version"

Gem::Specification.new do |spec|
  spec.name = "atask_stock"
  spec.version = AtaskStock::VERSION
  spec.authors = ["DNS Progress"]
  spec.email = ["dnsprogress@gmail.com"]

  spec.summary = "Atask Stock Application Library"
  spec.description = "This is Atask Stock reusable library for rails to show indonesian stock list."
  spec.homepage = "https://github.com/dns2012/atask-wallet"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://github.com/dns2012/atask-wallet"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dns2012/atask-wallet/tree/main/api/lib/atask_stock"
  spec.metadata["changelog_uri"] = "https://github.com/dns2012/atask-wallet/tree/main/api/lib/atask_stock/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
