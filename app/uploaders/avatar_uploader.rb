# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  include CarrierWave::MimeTypes
  process :set_content_type
   
   
  def cache_dir
   "#{Rails.root}/tmp/uploads"
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :mini do
    process :crop
    resize_to_fill(30, 30)
  end

  version :thumb do
    process :crop
    resize_to_fill(50, 50)
  end

  version :large do
    process :crop
    resize_to_limit(600, 600)
  end

  def crop
   if model.crop_x.present?
     resize_to_limit(600, 600)
     manipulate! do |img|
       x = model.crop_x.to_i
       y = model.crop_y.to_i
       w = model.crop_w.to_i
       h = model.crop_h.to_i
       img.crop!(x, y, w, h)
     end
   end
  end
   
end
