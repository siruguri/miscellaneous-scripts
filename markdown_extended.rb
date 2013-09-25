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
      line=line.gsub(/(\# .*$)/, "<span.ps.style='color:.ps.red'>\\1</span>")

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
input += File.open(ARGV[0]).readlines.join("")

outname=ARGV[0].gsub("\.md", ".html")
puts outname
f=File.open(outname, 'w')

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

