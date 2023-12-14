#!/usr/bin/env ruby
# frozen_string_literal: true

ROUNDED = 'O'
CUBE = '#'
EMPTY = '.'

# sum of arithmetic series (d = –1):
def series_sum(a, n)
  (2 * a + 1 - n) * n / 2
end

def get_series_round_count(line, s_idx, e_idx)
  (s_idx..e_idx).find_all { |i| line[i] == ROUNDED }.size
end

def get_line_load(line)
  c_idxs = (0...line.size).find_all { |i| line[i] == CUBE }
  prev = -1
  c_idxs.map do |curr|
    s = prev + 1
    r_cnt = get_series_round_count(line, s, curr - 1)
    prev = curr
    series_sum(line.size - s, r_cnt)
  end.append(
    series_sum(
      line.size - (prev + 1),
      get_series_round_count(line, prev + 1, line.size - 1)
    )
  ).sum
end

def solve(rows)
  rows.map(&:chars).transpose
      .map { |line| get_line_load(line) }
      .sum
end

puts solve($stdin.read.split("\n"))
