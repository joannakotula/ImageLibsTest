#include <opencv2/core/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>

#include "ImageLibrary.hpp"

class ImageData {
public:
    cv::Mat image;
};

void ImageLibrary::init(const char*) {
}

ImageData* ImageLibrary::loadImageFromFile(const char* filename) {
    ImageData* data = new ImageData();
    data->image = cv::imread(filename, cv::IMREAD_COLOR); // Read the file
    return data;
}

void ImageLibrary::cropImage(ImageData& data, CropDataPercent crop) {
    int currentWidth = data.image.size().width;
    int currentHeight = data.image.size().height;
    cv::Rect rect;
    rect.x = crop.offX * currentWidth/100;
    rect.y = crop.offY * currentHeight/100;
    rect.width = crop.width * currentWidth/100;
    rect.height = crop.height * currentHeight/100;
    cv::Mat cropped = data.image(rect);
    data.image = cropped;
}

void ImageLibrary::scaleDown(ImageData& data, int scale) {
    cv::Mat oldImage = data.image;
    data.image = cv::Mat();
    double fscale = 1.0/scale;
    cv::resize(oldImage, data.image, cv::Size(0, 0), fscale, fscale);
}

void ImageLibrary::deleteImage(ImageData* data) {
    delete data;
}

void ImageLibrary::saveToFile(ImageData& data, const char* outputfile) {
    cv::imwrite(outputfile, data.image);
}

ImageData* ImageLibrary::copy(const ImageData& data){
    ImageData* copy = new ImageData();
    copy->image = data.image;
    return copy;
}

void ImageLibrary::close() {
}


