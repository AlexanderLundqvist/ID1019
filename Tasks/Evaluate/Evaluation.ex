defmodule Evaluation do

  @type literal() :: {:num, number()} | {:var, atom()} | | {:q, number(), number()}

  @type expression() :: literal()
  | {:add, expression(), expression()}
  | {:sub, expression(), expression()}
  | {:mul, expression(), expression()}
  | {:div, expression(), expression()}


  def eval({:num, number}, number) do {:num, number} end

  def eval({:var, x}, x) do {:var, x} end

  def eval({:add, expression1, expression2}, x) do
    add({expression1}, {})
  end

  def eval({:sub, ..., ...}, ...) do
    sub(..., ...)
  end

  def eval({:mul, ..., ...}, ...) do
    mul(..., ...)
  end

  def eval({:div, ..., ...}, ...) do
    div(..., ...)
  end

  def add({:num, number1}, {:num, number2}) do
    number1 + number2
  end

  def add({:num, number1}, {:num, number2}) do
    number1 + number2
  end

end
