/* 
 * File:   ResizeAndCropTester.hpp
 * Author: asia
 *
 * Created on 8 styczeń 2016, 20:12
 */

#ifndef RESIZEANDCROPTESTER_HPP
#define	RESIZEANDCROPTESTER_HPP

#include "ImageLibrary.hpp"

#include "FileByFileTester.hpp"

class ResizeAndCropTester : public FileByFileTester {
public:
    ResizeAndCropTester(const char* programName, CropDataPercent cropData, int scale)
        : FileByFileTester(programName)
        , cropData(cropData)
        , scale(scale)
    {
    }
    ResizeAndCropTester(const ResizeAndCropTester& orig) = delete;
    virtual ~ResizeAndCropTester(){}
protected:

    virtual void runForFile(const char* filename, const char* outfile){
        ImageData* data = library.loadImageFromFile(filename);
        library.scaleDown(*data, scale);
        library.cropImage(*data, cropData);
        library.saveToFile(*data, outfile);
        library.deleteImage(data);
    }
    
private:
    CropDataPercent cropData;
    int scale;
};

#endif	/* RESIZEANDCROPTESTER_HPP */

