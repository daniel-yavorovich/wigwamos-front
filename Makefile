build:
	npm run build
deploy: build
    rsync -av ./dist/ pi@192.168.88.15:/home/pi/wigwamapp/
