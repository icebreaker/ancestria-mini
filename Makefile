SOURCE 	= `find src/ -type f -print | sort -n | head -1`
TARGET 	= mini.swf
CACHE 	= $(TARGET).cache
FLAGS 	= -incremental=true -static-link-runtime-shared-libraries=true
DEBUG  	= -compiler.debug=true
RM 		= rm -f
CC 		= mxmlc
CMD 	= $(CC) $(SOURCE) -o $(TARGET) $(FLAGS)

all: release

release: 
	$(CMD)

debug:
	$(CMD) $(DEBUG)

clean:
	$(RM) $(TARGET)
	$(RM) $(CACHE)
	
distclean: clean
realclean: clean

.PHONY: all release debug clean distclean realclean
