/* 
 * File:   AbstractTester.hpp
 * Author: asia
 *
 * Created on 8 styczeń 2016, 07:20
 */

#ifndef TESTER_HPP
#define	TESTER_HPP

class Tester {
public:
    Tester(){}
        
    Tester(const Tester& orig) = delete;
    
    virtual ~Tester(){}
    
    virtual void runTests(std::string imagesFolder) = 0;
};

#endif	/* TESTER_HPP */

