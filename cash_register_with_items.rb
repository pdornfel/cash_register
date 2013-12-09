require 'pry'

require 'time'
t = Time.now

def check_validity(amount)
  if amount.match(/\A\d+(\.\d{0,2})?\z/) == nil
    puts "Invalid input.... exiting"
  end
end

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
puts
puts "What is the amount tendered?"
amount_tendered = gets.chomp
check_validity(amount_tendered)
customer_change = (amount_tendered.to_f - order_total.to_f)
while order_total.to_f > amount_tendered.to_f
  puts "WARNING: You still owe $#{customer_change.abs}."
  puts "You only entered $#{amount_tendered}"
  puts "Enter new amount tendered."
  amount_tendered = gets.chomp
end
customer_change = (amount_tendered.to_f - order_total.to_f)
puts "==================== Thank You! ================================"
puts "your change is $#{customer_change}"
puts
puts "Your order was processed at #{t.strftime("%m/%d/%Y at %I:%M%P")}"
puts "================================================================"