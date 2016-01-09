/* 
 * File:   ImageLibrary.cpp
 * Author: asia
 * 
 * Created on 8 styczeń 2016, 20:46
 */

#include "ImageLibrary.hpp"

#include <Magick++.h> 

class ImageData {
public:
    Magick::Image image;
};

void ImageLibrary::init(const char* programName) {
    Magick::InitializeMagick(programName);
}

ImageData* ImageLibrary::loadImageFromFile(const char* filename) {
    ImageData* data = new ImageData();
    data->image.read(filename);
    return data;
}

void ImageLibrary::cropImage(ImageData& data, CropDataPercent crop) {
    Magick::Geometry g(crop.width, crop.height, crop.offX, crop.offY);
    g.percent(true);
    data.image.crop(g);
}

void ImageLibrary::scaleDown(ImageData& data, int scale) {
    size_t newSizeInPercent = 100/scale;
    Magick::Geometry g(newSizeInPercent, newSizeInPercent);
    g.percent(true);
    data.image.scale(g);
}

void ImageLibrary::deleteImage(ImageData* data) {
    delete data;
}

void ImageLibrary::saveToFile(ImageData& data, const char* outputfile) {
    data.image.write(outputfile);
}


void ImageLibrary::close() {
}




