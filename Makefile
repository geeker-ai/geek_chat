VERSION ?= 0.0.1
change-version:
	sed -i -e "s/version: .*/version: $(VERSION)/" pubspec.yaml
	sed -i -e "s/msix_version: .*/msix_version: $(VERSION).1" windows/packaging/msix/make_config.yaml

CHANNEL ?= dev
change-channel:
	sed -i -e "s/CHANNEL=.*/CHANNEL=$(CHANNEL)/" .env