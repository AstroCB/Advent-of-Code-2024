input = File.read('input.txt')

# part 1
pairs = input.lines.map do |line|
  first, snd = line.split(' ')
  [first.to_i, snd.to_i]
end

list_a, list_b = pairs.transpose.map(&:sort)
distances = list_a.zip(list_b).map do |a, b|
  (a - b).abs
end

puts "part 1: #{distances.sum}"

# part 2
frequency_map = list_b.reduce({}) do |acc, num|
  acc[num] = acc.fetch(num, 0) + 1

  acc
end

similarity_score = list_a.reduce(0) do |acc, num|
  multiplier = frequency_map.fetch(num, 0)

  acc + (num * multiplier)
end

puts "part 2: #{similarity_score}"
