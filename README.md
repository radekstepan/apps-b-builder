#apps-b-builder

A [component.io](https://github.com/component/component) based builder for making JS packages.

##Quick Start

```bash
$ sudo npm install apps-b-builder -g
```

Then specify the input and output path to build:

```bash
# relative to current working directory
$ apps-b build ./src/ ./build/
```

If you wish to serve a particular directory (an example):

```bash
# relative to current working directory
$ apps-b serve ./example
```