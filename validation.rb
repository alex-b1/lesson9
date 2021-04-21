# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(name, type, *args)
      instance_variable_set('@validations', []) unless instance_variable_defined?('@validations')
      if type == :presence
        method = lambda do
          raise 'Не верное значение' if name.nil? || name.empty?
        end
        @validations.push(method)
      end
      if type == :format
        method = lambda do
          raise 'Не верный формат' unless name =~ args[0]
        end
        @validations.push(method)
      end
      if type == :type
        method = lambda do
          raise 'Не соответствует классу' if name.instance_of?(args[0])
        end
        @validations.push(method)
      end
    end
  end

  module InstanceMethods
    def validate!
      self.class.instance_variable_get('@validations').each(&:call)
    ensure
      self.class.instance_variable_set('@validations', [])
    end

    def valid?
      validate!
      true
    rescue StandardError => e
      puts "Ошибка: #{e.message}"
      false
    end
  end
end
