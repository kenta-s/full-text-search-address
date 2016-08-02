require './address'
require './search'
require './constants'

include Constants

address = Address.new

if File.exist?(INDEX_FILE)
  puts "すでに#{INDEX_FILE}が存在します"
else
  address.create_index!
end

search = Search.new(address)

loop do
  search.exec
end
