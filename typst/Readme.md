# Typst Templates

See [slide_example.typ](slide_example.typ) for an example presentation.

Just remember to change the first line (the import) to the following:

```diff
- #import "sraslides.typ": *
+ #import "texmf/typst/sraslides.typ": *
```

As this is a fork of Polylux, most of its documentation is still helpful ([Polylux book](https://polylux.dev/book/polylux.html)).

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

// Create a speaker note inside a frame
#frame(title: [Test])[
    - Lorem Ipsum...

    ```note
    - Here is a speaker note
    - ...
    ```
]
````

The pdfpc config and notes can be exported with:

```sh
typst query --root . ./slides.typ --field value --one "<pdfpc-file>" > ./slides.pdfpc
```
