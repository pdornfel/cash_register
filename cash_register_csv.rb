require 'CSV'
require 'pry'
require 'time'
require 'pp'

puts "Welcome to James' Coffee Emporium!
1) enter order mode
2) enter reporting mode
3) exit"

mode_choice = gets.chomp.to_i

if mode_choice == 1
  `clear`
  #is the input 1,2,3,4?
  def is_valid_item?(input, max_input)  # input is a string
    /\A[1-#{max_input}]\z/.match(input)
  end

  #is it a number
  def is_valid_num?(input)  # input is a string
    /\A\d+(\.\d{0,2})?\z/.match(input)
  end

  def is_valid_range?(order_total, tendered)
    tendered.to_f >= order_total
  end



  #ask for the item number 1,2,3,4
  def ask_item (max_input)
    puts 'What item is being purchased?'
    item = gets.chomp
    #check if they've put in a valid item
    if is_valid_item?(item, max_input)
      item
    else
      puts "not valid input"
      ask_item(max_input)
    end
  end

  def ask_tendered (order_total)
    puts 'What is the amount tendered?'
    tendered = gets.chomp
    #check if they've put in a valid item
    if is_valid_num?(tendered) && is_valid_range?(order_total, tendered)
      tendered.to_f
    else
      puts "You owe $#{order_total}, please enter valid input"
      ask_tendered(order_total)
    end
  end


  # number of bags for specific item
  def ask_quantity
    puts "How many bags?"
    gets.chomp.to_i
  end

  def find_partial_order(order, choice)
    order.each do |past_partial_order|
      return past_partial_order if past_partial_order[:sku] == choice
    end
    nil
  end

  # def find_partial_order(order, choice)
  #   order.find { |past_partial_order| past_partial_order[:sku] == choice }
  # end

  def find_desc(items, choice)
    items.each do |item|
      return item[:item] if item[:sku] == choice
    end
  end

  def find_retail_price(items, choice)
    items.each do |item|
      return item[:retail_price].to_f if item[:sku] == choice
    end

  end

  def find_purchase_price(items, choice)
    items.each do |item|
      return item[:purchase_price].to_f if item[:sku] == choice
    end
  end

  # read and parse CSV method

  def parse_csv(file_name)
    data = IO.read file_name
    # data = CSV.read(file_name, headers:true)
    data = CSV.parse(data)
  end

  def write_partial_orders (csv, order)
    order.each do |partial_order|
      csv << partial_order.values
    end
  end

  menu_data_csv = parse_csv("product_menu.csv")

  menu_data_csv.each_with_index do |item, index|
    next if index == 0
    puts "#{item[0]}) Add item - $#{item[3]} - #{item[1]}"
    if index == menu_data_csv.length-1
      puts "#{index+1}) - Complete Sale"
    end
  end

  #creating items (array of hashes)
  items = []
  menu_data_csv.each_with_index do |row, index|
    next if index == 0
    item = {}
    item[:sku] = row[0]
    item[:item] = row[1]
    item[:purchase_price] = row[2]
    item[:retail_price] = row[3]
    items << item
  end

  order_total = 0.00
  # A collection of choices for a paticular transaction
  order = []
  choice = ask_item(items.length+1)

  until choice == ((items.length) + 1).to_s
    past_partial_order = find_partial_order(order, choice)
    if past_partial_order
      order_total -= past_partial_order[:line_total]
      past_partial_order[:quantity] = ask_quantity
      past_partial_order[:line_total] = past_partial_order[:quantity] * past_partial_order[:retail_price]
      order_total += past_partial_order[:line_total]

      puts "==============="
      puts "(adjusted) #{past_partial_order[:item]} - Bags: #{past_partial_order[:quantity]} - $#{past_partial_order[:line_total]}"
      puts "(adjusted) Total: $#{order_total}"
      puts "==============="
    else
      partial_order = {}
      partial_order[:sku] = choice
      partial_order[:item] = find_desc(items, choice)
      partial_order[:quantity] = ask_quantity
      partial_order[:retail_price] = find_retail_price(items, choice)
      partial_order[:purchase_price] = find_purchase_price(items, choice)
      partial_order[:line_total] = partial_order[:quantity] * partial_order[:retail_price]
      order_total += partial_order[:line_total]
      order << partial_order

      puts "================"
      puts "#{partial_order[:item]} - Bags: #{partial_order[:quantity]} - $#{partial_order[:line_total]}"
      puts "Total: $#{order_total}"
      puts "================"
    end

    choice = ask_item(items.length + 1)
  end

  t = Time.now
    order.each do |line|
    line[:date] = t.strftime("%m/%d/%Y")
    line[:time] = t.strftime( "%I:%M:%S %P")
    line[:order_total] = order_total
  end

  puts "====Sale Complete===="
  puts
  puts "Total: $#{order_total}"
  puts

  amount_tendered = ask_tendered(order_total)
  customer_change = (amount_tendered - order_total)

  puts "==================== Thank You! ================================"
  puts "your change is $#{customer_change}"
  puts
  puts "Your order was processed at #{t.strftime("%m/%d/%Y at %I:%M%P")}"
  puts "================================================================"


  if File.exists?("order_tracker.csv")
    CSV.open("order_tracker.csv", "a") do |csv|
      write_partial_orders(csv, order)
    end
  else
    CSV.open("order_tracker.csv", "a") do |csv|
      csv<<order.first.keys
      write_partial_orders(csv, order)
    end
  end

elsif mode_choice == 2

  # REPORTING MODE

  def parse_order_tracker (file_name)
    raw_orders = File.read(file_name)
    CSV.parse(raw_orders, headers:true)
  end

  def ask_date
    puts "Specify a date to view records"
    puts "\"mm/dd/yyyy\""
    chosen_date = gets.chomp
    if valid_date?(chosen_date)
      chosen_date
    else
      puts "Enter a valid date"
      ask_date
    end
  end

  def valid_date?( str, format="%m/%d/%Y" )
    Date.strptime(str,format) rescue false
  end

  order = parse_order_tracker('order_tracker.csv')

  chosen_date = ask_date

  date_info = []

  order.each do |row|
    if chosen_date == row['date']
      date_info << row
    end
  end

p date_info[0]['order_total']

day_total = 0.00
CSV.open('date_range_data.csv', 'w') do |csv|
      csv << ["Sku", "Item", "Quantity", "Retail Price", "Purchase Price", "Item Total", "Date", "Time", "Order Total"]
      date_info.each do |row|
        csv << row
        day_total += row['order_total'].to_f
      end
    csv << ['','','','','', '', '', '', day_total]
  end
 puts "=========================="
 puts "Total Revenue = #{day_total}"
  `open date_range_data.csv`
end
