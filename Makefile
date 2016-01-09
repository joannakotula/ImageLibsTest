TARGET = tester

BUILD_DIR=.bin
SRC_DIR=src
INCLUDE_DIR=include

DEFAULT_FLAGS= -Wall -Wextra -I$(INCLUDE_DIR) -g 
MAGICK_FLAGS=-I/usr/include/ImageMagick/

CXXFLAGS = -std=c++0x -Werror -fno-strict-aliasing 
#-D_LARGEFILE64_SOURCE=1 -D_FILE_OFFSET_BITS=64 

CC = g++
MAGICK_LIBS = -lpthread -lMagick++ -lMagickWand -lMagickCore 
OBJS = $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(wildcard $(SRC_DIR)/*.cpp))

all: $(BUILD_DIR) $(TARGET)
	
$(BUILD_DIR):
	mkdir $(BUILD_DIR)
	
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(INCLUDE_DIR)/%.hpp
	$(CC) -c -o $@ $< $(CXXFLAGS) $(DEFAULT_FLAGS) $(MAGICK_FLAGS)
	
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp 
	$(CC) -c -o $@ $< $(CXXFLAGS) $(DEFAULT_FLAGS) $(MAGICK_FLAGS)

$(TARGET): $(BUILD_DIR) $(OBJS)
	$(CC) $(CXXFLAGS) $(DEFAULT_FLAGS) -o $(TARGET) $(OBJS) $(LIBS) $(MAGICK_LIBS)
	
clean:
	rm -rf $(BUILD_DIR) $(TARGET) || true
