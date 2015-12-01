%% Face Detection Tester 
%%%%%%%%%%%%%%%%%%%%%%%%

% Input Variables
input_directory = 'women_2';
output_directory = 'women_faces';
output_size = 25;

% Get all images from a directory
dirname = input_directory;
files = dir(dirname);
imagePaths = cell(length(files)-2, 1);
for i=3:length(files)
    imagePaths{i-2} = strcat(dirname, '/', files(i).name);
end

% Create output directory
mkdir(output_directory);

% % Select a random image from the list
% image = imread(imagePaths{randi([1 length(imagePaths)])});
% 
% % Detect the faces
% [containsOneFace, face, labeledImage] = get_face(image);
x = 0;

for i=1:length(imagePaths)
    
    [pathstr, name, ext] = fileparts(imagePaths{i});
    if (strcmp(ext, '.jpg')),

        % Read in image and detect face
        imagePaths{i}
        image =imread(imagePaths{i});
        [containsOneFace, face, labeledImage] = get_face(image);

        % If there is a face, write to dir, otherwise don't
        if (containsOneFace),
            % Show the image and the faces detected
    %         subplot(1,3,1);
    %         imshow(image);
    %         title('Original');
    %         subplot(1,3,2);
    %         imshow(labeledImage);
    %         title('Labeled');
    %         subplot(1,3,3);
    %         imshow(face);
    %         title('Face');
    %         strcat('YES: ', 'faces/', name, '.jpg')
%             face = imresize(face, [output_size output_size]);
            face_big = imresize(face, [512 512]);
%             imwrite(face, strcat( output_directory, '/', name, '_face', '.png'));
            imwrite(face, strcat( output_directory, '/', name, '_faceLarge', '.png'));
%             imwrite(image, strcat( output_directory, '/', name, '_orig', '.png'));
%             imwrite(labeledImage, strcat( output_directory, '/', name, '_label', '.png'));
            x = x + 1;
        end
        
    end
    x
end
