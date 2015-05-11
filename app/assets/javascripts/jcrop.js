//= require jquery.jcrop.js
//= require_self

document.jcrop = (function() {
    var exports = { };

    var centerSelection = function(input_image_sizes, output_image_sizes) {
        var x_offset = 0;
        var y_offset = 0;
        var orig_w = input_image_sizes[0];
        var orig_h = input_image_sizes[1];

        var ratio = output_image_sizes[0] / output_image_sizes[1];
        var current_image_ratio = orig_w / orig_h;

        var width = orig_w;
        var height = orig_h;
        if (ratio < current_image_ratio) {
            width = orig_h * ratio;
            x_offset = (orig_w - width) / 2;
        } else if (ratio > current_image_ratio) {
            height = orig_w * ratio;
            y_offset = (orig_h - height) / 2
        }

        return { aspect_ratio: ratio, position_and_size: [x_offset, y_offset, width, height] }
    };

    var readURL = function(input)
    {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function(e){
                if (!document.jcrop.options.image_loaded) {
                    document.jcrop.options.image_loaded = true;
                    document.jcrop.options.cropbox_image.on('load', function () {
                        document.jcrop.options.current_image_width = this.width;
                        document.jcrop.options.current_image_height = this.height;

                        var selection = centerSelection([document.jcrop.options.current_image_width, document.jcrop.options.current_image_height],
                                                        [document.jcrop.options.output_width, document.jcrop.options.output_height]);

                        var data = document.jcrop.options.cropbox_image.data('Jcrop');
                        if (data) { data.destroy(); }

                        document.jcrop.options.cropbox_image.Jcrop({
                            aspectRatio: selection.aspect_ratio,
                            setSelect: selection.position_and_size,
                            onChange: showPreview,
                            onSelect: showPreview,
                            boxWidth: 300, boxHeight: 300
                        });
                    });
                }

                document.jcrop.options.cropbox_image.attr('src', e.target.result);
                if (document.jcrop.options.previewbox_image.length > 0) { document.jcrop.options.previewbox_image.attr('src', e.target.result); }
            };
            reader.readAsDataURL(input.files[0]);
        }
    };

    var showPreview = function(coords) {
        if (document.jcrop.options.crop_x.length > 0) { document.jcrop.options.crop_x.val(coords.x); }
        if (document.jcrop.options.crop_y.length > 0) { document.jcrop.options.crop_y.val(coords.y); }
        if (document.jcrop.options.crop_w.length > 0) { document.jcrop.options.crop_w.val(coords.w); }
        if (document.jcrop.options.crop_h.length > 0) { document.jcrop.options.crop_h.val(coords.h); }

        if (document.jcrop.options.previewbox_image.length > 0) {
            var original_picture_height = document.jcrop.options.current_image_height;
            var original_picture_width = document.jcrop.options.current_image_width;

            var preview_height = document.jcrop.options.output_height;
            var preview_width = document.jcrop.options.output_width;

            var imaginary_picture_height = (original_picture_height * preview_height) / coords.h;
            var imaginary_picture_width = (original_picture_width * preview_width) / coords.w;

            var imaginary_picture_x_shift = imaginary_picture_width * coords.x / (original_picture_width);
            var imaginary_picture_y_shift = imaginary_picture_height * coords.y / (original_picture_height);

            document.jcrop.options.previewbox_image.css({
                width: Math.round(imaginary_picture_width) + 'px',
                height: Math.round(imaginary_picture_height) + 'px',
                marginLeft: '-' + Math.round(imaginary_picture_x_shift) + 'px',
                marginTop: '-' + Math.round(imaginary_picture_y_shift) + 'px'
            });
        }
    };

    var init_options = function(options) {
        options = options || {};

        options.file_input_id = options.file_input_id ? '#' + options.file_input_id : '#file_input_cropper';
        options.file_input = $(options.file_input_id);
        if (options.file_input.length == 0) { throw "element '" + options.file_input_id + "' not found"; }

        options.cropbox_image_id = options.cropbox_image_id || options.file_input_id + '_cropbox';
        options.cropbox_image = $(options.cropbox_image_id);
        if (options.cropbox_image.length == 0) { throw "element '" + options.cropbox_image_id + "' not found"; }

        options.previewbox_image_id = options.previewbox_image_id || options.file_input_id + '_previewbox';
        options.previewbox_image = $(options.previewbox_image_id);
        if (options.previewbox_image.length == 0) { console.info("element '" + options.previewbox_image_id + "' not found"); }

        options.crop_x_id = options.crop_x_id || options.file_input_id + '_crop_x';
        options.crop_x = $(options.crop_x_id);
        if (options.crop_x.length == 0) { console.warn("element '" + options.crop_x_id + "' not found. You can not send horizontal offset data to the server"); }

        options.crop_y_id = options.crop_y_id || options.file_input_id + '_crop_y';
        options.crop_y = $(options.crop_y_id);
        if (options.crop_y.length == 0) { console.warn("element '" + options.crop_y_id + "' not found. You can not send vertical offset data to the server"); }

        options.crop_w_id = options.crop_w_id || options.file_input_id + '_crop_w';
        options.crop_w = $(options.crop_w_id);
        if (options.crop_w.length == 0) { console.warn("element '" + options.crop_w_id + "' not found. You can not send width data to the server"); }

        options.crop_h_id = options.crop_h_id || options.file_input_id + '_crop_h';
        options.crop_h = $(options.crop_h_id);
        if (options.crop_h.length == 0) { console.warn("element '" + options.crop_h_id + "' not found. You can not send height data to the server"); }

        options.output_width = options.output_width || options.cropbox_image.data('output-width') || 100;
        options.output_height = options.output_height || options.cropbox_image.data('output-height') || 100;

        document.jcrop.options = options;

        return options;
    };

    exports.init = function(options) {
        init_options(options);

        var file_input = $(document.jcrop.options.file_input_id);

        if (file_input.length > 0) {
            file_input.change(function(){
                if (document.jcrop.options.after_change) { document.jcrop.options.after_change(); }
                readURL(this);
            });
        }
    };
    
    return exports;
})();