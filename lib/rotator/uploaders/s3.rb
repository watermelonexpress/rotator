module Rotator

  module Uploaders
  
    class S3 < Base
      # ACCESSORS ---------------------------------------------------------
      attr_accessor :key, :secret, :bucket
      attr_reader :s3_options
    
      # METHODS -----------------------------------------------------------
      def initialize(path, opts = {})
        @include_hostname = opts.delete(:hostname)||true
        set_s3_options(opts.delete(:s3_options))
        establish_connection
        check_connection
        super(path, opts)
      end
    
      def upload
        super
        create_bucket
        response = AWS::S3::S3Object.store(filename, open(path), s3_path)
        `rm #{path}` if response.code == 200
        response
      end

      def establish_connection; AWS::S3::Base.establish_connection!(s3_options); check_connection end
    
      def check_connection
        raise S3ConnectionError.new("Check your configuration settings and try again.") unless AWS::S3::Base.connected?
      end

      def create_bucket
        begin
          AWS::S3::Bucket.find(bucket)
        rescue AWS::S3::NoSuchBucket
          AWS::S3::Bucket.create(bucket)
        end
      end

      def set_s3_options(opts)
        raise InvalidS3Configuration.new("You must pass options as s3_options: { key: 'your_key', secret: 'your_secret' } ") if opts.blank?
        self.bucket = opts.delete(:bucket)||'rotator.files'
        @s3_options = opts
        self.key = s3_options[:access_key_id]
        self.secret = s3_options[:secret_access_key]
      end
    
      def s3_path; bucket + (@include_hostname ? ("/" + `hostname`.chomp) : "") end
    end
  
  end

end