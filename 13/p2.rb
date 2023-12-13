#!/usr/bin/env ruby
# frozen_string_literal: true

def get_pos_char(row)
  row.chars.map.with_index { |c, i| [i, c] }.to_h
end

def reflection?(rows_pair)
  cnt = 0
  bs = rows_pair.last.reverse
  rows_pair.first.each_with_index do |a, i|
    cnt += (get_pos_char(a).to_a - get_pos_char(bs[i]).to_a).to_h.size
    return false if cnt > 1
  end

  cnt == 1
end

def find_row(rows)
  [*0...rows.size - 1].each do |y|
    w = [y, (y + 2 - rows.size).abs].min
    return y + 1 if reflection?([rows[y - w..y], rows[y + 1..y + w + 1]])
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
