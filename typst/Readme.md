# Typst Templates

See [example.typ](example.typ) for a presentation and
[example-lecture.typ](example-lecture.typ) for a lecture using `sra-lecture-theme`.

Just remember to change the first line (the import) to the following:

```diff
- #import "sraslides.typ": *
+ #import "texmf/typst/sraslides.typ": *
```

This theme is based on [touying](https://touying-typ.github.io/), so take a look into their documentation.


## Migration from our [Legacy](legacy) Polylux Fork

- Touying uses the `#slide` function (instead of `#frame`) and level 2 headings to create slides
- Sections are created with level 1 headings
- Section outlines can be created with `#outline(title: none, depth: 1)`


## PDFPC

You can create pdfpc notes and change settings inside your typst slides.

````typ
// configure pdfpc at the beginning of your slides
#pdfpc.config(
  duration-minutes: 20,
  start-time: none,
  end-time: none,
  last-minutes: none,
  note-font-size: none,
  disable-markdown: false,
  default-transition: none,
)

// Create a speaker note inside a slide
== Test

- Lorem Ipsum...

```note
- Here is a speaker note
- ...
```
````

The pdfpc config and notes can be exported with:

```sh
typst query --root . ./slides.typ --field value --one "<pdfpc-file>" > ./slides.pdfpc
```

## Example Makefile

```Makefile
F=slides
TYPST = typst

all: $(F).pdf $(F).pdfpc
.PHONY: all clean
.DEFAULT: all

$(F).pdf: $(F).typ
	$(TYPST) compile $(F).typ

$(F).pdfpc: $(F).typ
	$(TYPST) query --root . $(F).typ --field value --one "<pdfpc-file>" > $(F).pdfpc

clean:
	rm -f $(F).pdf $(F).pdfpc
```

## [Slidepilot](https://slidepilot.gitbook.io/slidepilot)

You can also export the pdfpc speaker notes to slidepilot.
This presenter runs a bit better on macos.

```sh
typst query --root . ./slides.typ --field value --one "<slidepilot-file>" | xargs printf '%b' > ./slides-notes.rtf
```
