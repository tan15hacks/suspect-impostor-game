# Custom Pack File Format

```json
{
  "format": "suspect-custom-pack",
  "version": 1,
  "id": "pack-id",
  "name": "Party Food",
  "language": "en",
  "familySafe": true,
  "colorValue": 4285357563,
  "iconCodePoint": 58378,
  "enabled": true,
  "words": [
    {
      "id": "word-1",
      "word": "Pizza",
      "alternateWord": "Flatbread",
      "enabled": true
    }
  ]
}
```

Plain-text imports use one word per line. Two Similar Words pairs use a vertical bar:

```text
Beach | Swimming Pool
Burger | Sandwich
Teacher | Professor
Bus | Jeepney
```

Blank lines and lines beginning with `#` are ignored. Normalized duplicate words are skipped during plain-text import and reported as critical errors during full validation.
