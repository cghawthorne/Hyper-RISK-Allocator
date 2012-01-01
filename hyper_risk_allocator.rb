#!/usr/bin/ruby

NUM_PLAYERS = 5

# A player can own at most (N - MIN_TO_CONQUER) territories in a region with N
# territories to prevent getting a territory bonus too early in the game.
MIN_TO_CONQUER = 2

#####

groups = [[]]
players = Array.new(NUM_PLAYERS) { Array.new }

country_counter = 0
group_counter = 0
File.open("countries.txt", "r").each_line do |line|
  if line.start_with? '*' then
    groups.push([])
    group_counter += 1
    next
  end

  groups[group_counter].push([line.chomp, group_counter])
  country_counter += 1
end

puts "#{country_counter} countries"
puts "******"
puts

global_territory_totals = Array.new(groups.length) do |group|
  groups[group].length
end

while groups.length > 0
  players.each do |player|
    if groups[0].length == 0 then
      groups.shift
    end
    if groups.length == 0 then
      break
    end
    player.push(groups[0].slice!(rand(groups[0].length)))
  end
end

players.each_index do |player_idx|
  player_territory_count = Hash.new(0)

  player = players[player_idx]
  puts "Player #{player_idx+1}"
  puts "#{player.length} countries"
  puts "------"
  player.each do |country|
    puts country[0]
    player_territory_count[country[1]] += 1
  end
  puts "======"
  puts

  # Check for unfair territory advantage
  player_territory_count.each_pair do |territory, count|
    if count > (global_territory_totals[territory] - MIN_TO_CONQUER) then
      puts "Player has unfair advantage! Run again."
      exit
    end
  end
end
