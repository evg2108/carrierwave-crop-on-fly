# encoding: utf-8

module CarrierWave
  module Crop
    module Helpers

      # Form helper to render the preview of a cropped attachment.
      # Loads the actual image. Previewbox has no constraints on dimensions, image is renedred at full size.
      # By default box size is 100x100. Size can be customized by setting the :width and :height option.
      # If you override one of width/height you must override both.
      #
      #   previewbox :avatar
      #   previewbox :avatar, width: 200, height: 200
      #
      # @param attachment [Symbol] attachment name
      # @param opts [Hash] specify version or width and height options
      def previewbox(attachment, opts = {})
        attachment = attachment.to_sym
        attachment_instance = self.object.send(attachment)

        if(attachment_instance.is_a? CarrierWave::Uploader::Base)
          model_name = self.object.class.name.demodulize.underscore
          width, height = 100, 100
          if(opts[:width] && opts[:height])
            width, height = opts[:width].round, opts[:height].round
          elsif (sizes = find_output_sizes(attachment_instance))
            width, height = *sizes
          end
          wrapper_attributes = {id: "#{model_name}_#{attachment}_previewbox_wrapper", style: "width:#{width}px; height:#{height}px; overflow:hidden", class: 'previewbox_wrapper'}

          preview_image = @template.image_tag(attachment_instance.url, id: "#{model_name}_#{attachment}_previewbox")
          @template.content_tag(:div, preview_image, wrapper_attributes)
        end
      end

      def find_output_sizes(attachment_instance)
        attachment_instance.class.processors.reverse.find{ |a| a[0].to_s.include?('crop') }.try(:[], 1)
      end

      # Form helper to render the actual cropping box of an attachment.
      # Loads the actual image. Cropbox has no constraints on dimensions, image is renedred at full size.
      # Box size can be restricted by setting the :width and :height option. If you override one of width/height you must override both.
      #
      #   cropbox :avatar
      #   cropbox :avatar, width: 550, height: 600
      #
      # @param attachment [Symbol] attachment name
      # @param opts [Hash] specify version or width and height options
      def cropbox(attachment, opts = {})
        attachment = attachment.to_sym
        attachment_instance = self.object.send(attachment)

        if(attachment_instance.is_a? CarrierWave::Uploader::Base)
          model_name = self.object.class.name.demodulize.underscore

          output = ActiveSupport::SafeBuffer.new
          [:crop_x ,:crop_y, :crop_w, :crop_h].each do |attribute|
            output << @template.hidden_field_tag("#{model_name}[#{attachment}][#{attribute}]", nil, id: "#{model_name}_#{attachment}_#{attribute}")
          end

          wrapper_attributes = {id: "#{model_name}_#{attachment}_cropbox_wrapper", class: 'cropbox_wrapper'}
          if(opts[:width] && opts[:height])
            wrapper_attributes.merge!(style: "width:#{opts[:width].round}px; height:#{opts[:height].round}px; overflow:hidden")
          end

          width, height = 100, 100
          if (sizes = find_output_sizes(attachment_instance))
            width, height = *sizes
          end

          output << @template.image_tag(attachment_instance.url, id: "#{model_name}_#{attachment}_cropbox", data: { output_width: width, output_height: height })

          @template.content_tag(:div, output, wrapper_attributes)
        end
      end
    end
  end
end

if defined? ActionView::Helpers::FormBuilder
  ActionView::Helpers::FormBuilder.class_eval do
    include CarrierWave::Crop::Helpers
  end
end
