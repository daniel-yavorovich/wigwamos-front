build:
	npm run build
deploy:
	rsync -av ./dist/ pi@192.168.88.15:/home/pi/wigwamapp/
