# mcv-m4-2017-team4

To execute the differents task realized in this week 2:

    Task 1 can be found in m4_week2_task1.m, only need specify the global path where the dataset are and be sure that the names 
    correspond to the one that the code reads, 'fall', 'highway' and 'traffic'. The code works for the full dataset taking only
    the correct frames for the task. Run the code will display the differents graphs and results for differents alpha values.

    Task 2 can be found in m4_week2_task2.m, in this task the datasets need to be in a foulder especified in the code, actually 
    'Dataset', to read the content, this one don't work with the full dataset, need the proper frames. Run the code to perform
    the two methods to calculate alpha and p values and display the results obtained. Actually this method don't work properly 
    due the lack of time to prepare it.

    task 3 can be found in m4_week2_task3.m, to define paths follow the same step as task 1. In compute_task_3.m we can play with
    the parameters of S&G, using the stdRange and threshold, we can define a range to calculate differents respondes for S&G, but
    to obtain the graphs properly ploted is necessary to mantain one of this two parameters static in range. 
    Ex: stdRange = [0 200]; threshold = [0.7 0.7]; Or stdRange = [100 100]; threshold = [0.5 0.9];
    
    task 4 can be found in m4_week2_task4_1.m, works equal that task 1 with paths. Run the code to obtain the diferents results
    and graph related to alpha and the differents colour spaces.
