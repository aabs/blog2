all: clean build deploy

build:
	hugo --cleanDestinationDir

clean:
	rm -rf public/*
	rm /var/www/html/* -rf

deploy:
	cp -R public/* /var/www/html/
