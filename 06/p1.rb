#!/usr/bin/env ruby
# frozen_string_literal: true

def parse_input(input_str)
  input_str.split("\n")
           .map { |l| l.split(':').last.strip.split(/ +/).map(&:to_i) }
end

ts, ds = parse_input($stdin.read)
puts ts.map.with_index { |t, i|
  [*0..t].select { |h| h * (t - h) > ds[i] }.size
}.reduce(:*)
