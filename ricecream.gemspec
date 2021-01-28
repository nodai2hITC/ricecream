# frozen_string_literal: true

require_relative "lib/ricecream/version"

Gem::Specification.new do |spec|
  spec.name          = "ricecream"
  spec.version       = Ricecream::VERSION
  spec.authors       = ["nodai2hITC"]
  spec.email         = ["nodai2h.itc@gmail.com"]

  spec.summary       = "More useful debugging libraries than puts / p"
  spec.description   = "Never use puts/p to debug again! More useful debugging libraries than puts / p. (A Ruby port of Python's IceCream.)"
  spec.homepage      = "https://github.com/nodai2hITC/ricecream"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
#  spec.metadata["changelog_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
