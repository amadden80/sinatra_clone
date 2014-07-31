# Inspired by this code: https://github.com/owningrails/patterns/blob/master/lib/connection_adapter.rb

class PostgresAdapter

  def initialize
    require "pg"
    @db = PG.connect( dbname: 'wdi_3000' ) #user must specify databse
  end

  def execute(sql)
    data = @db.exec(sql).map do |row|
      row.each_with_object({}){|(k,v), hash| hash[k.to_sym] = v} # symbolize keys
    end
  end

  def columns(table_name)
    @db.exec("SELECT column_name FROM information_schema.columns WHERE table_name='#{table_name}';").map do |row|
      row['column_name'].to_sym
    end
  end

end