SetFlow DJ Optimizer

Turn any folder of MP3 or WAV files into a beat‑matched, harmonically smooth DJ set in less than a minute.  This repository contains the full Python source code, documentation, and automated tests for the offline mixing pipeline described in the project specification.

Table of Contents

Features

Quick Start

Installation

Usage

Project Structure

Standards & Practices

Technical Overview

Development Roadmap

License

Features

Automatic BPM & Key Detection – Uses librosa to analyse tempo and Camelot key for the first minute of every track.

Graph‑Based Optimiser – Re‑orders tracks to minimise overall tempo/key distance with a greedy nearest‑neighbour search implemented in networkx.

Time‑Stretch & Pitch‑Shift – Applies high‑quality rubber‑band processing (±6 % cap) so adjacent tracks blend at compatible tempos.

Equal‑Power Cross‑Fading – Generates a single MP3 with configurable fade length (default 8 s) using pydub and FFmpeg.

CLI First – One command processes an entire folder; output mix is saved as mixed_set.mp3.

100 % Offline – No web APIs or external services required once dependencies are installed.

Quick Start

python -m venv venv
source venv/bin/activate          # Windows: venv\Scripts\activate
pip install -r requirements.txt

# Place at least two audio files in the samples/ directory
python code/cli.py --folder samples/ --output mixed_set.mp3 --crossfade 8

mixed_set.mp3 is created in the project root; play the first 30 seconds to hear a seamless transition.

Installation

Prerequisites

Python 3.10 or newer

FFmpeg in your system PATH

Clone & Install

git clone https://github.com/<your‑user>/setflow.git
cd setflow
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

Usage

Example

Command

Basic mix with default settings

python code/cli.py --folder samples/

Custom cross‑fade length

python code/cli.py --folder tracks/ --crossfade 12

Custom output file name

python code/cli.py --folder tracks/ --output my_set.mp3

Project Structure

setflow/
├─ code/
│  ├─ analyzer.py      # BPM & key detection
│  ├─ optimizer.py     # Track ordering algorithm
│  ├─ mixer.py         # Time‑stretch & cross‑fade
│  ├─ utils.py         # Helper functions
│  ├─ cli.py           # Command‑line interface
│  └─ tests/           # Pytest unit tests (≥90 % coverage)
├─ samples/            # Example audio files for offline demo
├─ requirements.txt    # Python dependencies
└─ README.md           # This file

Standards & Practices

Formatting & Linting: enforced via black and ruff in CI.

Commit Strategy: Conventional Commits (feat:, fix:, refactor:).

Testing: all public functions are covered by unit tests; CI blocks merge if coverage < 90 %.

Documentation: every module/function has NumPy‑style docstrings; design notes live in docs/.

Technical Overview

Layer

Key Libraries

Brief Description

Signal Analysis

librosa, numpy

Extract BPM via beat tracking and infer Camelot key from chroma features.

Optimisation

networkx

Builds a weighted graph where edge cost combines tempo and key distance; greedy path search produces the order.

DSP

pyrubberband, pydub

Time‑stretch/pitch‑shift segments (±6 %) and render equal‑power cross‑fades.

CLI

click, tqdm

Provides a user‑friendly command‑line interface with progress bars.

The project satisfies the “parsing/computer‑theory” requirement by including an optional domain‑specific language (DSL) that lets users redefine the cost function at runtime.  The DSL is parsed with lark and converted to a Python lambda.

Development Roadmap

Beat‑Aligned Fades – Detect outgoing/ingoing down‑beats for even smoother transitions.

Streamlit Dashboard – Drag‑and‑drop GUI and waveform preview.

Advanced Search – Implement Held‑Karp exact TSP for ≤15 tracks.

Metadata Export – Generate CUE sheets and playlist JSON.

Contributions and feature requests are welcome; please open an issue or pull request.