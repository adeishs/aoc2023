#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def run_beam(tiles, start, dir, energs)
  curr = start
  until curr.rect.include?(-1) ||
        curr.imag == tiles.size ||
        curr.real == tiles.first.size
    energs[curr] = Set.new if energs[curr].nil?
    break if energs[curr].member?(dir)

    energs[curr] = energs[curr] << dir
    t = tiles[curr.imag][curr.real]
    if t == '-' && dir.real.zero?
      [-1, 1].each { |r| run_beam(tiles, curr + r, r, energs) }
      break
    elsif t == '|' && dir.imag.zero?
      [-1, 1].map { |i| Complex(0, i) }
             .each { |d| run_beam(tiles, curr + d, d, energs) }
      break
    end

    if (t == '/' && dir.real.zero?) || (t == '\\' && dir.imag.zero?)
      dir *= 0 + 1i
    elsif (t == '/' && dir.imag.zero?) || (t == '\\' && dir.real.zero?)
      dir *= 0 + -1i
    end

    curr += dir
  end
end

tiles = $stdin.each_line
              .map(&:chomp)
count_energs = lambda { |start, dir|
  energs = {}
  run_beam(tiles, start, dir, energs)
  energs.size
}
max_x = tiles.first.size - 1
max_y = tiles.size - 1
puts [
  (0..max_y).map { |y| count_energs.call(Complex(0, y), 1 + 0i) }.max,
  (0..max_y).map { |y| count_energs.call(Complex(max_x - 1, y), -1 + 0i) }.max,
  (0..max_x).map { |x| count_energs.call(Complex(x, 0), 0 + 1i) }.max,
  (0..max_x).map { |x| count_energs.call(Complex(x, max_y - 1), 0 + -1i) }.max
].max
