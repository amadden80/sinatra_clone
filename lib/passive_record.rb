require_relative 'connection_adapter'

module PassiveRecord
  class Base

    @@connection = PostgresAdapter.new

    def initialize(attributes = {})
      columns = @@connection.columns(self.class.table_name)
      attributes.keys.each { |attr| raise PassiveRecord::UnknownAttributeError.new(attr) unless columns.include?(attr) }
      @attributes = attributes
    end

    def save
      data = @@connection.execute("INSERT INTO #{self.class.table_name} (#{attributes_to_sql}) VALUES (#{values_to_sql}) RETURNING *") #could refactor is psql allows
      @attributes = data[0]
      self
    end

    def update(attributes)
      attrs = @attributes.merge(attributes)
      data = @@connection.execute("UPDATE #{self.class.table_name} SET (#{attributes_to_sql}) = (#{values_to_sql(attrs)}) WHERE id=#{self.id} RETURNING *")
      @attributes = data[0]
      self
    end

    def method_missing(*args)
      return @attributes[args[0]].to_i if !@attributes[args[0]].to_i.zero? #returns integer if it can be parsed into int
      return @attributes[args[0]] if @attributes[args[0]]
      super
    end


    def self.create(attributes={})
      self.new(attributes).save
    end

    def self.delete(id)
      @@connection.execute("DELETE FROM #{self.table_name} WHERE id=#{id};")
    end

    def self.all
      data = @@connection.execute("SELECT * FROM #{table_name};")
      self.objectify(data)
    end

    def self.find(id)
      data = @@connection.execute("SELECT * FROM #{table_name} WHERE id=#{id};")
      raise PassiveRecord::RecordNotFound.new(id, self) if data.empty?
      self.objectify(data)[0]
    end

    def self.table_name
      self.name.downcase+"s"
    end

    def self.objectify(arr)
      arr.map{ |hash| self.new(hash)}
    end

    private

    def attributes_to_sql
      exclude_immutables(@attributes.clone).keys.map(&:to_s).join(", ")
    end

    def values_to_sql(attributes = nil)
      attributes = @attributes unless attributes
      attributes = exclude_immutables(attributes.clone).values.map{|x| x.is_a?(String) ? "'#{x}'" : x }.join(", ")
    end

    def exclude_immutables(attributes)
      immutables = [ :created_at, :id ]
      attributes.keep_if{ |k,v| !immutables.include? k }
    end
  end

  class UnknownAttributeError < NoMethodError
    def initialize(attribute)
      @attribute = attribute.to_s
      super("unknown attribute: #{attribute}")
    end
  end

  class RecordNotFound < NoMethodError
    def initialize(id, klass)
      @id = id
      super("Couldn't find #{klass} with 'id'=#{id}")
    end
  end
end





