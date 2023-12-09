#!/usr/bin/env ruby
# frozen_string_literal: true

def get_next_val(nums)
  return nums[0] if nums.uniq.size == 1

  nums.last + get_next_val(nums.each_cons(2).map { |ns| ns[1] - ns[0] })
end

puts $stdin.each_line
           .map { |line| get_next_val(line.split(' ').map(&:to_i)) }
           .sum
