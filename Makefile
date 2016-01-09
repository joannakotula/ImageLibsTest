TARGET = tester

BUILD_DIR=.bin
SRC_DIR=src
INCLUDE_DIR=include

DEFAULT_FLAGS= -Wall -Wextra -I$(INCLUDE_DIR) -g 

CXXFLAGS = -std=c++0x -Werror -fno-strict-aliasing 
#-D_LARGEFILE64_SOURCE=1 -D_FILE_OFFSET_BITS=64 
CC = g++

MAGICK_FLAGS=-I/usr/include/ImageMagick/
MAGICK_LIBS = -lpthread -lMagick++ -lMagickWand -lMagickCore 

OBJS = $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(wildcard $(SRC_DIR)/*.cpp))

all: $(TARGET)-magick
	
$(TARGET)-magick: TARGET_LIBS = $(MAGICK_LIBS)

%-magick.o: TARGET_FLAGS = $(MAGICK_FLAGS)
	
$(BUILD_DIR)/ImageLibrary-%.o: $(SRC_DIR)/%/ImageLibrary.cpp $(INCLUDE_DIR)/ImageLibrary.hpp
	mkdir -p $(BUILD_DIR)
	$(CC) -c -o $@ $< $(CXXFLAGS) $(DEFAULT_FLAGS) $(TARGET_FLAGS)
	
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(INCLUDE_DIR)/%.hpp
	mkdir -p $(BUILD_DIR)
	$(CC) -c -o $@ $< $(CXXFLAGS) $(DEFAULT_FLAGS)
	
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp 
	mkdir -p $(BUILD_DIR)
	$(CC) -c -o $@ $< $(CXXFLAGS) $(DEFAULT_FLAGS)

$(TARGET)-%: $(OBJS) $(BUILD_DIR)/ImageLibrary-%.o
	$(CC) $(CXXFLAGS) $(DEFAULT_FLAGS) -o $@ $^ $(LIBS) $(TARGET_LIBS)
	
clean:
	-rm -rf $(BUILD_DIR) $(TARGET)*
