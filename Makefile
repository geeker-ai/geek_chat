VERSION ?= 0.0.1
change-version:
	sed -i -e "s/version: .*/version: $(VERSION)/" pubspec.yaml