# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'napster/version'

Gem::Specification.new do |spec|
  spec.name = 'napster'
  spec.version = Napster::VERSION
  spec.authors = ['Jason Kim']
  spec.email = ['jasonkim@rhapsody.com']

  spec.summary = 'A Ruby interface to the Napster API.'
  spec.description = 'A Ruby interface to the Napster API.'
  spec.homepage = 'https://developer.napster.com/'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to ' \
          'protect against public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) do |f|
    File.basename(f)
  end
  spec.require_paths = ['lib']

  spec.add_dependency('faraday', '~> 0.9.2')
  spec.add_dependency('oj', '~> 3.3.9')

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'capybara', '~> 2.6'
  spec.add_development_dependency 'poltergeist', '~> 1.9'
  spec.add_development_dependency 'rubocop', '~> 0.49.0'
  spec.add_development_dependency 'faker', '~> 1.6'
  spec.add_development_dependency 'yard', '~> 0.9.12'
end
