using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _00_Exam_Project
{
    public class MultipleRegression
    {
        public double[] Train(double[,] independents, double[] dependents)
        {
            double[,] x = AddConstantBias(independents);
            double[,] xt = Transpose(x);
            double[,] product_xtx = Multiply(xt, x);
            double[] product_xty = Multiply(xt, dependents);

            double determinant = Determinant(product_xtx);
           double[,] adjugated = Adjugate(product_xtx);
            double[] adjugated_xty = Multiply(adjugated, product_xty);
            double[] coefficients = new double[adjugated_xty.Length];
            for (int i = 0; i < adjugated_xty.Length; i++)
            {
                double beta_value = adjugated_xty[i] / determinant;
                coefficients[i] = beta_value;
            }            
            return coefficients;
        }

        internal double[] Predict(List<Assignments> new_assignments, double[] coefficients)
        {
            double[,] assignments = ToMatrix(new_assignments);
            double[,] constant_assignments = AddConstantBias(assignments);
            double[] durations = Multiply(constant_assignments, coefficients);
            return durations;
        }

        private double[,] ToMatrix(List<Assignments> new_assignments)
        {
            int rows = new_assignments.Count;
            int columns = 3;
            double[,] assignments = new double[rows, columns];

            for (int i = 0; i < rows; i++)
            {
                assignments[i, 0] = new_assignments[i].Priority;
                assignments[i, 1] = new_assignments[i].Complexity;
                assignments[i, 2] = new_assignments[i].Workload;
            }
            return assignments;
        }

        private double[,] Adjugate(double[,] product_xtx)
        {
            int rows = product_xtx.GetLength(0);
            int columns = product_xtx.GetLength(1);
            double[,] adjugated = new double[rows, columns];

            for (int i = 0; i < rows; i++)
            {
                for (int j = 0; j < columns; j++)
                {
                    adjugated[i, j] = Cofactor(product_xtx, i, j);
                }
            }
            adjugated = Transpose(adjugated);            

            return adjugated;
        }

        private double Cofactor(double[,] matrix, int row, int column)
        {
            int rows = matrix.GetLength(0);
            int columns = matrix.GetLength(1);

            int subrow = 0;
            double[,] submatrix = new double[rows - 1, columns - 1];

            for (int i = 0; i < rows; i++)
            {
                if (i != row)
                {
                    int subcolumn = 0;
                    for (int j = 0; j < columns; j++)
                    {
                        if (j != column)
                        {
                            submatrix[subrow, subcolumn] = matrix[i, j];
                            subcolumn++;
                        }    
                    }
                    subrow++;
                }                                    
            }

            int sign;
            if ((row + column) % 2 == 0) sign = 1;
            else sign = -1;
            
            double determinant = Determinant(submatrix);

            return sign * determinant;
        }

        private double Determinant(double[,] matrix)
        {
            double determinant = 0;
            
            //base case
            if (matrix.GetLength(0) == 1)
            {
                return matrix[0, 0];
            }
            else if (matrix.GetLength(0) == 2)
            {
                return matrix[0, 0] * matrix[1, 1] - matrix[0, 1] * matrix[1, 0];
            }

            for (int i = 0; i < matrix.GetLength(1); i++)
            {
                int subcolumn = 0;

                double[,] submatrix = new double[matrix.GetLength(0) - 1, matrix.GetLength(1) - 1];

                for (int row = 1; row < matrix.GetLength(0); row++)
                {
                    for (int column = 0; column < matrix.GetLength(1); column++)
                    {
                        if (column != i)
                        {
                            submatrix[row - 1, subcolumn] = matrix[row, column];
                            subcolumn++;
                        }
                    }
                    subcolumn = 0;
                }
                double submatrix_determinant = Determinant(submatrix);

                if (i % 2 == 0)
                {
                    determinant += matrix[0, i] * submatrix_determinant;

                }
                else
                {
                    determinant -= matrix[0, i] * submatrix_determinant;
                }
            }
            return determinant;
        }

        private double[] Multiply(double[,] xt, double[] dependents)
        {
            int rows = xt.GetLength(0);
            double[] results = new double[rows];

            for (int i = 0; i < rows; i++)
            {
                results[i] = DotProduct(GetRow(xt, i), dependents);
            }
            return results;
        }

        private double[] GetColumn(double[,] matrix, int column)
        {
            int rows = matrix.GetLength(0);
            double[] column_values = new double[rows];

            for (int i = 0; i < rows; i++)
            {
                column_values[i] = matrix[i, column];
            }
            return column_values;
        }

        private double[] GetRow(double[,] matrix, int row)
        {
            int columns = matrix.GetLength(1);
            double[] row_observations = new double[columns];

            for (int i = 0; i < columns; i++)
            {
                row_observations[i] = matrix[row, i];
            } 
            return row_observations;
        }

        private double DotProduct(double[] row, double[] column)
        {
            if (row.Length != column.Length) throw new ArgumentException("Vector dimensions do not match.");

            double result = 0;
            for (int i = 0; i < row.Length; i++)
            {
                result += row[i] * column[i];
            }
            return result;
        }

        private double[,] Multiply(double[,] xt, double[,] x)
        {
            int rows = xt.GetLength(0);
            int x_columns = x.GetLength(1);
            double[,] results = new double[rows, x_columns];

            for (int i = 0; i < rows; i++)
            {
                for (int j = 0; j < x_columns; j++)
                {
                    results[i, j] = DotProduct(GetRow(xt, i), GetColumn(x, j));
                }
            }
            return results;
        }

        private double[,] Transpose(double[,] x)
        {
            int rows = x.GetLength(0);
            int columns = x.GetLength(1);
            double[,] transposed = new double[columns, rows];

            for (int i = 0; i < columns; i++)
            {
                for (int j = 0; j < rows; j++)
                {
                    transposed[i, j] = x[j, i];
                }
            }
            return transposed;
        }

        private double[,] AddConstantBias(double[,] independents)
        {
            int rows = independents.GetLength(0);
            int columns = independents.GetLength(1);
            double[,] x = new double[rows, columns + 1];

            for (int i = 0; i < rows; i++)
            {
                x[i, 0] = 1; //adding the constant term in each row

                for (int j = 0; j < columns; j++)
                {
                    x[i, j + 1] = independents[i, j]; //copying the original array
                }
            }
            return x;
        }        
    }
}
