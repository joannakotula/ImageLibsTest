/* 
 * File:   AbstractTester.hpp
 * Author: asia
 *
 * Created on 8 styczeń 2016, 07:20
 */

#ifndef TESTER_HPP
#define	TESTER_HPP

#include "ImageLibrary.hpp"

class Tester {
public:
    Tester(const char* programName)
        : library(programName)
        {}
    
    virtual ~Tester(){}
    virtual void runTests(const char* imagesFolder) = 0;

private:
    Tester(const Tester& orig) = delete;
    
protected:
    ImageLibrary library;
};

#endif	/* TESTER_HPP */

