# CarrierWave-Fly-Crop

CarrierWave extension for on fly specifying crop area with preview and cropping images before they saved.

this gem based on [carrierwave-crop](https://github.com/kirtithorat/carrierwave-crop)

## Installation

Install the latest stable release:

    $[sudo] gem install carrierwave-fly-crop

In Rails, add it to your Gemfile:

    gem 'carrierwave-fly-crop'
    
Also you must add mini_magick gem

    gem 'mini_magick'

And then execute:

    $ bundle

Finally, restart the server to apply the changes.

## Getting Started

Add the required files in assets

In .js file

    //= require jquery
    //= require jcrop_init

In .css file

    *= require jquery.jcrop
    *= require jcrop_fix

## Usage

Open your model file and add the CarrierWave uploader:

    class User < ActiveRecord::Base
      mount_uploader :avatar, AvatarUploader
    end

In the CarrierWave uploader:

    class BaseUploader < CarrierWave::Uploader::Base
      include CarrierWave::MiniMagick
      process crop: [100, 100]
    end

In the view:

    <%= form_for @user do |f| %>
      <%= f.file_field :avatar %>
      <%= f.cropbox :avatar, width: 300, height: 300 %>
      <%= f.previewbox :avatar %>
      <%= f.submit 'Crop' %>
    <% end %>

### Credits and resources
* [CarrierWave](https://github.com/carrierwaveuploader/carrierwave)
* [Deep Liquid's JCrop](http://deepliquid.com/content/Jcrop.html)