require 'sqlite3'
require 'minitest/autorun'
require 'active_sql_bindings'

class ActiveSqlBindingsTest < Minitest::Test
  def test_execute
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: 'test.db'
    )

    id = 1
    name = 'test'

    ActiveSqlBindings.execute('CREATE TABLE IF NOT EXISTS test (id INTEGER, name TEXT)')

    ActiveSqlBindings.execute('INSERT INTO test (id, name) VALUES (:id, :name)', id: id, name: name)

    query = ActiveSqlBindings.execute('SELECT name FROM test WHERE id = :id', id: id)

    assert_equal(name, query.first[:name])

    File.delete('test.db') if File.exist?('test.db')
  end
end