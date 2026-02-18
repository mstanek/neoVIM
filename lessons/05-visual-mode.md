# Lekcja 05: Tryb Visual

> Czas: ~35-45 min | Poziom: Intermediate

## Cel lekcji

Opanowanie trzech wariantow trybu Visual: character-wise (`v`), line-wise (`V`) i block-wise
(`Ctrl+v`). Nauczysz sie zaznaczac tekst, operowac na zaznaczeniu, a przede wszystkim
korzystac z poteznej edycji kolumnowej (block Visual).

## Teoria

### Trzy warianty trybu Visual

| Klawisz | Wariant | Opis | Ikona w lualine |
|---------|---------|------|-----------------|
| `v` | Character-wise | Zaznaczanie po znakach | `VISUAL` |
| `V` | Line-wise | Zaznaczanie calych linii | `V-LINE` |
| `Ctrl+v` | Block-wise | Zaznaczanie prostokatnego bloku (kolumny) | `V-BLOCK` |

Przelaczanie miedzy wariantami w trybie Visual:
- W Visual char -> nacisnij `V` -> przejdziesz do Visual line
- W Visual line -> nacisnij `Ctrl+v` -> przejdziesz do Visual block
- W Visual block -> nacisnij `v` -> przejdziesz do Visual char
- `Esc` lub `v`/`V`/`Ctrl+v` (ten sam klawisz) -> wyjscie z Visual

### Character-wise Visual (`v`)

Nacisnij `v` i poruszaj kursorem -- tekst zostanie zaznaczony od punktu startowego
do biezacej pozycji kursora. Mozesz uzywac WSZYSTKICH motions i text objects:

```python
name = "John Doe"
^                     # nacisnij v
         ^            # przesun do "D" -- zaznaczone: name = "D
```

Po zaznaczeniu wykonaj operacje:

| Klawisz | Opis |
|---------|------|
| `d` | Usun zaznaczony tekst |
| `c` | Usun i wejdz w Insert |
| `y` | Kopiuj zaznaczony tekst |
| `>` | Wciecie w prawo (indent) |
| `<` | Wciecie w lewo (outdent) |
| `~` | Przelacz wielkosc liter (toggle case) |
| `u` | Zamien na male litery (lowercase) |
| `U` | Zamien na wielkie litery (UPPERCASE) |
| `r{char}` | Zastap kazdy zaznaczony znak danym znakiem |
| `J` | Polacz zaznaczone linie w jedna |
| `:` | Wejdz w Command-line z zakresem `'<,'>` |

**Uzywanie text objects w Visual**:

```python
name = "John Doe"
        ^             # kursor wewnatrz cudzystowu
                      # nacisnij: vi"
name = "John Doe"
        ^^^^^^^^      # zaznaczone: John Doe (inner quotes)
```

### Line-wise Visual (`V`)

Zaznacza **calke linie**. Kazdy ruch w pionie (`j`/`k`) dodaje kolejne linie:

```python
def hello():        # V -- zaznaczona ta linia
    print("hi")     # j -- zaznaczone obie linie
    return True     # j -- zaznaczone trzy linie
```

Operacje dzialaja na calych liniach -- `d` usunie wszystkie zaznaczone linie,
`>` doda wciecie do kazdej zaznaczonej linii.

### Block-wise Visual (`Ctrl+v`)

Najciekawszy wariant -- zaznacza **prostokatny blok** tekstu. Pozwala operowac
na kolumnach:

```
name    = "Alice"
email   = "alice@test.com"
age     = 30
city    = "Krakow"
```

Ustaw kursor na `n` w `name`, nacisnij `Ctrl+v`, potem `3j` i `e`:
```
[name   ] = "Alice"
[email  ] = "alice@test.com"
[age    ] = 30
[city   ] = "Krakow"
```

Zaznaczony jest prostokat obejmujacy kolumne z nazwami zmiennych.

#### Operacje w Block Visual

| Klawisz | Opis |
|---------|------|
| `d` | Usun zaznaczony blok |
| `c` | Zmien zaznaczony blok (Insert, tekst pojawi sie we wszystkich liniach po `Esc`) |
| `I` | Wstaw tekst na poczatku bloku (kazda linia, po `Esc`) |
| `A` | Dopisz tekst na koncu bloku (kazda linia, po `Esc`) |
| `r{char}` | Zastap kazdy znak w bloku danym znakiem |
| `>` / `<` | Wciecie bloku |

**Kluczowe**: Po `I` lub `A` w block Visual, wpisujesz tekst w jednej linii.
Dopiero po nacisnieciu `Esc` tekst pojawia sie we **wszystkich** zaznaczonych liniach!

#### Typowe zastosowanie: dodawanie prefixu

```python
name = "Alice"
email = "alice@test.com"
age = 30
```

Chcesz dodac `self.` przed kazda zmienna:

1. Ustaw kursor na `n` w `name`
2. `Ctrl+v` -- block Visual
3. `2j` -- zaznacz 3 linie
4. `I` -- tryb Insert na poczatku bloku
5. Wpisz `self.`
6. `Esc` -- tekst pojawi sie we wszystkich liniach:

```python
self.name = "Alice"
self.email = "alice@test.com"
self.age = 30
```

#### Typowe zastosowanie: usuwanie kolumny

```python
#   name = "Alice"
#   email = "alice@test.com"
#   age = 30
```

Chcesz usunac komentarze `# `:

1. Ustaw kursor na `#` w pierwszej linii
2. `Ctrl+v` -- block Visual
3. `2j` -- zaznacz 3 linie
4. `l` albo `2l` -- rozszerz zaznaczenie na `# ` (hash + spacje)
5. `d` -- usun blok

### Przydatne komendy w Visual mode

| Klawisz | Opis |
|---------|------|
| `o` | Przenies kursor na drugi koniec zaznaczenia |
| `O` | W block Visual: przenies na drugi rog (ta sama linia) |
| `gv` | Ponownie zaznacz ostatnie zaznaczenie (po wyjsciu z Visual) |

**`o` -- toggle selection end**: Pozwala rozszerzac zaznaczenie w obie strony.
Np. zaznaczyles od linii 5 do 10, ale chcesz rozszerzyc do linii 3:
nacisnij `o` (kursor przeskoczy na poczatek zaznaczenia), potem `2k`.

**`gv` -- reselect**: Niezwykle przydatne po operacji. Np. po `>` (indent)
mozesz nacisnac `gv` zeby ponownie zaznaczac te same linie i dodac kolejne wciecie.

> **Twoja konfiguracja**: Masz zmapowane `<` i `>` w Visual mode z automatycznym
> ponownym zaznaczeniem:
> ```lua
> vim.keymap.set("v", "<", "<gv")  -- po outdent: zachowaj zaznaczenie
> vim.keymap.set("v", ">", ">gv")  -- po indent: zachowaj zaznaczenie
> ```
> Dzieki temu mozesz wielokrotnie naciskac `>` lub `<` bez koniecznosci ponownego
> zaznaczania! W standardowym Vimie po `>` zaznaczenie znika.

### Visual + operatory/text objects

Mozesz wejsc w Visual i uzyc text objects do precyzyjnego zaznaczenia:

| Komenda | Opis |
|---------|------|
| `viw` | Zaznacz slowo |
| `vi"` | Zaznacz zawartosc stringa |
| `vi(` | Zaznacz zawartosc nawiasow |
| `vit` | Zaznacz zawartosc tagu HTML |
| `vaf` | Zaznacz cala funkcje (mini.ai) |
| `Vaf` | Zaznacz cala funkcje jako linie (line-wise) |

### Kiedy uzywac Visual vs operator+motion?

| Sytuacja | Lepszy sposob | Dlaczego |
|----------|---------------|----------|
| Usun slowo | `diw` | Szybciej niz `viwd` |
| Zmien string | `ci"` | Szybciej niz `vi"c` |
| Skopiuj 5 linii | `5yy` lub `V4jy` | `5yy` szybsze, `V4jy` daje wizualny feedback |
| Indent bloku | `V3j>` | Visual daje kontrol nad zakresem |
| Edycja kolumn | `Ctrl+v` | Tylko Visual block to umozliwia |
| Skomplikowane zaznaczenie | `v` + motions | Kiedy zakres jest nieregularny |

**Ogolna zasada**: Jesli znasz dokladny zakres -- uzyj operator+motion (szybsze).
Jesli chcesz zobaczyc co zaznaczasz -- uzyj Visual (bezpieczniejsze).

## Cwiczenia

### Cwiczenie 1: Character Visual -- podstawy

Otworz plik:
```
nvim exercises/practice/operators.txt
```

Wpisz nastepujacy tekst:
```
The quick brown fox jumps over the lazy dog.
Pack my box with five dozen liquor jugs.
How vexingly quick daft zebras jump.
```

1. Ustaw kursor na `q` w `quick` (pierwsza linia)
2. `v` -- wejdz w Visual char
3. `e` -- zaznacz do konca slowa `quick`
4. `l` -- rozszerz o spacje
5. `e` -- zaznacz `brown`
6. `d` -- usun zaznaczony tekst
7. `u` -- cofnij
8. `viw` -- zaznacz slowo `quick` (z dowolna pozycja kursora w slowie)
9. `U` -- zamien na wielkie litery: `QUICK`
10. `u` -- cofnij

### Cwiczenie 2: Line Visual -- operacje na liniach

W tym samym pliku:

1. Ustaw kursor na drugiej linii
2. `V` -- zaznacz cala linie
3. `j` -- rozszerz zaznaczenie o nastepna linie
4. `d` -- usun obie linie
5. `u` -- cofnij
6. `V2j` -- zaznacz 3 linie
7. `>` -- dodaj wciecie (zaznaczenie zostanie zachowane!)
8. `>` -- dodaj kolejne wciecie
9. `<` -- cofnij jedno wciecie
10. `Esc` -- wyjdz z Visual
11. `u` kilka razy -- cofnij wszystko

### Cwiczenie 3: Block Visual -- edycja kolumnowa

Wpisz w pliku:
```
name = "Alice"
email = "alice@test.com"
age = 30
city = "Krakow"
active = True
```

**Dodawanie prefixu `self.`**:
1. Ustaw kursor na `n` w `name` (pierwsza linia, pierwsza kolumna)
2. `Ctrl+v` -- wejdz w Block Visual
3. `4j` -- zaznacz 5 linii
4. `I` -- Insert na poczatku bloku
5. Wpisz `self.`
6. `Esc` -- tekst pojawi sie we wszystkich liniach
7. `u` -- cofnij

**Usuwanie kolumny**:
1. `u` -- upewnij sie ze masz oryginalny tekst
2. Ustaw kursor na `=` w pierwszej linii
3. `Ctrl+v` -- Block Visual
4. `4j` -- zaznacz 5 linii
5. `$` -- zaznacz do konca kazdej linii
6. `d` -- usun -- zostaną same nazwy zmiennych
7. `u` -- cofnij

### Cwiczenie 4: Block Visual -- komentowanie kodu

Otworz `exercises/python/calculator.py`:
```
nvim exercises/python/calculator.py
```

1. Przejdz do metody `add` (linia ~85)
2. Ustaw kursor na poczatku linii `def add(...)`
3. `Ctrl+v` -- Block Visual
4. `4j` -- zaznacz 5 linii (cala metoda)
5. `I` -- Insert
6. Wpisz `# `
7. `Esc` -- wszystkie linie sa teraz zakomentowane
8. `u` -- cofnij komentarz

### Cwiczenie 5: Przelaczanie miedzy wariantami Visual

1. `v` -- character Visual
2. Obserwuj lualine: `VISUAL`
3. `V` -- przelacz na line Visual (lualine: `V-LINE`)
4. `Ctrl+v` -- przelacz na block Visual (lualine: `V-BLOCK`)
5. `v` -- wroc do character Visual
6. `Esc` -- wyjdz

### Cwiczenie 6: Komenda `o` -- toggle end

W pliku cwiczeniowym z tekstem:

1. Ustaw kursor na 3. linii
2. `V` -- zaznacz linie
3. `2j` -- rozszerz w dol (linie 3-5 zaznaczone)
4. `o` -- kursor przeskakuje na poczatek zaznaczenia (linia 3)
5. `2k` -- rozszerz w gore (linie 1-5 zaznaczone)
6. `Esc`

### Cwiczenie 7: `gv` -- ponowne zaznaczenie

1. `V3j` -- zaznacz 4 linie
2. `y` -- kopiuj (zaznaczenie znika)
3. `gv` -- ponownie zaznacz te same 4 linie
4. `>` -- dodaj wciecie (zaznaczenie zostanie -- Twoja konfiguracja!)
5. `u` -- cofnij wciecie
6. `Esc`

### Cwiczenie 8: Visual + text objects

Otworz `exercises/python/utils.py`:

1. Przejdz do funkcji `paginate` (linia ~69)
2. `vi{` -- zaznacz zawartosc bloku return `{...}` (slownik)
3. Obserwuj co jest zaznaczone
4. `Esc`
5. `va{` -- zaznacz z klamrami
6. `Esc`
7. `vaf` -- zaznacz cala funkcje (mini.ai)
8. `Esc`
9. Ustaw kursor na argumencie `page: int = 1`
10. `via` -- zaznacz argument (mini.ai)
11. `Esc`

### Cwiczenie 9: Block Visual -- zaawansowane

Wpisz:
```
const name    = "Alice";
const email   = "alice@test.com";
const age     = 30;
const city    = "Krakow";
const active  = true;
```

**Zamiana `const` na `let`**:
1. Ustaw kursor na `c` w `const` (pierwsza linia)
2. `Ctrl+v` -- Block Visual
3. `4j` -- zaznacz 5 linii
4. `4l` -- zaznacz `const` (5 znakow)
5. `c` -- change block
6. Wpisz `let  ` (let + 2 spacje)
7. `Esc` -- zamiana we wszystkich liniach
8. `u` -- cofnij

**Dodawanie srednika na koncu** (jesli brakuje):
1. `Ctrl+v` -- Block Visual
2. `4j` -- zaznacz 5 linii
3. `$` -- przejdz na koniec kazdej linii
4. `A` -- Append na koncu
5. Wpisz `;`
6. `Esc`
7. `u` -- cofnij

### Cwiczenie 10: Praktyczny scenariusz -- indent HTML

Wpisz:
```html
<div>
<h1>Title</h1>
<p>Paragraph one</p>
<p>Paragraph two</p>
<p>Paragraph three</p>
</div>
```

1. Ustaw kursor na `<h1>` (druga linia)
2. `V` -- zaznacz linie
3. `3j` -- zaznacz linie 2-5 (wnetrze diva)
4. `>` -- dodaj wciecie
5. Wynik:
```html
<div>
  <h1>Title</h1>
  <p>Paragraph one</p>
  <p>Paragraph two</p>
  <p>Paragraph three</p>
</div>
```
6. Zaznaczenie zostalo (Twoja konfiguracja) -- mozesz nacisnac `>` ponownie jesli chcesz wiecej
7. `Esc` -- gotowe

## Cwiczenie bonusowe

Otworz `exercises/python/calculator.py` i wykonaj nastepujace zadania uzywajac **glownie
trybu Visual**:

1. Zaznacz cala klase `Calculator` uzywajac `Vac` (line-wise Visual + around class)
   i policz ile linii ma
2. W metodzie `chain`, zaznacz slownik `dispatch` uzywajac `vi{` i zamien wartosci na
   lambdy (np. `"add": lambda a, b: a + b`)
3. Uzyj Block Visual (`Ctrl+v`) zeby dodac type hint `: float` do argumentow w metody `add`:
   - Zaznacz kolumne po nazwie argumentu
   - Uzyj `A` zeby dopisac `: float`
4. Zaznacz 3 metody (add, subtract, multiply) uzywajac `V` i skopiuj je (`y`), potem
   wklej na koncu klasy (`G`, `p`)

**Wyzwanie**: Skomentuj/odkomentuj 10 linii kodu jednoczesnie uzywajac Block Visual + `I# `.
Potem cofnij (`u`) i zrob to ponownie -- powinno pojsc szybciej za drugim razem!

## Podsumowanie

### Nauczone komendy

| Kategoria | Komenda | Opis |
|-----------|---------|------|
| Wejscie | `v` | Character-wise Visual |
| Wejscie | `V` | Line-wise Visual |
| Wejscie | `Ctrl+v` | Block-wise Visual |
| Operacja | `d` | Usun zaznaczenie |
| Operacja | `c` | Zmien zaznaczenie |
| Operacja | `y` | Kopiuj zaznaczenie |
| Operacja | `>` / `<` | Indent / outdent |
| Operacja | `~` | Toggle case |
| Operacja | `u` / `U` | Lowercase / UPPERCASE |
| Operacja | `r{char}` | Zastap kazdy znak |
| Operacja | `J` | Polacz linie |
| Block | `I` | Insert na poczatku bloku |
| Block | `A` | Append na koncu bloku |
| Nawigacja | `o` | Toggle end zaznaczenia |
| Nawigacja | `O` | Toggle corner (block) |
| Ponowne | `gv` | Reselect ostatnie zaznaczenie |

### Konfiguracja uzyta w tej lekcji

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| `v: < -> <gv` | keymap | Indent zachowuje zaznaczenie |
| `v: > -> >gv` | keymap | Outdent zachowuje zaznaczenie |
| `showmode` | `false` | Tryb Visual widoczny w lualine |

### Co dalej?

W **lekcji 06** poznasz **szukanie (search)** -- wyszukiwanie wzorcow `/pattern`,
nawigacja miedzy wynikami `n`/`N`, wyszukiwanie slowa pod kursorem `*`/`#`, i konfiguracje
ktora juz masz: `inccommand=split` (podglad zamian na zywo) i `smartcase` (inteligentne
rozroznianie wielkosci liter).
