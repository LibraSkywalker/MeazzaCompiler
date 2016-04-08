all:
		mkdir -p bin
		cd src/out && make
		javac src/*/*.java src/AST/*/*.java -classpath lib/*.jar -d bin

clean:
		cd src/out && make clean
		rm -rf bin
