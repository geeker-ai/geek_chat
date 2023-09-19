VERSION ?= 0.0.1
change-version:
	sed -i -e "s/version: .*/version: $(VERSION)/" pubspec.yaml

CHANNEL ?= dev
change-channel:
	sed -i -e "s/CHANNEL=.*/CHANNEL=$(CHANNEL)/" .env