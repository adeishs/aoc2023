#!/usr/bin/env ruby
# frozen_string_literal: true

def find_row(rows)
  i = [*1...rows.size].map { |y| [y, [y, rows.size - y].min] }
                      .index { |y, w| rows[y - w, w] == rows[y, w].reverse }
  i.nil? ? 0 : i + 1
end

def solve(rows)
  100 * find_row(rows) +
    find_row(rows.map(&:chars).transpose.map { |cols| cols.join('') })
end

puts $stdin.read
           .split("\n\n")
           .map { |pattern| solve(pattern.split("\n")) }
           .sum
