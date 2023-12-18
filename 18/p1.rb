#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

class Movement
  attr_accessor :dir, :dist, :clr

  def initialize(dir, dist, clr)
    @dir = dir
    @dist = dist
    @clr = clr
  end
end

DIR = {
  'L' => -1 + 0i,
  'R' => 1 + 0i,
  'U' => 0 + -1i,
  'D' => 0 + 1i
}.freeze

def crossed?(cube, halfpoint_coord, dir)
  top_coord = Complex(
    (halfpoint_coord.real + dir * 0.5).to_i,
    (halfpoint_coord.imag - 0.5).to_i
  )
  !cube[top_coord].nil? && !cube[top_coord + DIR['D']].nil?
end

def inside?(plan, halfpoint_coord)
  inside = false
  dir = halfpoint_coord.real <=> ((plan[:max_x] - plan[:min_x]) / 2)
  wall = Complex(
    dir == 1 ? plan[:max_x] + 1 : plan[:min_x] - 1, halfpoint_coord.imag
  )
  c = halfpoint_coord
  while dir == (wall.real <=> c.real)
    inside = !inside if crossed?(plan[:cube], c, dir)
    c += dir
  end

  inside
end

def get_inside_halfpoints(plan)
  Set.new(
    (plan[:min_y]..plan[:max_y]).map do |y|
      (plan[:min_x]..plan[:max_x]).map do |x|
        halfpoint_coord = Complex(x + 0.5, y + 0.5)
        inside?(plan, halfpoint_coord) ? halfpoint_coord : nil
      end
    end.flatten.reject(&:nil?)
  )
end

def all_adjacent_halfpoints?(coord, halfpoint_coords)
  [
    Complex(coord.real + 1, coord.imag),
    Complex(coord.real, coord.imag + 1),
    Complex(coord.real + 1, coord.imag)
  ].all? { |a| halfpoint_coords.member?(a) }
end

def get_inside_coords(plan)
  halfpoint_coords = get_inside_halfpoints(plan)
  halfpoint_coords.select { |c| all_adjacent_halfpoints?(c, halfpoint_coords) }
                  .map { |c| Complex((c.real + 0.5).to_i, (c.imag + 0.5).to_i) }
                  .select { |c| plan[:cube][c].nil? }
end

def parse_line(line)
  dir_str, dist_str, clr_str = line.split(' ')
  Movement.new(DIR[dir_str], dist_str.to_i, clr_str[2, 6].to_i(16))
end

def construct_plan(steps)
  cube = {}
  curr = 0 + 0i
  min_x = min_y = Float::INFINITY
  max_x = max_y = -Float::INFINITY
  steps.each do |step|
    step.dist.times do
      cube[curr] = step.clr
      min_x = [min_x, curr.real].min
      max_x = [curr.real, max_x].max
      min_y = [min_y, curr.imag].min
      max_y = [curr.imag, max_y].max
      curr += step.dir
    end
  end
  {
    cube: cube,
    min_x: min_x,
    max_x: max_x,
    min_y: min_y,
    max_y: max_y
  }
end

plan = construct_plan($stdin.each_line.map { |l| parse_line(l) })
puts get_inside_coords(plan).size + plan[:cube].size
