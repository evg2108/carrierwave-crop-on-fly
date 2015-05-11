class ActionDispatch::Http::UploadedFile
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  alias_method :old_initialize, :initialize

  def initialize(hash)
    parameters = hash.with_indifferent_access
    @crop_x = parameters[:crop_x]
    @crop_y = parameters[:crop_y]
    @crop_w = parameters[:crop_w]
    @crop_h = parameters[:crop_h]

    old_initialize(hash)
  end
end