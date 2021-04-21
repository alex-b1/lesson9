# frozen_string_literal: true

require_relative './carriage'

class PassengerCarriage < Carriage
  TYPE = :passenger

  attr_reader :number_seats

  def initialize(number_seats)
    @number_seats = number_seats
    @seats = {}
    @number_seats.times { |i| @seats[(i + 1).to_s] = 'свободно' }
  end

  def type
    TYPE
  end

  def take_seat(number)
    @seats[number] = 'занято'
  end

  def occupied_seats
    count = 0
    @seats.each do |_k, v|
      count += 1 if v == 'занято'
    end
    count
  end

  def free_seats
    count = 0
    @seats.each do |_k, v|
      count += 1 if v == 'свободно'
    end
    count
  end
end
