# AI Coding Agent Instructions for Writing Repository

## Project Overview
This repository contains fanfiction and creative writing projects using a Markdown-based system. Stories are organized hierarchically and compiled to EPUB/HTML using Pandoc.

## Architecture
- **Stories**: Top-level folders (e.g., `Begin Again/`, `Deliverer of Destiny (BOTW)/`)
- **Chapters**: `Chapters/` folder with `Part X/` subfolders (for multi-part stories)
- **Chapter Structure**: Each chapter is a folder named `NN Title/` containing numbered scene files (`1 Scene.md`, `2 Scene.md`, etc.)
- **Metadata**: `Resources/metadata.yaml` contains Pandoc metadata (title, author, abstract)
- **Compilation**: `Compiled/` folder holds output files (`.epub`, `.html`)

## Build System
- **Primary Tool**: `compile.ps1` (PowerShell script) in each story folder
- **Process**: Recursively collects all `.md` files in specified path, concatenates with double newlines, runs Pandoc
- **Config**: Uses `../pandoc.yaml` for defaults (markdown extensions, TOC, numbering)
- **Commands**:
  - Full story: `.\compile.ps1`
  - Specific part: `.\compile.ps1 -Part 1`
  - Single chapter: `.\compile.ps1 -Part 1 -ChapterNumber 1`
  - Output formats: `-ePub`, `-HTML` (default), or `-Format pdf`
- **On Linux**: Use `pwsh` instead of `powershell`

## Key Patterns
- **File Naming**: Scenes use `N Title.md` format (e.g., `1 The Encounter.md`)
- **Headers**: Use `## Chapter Title` for chapters, `### Scene Title` for scenes
- **Markdown Extensions**: `line_blocks`, `multiline_tables` enabled via Pandoc
- **Content Flow**: Files concatenated in filesystem order (directory then name sort)

## Tools & Scripts
- **markov_chain_generator.py**: Generates creative writing prompts using Markov chains from existing `.md` files
  - Run: `python markov_chain_generator.py`
  - Analyzes all Markdown in workspace for token patterns

## Dependencies
- Pandoc (for compilation)
- PowerShell/pwsh (for build scripts)
- Python 3 (for Markov generator)

## Conventions
- All writing content in Markdown files only
- No code changes affect story content directly
- Compilation handles formatting, TOC, and metadata injection
- Resources folder for story-specific assets and notes

## Example Workflow
1. Edit scene files in `Chapters/Part X/NN Title/`
2. Run `pwsh compile.ps1 -Part X` to build specific part
3. Check `Compiled/` for output files
4. Use Markov generator for inspiration: `python ../markov_chain_generator.py`