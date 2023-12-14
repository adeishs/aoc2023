#!/usr/bin/env ruby
# frozen_string_literal: true

ROUNDED = 'O'
CUBE = '#'

# sum of arithmetic series (d = –1):
def series_sum(s_start, num)
  (2 * s_start + 1 - num) * num / 2
end

def get_series_round_count(line, range)
  range.find_all { |i| line[i] == ROUNDED }.size
end

def get_cube_idxs(line)
  # add pretend cube rocks at the edges
  [-1].concat((0...line.size).find_all { |i| line[i] == CUBE })
      .append(line.size)
end

def get_line_load(line)
  c_idxs = get_cube_idxs(line)
  (1...c_idxs.size).map do |_|
    s = c_idxs.shift + 1
    series_sum(line.size - s, get_series_round_count(line, s...c_idxs.first))
  end.sum
end

def get_total_load(rows)
  rows.map(&:chars).transpose
      .map { |line| get_line_load(line) }
      .sum
end

puts get_total_load($stdin.read.split("\n"))
