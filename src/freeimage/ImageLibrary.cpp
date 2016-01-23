/* 
 * File:   ImageLibrary.cpp
 * Author: asia
 * 
 * Created on 8 styczeń 2016, 20:46
 */

#include <FreeImagePlus.h>

#include "ImageLibrary.hpp"


class ImageData {
public:
    fipImage image;
};

void ImageLibrary::init(const char* ) {
}

ImageData* ImageLibrary::loadImageFromFile(const char* filename) {
    ImageData* data = new ImageData();
    data->image.load(filename);
    return data;
}

void ImageLibrary::cropImage(ImageData& data, CropDataPercent crop) {
    unsigned currentHeight = data.image.getHeight();
    unsigned currentWidth = data.image.getWidth();
    
    unsigned xStart = currentWidth * crop.offX / 100;
    unsigned yStart = currentHeight * crop.offY / 100;
    unsigned xStop = xStart + (currentWidth * crop.width / 100);
    unsigned yStop = yStart + (currentHeight * crop.height / 100);
    data.image.crop(xStart, yStart, xStop, yStop);
}

void ImageLibrary::scaleDown(ImageData& data, int scale) {
    unsigned currentHeight = data.image.getHeight();
    unsigned currentWidth = data.image.getWidth();
    
    data.image.rescale(currentWidth/scale, currentHeight/scale, FREE_IMAGE_FILTER::FILTER_BICUBIC);
}

void ImageLibrary::deleteImage(ImageData* data) {
    delete data;
}

void ImageLibrary::saveToFile(ImageData& data, const char* outputfile) {
    data.image.save(outputfile);
}


void ImageLibrary::close() {
}




