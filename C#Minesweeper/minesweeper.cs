using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

/*
 * Project 1 Conversion from C.
 */
namespace MinesweeperProject
{
    class Minesweeper
    {
        public const int BOARD_SIZE_MIN = 5;
        public const int BOARD_SIZE_MAX = 15;
        public const int PCT_MINES_MIN = 10;
        public const int PCT_MINES_MAX = 70;
        public enum Status { WON, INPROGRESS, LOST}
        public struct Cell
        {
            public int nbr_mines { get; set; }
            public bool is_mine { get; set; }
            public bool visible { get; set; }
        }
        public static void Main(string[] args)
        {
            Minesweeper game = new Minesweeper();
        }

        public Minesweeper()
        {
            int row = 0, col = 0, size, nbrMines;
            char command;
            bool displayMines = false;
            Status gameState = Status.INPROGRESS;

            Console.WriteLine("!!!!!!!WELCOME TO THE MINESWEEPER GAME!!!!!!");
            size = getBoardSize();

            Cell[,] board = new Cell[size,size];
            initBoard(size, board);

            nbrMines = (int)(size * size * (getPercentMines() / 100.0));
            placeMinesOnBoard(size, board, nbrMines);

            fillInMineCountForNonMineCells(size, board);
            displayBoard(size, board, displayMines);

            while (true)
            {
                Console.Write("Enter command (m/M for command menu): ");
                command = char.Parse(Console.ReadLine());

                if (command == 'm' || command == 'M')
                {
                    displayMenu();
                }
                else if (command == 'c' || command == 'C')
                {
                    do
                    {
                        Console.Write("Enter row and column of cell: ");
                        string[] tokens = Console.ReadLine().Split();
                        Console.WriteLine("0:" + tokens[0] + " 1: " + tokens[1]);
                        if (int.TryParse(tokens[0], out row) == false || int.TryParse(tokens[1], out col) == false)
                        {
                            row = int.Parse(tokens[0]);
                            col = int.Parse(tokens[1]);
                        }
                        if (row < 1 || row > size || col < 1 || col > size)
                        {
                            Console.WriteLine("Invalid row or column values. Try again.");
                        }
                    } while (row < 1 || row > size || col < 1 || col > size);
                    row--;
                    col--;
                    gameState = selectCell(row, col, size, board);
                    displayBoard(size, board, displayMines);
                }
                else if (command == 's' || command == 'S')
                {
                    displayMines = true;
                    displayBoard(size, board, displayMines);
                }
                else if (command == 'h' || command == 'H')
                {
                    displayMines = false;
                    displayBoard(size, board, displayMines);
                }
                else if (command == 'b' || command == 'B')
                {
                    displayBoard(size, board, displayMines);
                }
                else if (command == 'q' || command == 'Q')
                {
                    Console.WriteLine("Bye.");
                    break;
                }
                else
                {
                    Console.WriteLine("Invalid command. Try again.");
                }

                if (gameState == Status.WON)
                {
                    Console.WriteLine("You found all the mines. Congratualtions. Bye.");
                    break;
                }
                else if (gameState == Status.LOST)
                {
                    Console.WriteLine("Oops. Sorry, you landed on a mine. Bye");
                    break;
                }
            }
        }

        private void displayMenu()
        {
            Console.WriteLine("List of available commands:");
            Console.WriteLine("   Show Mines: s/S");
            Console.WriteLine("   Hide Mines: h/H");
            Console.WriteLine("   Select Cell: c/C");
            Console.WriteLine("   Display Board: b/B");
            Console.WriteLine("   Display Menu: m/M");
            Console.WriteLine("   Quit: q/Q");
        }

        public void initBoard(int size, Cell[,] board)
        {
            for (int i = 0; i < size; i++)
            {
                for (int j = 0; j < size; j++)
                {
                    board[i, j].nbr_mines = 0;
                    board[i, j].is_mine = false;
                    board[i, j].visible = false;
                }
            }
        }

        public void placeMinesOnBoard(int size, Cell[,] board, int nbrMines)
        {
            int x, y;
            Random val = new Random();
            for (int i = 0; i < nbrMines; i++)
            {
                x = val.Next(size);
                y = val.Next(size);
                if (board[x, y].is_mine == false)
                {
                    board[x, y].is_mine = true;
                }
                else
                {
                    i--;
                }
            }
        }

        public void fillInMineCountForNonMineCells(int size, Cell[,] board)
        {
            for (int i = 0; i < size; i++)
            {
                for (int j = 0; j < size; j++)
                {
                    if (board[i, j].is_mine == false)
                    {
                        board[i, j].nbr_mines = getNbrNeighborMines(i, j, size, board);   
                    }
                }
            }
        }

        public int nbrOfMines(int size, Cell[,] board)
        {
            int count = 0;
            for (int i = 0; i < size; i++)
            {
                for (int j = 0; j < size; j++)
                {
                    if (board[i, j].is_mine == true) { count++; }
                }
            }
            return count;
        }

        public int getNbrNeighborMines(int row, int col, int size, Cell[,] board)
        {
            int count = 0;
            if (row != 0 && col != 0 && board[row - 1, col - 1].is_mine == true)
            {
                count++;
            }
            if (row != 0 && board[row - 1, col].is_mine == true)
            {
                count++;
            }
            if (row != 0 && col != size - 1 && board[row - 1, col + 1].is_mine == true)
            {
                count++;
            }
            if (col != 0 && board[row, col - 1].is_mine == true)
            {
                count++;
            }
            if (col != size - 1 && board[row, col + 1].is_mine == true)
            {
                count++;
            }
            if (row != size - 1 && col != 0 && board[row + 1, col - 1].is_mine == true)
            {
                count++;
            }
            if (row != size - 1 && board[row + 1, col].is_mine == true)
            {
                count++;
            }
            if (row != size - 1 && col != size - 1 && board[row + 1, col + 1].is_mine == true)
            {
                count++;
            }
            return count;
        }

        public void displayBoard(int size, Cell[,] board, bool displayMines)
        {
            Console.WriteLine();
            Console.Write("   ");
            for (int n = 1; n <= size; n++)
            {
                if (n < 10)
                {
                    Console.Write(" " + n + " ");
                }
                else
                {
                    Console.Write(n + " ");
                }
            }
            Console.WriteLine();
            for (int i = 0; i < size; i++)
            {
                if (i + 1 < 10)
                {
                    Console.Write(" " + (i + 1) + " ");
                }
                else
                {
                    Console.Write((i + 1) + " ");
                }
                for (int j = 0; j < size; j++)
                {
                    if ((board[i, j].visible == false) && (board[i, j].is_mine == true) && (displayMines == true))
                    {
                        Console.Write(" * ");
                    }
                    else if ((board[i, j].visible == true) && (board[i, j].is_mine == true))
                    {
                        Console.Write(" * ");
                    }
                    else if ((board[i, j].visible == true) && (board[i, j].is_mine == false))
                    {
                        Console.Write(" " + board[i, j].nbr_mines + " ");
                    }
                    else
                    {
                        Console.Write(" ? ");
                    }
                }
                Console.WriteLine();
            }
        }

        public int getBoardSize()
        {
            int size = 0;
            Console.Write("Please enter the size of the board: ");
            size = int.Parse(Console.ReadLine());
            Console.WriteLine();
            if ((size > BOARD_SIZE_MAX) || (size < BOARD_SIZE_MIN))
            {
                Console.WriteLine("The size of the board is not in the range of 5 to 15");
                getBoardSize();
            }
            else
            {
                Console.WriteLine("The size of the board is " + size + " x " + size);
            }
            return size;
        }

        public int getPercentMines()
        {
            int percent = 0;
            Console.Write("Please enter the percentage of mines: ");
            percent = int.Parse(Console.ReadLine());
            Console.WriteLine();
            if ((percent > PCT_MINES_MAX) || (percent < PCT_MINES_MIN))
            {
                Console.WriteLine("The percentage of mines for the board is not in the range of 10 to 70 percent.");
                getPercentMines();
            }
            else
            {
                Console.WriteLine("The percentage of mines on the board is " + percent + "percent.");
            }
            return percent;
        }

        public Status selectCell(int row, int col, int size, Cell[,] board)
        {
            board[row, col].visible = true;
            if (board[row, col].is_mine == true)
            {
                return Status.LOST;
            }
            else if (board[row, col].nbr_mines == 0)
            {
                setAllNeighborCellsVisible(row, col, size, board);
            }
            else if ((((size * size) - nbrVisibleCells(size, board)) - nbrOfMines(size, board)) == 0)
            {
                return Status.WON;
            }
            return Status.INPROGRESS;
        }

        public int nbrVisibleCells(int size, Cell[,] board)
        {
            int count = 0;
            for (int i = 0; i < size; i++)
            {
                for (int j = 0; j < size; j++)
                {
                    if (board[i, j].visible == true)
                    {
                        count++;
                    }
                }
            }
            return count;
        }

        public void setAllNeighborCellsVisible(int row, int col, int size, Cell[,] board)
        {
            if (row != 0 && col != 0 && board[row - 1, col - 1].is_mine == false && board[row - 1, col - 1].visible == false)
            {
                if (board[row - 1, col - 1].nbr_mines == 0)
                {
                    setAllNeighborCellsVisible(row - 1, col - 1, size, board);
                }
                else
                {
                    board[row - 1, col - 1].visible = true;
                }
            }
            if (row != 0 && board[row - 1, col].is_mine == false && board[row - 1, col].visible == false)
            {
                if (board[row - 1, col].nbr_mines == 0)
                {
                    setAllNeighborCellsVisible(row - 1, col, size, board);
                }
                else
                {
                    board[row - 1, col].visible = true;
                }
            }
            if (row != 0 && col != size-1 && board[row - 1, col + 1].is_mine == false && board[row - 1, col + 1].visible == false)
            {
                if (board[row - 1, col + 1].nbr_mines == 0)
                {
                    setAllNeighborCellsVisible(row - 1, col + 1, size, board);
                }
                else
                {
                    board[row - 1, col + 1].visible = true;
                }
            }
            if (col != 0 && board[row, col - 1].is_mine == false && board[row, col - 1].visible == false)
            {
                if (board[row, col - 1].nbr_mines == 0)
                {
                    setAllNeighborCellsVisible(row, col - 1, size, board);
                }
                else
                {
                    board[row, col - 1].visible = true;
                }
            }
            if (board[row, col].visible == false)
            {
                board[row, col].visible = true;
            }
            if (col != size-1 && board[row, col + 1].is_mine == false && board[row, col + 1].visible == false)
            {
                if (board[row, col + 1].nbr_mines == 0)
                {
                    setAllNeighborCellsVisible(row, col + 1, size, board);
                }
                else
                {
                    board[row, col + 1].visible = true;
                }
            }
            if (row != size-1 && col != 0 && board[row + 1, col - 1].is_mine == false && board[row + 1, col - 1].visible == false)
            {
                if (board[row + 1, col - 1].nbr_mines == 0)
                {
                    setAllNeighborCellsVisible(row + 1, col - 1, size, board);
                }
                else
                {
                    board[row + 1, col - 1].visible = true;
                }
            }
            if (row != size-1 && board[row + 1, col].is_mine == false && board[row + 1, col].visible == false)
            {
                if (board[row + 1, col].nbr_mines == 0)
                {
                    setAllNeighborCellsVisible(row + 1, col, size, board);
                }
                else
                {
                    board[row + 1, col].visible = true;
                }
            }
            if (row != size-1 && col != size-1 && board[row + 1, col + 1].is_mine == false && board[row + 1, col + 1].visible == false)
            {
                if (board[row + 1, col + 1].nbr_mines == 0)
                {
                    setAllNeighborCellsVisible(row + 1, col + 1, size, board);
                }
                else
                {
                    board[row + 1, col + 1].visible = true;
                }
            }
        }
    }
}
