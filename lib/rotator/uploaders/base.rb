require 'rotator/errors'

module Rotator

  module Uploaders
    
    class Base
      include Errors

      # ACCESSORS ---------------------------------------------------------
      attr_accessor :filename, :valid_extensions, :gzip_it, :cptrunc
      attr_reader :path, :extension, :directory
    
      # METHODS -----------------------------------------------------------
      def initialize(path, opts = {})
        set_valid_extensions(opts[:valid_extensions])
        set_path_related_variables(path)
        self.gzip_it = opts[:gzip_it]||true
        self.cptrunc = opts[:cptrunc]||true
      end
    
      def upload
        rename
        gzip if gzip_it
        # hook method for uploading the file
      end
    
      def gzip
        `gzip #{path}`
        set_path_related_variables(path + ".gz")
      end
    
      def rename(salt = Date.today.to_s, sep = "-")
        fn = directory + [filename.gsub(extension, ""), salt].join(sep) + extension
        cptrunc ?  `cp #{path} #{fn} && > #{path}` : File.rename(path, fn)
        set_path_related_variables(fn)
      end

      def set_path_related_variables(filepath)
        @path = File.expand_path(filepath.to_s)
        set_extension
        @filename = File.basename(path)
        @directory = path.gsub(filename, "")
      end

      def set_valid_extensions(exts)
        @valid_extensions = (Array(exts) << "log" << "gz").map(&method(:extensionify))
      end

      def set_extension
        @extension = File.extname(path)
        raise InvalidFileExtension.new(
          "Only files with #{valid_extensions.join(", ")} extension are valid. " +
          "If you want to include #{extension} as a valid extension please pass options valid_extensions: #{unextensionify(extension)}"
        ) unless valid_extensions.member? extension
      end
    
      def extensionify(str); str.match(/^\./) ? str : ("." + str) end
      
      def unextensionify(str); str.gsub(/^\./, "") end
      # METHOD CLASSIFICATION -------------------------------------------------------------------------------
      private :set_extension, :set_path_related_variables, :set_valid_extensions, :extensionify, :unextensionify
    end
  
  end
  
end
