# CameraCalibration
# CameraCalibrationWithMATLAB
Used MATLAB to calibrate the camera.
Calibration.m file is the MATLAB File. Camera calibration is mapping world coordinate points (checkerboard points) onto the image plane (projected points).
Images are taken under good lighting conditions with asymmetric checkerboard pattern. 
Firstly, Images are uploaded in jpg format.
Then using cameraetimateparameters function calculated intrinsic and extrinsic parameters. 
Intrinsic parameters are focal length in x and y axis, optical center in x and y axis and skew.
Extrinisc paraemeters consists of translation vector and rotational matrices.
# CHECKERBOARD PATTERN
Checkerboard pattern is the most common approach for camera calibration. Checkerboard pattern should be asymmetric which means one direction with odd number of boxes and another direction with even number of boxes. Maximum number of boxes direction will be considered as X direction. It should be asymmetric pattern to get proper origin and should able to detect corners properly even when image rotated 180 degrees. Each box with width of 25mm.
So, we took pictures with asymmetric checkerboard pattern for two cameras.
we analysed both the cameras to get the good accuracy.
# Camera1 and Camera2
Camera Calibration had done on two cameras with resoultion of 1920 * 1080, 3840*2160.
Camera1 and Camera2 are used to calibrate. Camera1 with dimensions of 1920 * 1080. width 
1920 and height is 1080.
Camera2 dimensions with 3840*2160. Width 3840 and height 2160.
# Calculating Intrinsic and Extrinsic parameters.
# EstimateCameraParameters
EstimateCameraParameters function used to calculate the camera parameters changing the distortion coefficients. To know more about the estimatecameraParameters function. select the function and right click on it. open the estimatecameraparameters program to get know more about how intrinsic and extrinisic parameters are calculated.
# Plotting
After calculating the intrinsic and extrinsic parameters. Tried to align projected points (Projected points are the pixel values after calibration) and detected points ( the points before calibration) to visualise how well both the points mapped by plotting on the same image. Then plotted camera centric and pattern centric to observe the distance and inclination from camera to the image. Determined meanreprojection error for all the images. Meanreprojection error is difference between projected and detected points. Normally, when meanreprojectionerror is less than 0.6 , it is considered as camera calibrated good.

Camera_matrix is the intrinsic matrix and intrinsic_Parameters are the camera parameters.




