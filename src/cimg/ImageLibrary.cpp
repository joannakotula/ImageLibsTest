/* 
 * File:   ImageLibrary.cpp
 * Author: asia
 * 
 * Created on 8 styczeń 2016, 20:46
 */

#include "ImageLibrary.hpp"
#include "CImg.h" 

using namespace cimg_library; 


class ImageData {
public:
    ImageData(const char* filename)
            : image(filename)
            {}
            
    ImageData(const CImg<unsigned char> image)
            : image(image)
            {}
            
    CImg<unsigned char> image;
};

void ImageLibrary::init(const char* ) {
}

ImageData* ImageLibrary::loadImageFromFile(const char* filename) {
    ImageData* data = new ImageData(filename);
    return data;
}

void ImageLibrary::cropImage(ImageData& data, CropDataPercent crop) {
    int currentHeight = data.image.height();
    int currentWidth = data.image.width();
    
    int xStart = currentWidth * crop.offX / 100;
    int yStart = currentHeight * crop.offY / 100;
    int xStop = xStart + (currentWidth * crop.width / 100);
    int yStop = yStart + (currentHeight * crop.height / 100);
    data.image.crop(xStart, yStart, xStop, yStop);
}

void ImageLibrary::scaleDown(ImageData& data, int scale) {
    size_t newSizeInPercent = 100/scale;
    data.image.resize(-newSizeInPercent, -newSizeInPercent);
}

void ImageLibrary::deleteImage(ImageData* data) {
    delete data;
}

void ImageLibrary::saveToFile(ImageData& data, const char* outputfile) {
    data.image.save(outputfile);
}

ImageData* ImageLibrary::copy(const ImageData& data){
    return new ImageData(data.image);
}

void ImageLibrary::close() {
}




