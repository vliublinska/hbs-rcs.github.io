---
author: Andrew Marder
title: Makefile Tips
slug: make
tags:
  - programming
date: 2017-06-19
---

If you're new to Make, check out Mike Bostock's article [Why Use Make](https://bost.ocks.org/mike/make/), it's excellent! This post is intended as a follow-up to Mike's introduction.

I love Makefiles because they allow me to describe my workflow as a directed acyclic graph. Makefiles are a great example of [declarative programming](https://en.wikipedia.org/wiki/Declarative_programming). When I specify a rule like the following:

```
targetfile: sourcefile
	command
```

I am saying that the `targetfile` depends on the `sourcefile`. Whenever I issue the command `make targetfile`, Make checks to see if anything in the `targetfile`'s dependency graph needs to be recompiled and it runs the necessary commands to bring the `targetfile` up to date. I enjoy using Make because it provides:

1.  A framework for writing reproducible research.
2.  A transparent caching mechanism. Often downloading data can take a lot of time, while cleaning data once it's downloaded is relatively fast. By breaking these into two rules. I only need to download the data once and then I can focus on data cleaning and data analysis without re-running code from previous steps.
3.  A mechanism for building projects in parallel. Using `make -j` (or `lsmake` on the Grid) tells Make to run commands in parallel. All I have to specify is how each file in my project is built, Make figures out how to run everything in parallel.


# Makefiles as Glue

I often find myself using different tools for different jobs. I like using Python for web scraping, R for data visualization, and Stata for certain statistical models. Makefiles make it easy to combine different tools:

```makefile
DATA = data/processed/data.csv

$(DATA): src/download.py
	python $<

reports/figures/graph.pdf: src/graph.R $(DATA)
	Rscript $<

reports/figures/table.tex: src/table.do $(DATA)
	stata-mp -b do $<
```

To understand the syntax above, read about [variables](https://www.gnu.org/software/make/manual/html_node/Using-Variables.html) and [automatic variables](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html).


# Compiling a Bunch of Files at Once

Often the projects I work on require a lot of analyses. Imagine the following directory structure:

```
.
├── Makefile
├── data
│   └── processed
│       └── data.dta
└── src
    └── tables
        ├── table1.do
        ├── table2.do
        └── table3.do
```

Putting the following two rules in my Makefile allows me to recompile all tables with a single `make tables` command:

```makefile
%.log: %.do data/processed/data.dta
	cd $(dir $<); stata-mp -b do $(notdir $<)

DO_FILES = $(shell find src/tables -name "*.do")
LOG_FILES = $(patsubst %.do,%.log,$(DO_FILES))

tables: $(LOG_FILES)
```

To understand the syntax above, read about [pattern rules](https://www.gnu.org/software/make/manual/html_node/Pattern-Rules.html) and [functions](https://www.gnu.org/software/make/manual/html_node/Functions.html).


# Working with Databases

Make cannot inspect when a database table was last modified. Imagine we have a script that updates a table of patent data. We can work this into a Makefile by creating a corresponding file to keep track of when the database table was last updated. A rule like the following will allow Make to keep track of when the patents table was last updated:

```makefile
data/processed/patents.table: src/patents.py
	python $<
	echo "Data stored in PostgreSQL database." > $@
```


# Conclusion

There are a crazy number of alternatives to Make. Here are just a few:

*   [Ant](http://ant.apache.org/)
*   [CMake](https://cmake.org/)
*   [Gradle](https://gradle.org/)
*   [Luigi](https://luigi.readthedocs.io/en/stable/)
*   [Maven](https://maven.apache.org/)
*   [Ninja](https://ninja-build.org/)
*   [Rake](https://ruby.github.io/rake/)
*   [SCons](http://scons.org/)
*   [Waf](https://waf.io/)

For the most part, I've found Make does everything I need it to do. Although the syntax is ugly, I appreciate how it ships with Unix-like operating systems (I find it annoying when I want to install a project and first I have to install the installation tool). That being said, I am very interested to experiment with Luigi (I've heard great things).

If you want to learn more about how I structure my projects, check out [Cookiecutter Data Science](https://drivendata.github.io/cookiecutter-data-science/).
