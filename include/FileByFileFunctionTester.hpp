/* 
 * File:   FileByFileFunctionTester.hpp
 * Author: asia
 *
 * Created on 1 luty 2016, 18:53
 */

#ifndef FILEBYFILEFUNCTIONTESTER_HPP
#define	FILEBYFILEFUNCTIONTESTER_HPP

#include "FileByFileTester.hpp"

class FileByFileFunctionTester : public FileByFileTester {

public:
    FileByFileFunctionTester(const char* programName, void(*runForFileFunction)(const char*, const char*, ImageLibrary&) ) 
        : FileByFileTester(programName)
        , runForFileFunction(runForFileFunction) {
        }

        
    
protected:
    virtual void runForFile(const char* filename, const char* outfile){
        runForFileFunction(filename, outfile, this->library);
    }

private:
    void (*runForFileFunction)(const char*, const char*, ImageLibrary&) ;
    
};

#endif	/* FILEBYFILEFUNCTIONTESTER_HPP */

