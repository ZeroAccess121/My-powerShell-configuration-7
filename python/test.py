   """Prompts the user for a valid move."""
    while True:
        try:
            move = int(input(Fore.YELLOW + f"Player {current_player}, enter your move (1-9): ")) - 1
            row, col = divmod(move, 3)

            if board[row][col] == EMPTY:
                return row, col
            else:
                print(Fore.RED + "This position is already taken. Try again.")
        except (ValueError, IndexError):
            print(Fore.RED + "Invalid move! Please enter a number between 1 and 9.")


def switch_player():
    """Switches the current player."""
    global current_player
    current_player = PLAYER_O if current_player == PLAYER_X else PLAYER_X


def main():
    """Main game loop."""
    print_board()
    
    while True:
        row, col = get_move()
        board[row][col] = current_player
        
        print_board()
        
        winner = check_winner()
        if winner:
            print(Fore.GREEN + f"Player {winner} wins!")
            break
        
        if is_board_full():
            print(Fore.YELLOW + "It's a tie!")
            break
        
        switch_player()

    # Ask if the player wants to play again
    play_again = input(Fore.CYAN + "Do you want to play again? (y/n): ").strip().lower()
    if play_again == 'y':
        global board
        board = [[EMPTY] * 3 for _ in range(3)]
        main()
    else:
        print(Fore.RED + "Thanks for playing!")


if __name__ == "__main__":
    main()


