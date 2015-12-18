module CarrierWave
  module Crop
    module UploaderAdditions
      # Performs cropping.
      #
      #  Resizes the original image to 600x600 and then performs cropping
      #  process crop: [600, 600]
      def crop(width = nil, height = nil)
        raise_missing_processor  unless defined?(CarrierWave::MiniMagick) || defined?(CarrierWave::RMagick)

        proc = ->(original_height, original_width) do
          if crop_w.present? && crop_h.present?
            w = crop_w
            h = crop_h
          else
            ratio = width.to_f / height
            orig_ratio = original_height / original_width

            w = h = [original_height, original_width].min
            if ratio < orig_ratio
              w = original_width * ratio
            elsif ratio > orig_ratio
              h = original_height * ratio
            end
          end

          { width: w, height: h }
        end

        if self.is_a?(CarrierWave::MiniMagick)
          begin
            manipulate! do |img|
              sizes = proc.call(img['width'], img['height'])
              h = sizes[:height]
              w = sizes[:width]

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

        elsif self.is_a?(CarrierWave::RMagick)
          begin
            manipulate! do |img|
              sizes = proc.call(img.columns, img.rows)
              h = sizes[:height]
              w = sizes[:width]

              if crop_x.blank? && crop_y.blank?
                img.crop! 'Center', 0, 0, w.to_i, h.to_i
              else
                img.crop! crop_x.to_i, crop_y.to_i, w.to_i, h.to_i
              end
              img.resize! width, height
            end

          rescue Exception => e
            raise CarrierWave::Crop::ProcessingError, "Failed to crop - #{e.message}"
          end
        else
          raise_missing_processor
        end
      end

      private

      def raise_missing_processor
        raise CarrierWave::Crop::MissingProcessorError, "Failed to crop #{attachment}. Add mini_magick or rmagick."
      end

    end ## End of UploaderAdditions
  end ## End of Crop
end ## End of CarrierWave

if defined? CarrierWave::Uploader::Base
  CarrierWave::Uploader::Base.class_eval do
    include CarrierWave::Crop::UploaderAdditions
  end
end