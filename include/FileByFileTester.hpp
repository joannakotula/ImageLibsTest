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
    FileByFileTester(const char* programName)
        : Tester(programName)
        {}
    virtual ~FileByFileTester(){}

    virtual void runTests(const char* imagesFolder, const char* outputFolder);

protected:
    virtual void runForFile(const char* filename, const char* outfile) = 0;

private:
    FileByFileTester(const FileByFileTester& orig) = delete;
};

#endif	/* FILEBYFILETESTER_HPP */

