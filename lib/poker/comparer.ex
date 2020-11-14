defmodule Poker.Comparer do
  @moduledoc """
  Compare two hands and return the higher ranking hand
  """
  alias Poker.Hand
  @category_high_to_low ~w(straight_flush four_of_a_kind full_house flush straight three_of_a_kind two_pairs one_pair high_card)a

  @doc """
  compare two hands when they are in different category
  """
  @spec compare(winnerHands :: [Hand.t()], handB :: Hand.t()) :: [Hand.t()]
  def compare(winnerHands, handB) do
    handA = Enum.at(winnerHands, 0)
    winner_hand = higher_ranking_hand(handA, handB)

    cond do
      winner_hand === handA -> winnerHands
      winner_hand === handB -> [handB]
      winner_hand === [handA, handB] -> [winnerHands | handB]
    end
  end

  defp higher_ranking_hand(handA, handB) when handA.category === handB.category do
    compare_value(handA, handB)
  end
  defp higher_ranking_hand(handA, handB) do
    compare_ranking(handA, handB)
  end

  defp compare_value(handA, handB) do
    compare_ranking(handA, handB)
  end

  defp compare_ranking(handA, handB) do
    handA_ranking = ranking_of_category(handA.category)
    handB_ranking = ranking_of_category(handB.category)

    case handA_ranking - handB_ranking do
      x when x < 0 -> handA
      x when x > 0 -> handB
      x when x === 0 -> [handA, handB]
    end
  end

  defp ranking_of_category(category) do
    Enum.find_index(@category_high_to_low, &(&1 == category))
  end
end