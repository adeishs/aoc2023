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
  run_beam(tiles, Complex(start), Complex(dir), energs)
  energs.size
}
max_x = tiles.first.size - 1
max_y = tiles.size - 1
run = lambda { |range_e, start, dir|
  (0..range_e).map { |c| count_energs.call(start.gsub('[]', c.to_s), dir) }.max
}
puts [
  [['[]i', '1'], ["#{max_x}+[]i", '-1']].map { |s, d| run.call(max_y, s, d) },
  [['[]', 'i'], ["[]+#{max_y}i", '-i']].map { |s, d| run.call(max_x, s, d) }
].flatten.max
