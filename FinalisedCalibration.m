clc;
clear all;
close all;

% Specify the path of folder containing the images
imageFolder = 'C:\vandana pratice\Image Processing\Camera2';

% Get all image file names in the folder 
imageFiles = dir(fullfile(imageFolder, '*.jpg')); 

% Build the list of image file paths
imageFileNames = fullfile(imageFolder, {imageFiles.name});

%% Detect calibration pattern in images
detector = vision.calibration.monocular.CheckerboardDetector();
[imagePoints, imagesUsed] = detectPatternPoints(detector, imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates for the planar pattern keypoints
squareSize = 25;  % size of checkerboard in millimeters
worldPoints = generateWorldPoints(detector, 'SquareSize', squareSize);

% Calibrate the camera using estimateCameraParameters Function
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', true, 'EstimateTangentialDistortion', true, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

%% 
% Visualize reprojection errors
figure; showReprojectionErrors(cameraParams);
% Visualize pattern locations
figure; showExtrinsics(cameraParams, 'CameraCentric');
% Visualize Camera locations
figure; showExtrinsics(cameraParams, 'PatternCentric');

%% To visualize the projected points and detected real-world points
for imgIndex = 1:length(imageFileNames)
    % Display Projected points vs Detected Points
    figure;
    imshow(imageFileNames{imgIndex}); 
    hold on;
    
    % Plot the detected points (green circles)
    plot(imagePoints(:, 1, imgIndex), imagePoints(:, 2, imgIndex), 'go','LineWidth',1.5);
    
    % Plot the reprojected points 
    plot(cameraParams.ReprojectedPoints(:, 1, imgIndex), cameraParams.ReprojectedPoints(:, 2, imgIndex), 'r+','LineWidth',1.5);
    
    % Add a legend for clarity
    legend('Detected Points', 'Reprojected Points');
    title(['Image ', num2str(imgIndex), ' - Detected vs. Reprojected Points']);
    hold off;
end

%% Save camera matrix and intrinsic parameters in a text file
z = cameraParams.Intrinsics;
focalLength = z.FocalLength;     
principalPoint = z.PrincipalPoint;
radialDistortion = z.RadialDistortion;
TangetialDistortion = z.TangentialDistortion;
Skew = z.Skew;

% Combine them into a matrix 
data = [focalLength; principalPoint; radialDistortion; TangetialDistortion];

% Create the intrinsic matrix
intrinsicMatrix = [focalLength(1), Skew, principalPoint(1);
                   0, focalLength(2), principalPoint(2);
                   0, 0, 1];

writematrix(intrinsicMatrix, 'Camera_matrix.txt');
dataCell = {
    'FocalLength', focalLength(1), focalLength(2);
    'PrincipalPoint', principalPoint(1), principalPoint(2);
    'RadialDistortion', radialDistortion(1), radialDistortion(2);
    'TangetialDistortion', TangetialDistortion(1), TangetialDistortion(2)
};
writecell(dataCell, 'Intrinsic_Parameters.txt');

%% Draw a straight line on the undistorted image to verify the camera calibration accuracy
for imgIndex = 1:length(imageFileNames)
    % Read and undistort the image
    undistortedImage1 = imread(imageFileNames{imgIndex});
    undistortedImage = undistortImage(undistortedImage1, cameraParams);
    
    % Extract reprojected points for this image
    reprojectedPoints = cameraParams.ReprojectedPoints(:, :, imgIndex);
    x = reprojectedPoints(:, 1); % X-coordinates
    y = reprojectedPoints(:, 2); % Y-coordinates

    % Fit a straight line to the reprojected points
    if range(x) > range(y)
        p = polyfit(y, x, 1);  % Fit line (x as a function of y)
        y_fit = linspace(min(x), max(x), 100);
        x_fit = polyval(p, y_fit);
    else
        p = polyfit(x, y, 1);
        x_fit = linspace(min(x), max(x), 100);
        y_fit = polyval(p, x_fit);
    end

    % Plot the results
    figure;
    imshow(undistortedImage);
    hold on;
    plot(reprojectedPoints(:, 1), reprojectedPoints(:, 2), 'ro', 'MarkerSize', 8, 'DisplayName', 'Reprojected Points');
    plot(x_fit, y_fit, 'b-', 'LineWidth', 2, 'DisplayName', 'Fitted Line');
    xlabel('X');
    ylabel('Y');
    legend show;
    grid on;
    title(sprintf('Straight Line Fit to Reprojected Points (Image %d)', imgIndex));
    hold off;
end
