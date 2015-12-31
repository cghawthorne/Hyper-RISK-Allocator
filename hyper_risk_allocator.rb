#!/usr/bin/ruby

NUM_PLAYERS = 4

# A player can own at most (N - MIN_TO_CONQUER) territories in a region with N
# territories to prevent getting a territory bonus too early in the game.
MIN_TO_CONQUER = 2

#####

countries = []
countries_by_territory = []
players = Array.new(NUM_PLAYERS) { Array.new }

country_counter = 0
territory_counter = 0
File.open("countries.txt", "r").each_line do |line|
  if line.start_with? '*' then
    countries_by_territory.push(country_counter)
    territory_counter += 1
    country_counter = 0
    next
  end

  countries.push([line.chomp, territory_counter])
  country_counter += 1
end

puts "#{countries.length} countries"
puts "#{territory_counter} territories"
puts "#{players.length} players"
puts "******"
puts

while countries.length > 0
  players.each do |player|
    if countries.length == 0 then
      break
    end
    player.push(countries.slice!(rand(countries.length)))
  end
end

players.each_index do |player_idx|
  player_territory_count = Hash.new(0)

  player = players[player_idx]
  puts "Player #{player_idx+1}"
  puts "#{player.length} countries"
  puts "------"
  player.each do |country|
    puts "#{country[0]}" # - territory #{country[1]}"
    player_territory_count[country[1]] += 1
  end
  puts "======"
  puts

  # Check for unfair territory advantage
  player_territory_count.each_pair do |territory, count|
    if count > (countries_by_territory[territory] - MIN_TO_CONQUER) then
      puts "Player #{player_idx+1} has an unfair advantage in territory " +
        "#{territory}! Run again."
      exit
    end
  end
end
