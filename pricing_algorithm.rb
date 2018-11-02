class SuggestionCalculator
  @@price_reference_factors = {
    -Float::INFINITY..15 => 0.75,
    15..25 => 0.775,
    25..50 => 0.8,
    50..75 => 0.825,
    75..100 => 0.85,
    100..200 => 0.875,
    200..400 => 0.9,
    400..600 => 0.925,
    600..Float::INFINITY => 0.95
  }

  def self.price_suggestion shipping_cost, price_reference
    price_reference - shipping_cost * SuggestionCalculator.price_reference_factor(price_reference)
  end

  private

  def self.price_reference_factor price_reference
    @@price_reference_factors.select {|factor| factor === price_reference }.values.first
  end
end

class PriceSuggester
  def initialize(price_reference, price_suggestion_factor = 1)
    @price_reference = price_reference
    @price_suggestion_factor = price_suggestion_factor
  end

  def suggestion shipping_cost
    SuggestionCalculator.price_suggestion(shipping_cost, @price_reference) * @price_suggestion_factor
  end
end


price_suggester = case brand.rating
  when high then PriceSuggester.new(price_reference, 1.1)
  when low then PriceSuggester.new(price_reference, 0.9)
  else PriceSuggester.new(price_reference)
end

price_suggester.suggestion(product_database.shipping_cost)
