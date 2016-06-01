class GameController < ApplicationController

  def try
    #check if there is a cookie key secretnumber saved
    if session[:secretnumber].nil?
      reset_game
    end

    @secret_number = session[:secretnumber].to_i
    @used_guesses = session[:usedguesses]
    @counter = cookies[:counter].to_i

    #saves argument passed from browser into variable number and turns it into an integer
    @guess = params[:guess].to_i
    #checks if the number is equal to secretnumber
    if @guess == @secret_number
      @result = @guess.to_s + " is correct! You WIN!"
      reset_game
    else
      #checks to see if guess has already been guessed and does not decremen remaining guesses
      if @used_guesses.include?(" " + params[:guess] + " ")
        @result = "You already guessed " + params[:guess] + ". Please guess another number."
      else
        #if there are still guesses remaining check guess for being too high or too low
        #FIXME guess counter is off by one
        decrement_counter
        if @counter > 0
          save_guess params[:guess]
          # checks if the number is greater than secretnumber
          if @guess > @secret_number
            @result = params[:guess] + " is too high! Guess again"
          else
            @result = params[:guess] + " is too low! Guess again!"
          end
        else
          #when there are no more guesses left, game ends
          @result = "You have used all your guesses. You Lose."
        end
      end
    end
    #renders the page
    render "try.html.erb"
  end

  def save_guess new_guess
    session[:usedguesses] = session[:usedguesses] + new_guess + " "
  end

  def decrement_counter
    @counter = @counter - 1
    cookies[:counter] = @counter
  end

  def reset_game
    #saves a new random number as value of secretnumber
    session[:secretnumber] = Random.rand(101)
    session[:usedguesses] = "Used Guesses: "
    cookies[:counter] = 7
  end

end
