/*function to output the position of centroids of stars found in an image*/

/*
input consisting of
1. An array of sums of coordinates along x and y
2. An array of weights
3. An array of the count of number of pixels in each tagged region
4. An array of final tags corresponding to each tag
5. Count of number of tags
6. Count of number of final tags
*/

void find_centroid(float sum_x[], float sum_y[], float weights[], int num_pixels[], int final_tag[], int num_tags, int num_final_tags)
{

//an array defined to contain the position of centroids of a star

int arr_star_coordinates[40][2]=0;    //[k][0]=pos_x  [k][1]=pos_y

//variable to count number of stars

int num_stars=0;

//variable to count number of singly tagged stars

int num_single_tag_stars=0;

//variable to count number of zero rows in arr_sums

int num_zero_rows=0;

//iteration variable

int i=0;

//array of variables to sum the values of different tagged regions of the same star ("summation variables")

float tot_sum_x[num_final_tags]=0, tot_sum_y[num_final_tags]=0, tot_weights[num_final_tags]=0;
int tot_pixels[num_final_tags]=0;

//loop to find position of centroids of stars with single tagged region and update values of summation variables for multi tagged stars

for(i=0; i<num_tags; i++)
    {
    //is region singly tagged?

    if (final_tag[i] == 0)

        {
        //is number of pixels in region within range?

        if (num_pixels[i] < MIN_PIXELS || num_pixels[i] > MAX_PIXELS)
            continue;

        arr_star_coordinates[num_final_tags + num_single_tag_stars][0] = (sum_x[i] - LENGTH/2)/weights[i];
        arr_star_coordinates[num_final_tags + num_single_tag_stars][1] = -1*(sum_y[i] - BREADTH/2)/weights[i];

        num_single_tag_stars++;
        num_stars++;
        }

    else

        {
        //update summation variables

        tot_sum_x[final_tag[i]]+=sum_x[i];
        tot_sum_y[final_tag[i]]+=sum_y[i];
        tot_weights[final_tag[i]]+=weights[i];
        tot_pixels[final_tag[i]]+=num_pixels[i];
        }

    }

//loop to find position of centroids of stars with more than one tagged regions

for(i=0; i<num_final_tags; i++)
    {
    //is number of pixels in region within range and with positive weight

    if (tot_pixels[i] > MIN_PIXELS && tot_pixels[i] < MAX_PIXELS && tot_weights[i] > 0)
        {
        arr_star_coordinates[i - num_zero_rows][0] = (tot_sum_x[i] - LENGTH/2)/tot_weights[i];
        arr_star_coordinates[i - num_zero_rows][1] = -1*(tot_sum_y[i] - BREADTH/2)/tot_weights[i];

        num_stars++;
        }
    else
        num_zero_rows++;
    }

//to remove possible zero rows present between dense rows
//is the number of zero rows between dense rows positive?

if (num_zero_rows > 0)
    {
    for(i = (num_final_tags - num_zero_rows); i < num_stars; i++)
        {
        arr_star_coordinates[i][0] = arr_star_coordinates[i + num_zero_rows][0];
        arr_star_coordinates[i][1] = arr_star_coordinates[i + num_zero_rows][1];
        }
    for(i = num_stars; i < (num_stars + num_zero_rows); i++)
        {
        arr_star_coordinates[i][0] = 0;
        arr_star_coordinates[i][1] = 0;
        }
    }

/*output consisting of
1. centroids of stars (arr_star_coordiantes)
2. number of stars (num_stars)
*/

//end of function

}

int main()
{

return 0;

}
