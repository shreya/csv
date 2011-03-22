require 'rubygems'
require 'csv'

new_objects = []
@@meths = [] 
csv = CSV.open("./#{ARGV[0]}.csv", 'r', ',')

class_name = ARGV[0].capitalize
klass = Object.const_set(class_name,Class.new)

csv.shift.map {|method|
    @@meths << method
    klass.class_eval(<<-EOS, __FILE__, __LINE__ + 1)
      attr_accessor :#{method} 
    EOS
}

klass.class_eval do
  def initialize(*args)  
    args.each_with_index do |arg, index|
      instance_variable_set :"@#{@@meths[index]}", arg
    end        
  end       
end


new_objects = csv.inject([]) do |new_objects, row| 
    new_objects << klass.new(*row)
end
csv.close

p new_objects
