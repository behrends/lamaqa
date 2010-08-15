#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'

Dir.mkdir('questions') unless File.directory?('questions')

(1..388).to_a.each do |i|
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

  File.open('questions/question' + i.to_s + '.txt', 'w') do |f| 
    f.write('Question: ' + question + "\n\n") 
    f.write('Answer: ' + answer + "\n\n") 

    categories.each do |category|
      f.write('Category: ' + category.content.tr('""','') + "\n\n")
    end

    tags.each do |tag|
      f.write('Tag: ' + tag.content.tr('""','') + "\n")
    end
  end
end
