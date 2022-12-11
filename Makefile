all: clean build deploy

build:
	hugo --cleanDestinationDir

clean:
	rm -rf public/*
	rm -rf /var/www/html/*

deploy:
	cp -R public/* /var/www/html/

save:
	git add -A .
	git commit -m "wip"
	git push
