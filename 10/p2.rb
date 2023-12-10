#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def find_animal(pipes)
  pipes.each_with_index do |cols, y|
    cols.each_with_index do |pipe, x|
      return Complex(x, y) if pipe == 'S'
    end
  end
end

DIR_PIPES = {
  0 - 1i => ['|', '7', 'F'],
  0 + 1i => ['|', 'L', 'J'],
  -1 + 0i => ['-', 'L', 'F'],
  1 + 0i => ['-', 'J', '7']
}.freeze

def get_open_pipes_from_animal(pipes, animal_pos)
  DIR_PIPES.map do |k, v|
    [k, v.include?(pipes[animal_pos.imag + k.imag][animal_pos.real + k.real])]
  end.to_h
end

DIRS_PIPE = {
  [0 - 1i, 0 + 1i] => '|',
  [0 - 1i, -1 + 0i] => 'J',
  [0 - 1i, 1 + 0i] => 'L',
  [0 + 1i, -1 + 0i] => '7',
  [0 + 1i, 1 + 0i] => 'F',
  [-1 + 0i, 1 + 0i] => '-'
}.freeze

PIPE_DIRS = DIRS_PIPE.invert

def get_animal_pipe(pipes, animal_pos)
  opens = get_open_pipes_from_animal(pipes, animal_pos)

  DIRS_PIPE.each do |dirs, pipe|
    return pipe if dirs.all? { |dir| opens[dir] }
  end

  nil
end

def parse_input(input)
  pipes = input.split("\n").map(&:chars)
  animal_pos = find_animal(pipes)
  pipes[animal_pos.imag][animal_pos.real] = get_animal_pipe(pipes, animal_pos)

  {
    pipes: pipes,
    animal_pos: animal_pos
  }
end

def get_next_pipe_pos(pipes, curr_pos, visited_coords)
  PIPE_DIRS[pipes[curr_pos.imag][curr_pos.real]].each do |d|
    next_pos = curr_pos + d
    return next_pos unless visited_coords.member?(next_pos)
  end

  nil
end

def get_loop_coords(input)
  curr = input[:animal_pos]
  visited_coords = Set.new([curr])
  until curr.nil?
    curr = get_next_pipe_pos(input[:pipes], curr, visited_coords)
    visited_coords << curr unless curr.nil?
  end

  visited_coords
end

def junk?(pipes, x, y)
  # if one end is closed or clear, it’s junk
  PIPE_DIRS[pipes[y][x]].each do |pd|
    ax = x + pd.real
    ay = y + pd.imag
    next if ax.between?(0, pipes[y].size - 1) &&
            ay.between?(0, pipes.size - 1) &&
            pipes[ay][ax] != '.' &&
            DIR_PIPES[pd].include?(pipes[ay][ax])

    return true
  end

  false
end

def clear_junk(pipes, loop_coords)
  loop do
    new_pipes = pipes.map { |py| py.map { |px| px } }
    changed = false
    [*0...pipes.size].each do |y|
      [*0...pipes[y].size].each do |x|
        next if loop_coords.member?(Complex(x, y)) ||
                !PIPE_DIRS[pipes[y][x]] ||
                !junk?(pipes, x, y)

        new_pipes[y][x] = '.'
        changed = true
        break
      end
    end

    return new_pipes unless changed

    pipes = new_pipes
  end
end

SOUTH_PIPES = DIRS_PIPE.select { |dirs, _| dirs.any? { |d| d == 0 + 1i } }
                       .values
NORTH_PIPES = DIRS_PIPE.select { |dirs, _| dirs.any? { |d| d == 0 - 1i } }
                       .values

def crossed?(pipes, halfpoint_coord, dir)
  check_x = (halfpoint_coord.real + dir * 0.5).to_i
  SOUTH_PIPES.include?(pipes[(halfpoint_coord.imag - 0.5).to_i][check_x]) &&
    NORTH_PIPES.include?(pipes[(halfpoint_coord.imag + 0.5).to_i][check_x])
end

def inside?(pipes, halfpoint_coord)
  inside = false
  max_x = pipes[0].size
  dir = halfpoint_coord.real <=> (max_x / 2)
  wall = Complex(dir == 1 ? max_x : 0, halfpoint_coord.imag)
  c = halfpoint_coord
  while dir == (wall.real <=> c.real)
    inside = !inside if crossed?(pipes, c, dir)
    c += dir
  end

  inside
end

def get_inside_halfpoints(pipes, _loop_coords)
  points = Set.new
  pipes[0...pipes.size - 1].each_with_index do |cols, y|
    cols[0...cols.size - 1].each_with_index do |_, x|
      halfpoint_coord = Complex(x + 0.5, y + 0.5)
      points << halfpoint_coord if inside?(pipes, halfpoint_coord)
    end
  end

  points
end

def all_adjacent_halfpoints?(coord, halfpoint_coords)
  [
    Complex(coord.real + 1, coord.imag),
    Complex(coord.real, coord.imag + 1),
    Complex(coord.real + 1, coord.imag)
  ].all? { |a| halfpoint_coords.member?(a) }
end

def get_inside_coords(pipes, loop_coords)
  halfpoint_coords = get_inside_halfpoints(pipes, loop_coords)

  halfpoint_coords.select { |c| all_adjacent_halfpoints?(c, halfpoint_coords) }
                  .map { |c| Complex((c.real + 0.5).to_i, (c.imag + 0.5).to_i) }
                  .reject { |c| loop_coords.member?(c) }
end

input = parse_input($stdin.read)
loop_coords = get_loop_coords(input)
pipes = clear_junk(input[:pipes], loop_coords)

puts get_inside_coords(pipes, loop_coords).size
