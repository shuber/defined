# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'defined/version'
require 'date'

Gem::Specification.new do |s|
  s.name     = 'defined'
  s.version  = Defined::Version.string
  s.date     = Date.today
  s.platform = Gem::Platform::RUBY

  s.summary     = 'Calls Module#defined whenever a class or module is (re)defined'
  s.description = 'Calls Module#defined whenever a class or module is defined or redefined'

  s.author   = 'Sean Huber'
  s.email    = 'shuber@huberry.com'
  s.homepage = 'http://github.com/shuber/defined'

  s.has_rdoc     = true
  s.rdoc_options = ['--line-numbers', '--inline-source', '--main', 'README.rdoc']

  s.require_paths = ['lib']

  s.files      = Dir['{bin,lib}/**/*'] + %w(MIT-LICENSE Rakefile README.rdoc)
  s.test_files = Dir['test/**/*']
end