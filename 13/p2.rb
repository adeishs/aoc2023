#!/usr/bin/env ruby
# frozen_string_literal: true

def get_pos_chars(row)
  row.chars.map.with_index { |c, i| [i, c] }
end

def mirrored?(rows_pair)
  smudge_count = 0
  bs = rows_pair.last.reverse

  # exactly one smudge must exist, so, just bail out early if more are found
  rows_pair.first.each_with_index do |a, i|
    smudge_count += (get_pos_chars(a) - get_pos_chars(bs[i])).to_h.size
    return false if smudge_count > 1
  end

  smudge_count == 1
end

def find_row(rows)
  i = [*1...rows.size].map { |y| [y, [y, rows.size - y].min] }
                      .index { |y, w| mirrored?([rows[y - w, w], rows[y, w]]) }
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
