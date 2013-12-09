require 'time'

def check_validity(amount)
  if amount.match(/\A\d+(\.\d{0,2})?\z/) == nil
    puts "Invalid input.... exiting"
    abort
  end
end

puts "Amount due:"
amount_due = gets.chomp
check_validity(amount_due)

puts "Amount tendered: "
amount_tendered = gets.chomp
check_validity(amount_tendered)

t = Time.now

customer_change = (amount_tendered.to_f - amount_due.to_f).round(2)

if amount_due.to_f > amount_tendered.to_f
  puts "WARNING: You still owe $#{customer_change.abs}. Exiting."
  abort
end

puts "==================== Thank You! ================================"
puts "your change is $#{customer_change}"
puts ""
puts "Your order was processed at #{t.strftime("%m/%d/%Y at %I:%M%P")}"
puts "================================================================"