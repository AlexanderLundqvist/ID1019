defmodule Test do


  # Translates an expression to a more readable format.
  def translate(expression) do
    case expression do
      {:num, number} -> "#{number}"
      {:var, variable} -> "#{variable}"
      {:add, expression1, expression2} -> "#{translate(expression1)} + #{translate(expression2)}"
      {:sub, expression1, expression2} -> "#{translate(expression1)} - #{translate(expression2)}"
      {:mul, expression1, expression2} -> "#{translate(expression1)} * #{translate(expression2)}"
      {:div, expression1, expression2} -> "#{translate(expression1)} / #{translate(expression2)}"
      {:quot, numerator, denominator} -> "(#{numerator}/#{denominator})"
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
    IO.write("Result: #{translate(Evaluation.evaluate(add, environment))}\n\n")

    # Subtraction
    sub = {:sub, {:num, 8}, {:num, 3}}
    IO.write("------------ Testing subtraction -----------\n")
    IO.write("Expression: #{translate(sub)}\n")
    IO.write("Expected: 5\n")
    IO.write("Result: #{translate(Evaluation.evaluate(sub, environment))}\n\n")

    # Multiplication
    mul = {:mul, {:num, 3}, {:num, 5}}
    IO.write("------ Testing integer multiplication ------\n")
    IO.write("Expression: #{translate(mul)}\n")
    IO.write("Expected: 15\n")
    IO.write("Result: #{translate(Evaluation.evaluate(mul, environment))}\n\n")

    mulFrac = {:mul, {:quot, 3, 5}, {:quot, 5, 8}}
    IO.write("------ Testing fraction multiplication -----\n")
    IO.write("Expression: #{translate(mulFrac)}\n")
    IO.write("Expected: 3/8\n")
    IO.write("Result: #{translate(Evaluation.evaluate(mulFrac, environment))}\n\n")

    # Division
    div = {:div, {:num, 15}, {:num, 3}}
    IO.write("--------- Testing integer division --------\n")
    IO.write("Expression: #{translate(div)}\n")
    IO.write("Expected: 5\n")
    IO.write("Result: #{translate(Evaluation.evaluate(div, environment))}\n\n")

    divFrac = {:div, {:quot, 3, 5}, {:quot, 5, 8}}
    IO.write("--------- Testing fraction division --------\n")
    IO.write("Expression: #{translate(divFrac)}\n")
    IO.write("Expected: 24/25\n")
    IO.write("Result: #{translate(Evaluation.evaluate(divFrac, environment))}\n\n")
  end

  # Test an expression.
  def testExpression() do

    # 2x + 8/4 + 3/7
    expression = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:quot, 8, 14}}, {:quot, 3, 7}}

    # Define the environment.
    environment = Map.new()
    environment = Map.put(environment, :x, 2)
    environment = Map.put(environment, :y, 4)
    environment = Map.put(environment, :z, 6)

    IO.write("------- Testing expression evaluation ------\n")
    IO.write("Expression: #{translate(expression)}\n")
    IO.write("x = #{Map.get(environment, :x)}\n")
    IO.write("Result: #{translate(Evaluation.evaluate(expression, environment))}\n\n")
  end

   # Test zero division.
   def testError() do

    # 2x + 3 + 1/2
    expression = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:quot, 1, 0}}

    # Define the environment.
    environment = Map.new()
    environment = Map.put(environment, :x, 2)

    IO.write("--- Testing zero division multiplication ---\n")
    IO.write("Expression: 2x + 3 + 1/0\n")
    IO.write("x = #{Map.get(environment, :x)}\n")
    IO.write("Result: #{translate(Evaluation.evaluate(expression, environment))}\n\n")
  end

end
