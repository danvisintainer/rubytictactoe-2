class Board
  attr_accessor :winner, :size, :board_array

  def initialize(size)
    @board_array = build_board(size)
    @winner = false
    @spaces_available = size * size
    @size = size
  end

  def build_board(size)
    new_board = []
    size.times do |row|
      new_board[row] = []
      size.times do |cell|
        new_board[row][cell] = ' '
      end
    end

    new_board
  end

  def display
    print "  "
    size.times do |i|
      print " #{i + 1}  "
    end
    puts ""

    size.times do |row|
      print "#{(65 + row).chr} "
      size.times do |cell|
        output = " #{board_array[row][cell]}"
        output += " |" unless (cell + 1) == size
        print output
      end
      
      print "\n  "
      
      size.times do |i|
        output = '---'
        output += '+' unless (i + 1) == size
        print output
      end unless (row + 1) == size
      
      puts ""
    end
  end

  def is_space_taken?(sanitized_choice)
    board_array[sanitized_choice[0]][sanitized_choice[1]] != ' '
  end

  def fill_space(sanitized_choice, mark)
    board_array[sanitized_choice[0]][sanitized_choice[1]] = mark
    @spaces_available -= 1
    check_for_and_set_winner
  end

  def check_for_and_set_winner
    # first, we'll check to see if there's a win in any ROW.
    # here, we just traverse through the array and see if each subarray element
    # is alike. if there's an empty space (' ') in the subarray, the row can't
    # be filled, so we ignore it. 
    board_array.each do |row|
      if row.uniq.length == 1 && !row.include?(' ')
        self.winner = row.uniq.first 
      end
    end

    # now we check for a win in all columns. this is a little trickier given
    # the arrays-in-arrays setup, but the logic is similar. we make temp arrays
    # so we can quickly check to see if all elements are identical
    board_array.length.times do |col|
      current_column = board_array.length.times.map {|row| board_array[row][col]}
      if current_column.uniq.length == 1 && !current_column.include?(' ')
        self.winner = current_column.uniq.first
      end
    end

    # now we check for diagonal wins. same logic as before.
    diagonal = board_array.length.times.map {|i| board_array[i][i]}
    if diagonal.uniq.length == 1 && !diagonal.include?(' ')
      self.winner = diagonal.uniq.first
    end

    diagonal = board_array.length.times.map {|i| board_array[(board_array.length - 1) - i][i]}
    if diagonal.uniq.length == 1 && !diagonal.include?(' ')
      self.winner = diagonal.uniq.first
    end

    # and finally, if the board is filled up and there are no wins, it must
    # be a draw.
    if @spaces_available == 0 && !self.winner
      self.winner = 'draw'
    end
  end

end