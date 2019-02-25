require 'csv'
require 'pry'
require '/home/frcake/Workspace/VergeThesis/code/csv_transformer/utils.rb'
require '/home/frcake/Workspace/VergeThesis/code/csv_transformer/operations.rb'

csv_transformer = CsvTransformer::Utils.new
csv_operations = CsvTransformer::Operations.new
dynamic_lookups = {}

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

csv_operations.static_operations.each do |oper|
  next if csv_hash[oper[:column]].nil?

  csv_hash[oper[:column]] = csv_hash[oper[:column]].map do |col_value|
    if col_value.nil?
      0
    else
      col_value.send(oper[:operation], oper[:target], oper[:result])
    end
  end
end

csv_operations.dynamic_columns.each do |column|
  dynamic_lookups[column], csv_hash[column] = csv_operations.dynamic_operations(column_data: csv_hash[column])
end

binding.pry

File.write('/home/frcake/Workspace/VergeThesis/code/loan_stats_export.txt', csv_hash)
