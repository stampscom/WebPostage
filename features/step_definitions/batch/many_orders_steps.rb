When /^Print (\d+) new orders with Address set to (.*) and Service set to (.*)$/ do |count, address, service|
  count.to_i.times {
    step "I Add a new order"
    step "Set Ship From to default"
    #SETTING RECIPIENT ADDRESS
    step "Set Ship-To address to #{address}"
    #SETTING SERVICE
    step "Set Service to #{service}"
    #PRINTING
    step "Print"
  }
end

Then /^Create (\d+) new orders with Address set to (.*) and Service set to (.*)$/ do |count, address, service|
  count.to_i.times { |iteration|
    step "I Add a new order"
    step "Set Ship From to default"
    #SETTING RECIPIENT ADDRESS
    step "Set Ship-To address to #{address}"
    #SETTING SERVICE
    step "Set Service to #{service}"
    log "Order #{iteration} created."
    sleep(1)
  }
end