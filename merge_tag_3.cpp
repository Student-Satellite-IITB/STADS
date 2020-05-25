/*function to output the position of centroids of stars found in an image*/

//fstream header file for ifstream, ofstream and fstream classes

#include<fstream>
using namespace std;

/*
input consisting of
1. An array of sums of coordinates along x and y
2. An array of weights
3. Count of number of final tags
4. An array of tags corresponding to final tags where the first column corresponds to the number of tags associated
with that particular final tag and the subsequent columns correspond to tags
*/

void merge_centroid(float sum_x[], float sum_y[], float weights[], int final_tag_num, int arr_final_tags[][])
{

//a structure defined to contain the position of centroids of a star before writing on an external file

struct centroid
{

int pos_x,pos_y;

}star_coordinates;

//creation of fstream class object

fstream fout;

//open external file to output the position of centroids of stars

fout.open("file_centroids.dat", ios::out | ios::binary);

//initialise iteration variables

int i,j;

//loop to find position of centroids of stars with single tagged region

for(i=1;i<arr_final_tag[0][0];i++)
    {
    star_coordinates.pos_x=sum_x[arr_final_tag[0][i]]/weights[arr_final_tag[0][i]];
    star_coordinates.pos_y=sum_y[arr_final_tag[0][i]]/weights[arr_final_tag[0][i]];

    //write the position of centroid of star to external file

    fout.write((char*) &star, sizeof(star));
    }

//variables to sum the values of different tagged regions of the same star

float tot_sum_x=0,tot_sum_y=0,tot_weights=0;

//loop to find position of centroids of stars with more than one tagged regions

for(i=1;i<final_tag_num;i++)
    {
    for(j=0;j<arr_final_tag[i][0];j++)
        {
        tot_sum_x+=sum_x[arr_final_tag[i][j]];
        tot_sum_y+=sum_y[arr_final_tag[i][j]];
        tot_weights+=weights[arr_final_tag[i][j]];
        }
    star_coordinates.pos_x=tot_sum_x/tot_weights;
    star_coordinates.pos_y=tot_sum_y/tot_weights;

    //write the position of centroid of star to external file

    fout.write((char*) &star, sizeof(star));

    tot_sum_x=0,tot_sum_y=0,tot_weights=0;
    }

//close external file

fout.close;

//end of function

}

int main()
{

return 0;

}
