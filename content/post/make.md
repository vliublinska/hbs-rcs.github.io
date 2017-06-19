---
author: Andrew Marder
title: Tips on How to Use Make
tags:
  - programming
draft: true
---

If you're new to Make, please read Mike Bostock's article [Why Use Make](https://bost.ocks.org/mike/make/), it's excellent! This post is intended as a follow-up to Mike's introduction.

I love Makefiles because they allow me to describe my workflow as a directed acyclic graph. Makefiles are a great example of [declarative programming](https://en.wikipedia.org/wiki/Declarative_programming). When I specify a rule like the following:

```
targetfile: sourcefile
	command
```

I am saying that the `targetfile` depends on the `sourcefile`. Whenever I issue the command `make targetfile`, Make checks to see if anything in the `targetfile`'s dependency graph needs to be recompiled and it runs the necessary commands to bring the `targetfile` up to date. I enjoy using Make because it provides:

1.  A framework for writing reproducible research.
2.  A transparent caching mechanism. Often downloading data can take a lot of time, while cleaning data once it's downloaded is relatively fast. By breaking these into two rules. I only need to download the data once and then I can focus on data cleaning and data analysis without re-running code from previous steps.
3.  A mechanism for building projects in parallel. Using `make -j` of `lsmake` tells Make to run in parallel. All I have to specify is how each file in my project is built, Make figures out how to run everything in parallel.


# Makefiles as Glue

I often find myself wanting to use different tools for different jobs. I like using Python for web scraping, R for data visualization, and Stata for certain statistical models. Makefiles make it easy to combine different tools:

```makefile
DATA = data/processed/data.csv

$(DATA): src/download.py
	python $<

reports/figures/graph.pdf: src/graph.R $(DATA)
	Rscript $<

reports/figures/table.tex: src/table.do $(DATA)
	stata-mp -b do $<
```


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

DO_FILES = $(shell find . -name "*.do")
LOG_FILES = $(patsubst %.do,%.log,$(DO_FILES))

tables: $(LOG_FILES)
```


# Working with Databases

```makefile
data/processed/patents.table: src/patents.py
	python $<
	echo "Data stored in PostgreSQL databases." > $@
```


# Conclusion

There are alternatives, like [Waf](https://github.com/waf-project/waf). For more on how I structure my projects, see [Cookiecutter Data Science](https://drivendata.github.io/cookiecutter-data-science/).
