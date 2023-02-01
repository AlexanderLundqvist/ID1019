defmodule Test do

  # Translates an expression to a more readable format.
  def translate(expression) do
    case expression do
      {:num, number} -> "#{number}"
      {:var, variable} -> "#{name}"
      {:quot, numerator, denominator} -> "#{translate(numerator)}/#{translate(denominator)}"
      {:add, expression1, expression2} -> "#{translate(expression1)} + #{translate(expression2)}"
      {:sub, expression1, expression2} -> "#{translate(expression1)} - #{translate(expression2)}"
      {:mul, expression1, expression2} -> "#{translate(expression1)}*#{translate(expression2)}"
      {:mul, expression, {:var, variable}} -> "#{translate(expression)}#{translate(variable)}"
      _ -> "Error: invalid expression"
    end
  end

  # Test the basic arithmetic operations
  def testOperations() do
    environment = %{}

    # Addition
    add = {:add, {:num, 3}, {:num, 5}}
    IO.write("Testing addition\n")
    IO.write("Expression: 3 + 5\n")
    IO.write("Expected: 8\n")
    IO.write("Result: #{Evaluation.evaluate(add, environment)}\n\n")

    # Subtraction
    sub = {:sub, {:num, 8}, {:num, 3}}
    IO.write("Testing subtraction\n")
    IO.write("Expression: 8 - 3\n")
    IO.write("Expected: 5\n")
    IO.write("Result: #{Evaluation.evaluate(sub, environment)}\n\n")

    # Multiplication
    mul = {:mul, {:num, 3}, {:num, 5}}
    IO.write("Testing integer multiplication\n")
    IO.write("Expression: 3 * 5\n")
    IO.write("Expected: 15\n")
    IO.write("Result: #{Evaluation.evaluate(mul, environment)}\n\n")

    mulFrac = {:mul, {:quot, 3, 5}, {:quot, 5, 8}}
    IO.write("Testing integer multiplication\n")
    IO.write("Expression: 3/5 * 5/8\n")
    IO.write("Expected: 3/8\n")
    IO.write("Result: #{Evaluation.evaluate(mulFrac, environment)}\n\n")

    # Division
    div = {:div, {:num, 15}, {:num, 3}}
    IO.write("Testing fraction division\n")
    IO.write("Expression: 15 / 3\n")
    IO.write("Expected: 5\n")
    IO.write("Result: #{Evaluation.evaluate(div, environment)}\n\n")

    divFrac = {:div, {:quot, 3, 5}, {:quot, 5, 8}}
    IO.write("Testing fraction division\n")
    IO.write("Expression: 3/5 / 5/8\n")
    IO.write("Expected: 49/40\n")
    IO.write("Result: #{Evaluation.evaluate(divFrac, environment)}\n\n")

  end

  # Test an expression.
  def testExpression() do

    # 2x + 3 + 1/2
    expression = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:quot, 1, 2}}

    # Define the environment.
    environment = %{}
    environment = Map.put(environment, x, 2)
    environment = Map.put(environment, y, 4)
    environment = Map.put(environment, z, 6)

    #IO.write("Expression: 2x + 3 + 1/2\n")
    IO.write("Expression: #{translate(expression)}\n")
    IO.write("x = #{Map.get(environment, x)}\n")
    IO.write("Result: #{Evaluation.evaluate(expression, environment)}\n")
  end

end
