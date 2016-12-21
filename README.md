# mcv-m4-2017-team4

To execute the differents task realized:

- Task 1 and 2 can be found in week1_task1.m, only need to be defined the directory for gt and results obtained in this case the highway example, after ir run the program to obtain the graphs of the task 2 ofr A and B test

- Task 3 and 5 can be found in week1_task3and5.m, you only need to select the path for the optical flow result and ground truth,
to analyze the differents metric MSEN and PEPN, then differents visualitzation are showed, histograms of errors and images of
pixels distribution for the optical flow and the errors. Task 5 is performed after using quiver fuction, select the path for the
original image defining the path for im, to plot the quiver on the image.

- Finally, task 4 is performed in week1_task4.m, you need to define the paths for gt and split the results of test A and B in different folders. If ytou want to calculate displacement for all 25 frames for every result and perfom a global f1-score for every displacement just run the program, if you want to see frame to frame fi-scores given certain displacement values, uncomment displacement list in the program and comment the other one, also uncomment lines 65,109, 111 and 112. 
