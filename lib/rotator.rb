require 'aws/s3'
require 'rotator/version'
require 'rotator/errors'
require 'rotator/uploaders/base'
require 'rotator/uploaders/s3'


module Rotator
  class << self
    def rotate(path, opts)
      uploader = opts[:s3_options].present? ? "S3" : (opts.delete(:uploader)||:Base).to_s
      uploader = "Rotator::Uploaders::" + uploader
      uploader.constantize.new(path, opts).upload
    end
  end
end
