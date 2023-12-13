#!/usr/bin/env ruby
# frozen_string_literal: true

def find_row(rows)
  [*0...rows.size - 1].each do |y|
    w = [y, (y + 2 - rows.size).abs].min
    return y + 1 if rows[y - w..y] == rows[y + 1..y + w + 1].reverse
  end

  0
end

def solve(rows)
  100 * find_row(rows) +
    find_row(rows.map(&:chars).transpose.map { |cols| cols.join('') })
end

puts $stdin.read
           .split("\n\n")
           .map { |pattern| solve(pattern.split("\n")) }
           .sum
