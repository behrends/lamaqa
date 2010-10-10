#!/usr/bin/ruby
require 'rubygems'
require 'fileutils'
require 'nokogiri'
require 'open-uri'

dest_dir = "questions"
Dir.mkdir(dest_dir) unless File.directory?(dest_dir)

q = {}
c = {}
umlauts = { "ae" => "\303\244", "oe" => "\303\266", /([^ae])ue/ => '\1' + "\303\274" } #regexp in ue: Treue, Frauen

(1..400).to_a.each do |i|
  doc = Nokogiri::HTML(open('http://www.lama-ole-nydahl.de/fragen/?p=' + i.to_s),nil,'UTF-8')

  qa_section = doc.xpath('//div[@id="inhalt"]/div[@class="article"]')

  next if qa_section.nil? || qa_section[0].content.include?("Du hast eine Seite aufgerufen, auf der keine Inhalte zu finden sind")

  question = qa_section.xpath('./h1')[0].content.tr('“”','')

  answer = ""
  qa_section.xpath('./p[not(@class)]').each do |part|
    answer += "<p>" + part.to_s.gsub("Antwort von Lama Ole Nydahl:","<b>Antwort von Lama Ole Nydahl:</b><br/>") + "</p>"
  end

  tags = qa_section.xpath('.//span[@class="tags"]/a')

  categories = qa_section.xpath('.//span[@class="cats"]/a')

  File.open(dest_dir + '/question' + i.to_s + '.html', 'w') do |f|
    f.write("<div id='content'>\n  <div id='header'>\n   <div id='question'>" + question + "</div>\n  </div>\n  <div id='answer'>\n" + answer + "\n  </div>\n</div>\n")
  end

  categories.each do |category|
    cat = category.content.tr('""','')
    umlauts.each_pair {|key,value| cat.gsub!(key,value)}

    tags.each do |tag|
      t = tag.content.tr('""','')
      umlauts.each_pair {|key,value| t.gsub!(key,value)}

      c[cat] = c[cat].nil? ? [t] : c[cat].push(t) unless c[cat] && !c[cat].find_index(t).nil?
    end
  end

  tags.each do |tag|
    t = tag.content.tr('""','')
    umlauts.each_pair {|key,value| t.gsub!(key,value)}

    qm = {'question' + i.to_s + '.html' => question}
    q[t] = q[t].nil? ? [qm] : q[t].push(qm)
  end

end

i=1
c.each do |category,tagnames|
  File.open(dest_dir + '/cat' + i.to_s + '.html', 'w') do |f|
    f.write("<div id='content'>\n  <div id='header'><h1>" + category + "</h1></div>\n  <div id='nav'>\n    <ul>\n")
    tagnames.each do |h|
      f.write("      <li><a href='tag" + (q.keys.find_index(h)+1).to_s  + ".html'>" + h + "</a></li>\n")
    end
    f.write("    </ul>\n  </div>\n</div>\n")
  end
  i+=1
end

i=1
q.each do |tag,files|
  File.open(dest_dir + '/tag' + i.to_s + '.html', 'w') do |f|
    f.write("<div id='content'>\n  <div id='header'><h1>" + tag + "</h1></div>\n  <div id='nav'>\n    <ul>\n")
    f.write("    <ul>\n")
    files.each do |h|
      h.each do |filename,question|
        f.write("      <li><a href='" + filename + "'>" + question + "</a></li>\n")
      end
    end
    f.write("    </ul>\n  </div>\n</div>\n")
  end
  i+=1
end

FileUtils.cp("../cache-manifest.manifest", dest_dir)
FileUtils.cp("../impressum.html", dest_dir)
FileUtils.cp("../index.html", dest_dir)
FileUtils.cp("../info.html", dest_dir)
FileUtils.cp_r("../resources", dest_dir)
