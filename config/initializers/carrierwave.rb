CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => "AWS",                        # required
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY'],        # required
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],        # required
  }
  config.fog_directory  = ENV['AWS_S3_BUCKET']                    # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  config.storage = :fog

  # For testing, upload files to local `tmp` folder.
  # if Rails.env.test? || Rails.env.cucumber?
#     config.storage = :file
#     config.enable_processing = false
#     config.root = "#{Rails.root}/tmp"
#   else
#     config.storage = :fog
#   end


# ------------

  # if Rails.env.development? || Rails.env.test?
#     # config.storage = :file
#     
#     config.storage = :fog
#     config.fog_credentials = {
#       :provider               => 'AWS',
#       :aws_access_key_id      => ENV['AWS_ACCESS_KEY'],
#       :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
#       :region                 => 'eu-west-1'
#     }
#     config.fog_directory = ENV['AWS_S3_BUCKET']
#   else
#     config.root = Rails.root.join('tmp')
#     config.cache_dir = 'carrierwave'
#     config.root = Rails.root.join('tmp')
#     config.cache_dir = 'carrierwave'
#     config.storage = :fog
#     config.fog_credentials = {
#       :provider               => 'AWS',
#       :aws_access_key_id      => ENV['AWS_ACCESS_KEY'],
#       :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
#       :region                 => 'eu-west-1'
#     }
#     config.fog_directory = ENV['AWS_S3_BUCKET']
#   end
  
end

