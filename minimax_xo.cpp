#include <iostream>
#include <vector>
#include <cstdlib> 
#include <time.h>

using namespace std ; 

vector<vector<int>> board(3, vector<int>(3, 0)); 

void showInstruction()
{
	int k = 0 ; 
	cout << "\n____________Instruction_Table_____________\n" ;
	cout << "\n-------------------------\n\t" ; 
	for(int i = 0 ; i < 3 ; i++)
	{
		for(int j = 0 ; j < 3 ; j++)
		{
			cout << k++ << " | " ; 
		}
		cout << "\n-------------------------\n\t" ; 	
	}
	cout << "\n____________Enter_your_choice_____________\n" ;
}

void showTable()
{

	cout << "\n\n-------------------------\n\t" ; 
	for(int i = 0 ; i < 3 ; i++)
	{
		for(int j = 0 ; j < 3 ; j++)
		{
			if(board[i][j])
				cout << (board[i][j] == 1 ? 'X' : 'O' )  << " | " ;  
			else
				cout << "  | " ; 
		}
		cout << "\n-------------------------\n\t" ; 	
	}
}

int getManMove(int val)
{
	int pos ; 
	cout << "Enter the position\n" ; 
	cin >> pos ; 

	int i = pos/3 ; 
	int j = pos%3 ; 
	if(pos > 8 or pos < 0 or board[i][j])
	{
		cout << "Invalid position\n" ; 
		pos = getManMove(val); 
		return pos ; 
	}

	return pos ;  
}

bool isWinMove(int val)
{
	for(int i = 0 ; i < 3 ; i++)
	{
		if(board[i][0] == val and board[i][1] == val and board[i][2] == val)
			return true ; 

		if(board[0][i] == val and board[1][i] == val and board[2][i] == val )
			return true ; 
	}

	if(board[0][0] == val and board[1][1] == val and board[2][2] == val)
		return true ; 

	if(board[0][2] == val and board[1][1] == val and board[2][0] == val)
		return true ; 

	return false ; 
}

bool isMovesEnd()
{
    for (int i = 0; i < 3 ; i++)
        for (int j = 0 ; j < 3 ; j++)
            if (board[i][j] == 0)
                return false ;
    return true ;
}


int evaluate(int cpu, int hum)
{

	if(isWinMove(cpu))
		return 1000 ; 

	if(isWinMove(hum))
		return -1000 ; 

    return 0 ; 
}

int minimax(int player, int opponet, int depth, bool isMax)
{
	int score = evaluate(player, opponet); 

	if(score)
		return score ; 

	if(isMovesEnd())
		return 0 ; 

	if(isMax)
	{
		int best = -99999 ; 
		for(int i = 0 ; i < 3 ; i++)
		{
			for(int j = 0 ; j < 3 ; j++)
			{
				if(board[i][j] == 0) 
				{
					board[i][j] = player ; 
					best = max(best, minimax(player, opponet, depth+1, false)); 
					board[i][j] = 0 ;
				}
			}
		}
		return best ; 
	}
	else
	{
		int best = 99999 ; 
		for(int i = 0 ; i < 3 ; i++)
		{
			for(int j = 0 ; j < 3 ; j++)
			{
				if(board[i][j] == 0) 
				{
					board[i][j] = opponet ; 
					best = min(best, minimax(player, opponet, depth+1, true)); 
					board[i][j] = 0 ;
				}
			}
		}
		return best ; 		
	}
}

int cpuMove(int player, int opponet)
{
	int bestVal = -99999;
    int row = -1;
	int col = -1;

    for (int i = 0 ; i < 3; i++) 
    {
        for (int j = 0 ; j < 3; j++) 
        {
            if (board[i][j] == 0) 
            {
                board[i][j] = player ;

                int moveValue = minimax(player, opponet,  0, false);

                if (moveValue > bestVal) 
                {
                    bestVal = moveValue;
                    row = i ;
                    col = j ;
                }

                board[i][j] = 0 ;
            }
        }
    }
    board[row][col] = player ;
    cout << "\nBest Move value : " << bestVal << endl ; 
    cout << "Row : " << row << " col : " << col << endl ;   
    return (row*3)+col ;   
}

int main()
{
	int pos, moves = 0, status = 0 ;  
	int cpu, hum ; 
	bool isManMove ; 

	cout << "Wanna Play 1st or 2nd?\t(Enter 1 or 2)\n" ; 
	cin >> hum ; 
	if(hum == 1)
	{
		cout<<"\nSo your symbol is X.\nAnd mine is O.\n\nLet's start the game.";
		isManMove = true ; 
		hum = 1 ; 
		cpu = 2 ; 
	}
	else
	{
		cout<<"\nSo your symbol is O.\nAnd mine is X.\n\nLet's start the game.";
		isManMove = false ; 
		cpu = 1 ; 
		hum = 2 ; 
	}   

	while(moves < 9)
	{
		if(isManMove)
		{
			showInstruction(); 
			pos =  getManMove(hum); 
			board[pos/3][pos%3] = hum ;
			isManMove = false ; 
		}
		else
		{
			if(moves == 0)// random move in any place (corners only)
			{
				time_t sec;
		        time(&sec);
		        srand((unsigned int) sec);
		        int i = (rand()%2)*2 ;
		        int j = (rand()%2)*2 ;
		        board[i][j] = cpu ; 
		        pos = (i*3)+j ;  
			}	
			else 
				pos = cpuMove(cpu, hum); 
			isManMove = true ; 
		} 

		showTable(); 
		cout << "Last move " << pos  ;
		if(isManMove)
			cout << " by Computer\n" ;
		else
			cout << " by Human\n" ; 

		if( 3 < moves and (isWinMove((isManMove ? cpu : hum ))))
		{
			status = (isManMove ? cpu : hum ) ; 
			break ; 
		}

		moves++ ;
	}

	showTable();
	if(status == 0)
		cout << "Game Tied"  << endl ; 
	else if(status == hum)
		cout << "You won" << endl ; 
	else 
		cout << "Computer Won" << endl ;

	cout << "Wanna Play again? (Enter y/n)" ;
	char ch ; 
	cin >> ch ;  
	if(ch == 'y' or ch == 'Y')
		return main();    

	return 0 ;  
}