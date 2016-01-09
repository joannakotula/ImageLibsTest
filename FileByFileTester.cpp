/* 
 * File:   FileByFileTester.cpp
 * Author: asia
 * 
 * Created on 8 styczeń 2016, 07:35
 */

#include <dirent.h>
#include <stdlib.h>
#include <stdio.h>

#include "FileByFileTester.hpp"

void FileByFileTester::runTests(const char* imagesFolder) {
    DIR *dir;
    struct dirent *ent;
    if ((dir = opendir(imagesFolder)) != NULL) {
        /* print all the files and directories within directory */
        while ((ent = readdir(dir)) != NULL) {
            if(ent->d_type == DT_REG){
                this->runForFile(ent->d_name);
            }
        }
        closedir(dir);
    } else {
        /* could not open directory */
        perror("could not open directory");
    }
}

