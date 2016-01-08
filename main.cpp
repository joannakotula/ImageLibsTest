/* 
 * File:   main.cpp
 * Author: asia
 *
 * Created on 7 styczeń 2016, 07:50
 */

#include <cstdlib>
#include <stdio.h>

#include "FileByFileTester.hpp"

using namespace std;


/*
 * 
 */
int main(int argc, char** argv) {
    if(argc < 2){
        printf("usage: %s <path to images> [<outputpath> = out]\n", argv[0]);
        return 1;
    }
    FileByFileTester* tester = new FileByFileTester();
    
    tester->runTests(argv[1]);
    
    delete tester;
    return 0;
}

