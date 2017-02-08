# Video Surveillance for Road Traffic Monitoring

<p align="justify"><b>Objectives:</b> The goal of this project is to learn the basic
concepts and techniques related to video sequences
processing, mainly for surveillance applications. We will focus on video sequences
from outdoor scenarios, with the application of traffic monitoring in mind. The main
techniques of video processing will be applied in the context of video surveillance: moving
object segmentation, motion estimation and compensation and video object tracking
are basic components of many video processing systems. In a first stage, moving object
segmentation will be tackled considering scenarios with static camera. Afterwards, camera
motion will be considered. Tracking of the moving objects can be performed in both
scenarios. The tracking result provides high level information that can be analysed for
traffic monitoring. The learning objectives for the students are the use of pixel based
statistical models (such as mixture of gaussians) for modeling a scene background and for
moving object segmentation, the development of optical flow estimation methods for camera
motion compensation, and techniques for object tracking (ranging from simple blob
analysis to more complex techniques based on filtering and probabilistic data association).
The performance of the developed techniques will be measured using standard metrics for
video analysis.</p>

## Project Schedule

<p align="justify">This work is composed by 5 sessions, which one have its goals in order to step bu step perform the
final Road traffic monitoring:</p>

*   **Session 1:** Assessment of Foreground Extraction and Optical Flow.
*   **Session 2:** Background estimation.
*   **Session 3:** Foreground segmentation.
*   **Session 4:** Video Stabilization.
*   **Session 5:** Region tracking.

## Documentation

* [Slides of the project]()
* [Project Report]()

## Results obtained
Video of Traffic:
 <video width="320" height="240" controls>
  <source src="videos/video_traffic.mp4" type="video/mp4">
</video> 
Using Particle filter:
 <video width="320" height="240" controls>
  <source src="videos/ 	traffic_PartFilter.mp4" type="video/mp4">
</video> 
<p align="justify">We can see how don't work properly and the tracking system can't mantain properly the tracking of the vehicles, so need to be adjusted because we use the main system like the kalman filter and doesn't seem to be compatible entirely in order to mantain ID and tracks properly.</p>

Video of Highway:
 <video width="320" height="240" controls>
  <source src="videos/video_highway.mp4" type="video/mp4">
</video> 
Video of our own scene:
 <video width="320" height="240" controls>
  <source src="videos/video_own_all.mp4" type="video/mp4">
</video> 
Mask without the shadow removal of own video:
 <video width="320" height="240" controls>
  <source src="videos/mask_own_stav.mp4" type="video/mp4">
</video> 
Mask without the shadow removal and stabilization of own video:
 <video width="320" height="240" controls>
  <source src="videos/mask_own_nothing.mp4" type="video/mp4">
</video> 

Position of our video:
Av. de Serragalliners, 112, 08193 Cerdanyola del Vallès, Barcelona
<iframe src="https://www.google.com/maps/embed?pb=!1m16!1m12!1m3!1d1056.4726676988516!2d2.1129707569473566!3d41.5008951892322!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!2m1!1sgoogle+maps!5e0!3m2!1sen!2ses!4v1486580514671" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

## Conclusions
As we can see on our video, in real case all the techniques that we have learn are necessary to improve the result. Because the influence of the daylight we can have problem of shadows or because the wind the camera could jig. 


## Team 4 members
* Jose Luis Gómez Zurita [CVC -ADAS](http://adas.cvc.uab.es/elektra/enigma-team/jose-luis-gomez/), [LinkedIn](https://www.linkedin.com/in/jose-luis-gomez-zurita-7101b1130)
* Luis Lebron Casas [LinkedIn](https://www.linkedin.com/in/luis-lebron-casas-369923ba/)
