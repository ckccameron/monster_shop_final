class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def bulk_discount_max(item_id)
    item = Item.find(item_id)

    item.merchant.discounts.where('min_item_quantity <= ?', count_of(item_id)).pluck(:percent_off).max
  end

  def discount_total_from_subtotal(item_id)
    (bulk_discount_max(item_id) * 0.01) * subtotal_of(item_id)
  end

  def discounted_subtotal_of(item_id)
    subtotal_of(item_id) - discount_total_from_subtotal(item_id)
  end
end
