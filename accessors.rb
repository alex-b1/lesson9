# frozen_string_literal: true

module Acсessors
  def attr_accessor_with_history(*values)
    map = {}
    values.each do |i|
      var_name = "@#{i}".to_sym
      var_name_setter = "#{i}=".to_sym

      define_method(i) do
        instance_variable_get(var_name)
      end
      define_method(var_name_setter) do |j|
        map[i] ||= []
        map[i] << j
        instance_variable_set var_name, j
      end

      define_method("#{i}_old") do
        map[i]
        puts map
      end
    end
  end

  def strong_attr_accessor(name, value_class)
    var_name = "@#{name}".to_sym
    var_name_setter = "#{name}=".to_sym

    define_method(name) do
      instance_variable_get(var_name)
    end

    define_method(var_name_setter) do |i|
      if i.class == value_class
        instance_variable_set(var_name, i)
      else
        fail 'Неверное значение'
      end
    end
  end
end
