defmodule Nine do

  @type expr() ::
  {:add, expr(), expr()}
| {:sub, expr(), expr()}
| {:mul, expr(), expr()}
| {:div, expr(), expr()}
| literal()


@type literal() ::
  {:num, number()}
  | {:var, atom()}
  | {:q, number(), number()}


  def test do
    environment = %{x: 2}

    # 2x + 3 + 3
    expression = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:num, 3}}

    eval(expression, environment)
  end


def eval({:num, k}, _) do k end
def eval({:var, x}, getVar) do Map.get(getVar, x)  end
def eval({:add, x1, x2}, getVar) do add(eval(x1, getVar), eval(x2, getVar)) end
def eval({:sub, x1, x2}, getVar) do sub(eval(x1, getVar), eval(x2, getVar)) end
def eval({:mul, x1, x2}, getVar) do mul(eval(x1, getVar), eval(x2, getVar)) end
def eval({:div, x1, x2}, getVar) do div(eval(x1, getVar), eval(x2, getVar)) end
def eval(_, {:q, x1, x2}) do simp(x1, x2) end


def add({:q, a, b}, {:num, x}) do {:q, x * b + a, b } end
def add({:num, x}, {:q, a, b}) do {:q, x * b + a, b } end
def add({:q, a, b}, {:q, z, k}) do {:q, a * k + b * z, b * k} end
def add({:num, x}, {:num, y}) do {:num, x + y} end


def sub({:q, a, b}, {:num, x}) do {:q, b * x - a, b } end
def sub({:num, x}, {:q, a, b}) do {:q, x * b - a, b } end
def sub({:q, a, b}, {:q, z, k}) do {:q, a * k - b * z, b * k} end
def sub({:num, x}, {:num, y}) do {:num, x - y} end


def mul({:q, a, b}, {:num, x}) do {:q, a * x, b } end
def mul({:num, x}, {:q, a, b}) do {:q, x * a, b } end
def mul({:q, a, b}, {:q, z, k}) do {:q, a * z, b * k} end
def mul({:num, x},{:num, y}) do {:num, x * y} end


def divi(x, {:q, a, b}) do {:q, a, x * b } end
def divi({:q, a, b}, {:q, z, k}) do {:q, a * k, b * z} end
def divi({:q, a, b}, x) do {:q, a, x * b } end
def divi({:num, x}, {:num, y}) do
  if(rem(x,y) == 0) do
    {:num, trunc(x/y)}
  else
    simp(x,y)

end
end

def simp(x1, x2) do
  {:q, trunc(x1/Integer.gcd(x1,x2)), trunc(x2/Integer.gcd(x1,x2))}

end
end
