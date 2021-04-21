# frozen_string_literal: true

require_relative './instance_counter'
require_relative './accessors'
require_relative './validation'

class Route
  include InstanceCounter
  include Validation
  extend Acсessors

  @@instances = {}

  #  attr_reader :stations, :route_name
  attr_accessor_with_history :stations, :route_name
  strong_attr_accessor(:some_attr, 'Route')

  def initialize(initial_station, end_station)
    @stations = [initial_station, end_station]
    @route_name = "#{@stations[0].name}-#{@stations[1].name}"
    @@instances[@route_name] = self

    init_validations
    validate!
    register_instance
  end

  def init_validations
    self.class.validate @route_name, :presence
    self.class.validate @type_class, :type, 'Route'
  end

  def add_station(station)
    @stations.insert(-2, station) unless validate_station? station
  end

  def remove_station(station)
    @stations.delete(station) unless validate_station? station
  end

  def stations_list
    @stations
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  private

  def validate_station?(station)
    @stations.find { |i| i[:name] == station[:name] }
  end
end
