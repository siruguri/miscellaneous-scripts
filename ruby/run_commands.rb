class RunCommands
  def initialize
    @_output_fh=nil
    @_fn=Time.now.to_i
    @success=nil
  end


  def run_cmd(cmd_string)
    @success=nil

    if @_output_fh
      @_output_fh.close
    end

    output = %x[#{cmd_string}]
    @success=$?.success?

    @_output_fh=File.open("_tmp.#{@_fn}", "w")
    @_output_fh.write(output)
    @_output_fh.close
  end

  def has_output(test_re)
    begin
      @_output_fh=File.open("_tmp.#{@_fn}", "r")
    rescue Errno::ENOENT => e
      return false
    end
    found_re=false
    while !found_re && !@_output_fh.eof
      line = @_output_fh.read
      found_re = line.match test_re
    end
    return found_re
  end

  def close
    if @_output_fh && @_output_fh.respond_to?(:close)
      begin
        @_output_fh.close
      rescue IOError => e
        # Ok to have a closed stream
      end
    end

    if File.exists? "_tmp.#{@_fn}"
      File.unlink "_tmp.#{@_fn}"
    end
  end
  
  def last_cmd_success?
    @success == true
  end
end

runner = RunCommands.new

runner.run_cmd('ls tmp')
if !runner.last_cmd_success?
  puts "failed"
elsif runner.has_output /.txt/
  puts "Found a text file"
end
runner.close
