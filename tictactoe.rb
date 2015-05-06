require 'pry'

class Board

  def initialize(size)
    @board = build_board(size)
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
    board_size = @board.length

    print "  "
    board_size.times do |i|
      print " #{i + 1}  "
    end
    puts ""

    board_size.times do |row|
      print "#{(65 + row).chr} "
      board_size.times do |cell|
        output = " #{@board[row][cell]}"
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
    @board[sanitized_choice[0]][sanitized_choice[1]] != ' '
  end

  def fill_space(sanitized_choice, mark)
    @board[sanitized_choice[0]][sanitized_choice[1]] = mark
  end

  def is_winner
    result = false

    # first, we'll check to see if there's a win in any ROW.
    # here, we just traverse through the array and see if each subarray element
    # is alike. if there's an empty space (' ') in the subarray, the row can't
    # be filled, so we ignore it. 
    @board.each do |row|
      if row.uniq.length == 1 && !row.include?(' ')
        result = true 
      end
    end

    @board.length.times do |col|
      current_column = @board.length.times.map {|row| @board[row][col]}
      if current_column.uniq.length == 1 && !current_column.include?(' ')
        result = true
      end
    end

    result
  end

end

class Game

  def initialize
    @board = []
    @x_is_human = true
    @o_is_human = true
    @current_turn = 'X'
    @winner = ''
  end

  def setup_game
    puts "Let's play Tic-Tac-Toe!"
    puts "Will X be a human? (y/n)"
    @x_is_human = false if gets.chomp == 'n'

    puts "Will O be a human? (y/n)"
    @o_is_human = false if gets.chomp == 'n'

    puts "How big do you want your board? (2-9)"
    # setup_board(gets.chomp.to_i)
    @board = Board.new(gets.chomp.to_i)
    decide_first_turn
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
    result = []
    choice.each do |coord|
      if (49..57) === coord.ord # if it's a number
        result[1] = (coord.to_i) - 1
      elsif coord.ord >= 65 # if it's a letter
        result[0] = coord.ord - 65
      end
    end

    result
  end

  def is_user_choice_valid?(choice)
    if choice.size != 2
      false
    end

    true
  end

  def human_turn
    turn_taken = false
    puts "It's your turn, #{@current_turn}. Which space do you want?"

    while !turn_taken
      choice = gets.chomp.split("")
      
      if !is_user_choice_valid?(choice)
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
  end

  def go
    user_quit = false
    game_over = false

    while !user_quit 
      setup_game

      while !game_over
        @board.display
        start_turn

        # is_winner ? game_over = true : next_turn
        if @board.is_winner
          puts "There's a winner!"
          game_over = true
        else
          puts "No winner yet."
          next_turn
        end
      end
    end
  end

end

Game.new.go