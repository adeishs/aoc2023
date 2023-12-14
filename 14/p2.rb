#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

ROUNDED = 'O'
CUBE = '#'
EMPTY = '.'

def get_cube_idxs(line)
  # add pretend cube rocks at the edges
  [-1].concat((0...line.size).find_all { |i| line[i] == CUBE })
      .append(line.size)
end

def get_total_load(rows)
  rows.reverse
      .map.with_index { |line, i| (line.chars.tally[ROUNDED] || 0) * (i + 1) }
      .sum
end

def get_cube_locs(rows)
  Set.new(
    rows.flat_map.with_index do |line, y|
      get_cube_idxs(line).map { |x| Complex(x, y) }
    end.concat(
      (0...rows[0].size).flat_map { |x| [x + -1i, Complex(x, rows.size)] }
    )
  ).sort { |a, b| [a.imag, a.real] <=> [b.imag, b.real] }
end

def tilt_horiz(rows, cube_locs, dir)
  new_rows = Marshal.load(Marshal.dump(rows))
  rocks = [ROUNDED, EMPTY]
  rocks.rotate! if dir == 1
  [*0...rows.size].each do |y|
    c_idxs = cube_locs.select { |l| l.imag == y }.map(&:real)
    (c_idxs.size - 1).times do
      s = c_idxs.shift + 1
      e = c_idxs.first
      cnt = rows[y][s...e].chars.tally
      str = rocks.map { |r| [r, r * (cnt[r] || 0)] }.to_h
      new_rows[y][s...e] = "#{str[rocks.first]}#{str[rocks.last]}"
    end
  end
  new_rows
end

def tilt_vert(rows, cube_locs, dir)
  new_rows = Marshal.load(Marshal.dump(rows))
  [*0...rows[0].size].each do |x|
    c_idxs = cube_locs.select { |l| l.real == x }.map(&:imag)
    (c_idxs.size - 1).times do
      s = c_idxs.shift + 1
      e = c_idxs.first
      cnt = (s...e).map { |y| rows[y][x] }.tally
      (s...e).each do |y|
        o = y - s
        new_rows[y][x] = if dir == - 1
                           o < (cnt[ROUNDED] || 0) ? ROUNDED : EMPTY
                         else
                           o < (cnt[EMPTY] || 0) ? EMPTY : ROUNDED
                         end
      end
    end
  end
  new_rows
end

def tilt(rows, cube_locs, dir)
  args = [rows, cube_locs, dir.real + dir.imag]
  dir.imag.zero? ? tilt_horiz(*args) : tilt_vert(*args)
end

M = { 100 => 34, 10 => 7 }.freeze
O = { 100 => 95, 10 => 2 }.freeze
def cycle_tilt(rows, cube_locs)
  o = O[rows.size] || 0
  t = 1_000_000_000
  ((t - o) % (M[rows.size] || (t + 1)) + o).times do
    [0 + -1i, -1 + 0i, 0 + 1i, 1 + 0i].each do |dir|
      rows = tilt(rows, cube_locs, dir)
    end
  end
  rows
end

rows = $stdin.read.split("\n")
cube_locs = get_cube_locs(rows)
puts get_total_load(cycle_tilt(rows, cube_locs))
