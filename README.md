[![Gem Version](https://badge.fury.io/rb/carrierwave-crop-on-fly.svg)](https://badge.fury.io/rb/carrierwave-crop-on-fly)

# CarrierWave-Crop-On-Fly

CarrierWave extension for on fly specifying crop area with preview and cropping images before they saved.

this gem based on [carrierwave-crop](https://github.com/kirtithorat/carrierwave-crop)

## Installation

Install the latest stable release:

```Shell
    $[sudo] gem install carrierwave-crop-on-fly
```

In Rails, add it to your Gemfile:

```Ruby
    gem 'carrierwave-crop-on-fly'
```
    
Also you must add mini_magick or rmagick gem

```Ruby
    gem 'mini_magick'
```

or

```Ruby
    gem 'rmagick'
```

And then execute:

```Shell
    $ bundle
```

Finally, restart the server to apply the changes.

## Getting Started

Add the required files in assets

In .js file

```javascript
    //= require jquery
    //= require jcrop.js
    //= require_self
    
    $(document).ready(function() {
        document.jcrop.init({ file_input_id: 'user_avatar' });
    });
```

In .css file

```css
    *= require jquery.jcrop
    *= require jcrop_fix
```

## Usage

Open your model file and add the CarrierWave uploader:

```Ruby
    class User < ActiveRecord::Base
      mount_uploader :avatar, AvatarUploader
    end
```

In the CarrierWave uploader:

```Ruby
    class AvatarUploader < CarrierWave::Uploader::Base
      # use mini_magick
      include CarrierWave::MiniMagick
      # or you may use rmagick:
      # include CarrierWave::RMagick

      process crop: [100, 100]
    end
```

In the view:

```erb
    <%= form_for @user do |f| %>
      <%= f.file_field :avatar %>
      <%= f.cropbox :avatar, width: 300, height: 300 %>
      <%= f.previewbox :avatar %>
      <%= f.submit 'Crop' %>
    <% end %>
```

in controller

```Ruby
    class UsersController < ApplicationController
        def update
            @user = User.find(params[:id])
            @user.update_attributes(user_params)
        end
        
        private
        
        def user_params
            params.require(:user).permit(:avatar)
        end
    end
```

### Credits and resources
* [CarrierWave](https://github.com/carrierwaveuploader/carrierwave)
* [Deep Liquid's JCrop](http://deepliquid.com/content/Jcrop.html)
