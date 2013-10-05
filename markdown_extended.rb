# Extending markdown to generate my own Code blocks

require 'redcarpet'
require 'getoptlong'
require File.join(ENV['HOME'], "code/ruby/common_utils.rb")

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--output_directory', '-o', GetoptLong::REQUIRED_ARGUMENT]
)

output_dir=nil

opts.each do |opt, arg|
  case opt
  when '--help'
    CommonUtils.print_help_and_exit
    
  when '--output_directory'
    output_dir = arg.to_s
  end
end

class RenderWithoutCode < Redcarpet::Render::HTML

  # Code will be in a separately styled div, with the class name 'mycode'
  # Undo what SmartyPants did
  def block_code(code, language)

    lines=code.split("\n")
    lines.map! do |line|
      line=line.gsub(/\&.squo;/, "'")
      line=line.gsub(/\&.dquo;/, '"')

      # Adding my own special coloring scheme for comments and outputs
      # (for which I've added my own special markup sequence, -->
      line=line.gsub(/(\# .*$)/, "<span.ps.style='color:.ps.red'>\\1</span>")
      line=line.gsub(/\=\=> (.*$)/, "<span.ps.style='color:.ps.blue'>\\1</span>")

      # Kludgy way of only replacing spaces outside the HTML tags I'm adding to get comments
      # to be in a span of their own
      line=line.gsub(/ /, "&nbsp;")
      line=line.gsub(/\.ps\./, " ")
    end
    html_inner = lines.join("<br/>\n")

    html="<div class=mycode>\n#{html_inner}\n</div>\n"
  end
end

input = '<link href="markdown.css" rel="stylesheet"></link>' + "\n"

begin
  input += File.open(ARGV[0]).readlines.join("")
rescue Errno::ENOENT => e
  CommonUtils.error_exit("#{ARGV[0]} Markdown file not found.")
end

outname=ARGV[0].gsub("\.md", ".html")
outname = File.join(output_dir, outname) unless output_dir.nil?

puts outname
begin
  f=File.open(outname, 'w')
rescue Errno::ENOENT => e
  msg_part2 = ((Dir.exists?output_dir)?"":'(Maybe you did not create the directory you specified via -o?)')
  CommonUtils::error_exit("Cannot open output file #{msg_part2}")
end 

parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC)
toc = parser.render input

# Print the TOC
puts toc
f.puts toc

# Change the quotes smartly
quoted_out = Redcarpet::Render::SmartyPants.render input

# Do the rest of the rendering
renderer = RenderWithoutCode.new(with_toc_data: true)
parser = Redcarpet::Markdown.new(renderer)
#parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :footnotes => true)

f.puts (parser.render quoted_out)

