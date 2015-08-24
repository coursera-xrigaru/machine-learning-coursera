function [C, sigma] = dataset3Params(X, y, Xval, yval)
%EX6PARAMS returns your choice of C and sigma for Part 3 of the exercise
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel
%   [C, sigma] = EX6PARAMS(X, y, Xval, yval) returns your choice of C and 
%   sigma. You should complete this function to return the optimal C and 
%   sigma based on a cross-validation set.
%

% You need to return the following variables correctly.
C = 1;
sigma = 0.3;

% ====================== YOUR CODE HERE ======================
% Instructions: Fill in this function to return the optimal C and sigma
%               learning parameters found using the cross validation set.
%               You can use svmPredict to predict the labels on the cross
%               validation set. For example, 
%                   predictions = svmPredict(model, Xval);
%               will return the predictions on the cross validation set.
%
%  Note: You can compute the prediction error using 
%        mean(double(predictions ~= yval))
%

Possibilities = [1 3]' * 10 .^ [-2:1]; %[0.01 0.03 0.1 0.3 1 3 10 30]
%Possibilities = ([0.01 0.03]' * (10 .^ [0:0]))(:)';  %[0.01 0.03 0.1 0.3 1 3 10 30]

values_count = numel(Possibilities);
Params = {};%zeros(values_count, values_count);

for i = 1:values_count
 for j = 1:values_count
      Params = [ Params; struct('C', Possibilities(i), 'sigma', Possibilities(j))];          
 end
end

errors = ... % cell2mat ...
  ( parcellfun(nproc, ...
  %( cellfun( ...
   @(params) computeModelError(params.C, params.sigma), Params ...
          % , "UniformOutput", false ...
       ));

[~, pos] = min(errors);
best_param = Params{pos};
C = best_param.C;
sigma = best_param.sigma;

function error = computeModelError(C, sigma)
  model = svmTrain(X, y, C, @(x1, x2) gaussianKernel(x1, x2, sigma));
  predictions = svmPredict(model, Xval);
  error = mean(double(predictions ~= yval));
%  fprintf('for C: %f, sigma: %f, error is: %f\n', C, sigma, error);
end  
% =========================================================================

end