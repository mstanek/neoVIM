# Lekcja 11: Flash.nvim -- blyskawiczna nawigacja

> Czas: ~30-45 min | Poziom: Intermediate

## Cel lekcji

Opanowanie Flash.nvim -- pluginu, ktory pozwala przeskakiwac do dowolnego widocznego miejsca
w buforze w 2-3 nacisnieciac klawiszy. Poznasz rowniez tryb Treesitter (selekcja
strukturalna) i Remote Flash (operacje na odleglym tekscie).

## Teoria

### Czym jest Flash.nvim?

Flash.nvim to nastepca pluginow takich jak EasyMotion, Hop czy Leap. Idea jest prosta:
zamiast wielokrotnego naciskania `w`, `f`, `/` aby dotrzec do odleglego miejsca, wpisujesz
kilka znakow -- Flash podswietla pasujace lokalizacje i wyswietla **label** (jedna litere)
przy kazdym trafieniu. Naciskasz label i kursor przeskakuje.

### Twoja konfiguracja Flash.nvim

> **Twoja konfiguracja**: Flash.nvim z wylaczonymi trybami:
> - `modes.search = false` -- Flash **nie** integruje sie z natywnym `/` (wyszukiwanie dziala normalnie)
> - `modes.char = false` -- `f`, `t`, `F`, `T` dzialaja **natywnie** (bez nakladki Flash)
>
> Aktywne tryby:
> - `s` -- Flash jump (normal, visual, operator-pending)
> - `S` -- Flash Treesitter select (normal, visual, operator-pending)
> - `r` -- Remote Flash (tylko operator-pending)

Dzieki temu masz czyste rozdzielenie: `f`/`t` do skokow w obrebie linii (natywne Vim),
`s` do skokow w obrebie calego ekranu (Flash).

### Flash Jump: `s`

Nacisnij `s` w trybie Normal, a nastepnie zacznij pisac tekst, ktory chcesz znalezc.
Flash dziala **inkrementalnie** -- po kazdym znaku zaweza wyniki:

```
Krok po kroku:

1. s              -- aktywuj Flash
2. wpisz "re"     -- Flash podswietla wszystkie "re" na ekranie
3.                -- przy kazdym trafieniu pojawia sie label (a, b, c, d...)
4. nacisnij label -- kursor przeskakuje do tego miejsca
```

**Wizualizacja** (labels oznaczone `[X]`):

```
def process_data(items):          def process_data(items):
    result = transform(items)  ->     [a]sult = transform(items)
    return result                     [b]turn [c]sult
    # remember to validate           # [d]member to validate
```

Po wpisaniu `s` + `re` -- Flash podswietla "re" w `result`, `return`, `result`, `remember`
i wyswietla labels `a`, `b`, `c`, `d`.

### Flash Jump w trybie Visual

`s` dziala rowniez w trybie Visual -- zaznaczenie rozszerza sie do miejsca skoku:

```
1. v         -- wejdz w Visual
2. s         -- aktywuj Flash
3. wpisz "fu"-- Flash podswietla "fu" (np. w "function")
4. label     -- zaznaczenie rozciaga sie do tego miejsca
```

To przydatne do zaznaczania duzych fragmentow tekstu bez liczenia linii.

### Flash Jump w trybie operator-pending

`s` w polaczeniu z operatorami (`d`, `c`, `y`) pozwala na operacje do odleglego miejsca:

| Sekwencja | Opis |
|-----------|------|
| `ds` + tekst + label | Usun od kursora do miejsca Flash |
| `cs` + tekst + label | Zmien od kursora do miejsca Flash |
| `ys` + tekst + label | Skopiuj (yank) od kursora do miejsca Flash |

**Przyklad**:

```python
# Kursor na poczatku linii:
def process_data(items):
^

# Chcemy usunac od kursora do "items":
# d    -- operator delete
# s    -- aktywuj Flash
# it   -- wpisz "it" (poczatek "items")
# [a]  -- nacisnij label
# Wynik: usuniety tekst od kursora do "items"
```

> **Uwaga**: W operator-pending mode Flash uzywa **inclusive** motion -- obejmuje
> trafiony tekst. To rozni sie od natywnego `/`, ktore jest exclusive.

### Flash Treesitter: `S`

Tryb Treesitter to zupelnie inna koncepcja niz zwykly jump. Zamiast przeskakiwac do
pozycji tekstowej, `S` pozwala **zaznaczac node'y Treesitter** (strukturalne czesci kodu):

```
Krok po kroku:

1. S              -- aktywuj Flash Treesitter
2.                -- Flash podswietla node'y Treesitter i wyswietla labels
3.                -- Widzisz labels na: funkcjach, ifach, petlach, argumentach, stringach...
4. nacisnij label -- zaznaczasz ten node (Visual mode)
```

**Co to sa node'y Treesitter?**

Treesitter parsuje kod do drzewa skladniowego. Kazdy element to node:

```python
def process_data(items):        # node: function_definition
    if items:                   # node: if_statement
        for item in items:      # node: for_statement
            result.append(item) # node: expression_statement
    return result               # node: return_statement
```

Po nacisnieciu `S` zobaczysz labels na roznych poziomach zagniezdzen.
Mozesz **rozszerzac** zaznaczenie naciskajac kolejne labels.

**Przyklad uzycia**:

```python
# Chcesz zaznaczac cala funkcje:
# 1. Ustaw kursor gdziekolwiek wewnatrz funkcji
# 2. S -- aktywuj Treesitter
# 3. Nacisnij label przy "function_definition"
# 4. Cala funkcja jest zaznaczona w Visual mode
```

### Typowe node'y Treesitter

| Node | Przyklad |
|------|----------|
| `function_definition` | Cala funkcja (def ... return) |
| `if_statement` | Caly blok if/elif/else |
| `for_statement` | Cala petla for |
| `class_definition` | Cala klasa |
| `argument_list` | Argumenty funkcji |
| `string` | Caly string (lacznie z cudzyslow) |
| `block` | Blok kodu (cialo funkcji, petli) |
| `parameters` | Parametry definicji funkcji |

### Remote Flash: `r`

Remote Flash to tryb dostepny **tylko w operator-pending mode**. Pozwala wykonac
operacje na tekscie w odleglym miejscu **bez przesuwania kursora**:

```
Krok po kroku:

1. y         -- operator yank
2. r         -- aktywuj Remote Flash
3. wpisz "he"-- Flash podswietla "he" (np. w "hello")
4. label     -- Flash przenosi Cie tam
5. iw        -- text object (inner word) -- kopiuje "hello"
6.           -- kursor wraca na oryginalna pozycje!
```

**Kluczowa roznica**: Po zakonczeniu operacji kursor **wraca** na poczatkowa pozycje.
To jak "zdalny" yank/delete.

| Sekwencja | Opis |
|-----------|------|
| `yr` + flash + `iw` | Skopiuj slowo z odleglego miejsca (kursor zostaje) |
| `dr` + flash + `iw` | Usun slowo z odleglego miejsca (kursor zostaje) |
| `cr` + flash + `iw` | Zmien slowo w odleglym miejscu (kursor przeniesie sie na chwile) |

> **Uwaga**: Remote Flash wymaga motion lub text object **po** skoku.
> Nacisnij `yr`, przeskocz do celu, a potem podaj text object (np. `iw`, `i"`, `a)`).

### Flash vs natywne motions -- kiedy czego uzywac?

| Sytuacja | Uzyj | Dlaczego |
|----------|------|----------|
| Skok do znaku w biezacej linii | `f`/`t` | Natywne, szybsze dla 1 znaku |
| Skok 2-3 slowa dalej | `w`/`b`/`e` | Natywne motions wystarczaja |
| Skok do odleglego miejsca na ekranie | `s` (Flash) | 2-3 klawisze vs wiele `w`/`j` |
| Zaznaczenie strukturalne (funkcja, blok) | `S` (Treesitter) | Precyzyjna selekcja AST |
| Operacja na odleglym tekscie | `r` (Remote) | Nie przesuwa kursora |
| Skok do tekstu poza ekranem | `/` (search) | Flash dziala tylko na widocznym tekscie |

**Zasada**: Flash jest najskuteczniejszy dla **sredni i dalekiego** zasiegu na ekranie.
Dla bliskiegu zasiegu uzywaj natywnych motions (`w`, `f`, `e`). Dla tekstu poza ekranem
uzywaj `/` (search).

## Cwiczenia

### Cwiczenie 1: Podstawowy Flash jump (exercises/python/data_processing.py)

Otwierz `exercises/python/data_processing.py` (426 linii -- duzy plik, idealny dla Flash):

1. Przejdz na poczatek pliku (`gg`)
2. `s` + wpisz `Pipeline` -- pojawia sie kilka trafien
3. Nacisnij label przy definicji klasy `Pipeline` (~linia 278)
4. Kursor przeskoczyl na poczatek `Pipeline`

### Cwiczenie 2: Flash do nawigacji (exercises/python/data_processing.py)

Bedzac gdziekolwiek w pliku:

1. `s` + `def ` (z spacja!) -- Flash podswietla wszystkie definicje funkcji/metod
2. Nacisnij label przy `def validate` -- przeskocz do metody validate
3. `s` + `def ` -- ponownie -- przeskocz do innej metody
4. Powtorz kilka razy -- porownaj szybkosc z `/def ` + `n`

### Cwiczenie 3: Flash w Visual mode (exercises/python/data_processing.py)

1. Przejdz do klasy `DataLoader` (~linia 80)
2. `V` -- wejdz w Visual Line
3. `s` + wpisz `Trans` -- label pojawi sie przy `class BaseTransformer`
4. Nacisnij label -- zaznaczyles cala klase DataLoader (od poczatku do linii przed BaseTransformer)
5. `Esc` -- anuluj zaznaczenie

### Cwiczenie 4: Flash z operatorem delete (exercises/python/data_processing.py)

1. Znajdz komentarz `# Helper functions` (~linia 343)
2. Kursor na poczatek linii komentarza
3. `d` + `s` + wpisz `def ch` -- Flash pokaze `def chunk_list`
4. Nacisnij label -- usuniety tekst od komentarza do `def chunk_list`
5. `u` -- cofnij!

### Cwiczenie 5: Flash z operatorem yank (exercises/python/data_processing.py)

1. Przejdz do klasy `ColumnRenamer` (~linia 148)
2. `y` + `s` + wpisz `class T` -- Flash pokaze `class TypeCaster`
3. Nacisnij label -- skopiowany tekst od ColumnRenamer do TypeCaster
4. `p` -- wklej skopiowany tekst
5. `u` -- cofnij

### Cwiczenie 6: Treesitter select (exercises/python/data_processing.py)

1. Przejdz do metody `process` klasy `Pipeline` (~linia 306)
2. Ustaw kursor wewnatrz ciala metody
3. `S` -- aktywuj Flash Treesitter
4. Zobaczysz labels na roznych node'ach -- wybierz label przy calej metodzie `process`
5. Cala metoda jest zaznaczona w Visual mode
6. `Esc` -- anuluj

### Cwiczenie 7: Treesitter select -- rozne node'y (exercises/python/data_processing.py)

1. Znajdz dowolny `if` statement (np. w `_validate_row` ~linia 249)
2. Ustaw kursor wewnatrz bloku `if`
3. `S` -- aktywuj Treesitter
4. Wybierz label przy `if_statement` -- zaznaczony caly blok if
5. `Esc`
6. Powtorz w `for` loop (~linia 239) -- `S` i zaznacz `for_statement`

### Cwiczenie 8: Remote Flash (exercises/python/data_processing.py)

1. Przejdz na poczatek pliku (`gg`)
2. `yr` -- yank + Remote Flash
3. Wpisz `Pipeline` -- Flash podswietla
4. Nacisnij label przy `class Pipeline`
5. `iw` -- skopiuj slowo "Pipeline"
6. Kursor wraca na poczatek pliku! Sprawdz: `p` -- wklei "Pipeline"
7. `u` -- cofnij

### Cwiczenie 9: Flash w Vue (exercises/vue/DataTable.vue)

Otwierz `exercises/vue/DataTable.vue`:

1. `gg` -- poczatek pliku
2. `s` + `computed` -- przeskocz do jednej z `computed`
3. `s` + `function` -- przeskocz do jednej z funkcji
4. `S` w sekcji `<script>` -- uzyj Treesitter do zaznaczenia calej funkcji

### Cwiczenie 10: Porownanie szybkosci

Otwierz `exercises/python/data_processing.py` i zmierz ile klawiszy potrzebujesz:

**Zadanie**: Z poczatku pliku dotrzec do metody `process_stream` (~linia 331):

Sposob 1 (natywne motions):
- `/process_stream<CR>` -- 15 klawiszy

Sposob 2 (Flash):
- `s` + `pro` + label -- 5-6 klawiszy (zalezy od ilosci trafien)

Sposob 3 (powtarzanie `/`):
- `/def <CR>` + wielokrotne `n` -- wiele klawiszy

## Cwiczenie bonusowe

**Flash marathon**: Otwierz `exercises/python/data_processing.py` i przeskakuj miedzy
tymi lokalizacjami uzywajac **tylko** Flash (`s`):

1. `class FileFormat` -> `class ColumnSchema` -> `class DataSchema`
2. `class DataLoader` -> metoda `load` -> metoda `_parse_csv`
3. `class BaseTransformer` -> `class ColumnRenamer` -> `class TypeCaster`
4. `class Pipeline` -> metoda `process` -> metoda `process_stream`
5. `def normalize_whitespace` -> `def extract_emails` -> `def flatten_dict`

Zmierz czas -- po kilku powtorzeniach powinienes przechodzic caly cykl w <30 sekund.

**Treesitter challenge**: W `exercises/python/data_processing.py`:
1. Uzyj `S` aby zaznaczac kazda klase po kolei
2. Uzyj `S` aby zaznaczac ciala metod (nie calych metod, tylko ciala)
3. Uzyj `S` aby zaznaczac argumenty funkcji

## Podsumowanie

### Tabela komend

| Komenda | Tryb | Opis |
|---------|------|------|
| `s` + tekst + label | Normal | Flash jump -- przeskocz do miejsca |
| `s` + tekst + label | Visual | Flash jump -- rozszerz zaznaczenie |
| `ds` + tekst + label | Normal | Delete do miejsca Flash |
| `ys` + tekst + label | Normal | Yank do miejsca Flash |
| `cs` + tekst + label | Normal | Change do miejsca Flash |
| `S` | Normal/Visual | Flash Treesitter -- zaznacz node AST |
| `yr` + flash + text object | Normal | Remote yank (kursor wraca) |
| `dr` + flash + text object | Normal | Remote delete (kursor wraca) |

### Flash vs natywne motions

| Zasieg | Najlepsze narzedzie |
|--------|---------------------|
| 1-3 znaki w linii | `f`/`t` (natywne) |
| 1-3 slowa | `w`/`b`/`e` (natywne) |
| Odlegly tekst na ekranie | `s` (Flash) |
| Struktura kodu | `S` (Treesitter) |
| Operacja "zdalna" | `r` (Remote Flash) |
| Tekst poza ekranem | `/` (search) |

### Co dalej?

W nastepnej lekcji (12) poznasz makra -- sposob na nagrywanie i odtwarzanie sekwencji
edycji. Makra pozwalaja zautomatyzowac powtarzalne operacje, ktore sa zbyt zlozone
dla samego `.` (dot repeat).
