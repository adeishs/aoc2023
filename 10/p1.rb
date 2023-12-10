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

def get_open_pipes_from_animal(pipes, animal_pos)
  {
    0 - 1i => ['|', '7', 'F'],
    0 + 1i => ['|', 'L', 'J'],
    -1 + 0i => ['-', 'L', 'F'],
    1 + 0i => ['-', 'J', '7']
  }.map do |k, v|
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

def get_loop_len(input)
  curr = input[:animal_pos]
  visited_coords = Set.new([curr])
  until curr.nil?
    curr = get_next_pipe_pos(input[:pipes], curr, visited_coords)
    visited_coords << curr unless curr.nil?
  end

  visited_coords.size
end

input = parse_input($stdin.read)
puts (get_loop_len(input) + 1) / 2
