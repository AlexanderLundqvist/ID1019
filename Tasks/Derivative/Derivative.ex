defmodule Derivative do
    @moduledoc """
    ID1019 Task 1: Derivative
    This module takes the derivative of a few common expressions.
    """
    @type literal() :: {:num, number()} | {:var, atom()}

    @type expression() :: literal()
    | {:add, expression(), expression()}
    | {:mul, expression(), expression()}
    | {:div, expression(), expression()}
    | {:exp, expression(), literal()}
    | {:sqrt, expression()}
    | {:ln, expression()}
    | {:sin, expression()}

    # ------------------------------ Derivation rules --------------------------------

    def derive({:num, _}, _) do {:num, 0} end

    def derive({:var, x}, x) do {:num, 1} end

    def derive({:var, _}, _) do {:num, 0} end

    def derive({:add, expression1, expression2}, x) do {:add, derive(expression1, x), derive(expression2, x)} end

    def derive({:mul, expression1, expression2}, x) do {:add, {:mul, derive(expression1, x), expression2}, {:mul, expression1, derive(expression2, x)}} end

    def derive({:div, expression1, expression2}, x) do
      {:div,
          {:add,
              {:mul, derive(expression1, x), expression2},
              {:mul,
                  {:mul, expression1, derive(expression2, x)},
                  {:num, -1}
              }
          },
          {:exp, expression2, {:num, 2}}
      }
    end

    def derive({:exp, expression, {:num, exponent}}, x) do
      {:mul,
          {:mul, {:num, exponent}, {:exp, expression, {:num, exponent-1}}},
          derive(expression, x)}
    end

    def derive({:sqrt, expression}, x) do
      {:div, derive(expression, x), {:mul, {:num, 2}, {:sqrt, expression}}}
    end

    def derive({:ln, expression}, x) do {:div, derive(expression, x), expression} end

    def derive({:sin, expression}, x) do
      {:mul, derive(expression, x), {:cos, expression}}
    end

    # --------------------------- Simplification methods -----------------------------

    def simplify({:num, number}) do {:num, number} end
    def simplify({:var, x}) do {:var, x} end
    def simplify({:add, expression1, expression2}) do
      simplify_add(simplify(expression1), simplify(expression2))
    end
    def simplify({:mul, expression1, expression2}) do
      simplify_mul(simplify(expression1), simplify(expression2))
    end
    def simplify({:div, expression1, expression2}) do
      simplify_div(simplify(expression1), simplify(expression2))
    end
    def simplify({:exp, expression1, expression2}) do
      simplify_exp(simplify(expression1), simplify(expression2))
    end
    def simplify({:ln, expression}) do
      simplify_ln(simplify(expression))
    end
    def simplify({:sqrt, expression}) do
      simplify_sqrt(simplify(expression))
    end
    def simplify({:sin, expression}) do
      simplify_sin(simplify(expression))
    end
    def simplify({:cos, expression}) do
      simplify_cos(simplify(expression))
    end

    # Addition
    def simplify_add({:num, 0}, expression) do expression end
    def simplify_add(expression, {:num, 0}) do expression end
    def simplify_add{:num, number1}, {:num, number2} do {:num, number1 + number2} end
    def simplify_add(expression1, expression2) do {:add, expression1, expression2} end

    # Multiplication
    def simplify_mul({:num, 1}, expression) do expression end
    def simplify_mul(expression, {:num, 1}) do expression end
    def simplify_mul({:num, number1}, {:num, number2}) do {:num, number1 * number2} end
    def simplify_mul({:num, 0}, _) do {:num, 0} end
    def simplify_mul(_,{:num, 0}) do {:num, 0} end
    def simplify_mul(expression1, expression2) do {:mul, expression1, expression2} end

    # Division
    def simplify_div({:num, number1}, {:num, number2}) do {:num, number1/number2} end
    def simplify_div({:num, 1}, expression) do {:div, {:num, 1}, expression} end
    def simplify_div(expression, {:num, 1}) do expression end
    def simplify_div(expression1, expression2) do {:div, expression1, expression2} end

    # Exponential
    def simplify_exp(expression, {:num, 1}) do expression end
    def simplify_exp(_, {:num, 0}) do {:num, 1} end
    def simplify_exp({:num, number}, {:num, exponent}) do {:num, :math.pow(number, exponent)} end
    def simplify_exp(expression1, expression2) do {:exp, expression1, expression2} end

    # Ln
    def simplify_ln({:num, 1}) do {:num, 0} end
    def simplify_ln({:num, 0}) do {:num, 0} end
    def simplify_ln(expression) do {:ln, expression} end

    # Square root
    def simplify_sqrt({:num, 0}) do {:num, 0} end
    def simplify_sqrt(expression) do {:sqrt, expression} end

    # Trig
    def simplify_sin(expression) do {:sin, expression} end
    def simplify_cos(expression) do {:cos, expression} end

    # -------------------------------- Print methods ---------------------------------

    def pprint({:num, number}) do "#{number}" end
    def pprint({:var, x}) do "#{x}" end
    def pprint({:add, expression1, expression2}) do "(#{pprint(expression1)} + #{pprint(expression2)})" end
    def pprint({:mul, expression1, expression2}) do "#{pprint(expression1)}*#{pprint(expression2)}" end
    def pprint({:exp, expression1, expression2}) do "(#{pprint(expression1)})^(#{pprint(expression2)})" end
    def pprint({:div, expression1, expression2}) do "(#{pprint(expression1)}/#{pprint(expression2)})" end
    def pprint({:ln , expression}) do "ln(#{pprint(expression)})" end
    def pprint({:sqrt, expression}) do "sqrt(#{pprint(expression)})" end
    def pprint({:sin, expression}) do "sin(#{pprint(expression)})" end
    def pprint({:cos, expression}) do "cos(#{pprint(expression)})" end

    # -------------------- Test cases for the different functions --------------------

    def test1() do
      expression = {:add, {:mul, {:num, 3}, {:exp, {:var, :x}, {:num, 2}}}, {:mul, {:num, 4}, {:var, :x}}}
      derivative = derive(expression, :x)
      IO.write("-------- Testing addition --------\n")
      IO.write("Expression: #{pprint(expression)}\n")
      IO.write("Derivative of expression: #{pprint(derivative)}\n")
      IO.write("Simplified: #{pprint(simplify(derivative))}\n\n")
    end

    def test2() do
      expression = {:mul, {:mul, {:num, 3}, {:var, :x}}, {:mul, {:num, 4}, {:var, :x}}}
      derivative = derive(expression, :x)
      IO.write("----- Testing multiplication -----\n")
      IO.write("Expression: #{pprint(expression)}\n")
      IO.write("Derivative of expression: #{pprint(derivative)}\n")
      IO.write("Simplified: #{pprint(simplify(derivative))}\n\n")
    end

    def test3() do
      expression = {:div, {:num, 3}, {:var, :x}}
      derivative = derive(expression, :x)
      IO.write("--------- Testing division -------\n")
      IO.write("Expression: #{pprint(expression)}\n")
      IO.write("Derivative of expression: #{pprint(derivative)}\n")
      IO.write("Simplified: #{pprint(simplify(derivative))}\n\n")
    end

    def test4() do
      expression = {:exp, {:var, :x}, {:num, 3}}
      derivative = derive(expression, :x)
      IO.write("------- Testing exponential ------\n")
      IO.write("Expression: #{pprint(expression)}\n")
      IO.write("Derivative of expression: #{pprint(derivative)}\n")
      IO.write("Simplified: #{pprint(simplify(derivative))}\n\n")
    end

    def test5() do
      expression = {:sqrt, {:mul, {:num, 5}, {:var, :x}}}
      derivative = derive(expression, :x)
      IO.write("------- Testing square root ------\n")
      IO.write("Expression: #{pprint(expression)}\n")
      IO.write("Derivative of expression: #{pprint(derivative)}\n")
      IO.write("Simplified: #{pprint(simplify(derivative))}\n\n")
    end

    def test6() do
      expression = {:ln, {:exp, {:var, :x}, {:num, 10}}}
      derivative = derive(expression, :x)
      IO.write("----------- Testing ln -----------\n")
      IO.write("Expression: #{pprint(expression)}\n")
      IO.write("Derivative of expression: #{pprint(derivative)}\n")
      IO.write("Simplified: #{pprint(simplify(derivative))}\n\n")
    end

    def test7() do
      expression = {:sin, {:mul, {:var, :x}, {:num, 3}}}
      derivative = derive(expression, :x)
      IO.write("----------- Testing sin ----------\n")
      IO.write("Expression: #{pprint(expression)}\n")
      IO.write("Derivative of expression: #{pprint(derivative)}\n")
      IO.write("Simplified: #{pprint(simplify(derivative))}\n\n")
    end
end
