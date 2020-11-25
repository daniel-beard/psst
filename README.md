# psst
PaSteboard String Tool - Julia based string transform tool, using Julia's Meta.parse.

E.g. 

```bash
$ echo "hello world" | psst 'spongebob'
hElLo wOrLd
```

```bash
$ echo "one two three four" | psst 'words |> take(2)'        
"one", "two"
```

Validate JSON

```bash
$ psst 'parseJSON |> pp'
{
  "an_array": [
    "string",
    9
  ],
  "a_number": 5.0
}
nothing
```

URLs

Examples assume `"http://test.com?foo=bar&anotherParam=baz"` is in the pasteboard.

```bash
# Check if valid
$ psst 'parseURL |> isValid'
# Extract query param
$ psst 'parseURL |> queryParams |> get("anotherParam")'
baz
```
