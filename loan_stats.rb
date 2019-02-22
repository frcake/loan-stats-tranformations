require 'csv'

# read args (csv_path)
csv_path = ARGV[0]

# read csv file in rows
csv = CSV.read(csv_path)

# init hash
csv_hash = {}

# create a hash key for each column name
csv[0].each do |key|
  csv_hash[key] = nil
end

# read csv in columns and pass the value as an array
# to each respective hash key
# now we have the csv as a hash so refer to each column
# using the hash
csv_hash.each_with_index do |(key, _value), i|
  csv_hash[key] = csv.map { |row| row[i] }.reject.each_with_index { |_item, index| index == 0 }
end
