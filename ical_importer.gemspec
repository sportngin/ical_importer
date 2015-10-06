# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ical_importer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jon Phenow"]
  gem.email         = ["jon.phenow@sportngin.com"]
  gem.description   = %q{Easily import iCal Events from a URL and handle their output}
  gem.summary       = %q{Uses RiCal to make a much simpler Event Importing interface.}
  gem.homepage      = "http://github.com/sportngin/ical_importer"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "ical_importer"
  gem.license       = "MIT"
  gem.require_paths = ["lib"]
  gem.version       = IcalImporter::VERSION

  gem.add_dependency 'activesupport', ['> 3.0.0', '< 4.0.0']
  gem.add_dependency 'ri_cal', '~> 0.8'
  gem.add_dependency 'i18n', '~> 0.6'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.11'
  gem.add_development_dependency 'awesome_print', '~> 1.0'
end
