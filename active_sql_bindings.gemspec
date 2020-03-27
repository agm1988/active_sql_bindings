# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name          = 'active_sql_bindings'
  s.version       = '0.0.5'
  s.date          = '2020-03-27'
  s.summary       = 'Active SQL bindings gem'
  s.description   = 'You can use native PostgreSQL query with named bindings'
  s.authors       = ['Danilevsky Kirill']
  s.email         = 'k.danilevsky@gmail.com'
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.files         = %w[lib/active_sql_bindings.rb]
  s.required_ruby_version = '>= 2.5.0'
  s.homepage      = 'https://github.com/kirill-dan/active_sql_bindings'
  s.license       = 'MIT'
  s.add_development_dependency 'minitest', '~> 5.13.0'
  s.add_development_dependency 'sqlite3', '~> 1.4.1'
  s.add_runtime_dependency 'activerecord', '~> 6.0.2'
end
