using System.Dynamic;

namespace _00_Exam_Project
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                Scheduling scheduling = new Scheduling();
                
                //Read in the schedule
                string[,] schedule = scheduling.Schedule("schedule.txt");
                
                //Read in the training data
                var (independents, dependent) = scheduling.TrainingData("training_data.txt");

                MultipleRegression regression = new MultipleRegression();
                double[] coefficients = regression.Train(independents, dependent);

                //Read in the new assignments to be integrated into the schedule
                List<Assignments> assignments = scheduling.Assignments("assignments.txt");
                double[] predicted_durations = regression.Predict(assignments, coefficients);

                if (assignments.Count == predicted_durations.Length)
                {
                    for (int i = 0; i < assignments.Count; i++)
                    {
                        assignments[i].PredictedDuration = predicted_durations[i];
                    }
                }
                else Console.WriteLine("The number of assignments doesn't match the number of predicted durations.");

                //Adjust schedule
                ScheduleChromosome chromosome = new ScheduleChromosome(schedule);
                Genetic genetic = new Genetic(schedule, assignments);
                genetic.Run();
            }
            catch (FormatException)
            {
                Console.WriteLine("Wrong Format");
            }
            catch (FileNotFoundException)
            {
                Console.WriteLine("File does not exist");
            }
            catch (IndexOutOfRangeException)
            {
                Console.WriteLine("Index out of range");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
    }
}