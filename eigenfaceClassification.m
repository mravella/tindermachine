
N=50;

positive_data=load_and_preprocess('./women_yes/',N);
negative_data=load_and_preprocess('./women_no/',N);

data = [positive_data; negative_data];

M=length(data);

images=[];  
for ii=1:M
    img=data{ii};
    [irow icol] = size(img);
    temp=reshape(img',irow*icol,1);
    images = [images temp];
end

%%

images_reshaped = images.';
coeff = pca(images_reshaped);
COEFF = coeff(:,1:(length(data)/4));

sz = size(COEFF);
num_faces = sz(2);

eigenMatrix = nan(50*22,50*22);

counter = 1;
for ii = 0:22
    for jj = 0:22
        if (counter < num_faces+1) 
            eigenface = reshape(COEFF(:,counter),N,N);
            eigenface = eigenface.';
            eigenMatrix((ii*50+1):((ii+1)*50), (jj*50+1):((jj+1)*50)) = eigenface(:,:); 
        else
            eigenMatrix((ii*50+1):((ii+1)*50), (jj*50+1):((jj+1)*50)) = 0;
        end
        counter = counter + 1;
    end
end
figure;
colormap(gray);
imagesc(eigenMatrix);

%%

feature_vectors = images_reshaped * COEFF;

%%

pos_labels = ones(length(positive_data),1);
neg_labels = ones(length(negative_data),1)*-1;

labels = [pos_labels; neg_labels];

%%

size_features = size(feature_vectors);
num_features = length(feature_vectors);

% Create a random ordering from 1 to the length of features
idxs = randperm(num_features);

labels_shuffled = nan(num_features, 1);
features_shuffled = nan(size_features(1), size_features(2));

% Create new feature, label and image data structures with the randomized
% indexing. 
for ii=1:num_features
    features_shuffled(ii,:) = feature_vectors(idxs(ii),:);
    labels_shuffled(ii) = labels(idxs(ii));
end

%%

train_size = round(.8*num_features);
test_size = num_features - train_size;

trainData = features_shuffled(1:train_size,:);
testData = features_shuffled(train_size+1:num_features,:);

trainLabels = labels_shuffled(1:train_size);
testLabels = labels_shuffled(train_size+1:num_features);

%%

% Train the classifier using training data
SVMModel = fitcsvm(trainData, trainLabels, 'CrossVal','on');

resultsLabels = cell(10,1);
scores = cell(10,1);

% For each slice, use the SVM model to predict the classification of the
% test data
for ii=1:10
    [label, Score] = predict(SVMModel.Trained{ii},testData);
    resultsLabels(ii,1) = {label};
    scores(ii,1) = {Score};
end


total = 0;
accuracies = zeros(10,1);

%%

% Record accuracies for each slice 
for ii=1:10
    accuracy = eval_accuracy(testLabels,resultsLabels{ii});
    accuracies(ii) = accuracy;
    total = total + accuracy;
end

% Calculate average accuracy
avg_accuracy = total / 10

% Using the array of accuracies for each slice, find the slice that had the
% highest accuracy rate
[max_val, argmax] = max(accuracies, [], 1);

