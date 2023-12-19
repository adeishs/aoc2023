#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def eval_wf(workflow, workflow_str, rating, curr_workflow_name)
  cond_str, then_str = workflow_str.split(':', 2)

  thens = then_str.split(',', 2)
  ret = {
    true => thens.shift,
    false => thens.shift
  }
  reg_name, operator, operand_str = cond_str.split('', 3)

  ret_val = ret[rating[reg_name].send(operator, operand_str.to_i)]
  return curr_workflow_name if ret_val == 'A' || ret[ret_val] == 'A'
  return nil if ret_val == 'R' || ret[ret_val] == 'R'

  if ret_val.index(/[<>]/).nil?
    eval_wf(workflow, workflow[ret_val], rating, ret_val)
  else
    eval_wf(workflow, ret_val, rating, curr_workflow_name)
  end
end

def parse_input(input)
  workflow_str, rating_str = input.split("\n\n")

  [
    workflow_str.split("\n")
                .map { |s| s[0...-1].split('{') }
                .to_h,
    rating_str.split("\n")
              .map do |line|
                line[1...-1].split(',').map do |e|
                  name, val_str = e.split('=')
                  [name, val_str.to_i]
                end.to_h
              end
  ]
end

workflow, ratings = parse_input($stdin.read)
puts ratings.reject { |r| eval_wf(workflow, workflow['in'], r, 'in').nil? }
            .map { |r| r.values.sum }
            .sum
