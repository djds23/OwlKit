OwlKit is a library for reading the data of the semantic web.

Currently this library only supports reading Open Graph protocol from web pages. A goal for this library is to at some point support OpenGraph, MicroData, RDFa and possibly JSON-LD.

Future design goals:

A tool for defining strong types you can query a page for. Currently you essentially ask for a website and get back a dictionary which the programmer must then try their best to make sense of. This includes a lot of optional checking and querying for keys. 

Ideally an HTML document could be validated gainst a known type like a social card for open graph or the many specific types offered by https://schema.org. 

This way a programmer could do something like (HTMLDocument) -> SocialCard?, simplifying the entire process. We could bake a couple of these into the library, but ideally we vend a tool similar to "SemanticWebDecodable" where a programmer can define their own struct:

```
@SemanticWebDecodable
struct Card {
    var title: String
    var description: String?
    var image: URL?
    var imageAltText: String?
}
```

and the library provides a nice function to validate this from the document. We would do the work of matching the property names from the struct to the keys extracted from the document, and pull out the correct type from the URL.