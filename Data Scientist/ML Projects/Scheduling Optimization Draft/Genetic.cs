using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Linq;
using System.Net.Sockets;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using static System.Formats.Asn1.AsnWriter;
using static System.Reflection.Metadata.BlobBuilder;

namespace _00_Exam_Project
{
    public class ScheduleChromosome
    {
        public string[,] Schedule { get; set; }
        public double Fitness { get; set; }
        public ScheduleChromosome(string[,] schedule)
        {
            Schedule = schedule;
        }
    }

    public class Genetic
    {
        Random random = new Random();

        private Fitness fitness;
        public string[,] Schedule { get; set; }
        public List<Assignments> Assignments { get; set; }
        public Genetic(string[,] schedule, List<Assignments> assignments)
        {
            fitness = new Fitness();
            Schedule = schedule;
            Assignments = assignments;
        }

        public void Run()
        {
            int numberOfSchedules = 20;
            int selections = 5;
            int generations = 200;
            int count = 0;

            //Initialization
            List<ScheduleChromosome> schedules = InitializePopulation(numberOfSchedules, Schedule, Assignments);

            while (count < generations)
            {
                //Selection
                List<ScheduleChromosome> selected = Selection(schedules, selections);

                //Crossover and Mutation
                List<ScheduleChromosome> new_schedules = new List<ScheduleChromosome>();
                for (int i = 0; i < selected.Count - 1; i++)
                {
                    ScheduleChromosome offspring1 = OrderCrossover(selected[i], selected[i + 1]);
                    ScheduleChromosome offspring2 = OrderCrossover(selected[i + 1], selected[i]);
                    new_schedules.Add(Mutation(offspring1));
                    new_schedules.Add(Mutation(offspring2));
                }
                schedules = new_schedules;
                count++;
            }

            //Output the final schedule
            ScheduleChromosome fittest = schedules.OrderByDescending(s => s.Fitness).First();
            OutputSchedule(fittest.Schedule);
        }

        private ScheduleChromosome Mutation(ScheduleChromosome offspring)
        {           
            string[,] schedule = (string[,])offspring.Schedule.Clone(); //copy of offspring schedule

            int days = schedule.GetLength(0);

            Tuple<string, string> assignments = RandomAssignments(schedule);

            if (assignments == null)
            {
                Tuple<int, int> assignment1 = RandomAssignment(schedule);
                Tuple<int, int> assignment2;

                do
                {
                    assignment2 = RandomAssignment(schedule);
                }
                while (assignment1 == assignment2);

                Swap(schedule, assignment1, assignment2);
            }
            else
            {
                List<Tuple<int, int>> slots_assignment1 = new List<Tuple<int, int>>();
                List<Tuple<int, int>> slots_assignment2 = new List<Tuple<int, int>>();


                for (int day = 0; day < days; day++)
                {
                    for (int hour = 5; hour < 22; hour++)
                    {
                        if (schedule[day, hour] == assignments.Item1)
                        {
                            slots_assignment1.Add(new Tuple<int, int>(day, hour));
                        }
                        else if (schedule[day, hour] == assignments.Item2)
                        {
                            slots_assignment2.Add(new Tuple<int, int>(day, hour));
                        }
                    }
                }

                if (slots_assignment1.Count == slots_assignment2.Count)
                {
                    for (int i = 0; i < slots_assignment1.Count; i++)
                    {
                        Swap(schedule, slots_assignment1[i], slots_assignment2[i]);
                    }
                }
                else if ((slots_assignment1.Count > slots_assignment2.Count && slots_assignment2.Count != 0))
                {
                    int difference = slots_assignment1.Count - slots_assignment2.Count;
                    slots_assignment1.RemoveRange(slots_assignment1.Count - difference, difference);

                    for (int i = 0; i < slots_assignment1.Count; i++)
                    {
                        Swap(schedule, slots_assignment1[i], slots_assignment2[i]);
                    }
                }
                else if (slots_assignment2.Count > slots_assignment1.Count && slots_assignment1.Count != 0)
                {
                    int difference = slots_assignment2.Count - slots_assignment1.Count;
                    slots_assignment2.RemoveRange(slots_assignment2.Count - difference, difference);

                    for (int i = 0; i < slots_assignment1.Count; i++)
                    {
                        Swap(schedule, slots_assignment1[i], slots_assignment2[i]);
                    }
                }
            }  
            ScheduleChromosome mutated_offspring = new ScheduleChromosome(schedule);
            mutated_offspring.Fitness = fitness.CalculateFitness(mutated_offspring, Assignments);

            return mutated_offspring;
        }

        public void Swap(string[,] schedule, Tuple<int, int> slot_assignment1, Tuple<int, int> slot_assignment2)
        {
            string temporary = schedule[slot_assignment1.Item1, slot_assignment1.Item2];
            schedule[slot_assignment1.Item1, slot_assignment1.Item2] = schedule[slot_assignment2.Item1, slot_assignment2.Item2];
            schedule[slot_assignment2.Item1, slot_assignment2.Item2] = temporary;
        }

        private Tuple<string, string> RandomAssignments(string[,] schedule)
        {
            int attempts = 0;
            int max_attempts = Assignments.Count;

            while (attempts < max_attempts)
            {
                int index = random.Next(Assignments.Count);

                Assignments assignment = Assignments[index];

                for (int i = 0; i < Assignments.Count; i++)
                {
                    if (Math.Ceiling(assignment.PredictedDuration / 60.0) == Math.Ceiling(Assignments[i].PredictedDuration / 60.0) && i != index)
                    {
                        return new Tuple<string, string>(assignment.Assignment, Assignments[i].Assignment);
                    }
                }
                attempts++;
            }
            return null;
        }

        private Tuple<int, int> RandomAssignment(string[,] schedule)
        {
            int days = schedule.GetLength(0);

            int day, hour;

            do
            {
                day = random.Next(days);
                hour = random.Next(5, 22);
            }
            while (!IsAssignment(schedule[day, hour], Assignments));

            return new Tuple<int, int>(day, hour);
        }

        private ScheduleChromosome OrderCrossover(ScheduleChromosome scheduleChromosome1, ScheduleChromosome scheduleChromosome2)
        {
            int days = scheduleChromosome1.Schedule.GetLength(0);
            int hours = scheduleChromosome1.Schedule.GetLength(1);
            string[,] child = new string[days, hours];
            Dictionary<string, int> assignments = new Dictionary<string, int>();

            for (int day = 0; day < days; day++) //copy the fixed slots
            {
                for (int hour = 5; hour < 22; hour++)
                {
                    if (!IsAssignment(scheduleChromosome1.Schedule[day, hour], Assignments))
                    {
                        child[day, hour] = scheduleChromosome1.Schedule[day, hour];
                    }
                }
            }

            //Segment from parent 1 to child
            int min = 5; int max = 22;
            int crossover_point1 = random.Next(min, max);
            int crossover_point2 = random.Next(crossover_point1, max); 

            for (int day = 0; day < days; day++) 
            {
                for (int hour = crossover_point1; hour < crossover_point2; hour++)
                {
                    if (string.IsNullOrEmpty(child[day, hour]) && !string.IsNullOrEmpty(scheduleChromosome1.Schedule[day, hour]))
                    {
                        child[day, hour] = scheduleChromosome1.Schedule[day, hour];

                        if (IsAssignment(child[day, hour], Assignments))
                        {
                            if (!assignments.ContainsKey(child[day, hour])) assignments[child[day, hour]] = 1;
                            else assignments[child[day, hour]]++;
                        }
                    }                    
                }
            }

            //Delete assignments from parent 2 that are in the child
            for (int day = 0; day < days; day++)
            {
                for (int hour = 5; hour < 22; hour++)
                {
                    string slot = scheduleChromosome2.Schedule[day, hour];

                    if (!string.IsNullOrEmpty(slot) && assignments.ContainsKey(slot) && assignments[slot] > 0)
                    {
                        scheduleChromosome2.Schedule[day, hour] = null;
                        assignments[slot]--;
                    }
                }
            }

            //Add the remaining assignments to the child from parent 2
            List<Tuple<int, int>> slots = new List<Tuple<int, int>>();
            for (int day = 0; day < days; day++)
            {
                for (int hour = 0; hour < hours; hour++)
                {
                    if (IsAssignment(scheduleChromosome2.Schedule[day, hour], Assignments))
                    {
                        slots.Add(new Tuple<int, int>(day, hour));
                    }
                }
            }

            bool doBreak = false;

            foreach (var slot in slots)
            {
                int chromosome2_day = slot.Item1;
                int chromosome2_hour = slot.Item2;

                for (int day = 0; day < days; day++)
                {
                    for (int hour = 5; hour < 22; hour++)
                    {
                        if (string.IsNullOrEmpty(child[day, hour]))
                        {
                            child[day, hour] = scheduleChromosome2.Schedule[chromosome2_day, chromosome2_hour];
                            doBreak = true;
                            break;
                        }
                    }

                    if (doBreak)
                    {
                        doBreak = false;
                        break;
                    }
                }
            }

            ScheduleChromosome offspring = new ScheduleChromosome(child); //creating the ScheduleChromosome for the child
            offspring.Fitness = fitness.CalculateFitness(offspring, Assignments);
            
            return offspring;
        }

        private List<ScheduleChromosome> Selection(List<ScheduleChromosome> schedules, int selections)
        {
            for (int i = 0; i < schedules.Count - 1; i++)
            {
                for (int j = i + 1; j < schedules.Count; j++)
                {
                    if (schedules[i].Fitness < schedules[j].Fitness)
                    {
                        ScheduleChromosome temp = schedules[i];
                        schedules[i] = schedules[j];
                        schedules[j] = temp;
                    }
                }
            }
            return schedules.Take(selections).ToList<ScheduleChromosome>();
        }

        public List<ScheduleChromosome> InitializePopulation(int numberOfSchedules, string[,] schedule, List<Assignments> assignments)
        {
            List<ScheduleChromosome> schedules = new List<ScheduleChromosome>();

            for (int i = 0; i < numberOfSchedules; i++)
            {
                string[,] random_schedule = RandomSchedule(schedule, assignments);
                ScheduleChromosome individual = new ScheduleChromosome(random_schedule);
                individual.Fitness = fitness.CalculateFitness(individual, assignments);
                schedules.Add(individual);
            }
            return schedules;
        }

        private string[,] RandomSchedule(string[,] schedule, List<Assignments> assignments)
        {
            int days = schedule.GetLength(0); //rows
            int hours = schedule.GetLength(1); //columns

            string[,] random_schedule = new string[days, hours];

            for (int day = 0; day < days; day++)
            {
                for (int hour = 0; hour < hours; hour++)
                {
                    random_schedule[day, hour] = schedule[day, hour];
                }
            }

            List<Tuple<int, int>> slots = new List<Tuple<int, int>>();
            for (int day = 0; day < days; day++)
            {
                for (int hour = 5; hour < 22; hour++)
                {
                    if (string.IsNullOrEmpty(schedule[day, hour]))
                    {
                        slots.Add(new Tuple<int, int>(day, hour));
                    }
                }
            }
            Shuffle(slots);

            if (slots.Count < SumInHoursOfPredictedDuration(assignments))
            {
                Console.WriteLine("Warning: Some assignments may not be schedules because of insufficient of slots");

                assignments.Sort((a, b) => b.Priority.CompareTo(a.Priority));

                int difference = Difference(slots);
                for (int i = assignments.Count - 1; i >= 0 && difference > 0; i--)
                {
                    assignments[i].PredictedDuration -= difference;
                    if (assignments[i].PredictedDuration <= 0) assignments.RemoveAt(i);
                    difference = Difference(slots);

                    if (difference == 0) break;
                }
            }

            foreach (var assignment in assignments)
            {
                if (slots.Count == 0) break; //no more available slots
                AssignAssignmentToSlot(random_schedule, slots, assignment);
            }
            return random_schedule;
        }       
        
        private void AssignAssignmentToSlot(string[,] random_schedule, List<Tuple<int, int>> slots, Assignments assignment)
        {
            bool noConsecutiveSlots = false;
            double duration = Math.Ceiling(assignment.PredictedDuration / 60.0);

            foreach (var slot in slots)
            {
                int day = slot.Item1;
                int start = slot.Item2;
                bool hasConsecutiveSlots = true;

                for (int hour = start; hour < start + duration; hour++)
                {
                    if (!string.IsNullOrEmpty(random_schedule[day, hour]))
                    {
                        hasConsecutiveSlots = false;
                        break;
                    }
                }

                if (hasConsecutiveSlots)
                {
                    for (int hour = start; hour < start + duration; hour++)
                    {
                        random_schedule[day, hour] = assignment.Assignment;
                    }
                    slots.RemoveAll(s => s.Item1 == day && s.Item2 >= start && s.Item2 < start + duration);
                    noConsecutiveSlots = true;
                    break;
                }
            }

            if (!noConsecutiveSlots)
            {
                foreach (var slot in slots)
                {
                    int day = slot.Item1;
                    int hour = slot.Item2;

                    if (string.IsNullOrEmpty(random_schedule[day, hour]))
                    {
                        random_schedule[day, hour] = assignment.Assignment;
                        slots.RemoveAll(s => s.Item1 == day && s.Item2 == hour);
                        duration--;
                    }    
                    else if (string.IsNullOrEmpty(random_schedule[day, hour - 1]))
                    {
                        random_schedule[day, hour - 1] = assignment.Assignment;
                        slots.RemoveAll(s => s.Item1 == day && s.Item2 == hour - 1);
                        duration--;
                    }
                    else if (string.IsNullOrEmpty(random_schedule[day, hour + 1]))
                    {
                        random_schedule[day, hour + 1] = assignment.Assignment;
                        slots.RemoveAll(s => s.Item1 == day && s.Item2 == hour + 1);
                        duration--;
                    }

                    if (duration == 0) break;
                }
            }
        }

        private int Difference(List<Tuple<int, int>> slots)
        {
            int difference = (int)Math.Ceiling(SumInHoursOfPredictedDuration(Assignments) - slots.Count);
            difference = difference * 60;
            return difference;
        }

        private double SumInHoursOfPredictedDuration(List<Assignments> assignments)
        {
            double sum_hours = 0;
            foreach (var assignment in assignments)
            {
                sum_hours += Math.Ceiling(assignment.PredictedDuration / 60.0);
            }
            return sum_hours;
        }

        private void Shuffle<T>(List<T> list)
        {
            for (int i = list.Count - 1; i > 0; i--)
            {
                int number = random.Next(0, i + 1);
                T temp = list[i];
                list[i] = list[number];
                list[number] = temp;
            }
        }

        public bool IsAssignment(string name, List<Assignments> assignments)
        {
            foreach (Assignments assignment in assignments)
            {
                if (assignment.Assignment == name)
                {
                    return true;
                }
            }
            return false;
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
    }

    public class Fitness
    {
        public double CalculateFitness(ScheduleChromosome individual, List<Assignments> assignments)
        {
            double fitness = 0;
            string[,] schedule = individual.Schedule;                      

            fitness += AccurateDuration(schedule, assignments);

            fitness += AllAssignmentsIncluded(schedule, assignments);

            fitness += HighPrioritization(schedule, assignments);

            return fitness;
        }

        private double HighPrioritization(string[,] schedule, List<Assignments> assignments)
        {
            double score = 0;

            for (int day = 0; day < schedule.GetLength(0); day++)
            {
                for (int hour = 0; hour < schedule.GetLength(1); hour++)
                {
                    if (!string.IsNullOrEmpty(schedule[day, hour]))
                    {
                        foreach (Assignments assignment in assignments)
                        {
                            if (assignment.Assignment == schedule[day, hour])
                            {
                                if ((assignment.Priority == 6 || assignment.Priority == 5 || assignment.Priority == 4) &&
                                    (day == 3 || day == 4 || day == 5))
                                {
                                    score -= 1;
                                } 
                            }
                        }
                    }
                }
            }
            return score;
        }               

        private double AllAssignmentsIncluded(string[,] schedule, List<Assignments> assignments)
        {
            double score = 0;

            foreach (var assignment in assignments)
            {
                if (!AssignmentIsIncluded(schedule, assignment))
                    score -= 1;
            }
            return score;
        }

        private bool AssignmentIsIncluded(string[,] schedule, Assignments assignment)
        {
            for (int day = 0; day < schedule.GetLength(0); day++)
            {
                for (int hour = 5; hour < 22; hour++)
                {
                    if (schedule[day, hour] == assignment.Assignment)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        private double AccurateDuration(string[,] schedule, List<Assignments> assignments)
        {
            double score = 0;

            foreach (var assignment in assignments)
            {
                int assigned_slots = AssignedSlots(schedule, assignment);
                double duration = Math.Ceiling(assignment.PredictedDuration / 60.0);

                if (assigned_slots > duration && assigned_slots < duration) score -= 1;
            }
            return score;
        }

        private int AssignedSlots(string[,] schedule, Assignments assignment)
        {
            int count = 0;

            for (int day = 0; day < schedule.GetLength(0); day++)
            {
                for (int hour = 5; hour < 22; hour++)
                {
                    if (schedule[day, hour] == assignment.Assignment)
                    {
                        count++;
                    }
                }
            }
            return count;
        }        
    }
}