using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace _00_Exam_Project
{
    public class Scheduling
    {
        public string[,] Schedule(string filename)
        {
            string[,] schedule = new string[7, 24];

            string[] lines = File.ReadAllLines(filename);

            foreach (string line in lines)
            {
                string[] items = line.Split(',');

                if (items.Length == 4 &&
                    Int32.TryParse(items[0], out int day) &&
                    Int32.TryParse(items[1], out int start) &&
                    Int32.TryParse(items[2], out int end))
                {
                    string activity = items[3];
                    UpdateSchedule(schedule, day, start, end, activity);
                }
            }

            return schedule;
        }

        private void UpdateSchedule(string[,] schedule, int day, int start, int end, string activity)
        {
            for (int hour = start; hour < end; hour++)
            {
                schedule[day, hour] = activity;
            }
        }

        public void OutputSchedule(string[,] schedule)
        {
            for (int hour = 0; hour < schedule.GetLength(1); hour++)
            {
                for (int day = 0; day < schedule.GetLength(0); day++)
                {
                    Console.Write($"{schedule[day, hour],-15}");
                }
                Console.WriteLine();
            }
        }

        public (double[,], double[]) TrainingData(string filename)
        {
            string[] lines = File.ReadAllLines(filename);
            int rows = lines.Length - 1; //excluding header

            double[,] independents = new double[rows, 3]; //3 = features excluding duration
            double[] dependent = new double[rows];

            for (int i = 1; i < lines.Length; i++) //skip header
            {
                string[] items = lines[i].Split(',');

                for (int j = 0; j < 3; j++)
                {
                    if (double.TryParse(items[j], out double feature))
                    {
                        independents[i - 1, j] = feature;
                    }
                    else Console.WriteLine("Error parsing feature in TrainingData Method");
                }

                if (double.TryParse(items[3], out double duration))
                {
                    dependent[i - 1] = duration;
                }
                else Console.WriteLine("Error parsing duration in TrainingData Method");
            }
            return (independents, dependent);
        }

        public List<Assignments> Assignments(string filename)
        {
            List<Assignments> assignments = new List<Assignments>();

            try
            {
                string[] lines = File.ReadAllLines(filename);

                for (int i = 1; i < lines.Length; i++)
                {
                    string[] items = lines[i].Split(',');

                    if (items.Length == 4)
                    {
                        if (double.TryParse(items[1], out double priority) &&
                        double.TryParse(items[2], out double complexity) &&
                        double.TryParse(items[3], out double workload))
                        {
                            Assignments assignment = new Assignments
                            {
                                Assignment = items[0],
                                Priority = priority,
                                Complexity = complexity,
                                Workload = workload
                            };
                            assignments.Add(assignment);
                        }
                        else Console.WriteLine("Error parsing new assignment features in Assignments Method");
                    }
                    else Console.WriteLine($"Number of new assignment features out of bounds in Assignments Method");
                }                
            }
            catch (FileNotFoundException)
            {
                Console.WriteLine("File does not exist");
            }
            catch (IndexOutOfRangeException)
            {
                Console.WriteLine("Index out of range in Assignment Method");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return assignments;
        }
    }
}
