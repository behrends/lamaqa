#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'

dest_dir = "questionsXYZ"

Dir.mkdir(dest_dir) unless File.directory?(dest_dir)

q = {}

c = {}

(1..400).to_a.each do |i|
  doc = Nokogiri::HTML(open('http://www.lama-ole-nydahl.de/fragen/?p=' + i.to_s))

  qa_section = doc.xpath('//div[@id="inhalt"]/div[@class="article"]')

  next if qa_section.nil? || qa_section[0].content.include?("Du hast eine Seite aufgerufen, auf der keine Inhalte zu finden sind")

  question = qa_section.xpath('./h1')[0].content.tr('“”','')

  answer = ""
  qa_section.xpath('./p[not(@class)]').each do |part|
    answer += "<p>" + part + "</p>"
  end

  tags = qa_section.xpath('.//span[@class="tags"]/a')

  categories = qa_section.xpath('.//span[@class="cats"]/a')

  File.open(dest_dir + '/question' + i.to_s + '.html', 'w') do |f|
    f.write("<div id='content'>\n")
    f.write("  <div id='question'>" + question + "</div>\n")
    f.write("  <div id='answer'>\n")
    f.write(    answer + "\n")
    f.write("  </div>\n")
    f.write("</div>\n")
  end

  categories.each do |category|
    cat = category.content.tr('""','')

    tags.each do |tag|
      t = tag.content.tr('""','')
      c[cat] = c[cat].nil? ? [t] : c[cat].push(t) unless c[cat] && !c[cat].find_index(t).nil?
    end
  end

  tags.each do |tag|
    t = tag.content.tr('""','')
    qm = {'question' + i.to_s + '.html' => question}
    q[t] = q[t].nil? ? [qm] : q[t].push(qm)
  end

end

i=1
c.each do |category,tagnames|
  File.open(dest_dir + '/cat' + i.to_s + '.html', 'w') do |f|
    f.write("<div id='content'>\n")
    f.write("  <div id='header'>" + category + "</div>\n")
    f.write("  <div id='nav'>\n")
    f.write("    <ul>\n")
    tagnames.each do |h|
      f.write("      <li><a href='tag" + (q.keys.find_index(h)+1).to_s  + ".html'>" + h + "</a></li>\n")
    end
    f.write("    </ul>\n")
    f.write("  </div>\n")
    f.write("</div>\n")
  end
  i+=1
end

i=1
q.each do |tag,files|
  File.open(dest_dir + '/tag' + i.to_s + '.html', 'w') do |f|
    f.write("<div id='content'>\n")
    f.write("  <div id='header'>" + tag + "</div>\n")
    f.write("  <div id='nav'>\n")
    f.write("    <ul>\n")
    files.each do |h|
      h.each do |filename,question|
        f.write("      <li><a href='" + filename + "'>" + question + "</a></li>\n")
      end
    end
    f.write("    </ul>\n")
    f.write("  </div>\n")
    f.write("</div>\n")
  end

  i+=1
end
