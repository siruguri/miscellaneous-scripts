require 'css_parser'

include CssParser

def change_all_urls decl
  url_matches = decl.scan /url\s*\((.*?)([^\/)]+)\)/
  new_decl = decl.gsub  /url\s*\((.*?)\/([^\/)]+)\)/, 'url(assets/\2)'
  puts "Changed #{decl} to #{new_decl}"
end

def change_style_files
  # Find src: attributes in the CSS file and "correct" them

  parser = CssParser::Parser.new
  # load a local file, setting the base_dir and media_types
  files = Dir.glob "styles/*" 
  files.each do |file|
    write_parser=CssParser::Parser.new
    puts "Reading #{file}"
    parser.load_file!(file)
    parser.each_selector do |sel, decl, specificity|
#      puts "#{sel},  {#{decl}},  #{specificity}"

      new_decl = change_all_urls decl if /url\s*\(/.match decl
      str =  "#{sel} { #{new_decl} }"
      write_parser.add_block! str
    end

    puts write_parser.to_s
  end
  

end

change_style_files
