require 'xmlrpc/client'
require 'yaml'

config = YAML.load_file 'config.yml'
client = XMLRPC::Client.new2 config['url']
posts = client.call 'metaWeblog.getRecentPosts', 1, config['login'], config['password']
categories = client.call 'wp.getCategories', 1, config['login'], config['password']
categories = categories.reduce({}) {|memo, category| memo.merge(Hash[category['categoryName'] => []])}

posts.sample(8).each do |post|
  puts "#{post['title']} - Keywords: #{post['mt_keywords']}"
  puts post['description']
end

posts.each { |post| post['categories'].each {|category| categories[category] << post['title'] } }

# this is now a hash of category names mapped to a list of post titles
puts categories
