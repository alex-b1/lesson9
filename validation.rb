# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(name, *args)
      instance_variable_set('@validations', {}) unless instance_variable_defined?('@validations')
      instance_variable_get('@validations')[name] = *args
    end
  end

  module InstanceMethods
    def validate!
      self.class.instance_variable_get('@validations').each do |i, args|
        puts args[0]
        send("validate_#{args[0]}", i, args[1])
      end
    ensure
      self.class.instance_variable_set('@validations', {})
    end

    def valid?
      validate!
      true
    rescue StandardError => e
      puts "Ошибка: #{e.message}"
      false
    end

    def validate_presence(name)
      raise 'Не верное значение' if name.nil? || name.empty?
    end

    def validate_format(name, format)
      raise 'Не верный формат' unless name =~ format
    end

    def validate_type(name, type)
      raise 'Не соответствует классу' if name.instance_of?(type)
    end
  end
end
