module CsvTransformer
  class Operations
    def static_operations
      [
        {
          column: 'term',
          operation: 'tr',
          target: ' months',
          result: ''
        },
        {
          column: 'int_rate',
          operation: 'tr',
          target: '%',
          result: ''
        },
        grade_map(column: 'grade'),
        grade_map(column: 'sub_grade'),
        home_ownership_map(column: 'home_ownership'),
        verification_status_map(column: 'verification_status'),
        {
          column: 'loan_status',
          operation: 'gsub',
          target: '/Does not meet the credit policy. Status:/',
          result: ''
        },
        loan_status_map(column: 'loan_status'),
        {
          column: 'revol_util',
          operation: 'tr',
          target: '%',
          result: ''
        },
        emp_length_map(column: 'emp_length')
      ].flatten
    end

    def dynamic_columns
      %w[purpose addr_state]
    end

    def date_columns
      %w[issue_d]
    end

    # assign an incremental number for each unique value in the column
    # this should be used when column values vary a lot
    def dynamic_operations(column_data:)
      lookup_names = {}
      lookup_value = 0
      result = column_data.map do |datum|
        # if we already have the key assign it's value to the column value
        if lookup_names.key?(datum)
          lookup_names[datum]
        # if the key doesnt exist in the hash increment the lookup value and assign
        else
          lookup_value += 1
          lookup_names[datum] = lookup_value
          lookup_names[datum]
        end
      end

      # return both the dynamic lookup and the resulting dataset for
      # future reference
      [lookup_names, result]
    end

    private

    def grade_map(column:)
      value_arr = [1, 2, 3, 4, 5, 6, 7]
      %w[A B C D E F G].each_with_index.map do |t, i|
        {
          column: column,
          operation: 'gsub',
          target: t,
          result: value_arr[i].to_s
        }
      end
    end

    def home_ownership_map(column:)
      value_arr = [1, 2, 3, 4, 5]
      %w[RENT MORTGAGE NONE OTHER OWN].each_with_index.map do |t, i|
        {
          column: column,
          operation: 'gsub',
          target: '/' + t + '/',
          result: value_arr[i].to_s
        }
      end
    end

    def verification_status_map(column:)
      value_arr = [1, 2, 3]
      ['Verified', 'Source Verified', 'Not Verified'].each_with_index.map do |t, i|
        {
          column: column,
          operation: 'gsub',
          target: '/' + t + '/',
          result: value_arr[i].to_s
        }
      end
    end

    def loan_status_map(column:)
      value_arr = [1, 2]
      ['Fully Paid', 'Charged Off'].each_with_index.map do |t, i|
        {
          column: column,
          operation: 'gsub',
          target: '/' + t + '/',
          result: value_arr[i].to_s
        }
      end
    end

    # 1 is the value for less than a year, just a custom scale
    def emp_length_map(column:)
      target_hash = {
        '10+ years': 11,
        '< 1 year': 1,
        '1 year': 2,
        '2 years': 3,
        '3 years': 4,
        '4 years': 5,
        '5 years': 6,
        '6 years': 7,
        '7 years': 8,
        '8 years': 9,
        '9 years': 10
      }
      target_hash.map do |key, value|
        {
          column: column,
          operation: 'gsub',
          target: "/#{key}/",
          result: value.to_s
        }
      end
    end
  end
end
