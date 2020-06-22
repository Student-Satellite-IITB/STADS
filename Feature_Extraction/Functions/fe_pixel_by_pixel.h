#include<iostream>
#include<chrono>
#include<fstream>
using namespace std;
using namespace std::chrono;

#define THRESHOLD 10
#define STAR_MIN_PIXEL 3
#define STAR_MAX_PIXEL 50
#define LENGTH 1280
#define BREADTH 1024
#define NUM_REGIONS 100
#define NUM_FINAL_TAGS 40
#define NUM_TAGS_PER_REGION 21
#define PIXEL_WIDTH 0.0048
#define NUM_TOT_STARS 100