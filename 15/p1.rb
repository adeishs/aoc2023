#!/usr/bin/env ruby
# frozen_string_literal: true

def solve(step)
  v = 0
  step.chars.each do |c|
    v = (17 * (v + c.ord)) & 0xff
  end
  v
end

puts($stdin.each_line
           .map { |line| line.chomp.split(',').map { |step| solve(step) }.sum })
