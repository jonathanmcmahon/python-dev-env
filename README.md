# README #

> "I'm not much but I'm all I have." *&mdash; Philip K. Dick*

### What is this repository for? ###

This repository is to assist a new Python developer in getting set up and pointed in the right direction with a dev environment and basic development workflow.


### Writing good documentation ###

This document is written in [markdown](https://www.markdownguide.org/). It is a lightweight text markup language that many people find ideally suited for documenting lots of things--especially software projects.

To see how this document looks in markdown (before it is rendered by github), [click here](https://github.com/jonathanmcmahon/python-dev-env/raw/unlinted/README.md).

Documentation isn't a nice-to-have, and it should never be done as an afterthought. It is a good idea to try to write it as you go and then it isn't this major task that awaits you to tackle all at once. 

Also, it helps you to remember stuff. See "Automation" below.

### Installing Python ###

Follow [this guide](https://docs.python-guide.org/starting/installation/) to install Python 3 on your system.



### Virtual environments ###


#### virtualenv ####

[Install pip.](https://pip.pypa.io/en/stable/installing/)

Install virtualenv: 

```
$ pip install virtualenv
```

Add this line to `~/.bash_profile`:

```
export PIP_REQUIRE_VIRTUALENV=true
```

https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/


#### pyenv with pyenv-virtualenv ####

This allows you to maintain separate Python installations (e.g. 3.6, 3.7, 3.8) and to switch easily. The approach it takes is lightweight and elegant, and easy to undo if you need to rip it all out.

[pyenv docs](https://github.com/pyenv/pyenv)

[pyenv-virtualenv plugin](https://github.com/pyenv/pyenv-virtualenv)

##### A quick pyenv tour #####

pyenv creates shims and points those shims at the currently-activated Python installation:

```
$ which python
/Users/Me/.pyenv/shims/python

$ python --version
Python 3.6.7
```

Check which Python installation we are currently using:

```
$ pyenv version 
system (set by /Users/Me/.pyenv/version)
```

Check all locally-installed python versions:

```
$ pyenv versions
* system (set by /Users/Me/.pyenv/version)
  3.5.7
```

Install a new Python version, v3.8.3:

```
$ pyenv install 3.8.3
python-build: use openssl@1.1 from homebrew
python-build: use readline from homebrew
Downloading Python-3.8.3.tar.xz...
-> https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tar.xz
Installing Python-3.8.3...
python-build: use readline from homebrew
python-build: use zlib from xcode sdk
Installed Python-3.8.3 to /Users/Me/.pyenv/versions/3.8.3
```

Create a new virtualenv using Python 3.8.3:

```
$ pyenv virtualenv 3.8.3 my-virtual-env-3.8.3
Looking in links: /var/folders/2b/yhg7v3mzcc62s5mm5mjm00gq/T/tmpmq7q6no
Requirement already satisfied: setuptools in /Users/Me/.pyenv/versions/3.8.3/envs/my-virtual-env-3.8.3/lib/python3.8/site-packages (41.2.0)
Requirement already satisfied: pip in /Users/Me/.pyenv/versions/3.8.3/envs/my-virtual-env-3.8.3/lib/python3.8/site-packages (19.2.3)
```

We created the virtualenv but note that it isn't activated yet:

```
$ python --version
Python 3.6.7
```

Set the current folder to use this virtualenv:

```
$ pyenv local my-virtual-env-3.8.3
```

Now we see we are pointed at the new Python version:

```
$ python --version
Python 3.8.3
```

pyenv drops a file into the current directory with the virtualenv name:

```
$ cat .python-version
my-virtual-env-3.8.3
```

### Pick an IDE ###

Some great choices for Python:

- [Visual Studio Code](https://code.visualstudio.com/) (make sure you install the [Python extension](https://code.visualstudio.com/docs/languages/python))
  - Free
  - Cross-platform (Linux, MacOS, Windows)
  - At one time a runner-up to PyCharm, vscode now boasts rich Python support and beyond that a fabulous ecosystem of extensions for virtually everything
- [PyCharm](https://www.jetbrains.com/pycharm/)
  - Free community version ([see here](https://www.jetbrains.com/pycharm/features/editions_comparison_matrix.html))
  - Cross-platform (Linux, MacOS, Windows)
- [vim](https://realpython.com/vim-and-python-a-match-made-in-heaven/)
  - Free
  - Found on virtually any *nix box
  - super hip?
- [JupyterLab](https://jupyterlab.readthedocs.io/en/stable/)
  - Free
  - Cross-platform
  - Good for data science / data munging
  - Not great for debugging


### Automation ###

The more that you can automate your dev workflow, the better results you will achieve for multiple reasons.

Automation...

- is a form of functional documentation
- provides consistency in execution 
- allows iterative refinement
- saves time 
- minimizes cognitive overhead
- is portable to other projects

How you achieve this automation is largely up to you. My personal bias is for tools that are commonly found on Linux systems and tools that I know well.

I am a big fan of writing shell scripts and stitching things together with a Makefile. This is probably because I have a long history of working on *nix systems. Do what works for you and your team, but keep it simple. Baroque things tend to break more easily. 

Here is a sample [Makefile](Makefile) for this project.

**More resources:**

[Makefile Tutorial](https://makefiletutorial.com/)

[Makefile for Docker builds](https://jmkhael.io/makefiles-for-your-dockerfiles/)

[Makefile for Ansible](https://dreisbach.us/articles/simple-ansible-makefile/)


### Code formatting with black ###

[black docs](https://black.readthedocs.io/)

Set up [editor integration](https://black.readthedocs.io/en/stable/editor_integration.html) so that the formatter is automatically run on files on every save. 

[See this Makefile target](Makefile):

```
make format-code
```


### Linting with pylint ###

[pylint docs](http://pylint.pycqa.org/)


[See this Makefile target](Makefile):

```
make lint-code
```


### Docstring linting ###

[PEP257 -- Docstring Conventions](https://www.python.org/dev/peps/pep-0257/)

[See this Makefile target](Makefile):

```
make lint-docstring
```


### Testing with pytest ###

[pytest docs](https://docs.pytest.org/en/latest/)

[See this Makefile target](Makefile):

```
make test
```

Use [pytest fixtures](https://docs.pytest.org/en/latest/fixture.html#fixture) to initialize test functions by setting up services, state, or other environment configuration.

### Checking code coverage ###

[See this Makefile target](Makefile):

```
make coverage
```

Note: You must run `make test` first to generate the coverage analysis.

### General thoughts ###

#### Simplicity ####

```
>>> import this
```

#### Readability over cleverness ####

```
fizzbuzz = [
    f'fizzbuzz {n}' if n % 3 == 0 and n % 5 == 0
    else f'fizz {n}' if n % 3 == 0
    else f'buzz {n}' if n % 5 == 0
    else n
    for n in range(100)
]
```

#### Automation ####

Use this as a force multiplier and to increase the reliability and precision of each part of your development workflow.

#### Documentation ####

It's not optional.

Do it as you go. Document modules, classes, and functions as you create them. The project should always have an up-to-date README with all the info a new dev needs to jump into the project and get an application stack running without any other assistance.

#### Understand logging and monitoring ####

Good logging and enabling application monitoring is part of our job as software engineers. This can really set you and the systems you help to build apart from the rest of the crowd. Educate yourself on these topics. Don't automatically settle for the way you see things being done; there's almost certainly a better way.

Like a lot of these general recommendations, this could be an entire workshop in and of itself. To get you thinking about the possibilities, [listen to this talk by consummate engineer Kelsey Hightower](https://vimeo.com/173610242).

[The Twelve-Factor App: Logs](https://12factor.net/logs)

#### Build a toolkit ####

Maintain a personal toolkit that contains functions, code snippets, examples, etc. that you find yourself using again and again in a variety of different tasks and jobs.

#### Make your dev environment portable ####

Maintain the configs for your dev environment (e.g. vscode config file, vim config) in VCS or something that allows to quickly and easily land on a brand new box and have a working dev environment that is customized to your preferences.

#### Read good code ####

It is critical for one's development as a programmer to read good code written by many different people. Set aside time each day to read through some code for projects that are good examples of Python. There are suggestions in the guide below for some projects; reading through the Python standard library is also a great idea. 

#### Hitchhiker's Guide to Python ####

A lot of the advice here is echoed in [this guide](https://docs.python-guide.org/), likely because I originally learned a lot of this stuff there. Read the whole thing. The part on organizing code is especially useful early on in your Python career.
