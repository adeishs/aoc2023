#!/usr/bin/env ruby
# frozen_string_literal: true

def parse_input(input_str)
  input_str.split("\n")
           .map { |l| l.split(':').last.gsub(' ', '').to_i }
end

t, d = parse_input($stdin.read)
puts [*0..t].select { |h| h * (t - h) > d }.size
