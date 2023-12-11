#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

EXP_SIZE = 999_999

def parse_input(input)
  input.split("\n").map(&:chars).map.with_index do |cols, y|
    cols.map.with_index { |point, x| point == '#' ? Complex(x, y) : nil }
  end.flatten.reject(&:nil?)
end

def get_universe_borders(galaxy_locs)
  border = {
    min: {
      x: Float::INFINITY,
      y: Float::INFINITY
    },
    max: {
      x: -Float::INFINITY,
      y: -Float::INFINITY
    }
  }
  galaxy_locs.each do |l|
    border[:min][:x] = [l.real, border[:min][:x]].min
    border[:min][:y] = [l.imag, border[:min][:y]].min
    border[:max][:x] = [l.real, border[:max][:x]].max
    border[:max][:y] = [l.imag, border[:max][:y]].max
  end

  border
end

def get_universe_attrs(galaxy_locs)
  border = get_universe_borders(galaxy_locs)
  empty_rows = [
    *border[:min][:y] + 1..border[:max][:y] - 1
  ].select { |y| galaxy_locs.none? { |l| l.imag == y } }.sort { |a, b| b <=> a }
  empty_cols = [
    *border[:min][:x] + 1..border[:max][:x] - 1
  ].select { |x| galaxy_locs.none? { |l| l.real == x } }.sort { |a, b| b <=> a }

  {
    border: border,
    empty_rows: empty_rows,
    empty_cols: empty_cols
  }
end

def expand_universe(galaxy_locs)
  attr = get_universe_attrs(galaxy_locs)

  attr[:empty_rows].each do |r|
    galaxy_locs = galaxy_locs.map do |l|
      Complex(l.real, l.imag + (l.imag > r ? EXP_SIZE : 0))
    end
  end
  attr[:empty_cols].each do |c|
    galaxy_locs = galaxy_locs.map do |l|
      Complex(l.real + (l.real > c ? EXP_SIZE : 0), l.imag)
    end
  end

  galaxy_locs
end

def calc_dist(a, b)
  d = a - b
  d.real.abs + d.imag.abs
end

puts expand_universe(parse_input($stdin.read)).combination(2)
                                              .map { |a, b| calc_dist(a, b) }
                                              .sum
