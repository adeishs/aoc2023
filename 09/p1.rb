#!/usr/bin/env ruby
# frozen_string_literal: true

def get_next_val(nums)
  return nums[0] if nums.uniq.size == 1

  nums.last + get_next_val([*1...nums.size].map { |i| nums[i] - nums[i - 1] })
end

puts $stdin.each_line
           .map { |line| get_next_val(line.split(' ').map(&:to_i)) }
           .sum
