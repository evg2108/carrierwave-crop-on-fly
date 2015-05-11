$:.push File.expand_path('../lib', __FILE__)

require 'carrierwave/crop/version'

Gem::Specification.new do |s|
  s.name          = 'carrierwave-crop-on-fly'
  s.version       = CarrierWave::Crop::VERSION
  s.authors       = %w(evg2108)
  s.email         = %w(evg2108@yandex.ru)
  s.homepage      = 'https://github.com/evg2108/carrierwave-crop-on-fly'
  s.summary       = %q{CarrierWave extension for on fly specifying crop area with preview and cropping images before they saved.}
  s.description   = %q{CarrierWave extension for on fly specifying crop area with preview and cropping images before they saved.}
  s.license       = 'MIT'

  s.files        = Dir['{app,lib,vendor,assets}/**/*', 'MIT-LICENSE', 'README.md']
  s.require_paths = %w(lib)

  s.add_dependency 'rails', '>= 3.2'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'carrierwave', '>= 0.8.0'
end