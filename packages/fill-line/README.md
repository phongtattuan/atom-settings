# Fill Line package

Fill the current line to match the length of the line above. Useful for Markdown or RST headers.

```
Welcome to the Jungle   =>   Welcome to the Jungle
=|                      =>   =====================|
```


The current line will be repeated to match the length of the line above, so you can do fun patterns (although this doesn't mean anything in MD or RST).

```
Welcome to the Jungle   =>   Welcome to the Jungle
=-~*|                   =>   =-~*=-~*=-~*=-~*=-~*=|
```

Nothing happens if the line above is empty or shorter than the current line.

The default hotkey is `ctrl-$`, like the end-of-line character in a regular expression.
