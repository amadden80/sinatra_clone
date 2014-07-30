require_relative 'connection_adapter'

module PassiveRecord
  class Base

    @@connection = PostgresAdapter.new

    def initialize(attributes = {})
      @attributes = attributes
    end

    def method_missing(*args)
      return @attributes[args[0]] if @attributes[args[0] #returns attributes
      super
    end

    def self.all
      @@connection.execute("SELECT * FROM #{table_name};")
    end

    def self.find(id)
      @@connection.execute("SELECT * FROM #{table_name} WHERE id=#{id};")
    end

    def self.table_name
      self.name.downcase+"s"
    end

  end
end

class Instructor < PassiveRecord::Base

end




