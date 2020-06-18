#include<iostream>
#include<chrono>
#include<fstream>
using namespace std;
using namespace std::chrono;

#define THRESHOLD 10
#define STAR_MIN_PIXEL 3
#define STAR_MAX_PIXEL 150
#define LENGTH 1280
#define BREADTH 1024
#define NUM_REGIONS 100
#define NUM_FINAL_TAGS 40
#define NUM_TAGS_PER_REGION 21
#define PIXEL_WIDTH 0.0048
#define NUM_TOT_STARS 100

unsigned short int arr_image[BREADTH][LENGTH];
unsigned short int arr_out_img[BREADTH + 1][LENGTH + 2][2];

void fe_tag(unsigned short int arr_in_img[BREADTH][LENGTH], double arr_sums_x[NUM_REGIONS], double arr_sums_y[NUM_REGIONS], double arr_weights[NUM_REGIONS], int arr_num[NUM_REGIONS], int arr_flags[NUM_REGIONS], int& tag_num, int& final_tag_num)
{

    int rows = BREADTH;
    int columns = LENGTH;

    // setting the "output" array with two layers, one for the tag, one for the oriiginal image, padding it to the left, right and top
    //unsigned short int arr_out_img[rows + 1][columns + 2][2];
    for (int j_set_row = 0; j_set_row < columns + 2; j_set_row++)
        arr_out_img[0][j_set_row][0] = 0;
    for (int i_set_col = 1; i_set_col < rows + 1; i_set_col++)
        {
        arr_out_img[i_set_col][0][0] = 0;
        arr_out_img[i_set_col][columns + 1][0] = 0;
        }

    for (int i_copy_img = 1; i_copy_img < rows + 1; i_copy_img++)
        for (int j_copy_img = 1; j_copy_img < columns + 1; j_copy_img++)
            arr_out_img[i_copy_img][j_copy_img][0] = arr_in_img[i_copy_img - 1][j_copy_img - 1];

    // initialising counters
    //int tag_num = 0;
    //int final_tag_num = 0;

    // initialising the output array
    // the first column is sum_intensity_times_x, the second column is
    // sum_intensity_times_y, the third column is sum_intensity, the fourth
    // is num_pixels and the fifth is final_tag
    double arr_sums[NUM_REGIONS][5];
    for (int i_set_zeros = 0; i_set_zeros < NUM_REGIONS; i_set_zeros++)
        for (int j_set_zeros = 0; j_set_zeros < 5; j_set_zeros++)
            arr_sums[i_set_zeros][j_set_zeros] = 0;

    // initialising the array containing final tags and tags associated with them
    int arr_final_tags[NUM_FINAL_TAGS][NUM_TAGS_PER_REGION];
        for (int i_set_zeros = 0; i_set_zeros < NUM_FINAL_TAGS; i_set_zeros++)
            for (int j_set_zeros = 0; j_set_zeros < NUM_TAGS_PER_REGION; j_set_zeros++)
                arr_final_tags[i_set_zeros][j_set_zeros] = 0;

    // initialising variables used in the loop
    int intensity;
    int i_left, i_above;
    int tag_left;
    int tag_above;
    int tag;
    int final_tag_above;
    int final_tag_left;
    int final_tag;
    int larger_final_tag, smaller_final_tag, num_iterations, num_skip;

    // looping over the input image
    for (int j_set_tags = 1; j_set_tags < rows+1; j_set_tags++)
        for (int i_set_tags = 1; i_set_tags < columns+1; i_set_tags++)

                {
                // "intensity" is the value stored at [j_tag, i_tag]
                intensity = arr_out_img[j_set_tags][i_set_tags][0];

                // if the pixel is bright,
                if (intensity > THRESHOLD)

                        {
                        // set the value of the pixel to the i_left as
                        // i_left, set the value of the pixel to above as i_above
                        i_left = arr_out_img[j_set_tags][i_set_tags-1][0];
                        i_above = arr_out_img[j_set_tags-1][i_set_tags][0];

                        // sequence to be followed if the pixel to the left is bright
                        if (i_left > THRESHOLD)
                            {
                            // set "tag_left" as the tag of the pixel to the left
                            tag_left = arr_out_img[j_set_tags][i_set_tags-1][1];

                            // if the pixel above is also bright
                            if (i_above > THRESHOLD)
                                {
                                // set "tag_above" as the tag of the pixel above
                                tag_above = arr_out_img[j_set_tags-1][i_set_tags][1];

                                // if both left and above have the same tag
                                if (tag_above == tag_left)
                                    {
                                    // update the tag
                                    tag = tag_above;
                                    arr_out_img[j_set_tags][i_set_tags][1] = tag;

                                    // update values in arr_sums
                                    arr_sums[tag][0] += intensity*(i_set_tags + 1);
                                    arr_sums[tag][1] += intensity*(j_set_tags + 1);
                                    arr_sums[tag][2] += intensity;
                                    arr_sums[tag][3] += 1;
                                    arr_sums[tag][4] += 0;
                                    }

                                // if both the pixel above and to the left are bright, and have different tags
                                else

                                    {
                                    // if tag of the pixel above is associated with a nonzero final tag
                                    if (arr_sums[tag_above][4] > 0)
                                        {
                                        final_tag_above = arr_sums[tag_above][4];

                                        // if the tag of the pixel to the left is also associated with a nonzero final tag
                                        if (arr_sums[tag_left][4] > 0)
                                            {
                                            final_tag_left = arr_sums[tag_left][4];

                                            // if the two final tags are equal
                                            if (final_tag_above == final_tag_left)
                                                {
                                                // update values for the tag
                                                // corresponding to the tag
                                                // of the pixel above
                                                tag = tag_above;
                                                arr_sums[tag][0] += intensity*(i_set_tags + 1);
                                                arr_sums[tag][1] += intensity*(j_set_tags + 1);
                                                arr_sums[tag][2] += intensity;
                                                arr_sums[tag][3] += 1;
                                                arr_sums[tag][4] += 0;
                                                arr_out_img[j_set_tags][i_set_tags][1] = tag;
                                                }

                                            // if the tags of the pixel above and the pixel to the left are associated with different final tags,
                                            else
                                                {
                                                // update the values
                                                // corresponding to the tag
                                                // of the pixel above
                                                tag = tag_above;
                                                arr_sums[tag][0] += intensity*(i_set_tags + 1);
                                                arr_sums[tag][1] += intensity*(j_set_tags + 1);
                                                arr_sums[tag][2] += intensity;
                                                arr_sums[tag][3] += 1;
                                                arr_sums[tag][4] += 0;
                                                arr_out_img[j_set_tags][i_set_tags][1] = tag;

                                                // merge the data
                                                // corresponding to the two
                                                // final tags
                                                larger_final_tag = max(final_tag_above, final_tag_left);
                                                smaller_final_tag = min(final_tag_above, final_tag_left);
                                                num_iterations = arr_final_tags[larger_final_tag][0];
                                                num_skip = arr_final_tags[smaller_final_tag][0];
                                                for (int i_final_tag_change  = 0; i_final_tag_change < num_iterations; i_final_tag_change++)
                                                    {
                                                    arr_final_tags[smaller_final_tag][num_skip + 1 + i_final_tag_change] = arr_final_tags[larger_final_tag][i_final_tag_change+1];
                                                    arr_sums[arr_final_tags[larger_final_tag][i_final_tag_change]][4] = smaller_final_tag;
                                                    arr_final_tags[larger_final_tag][i_final_tag_change + 1] = 0;
                                                    }
                                                arr_final_tags[larger_final_tag][0] = 0;
                                                arr_final_tags[smaller_final_tag][0] = num_skip + num_iterations;
                                                }
                                            }

                                        // if the final tag of the tag associated with the pixel to the left is zero, but that associated with the one above isn't
                                        else
                                            {
                                            // update the data of the tag
                                            // of the pixel above
                                            tag = tag_above;
                                            arr_sums[tag][0] += intensity*(i_set_tags + 1);
                                            arr_sums[tag][1] += intensity*(j_set_tags + 1);
                                            arr_sums[tag][2] += intensity;
                                            arr_sums[tag][3] += 1;
                                            arr_sums[tag][4] += 0;
                                            arr_out_img[j_set_tags][i_set_tags][1] = tag;
                                            // set final_tag as the final
                                            // tag of the region that the
                                            // pixel above is in, update
                                            // corresponding data
                                            final_tag = arr_sums[tag_above][4];
                                            arr_final_tags[final_tag][arr_final_tags[final_tag][0]+2] = tag;
                                            arr_sums[tag_left][4] = final_tag;
                                            arr_final_tags[final_tag][0] = arr_final_tags[final_tag][0] + 1;
                                            }
                                        }

                                    // if the final tag of the tag of the pixel above is zero
                                    else

                                        {
                                        // if the final tag of the tag of the pixel to the left is nonzero
                                        if (arr_sums[tag_left][4] > 0)
                                            {
                                            // update the data corresponding
                                            // to the tag of the pixel above
                                            tag = tag_above;
                                            arr_sums[tag][0] += intensity*(i_set_tags + 1);
                                            arr_sums[tag][1] += intensity*(j_set_tags + 1);
                                            arr_sums[tag][2] += intensity;
                                            arr_sums[tag][3] += 1;
                                            arr_sums[tag][4] += 0;
                                            arr_out_img[j_set_tags][i_set_tags][1] = tag;
                                            // add the tag of the pixel
                                            // above to the final tag
                                            // corresponding to the pixel to
                                            // the left
                                            final_tag = arr_sums[tag_left][4];
                                            arr_final_tags[final_tag][arr_final_tags[final_tag][1] + 2] = tag;
                                            arr_sums[tag_above][4] = final_tag;
                                            arr_final_tags[final_tag][0] = arr_final_tags[final_tag][0] + 1;
                                            }

                                        // if the final tags of both tag_left and tag_above are zero
                                        else
                                            {
                                            // update data corresponding to
                                            // the tag of the pixel above
                                            tag = tag_above;
                                            arr_sums[tag][0] += intensity*(i_set_tags + 1);
                                            arr_sums[tag][1] += intensity*(j_set_tags + 1);
                                            arr_sums[tag][2] += intensity;
                                            arr_sums[tag][3] += 1;
                                            arr_sums[tag][4] += 0;
                                            arr_out_img[j_set_tags][i_set_tags][1] = tag;
                                            // generate a new final tag,
                                            // update correspooonding data
                                            arr_final_tags[final_tag_num][0] = 2;
                                            arr_final_tags[final_tag_num][1] = tag_above;
                                            arr_final_tags[final_tag_num][2] = tag_left;
                                            arr_sums[tag_above][4] = final_tag_num;
                                            arr_sums[tag_left][4] = final_tag_num;
                                            final_tag_num = final_tag_num + 1;
                                            }
                                        }
                                    }
                                }

                             // if the pixel above is dim but the pixel to the left is bright
                            else
                                {
                                // update the data corresponding to the tag
                                // of the pixel to the left
                                tag = tag_left;
                                arr_out_img[j_set_tags][i_set_tags][1] = tag;
                                arr_sums[tag][0] += intensity*(i_set_tags + 1);
                                arr_sums[tag][1] += intensity*(j_set_tags + 1);
                                arr_sums[tag][2] += intensity;
                                arr_sums[tag][3] += 1;
                                arr_sums[tag][4] += 0;
                                }
                            }
                        else
                            {
                            // if the pixel above is bright is bright but the pixel to the left is dim
                            if (i_above > THRESHOLD)
                                {
                                // update the data corresponding to the tag
                                // of pixel above
                                tag_above = arr_out_img[j_set_tags - 1][i_set_tags][1];
                                tag = tag_above;
                                arr_out_img[j_set_tags][i_set_tags][1] = tag;
                                arr_sums[tag][0] += intensity*(i_set_tags + 1);
                                arr_sums[tag][1] += intensity*(j_set_tags + 1);
                                arr_sums[tag][2] += intensity;
                                arr_sums[tag][3] += 1;
                                arr_sums[tag][4] += 0;
                                }

                            // if both the pixel above and to the left are dim
                            else

                                {
                                // if the pixel to the right and the one to the right and above are bright
                                if (arr_out_img[j_set_tags][i_set_tags + 1][0] > THRESHOLD && arr_out_img[j_set_tags - 1][i_set_tags + 1][0] > THRESHOLD)
                                    {
                                    // update the data corresponding to the
                                    // tag of the pixel above the pixel to
                                    // the right
                                    tag = arr_out_img[j_set_tags - 1][i_set_tags + 1][1];
                                    arr_out_img[j_set_tags][i_set_tags][1] = tag;
                                    arr_sums[tag][0] += intensity*(i_set_tags + 1);
                                    arr_sums[tag][1] += intensity*(j_set_tags + 1);
                                    arr_sums[tag][2] += intensity;
                                    arr_sums[tag][3] += 1;
                                    arr_sums[tag][4] += 0;
                                    }

                                // if none of the conditions are satisfied,
                                // generate a new tag, update the
                                // corresponding data
                                else
                                    {
                                    arr_sums[tag][0] += intensity*(i_set_tags + 1);
                                    arr_sums[tag][1] += intensity*(j_set_tags + 1);
                                    arr_sums[tag][2] += intensity;
                                    arr_sums[tag][3] += 1;
                                    arr_sums[tag][4] += 0;
                                    arr_out_img[j_set_tags][i_set_tags][1] = tag_num;
                                    tag_num = tag_num + 1;
                                    }
                                }
                            }
                        }
                }


    //formatting outputs
    for (int i_format_out = 0; i_format_out < NUM_REGIONS; i_format_out++)
        {
        arr_sums_x[i_format_out] = arr_sums[i_format_out][0];
        arr_sums_y[i_format_out] = arr_sums[i_format_out][1];
        arr_weights[i_format_out] = arr_sums[i_format_out][2];
        arr_num[i_format_out] = arr_sums[i_format_out][3];
        arr_flags[i_format_out] = arr_sums[i_format_out][4];
        }
cout<<"Number of tags: "<<tag_num<<"\tNumber of final tags: "<<final_tag_num<<endl;
return;

}

int fe_merge_tag(double arr_sum_x[], double arr_sum_y[], double arr_weights[], int arr_num_pixels[], int arr_final_tag[], int num_tags, int num_final_tags, double arr_star_coordinates[NUM_TOT_STARS][2])
{

//function to output the position of centroids of stars found in an image*/

/*
input consisting of
1. An array of sums of coordinates along x and y
2. An array of weights
3. An array of the count of number of pixels in each tagged region
4. An array of final tags corresponding to each tag
5. Count of number of tags
6. Count of number of final tags
7. A placeholder array for star coordinates
*/

    //variable to count number of stars
    int num_stars=0;

    //variable to count number of singly tagged stars
    int num_single_tag_stars=0;

    //variable to count number of zero rows in arr_sums
    int num_zero_rows=0;

    //array of variables to sum the values of different tagged regions of the same star ("summation variables")
    double arr_tot_sum_x[NUM_FINAL_TAGS];
    double arr_tot_sum_y[NUM_FINAL_TAGS];
    double arr_tot_weights[NUM_FINAL_TAGS];
    double arr_tot_pixels[NUM_FINAL_TAGS];

    //loop to find position of centroids of stars with single tagged region and update values of summation variables for multi tagged stars
    for (int i_centroids_single = 0; i_centroids_single < num_tags; i_centroids_single++)
        {
        //if region is singly tagged
        if (arr_final_tag[i_centroids_single] == 0)
            {
            //if number of pixels in region is out of range
            if (arr_num_pixels[i_centroids_single] < STAR_MIN_PIXEL || arr_num_pixels[i_centroids_single] > STAR_MAX_PIXEL)
                continue;   //skip this iteration of loop

            //incrementing number of stars and single tagged stars by 1
            num_single_tag_stars = num_single_tag_stars + 1;
            num_stars = num_stars + 1;
            //updating values of centroid
            arr_star_coordinates[num_final_tags + num_single_tag_stars][0] = (arr_sum_x[i_centroids_single]/arr_weights[i_centroids_single] - 1) - (LENGTH/2 + 0.5);
            arr_star_coordinates[num_final_tags + num_single_tag_stars][1] = -1*((arr_sum_y[i_centroids_single]/arr_weights[i_centroids_single] - 1) - (BREADTH/2 + 0.5));
            }
        //if region has multiple tags
        else
            {
            //update summation variables
            arr_tot_sum_x[arr_final_tag[i_centroids_single]] = arr_tot_sum_x[arr_final_tag[i_centroids_single]] + arr_sum_x[i_centroids_single];
            arr_tot_sum_y[arr_final_tag[i_centroids_single]] = arr_tot_sum_y[arr_final_tag[i_centroids_single]] + arr_sum_y[i_centroids_single];
            arr_tot_weights[arr_final_tag[i_centroids_single]] = arr_tot_weights[arr_final_tag[i_centroids_single]] + arr_weights[i_centroids_single];
            arr_tot_pixels[arr_final_tag[i_centroids_single]] = arr_tot_pixels[arr_final_tag[i_centroids_single]] + arr_num_pixels[i_centroids_single];
            }
        }

    //loop to find position of centroids of stars with more than one tagged regions
    for (int i_centroids_multi = 0; i_centroids_multi < num_final_tags; i_centroids_multi++)
        //if number of pixels in region is within range and with positive weight
        if (arr_tot_pixels[i_centroids_multi] > STAR_MIN_PIXEL && arr_tot_pixels[i_centroids_multi] < STAR_MAX_PIXEL && arr_tot_weights[i_centroids_multi] > 0)
            {
            //updating values of centroid
            arr_star_coordinates[i_centroids_multi - num_zero_rows][0] = (arr_tot_sum_x[i_centroids_multi]/arr_tot_weights[i_centroids_multi] - 1) - (LENGTH/2 + 0.5);
            arr_star_coordinates[i_centroids_multi - num_zero_rows][1] = -1*((arr_tot_sum_y[i_centroids_multi]/arr_tot_weights[i_centroids_multi] - 1) - (BREADTH/2 + 0.5));
            //incrementing number of stars by 1
            num_stars = num_stars + 1;
            }
        //if number of pixels in region is out of range or with zero weight
        else
            num_zero_rows = num_zero_rows + 1;  //increment number of zero rows by 1

    //to remove possible zero rows present between dense rows
    //multi tagged regions have been written sequentially in the array beginning at index 1. Single tagged region have been written sequentially beginning at index <value of num_final_tags>
    //rows of coordinates of single tagged regions are adjusted to a lower index and the final couple of rows are overwritten to zero
    //if the number of zero rows between dense rows is positive
    if (num_zero_rows > 0)
        for (int i_remove_zero_rows = (num_final_tags - num_zero_rows); i_remove_zero_rows < num_stars; i_remove_zero_rows++)
            {
            arr_star_coordinates[i_remove_zero_rows][0] = arr_star_coordinates[i_remove_zero_rows + num_zero_rows][0];
            arr_star_coordinates[i_remove_zero_rows][1] = arr_star_coordinates[i_remove_zero_rows + num_zero_rows][1];
            }
        for (int i_overwrite_rows = (num_stars); i_overwrite_rows < (num_stars + num_zero_rows); i_overwrite_rows++)
            {
            arr_star_coordinates[i_overwrite_rows][0] = 0;
            arr_star_coordinates[i_overwrite_rows][1] = 0;
            }

/*
output consisting of
1. number of stars (num_stars)
*/

return (num_stars);

//end of function

}

int img_num_global=1;

int fe_centroiding(unsigned short int arr_img[BREADTH][LENGTH], double arr_centroids[NUM_TOT_STARS][3])
{

//initialising variables for fe_tag()
double arr_sum_x[NUM_REGIONS], arr_sum_y[NUM_REGIONS], arr_weights[NUM_REGIONS];
int arr_num_pixels[NUM_REGIONS], arr_final_tag[NUM_REGIONS];
int num_tags = 0, num_final_tags = 0;

//an array defined to contain the position of centroids of a star
double arr_star_coordinates[NUM_TOT_STARS][2];    //(k, 1)=pos_x  (k, 2)=pos_y
    // reading in the image, converting it to grayscale
    // arr_img = rgb2gray(imread(img_path));

    // getting interediate output from tag_2 and merge_tag_3
    fe_tag(arr_img, arr_sum_x, arr_sum_y, arr_weights, arr_num_pixels, arr_final_tag, num_tags, num_final_tags);
    int num_stars = fe_merge_tag(arr_sum_x, arr_sum_y, arr_weights, arr_num_pixels, arr_final_tag, num_tags, num_final_tags, arr_star_coordinates);

    // adding star ids and formatting the output
//cout<<num_stars<<"\nStar ID\t\tX\t\tY\n";
    for(int i_set_star_id = 0; i_set_star_id < num_stars; i_set_star_id++)
        {
        arr_centroids[i_set_star_id][0] = i_set_star_id + 1;
        arr_centroids[i_set_star_id][1] = arr_star_coordinates[i_set_star_id][0];
        arr_centroids[i_set_star_id][2] = arr_star_coordinates[i_set_star_id][1];
        //cout<<arr_centroids[i_set_star_id][0]<<"\t\t"<<int(arr_centroids[i_set_star_id][1])<<"\t\t"<<int(arr_centroids[i_set_star_id][2])<<endl;
        }

//output to external file
char filename[25];
    sprintf(filename, "centroids_%i.csv", img_num_global);
img_num_global++;
ofstream cen;
	cen.open(filename);
	//cen<<"ID, x_cen, y_cen\n";
	for(int k = 0; k < num_stars; k++)
		cen<<arr_centroids[k][0]<<","<<arr_centroids[k][1]<<","<<arr_centroids[k][2]<<"\n";

	cen.close();

return (num_stars);

}

int main()
{

double arr_centroids[NUM_TOT_STARS][3];

for(unsigned short img_num = 1; img_num <= 1; img_num++)
	{
    //input from external file
    ifstream file;

    cout<<"Image: "<<img_num<<endl;

    char filename[25];
    sprintf(filename, "image_%i.txt", img_num);

    file.open(filename);
    for(int i = 0; i < BREADTH; i++)
        for(int j = 0; j < LENGTH; j++)
            file >> arr_image[i][j];

    //Start time
    auto start = high_resolution_clock::now();

    //Feature Extraction start
    int num_stars = fe_centroiding(arr_image, arr_centroids);
    //Feature Extraction end

    //End time
    auto stop = high_resolution_clock::now();

    //Calculate time
    auto duration = duration_cast<milliseconds>(stop - start);

    cout<<"Number of Stars: "<<num_stars<<"\tTime Taken: "<<duration.count()<<" ms"<<endl<<endl;
    file.close();
    }

return 1;

}
