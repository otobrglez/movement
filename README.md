# movement

Little script that I used to make nice vizualisation of my tracks.

- [Oto Brglez](https://github.com/otobrglez)

## Requirements

- gnuplot - With Homebrew install with `brew install gnuplot`.

## Usage

1. Build folder of `tcx` files.

```bash
INPUT_FOLDER=~/Dropbox/Apps/RunGap/export OUTPUT_FOLDER=tmp ./bin/unzip-rungap.sh
```

2. Run visualizer script and wait a bit.

```bash
INPUT_FOLDER=tmp ./bin/visualizer.rb
```

3. Marge all images.

```bash
./bin/make_images.sh
```

4. Love the output <3

![out-montage](out-montage.jpg)
