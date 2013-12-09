items_and_prices = {
  1 => ["Light Bag", 5],
  2 => ["Medium Bag", 7.5],
  3 => ["Bold Bag", 9.75],
  4 => ["Complete Sale",0]
}
order = {}
order_total = 0
puts "Welcome to James' Coffee Emporium!"
puts
items_and_prices.each do |key, item|
  if item[0] == "Complete Sale"
    puts "#{key}) Complete Sale"
  else
    puts "#{key}) Add item - $#{item[1]} - #{item[0]}"
  end
end

puts "Make a selection?"

while true
  selection = gets.chomp.to_i
  if selection == 4
    break
  end
  item_selected = items_and_prices[selection][0]

  puts "How many bags?"
  qty_ordered = gets.chomp.to_i

  order[item_selected] = qty_ordered, ((qty_ordered * items_and_prices[selection][1]).to_f)

  subtotal = (qty_ordered * items_and_prices[selection][1]) + order_total
  puts "Subtotal: $#{subtotal}"
  order_total = subtotal


  puts "What item is being purchased?"
end

puts "====Sale Complete===="
order.each do |item , qty|
  puts "$#{qty[1]} - #{qty[0]} #{item}"
end
puts
puts "Total: $#{order_total}"







