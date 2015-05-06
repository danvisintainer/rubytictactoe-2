require 'pry'

class TictactoeGame

  def initialize
    @board = []
    @x_is_human = true
    @o_is_human = true
    @current_turn = 'X'
  end

  def setup_board(n)
    n.times do |row|
      @board[row] = []
      n.times do |cell|
        @board[row][cell] = ' '
      end
    end

    print_board
  end

  def setup_game
    puts "Let's play Tic-Tac-Toe!"
    puts "Will X be a human? (y/n)"
    @x_is_human = false if gets.chomp == 'n'

    puts "Will O be a human? (y/n)"
    @o_is_human = false if gets.chomp == 'n'

    puts "How big do you want your board? (2-9)"
    setup_board(gets.chomp.to_i)
    decide_first_turn
  end

  def print_board
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
    @current_turn == 'X' ? @current_turn = 'Y' : @current_turn = 'X'
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

    puts "DEBUG: Sanitized user choice is #{result.inspect}"
    result
  end

  def is_space_taken?(sanitized_choice)
    false
  end

  def is_user_choice_valid?(choice)
    if choice.size != 2
      false
    end

    true
  end

  def fill_space(sanitized_choice)
    @board[sanitized_choice[0]][sanitized_choice[1]] = @current_turn
  end

  def human_turn
    turn_taken = false
    puts "It's your turn, #{@current_turn}. Which space do you want?"

    while !turn_taken
      choice = gets.chomp.split("")
      
      if !is_user_choice_valid?(choice)
        puts "That's not a valid choice - try again!"
      elsif is_space_taken?(sanitize_user_choice(choice))
        puts "That space is already taken! Try another one."
      else
        fill_space(sanitize_user_choice(choice))
        turn_taken = true
      end
    end
  end

  def computer_turn
    puts "It's #{@current_turn}'s turn - that's me! Hmm..."
  end

  def go
    setup_game
    start_turn
    print_board
    next_turn
  end

end

TictactoeGame.new.go