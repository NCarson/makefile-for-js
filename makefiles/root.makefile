#FIXME: use $(MAKE) instead of cd src && make
all:
	cd src && make

clean:
	cd src && make clean

docs:
	cd src && make docs

commit-doc:
	git add docs README.md
	git commit -m "updated doc"
	git push

publish:
	cd src && make clean
	cd src && PRODUCTION=1 make
	cd src && make docs
	npm version patch
	npm publish
	git push --tags
