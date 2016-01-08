/* 
 * File:   FileByFileTester.hpp
 * Author: asia
 *
 * Created on 8 styczeń 2016, 07:35
 */

#ifndef FILEBYFILETESTER_HPP
#define	FILEBYFILETESTER_HPP

#include "Tester.hpp"

class FileByFileTester : public Tester {
public:
    FileByFileTester(){}
    FileByFileTester(const FileByFileTester& orig) = delete;
    virtual ~FileByFileTester(){}

    virtual void runTests(const char* imagesFolder);

private:

};

#endif	/* FILEBYFILETESTER_HPP */

