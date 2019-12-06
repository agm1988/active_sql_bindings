# frozen_string_literal: true

require 'active_record'

# Class for work with SQL query.
# You can use native SQL with bindings as hash.
# Auto converting JSON fields to hash.
class ActiveSqlBindings
  # Create sql query with hash named bindings
  #
  # Example: ActiveSqlBindings.execute('SELECT name FROM test WHERE id = :id', id: id)
  #
  # @param [String] sql SQL query
  # @param [Hash] bind bindings data for query
  #
  # @return [Array] executed SQL request data and return array with hashes
  def self.execute(sql, bind = {})
    bindings = []
    bind_index = 1

    # Get all bindings if exist
    unless bind.empty?
      bind.each do |key, value|
        # Change name bind to $ bind
        sql.gsub!(/(?<!:):#{key}(?=\b)/, "$#{bind_index}")
        bind_index += 1

        # Add new bind data
        bindings << [nil, value]
      end
    end

    # Execute query, convert to hash with symbol keys
    result = ActiveRecord::Base.connection.exec_query(sql, 'SQL', bindings).map(&:symbolize_keys)

    # Convert JSON data to hash
    result.map do |v|
      next if v.nil?

      v.each do |key, val|
        v[key] = json_to_hash(val)
      end
    end
  end

  # Convert JSON to hash if correct data
  #
  # @param [String] json string
  # @return [Hash] return hash if json is correct or input data
  def self.json_to_hash(json)
    JSON.parse(json, symbolize_names: true) rescue json
  end
end
