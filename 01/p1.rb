#!/usr/bin/env ruby
# frozen_string_literal: true

def parse(s)
  nums = s.gsub(/[a-z]/, '').split('')
  "#{nums.first}#{nums.last}".to_i
end

puts $stdin.each_line
           .map { |line| parse(line.chomp) }
           .sum
