defmodule Practice.Factor do

  # Function logic taken from https://www.geeksforgeeks.org/print-all-prime-factors-of-a-given-number/ 

  def factor(x) do
    factorTwos(x, "" )
  end
 
  def factorTwos(x, factors) do
    if (rem(x, 2) == 0 && x != 0) do
      factorTwos(floor(x/2), "2 " <> factors)
    else
      factorAcc(x, 3, factors)
    end
  end
	
  def factorAcc(x, acc, factors) do
    cond do
      :math.sqrt(x) >=  acc ->
        if (rem(x, acc) == 0) do
          factorAcc(floor(x/acc), acc, factors <> " " <>  to_string(acc))
        else 
          factorAcc(x, acc+2, factors)
        end
      true -> lastFactor(x, factors)
    end
  end

  def lastFactor(x, factors) do
    if (x > 2) do
      factors <> " " <> to_string(x)
    else
      factors
    end
  end
end
