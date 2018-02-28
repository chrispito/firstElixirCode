defmodule Cards do
  @moduledoc """
  Documentation for Cards.
    new elixir project: mix new cards
    
    run iex -S mix to hot compile
    run recompile to reload the new state after changes

    Maps:
    new map: Map.new() or %{} or 'With data' %{primary: "red"}
    # To access it:
    iex> colors = {primary: "red", secondary: "blue"}
    iex> colors.primary
    "red"
    # Update
    Map.put(myMap, :key, newValue) or %{myMap | key: value}

    Keyword List
    [{:primary, "red"}, {:secondary, "green"}] or [primary: "red", secondary: "blue"]
    # To access it:
    iex> keywordlisr = [primary: "blue", secondary: "red"]
    iex> keywordlist[:primary]
    "blue"
  """

  @doc """
  Create Deck!

  This will create an initial Deck
  """
  def create_deck do
    values = [
      "Ace", 
      "Two", 
      "Three", 
      "Four", 
      "Five"
      # "Six", 
      # "Seven",
      # "Eight", 
      # "Nine", 
      # "Ten", 
      # "J", 
      # "Queen", 
      # "KIng"
    ]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    # Initial 
    # for value <- values do
    #   for suit <- suits do
    #     "#{value} of #{suit}"
    #   end
    # end

    ####  Solution 1 ####

    # cards = for value <- values do
    #   for suit <- suits do
    #     "#{value} of #{suit}"
    #   end
    # end
    # List.flatten(cards)

    #### Solution 2 ####
    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end

  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    We give tow parameters: `deck` and `hand_size`:
    The first parameter is the list of the cards and the second
    the number of cards we want to pick.

  ## Example

      iex> deck = Cards.create_deck
      iex> {hand, _rest} = Cards.deal(deck, 2)
      iex> hand
      ["Ace of Spades", "Two of Spades"]

  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  @doc """
    Check if the first parameter list `deck` contains the second
    parameter string `card`

  ## Example

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Ace of Spades")
      true

  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    We give tow parameters: `deck` and `filename`:
    The first parameter is the list of the cards and the second
    the path and the filename where we are going to save the data.
  """
  def save(deck, filename) do
    binary  = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    #### First approach ####
    # {status, binary} = File.read(filename)
    # case status do
    #   :ok -> :erlang.binary_to_term binary
    #   :error -> "That file does not exist!"
    # end

   #### Second approach ####
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term binary
      {:error, reason} -> "That file does not exist! because: \n #{reason}"
      # If we don't want to use the 'reason' variable and don't want to a warning, 
      # we can use the '_' like {:error, _reason}
    end
  end

  @doc """
  The Pipe operator:
  The Pipe operator always pass the result of the previous operatio 
  to the first argument of the next function
  """
  def create_hand(hand_size) do
    #### First approach ####
    # deck = Cards.create_deck
    # deck = Cards.shuffle(deck)
    # {hand, _rest} = Cards.deal(deck, hand_size)
    # hand

    #### Second approach ####
    {hand, _rest} = Cards.create_deck
    |> Cards.shuffle
    |> Cards.deal(hand_size)
    hand
  end

end
