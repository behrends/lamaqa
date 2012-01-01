require 'xmlrpc/client'
require 'yaml'

config = YAML.load_file 'config.yml'
client = XMLRPC::Client.new2 config['url']
posts = client.call 'metaWeblog.getRecentPosts', 1, config['login'], config['password']
categories = client.call 'wp.getCategories', 1, config['login'], config['password']

posts.each do |post|
  puts "#{post['title']} - Keywords: #{post['mt_keywords']}"
  puts post['description']
end
