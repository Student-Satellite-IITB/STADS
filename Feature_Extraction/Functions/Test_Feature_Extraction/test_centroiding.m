function tests = test_centroiding
%test code for centroiding.m
tests = functiontests(localfunctions);
end

%find rms and max error values required for the star matching and estimation team
function [rms, max] = find_rms(abs_error)
    rms = 0;
    max = 0;
    for I=1:size(abs_error,1)
        m = abs_error(I,1)^2 + abs_error(I,2)^2;
        if max < m 
            max = m;
        end
        rms = rms + m;
    end
    rms = rms/size(abs_error,1);
    rms = sqrt(rms);
end

%find number and centroid of stars within circle radius r about x0,y0
function [centroids_in_r, num_in_r] = find_in_r(arr_centroids,x0,y0,r)
    centroids_in_r = zeros(size(arr_centroids,1),size(arr_centroids,2));
    num_in_r=0;
    for I=1:size(arr_centroids,1)
        m = (arr_centroids(I,1)-x0)^2 + (arr_centroids(I,2)-y0)^2;
        if m<r
            num_in_r = num_in_r +1;
            centroids_in_r(num_in_r,:) = arr_centroids(I,:);
        end
    end
end

function [coordinate] = search_centroid(arr_centroids,x0,y0)
    r = 10^-1;    %set radius
    coordinate = [0,0];
    for I=1:size(arr_centroids,1)
        m = (arr_centroids(I,1)-x0)^2 + (arr_centroids(I,2)-y0)^2;
        if m<r
            coordinate=arr_centroids(I,:);
            break;
        end
    end
end

function [a] = sort_yx (a)
    for I=1:size(a,1)-1
        for J=1:size(a,1)-I-1
            if a(J,1)<a(J+1,1)
                t=a(J,:);
                a(J,:)=a(J+1,:)
                a(J+1,:)=t;
            end
        end
    end
    for I=1:size(a,1)-1
        for J=1:size(a,1)-I-1
            if a(J,2)>a(J+1,2)
                t=a(J,:);
                a(J,:)=a(J+1,:)
                a(J+1,:)=t;
            end
        end
    end
end

function testCentroids(testCase)
    n = 10; %number of test cases
    allowed_error = 10^-6; %allowed error
    imgpath = "C:/";
    outpath = "C:/";
    for I = 1: n
        test_case_1 = load(imgpath);    %loading input of test case
        arr_exp_centroids = load(outpath);  %loading expected output of test case
        [arr_centroids] = centroiding(test_case_1); %simulating the function with given input
        arr_centroids = arr_centroids(:,2:3);
        abs_error = abs(arr_exp_centroids - arr_centroids); %finding the absolute error between the two outputs
        verifyLessThan(testCase, abs_error, allowed_error);    %successful if error is less than allowed error the width of a pixel
        %sort by brightness?
    end
end
