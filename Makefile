TARGET = tester

DEFAULT_FLAGS= -Wall -Wextra -Iinclude -g 
MAGICK_FLAGS=-I/usr/include/ImageMagick/

CXXFLAGS = -std=c++0x -Werror -fno-strict-aliasing 
#-D_LARGEFILE64_SOURCE=1 -D_FILE_OFFSET_BITS=64 

BIN_DIR = .bin/
CC = g++
MAGICK_LIBS = -lpthread -lMagick++ -lMagickWand -lMagickCore 
OBJS = $(patsubst %.cpp,%.o,$(wildcard *.cpp))

all: $(TARGET)
	
%.o: %.cpp %.hpp
	$(CC) -c -o $@ $< $(CXXFLAGS) $(DEFAULT_FLAGS) $(MAGICK_FLAGS)
	
%.o: %.cpp 
	$(CC) -c -o $@ $< $(CXXFLAGS) $(DEFAULT_FLAGS) $(MAGICK_FLAGS)

$(TARGET): $(OBJS)
	$(CC) $(CXXFLAGS) $(DEFAULT_FLAGS) -o $(TARGET) $(OBJS) $(LIBS) $(MAGICK_LIBS)
	
clean:
	rm *.o $(TARGET) || true
