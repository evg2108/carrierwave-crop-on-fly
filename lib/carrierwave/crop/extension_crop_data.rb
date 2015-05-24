if defined? CarrierWave::Uploader::Base
  class CarrierWave::Uploader::Base

    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

    alias_method :old_cache!, :cache!

    def cache!(file)
      if file.is_a?(ActionDispatch::Http::UploadedFile)
        self.crop_x = file.crop_x
        self.crop_y = file.crop_y
        self.crop_w = file.crop_w
        self.crop_h = file.crop_h
      end

      old_cache!(file)
    end
  end
end