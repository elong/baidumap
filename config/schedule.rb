ak ="????"

every 180.day do
  rake "poi:fetch_metro[#{ak}]"
end

every 180.day do
  rake "poi:fetch_bus[#{ak}]"
end

every 180.day do
  rake "poi:fetch_bank[#{ak}]"
end

every 180.day do
  rake "poi:fetch_spot[#{ak}]"
end

every 180.day do
  rake "poi:fetch_cafe[#{ak}]"
end



