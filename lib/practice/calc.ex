defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> tag_tokens
    |> sort_postfix
    |> postfix_eval
    |> hd
    |> elem(1)
  end

  def tag_tokens([]), do: []
  def tag_tokens(list) do 
    head = hd list
    cond do
      head == "+" || head == "-" ->
        [{:op1, head}] ++ tag_tokens(tl(list))
      head == "/" || head == "*" ->
        [{:op2, head}] ++ tag_tokens(tl(list))
      true -> 
        [{:num, parse_float(head)}] ++ tag_tokens(tl(list))
    end
  end

  def sort_postfix(list), do: sort_postfix(list, [])
  def sort_postfix([], stack), do: stack
  def sort_postfix(list, stack) do
    head = hd list
    cond do
      # transcribe numbers
      elem(head, 0) == :num ->
        [head] ++ sort_postfix(tl(list), stack)
      # push
      length(stack) == 0 || elem(head, 0) == :op2 && elem(hd(stack), 0) == :op1 ->
        sort_postfix(tl(list), [head] ++ stack)
      # pop all stack operators with higher or equal priority
      true ->
        operators = pop_op(head, stack, [])
        elem(operators, 0) ++ sort_postfix(tl(list), [head] ++ elem(operators, 1))
    end
  end

  def pop_op(head,[],output), do: {output, []}
  def pop_op(head,stack,output) do
    if (!(elem(head,0) == :op2 && elem(hd(stack),0) == :op1)) do
      pop_op(head, tl(stack), [hd(stack)] ++ output)
    else
      {output, stack}
    end
  end
  
  def postfix_eval(list), do: postfix_eval(list, [])
  def postfix_eval([], stack), do: stack
  def postfix_eval(list, stack) do
    head = hd list
    if elem(head, 0) == :num do
      postfix_eval(tl(list), [head] ++ stack)
    else
      postfix_eval(tl(list), evaluate(elem(head, 1), stack))
    end
  end

  def evaluate(op, stack) do
    head = hd stack
    tail = tl stack
    head2 = hd tail
    tail2 = tl tail
    cond do
      op == "+" ->
        [{:num, elem(head2, 1) + elem(head, 1)}] ++ tail2
      op == "-" ->
        [{:num, elem(head2, 1) - elem(head, 1)}] ++ tail2
      op == "*" ->
        [{:num, elem(head2, 1) * elem(head, 1)}] ++ tail2
      op == "/" ->
        [{:num, elem(head2, 1) / elem(head, 1)}] ++ tail2
      true ->
        stack
    end
  end

end
