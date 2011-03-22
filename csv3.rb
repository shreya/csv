require 'rubygems'
require 'csv'

class_name = ARGV[0].capitalize
klass = Object.const_set(class_name,Class.new)

columns = []
csv = CSV.open("./#{ARGV[0]}.csv", 'r', ',')
csv.shift.map {|method|
  columns << method
}


klass.class_eval do
  attr_accessor *columns
  define_method(:initialize) do |*values|
    columns.each_with_index do |name, index|
      instance_variable_set("@"+name.to_s, values[index])
    end
  end
end

new_objects = []
new_objects = csv.inject([]) do |new_objects, row| 
    new_objects << klass.new(*row)
end
csv.close

p new_objects