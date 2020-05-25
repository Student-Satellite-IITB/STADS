#include<iostream>
using namespace std;

struct Pixels
{

int value, tag;

};

void insertion(int a[], int b)
{

//insertion sort

}
void centroid(int sum_x[50], int sum_y[50], int no_of_pixels[50], int n, Pixels pixel[30][30], int diff_tag[100][2])    //diff_tag[a][0]=x    diff_tag[a][1]=y
{                                                                                                                       //n=no of double tagged pixels

int i=0, tags[10][10], new_tag_1, new_tag_2, j=0, k=0, a[10][10];
for(;i<n;i++)
    {
    x = diff_tag[i][0];
    y = diff_tag[i][1];
    new_tag_2 = pixel[x][y].tag;
    new_tag_1 = pixel[x-1][y].tag;
    for(j=0;j<k;j++)
        if ( new_tag_2 == tags[j] )
            {
            insertion(tags[t][10], new_tag_1);
            break;
            }
        else if( new_tag_1 == tags[j] )
            {
            insertion(tags[t][10], new_tag_2);
            break;
            }
        else
            t++;
    }
for(i=1;i<t;i++)
    for(j=0;j<i;j++)
        if (intersection(tags[j],tags[i]) != NULL)
            merge(tags[j],tags[i]);
for(i=0;i<no(tags);i++)
    for(j=0;j<no(tags[i]);j++)
        {
        sum_x += sum_x[tags[i][j]];
        sum_y += sum_y[tags[i][j]];
        }
    cout<<sum_x/no<<' '<<sum_y/no;
}

int main()
{

return 0;

}
