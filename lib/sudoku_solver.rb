class Sudoku

  NUMBERS = (1..9).to_a
  ORDINALIZE = ["first", "second", "third", "fourth", "fifth", "sixth", "seventh",
        "eighth", "ninth",]

  def solve_sudoku(puzzle)
    @rows = puzzle
    @columns = @rows.transpose
    @blocks = create_blocks(@rows)

    unknowns = {}
    updated = []

    x = 0
    while x < 9 do
      y = 0
      while y < 9 do
        which_block?(x, y)
        if @rows[x][y] == 0
          poss_in_row = NUMBERS - @rows[x]
          poss_in_column = NUMBERS - @columns[y]
          poss_in_block = NUMBERS - @blocks[@block]
          poss_nums = []
            # create array of possible numbers for each blank box
            poss_in_row.each do |num|
              poss_nums << num if poss_in_column.include?(num) && poss_in_block.include?(num)
            end
            if poss_nums.nil?
            elsif poss_nums.length == 1     # if there is only one possible number
              @rows[x][y] = poss_nums[0]     # replace the blank with that number in the puzzle
              updated << [x, y]             # add the coordinates of this to the 'updated' array
            else
              unknowns[[x, y]] = poss_nums  # if not, add the coordinates of the blank box to the 'unknowns' array
            end
          end
          y += 1
        end
        x += 1
      end

      # iterate through the board again, only checking the blanks and only if they are in
      # the same column, row, or block as a number which has been updated
      updated.each do |coords|
        coords_block = which_block?(coords[0], coords[1])
        unknowns.each do |unk_coords, poss_nums|
          unk_block = which_block?(unk_coords[0], unk_coords[1])
          if unk_coords[0] == coords[0] || unk_coords[1] == coords[1] || coords_block == unk_block
            poss_nums.delete(@rows[coords[0]][coords[1]])
          end
          if poss_nums.nil?
          elsif poss_nums.length == 1
            @rows[unk_coords[0]][unk_coords[1]] = poss_nums[0]
            unknowns.delete(unk_coords)
            updated << unk_coords
          end
        end
      end
    @solved_puzzle = @rows
  end

  def create_blocks(rows)
    blocks = Array.new(9){Array.new}
    i = 0
    j = 0
    numbers = rows.flatten.each_slice(3).to_a
    while numbers.length > 0 do
      blocks[j] << numbers.delete_at(0)
      i += 1
        if i % 3 == 0 && blocks[j].length < 3
          j -= 2
        else
          j += 1
        end
    end
    blocks.map! { |x| x.flatten }
    return blocks
  end

  def which_block?(x, y)
    which_block = {0 => [[0, 1, 2], [0, 1, 2]],
      1 => [[0, 1, 2], [3, 4, 5]],
      2 => [[0, 1, 2], [6, 7, 8]],
      3 => [[3, 4, 5], [0, 1, 2]],
      4 => [[3, 4, 5], [3, 4, 5]],
      5 => [[3, 4, 5], [6, 7, 8]],
      6 => [[6, 7, 8], [0, 1, 2]],
      7 => [[6, 7, 8], [3, 4, 5]],
      8 => [[6, 7, 8], [6, 7, 8]]
    }
    which_block.each do |block, location|
      if location[0].include?(x) && location[1].include?(y)
        @block = block
        return @block
      end
    end
  end

  def user_input
    puts "Please enter numbers in the format 123095040, with 0s to mark where blanks appear."
    i = 0
    @puzzle = []
    while i < 9 do
      puts "Please enter the #{ORDINALIZE[i]} row of numbers."
      list = gets.chomp
      while list.scan(/\D/).empty? == false || list.length != 9 do
        puts "Please enter the row of numbers in the correct format."
        list = gets.chomp
      end
      row = []
      list.split("").each { |x| row << x.to_i }
      @puzzle << row
      i += 1
    end
    return @puzzle
  end

  def array_to_board(array)
    board = ""
    x = 0
    array.each do |row|
      y = 0
      while y < 9 do
        board << row[y].to_s
        y += 1
        board << " | " if (y) % 3 == 0 && y != 0 && y != 9
      end
      board += "\n"
      x += 1
      if x % 3 == 0 && x != 9
        board << "-----------------"
        board += "\n"
      end
    end
    print board
  end

  def solve_user_puzzle
    user_input
    solve_sudoku(@puzzle)
    print array_to_board(@solved_puzzle)
  end

end

#puzzle = Sudoku.new
#puzzle.solve_user_puzzle
