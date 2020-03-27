# frozen_string_literal: true

require 'active_record'

# Class for work with SQL query.
# You can use native SQL with bindings as hash.
# Auto converting JSON fields to hash.
class ActiveSqlBindings
  class << self
    # Create sql query with hash named bindings
    #
    # Example: ActiveSqlBindings.execute('SELECT name FROM test WHERE id = :id', id: id)
    #
    # @param [String] sql SQL query
    # @param [Hash] bind bindings data for query
    #
    # @return [Array] executed SQL request data and return array with hashes
    def execute(sql, bind = {})
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
      sql_result = ActiveRecord::Base.connection.exec_query(sql, 'SQL', bindings)

      # Find fields JSON/JSONb type
      json_fields = sql_result.column_types.select { |_k, v| v.class.name.split('::').last.downcase.to_sym == :json || v.class.name.split('::').last.downcase.to_sym == :jsonb }.keys

      # Find fields ARRAY type
      array_fields = sql_result.column_types.select { |_k, v| v.class.name.split('::').last.downcase.to_sym == :array }.keys

      # Convert JSON data to hash
      sql_result.map do |v|
        v.map do |key, value|
          [
            key.to_sym,
            check_fields(key: key, value: value, fields: { json: json_fields, array: array_fields })
          ]
        end.to_h
      end
    end

    # Check fields' type and replace it
    #
    # @param [String] key for check type
    # @param [String] value for converting
    def check_fields(key:, value:, fields:)
      return json_to_hash(value) if fields[:json].include?(key)
      return postgres_to_array(value) if fields[:array].include?(key)

      value
    end

    # Convert JSON to hash if correct data
    #
    # @param [String] json string
    # @return [Hash] return hash if json is correct or input data
    def json_to_hash(json)
      JSON.parse(json, symbolize_names: true) rescue json
    end

    # Convert ruby array to Postgres array
    #
    # @param [Array] array data for converting
    def array_to_postgres(array)
      array = [array] if array.is_a?(String)

      '{' + array.join(',') + '}'
    end

    # Convert Postgres array to ruby array
    #
    # @param [String] array string data for converting
    def postgres_to_array(array)
      return array.gsub(/[{}]/, '').split(',') if array.is_a?(String)

      []
    end
  end
end
