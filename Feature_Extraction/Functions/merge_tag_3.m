%function to output the position of centroids of stars found in an image*/

%{
input consisting of
1. An array of sums of coordinates along x and y
2. An array of weights
3. Count of number of pixels in each tagged region
4. Count of number of final tags
5. An array of tags corresponding to final tags where the first column corresponds to the number of tags associated
with that particular final tag and the subsequent columns correspond to tags
%}

clc

%an array defined to contain the position of centroids of a star before writing on an external file

arr_star_coordinates=zeros(50*2);

%initialise variable to count number of stars

num_stars=0;

%initialise iteration variables

I=1,J=1;

%loop to find position of centroids of stars with single tagged region

for I=1:1:
    if final_tag(I) != -1
        break
    end
    if num_pixels(I) < MINIMUM_PIXEL_COUNT | final_tag(I) != 0
        continue
    end
    
    %is final_tag[i] 0 and number of pixels more than MINIMUM_PIXEL_COUNT?
    
    arr_star_coordinates(num_stars,1)=sum_x(I)/weights(I);
    arr_star_coordinates(num_stars,2)=sum_y(I)/weights(I);
    
    num_stars=num_stars+1;
end    

%variables to sum the values of different tagged regions of the same star

tot_sum_x=0,tot_sum_y=0,tot_weights=0;
tot_pixel_count=0;

%loop to find position of centroids of stars with more than one tagged regions

for I=0