module CarrierWave
  module Crop
    module UploaderAdditions
      # Performs cropping.
      #
      #  Resizes the original image to 600x600 and then performs cropping
      #  process crop: [600, 600]
      def crop(width = nil, height = nil)
        if self.respond_to? "resize_to_limit"
          begin
            manipulate! do |img|
              if crop_w.present? && crop_h.present?
                w = crop_w
                h = crop_h
              else
                orig_w = img['width']
                orig_h = img['height']

                ratio = width.to_f / height
                orig_ratio = orig_w / orig_h

                w = h = [orig_w, orig_h].min
                if ratio < orig_ratio
                  w = orig_h * ratio
                elsif ratio > orig_ratio
                  h = orig_w * ratio
                end
              end

              if crop_x.blank? && crop_y.blank?
                img.combine_options do |op|
                  op.crop "#{w.to_i}x#{h.to_i}+0+0"
                  op.gravity 'Center'
                end
              else
                img.crop("#{w.to_i}x#{h.to_i}+#{crop_x.to_i}+#{crop_y.to_i}")
              end
              img.resize("#{width}x#{height}")
              img
            end

          rescue Exception => e
            raise CarrierWave::Crop::ProcessingError, "Failed to crop - #{e.message}"
          end

        else
          raise CarrierWave::Crop::MissingProcessorError, "Failed to crop #{attachment}. Add mini_magick."
        end
      end

      # Checks if the attachment received cropping attributes
      # @param  attachment [Symbol] Name of the attribute to be croppedv
      #
      # @return [Boolean]
      # def cropping?
      #   crop_x.present? && crop_y.present? && crop_w.present? && crop_h.present?
      # end

    end ## End of UploaderAdditions
  end ## End of Crop
end ## End of CarrierWave

if defined? CarrierWave::Uploader::Base
  CarrierWave::Uploader::Base.class_eval do
    include CarrierWave::Crop::UploaderAdditions
  end
end