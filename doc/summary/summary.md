### [< Back](/README.md) to README File

# Code Organization and File Structure

Code is organized under the following major files and directories:

```text

├── docs: Documentation.
|     └──  design
|            ├── design.md: Locate the design.
|            └── 3D print: Versions of Print for Smart Planter STL Files
|    └── documents: documentation for us.
|           ├── overleaf.md: documentation for Overleaf
|           └── pdfs : Recent PDF format for all Overleaf.
|               ├── ADS.pdf: Architecture Design Specification documentation.
|               ├── PC.pdf: Project Charter documentation.
|               └── SRS.pdf: System Requirement Specification documentation.
|    └── summary: summary for application
|       └── summary.md: Understand the file structure.
|
├── src: Source Code goes here
|    ├── plantsways_iot: IoT Source Code.
|    └── plantsways_app: Flutter Application Source Code.
|
├── CITATION: Developer Site
|
├── CONTRIBUTION: Developer Guide
|
├── LICENSE: BSD 3-Clause License
|
├── README: Overview page for Smart Planter: PlantWays
|
└── ... developer files (vscode, git, idea, etc)
```

## Code Style

Code (mostly) adheres to [Flutter Guide](https://docs.flutter.dev/):

- camelCase is used for variable names and modularized css classes
- `const` instead of `var` or `let` is employed wherever possible
- jsdoc comments are / should be included for each function/class/etc.

While no hard formatting rules are enforced, eg, indentation level, tab vs. space, max length, etc., the code is formatted in a way that is easy to read and modify.
