# Lekcja 09: nvim-surround -- otaczanie tekstu

> Czas: ~30-45 min | Poziom: Intermediate

## Cel lekcji

Opanowanie pluginu nvim-surround -- jednego z najczesciej uzywanych pluginow Vima. Nauczysz sie
dodawac, zmieniac i usuwac otaczajace znaki (cudzyslow, nawiasy, tagi HTML) w blyskawiczny
sposob. Wszystkie operacje nvim-surround sa powtarzalne komenda `.` (dot repeat).

## Teoria

### Czym jest nvim-surround?

nvim-surround to plugin do manipulacji "otoczenia" tekstu -- cudzyslow, nawiasow, tagow HTML,
nawiasow klamrowych itd. Zamiast recznego przesuwania kursora na poczatek i koniec tekstu,
plugin pozwala na wykonanie operacji jednym ruchem.

Trzy podstawowe operacje:

| Operacja | Skrot | Opis |
|----------|-------|------|
| **Add** | `ys{motion}{char}` | Dodaj otoczenie wokol motion |
| **Change** | `cs{old}{new}` | Zmien otoczenie z jednego na drugie |
| **Delete** | `ds{char}` | Usun otoczenie |

### Add surround: `ys{motion}{char}`

`ys` to operator ("you surround") -- dziala jak `d` czy `c`, czyli laczy sie z dowolnym motion
lub text object:

| Komenda | Opis | Przed | Po |
|---------|------|-------|----|
| `ysiw"` | Otocz word cudzyslow | `hello` | `"hello"` |
| `ysiw)` | Otocz word nawiasami (bez spacji) | `hello` | `(hello)` |
| `ysiw(` | Otocz word nawiasami (ze spacjami) | `hello` | `( hello )` |
| `yss)` | Otocz cala linie nawiasami | `return x + y` | `(return x + y)` |
| `ys2w'` | Otocz 2 slowa apostrofami | `hello world foo` | `'hello world' foo` |
| `ysiW]` | Otocz WORD nawiasem kwadratowym | `data[0]` | `[data[0]]` |
| `ysip"` | Otocz paragraf cudzyslow | (caly paragraf) | `"(caly paragraf)"` |

**Mnemonik**: **y**ou **s**urround **i**nner **w**ord with **"**

> **Twoja konfiguracja**: nvim-surround uzywa domyslnej konfiguracji. Wszystkie komendy
> dzialaja standardowo, a operacje sa powtarzalne przez `.` (dot repeat).

### Roznica miedzy `)` a `(`, `]` a `[`, `}` a `{`

To jedna z najwazniejszych zasad nvim-surround:

| Zamykajacy (bez spacji) | Otwierajacy (ze spacjami) |
|-------------------------|---------------------------|
| `)` -- `(hello)` | `(` -- `( hello )` |
| `]` -- `[hello]` | `[` -- `[ hello ]` |
| `}` -- `{hello}` | `{` -- `{ hello }` |

**Regula**: Zamykajacy nawias = ciasno (bez spacji). Otwierajacy = luzno (ze spacjami wewnatrz).

### Change surround: `cs{old}{new}`

Zmienia otoczenie z jednego typu na inny -- bez dotykania zawartosci:

| Komenda | Opis | Przed | Po |
|---------|------|-------|----|
| `cs"'` | Zmien `"` na `'` | `"hello"` | `'hello'` |
| `cs'` `` ` `` | Zmien `'` na backtick | `'hello'` | `` `hello` `` |
| `cs)(` | Zmien `)` na `(` (dodaj spacje) | `(hello)` | `( hello )` |
| `cs({` | Zmien `(` na `{` | `(hello)` | `{hello}` |
| `cs]}` | Zmien `]` na `}` | `[hello]` | `{hello}` |
| `cst<div>` | Zmien tag na `<div>` | `<span>hello</span>` | `<div>hello</div>` |

**Uwaga**: W `cs` uzywasz znaku **zamykajacego** do identyfikacji starego otoczenia.
`cs"'` znaczy: znajdz najblizsze `"..."` i zmien na `'...'`.

### Delete surround: `ds{char}`

Usuwa otoczenie, zostawiajac zawartosc:

| Komenda | Opis | Przed | Po |
|---------|------|-------|----|
| `ds"` | Usun cudzyslow | `"hello"` | `hello` |
| `ds'` | Usun apostrofy | `'hello'` | `hello` |
| `ds)` | Usun nawiasy | `(hello)` | `hello` |
| `ds]` | Usun nawiasy kwadratowe | `[hello]` | `hello` |
| `ds}` | Usun klamry | `{hello}` | `hello` |
| `dst` | Usun tag HTML | `<b>hello</b>` | `hello` |

### Visual mode surround: `S{char}`

W trybie Visual (po zaznaczeniu tekstu) nacisnij `S` i podaj znak otaczajacy:

1. `viw` -- zaznacz slowo
2. `S"` -- otocz zaznaczenie cudzyslow

| Sekwencja | Opis | Przed | Po |
|-----------|------|-------|----|
| `viwS"` | Zaznacz slowo, otocz `"` | `hello` | `"hello"` |
| `VS)` | Zaznacz linie, otocz `()` | `x + y` | `(x + y)` |
| `vipS}` | Zaznacz paragraf, otocz `{}` | (paragraf) | `{paragraf}` |
| `viwS<em>` | Zaznacz slowo, otocz tagiem | `hello` | `<em>hello</em>` |

### Tagi HTML: `t` i `<tag>`

nvim-surround ma specjalne wsparcie dla tagow HTML/JSX:

| Komenda | Opis | Przed | Po |
|---------|------|-------|----|
| `ysiw<em>` | Otocz word tagiem `<em>` | `hello` | `<em>hello</em>` |
| `cst<div>` | Zmien tag na `<div>` | `<span>hi</span>` | `<div>hi</div>` |
| `dst` | Usun tag | `<b>hello</b>` | `hello` |
| `ysiw<a href="#">` | Otocz tagiem z atrybutem | `link` | `<a href="#">link</a>` |

`t` oznacza "tag" -- dziala w `ds` i `cs` do identyfikacji istniejacych tagow.

### Function surround: `f`

Uzyj `f` jako znaku otaczajacego, aby otworzyc prompt na nazwe funkcji:

| Komenda | Opis | Przed | Po |
|---------|------|-------|----|
| `ysiwf` + `print` | Otocz wywolaniem funkcji | `hello` | `print(hello)` |
| `ysiwf` + `len` | Otocz `len()` | `items` | `len(items)` |
| `csf` + nowa nazwa | Zmien nazwe funkcji | `old(x)` | `new(x)` |
| `dsf` | Usun wywolanie funkcji | `print(x)` | `x` |

### Dot repeat z nvim-surround

Wszystkie operacje nvim-surround sa powtarzalne komenda `.`:

```
Scenariusz: Otocz kilka slow cudzyslow.

1. Ustaw kursor na pierwszym slowie
2. ysiw"          -- otocz pierwsze slowo
3. w              -- przejdz do nastepnego slowa
4. .              -- powtorz otoczenie (dot repeat!)
5. w.             -- nastepne slowo i powtorz
```

To jest ogromna przewaga -- nie musisz za kazdym razem wpisywac pelnej komendy.

### Laczenie z innymi text objects

Pamietaj, ze `ys` to operator -- dziala z **kazdym** motion i text object:

| Komenda | Opis |
|---------|------|
| `ysa"'` | Otocz to co jest w `"..."` apostrofami (surround around `"`) |
| `ysi)b` | Otocz zawartosc `(...)` nawiasami klamrowymi |
| `ysab)` | Otocz blok `(...)` lacznie z nawiasami w nowe `()` |
| `ys$"` | Otocz od kursora do konca linii |
| `ys^"` | Otocz od kursora do poczatku linii |

## Cwiczenia

> Otwierz pliki cwiczen i wykonaj zadania. Komendy w `backtickach` to dokladna sekwencja
> klawiszy do wcisniecia.

### Cwiczenie 1: Dodawanie cudzyslow (exercises/practice/surround.txt)

Otwierz `exercises/practice/surround.txt`. Linie 5-7 zawieraja zmienne bez cudzyslow.

1. Ustaw kursor na `John` (linia 5) -- `ysiw"` -- otocz cudzyslow
2. Przejdz do `Hello World` (linia 6) -- `ys2w"` -- otocz oba slowa
3. Przejdz do `something` (linia 7) -- `ysiw'` -- otocz apostrofami

### Cwiczenie 2: Dodawanie nawiasow do importow (exercises/practice/surround.txt)

Linie 28-29 zawieraja importy bez cudzyslow.

1. Kursor na `react` (linia 28) -- `ysiw"` -- `import React from "react"`
2. Kursor na `react` (linia 29) -- `ysiw"` -- `import { useState } from "react"`

### Cwiczenie 3: Zmiana cudzyslow (exercises/practice/surround.txt)

Linie 22-24:
1. `cs"'` na linii z `It's a beautiful day` -- zmien `"` na `'` ... ups, to nie zadziala dobrze z apostrofem!
2. Lepiej: `cs'"` na linii z apostrofami -- zmien `'` na `"`

### Cwiczenie 4: Tagi HTML (exercises/practice/surround.txt)

Linie 16-19 zawieraja tagi HTML:
1. Kursor wewnatrz `<p>` (linia 16) -- `cst<div>` -- zmien `<p>` na `<div>`
2. Kursor wewnatrz `<span>` (linia 17) -- `cst<strong>` -- zmien `<span>` na `<strong>`
3. Kursor wewnatrz `<b>` (linia 19) -- `dst` -- usun tag `<b>`, zostaw tekst
4. Kursor wewnatrz `<div>` (linia 18) -- `dst` -- usun tag, zostaw "content here"

### Cwiczenie 5: Function surround (exercises/practice/surround.txt)

Linie 31-33:
1. Kursor na `fetchData()` (linia 31) -- chcemy otworzyc `await` ... to nie dotyczy surround
2. Kursor na `data` (linia 31) -- `ysiwf` + wpisz `await fetchData` -- hmm, to bardziej skomplikowane
3. Lepszy przyklad: kursor na `result` (linia 32) -- `ysiwf` + wpisz `JSON.stringify` -- wynik: `JSON.stringify(result)`

### Cwiczenie 6: Visual mode surround (exercises/vue/UserCard.vue)

Otwierz `exercises/vue/UserCard.vue`:
1. Znajdz linie z `{{ user.fullName }}` -- zaznacz `user.fullName` (`viw` nie wystarczy -- uzyj `vt}`)
2. `S'` -- otocz apostrofami (to przyklad -- w praktyce nie chcesz tego robic w template)
3. Cofnij: `u`
4. Znajdz tekst `Anonymous User` (linia ~67) -- `viw` + `S"` -- otocz cudzyslow

### Cwiczenie 7: Otaczanie w TypeScript (exercises/typescript/utils.ts)

Otwierz `exercises/typescript/utils.ts`:
1. Znajdz `return str` w funkcji `capitalize` (~linia 11) -- kursor na `str` -- `ysiwf` + `String` -- `String(str)`
2. Cofnij: `u`

### Cwiczenie 8: Dot repeat (exercises/practice/surround.txt)

Linie 36-40 zawieraja obiekty bez cudzyslow przy kluczach:
1. Kursor na `name` (linia 37) -- `ysiw"` -- otocz cudzyslow
2. Kursor na `Alice` -- `.` -- powtorz (dot repeat)
3. Kontynuuj na `age`, `30`, `name`, `Bob` itd. -- uzyj `w` i `.`

### Cwiczenie 9: Zamiana nawiasow (exercises/typescript/utils.ts)

1. Znajdz `Math.min(Math.max(value, min), max)` w funkcji `clamp` (~linia 74)
2. Kursor wewnatrz wewnetrznych nawiasow -- `cs)]` -- zmien `()` na `[]`
3. Cofnij: `u`

## Cwiczenie bonusowe

**Refaktor nawiasow w calym pliku**: Otwierz `exercises/typescript/utils.ts` i wykonaj nastepujace
operacje na roznnych funkcjach, nie uzywajac trybu Insert ani jednego razu:

1. W funkcji `escapeHtml` (~linia 43) -- zmien `"` na `'` w jednym z par cudzyslow (`cs"'`) i uzyj `.` na pozostalych
2. Znajdz dowolny string w `Record<string, string>` -- uzyj `cst` aby zmienic tagi generyczne (nie, tagi to HTML -- ale mozesz uzyc `cs>)` etc.)
3. Otocz wynik `Math.round(value * factor) / factor` w `return` nawiasami: zaznacz `viW` i `S)`

**Wyzwanie**: Wykonaj 10 operacji surround w 60 sekund na pliku `exercises/practice/surround.txt`. Im wiecej uzywasz `.`, tym szybciej.

## Podsumowanie

### Tabela komend

| Komenda | Opis | Przyklad |
|---------|------|----------|
| `ys{motion}{char}` | Dodaj otoczenie | `ysiw"` -- otocz word `"` |
| `yss{char}` | Otocz cala linie | `yss)` -- otocz linie `()` |
| `cs{old}{new}` | Zmien otoczenie | `cs"'` -- `"` na `'` |
| `ds{char}` | Usun otoczenie | `ds"` -- usun `"` |
| `S{char}` (Visual) | Otocz zaznaczenie | `viwS"` -- zaznacz i otocz |
| `cst<tag>` | Zmien tag HTML | `cst<div>` -- zmien na `<div>` |
| `dst` | Usun tag HTML | usun najblizszy tag |
| `ysiwf` + nazwa | Otocz wywolaniem funkcji | `ysiwf` + `print` |
| `)` / `]` / `}` | Bez spacji wewnatrz | `(hello)` |
| `(` / `[` / `{` | Ze spacjami wewnatrz | `( hello )` |

### Najczestsze wzorce

```
ysiw"    -- najczesciej uzywane: otocz slowo cudzyslow
cs"'     -- zmien typ cudzyslow
ds"      -- usun cudzyslow
cst<X>   -- zmien tag HTML
dst      -- usun tag HTML
yss)     -- otocz cala linie nawiasami
.        -- powtorz ostatnia operacje surround
```

### Co dalej?

W nastepnej lekcji (10) poznasz Comment.nvim do szybkiego komentowania kodu oraz zaawansowane
operacje na wcieniach -- w tym automatyczne zachowanie zaznaczenia po indentacji dzieki
Twojej konfiguracji.
