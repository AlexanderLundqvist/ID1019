defmodule Evaluation do

  @type literal() :: {:num, number()}
  | {:var, atom()}
  | {:quot, number(), number()}

  @type expression() :: literal()
  | {:add, expression(), expression()}
  | {:sub, expression(), expression()}
  | {:mul, expression(), expression()}
  | {:div, expression(), expression()}

  # 2x + 3 + 3
  def test1 do
    environment = %{x: 2}
    expression = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:num, 3}}
    evaluate(expression, environment)
  end

  # 2x + 3 + 1/2
  def test2 do
    environment = %{x: 2}
    expression = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:quot, 1, 2}}
    evaluate(expression, environment)
  end

  # x + 0/5
  def test3 do
    environment = %{x: 2}
    expression = {:add, {:var, :x}, {:quot, 0, 5}}
    evaluate(expression, environment)
  end

  # x + 5/0
  def test4 do
    environment = %{x: 2}
    expression = {:add, {:var, :x}, {:quot, 5, 0}}
    evaluate(expression, environment)
  end

  # Any single number is just evaluated to itself.
  def evaluate({:num, number}, _environment) do {:num, number} end

  # For the evaluation of a variable we have to look in the environment to find the value bound to the variable.
  # The environment is implemented with Elixir's Map module.
  def evaluate({:var, variable}, environment) do {:num, Map.get(environment, variable)} end

  # Fractional numbers are evaluated to the lowest common denominator with simplify().
  def evaluate({:quot, numerator, denominator}, _environment) do
    simplify({:quot, numerator, denominator})
  end

  # The evaluation functions passes the expressions and the environment to corresponding arithmetic operation functions.
  # If we at any point in the recursive evaluation get :undefined, we stop the evaluation and return :undefined.
  def evaluate({:add, expression1, expression2}, environment) do
    evaluated1 = evaluate(expression1, environment)
    evaluated2 = evaluate(expression2, environment)
    if evaluated1 == :undefined || evaluated2 == :undefined do
      :undefined
    else
      add(evaluated1, evaluated2)
    end
  end
  def evaluate({:sub, expression1, expression2}, environment) do
    evaluated1 = evaluate(expression1, environment)
    evaluated2 = evaluate(expression2, environment)
    if evaluated1 == :undefined || evaluated2 == :undefined do
      :undefined
    else
      subtract(evaluated1, evaluated2)
    end
  end
  def evaluate({:mul, expression1, expression2}, environment) do
    evaluated1 = evaluate(expression1, environment)
    evaluated2 = evaluate(expression2, environment)
    if evaluated1 == :undefined || evaluated2 == :undefined do
      :undefined
    else
      multiply(evaluated1, evaluated2)
    end
  end
  def evaluate({:div, expression1, expression2}, environment) do
    numerator = evaluate(expression1, environment)
    denominator = evaluate(expression2, environment)
    if numerator == :undefined || denominator == 0 do
      :undefined
    else
      divide(numerator, denominator)
    end
  end

  # ----------------------------------- Addition ------------------------------------

  # Addition between two fractions.
  defp add({:quot, numerator1, denominator1}, {:quot, numerator2, denominator2}) do
    simplify({:quot, numerator1 * denominator2 + numerator2 * denominator1, denominator1 * denominator2})
  end

  # Addition between a number and a fraction.
  defp add({:num, number}, {:quot, numerator, denominator}) do
    simplify({:quot, number * denominator + numerator, denominator})
  end
  defp add({:quot, numerator, denominator}, {:num, number}) do
    simplify({:quot, number * denominator + numerator, denominator})
  end

  # Addition between two numbers.
  defp add({:num, number1}, {:num, number2}) do {:num, number1 + number2} end

  # ---------------------------------- Subtraction ----------------------------------

  # Subtraction between two fractions.
  defp subtract({:quot, numerator1, denominator1}, {:quot, numerator2, denominator2}) do
    simplify({:quot, numerator1 * denominator2 - numerator2 * denominator1, denominator1 * denominator2})
  end

  # Subtraction between a number and a fraction.
  defp subtract({:num, number}, {:quot, numerator, denominator}) do
    simplify({:quot, number * denominator - numerator, denominator})
  end
  defp subtract({:quot, numerator, denominator}, {:num, number}) do
    simplify({:quot, numerator - number * denominator, denominator})
  end

  # Subtraction between two numbers.
  defp subtract({:num, number1}, {:num, number2}) do {:num, number1-number2} end

  # -------------------------------- Multiplication ---------------------------------

  # Multiplication between two fractions.
  defp multiply({:quot, numerator1, denominator1}, {:quot, numerator2, denominator2}) do
    simplify({:quot, numerator1 * numerator2, denominator1 * denominator2})
  end

  # Multiplication between a number and a fraction.
  defp multiply({:num, number}, {:quot, numerator, denominator}) do
    simplify({:quot, number * numerator, denominator})
  end
  defp multiply({:quot, numerator, denominator}, {:num, number}) do
    simplify({:quot, number * numerator, denominator})
  end

  # Multiplication between two numbers.
  defp multiply({:num, number1}, {:num, number2}) do {:num, number1 * number2} end

  # ----------------------------------- Division ------------------------------------

  # Division between two fractions.
  defp divide({:quot, numerator1, denominator1}, {:quot, numerator2, denominator2}) do
    simplify({:quot, numerator1 * denominator2, denominator1 * numerator2})
  end

  # Division between a number and a fraction.
  defp divide({:num, number}, {:quot, numerator, denominator}) do
    simplify({:quot, number * denominator, numerator})
  end
  defp divide({:quot, numerator, denominator}, {:num, number}) do
    simplify({:quot, numerator, number * denominator})
  end

  # Division with zero over anything.
  defp divide({:num, 0}, _number) do {:num, 0} end

  # Division with zero.
  defp divide(_number, {:num, 0}) do :undefined end

  # Division between two numbers.
  defp divide({:num, number1}, {:num, number2}) do simplify({:quot, number1, number2}) end

  # ----------------------------------- Simplify ------------------------------------

  # Catch zero-division and reduce the fraction to the lowest common denominator or
  # to a single number if it is evenly divisable.
  defp simplify({:quot, numerator, denominator}) do
    cond do
      numerator == 0 ->
        {:num, 0}
      denominator == 0 ->
        :undefined
      rem(numerator, denominator) == 0 ->
        {:num, trunc(numerator/denominator)}
      true ->
        gcd = Integer.gcd(numerator, denominator)
        {:quot, trunc(numerator/gcd), trunc(denominator/gcd)}
    end
  end
end
