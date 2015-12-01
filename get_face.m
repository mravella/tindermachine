function [ containsOneFace, face, labeledImage ] = get_face( image )
%GET_FACE Detects a face from an image
%   This function detects all faces in an image.
%   If the image has more than one face, or no faces
%   the function will return false because we only want to 
%   analyze images with on face in them.

    % Create an object detector
    faceDetector = vision.CascadeObjectDetector;
    
    % Get bounding boxes around faces
    boundingBoxes = step(faceDetector, image);

    % Label the image with the bounding boxes
    red = uint8([255 0 0]); 

    shapeInserter = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','CustomBorderColor',red,'LineWidth',10);
    RGB = repmat(image,[1,1,3]);
    labeledImage = step(shapeInserter, image, int32(boundingBoxes));
    
    % Set the contains variable based on how many faces are in the image
    if (size(boundingBoxes, 1) == 1)
        containsOneFace = true;
        face = zeros(25,25);
        face = image(boundingBoxes(2):(boundingBoxes(2)+boundingBoxes(3)), boundingBoxes(1):(boundingBoxes(1)+boundingBoxes(4)));
    else
        containsOneFace = false;
        face = zeros(25,25);
    end
    
end

