lines = File.open('input.txt').lines.map(&:chomp)

rows = lines.map { |line| line.split('') }

columns = rows.transpose

# part 1
search_str = 'XMAS'

across = rows.map do |row|
  row_letters = row.join('')
  forward_count = row_letters.scan(search_str).count
  backward_count = row_letters.scan(search_str.reverse).count

  forward_count + backward_count
end

down = columns.map do |column|
  column_letters = column.join('')
  forward_count = column_letters.scan(search_str).count
  backward_count = column_letters.scan(search_str.reverse).count

  forward_count + backward_count
end

def diag_count?(rows, row, col, str)
  search_len = str.length - 1
  prev_rows_all_exist = row - search_len >= 0
  prev_cols_all_exist = col - search_len >= 0

  down_right = str.chars.each_with_index.all? do |char, i|
    rows[row + i]&.[](col + i) == char
  end

  down_left = prev_cols_all_exist &&
    str.chars.each_with_index.all? do |char, i|
      rows[row + i]&.[](col - i) == char
    end

  up_right = prev_rows_all_exist &&
    str.chars.each_with_index.all? do |char, i|
      rows[row - i]&.[](col + i) == char
    end

  up_left = prev_rows_all_exist && prev_cols_all_exist &&
    str.chars.each_with_index.all? do |char, i|
      rows[row - i]&.[](col - i) == char
    end

  { up_left: up_left, up_right: up_right, down_right: down_right, down_left: down_left }
end

num_diag = 0

rows.each_with_index do |row, row_index|
  row.each_index do |col_index|
    num_diag += diag_count?(rows, row_index, col_index, search_str).values.filter(&:itself).count
  end
end

puts "part 1: #{across.sum + down.sum + num_diag}"

# part 2

xmas_search_str = 'MAS'
num_xmas = 0

rows.each_with_index do |row, row_index|
  row.each_index do |col_index|
    has_mas_fwd = diag_count?(rows, row_index, col_index, xmas_search_str)[:down_right]
    has_sam_fwd = diag_count?(rows, row_index, col_index, xmas_search_str.reverse)[:down_right]

    # check if the other part of the x exists two cols down
    has_mas_bwd = diag_count?(rows, row_index, col_index + 2, xmas_search_str)[:down_left]
    has_sam_bwd = diag_count?(rows, row_index, col_index + 2, xmas_search_str.reverse)[:down_left]

    num_xmas += 1 if (has_mas_fwd || has_sam_fwd) && (has_mas_bwd || has_sam_bwd)
  end
end

puts "part 2: #{num_xmas}"
