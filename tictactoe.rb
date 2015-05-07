require 'pry'

class Board
  attr_reader :winner, :size, :board_array

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
    board_size = board_array.length

    print "  "
    board_size.times do |i|
      print " #{i + 1}  "
    end
    puts ""

    board_size.times do |row|
      print "#{(65 + row).chr} "
      board_size.times do |cell|
        output = " #{board_array[row][cell]}"
        output += " |" unless (cell + 1) == board_size
        print output
      end
      
      print "\n  "
      
      board_size.times do |i|
        output = '---'
        output += '+' unless (i + 1) == board_size
        print output
      end unless (row + 1) == board_size
      
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
        @winner = row.uniq.first 
      end
    end

    # now we check for a win in all columns. this is a little trickier given
    # the arrays-in-arrays setup, but the logic is similar. we make temp arrays
    # so we can quickly check to see if all elements are identical
    board_array.length.times do |col|
      current_column = board_array.length.times.map {|row| board_array[row][col]}
      if current_column.uniq.length == 1 && !current_column.include?(' ')
        @winner = current_column.uniq.first
      end
    end

    # now we check for diagonal wins. same logic as before.
    diagonal = board_array.length.times.map {|i| board_array[i][i]}
    if diagonal.uniq.length == 1 && !diagonal.include?(' ')
      @winner = diagonal.uniq.first
    end

    diagonal = board_array.length.times.map {|i| board_array[(board_array.length - 1) - i][i]}
    if diagonal.uniq.length == 1 && !diagonal.include?(' ')
      @winner = diagonal.uniq.first
    end

    # and finally, if the board is filled up and there are no wins, it must
    # be a draw.
    if @spaces_available == 0 && !@winner
      @winner = 'draw'
    end
  end

end

class Game

  def initialize
    @x_is_human = true
    @o_is_human = true
    @current_turn = 'X'
    @winner = ''
  end

  def print_intro
    puts <<-intro
Welcome to Dan Visintainer's Tic-Tac-Toe!
Remember, the only winning move is not to play.

To pick your space, enter the space's coordinates using the board
displayed below. For example, to take the upper-left spot, enter
"A1". "a1" or "1A" will also work.
    intro
  end

  def setup_game
    puts "Let's play Tic-Tac-Toe!"
    puts "Will X be a human? (y/n)"
    @x_is_human = false if gets.chomp == 'n'

    puts "Will O be a human? (y/n)"
    @o_is_human = false if gets.chomp == 'n'

    puts "How big do you want the board? (2-9)"
    # setup_board(gets.chomp.to_i)
    @board = Board.new(gets.chomp.to_i)
  end

  def is_human?(player)
    if player == 'X'
      @x_is_human
    elsif player == 'O'
      @o_is_human
    end
  end

  def decide_first_turn
    [true, false].sample ? @current_turn = 'X' : @current_turn = 'O'
    puts "I've thought about this, and I think #{@current_turn} should go first!"
  end

  def start_turn
    is_human?(@current_turn) ? human_turn : computer_turn
  end

  def next_turn
    @current_turn == 'X' ? @current_turn = 'O' : @current_turn = 'X'
  end

  def sanitize_user_choice(choice)
    if choice.size != 2
      false
    else
      result = []
      choice.each do |coord|
        if (49..57) === coord.ord # if it's a number
          result[1] = (coord.to_i) - 1 unless (coord.to_i) - 1 > @board.size
        elsif (65..73) === coord.ord # if it's a letter
          result[0] = coord.ord - 65  unless coord.ord - 65 >= @board.size
        elsif (97..105) === coord.ord # if it's a lowercase letter
          result[0] = coord.ord - 97 unless coord.ord - 97 >= @board.size
        end
      end

      if result.empty? || result.include?(nil)
        false
      else
        result
      end
    end
  end

  def human_turn
    turn_taken = false
    puts "It's your turn, #{@current_turn}. Which space do you want?"

    while !turn_taken
      choice = gets.chomp.split("")
      
      if !sanitize_user_choice(choice)
        puts "That's not a valid choice - try again!"
      elsif @board.is_space_taken?(sanitize_user_choice(choice))
        puts "That space is already taken! Try another one."
      else
        @board.fill_space(sanitize_user_choice(choice), @current_turn)
        turn_taken = true
      end
    end
  end

  def computer_turn
    puts "It's #{@current_turn}'s turn - that's me! Hmm..."

    # first and foremost, the computer will check to see if it can win the
    # game, and if it can, it'll do so over anything else.
    if take_win(@current_turn)
    # if it can't win, it'll check to see if it can prevent its opponent from
    # winning.
    elsif cut_off_opponent(@current_turn)
    else
      # and if nothing else, it'll just pick a random space.
      fill_random_space(@current_turn)
    end
  end

    # for the computer player, this will just fill a random space.
  def fill_random_space(mark)
    space_filled = false
    while !space_filled
      row = rand(@board.size)
      col = rand(@board.size)
      if !is_space_taken?([row, col])
        @board.fill_space([row, col], mark)
        space_filled = true
      end
    end
  end

  # for the computer player, this will fill the last space required to win, if
  # possible.
  def take_win(mark)
    placed = false

    # check rows for possible win...
    binding.pry
    @board.each_with_index do |row, i|
      if row.count(mark) == @board.length - 1 && row.count(' ') == 1
        @board.fill_space([i, row.index(' ')], mark)
        placed = true
      end
    end

    if !placed
      @board.length.times do |col|
        current_column = @board.length.times.map {|row| @board[row][col]}
        if current_column.count(mark) == @board.length - 1 && current_column.count(' ') == 1
          @board.fill_space([current_column.index(' '), col], mark)
          placed = true
        end
      end

      if !placed
        diagonal = @board.length.times.map {|i| @board[i][i]}
        if diagonal.count(mark) == @board.length - 1 && diagonal.count(' ') == 1
          @board.fill_space([diagonal.index(' '), diagonal.index(' ')], mark)
          placed = true
        end

        if !placed
          diagonal = @board.length.times.map {|i| @board[(@board.length - 1) - i][i]}
          if diagonal.count(mark) == @board.length - 1 && diagonal.count(' ') == 1
            @board.fill_space([(@board.length - diagonal.index(' ') - 1), diagonal.index(' ')], mark)
            placed = true
          end
        end
      end
    end

    placed
  end

  # for the computer player, this will fill a space in an attempt to keep the
  # opponent from winning the game.
  def cut_off_opponent(mark)
    mark == 'X' ? opponent = 'O' : opponent = 'X'
    placed = false

    @board.each_with_index do |row, i|
      if row.count(opponent) == @board.length - 1 && row.count(' ') == 1
        @board.fill_space([i, row.index(' ')], mark)
        placed = true
      end
    end

    if !placed
      @board.length.times do |col|
        current_column = @board.length.times.map {|row| @board[row][col]}
        if current_column.count(opponent) == @board.length - 1 && current_column.count(' ') == 1
          @board.fill_space([current_column.index(' '), col], mark)
          placed = true
        end
      end

      if !placed
        diagonal = @board.length.times.map {|i| @board[i][i]}
        if diagonal.count(opponent) == @board.length - 1 && diagonal.count(' ') == 1
          @board.fill_space([diagonal.index(' '), diagonal.index(' ')], mark)
          placed = true
        end

        if !placed
          diagonal = @board.length.times.map {|i| @board[(@board.length - 1) - i][i]}
          if diagonal.count(opponent) == @board.length - 1 && diagonal.count(' ') == 1
            @board.fill_space([(@board.length - diagonal.index(' ') - 1), diagonal.index(' ')], mark)
            placed = true
          end
        end
      end
    end

    placed
  end

  def go
    user_quit = false

    while !user_quit 
      game_over = false
      setup_game
      print_intro
      decide_first_turn

      while !game_over
        @board.display
        start_turn

        if @board.winner
          @board.display
          if @board.winner == 'draw'
            puts "Ooh, nobody won this one."
          else
            puts "#{@board.winner} has won the game!"
          end
          game_over = true
        else
          next_turn
        end
      end

      puts "Would you like to play again? Enter 'q' to quit."
      input = gets.chomp
      user_quit = true if input == 'q' || input == 'Q'
    end
  end

end

Game.new.go