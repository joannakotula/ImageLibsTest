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
    char buffer[512];
    if ((dir = opendir(imagesFolder)) != NULL) {
        /* print all the files and directories within directory */
        while ((ent = readdir(dir)) != NULL) {
            if(ent->d_type == DT_REG){
                sprintf(buffer, "%s/%s", imagesFolder, ent->d_name);
                this->runForFile(buffer);
            }
        }
        closedir(dir);
    } else {
        /* could not open directory */
        perror("could not open directory");
    }
}

