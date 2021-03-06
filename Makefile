.PHONY: help clean doc docall lint test dist release

help:
	@echo "clean    remove non-source files"
	@echo "doc      generate Sphinx HTML documentation, including API doc"
	@echo "docall   generate HTML documentation, check links"
	@echo "lint     check style with flake8"
	@echo "test     run tests and check code coverage"
	@echo "dist     package"
	@echo "release  package and upload a release"

clean:
	# Python files.
	find . -name '__pycache__' -exec rm -rf {} +
	# Documentation.
	rm -rf doc/_build
	# Coverage.
	rm -rf .coverage
	rm -rf htmlcov
	# Package build.
	rm -rf build
	rm -rf dist
	rm -rf *.egg-info

doc:
	sphinx-build -b html -d doc/_build/doctrees doc doc/_build/html

docall: doc
	# sphinx-build -b latex -d doc/_build/doctrees doc doc/_build/latex
	# $(MAKE) -C doc/_build/latex all-pdf > doc/_build/latex/pdflatex.log
	sphinx-build -b linkcheck -d doc/_build/doctrees doc doc/_build/linkcheck

lint:
	flake8 --doctests --exclude=doc

test:
	coverage run --branch --source pyunlocbox setup.py test
	coverage report
	coverage html

dist: clean
	python setup.py sdist
	python setup.py bdist_wheel --universal
	ls -l dist

release: dist
	twine upload dist/*
