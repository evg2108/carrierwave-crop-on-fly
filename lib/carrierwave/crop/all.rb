# encoding: utf-8

require 'carrierwave/crop/version'
require 'carrierwave/crop/error'

if defined? Rails
  require 'carrierwave/crop/engine'
  require 'carrierwave/crop/helpers'
  require 'carrierwave/crop/uploader_additions'
  require 'carrierwave/crop/uploaded_file_additions'
  require 'carrierwave/crop/extension_crop_data'
  require 'carrierwave/crop/railtie'
end
