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

input = parse_input($stdin.read)
puts input[:path].keys.select { |n| n[-1] == 'A' }
                 .map { |curr|
       s = 0
       until curr[-1] == 'Z'
         dir = input[:insts][s % input[:insts].size]
         curr = input[:path][curr][dir]
         s += 1
       end
       s
     }.reduce(1, :lcm)
