#!/usr/bin/env ruby
require 'open-uri'

def source_url(page_url)
  url = page_url.dup

  return url + '?format=txt' if %r[/wiki/.+$] =~ url

  url << '/' if %r[/\Z] !~ url 
  url << 'wiki/' if %r[/wiki/] !~ url
  url << 'WikiStart?format=txt'
  url
end

def convert(body)
  body = body.dup
  body.gsub!(/\r/, '')
  body.gsub!(/\{\{\{([^\n]+?)\}\}\}/, '@\1@')
  body.gsub!(/\{\{\{\n#!([^\n]+?)(.+?)\}\}\}/m, '<pre><code class="\1">\2</code></pre>')
  body.gsub!(/\{\{\{(.+?)\}\}\}/m, '<pre>\1</pre>')
  # macro
  body.gsub!(/\[\[BR\]\]/, '')
  body.gsub!(/\[\[PageOutline.*\]\]/, '{{toc}}')
  body.gsub!(/\[\[Image\((.+?)\)\]\]/, '!\1!')
  # header
  body.gsub!(/=====\s(.+?)\s=====/, "h5. #{'\1'} \n\n")
  body.gsub!(/====\s(.+?)\s====/,   "h4. #{'\1'} \n\n")
  body.gsub!(/===\s(.+?)\s===/,     "h3. #{'\1'} \n\n")
  body.gsub!(/==\s(.+?)\s==/,       "h2. #{'\1'} \n\n")
  body.gsub!(/=\s(.+?)\s=[\s\n]*/,  "h1. #{'\1'} \n\n")
# table
  body.gsub!(/\|\|/,  "|")
# link
  body.gsub!(/\[(http[^\s\[\]]+)\s([^\[\]]+)\]/, ' "\2":\1' )
  body.gsub!(/\[([^\s]+)\s(.+)\]/, ' [[\1 | \2]] ')
  body.gsub!(/([^"\/\!])(([A-Z][a-z0-9]+){2,})/, ' \1[[\2]] ')
  body.gsub!(/\!(([A-Z][a-z0-9]+){2,})/, '\1')
# text decoration
  body.gsub!(/'''(.+)'''/, '*\1*')
  body.gsub!(/''(.+)''/, '_\1_')
  body.gsub!(/`(.+)`/, '@\1@')
# itemize
  body.gsub!(/^\s\s\s\*/, '***')
  body.gsub!(/^\s\s\*/, '**')
  body.gsub!(/^\s\*/, '*')
  body.gsub!(/^\s\s\s\d\./, '###')
  body.gsub!(/^\s\s\d\./, '##')
  body.gsub!(/^\s\d\./, '#')
  body
end

def main(page_url)
  url = source_url(page_url)
  open(url){|f|
    puts convert(f.read)
  }
end

main(ARGV.shift)

