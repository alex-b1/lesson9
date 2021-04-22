# frozen_string_literal: true

require_relative './instance_counter'
require_relative './accessors'
require_relative './validation'

class Station
  include InstanceCounter
  include Validation
  extend Acсessors

  @@instances = {}

  #  attr_accessor :trains, :name
  attr_accessor_with_history :trains, :name
  strong_attr_accessor(:some_attr, 'Station')

  def initialize(name)
    @name = name
    init_validations
    validate!
    @trains = []
    @@instances[name] = self
    @type_class = self.class

    register_instance
  end

  def init_validations
    self.class.validate @name,       :presence
    self.class.validate @type_class, :type, self.class
  end

  def get_trains(block)
    @trains.each do |i|
      block.call(i)
    end
  end

  def arrival_train(train)
    @trains << train
  end

  def depart_train(train)
    @trains.filter! { |i| i.number != train.number }
    train.go_ahead

    train.accelerate while train.accelerate < 80
  end

  def trains_by_type
    {
      cargo: (@trains.filter { |i| i.type == :cargo }).count,
      passenger: (@trains.filter { |i| i.type == :passenger }).count
    }
  end

  def self.all
    @@instances
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  private

  def validate!
    raise 'Неверное значение' if name.empty?
    raise 'Такая станция уже есть' if @@instances[name]
  end
end
