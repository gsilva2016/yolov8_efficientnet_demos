# Yolov8 Efficientnet Demos
Execute a GStreamer media accelerated decode and model ensembled pipeline of Yolov8 and Efficientnet with either OpenVINO Model Server or DLStreamer for inference.

## Build Steps

1. Download the quantized yolov8 IR model

```
./download-yolov8.sh
```

2. Build GST + OVMS Docker Image

```
sudo docker build -t ovms-yolov8-efficientnet:1.0 -f Dockerfile.ovms .
```

3. Build GST + DLStreamer Yolov8 Docker Image
   
```
sudo docker build -t dls-yolov8-efficientnet:1.0 -f Dockerfile.dls-yolov8 .
```

## Run GST + OVMS E2E Pipeline Examples

**Environment variables. Note not all are shown in the below Examples for brevity**

_Used to show direct console output instead of logging to the tmp directory_<br>
DC=1 

_Video streams' location and types_<br>
INPUTSRC=rtsp://127.0.0.1:8554/camera_0 <br>
INPUTSRC2=rtsp://127.0.0.1:8554/camera_0 <br>
INPUT_TYPE=RTSP_H264<br>
INPUT_TYPE2=RTSP_H264

_Rendering_<br>
RENDER_MODE=0 # enable rendering graphical content in a window<br>
RENDER_PORTRAIT_MODE=0 # landscape vs. portrait rendering<br>

_Pipelines_<br>
LOW_POWER=1  # GPU  pipeline<br>
CPU_ONLY=0   # CPU  pipeline<br>
LOW_POWER=0 && CPU_ONLY=0 # CPU+GPU pieline

**Yolov8 Dual Camera GPU Example**
```
INPUTSRC=rtsp://127.0.0.1:8554/camera_0 
INPUTSRC2=rtsp://127.0.0.1:8554/camera_0 
RENDER_MODE=0
RENDER_PORTRAIT_MODE=0
LOW_POWER=1
CPU_ONLY=0
INPUT_TYPE=RTSP_H264
INPUT_TYPE2=RTSP_H264
DC=1
```

```
sudo docker run --rm --user root -it -e DC=$DC -e INPUTSRC=$INPUTSRC -e INPUTSRC2=$INPUTSRC2 -e RENDER_MODE=$RENDER_MODE -e LOW_POWER=$LOW_POWER -e CPU_ONLY=$CPU_ONLY -e INPUT_TYPE=$INPUT_TYPE -e INPUT_TYPE2=$INPUT_TYPE2 -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/tmp:/app/yolov8_ensemble/results -v `pwd`:/savedir --net host --ipc=host --device /dev/dri/renderD128 ovms-yolov8-efficientnet:1.0 yolov8_ensemble/yolo_efficientnet_dual.sh
```


**Yolov8 Dual Camera CPU+GPU Example**
```
INPUTSRC=rtsp://127.0.0.1:8554/camera_0 
INPUTSRC2=rtsp://127.0.0.1:8554/camera_0 
RENDER_MODE=0
RENDER_PORTRAIT_MODE=0
LOW_POWER=0
CPU_ONLY=0
INPUT_TYPE=RTSP_H264
INPUT_TYPE2=RTSP_H264
DC=1
```

```
sudo docker run --rm --user root -it -e DC=$DC -e INPUTSRC=$INPUTSRC -e INPUTSRC2=$INPUTSRC2 -e RENDER_MODE=$RENDER_MODE -e LOW_POWER=$LOW_POWER -e CPU_ONLY=$CPU_ONLY -e INPUT_TYPE=$INPUT_TYPE -e INPUT_TYPE2=$INPUT_TYPE2 -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/tmp:/app/yolov8_ensemble/results -v `pwd`:/savedir --net host --ipc=host --device /dev/dri/renderD128 ovms-yolov8-efficientnet:1.0 yolov8_ensemble/yolo_efficientnet_dual.sh
```

**Yolov8 Single Camera CPU with Rendering Example**<br>
Check /tmp for log files.

```
xhost +
```

```
INPUTSRC=rtsp://127.0.0.1:8554/camera_0 
RENDER_MODE=1
RENDER_PORTRAIT_MODE=0
LOW_POWER=0
CPU_ONLY=1
INPUT_TYPE=RTSP_H264
```

```
sudo docker run --rm --user root -it -e DISPLAY=$DISPLAY -e INPUTSRC=$INPUTSRC -e RENDER_MODE=$RENDER_MODE -e LOW_POWER=$LOW_POWER -e CPU_ONLY=$CPU_ONLY -e INPUT_TYPE=$INPUT_TYPE -e INPUT_TYPE2=$INPUT_TYPE2 -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/tmp:/app/yolov8_ensemble/results -v `pwd`:/savedir --net host --ipc=host --device /dev/dri/renderD128 ovms-yolov8-efficientnet:1.0 yolov8_ensemble/yolo_efficientnet.sh
```

## Run GST + Dlstreamer Yolov8 E2E Pipeline Examples

**Environment variables. Note not all are shown in the below Examples for brevity**

_Used to show direct console output instead of logging to the tmp directory_<br>
DC=1 

_Video streams' location and types_<br>
INPUTSRC=rtsp://127.0.0.1:8554/camera_0 <br>
INPUTSRC2=rtsp://127.0.0.1:8554/camera_0 <br>
INPUT_TYPE=RTSP_H264<br>
INPUT_TYPE2=RTSP_H264

_Rendering_<br>
RENDER_MODE=0 # enable rendering graphical content in a window<br>

_Pipelines_<br>
LOW_POWER=1  # GPU  pipeline<br>
CPU_ONLY=0   # CPU  pipeline<br>
LOW_POWER=0 && CPU_ONLY=0 # CPU+GPU pieline<br>
MAX=1 # Stream 1 is GPU+GPU and Stream 2 is GPU+CPU

**Yolov8 Dual Camera GPU Example**
```
INPUTSRC=rtsp://127.0.0.1:8554/camera_0 
INPUTSRC2=rtsp://127.0.0.1:8554/camera_0 
RENDER_MODE=0
LOW_POWER=1
CPU_ONLY=0
INPUT_TYPE=RTSP_H264
INPUT_TYPE2=RTSP_H264
DC=1
```

```
sudo docker run --rm --user root -it -e DISPLAY=$DISPLAY -e DC=$DC -e INPUTSRC=$INPUTSRC -e INPUTSRC2=$INPUTSRC2 -e RENDER_MODE=$RENDER_MODE -e LOW_POWER=$LOW_POWER -e CPU_ONLY=$CPU_ONLY -e INPUT_TYPE=$INPUT_TYPE -e INPUT_TYPE2=$INPUT_TYPE2 -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/tmp:/app/dlstreamer/results -v `pwd`:/savedir --net host --ipc=host --device /dev/dri/renderD128 dls-yolov8-efficientnet:1.0 
```

```
source /home/dlstreamer/dlstreamer_gst/scripts/setup_env.sh
```

```
./yolov8_efficientnet_dual.sh
```
