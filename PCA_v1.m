%Read in ship speed from an edited csv file and assign it to a DataSet
dataSetSpeed = readtable('C:\Users\connorlof\Documents\School\Fall 2017\Software Eng\Files\Speed CSVs\dataSpeed7.csv','ReadVariableNames',false);

%dataSetSpeed = readtable('C:\Users\connorlof\Documents\School\Fall 2017\Software Eng\Files\completeDataCsv.csv','ReadVariableNames',false);


%dataSetSpeed = readtable('C:\Users\connorlof\Downloads\CMAPSSData\unit1csv.csv','ReadVariableNames',false);

%Required for the NASA data set, remove first column
%dataSetSpeed.Var1 = []

shipSpeedTitle = '21 knots';

graphPca(dataSetSpeed,shipSpeedTitle)



%Function to calculate the pca for the called dataSet, as well as graph the
%pca in a cumulative/indiviudal comparison plot for the # of principal
%components, and the percent of the data explained by that number 
%of principal components.
%
%Working on making this less "hard coded", meaning having it work for any
%csv file of any amount of columns and principal components. Also
%attempting to add csv file assignment(line 2) into the function as well
%(if possible).
function z = graphPca(data, shipSpeed)

    %parse table to array
    dataAsTable = table2array(data);
    
    %gets the size of the table where m = # of rows and n = # of columns
    %n will be used later for determining the # of individual principal
    %components, **m is not needed**.
    [m,n] = size(dataAsTable);
    
    %normalize columns of matrix
  % norm = sqrt(sum(dataAsTable.^2,1)); % Compute norms of columns
  % dataAsTable = bsxfun(@rdivide,dataAsTable,norm); % Normalize M
  % norm = reshape(norm,[],1); % Store column vector of norms
    mn = mean(dataAsTable);
    sd = std(dataAsTable);
    sd(sd==0) = 1;

    dataNorm = bsxfun(@minus,dataAsTable,mn);
    dataNorm = bsxfun(@rdivide,dataNorm,sd);
    
    dataAsTable = dataNorm;

    %PCA algo based on psuedo code on Github
    coeff = pca(dataAsTable);
    [coeff,score,latent] = pca(dataAsTable);

    %Plot the cumulative sum of each pca component
    figure
    plot([cumsum(latent(1:n))/sum(latent) latent(1:n)/sum(latent)]*100,'.','MarkerSize',24)
    xlabel('# of principal components');
    ylabel('% of variance of dataset explained');
    legend('Cumulative','Individual')
    
    fullTitle1 = strcat('Cumulative Sum of Each Prinicpal Component (',shipSpeed,')');
    
    title(fullTitle1)
    grid on
    
    xAxis = tall(score(:,1));
    yAxis = tall(score(:,2));

    %Create a bin scatter plot of PCA
    figure
    binScatterPlot(xAxis,yAxis,[50,50],'Gamma',0.01)
    axis equal
    xlabel('First Principal Component')
    ylabel('Second Principal Component')
    fullTitle2 = strcat('Frequency of the First & Second Principal Components (',shipSpeed,')');
    
    title(fullTitle2)
    
    %Plot first and last data points
    %idxFirst = dataAsTable(1,:);
    firstPointsTall = score(1,1:2);
    %Last points
    %g = findgroups(dataAsTable.Unit);
    lastPointsTall = score(end,1:2);
    %get mid point of data
    midPointsTall = score(round(end/2,0),1:2);
    %gether them into memory
    [firstPoints,lastPoints] = gather(firstPointsTall,lastPointsTall);
    
    %plot the first and second PCA components
    figure
    hold on
    plot(score(:,1), score(:,2), '.','MarkerSize',12)
    plot(firstPoints(:,1),firstPoints(:,2),'g.','MarkerSize',16)
    %plot(midPointsTall(:,1),midPointsTall(:,2),'y.','MarkerSize',16)
    plot(lastPoints(:,1),lastPoints(:,2),'r.','MarkerSize',16)
    hold off
    axis equal
    xlabel('First Principal Component')
    ylabel('Second Principal Component')
    legend('Data Point','First Data Point','Last Data Point','Location','southwest')
    fullTitle3 = strcat('Scatter Plot of the First & Second Principal Components (',shipSpeed,')');
    
    title(fullTitle3)
    
end