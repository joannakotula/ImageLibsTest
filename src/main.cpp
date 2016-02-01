/* 
 * File:   main.cpp
 * Author: asia
 *
 * Created on 7 styczeń 2016, 07:50
 */

#include <assert.h>
#include <cstdlib>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <algorithm>

#include "FileByFileFunctionTester.hpp"


using namespace std;

const int splitCount = 3;

CropDataPercent createCropDataForSplit(int x, int y){
    assert(x < splitCount);
    assert(y < splitCount);
    const int splitContentSize = 100/splitCount;
    const int buffor = splitContentSize/5;
    const int normalSplitSize = splitContentSize + 2*buffor;
    const int edgeSplitSize = splitContentSize + buffor;
    
    CropDataPercent cropData;
    cropData.width = (x == 0 || x == splitCount - 1 ? edgeSplitSize : normalSplitSize);
    cropData.height = (y == 0 || y == splitCount - 1 ? edgeSplitSize : normalSplitSize);
    cropData.offX = std::max(0, x * splitContentSize - buffor);
    cropData.offY = std::max(0, y * splitContentSize - buffor);
    return cropData;
}

#ifdef PRINT_IMAGES
#include <string.h>
#include <sstream>

char* addSuffixToFilename(const char* filename, const char* suffix){
    size_t filenameLen = strlen(filename);
    size_t suffixLen = strlen(suffix);
    const char* extension = strstr(filename, ".jpg");
    size_t filenameBaseLen = (extension - filename);
    char* newFilename = (char*) malloc(filenameLen + suffixLen + 1);
    strncpy(newFilename, filename, filenameBaseLen);
    newFilename[filenameBaseLen] = 0; 
    strcat(newFilename, suffix);
    strcat(newFilename, extension);
    return newFilename;
}

char* getOutputFilename(const char* output, int x, int y){
    ostringstream ss;
    ss << "_" << x << "_" << y;
    return addSuffixToFilename(output, ss.str().c_str());
}

#endif

void runForFile(const char* filename, const char* output, ImageLibrary& library){
    ImageData* data = library.loadImageFromFile(filename);
    for(int x = 0; x < splitCount; x++){
        for(int y = 0; y < splitCount; y++){
    
            ImageData* copy = library.copy(*data);
            library.scaleDown(*copy, 2);
            library.cropImage(*copy, createCropDataForSplit(x, y));
            
#ifdef PRINT_IMAGES
            library.saveToFile(*copy, getOutputFilename(output, x, y));
#else
            (void) output;
#endif                  
            
            library.deleteImage(copy);
        }
    }
    library.deleteImage(data);
}

/*
 * 
 */
int main(int argc, char** argv) {
    if(argc < 2){
        printf("usage: %s <path to images> [<outputpath> = out]\n", argv[0]);
        return 1;
    }
    FileByFileFunctionTester* tester = new FileByFileFunctionTester(argv[0], runForFile);
    
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

