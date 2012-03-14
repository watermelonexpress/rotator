module Rotator
  module Errors
    class InvalidFileExtension < StandardError; end
    class InvalidS3Configuration < StandardError; end
    class S3ConnectionError < StandardError; end
  end
end