all:
		mkdir -p bin
		cd src/compiler2016/ && make
		javac src/*/*.java src/AST/*/*.java -classpath lib/*.jar -d bin

clean:
		cd src/compiler2016/ && make clean
		rm -rf bin
