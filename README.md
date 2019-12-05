# active_sql_bindings
Small ruby gem for using native SQL query with named bindings

##Installation

The recommended installation method is via Rubygems.
```
gem install active_sql_bindings
```

##Usage:
```ruby
sql = 'SELECT id, name, desc FROM news WHERE id > :id'
binding = { id: 100 }
news = ActiveSqlBindings.execute(sql, binding)
```

In the **news** variable, you will get an array of data with hash.