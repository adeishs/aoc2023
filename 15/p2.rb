#!/usr/bin/env ruby
# frozen_string_literal: true

def hash(step)
  v = 0
  step.chars.each do |c|
    v = (17 * (v + c.ord)) & 0xff
  end
  v
end

def get_op(step)
  label, foc_len_s = step.split(/[=-]/)
  [label, hash(label), foc_len_s]
end

def run_steps(steps)
  boxes = Array.new(256) { {} }
  steps.each do |step|
    label, h, foc_len_s = get_op(step)
    if foc_len_s.nil?
      boxes[h].delete(label)
    else
      boxes[h][label] = foc_len_s
    end
  end
  boxes
end

puts run_steps(
  $stdin.each_line.map { |line| line.chomp.split(',') }.first
).flat_map.with_index { |slots, bi|
  slots.map.with_index { |slot, si| (bi + 1) * (si + 1) * slot.last.to_i }
}.sum
