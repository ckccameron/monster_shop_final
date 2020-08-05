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

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def grand_total
    grand_total = 0.00
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def discounted_grand_total
    grand_total = 0.00
    @contents.each do |item_id, quantity|
      grand_total += discounted_subtotal_of(item_id) if find_applicable_discount(item_id)
      grand_total += subtotal_of(item_id) if !find_applicable_discount(item_id)
    end
    grand_total
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
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

  def find_applicable_discount(item_id)
    item = Item.find(item_id)
    discounts = item.merchant.discounts.where("min_item_quantity <= ?", count_of(item_id))
    return discounts.order(percent_off: :desc).first.percent_off if !discounts.empty?
  end
end
