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
    input = ''
    puts "Let's play Tic-Tac-Toe!"

    while !'YyNn'.include?(input) || input == ''
      puts "Will X be a human? (y/n)"
      input = gets.chomp

      if input == 'Y' || input == 'y'
        @x_is_human = true
      elsif input == 'N' || input == 'n'
        @x_is_human = false
      end
    end

    input = ''
    while !'YyNn'.include?(input) || input == ''
      puts "Will O be a human? (y/n)"
      input = gets.chomp

      if input == 'Y' || input == 'y'
        @o_is_human = true
      elsif input == 'N' || input == 'n'
        @o_is_human = false
      end
    end

    input = ''
    while !((2..9) === input.to_i)
      puts "How big do you want the board? (2-9)"
      input = gets.chomp
    end

    @board = Board.new(input.to_i)
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
      if !@board.is_space_taken?([row, col])
        @board.fill_space([row, col], mark)
        space_filled = true
      end
    end
  end

  # for the computer player, this will fill the last space required to win, if
  # possible. the computer will do this before anything else.
  def take_win(mark)
    placed = false

    # check rows for possible win...
    @board.board_array.each_with_index do |row, i|
      if row.count(mark) == @board.size - 1 && row.count(' ') == 1
        @board.fill_space([i, row.index(' ')], mark)
        placed = true
      end
    end

    # check columns for a possible win, only if a piece hasn't been placed.
    if !placed
      @board.size.times do |col|
        current_column = @board.size.times.map {|row| @board.board_array[row][col]}
        if current_column.count(mark) == @board.size - 1 && current_column.count(' ') == 1
          @board.fill_space([current_column.index(' '), col], mark)
          placed = true
        end
      end

      # check diagonals for a win
      if !placed
        diagonal = @board.size.times.map {|i| @board.board_array[i][i]}
        if diagonal.count(mark) == @board.size - 1 && diagonal.count(' ') == 1
          @board.fill_space([diagonal.index(' '), diagonal.index(' ')], mark)
          placed = true
        end

        if !placed
          diagonal = @board.size.times.map {|i| @board.board_array[(@board.size - 1) - i][i]}
          if diagonal.count(mark) == @board.size - 1 && diagonal.count(' ') == 1
            @board.fill_space([(@board.size - diagonal.index(' ') - 1), diagonal.index(' ')], mark)
            placed = true
          end
        end
      end
    end

    placed
  end

  # for the computer player, this will fill a space in an attempt to keep the
  # opponent from winning the game. this is second in priority. the logic used
  # here is similar to the possible win checker.
  def cut_off_opponent(mark)
    mark == 'X' ? opponent = 'O' : opponent = 'X'
    placed = false

    @board.board_array.each_with_index do |row, i|
      if row.count(opponent) == @board.size - 1 && row.count(' ') == 1
        @board.fill_space([i, row.index(' ')], mark)
        placed = true
      end
    end

    if !placed
      @board.size.times do |col|
        current_column = @board.size.times.map {|row| @board.board_array[row][col]}
        if current_column.count(opponent) == @board.size - 1 && current_column.count(' ') == 1
          @board.fill_space([current_column.index(' '), col], mark)
          placed = true
        end
      end

      if !placed
        diagonal = @board.size.times.map {|i| @board.board_array[i][i]}
        if diagonal.count(opponent) == @board.size - 1 && diagonal.count(' ') == 1
          @board.fill_space([diagonal.index(' '), diagonal.index(' ')], mark)
          placed = true
        end

        if !placed
          diagonal = @board.size.times.map {|i| @board.board_array[(@board.size - 1) - i][i]}
          if diagonal.count(opponent) == @board.size - 1 && diagonal.count(' ') == 1
            @board.fill_space([(@board.size - diagonal.index(' ') - 1), diagonal.index(' ')], mark)
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