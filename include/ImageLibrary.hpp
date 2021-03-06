/* 
 * File:   ImageLibrary.hpp
 * Author: asia
 *
 * Created on 8 styczeń 2016, 20:46
 */

#ifndef IMAGELIBRARY_HPP
#define	IMAGELIBRARY_HPP

class ImageData;

struct CropDataPercent {
    int width, height;
    int offX, offY;

    CropDataPercent() = default;
    CropDataPercent(int width, int height, int offX, int offY) 
        : width(width)
        , height(height)
        , offX(offX)
        , offY(offY) 
    {}

};

class ImageLibrary {
public:
    ImageLibrary(const char* programName){
        init(programName);
    };
    ImageLibrary(const ImageLibrary& orig) = delete;
    virtual ~ImageLibrary(){
        close();
    };
    
    ImageData* loadImageFromFile(const char* filename);
    ImageData* copy(const ImageData& data);
    void cropImage(ImageData&, CropDataPercent);
    void scaleDown(ImageData&, int scale);
    void saveToFile(ImageData&, const char* outputfile);
    void deleteImage(ImageData*);
private:
    void init(const char* programName);
    void close();
};

#endif	/* IMAGELIBRARY_HPP */

