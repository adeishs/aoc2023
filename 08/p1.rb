#!/usr/bin/env ruby
# frozen_string_literal: true

def parse_input(input)
  inst_str, path_str = input.split("\n\n")
  insts = inst_str.tr('LR', '01').chars.map(&:to_i)
  {
    insts: insts,
    path: path_str.split("\n")
                  .map do |l|
            src, dest_str = l.split(' = ')
            [src, dest_str[1...-1].split(', ')]
          end.to_h
  }
end

def count_steps(input, start, &finish_cond)
  s = 0
  curr = start
  until finish_cond.call(curr)
    dir = input[:insts][s % input[:insts].size]
    curr = input[:path][curr][dir]
    s += 1
  end
  s
end

puts count_steps(parse_input($stdin.read), 'AAA') { |n| n == 'ZZZ' }
