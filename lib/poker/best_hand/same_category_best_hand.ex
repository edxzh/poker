defmodule Poker.BestHand.SameCategoryBestHand do
  @moduledoc """
  Return higher hand from two hands when they are in same category
  """
  alias Poker.Hand

  @spec find(current_best_hand :: Hand.t(), next_hand :: Hand.t()) :: Hand.t() | [Hand.t()]
  def find(current_best_hand, next_hand) do
    current_hand_values = values_of(current_best_hand)
    next_hand_values = values_of(next_hand)

    cond do
      current_hand_values > next_hand_values -> current_best_hand
      current_hand_values < next_hand_values -> next_hand
      current_hand_values == next_hand_values -> [current_best_hand, next_hand]
    end
  end

  defp values_of(hand) when hand.category in ~w(straight_flush straight)a do
    hand.cards
    |> Enum.map(& &1.int_value)
    |> Enum.sort_by(& &1)
    |> comparable_value()
    |> List.wrap()
  end

  defp values_of(hand) when hand.category in ~w(flush high_card)a,
    do: Enum.map(hand.cards, & &1.int_value)

  defp values_of(hand) do
    hand.cards
    |> Enum.group_by(& &1.int_value)
    |> Enum.sort_by(&{length(elem(&1, 1)), elem(&1, 0)}, :desc)
    |> Enum.map(&elem(&1, 0))
  end

  defp comparable_value(values) when values == [2, 3, 4, 5, 14], do: 5
  defp comparable_value(values), do: Enum.at(values, -1)
end
