defmodule Evaluation do

  @type literal() :: {:num, number()}
  | {:var, atom()}
  | {:quot, number(), number()}

  @type expression() :: literal()
  | {:add, expression(), expression()}
  | {:sub, expression(), expression()}
  | {:mul, expression(), expression()}
  | {:div, expression(), expression()}

  def test do
    environment = %{x: 2}

    # 2x + 3 + 3
    expression = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:num, 3}}

    evaluate(expression, environment)
  end

  # Any single number is just evaluated to itself.
  def evaluate({:num, number}, _environment) do number end

  # For the evaluation of a variable we have to look in the environment to find the value bound to the variable.
  # The environment is implemented with Elixir's Map module.
  def evaluate({:var, variable}, environment) do Map.get(environment, variable) end

  # The evaluation functions passes the expressions and the environment to corresponding arithmetic operation functions.
  def evaluate({:add, expression1, expression2}, environment) do
    add(evaluate(expression1, environment), evaluate(expression2, environment))
  end
  def evaluate({:sub, expression1, expression2}, environment) do
    subtract(evaluate(expression1, environment), evaluate(expression2, environment))
  end
  def evaluate({:mul, expression1, expression2}, environment) do
    multiply(evaluate(expression1, environment), evaluate(expression2, environment))
  end
  def evaluate({:div, expression1, expression2}, environment) do
    divide(evaluate(expression1, environment), evaluate(expression2, environment))
  end

  # Fractional numbers are evaluated to the lowest common denominator.
  def evaluate({:quot, numerator, denominator}, _environment) do
    gcd = Integer.gcd(numerator, denominator)
    {:quot, numerator/gcd, denominator/gcd}
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
  defp subtract({:num, number}, {:num, 0}) do {:num, number} end
  defp subtract({:num, 0}, {:num, number}) do {:num, number} end

  # Subtraction between two numbers.
  defp subtract({:num, number1}, {:num, number2}) do {:num, number1-number2} end

  # Subtraction between a number and a fraction.
  defp subtract({:num, number}, {:quot, numerator, denominator}) do
    {:quot, number*denominator - numerator, denominator}
  end
  defp subtract({:quot, numerator, denominator}, {:num, number}) do
    {:quot, numerator - number*denominator, denominator}
  end

  # Subtraction between two fractions.
  defp subtract({:quot, numerator1, denominator1}, {:quot, numerator2, denominator2}) do
    {:quot, numerator1*denominator2 - numerator2*denominator1, denominator1*denominator2}
  end

  # -------------------------------- Multiplication ---------------------------------

  # Multiplication with zero.
  defp multiply(_number, {:num, 0}) do {:num, 0} end
  defp multiply({:num, 0}, _number) do {:num, 0} end

  # Multiplication between two numbers.
  defp multiply({:num, number1}, {:num, number2}) do {:num, number1*number2} end

  # Multiplication between a number and a fraction.
  defp multiply({:num, number}, {:quot, numerator, denominator}) do {:quot, number*numerator, denominator} end
  defp multiply({:quot, numerator, denominator}, {:num, number}) do {:quot, number*numerator, denominator} end

  # Multiplication between two fractions.
  defp multiply({:quot, numerator1, denominator1}, {:quot, numerator2, denominator2}) do
    {:quot, numerator1*numerator2, denominator1*denominator2}
  end

  # ----------------------------------- Division ------------------------------------

  # Division with zero.
  defp divide(_number, {:num, 0}) do :undefined end

  # Division with zero over anything.
  defp divide({:num, 0}, _number) do {:num, 0} end

  # Division between two numbers.
  defp divide({:num, number1}, {:num, number2}) do {:quot, number1, number2} end

  # Division between a number and a fraction.
  defp divide({:num, number}, {:quot, numerator, denominator}) do
    {:quot, number*denominator, numerator}
  end
  defp divide({:quot, numerator, denominator}, {:num, number}) do
    {:quot, numerator, number*denominator}
  end

  # Division between two fractions.
  defp divide({:quot, numerator1, denominator1}, {:quot, numerator2, denominator2}) do
    {:quot, numerator1*denominator2, denominator1*numerator2}
  end


  # Translates an expression to a more readable format.
  def translate(expression) do
    case expression do
      {:num, number} -> "#{number}"
      {:var, variable} -> "#{variable}"
      {:quot, numerator, denominator} -> "#{translate(numerator)}/#{translate(denominator)}"
      {:add, expression1, expression2} -> "#{translate(expression1)} + #{translate(expression2)}"
      {:sub, expression1, expression2} -> "#{translate(expression1)} - #{translate(expression2)}"
      {:mul, expression1, expression2} -> "#{translate(expression1)}*#{translate(expression2)}"
      {:div, expression1, expression2} -> "#{translate(expression1)} / #{translate(expression2)}"
      _ -> "Error: invalid expression"
    end
  end

  # Test the basic arithmetic operations
  def testOperations() do

    # Only need an empty environment for this test
    environment = Map.new()

    # Addition
    add = {:add, {:num, 3}, {:num, 5}}
    IO.write("------------- Testing addition -------------\n")
    IO.write("Expression: #{translate(add)}\n")
    IO.write("Expected: 8\n")
    IO.write("Result: #{evaluate(add, environment)}\n\n")

    # Subtraction
    sub = {:sub, {:num, 8}, {:num, 3}}
    IO.write("------------ Testing subtraction -----------\n")
    IO.write("Expression: #{translate(sub)}\n")
    IO.write("Expected: 5\n")
    IO.write("Result: #{evaluate(sub, environment)}\n\n")

    # Multiplication
    mul = {:mul, {:num, 3}, {:num, 5}}
    IO.write("------ Testing integer multiplication ------\n")
    IO.write("Expression: #{translate(mul)}\n")
    IO.write("Expected: 15\n")
    IO.write("Result: #{evaluate(mul, environment)}\n\n")

    mulFrac = {:mul, {:quot, 3, 5}, {:quot, 5, 8}}
    IO.write("------ Testing fraction multiplication -----\n")
    IO.write("Expression: #{translate(mulFrac)}\n")
    IO.write("Expected: 3/8\n")
    IO.write("Result: #{evaluate(mulFrac, environment)}\n\n")

    # Division
    div = {:div, {:num, 15}, {:num, 3}}
    IO.write("--------- Testing fraction division --------\n")
    IO.write("Expression: #{translate(div)}\n")
    IO.write("Expected: 5\n")
    IO.write("Result: #{evaluate(div, environment)}\n\n")

    divFrac = {:div, {:quot, 3, 5}, {:quot, 5, 8}}
    IO.write("--------- Testing fraction division --------\n")
    IO.write("Expression: #{translate(divFrac)}\n")
    IO.write("Expected: 49/40\n")
    IO.write("Result: #{evaluate(divFrac, environment)}\n\n")
  end

  # Test an expression.
  def testExpression() do

    # 2x + 3 + 1/2
    expression = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:quot, 1, 2}}

    # Define the environment.
    environment = Map.new()
    environment = Map.put(environment, :x, 2)
    environment = Map.put(environment, :y, 4)
    environment = Map.put(environment, :z, 6)

    #IO.write("Expression: 2x + 3 + 1/2\n")
    IO.write("Expression: #{translate(expression)}\n")
    IO.write("x = #{Map.get(environment, :x)}\n")
    IO.write("Result: #{evaluate(expression, environment)}\n")
  end
end
