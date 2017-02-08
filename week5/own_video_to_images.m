v = VideoReader('V_20170206_155430.mp4');
count=1;
while hasFrame(v)
    video = readFrame(v);
    video=imresize(video,[360 640]);
    imwrite(video,strcat('./own/input/',sprintf('in%06d',count),'.jpg'));
    count=count+1;
end