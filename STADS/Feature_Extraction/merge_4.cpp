/*function to output the position of centroids of stars found in an image*/

/*
input consisting of
1. An array of sums of coordinates along x and y
2. An array of weights
3. Count of number of pixels in each tagged region
4. Count of number of final tags
5. An array of tags corresponding to final tags where the first column corresponds to the number of tags associated
with that particular final tag and the subsequent columns correspond to tags
*/

void find_centroid(float sum_x[], float sum_y[], float weights[], int num_pixels[], int final_tag[], int arr_final_tags[][])
{

//an array defined to contain the position of centroids of a star before writing on an external file

int arr_star_coordinates[50][2];    //[k][0]=pos_x  [k][1]=pos_y

//initialise variable to count number of stars

int num_stars=0;

//initialise iteration variables

int i,j;

//loop to find position of centroids of stars with single tagged region

for(i=0;final_tag[i]!=-1;i++)
    {

    //is final_tag[i] 0 and number of pixels more than MINIMUM_PIXEL_COUNT?

    if (num_pixels[i] < MINIMUM_PIXEL_COUNT || final_tag[i]!=0)
        continue;

    arr_star_coordinates[num_stars][0]=sum_x[i]/weights[i];
    arr_star_coordinates[num_stars][1]=sum_y[i]/weights[i];

    num_stars++;
    }

//variables to sum the values of different tagged regions of the same star

float tot_sum_x=0,tot_sum_y=0,tot_weights=0;
int tot_pixel_count=0;

//loop to find position of centroids of stars with more than one tagged regions

for(i=0;arr_final_tag[i][0]!=0;i++)
    {
    for(j=0;j<arr_final_tag[i][0];j++)
        {
        tot_sum_x+=sum_x[arr_final_tag[i][j]];
        tot_sum_y+=sum_y[arr_final_tag[i][j]];
        tot_weights+=weights[arr_final_tag[i][j]];
        tot_pixel_count+=num_pixels[arr_final_tag[i][j]];
        }

    if (tot_pixel_count > MINIMUM_PIXEL_COUNT)
        {
        arr_star_coordinates[num_stars][0]=tot_sum_x/tot_weights;
        arr_star_coordinates[num_stars][1]=tot_sum_y/tot_weights;

        num_stars++;
        }

    tot_sum_x=0;
    tot_sum_y=0;
    tot_weights=0;
    tot_pixel_count=0;

    }

/*output consisting of
1. centroids of stars (star_coordiantes)
2. number of stars (num_stars)
*/

//end of function

}

int main()
{

return 0;

}
