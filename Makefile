OUT_DIR := out
BUILD_DIR := build
SRC_DIR := src

MAIN_TEX := main.tex
MAIN_BASE := $(basename $(MAIN_TEX))
PDF_NAME := advma_exercises.pdf

LATEX := pdflatex
LATEX_FLAGS := -halt-on-error -interaction=nonstopmode -file-line-error -output-directory=$(abspath $(BUILD_DIR))
LATEX_COMPILE := $(LATEX) $(LATEX_FLAGS) $(MAIN_TEX)

.PHONY: all build pdf clean

all: pdf

build:
	mkdir -p $(BUILD_DIR) $(OUT_DIR)
	cd $(SRC_DIR) && $(LATEX_COMPILE) && $(LATEX_COMPILE)
	cp $(BUILD_DIR)/$(MAIN_BASE).pdf $(OUT_DIR)/$(PDF_NAME)

pdf: build
	xdg-open "$(OUT_DIR)/$(PDF_NAME)" &

clean:
	rm -rf $(BUILD_DIR) $(OUT_DIR)
