defmodule Cryptofolio.Web.PortfolioView do
  use Cryptofolio.Web, :view
  alias Cryptofolio.Trade

  def class_for_sign(n1) do
    "#{if Decimal.cmp(n1, Decimal.new(0)) == :lt, do: 'decrease', else: 'increase'}"
  end

  def class_for_value(n1) do
    "price-value--#{if Decimal.cmp(n1, Decimal.new(0)) == :lt, do: 'decrease', else: 'increase'}"
  end

  def description_preview(description) when is_binary(description) do
    length = String.length(description)

    if length > 50 do
      "#{String.slice(description, 0, 50)}..."
    else
      description
    end
  end

  def description_preview(_) do
    ""
  end

  def privacy_text(portfolio) do
    if portfolio.is_public_all, do: "public", else: "private"
  end

  def privacy_text(portfolio, :reverse) do
    if portfolio.is_public_all, do: "private", else: "public"
  end

  def group_coin_trades(trades) do
    Enum.group_by(trades, &(&1.currency_id))
  end

  def coin_trades_amount(trades) do
    Enum.reduce(trades, Decimal.new(0), fn(trade, acc) -> Decimal.add(trade.amount, acc) end)
  end

  def coin_trades_total_cost(trades) do
    Enum.reduce(trades, Decimal.new(0), fn(trade, acc) -> Decimal.add(trade.total_cost, acc) end)
  end

  def coin_trades_cost(trades) do
    Decimal.div(coin_trades_total_cost(trades), coin_trades_amount(trades))
  end

  def coin_trades_profit_lost(trades) do
    Enum.reduce(trades, Decimal.new(0), fn(trade, acc) -> Decimal.add(Trade.profit_loss(trade), acc) end)
  end

  def coin_trades_profit_lost_perc(trades) do
    total_cost = coin_trades_total_cost(trades)

    if Decimal.cmp(total_cost, Decimal.new(0)) != :eq do
      Decimal.mult(Decimal.div(coin_trades_profit_lost(trades), total_cost), Decimal.new(100))
    else
      Decimal.new(0)
    end

  end
end
