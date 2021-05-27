# active_sql_bindings
Small ruby gem for using native PostgreSQL query with named bindings

## Installation

The recommended installation method is via Rubygems.
```
gem install active_sql_bindings
```

## Usage:
```ruby
sql = 'SELECT id, name, desc FROM news WHERE id > :id'
binding = { id: 100 }
news = ActiveSqlBindings.execute(sql, binding)
```

In the **news** variable, you will get an array of data with hash.

## Attention
JSON/JSONb field from SELECT will try to convert a data to Hash (will check field on JSON format). 
ARRAY field from SELECT will try to convert a data to Array (will check field on ARRAY format).
```
SELECT id, name, log, data FROM users; 
```
If the log has JSON/JSONb format this field will convert to Hash.
If the data has ARRAY format this field will convert to Array.

## History
Versions:

0.0.3 - Improved performance  
0.0.4 - Updated Active Record to 6.0.2 version  
0.0.5 - Added converting ARRAY field to the Array. Refactoring.  
0.0.6 - Update to active records 6.1.3.2  
