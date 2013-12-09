require 'time'
balance = 0
total_amount = Array.new
t = Time.now

def check_validity(amount)
  if amount.match(/\A\d+(\.\d{0,2})?\z/) == nil
    puts "Invalid input.... exiting"
    abort
  end
end

while true
  puts "What is the sale price? (when finished type \"done\")"
  input_amount = gets.chomp
  if input_amount == 'done'
    break
  else
    check_validity(input_amount)
    balance += input_amount.to_f
    total_amount << input_amount
    puts "Subtotal:  $#{balance}"
  end
end
puts
puts "Here are your items prices:"
for item in total_amount do
  puts "$#{item}"
end
puts
puts "The total amount due is $#{balance}"
puts
puts "What is the amount tendered?"
amount_tendered = gets.chomp
check_validity(amount_tendered)
customer_change = (amount_tendered.to_f - balance.to_f)
if balance.to_f > amount_tendered.to_f
  puts "WARNING: You still owe $#{customer_change.abs}. Exiting."
  abort
end
puts "==================== Thank You! ================================"
puts "your change is $#{customer_change}"
puts
puts "Your order was processed at #{t.strftime("%m/%d/%Y at %I:%M%P")}"
puts "================================================================"