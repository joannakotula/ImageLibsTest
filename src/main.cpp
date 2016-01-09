/* 
 * File:   main.cpp
 * Author: asia
 *
 * Created on 7 styczeń 2016, 07:50
 */

#include <cstdlib>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "FileByFileTester.hpp"
#include "ResizeAndCropTester.hpp"

using namespace std;


/*
 * 
 */
int main(int argc, char** argv) {
    if(argc < 2){
        printf("usage: %s <path to images> [<outputpath> = out]\n", argv[0]);
        return 1;
    }
    CropDataPercent cropData(50, 50, 25, 25);
    ResizeAndCropTester* tester = new ResizeAndCropTester(argv[0], cropData, 2);
    
    const char* output = argc > 2 ? argv[2] : "out";
    
    int status = mkdir(output, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    if(status && status != -1){
        perror("can't create output folder\n");
        return status;
    }
    
    tester->runTests(argv[1], output);
    
    delete tester;
    return 0;
}

