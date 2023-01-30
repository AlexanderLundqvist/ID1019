defmodule Evaluation do

  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div, expr(), expr()}


  def eval({:num, _number}, _number) do number end

  def eval({:var, x}, x) do x end

  def eval({:add, ..., ...}, ...) do
    add(..., ...)
  end

  def eval({:add, ..., ...}, ...) do
    add(..., ...)
  end

  def eval({:add, ..., ...}, ...) do
    add(..., ...)
  end

end
