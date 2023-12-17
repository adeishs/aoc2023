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

    energs[curr] <<= dir
    t = tiles[curr.imag][curr.real]
    if t == '-' && dir.real.zero?
      [-1, 1].each { |r| run_beam(tiles, curr + r, r, energs) }
      break
    elsif t == '|' && dir.imag.zero?
      [-1i, 1i].each { |d| run_beam(tiles, curr + d, d, energs) }
      break
    end

    if (t == '/' && dir.real.zero?) || (t == '\\' && dir.imag.zero?)
      dir *= 1i
    elsif (t == '/' && dir.imag.zero?) || (t == '\\' && dir.real.zero?)
      dir *= -1i
    end

    curr += dir
  end
  energs.size
end

tiles = $stdin.each_line.map(&:chomp)
max_x = tiles.first.size - 1
max_y = tiles.size - 1
puts [
  [max_y].product([['[]i', '1'], ["#{max_x}+[]i", '-1']]),
  [max_x].product([['[]', 'i'], ["[]+#{max_y}i", '-i']])
].map(&:flatten).map { |e, s, d|
  (0..e).map do |c|
    run_beam(tiles, Complex(s.sub('[]', c.to_s)), Complex(d), {})
  end.max
}.max
