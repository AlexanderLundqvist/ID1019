defmodule Evaluation do

  @type literal() :: {:num, number()}
  | {:var, atom()}
  | {:quot, number(), number()}

  @type expression() :: literal()
  | {:add, expression(), expression()}
  | {:sub, expression(), expression()}
  | {:mul, expression(), expression()}
  | {:div, expression(), expression()}

  # Any single number is just evaluated to itself.
  def evaluate({:num, number}, _environment) do number end

  # For the evaluation of a variable we have to look in the environment to find the value bound to the variable.
  # The environment is implemented with Elixir's Map module.
  def evaluate({:var, variable}, environment) do Map.get(environment, variable) end

  # Fractional numbers are evaluated to the lowest common denominator.
  def evaluate({:quot, numerator, denominator}, _environment) do
    #gcd = numerator |> Integer.gcd(denominator)
    gcd = Integer.gcd(numerator, denominator)
    {:quot, numerator/gcd, denominator/gcd}
  end

  # The evaluation functions passes the expressions and the environment to corresponding arithmetic operation functions.
  def evaluate({:add, expression1, expression2}, environment) do
    add(evaluate(expression1, environment), evaluate(expression2, environment))
  end
  def evaluate({:sub, expression1, expression2}, environment) do
    sub(evaluate(expression1, environment), evaluate(expression2, environment))
  end
  def evaluate({:mul, expression1, expression2}, environment) do
    mul(evaluate(expression1, environment), evaluate(expression2, environment))
  end
  def evaluate({:div, expression1, expression2}, environment) do
    div(evaluate(expression1, environment), evaluate(expression2, environment))
  end


  # ----------------------------------- Addition ------------------------------------

  # Addition with zero.
  defp add({:num, number}, {:num, 0}) do {:num, number} end
  defp add({:num, 0}, {:num, number}) do {:num, number} end

  # Addition between two numbers.
  defp add({:num, number1}, {:num, number2}) do {:num, number1+number2} end

  # Addition between a number and a fraction.
  defp add({:num, number}, {:quot, numerator, denominator}) do
    {:quot, number*denominator + numerator, denominator}
  end
  defp add({:quot, numerator, denominator}, {:num, number}) do
    {:quot, number*denominator + numerator, denominator}
  end

  # Addition between two fractions.
  defp add({:quot, numerator1, denominator1}, {:quot, numerator2, denominator2}) do
    {:quot, numerator1*denominator2 + numerator2*denominator1, denominator1*denominator2}
  end

  # ---------------------------------- Subtraction ----------------------------------

  # Subtraction with zero.
  defp sub({:num, number}, {:num, 0}) do {:num, number} end
  defp sub({:num, 0}, {:num, number}) do {:num, number} end

  # Subtraction between two numbers.
  defp sub({:num, number1}, {:num, number2}) do {:num, number1-number2} end

  # Subtraction between a number and a fraction.
  defp sub({:num, number}, {:quot, numerator, denominator}) do
    {:quot, number*denominator - numerator, denominator}
  end
  defp sub({:quot, numerator, denominator}, {:num, number}) do
    {:quot, number*denominator - numerator, denominator}
  end

  # Subtraction between two fractions.
  defp sub({:quot, numerator1, denominator1}, {:quot, numerator2, denominator2}) do
    {:quot, numerator1*denominator2 - numerator2*denominator1, denominator1*denominator2}
  end

  # -------------------------------- Multiplication ---------------------------------

  # Multiplication with zero.
  defp mul(_number, {:num, 0}) do {:num, 0} end
  defp mul({:num, 0}, _number) do {:num, 0} end

  # Multiplication between two numbers.
  defp mul({:num, number1}, {:num, number2}) do {:num, number1*number2} end

  # Multiplication between a number and a fraction.
  defp mul({:num, number}, {:quot, numerator, denominator}) do {:quot, number*numerator, denominator} end
  defp mul({:quot, numerator, denominator}, {:num, number}) do {:quot, number*numerator, denominator} end

  # Multiplication between two fractions.
  defp mul({:quot, numerator1, denominator1}, {:quot, numerator2, denominator2}) do
    {:quot, numerator1*numerator2, denominator1*denominator2}
  end

  # ----------------------------------- Division ------------------------------------

  # Division with zero.
  defp div(_number, {:num, 0}) do :undefined end

  # Division with zero over anything.
  defp div({:num, 0}, _number) do {:num, 0} end

  # Division between two numbers.
  defp div({:num, number1}, {:num, number2}) do {:quot, number1, number2} end

  # Division between a number and a fraction.
  defp div({:num, number}, {:quot, numerator, denominator}) do
    {:quot, number*denominator, numerator}
  end
  defp div({:quot, numerator, denominator}, {:num, number}) do
    {:quot, numerator, number*denominator}
  end

  # Division between two fractions.
  defp div({:quot, numerator1, denominator1}, {:quot, numerator2, denominator2}) do
    {:quot, numerator1*denominator2, denominator1*numerator2}
  end

end
