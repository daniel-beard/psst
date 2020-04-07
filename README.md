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


