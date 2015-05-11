module CarrierWave
  module Crop
    module ExtensionCropData
      extend ActiveSupport::Concern

      included do
        before :cache, :remember_crop_data

        attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
      end

      private

      def remember_crop_data(file)
        self.crop_x = file.file.crop_x
        self.crop_y = file.file.crop_y
        self.crop_w = file.file.crop_w
        self.crop_h = file.file.crop_h
      end

    end
  end
end

if defined? CarrierWave::Uploader::Base
  CarrierWave::Uploader::Base.class_eval do
    include ::CarrierWave::Crop::ExtensionCropData
  end
end