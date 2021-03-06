module Rotator

  module Uploaders

    class S3 < Base
      # ACCESSORS ---------------------------------------------------------
      attr_accessor :bucket
      attr_reader :s3_options, :connection

      # METHODS -----------------------------------------------------------
      def initialize(path, opts = {})
        @hostname = opts.delete(:hostname)
        self.s3_options = opts.delete(:s3_options)
        super(path, opts)
      end

      def upload
        rename(Time.now.to_i)
        gzip if  gzip_it
        create_bucket
        connection.buckets[bucket].objects[filename].write(File.new(path)).tap do |obj|
          `rm #{path}` if obj.exists?
        end
      end

      def s3_options=(opts)
        raise InvalidS3Configuration.new(
          "You must pass options as s3_options: { access_key_id: 'your_key', secret_access_key: 'your_secret' ... } "
        ) if opts.nil?
        self.bucket = opts.delete(:bucket) || opts.delete("bucket") || "#{get_hostname}.rotator.files"
        @s3_options = opts
        @connection = ::AWS::S3.new(s3_options)
      end

      def create_bucket
        connection.buckets.create(bucket) unless connection.buckets[bucket].exists?
      end

      def s3_path; bucket + (@hostname ? ("/" + get_hostname) : "") end

      def get_hostname; `hostname`.chomp end
    end

  end

end
