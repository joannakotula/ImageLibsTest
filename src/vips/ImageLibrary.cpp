#include <vips/vips8>

#include "ImageLibrary.hpp"


using namespace vips;

class ImageData{
public:
    VImage image;
};


void ImageLibrary::init(const char* programName){
    if( VIPS_INIT(programName) ){
        vips_error_exit( NULL );
    }
}

ImageData* ImageLibrary::loadImageFromFile(const char* filename){
    ImageData* data = new ImageData();
    data->image = VImage::new_from_file(filename);
    return data;
}

void ImageLibrary::cropImage(ImageData& data, CropDataPercent crop){
    int currentWidth = data.image.width();
    int currentHeight = data.image.height();
    int x = crop.offX * currentWidth/100;
    int y = crop.offY * currentHeight/100;
    int width = crop.width * currentWidth/100;
    int height = crop.height * currentHeight/100;
    data.image = data.image.extract_area(x, y, width, height);
}

void ImageLibrary::scaleDown(ImageData& data, int scale){
    data.image = data.image.resize(1./scale);
}

void ImageLibrary::saveToFile(ImageData& data, const char* outputfile){
    data.image.write_to_file(outputfile);
}

void ImageLibrary::deleteImage(ImageData* data){
    delete data;
}

void ImageLibrary::close(){
    
}

