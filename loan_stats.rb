require 'csv'

v1 = ARGV[0]

csv = CSV.read(v1) # .map { |row| row[1] }
csv_hash = {}

csv[0].each do |key|
  csv_hash[key] = nil
end
p csv_hash.size

csv_hash.each_with_index do |(key, _value), i|
  csv_hash[key] = csv.map { |row| row[i] }.reject.each_with_index { |_item, index| index == 0 }
end

p csv_hash
