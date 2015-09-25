module FolderAnalyzer

  class FolderData
    attr_accessor :name, :depth, :stats

    def initialize(f)
      @name = f
      @entries = Dir.open(f).entries
      @stats = Stats.new

      @has_folders=false
      @folder_list = []
      @file_list = []

      @entries.each do |child|
        next if /^\.\.?$/.match child
        full_path = File.join(f, child)
        if File.directory? full_path
          @has_folders = true
          @folder_list << {path: full_path}
        else
          @file_list << full_path
        end
      end
    end


    def file_size= val
        @stats.sizes :file, val
    end
    def folder_size= val
        @stats.sizes :folder, val
    end
    def total_size= val
        @stats.sizes :total, val
    end

    def file_size
      @stats.sizes :file
    end
    def folder_size
      @stats.sizes :folder
    end
    def total_size
      @stats.sizes :total
    end

    def location
      @name
    end
    def location= x
      @name=x
    end

    def has_folders?
      @has_folders
    end

    def filelist # List of non-directory files
      @file_list
    end

    def folderlist 
      @folder_list
    end

    def set_percentages(total_size=nil)
      if total_size.nil?
        denom = self.total_size
      else
        denom = total_size
      end
      self.folderlist.each do |child|
        child[:fd].set_percentages denom
      end

      perc_hash = {}
      @stats.sizes.each do |size_type, size_val|
        perc_key = (size_type.to_s + "_perc").to_sym
        perc_hash[perc_key] = size_val/denom.to_f
      end
      @stats.sizes.merge! perc_hash
    end
    
    def report_by_depth(limit: nil)
      return if limit==0

      self.folderlist.each.sort { |a, b| b[:fd].stats.sizes(:total_perc) <=> a[:fd].stats.sizes(:total_perc) }.each \
      do |child|
        puts "#{child[:path]} => " + sprintf("%0.2f", child[:fd].stats.sizes(:total_perc))
        puts "#{child[:path]} => #{child[:fd].total_size}"
        puts "---->"
        if limit.nil?
          next_limit = nil
        else
          next_limit = limit - 1
        end
        child[:fd].report_by_depth limit: next_limit
      end
      puts self.file_size
    end
  end

  class Stats
    def initialize
      @_sizes = {}
    end

    def merge(child_stats)
      child_stats.sizes.each do |size_type, size_type_set|
        size_type_set.each do |size_type_set_value, size_value_array|
          merge_arrays!(size_type_set_value, size_value_array, key: size_type)
        end
      end
    end

    def sizes(key=:all, val=nil)
      if val
        @_sizes[key]=val
      elsif key == :all
        @_sizes
      else
        @_sizes[key]
      end
    end

    def add_size(key_value, fd_name, size, key: :depth)
      merge_arrays! key_value, [{name: fd_name, size: size}], key: key
    end

    private
    def merge_arrays!(value, array, key:)
      @_sizes[key] ||= {}
      @_sizes[key][value] ||= []
      
      @_sizes[key][value] |= array
    end
  end

  class Analyzer
    def self.analyze(f)
      return nil if !Dir.exists? f
      _fd = FolderData.new f
      _analyze(_fd)

      _fd
    end

    private
    def self._analyze(fd)
      file_size = 0
      fd.filelist.each do |f_entry|
        begin
          file_size += File.size f_entry
        rescue Errno::ENOENT, exc # Happens with sym links
          unless File.symlink? f_entry
            raise Errno::ENOENT, exc
          end
        end
      end

      fd.file_size= file_size

      if fd.has_folders?
        max_depth = 0
        folder_size = 0

        fd.folderlist.each do |child|
          child[:fd] = analyze(child[:path])
          folder_size += child[:fd].total_size
        end

        fd.folder_size= folder_size
        fd.total_size= folder_size + file_size
      else
        fd.total_size = file_size
      end
    end
  end
end

analyzed_fd = FolderAnalyzer::Analyzer.analyze ARGV[0]
analyzed_fd.set_percentages

analyzed_fd.report_by_depth limit: 1
