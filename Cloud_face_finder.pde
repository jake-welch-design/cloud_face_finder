//import libraries
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import com.hamoid.*;

//load import library objects
OpenCV opencv;
Movie video;
VideoExport videoExport;

//video export settings
int vidLength = 60;
int frames = 30;
int delay = 1;
String title = "cloud_face_finder";

void setup() {
  //setup settings (canvas size, background color, framrate)
  size(1080, 1920);
  background(0);
  frameRate(frames);

  //load video
  ( video = new Movie(this, "cloud_timelapse_contrast.mp4")).loop();
  while (video.height == 0 ) delay(2);

  //load face detection
  opencv = new OpenCV(this, 1080, 960);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  //load video export
  videoExport = new VideoExport(this, title + ".mp4");
  videoExport.setFrameRate(frames);
  videoExport.startMovie();
  videoExport.setQuality(100, 0);
}

//initiate video / slow it down
void movieEvent(Movie video) {
  video.read();
  video.speed(0.3);
}

void draw() {
  //initiate face detection / display video
  opencv.loadImage(video);
  image(video, 0, 0, width, height/2 );

  //face detection rectangle colors / stroke weight
  noFill();
  stroke(0, 0, 255);
  int weight = 2;
  strokeWeight(weight);

  //display face detection rectangles
  Rectangle[] faces = opencv.detect();

  for (int i = 0; i < faces.length; i++) {
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);

    //copy function (source x, y, width, height & destination x, y, width, height)
    int sx = faces[i].x + weight;
    int sy = faces[i].y + weight;
    int sw = faces[i].width - (weight * 2);
    int sh = faces[i].height - (weight * 2);
    int dx = 0;
    int dy = height/2;
    int dw = width;
    int dh = height/2;

    copy(sx, sy, sw, sh, dx, dy, dw, dh);

    //darken light areas, create more contrast so faces are more visible
    filter(ERODE);
  }

  //start recording after a certain delay to avoid blank frames at beginning of export
  if (frameCount > delay) {
    videoExport.saveFrame();
  }
  //stop sketch after one minute
  if (frameCount >= (frames * vidLength) + delay) {
    exit();
  }
}
