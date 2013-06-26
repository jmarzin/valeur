# newton_raphson_irr_calculator.rb - Calculate the Internal rate of return for a given set of cashflows.
# Zainco Ltd
# Author: Joseph A. Nyirenda <joseph.nyirenda@gmail.com>
#             Mai Kalange<code5p@yahoo.co.uk>
# Copyright (c) 2008 Joseph A. Nyirenda, Mai Kalange, Zainco Ltd
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of version 2 of the GNU General Public
# License as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.
class NewtonRaphsonIrrCalculator
  MIN_NO_CASH_FLOW_PERIODS = 2
  @@tolerance = 0.00000001
  attr_reader :cash_flows, :attempts, :guess, :result
  def self.calculate(flows, max_iterations=100, initial_guess=nil)
    calculator = NewtonRaphsonIrrCalculator.new
    calculator.guess = initial_guess if initial_guess
    calculator.max_iterations = max_iterations
    calculator.cash_flows = flows
    calculator.calculate
  end
  def initialize()
    @number_of_iterations = 0
    @result = nil
    @track_attempts = false
    @attempts = [] if @track_attempts
    @max_iterations = 100
  end
  def track_attempts=(track_iterations)
    @attempts = nil unless track_iterations
    @attempts = [] if track_iterations
    @track_attempts = track_iterations
  end
  def max_iterations=(maximum_iterations)
    @max_iterations = maximum_iterations
  end
  def cash_flows=(cash_flows)
    @cash_flows = cash_flows
  end
  def guess=(guess)
    @guess = guess
  end

  def is_valid_cash_flows?
    @cash_flows && @cash_flows.length >= MIN_NO_CASH_FLOW_PERIODS && @cash_flows[0] < 0
  end
  def attempts_tracked?
    @track_attempts
  end

  def calculate
    if is_valid_cash_flows?
      do_calculation(initial_guess)
    end
    @result
  end
private
  def initial_guess
    unless @guess
      @guess = 0.0
      @guess = -1.0 * (1.0 + (@cash_flows[1] / @cash_flows[0])) if is_valid_cash_flows?
      @guess = -0.999999999 if guess <= -1
    end
    @guess
  end
  def do_calculation(estimated_return)
    @number_of_iterations += 1
    @result = (estimated_return - sum_of_irr_polynomial(estimated_return) / irr_derivative_sum(estimated_return)).to_f
    @attempts << [@number_of_iterations, @result] if @track_attempts
    while !has_converged?(@result) && @number_of_iterations < @max_iterations
      do_calculation(@result)
    end
    @result
  end
  def sum_of_irr_polynomial(estimated_return)
    sum_of_polynomial = 0.0
    if is_valid_iteration_bounds? estimated_return
      (0...@cash_flows.length).each do |idx|
        sum_of_polynomial += @cash_flows[idx] / ((1.0 + estimated_return)**(idx.to_f))
      end
    end
    sum_of_polynomial
  end
  def has_converged?(estimated_return)
    (sum_of_irr_polynomial(estimated_return)).abs <= @@tolerance
  end
  def irr_derivative_sum(estimated_return)
    sum_of_derivative = 0.0
    if is_valid_iteration_bounds?(estimated_return)
      (1...@cash_flows.length).each do |idx|
        sum_of_derivative += @cash_flows[idx] * idx.to_f / ((1.0 + estimated_return)**(idx.to_f))
      end
    end
    sum_of_derivative *= -1.0
    sum_of_derivative
  end
  def is_valid_iteration_bounds?(estimated_return)
    estimated_return != -1.0 && (estimated_return < Float::MAX && estimated_return > -Float::MAX)
  end
end
