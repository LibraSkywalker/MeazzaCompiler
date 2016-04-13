all:
		mkdir -p bin
		javac src/*/*.java src/*/*/*.java -cp "antlr-4.5.3-complete.jar" -d bin


clean:
		rm -rf bin
