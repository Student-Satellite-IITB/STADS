#include<iostream>
using namespace std;

struct Pixels
{

int value, tag;

};

void merge_tag(Pixels pixel[30][30]) //p[x][y]
{

int i=0,j=0;
for(;i<29;i++)
    for(j=0;j<29;j++)
        if (pixel[i][j].value > threshold)
            {
            if (pixel[i][j+1].value > threshold)
                {
                if(pixel[i][j].tag != pixel[i][j+1].tag)
                    {
                    pixel[i][j].tag = min(pixel.tag[i][j], pixel.tag[i][j+1]);
                    pixel[i][j+1].tag = pixel[i][j].tag;
                    }
                }
            if (pixel[i+1][j].value > threshold)
                {
                if(pixel[i][j].tag != pixel[i+1][j].tag)
                    {
                    pixel[i][j].tag = min(pixel.tag[i][j], pixel.tag[i+1][j]);
                    pixel[i+1][j].tag = pixel[i][j].tag;
                    }
                }
            }

}

void find_centroid(Pixels pixel[30][30])
{

int i=0, j=0;
int sum_x=0, sum_y=0, no=0, tag=1;
//considering tag of pixels lesser than threshold as 0
for(;i<30;i++)
    for(j=0;j<30;j++)
        {
        if (pixel[i][j].value > threshold)
            {
            if (pixel[i][j].tag == tag)
                {
                sum_x += pixel[i][j].value;
                sum_y += pixel[i][j].value;
                no++;
                }
            else if (pixel[i][j].tag > tag)
                {
                cout<<sum_x*1.0/no<<' '<<sum_y*1.0/no;
                no  = 1;
                tag = pixel[i][j].value;
                }
            }
        }

}

int main()
{

return 0;

}
