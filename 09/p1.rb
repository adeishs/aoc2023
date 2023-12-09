#!/usr/bin/env ruby
# frozen_string_literal: true

def get_next_val(nums)
  u = nums.uniq
  return u[0] if u.size == 1

  ds = [*1...nums.size].map { |i| nums[i] - nums[i - 1] }
  return nums.last + get_next_val(ds)
end

puts $stdin.each_line
           .map { |line| get_next_val(line.split(' ').map(&:to_i)) }
           .sum
