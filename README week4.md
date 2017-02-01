# mcv-m4-2017-team4

To execute the differents task realized in this week 4:

    Task 1.1 can be found in m4_week4_task1.m, only need specify the global path where the dataset are and be sure that the names 
    correspond to the one that the code reads.Also could be choose if want to execute for the sequence 45 or 157 or both. The code 
	works for the full dataset taking only the correct frames for the task. Run the code will display the surf graphic with the compartive.
	
	Task 1.2 and 1.3 can be found in m4_week4_task1_2.m, need to specify the global path where the dataset are and be sure that the names 
    correspond to the one that the code reads.Also could be choose if want to execute for the sequence 45 or 157 or both and which
	opticalflow applied, task=1.1 means BM, task 1.2 let you choose between the Lucas-Kanade,Lucas-Kanade derivative of Gaussian,
	Horn-Schunck and Farneback. The code works for the full dataset taking only the correct frames for the task. Run the code will
	display the MSEN, PEPN, and the optical flow  graphic with the compartive.

    Task 2.1 can be found in m4_week4_task2.m, in this task the datasets need to be in a foulder especified in the code, to read the content.
	The path to where to save the compensated image could be specify. Run this code to get the video of the image and gt, and all the image
	saved in the configured folders. This version use the BM of the packatge vision of matlab because at first we thought the problem with the 
	results comes from our implementation, so we test with another (continued with this because simplicity of code). 
	The field m4_week4_task2_own_block.m do the same but with our BM, not fully tested.

    task 2.2 can be found in m4_week4_task2_2.m, same as the previous one but eith the features matching. The only parameter that could be 
	change is the feature descriptor.
    
    task 2.3 can be found in m4_week4_task2_3.m, use the methods of the previous one and concatened the iamges result in a video.
	
	For the task 2, to evaluate the videos use evaluated_video.m that will compare the methods with the last one of the week 3.
	All the forlders and sequencies could be change.
