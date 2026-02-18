# Lekcja 13: Substitution -- wyszukaj i zamien

> Czas: ~35-45 min | Poziom: Intermediate

## Cel lekcji

Opanowanie komendy `:s` (substitution) -- od prostych zamian tekstu, przez regex z grupami,
az po zaawansowane transformacje z `\U`, `\L`, `\v` (very magic). Twoja konfiguracja z
`inccommand=split` daje podglad zmian na zywo, co czyni substitution znacznie latwiejszym
do nauki.

## Teoria

### Podstawowa skladnia

```vim
:[range]s/pattern/replacement/[flags]
```

| Czesc | Opis |
|-------|------|
| `range` | Zakres linii (opcjonalny, domyslnie biezaca linia) |
| `s` | Komenda substitute |
| `pattern` | Wzorzec do wyszukania (regex) |
| `replacement` | Tekst zastepczy |
| `flags` | Modyfikatory zachowania |

### Zakresy (range)

| Zakres | Opis |
|--------|------|
| (brak) | Tylko biezaca linia |
| `%` | Caly plik |
| `1,10` | Linie 1-10 |
| `.,$` | Od biezacej linii do konca pliku |
| `.,.+5` | Od biezacej linii + 5 nastepnych |
| `'<,'>` | Zaznaczenie Visual (automatycznie wstawiane) |

### Flagi

| Flaga | Opis |
|-------|------|
| `g` | **Global** -- zamien wszystkie wystapienia w linii (domyslnie tylko pierwsze) |
| `c` | **Confirm** -- pytaj przy kazdym wystpieniu (y/n/a/q/l) |
| `i` | **Insensitive** -- ignoruj wielkosc liter |
| `I` | Case **sensitive** (nadpisuje ustawienia ignorecase) |
| `n` | **Count only** -- nie zamieniaj, tylko policz wystapienia |
| `e` | **No error** -- nie pokazuj bledu jesli nie znaleziono |

### Podstawowe przyklady

```vim
:s/foo/bar/          " Zamien pierwsze 'foo' na 'bar' w biezacej linii
:s/foo/bar/g         " Zamien wszystkie 'foo' na 'bar' w biezacej linii
:%s/foo/bar/g        " Zamien wszystkie 'foo' na 'bar' w calym pliku
:%s/foo/bar/gc       " j.w. ale z potwierdzeniem kazdej zamiany
:%s/foo/bar/gi       " j.w. case insensitive
```

### `inccommand=split` -- podglad na zywo

> **Twoja konfiguracja**: `inccommand=split` to jedna z najlepszych opcji Neovima.
> Kiedy wpisujesz komende `:s/.../.../`, Neovim **na zywo** pokazuje efekt zamiany:
>
> 1. W buforze -- trafienia sa podswietlone, zamieniony tekst widoczny inline
> 2. W dolnym splicie -- preview window pokazuje wszystkie linie, ktore sie zmienia
>
> To oznacza, ze **widzisz wynik ZANIM nacisniesz Enter**. Mozesz modyfikowac
> pattern i replacement w locie, obserwujac zmiany na zywo.

**Workflow z inccommand**:

```
1. :%s/            -- zacznij wpisywac komende
2. old             -- w miarke wpisywania, trafienia podswietlaja sie
3. /               -- separator -- teraz wpisujesz replacement
4. new             -- widzisz na zywo jak "old" zmienia sie na "new"
5. /g              -- flaga global
6. <CR>            -- zatwierdz -- lub <Esc> aby anulowac
```

Jesli wynik w preview nie wyglada dobrze -- po prostu `Esc` i zacznij od nowa.
Zadna zmiana nie zostanie zastosowana dopoki nie nacisniesz Enter.

### Potwierdzenie: flaga `c`

Z flaga `c` Vim pyta o kazde wystapienie:

```vim
:%s/foo/bar/gc
```

Przy kazdym trafieniu pojawia sie prompt:

```
replace with bar (y/n/a/q/l/^E/^Y)?
```

| Klawisz | Opis |
|---------|------|
| `y` | **Yes** -- zamien to wystapienie |
| `n` | **No** -- pomin |
| `a` | **All** -- zamien to i wszystkie nastepne |
| `q` | **Quit** -- przerwij |
| `l` | **Last** -- zamien to i zakoncz |

### Regex w substitution

Vim uzywa wlasnego dialektu regex. Domyslnie (magic mode) wiele znakow specjalnych
wymaga `\` (backslash):

| Vim regex | Opis | Przyklad |
|-----------|------|----------|
| `.` | Dowolny znak | `a.c` -> "abc", "axc" |
| `*` | 0+ powtorzen | `ab*c` -> "ac", "abc", "abbc" |
| `\+` | 1+ powtorzen | `ab\+c` -> "abc", "abbc" (nie "ac") |
| `\?` | 0 lub 1 | `ab\?c` -> "ac", "abc" |
| `\(group\)` | Grupa przechwytujaca | `\(foo\)` przechwytuje "foo" |
| `\1`, `\2` | Backreference do grupy | `\1` odwoluje sie do pierwszej grupy |
| `\w` | Znak alfanumeryczny | `\w\+` -> slowo |
| `\s` | Whitespace | `\s\+` -> spacje/taby |
| `^` | Poczatek linii | `^import` -> linie zaczynajace sie od "import" |
| `$` | Koniec linii | `;$` -> linie konczace sie `;` |

### Very magic mode: `\v`

Dodaj `\v` na poczatku pattern, aby wlaczyc "very magic" mode -- mniej backslashy:

```vim
" Bez \v (domyslny magic mode):
:%s/\(\w\+\)_\(\w\+\)/\2_\1/g

" Z \v (very magic mode):
:%s/\v(\w+)_(\w+)/\2_\1/g
```

| Magic | Very magic `\v` |
|-------|-----------------|
| `\(` `)` | `(` `)` |
| `\+` | `+` |
| `\?` | `?` |
| `\{n,m\}` | `{n,m}` |
| `\|` | `\|` ... (pipe) |

**Rekomendacja**: Zawsze uzywaj `\v` dla zlozonych regex. Oszczedza mnstwo `\`.

### Grupy przechwytujace i backreferences

Grupy pozwalaja przechwycic czesci wzorca i uzyc ich w replacement:

```vim
" Zamien kolejnosc slow: "first_second" -> "second_first"
:%s/\v(\w+)_(\w+)/\2_\1/g

" \1 = pierwsza grupa (first)
" \2 = druga grupa (second)
```

**Przyklad -- zamien argumenty funkcji**:

```vim
" func(a, b) -> func(b, a)
:%s/\v(\w+)\((\w+), (\w+)\)/\1(\3, \2)/g
```

### Specjalne sekwencje w replacement

| Sekwencja | Opis | Przyklad |
|-----------|------|----------|
| `&` | Caly dopasowany tekst | `:%s/\w\+/[\0]/g` -- otocz kazde slowo `[]` |
| `\0` | To samo co `&` | Caly match |
| `\1` -- `\9` | Backreference do grupy | Pierwsza, druga... dziewiata grupa |
| `\U` | UPPERCASE do konca lub `\e` | `\U\1` -- cala grupa uppercase |
| `\L` | lowercase do konca lub `\e` | `\L\1` -- cala grupa lowercase |
| `\u` | Uppercase nastepny znak | `\u\1` -- capitalize pierwsza litere grupy |
| `\l` | Lowercase nastepny znak | `\l\1` -- lowercase pierwsza litere grupy |
| `\e` | Koniec `\U` lub `\L` | `\U\1\e_\L\2` -- FIRST_second |
| `\r` | Nowa linia (newline) | Wstaw nowa linie w replacement |
| `\t` | Tab | Wstaw tabulator |

### Czeste wzorce substitution

**snake_case -> camelCase**:

```vim
:%s/\v_([a-z])/\u\1/g
```

Logika: Znajdz `_` + mala litera. Zamien na wielka litere (bez podkreslnika).

**camelCase -> snake_case**:

```vim
:%s/\v([a-z])([A-Z])/\1_\l\2/g
```

Logika: Znajdz mala litere + wielka litera. Wstaw `_` miedzy i zamien wielka na mala.

**Dodaj prefix do linii**:

```vim
:%s/^/export /
```

**Usun trailing whitespace**:

```vim
:%s/\s\+$//
```

**Zamien taby na spacje**:

```vim
:%s/\t/    /g
```

### Substitution w zaznaczeniu Visual

1. Zaznacz tekst w trybie Visual (`v`, `V`, `Ctrl+v`)
2. Nacisnij `:` -- automatycznie pojawi sie `:'<,'>`
3. Dopisz `s/old/new/g`

```vim
:'<,'>s/error/warning/g    " Zamien tylko w zaznaczeniu
```

> **Uwaga**: Przy Visual Block (`Ctrl+v`) substitution dziala na calych liniach
> zaznaczenia, nie tylko na zaznaczonym prostokcie. Jesli potrzebujesz zamiany
> tylko w obrebie bloku, uzyj `\%V`:
>
> ```vim
> :'<,'>s/\%Vold/new/g
> ```

### Wielokrotne zamiany na tym samym pliku

Czesto potrzebujesz kilku zamian. Mozesz laczyc je:

```vim
:%s/class/className/g | %s/for="/htmlFor="/g | %s/tabindex/tabIndex/g
```

Lub uzywaj historii komend -- `q:` otwiera okno historii, gdzie mozesz edytowac
poprzednie komendy i ponownie je wywolac.

## Cwiczenia

### Cwiczenie 1: Prosta zamiana (exercises/practice/search-replace.txt)

Otwierz `exercises/practice/search-replace.txt`. Exercise 1 (linie 7-10):

1. Wpisz `:%s/foo/bar/g` -- **ale nie naciskaj Enter jeszcze!**
2. Obserwuj podglad na zywo (inccommand=split) -- widzisz podswietlone "foo" i preview zmian
3. Nacisnij `Enter` -- zamiana wykonana
4. `u` -- cofnij

### Cwiczenie 2: snake_case -> camelCase (exercises/practice/search-replace.txt)

Exercise 2 (linie 14-23):

1. Zaznacz linie 14-23 w Visual Line (`V` + ruszaj w dol)
2. Wpisz `:` -- pojawi sie `:'<,'>`
3. Dopisz `s/\v_([a-z])/\u\1/g`
4. Obserwuj preview -- kazdy `_x` zmienia sie na wielka litere
5. `Enter` -- `u` -- cofnij

### Cwiczenie 3: Dodaj prefix (exercises/practice/search-replace.txt)

Exercise 3 (linie 27-34):

1. Zaznacz linie z `const` w Visual Line
2. `:'<,'>s/^const/export const/g`
3. Sprawdz preview -- `const` zmienia sie na `export const`
4. `Enter`
5. `u` -- cofnij

### Cwiczenie 4: Zamiana argumentow (exercises/practice/search-replace.txt)

Exercise 4 (linie 39-46):

1. Zaznacz blok
2. `:'<,'>s/\v(\w+)\((\w+), (\w+)\)/\1(\3, \2)/g`
3. Preview: `add(x, y)` -> `add(y, x)`
4. `Enter` -- `u`

### Cwiczenie 5: Wrap values (exercises/practice/search-replace.txt)

Exercise 5 (linie 51-60):

1. Zaznacz blok
2. `:'<,'>s/\v^(\w+) \= (.+)/\1 = "\2"/`
3. Preview: `HOST = localhost` -> `HOST = "localhost"`
4. `Enter` -- `u`

### Cwiczenie 6: HTML to JSX (exercises/practice/search-replace.txt)

Exercise 6 (linie 66-72) -- wymaga kilku zamian:

1. `:'<,'>s/class=/className=/g` -- zmien `class=` na `className=`
2. `:'<,'>s/for=/htmlFor=/g` -- zmien `for=` na `htmlFor=`
3. `:'<,'>s/tabindex=/tabIndex=/g` -- zmien `tabindex=` na `tabIndex=`
4. `u` wielokrotnie aby cofnac

### Cwiczenie 7: Live preview (exercises/practice/search-replace.txt)

Exercise 7 (linie 78-84) -- zamien `"` na `'` ale TYLKO w `console.log()`:

1. `:%s/\vconsole\.log\("([^"]+)"\)/console.log('\1')/g`
2. Obserwuj preview -- **tylko** linie z `console.log` sie zmieniaja!
3. Linie z `const msg =` i `const title =` zostaja nietkniete
4. `Enter` -- `u`

### Cwiczenie 8: Uppercase constants (exercises/practice/search-replace.txt)

Exercise 8 (linie 90-97) -- camelCase -> UPPER_SNAKE_CASE:

To wymaga dwoch krokow:
1. Najpierw camelCase -> snake_case:
   `:'<,'>s/\v([a-z])([A-Z])/\1_\2/g`
2. Potem snake_case -> UPPER:
   `:'<,'>s/\v(\w+)/\U\1/g`
3. `u` wielokrotnie -- cofnij

Alternatywnie jednym krokiem (trudniejsze):
`:'<,'>s/\v([a-z])([A-Z])/\1_\2/g | '<,'>s/\v^(\w+)/\U\1/`

### Cwiczenie 9: Visual range (exercises/practice/search-replace.txt)

Exercise 9 (linie 101-112) -- zamien "error" na "warning" TYLKO w Block 2:

1. Przejdz do Block 2 (~linia 107)
2. `V` -- wejdz w Visual Line
3. Zaznacz 3 linie Block 2
4. `:'<,'>s/error/warning/g`
5. Sprawdz -- Block 1 i Block 3 nie zmienione!
6. `u` -- cofnij

### Cwiczenie 10: Substitution w realnym kodzie (exercises/python/models.py)

Otwierz `exercises/python/models.py`:

1. `:%s/\vdatetime\.now/datetime.utcnow/g` -- zamien `datetime.now` na `datetime.utcnow`
2. Obserwuj preview -- trafienia w kilku miejscach
3. `Enter` -- `u`

**Bonus**: Zamien wszystkie `Optional[` na `| None`:
`:%s/\vOptional\[(\w+)\]/\1 | None/g`

## Cwiczenie bonusowe

**Pelna konwersja snake_case -> camelCase** na `exercises/practice/search-replace.txt`:

1. Otwierz Exercise 2
2. Uzyj `:%s/\v_([a-z])/\u\1/g` -- zamien snake_case
3. Ale to zmieni tez nazwy po `=`! Jak ograniczyc do lewej strony `=`?
4. Hint: `:%s/\v^(\w+)_(\w+)(\s*\=)/\1\u\2\3/g` -- zamienia tylko identyfikatory przed `=`
5. Moze potrzebowac kilku przejsc dla zmiennych z wiecej niz jednym `_`

**Regex golf**: Sprobuj napisac single regex dla kazdego z tych zadan:
- Zamien `print("...")` na `logger.info("...")`
- Zamien `def func_name(` na `async def func_name(`
- Usun wszystkie komentarze `#` z pliku Python

## Podsumowanie

### Tabela komend

| Komenda | Opis |
|---------|------|
| `:s/old/new/` | Zamien pierwsze w linii |
| `:s/old/new/g` | Zamien wszystkie w linii |
| `:%s/old/new/g` | Zamien w calym pliku |
| `:%s/old/new/gc` | Z potwierdzeniem |
| `:%s/old/new/gi` | Case insensitive |
| `:'<,'>s/old/new/g` | Tylko w zaznaczeniu Visual |
| `:%s/\v(pattern)/\1/g` | Very magic + grupy |
| `:%s/\vpattern/\U\1/g` | Uppercase |
| `:%s/\vpattern/\L\1/g` | Lowercase |
| `:%s/\vpattern/\u\1/g` | Capitalize |

### Specjalne znaki w replacement

| Znak | Opis |
|------|------|
| `&` / `\0` | Caly match |
| `\1`-`\9` | Grupy przechwytujace |
| `\U` | Uppercase do `\e` |
| `\L` | Lowercase do `\e` |
| `\u` | Uppercase nastepny znak |
| `\l` | Lowercase nastepny znak |
| `\r` | Nowa linia |
| `\t` | Tabulator |

### Kluczowa przewaga Twojej konfiguracji

`inccommand=split` pozwala Ci **widziec** wynik zamiany **zanim** nacisniesz Enter.
Uzywaj tego do eksperymentowania z regex -- wpisuj pattern, obserwuj preview,
modyfikuj, az wynik bedzie poprawny. Zero ryzyka -- `Esc` anuluje wszystko.

### Co dalej?

W nastepnej lekcji (14) poznasz przesuwanie linii (`Alt+j`/`Alt+k`), laczenie linii
(`J`/`gJ`) i potezna komende `.` (dot repeat) -- wszystko to razem tworzy szybki
workflow edycji bez makr i bez substytucji.
