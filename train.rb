# frozen_string_literal: true

require_relative './instance_counter'
require_relative './company_manufacturer'
require_relative './accessors'
require_relative './validation'

class Train
  include CompanyManufacturer
  include InstanceCounter
  include Validation
  extend Acсessors

  NUMBER_FORMAT = /([а-яА-Я]|\d){3}-*([а-яА-Я]|\d){2}/.freeze
  TRAIN_TYPES = %i[cargo passenger].freeze

  @@instances = {}

  #  attr_reader :carriages, :number, :type, :speed, :station,
  attr_accessor_with_history :carriages, :number, :type, :speed, :station
  strong_attr_accessor(:some_attr, 'Train')

  def initialize(options)
    @number = options[:number]
    @type = options[:type]
    @type_class = self.class

    init_validations
    validate!
    @carriages = [].concat(options[:carriages])
    @speed = 0
    @@instances[@number] = self
    register_instance
  end

  def init_validations
    self.class.validate @number,       :presence
    self.class.validate @number,       :format, NUMBER_FORMAT
    self.class.validate @type_class, :type, 'Train'
  end

  def carriages_list(block)
    @carriages.each do |i|
      block.call(i)
    end
  end

  def accelerate(speed = 10)
    @speed += speed
  end

  def slow_down(speed = 10)
    @speed = @speed < speed ? 0 : @speed - speed
  end

  def attach_carriage(carriage)
    @carriages << carriage if !validate_speed? && validate_carriage?(carriage)
  end

  def detach_carriage
    @carriages.pop unless validate_speed?
  end

  def route(route)
    @route = route
    @station = @route.stations.first
  end

  def go_ahead
    @station = next_station if next_station
  end

  def go_back
    @station = previous_station if previous_station
  end

  def self.find(number)
    @@instances[number] || nil
  end

  # def valid?
  #   validate!
  #   true
  # rescue StandardError
  #   false
  # end

  private

  # def validate!
  #   raise 'Не правильный номер поезда' if number !~ NUMBER_FORMAT
  #   raise 'Не правильный тип поезда' unless TRAIN_TYPES.include? type
  #   raise 'Такой поезд уже есть' unless @@instances[number].nil?
  # end

  def validate_carriage?(carriage)
    carriage.class::TYPE == @type
  end

  # validate_speed? only for Class Train using
  def validate_speed?
    @speed.positive?
  end

  # next_station, previous_station for checking last stations
  def next_station
    index = @route.stations.index @station
    length = @route.stations.length
    if index == length - 1
      false
    else
      @route.stations[index + 1]
    end
  end

  def previous_station
    index = @route.stations.index @station
    if index.zero?
      false
    else
      @route.stations[index - 1]
    end
  end
end
