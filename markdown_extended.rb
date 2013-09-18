# Extending markdown to generate my own Code blocks

require 'redcarpet'

class RenderWithoutCode < Redcarpet::Render::HTML

  # Code will be in a separately styled div, with the class name 'mycode'
  # Undo what SmartyPants did
  def block_code(code, language)

    lines=code.split("\n")
    lines.map! do |line|
      line=line.gsub(/\&.squo;/, "'")
      line=line.gsub(/\&.dquo;/, '"')
      line.gsub(/(\# .*$)/, "<span style='color: red'>\\1</span>")
    end
    html_inner = lines.join("<br/>\n")

    html="<div class=mycode>\n#{html_inner}\n</div>\n"
  end
end

input = '<link href="markdown.css" rel="stylesheet"></link>' + "\n"
input += File.open(ARGV[0]).readlines.join("")

parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC)
toc = parser.render input

outname=ARGV[0].gsub("\.md", ".html")
puts outname
f=File.open(outname, 'w')

# Print the TOC
 f.puts toc

# Change the quotes smartly
quoted_out = Redcarpet::Render::SmartyPants.render input

# Do the rest of the rendering
parser = Redcarpet::Markdown.new(RenderWithoutCode)

f.puts (parser.render quoted_out)

