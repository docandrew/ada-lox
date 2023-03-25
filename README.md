# Lox Interpreter in Ada

This is an implementation of the Lox interpreter in the Ada programming language,
based on the book "Crafting Interpreters" by Bob Nystrom.

> **Warning**
> I'm updating this repository as I work through the book, so it may be unfinished and may contain bugs or missing features.

## Getting started

To build and run the Lox interpreter, you will need an Ada compiler that supports Ada 2012 or later.
We recommend the use of [Alire](<https://alire.ada.dev/>)

```shell
alr build
```

This will compile the interpreter and create an executable named `lox`.

To run the interpreter, execute the following command:

```shell
alr run
```

or alternatively:

```shell
bin/lox
```

This will start the interpreter, which will display a prompt (`>`) and wait for you to enter Lox code.

## Features

This Lox interpreter will someday support the following features:

- Arithmetic expressions (`+`, `-`, `*`, `/`)
- Comparison expressions (`>`, `<`, `>=`, `<=`, `==`, `!=`)
- Logical expressions (`and`, `or`)
- Variables and assignments (`var` and `=`)
- Control flow statements (`if`, `else`, `while`)
- Functions and closures (`fun` and `return`)
- Classes and inheritance (`class`, `super`, `this`)
- Native functions (`clock`, `print`, `input`)
