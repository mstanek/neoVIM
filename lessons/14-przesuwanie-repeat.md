# Lekcja 14: Przesuwanie linii i powtarzanie

> Czas: ~30-40 min | Poziom: Intermediate

## Cel lekcji

Opanowanie przesuwania linii (`Alt+j`/`Alt+k`), laczenia linii (`J`/`gJ`) oraz
komendy `.` (dot repeat) -- najpotezniejszego skrotu Vima do powtarzania zmian.
Lekcja konczy Modul 2 (Intermediate) i laczy wiedze z poprzednich lekcji.

## Teoria

### Przesuwanie linii: `Alt+j` / `Alt+k`

> **Twoja konfiguracja**: Masz skroty `Alt+j` i `Alt+k` do przesuwania linii:
>
> **Normal mode**:
> - `Alt+j` -- przesuwa biezaca linie w dol (`:m .+1<CR>==`)
> - `Alt+k` -- przesuwa biezaca linie w gore (`:m .-2<CR>==`)
>
> **Visual mode**:
> - `Alt+j` -- przesuwa zaznaczony blok w dol (`:m '>+1<CR>gv=gv`)
> - `Alt+k` -- przesuwa zaznaczony blok w gore (`:m '<-2<CR>gv=gv`)
>
> Po przesunieciu linia jest automatycznie przeformatowana (`==`) i w Visual mode
> zaznaczenie jest zachowane (`gv`).

**Dlaczego to jest lepsze niz `dd` + `p`?**

| Metoda | Kroki | Efekt |
|--------|-------|-------|
| `dd` + `jjj` + `P` | 6+ klawiszy | Usuwa linie, nawiguje, wkleja |
| `Alt+j` x4 | 4 nacisniec | Plynne przesuwanie, widzisz efekt na zywo |

`Alt+j`/`Alt+k` jest **wizualne** -- widzisz linie przesuwajaca sie w czasie rzeczywistym.
Mozesz naciskac wielokrotnie, az linia bedzie we wlasciwym miejscu.

### Przesuwanie linii w Normal mode

```python
# Przed (kursor na linii 'banana'):
apple
banana       # <-- Alt+k
cherry

# Po Alt+k:
banana       # <-- przesunela sie w gore
apple
cherry

# Po kolejnym Alt+j, Alt+j:
apple
cherry
banana       # <-- teraz na dole
```

### Przesuwanie bloku w Visual mode

```python
# Zaznaczenie 3 linii:
apple
banana       # <-- V (Visual Line)
cherry       # <-- jj (zaznacz 3 linie)
date         # <-- Alt+j przesunie caly blok w dol
elderberry

# Po Alt+j:
apple
date
banana       # <-- blok przesuniety
cherry       # <-- zaznaczenie zachowane!
elderberry   # <-- mozesz dalej naciskac Alt+j/k
```

> **Kluczowe**: W Visual mode po przesunieciu zaznaczenie **nie znika** -- mozesz
> dalej naciskac `Alt+j`/`Alt+k` bez ponownego zaznaczania. To dzieki `gv=gv`
> w mappingu.

### Laczenie linii: `J` i `gJ`

| Komenda | Opis |
|---------|------|
| `J` | Polacz biezaca linie z nastepna (dodaje spacje) |
| `gJ` | Polacz bez dodawania spacji |
| `{count}J` | Polacz `{count}` linii |

**Przyklad `J`**:

```python
# Przed:
name = (
    "Alice"
)

# Kursor na 'name', 3J:
name = ( "Alice" )
```

**Przyklad `gJ`**:

```python
# Przed:
hello
world

# Kursor na 'hello', gJ:
helloworld
```

**Roznica**:
- `J` -- usuwa wciecia nastepnej linii i wstawia **jedna spacje** miedzy nimi
- `gJ` -- po prostu laczy linie **bez zadnych zmian** (nawet spacji)

**`J` z count**:

```python
# Przed:
a
b
c
d

# 4J:
a b c d
```

### Komenda `.` (dot repeat)

Komenda `.` to **najpotezniejszy skrot Vima**. Powtarza ostatnia **zmiane** (change).

### Co jest "zmiana"?

Zmiana to cokolwiek co modyfikuje bufor. Wazna zasada: zmiana zaczyna sie od operatora
lub wejscia w Insert mode i konczy sie na powrocie do Normal mode.

| Akcja | Czy to zmiana? | `.` powtorzy? |
|-------|----------------|---------------|
| `dw` (delete word) | Tak | Usunie nastepne slowo |
| `ciw` + tekst + `Esc` | Tak | Zmieni slowo na ten sam tekst |
| `dd` (delete line) | Tak | Usunie nastepna linie |
| `>>` (indent) | Tak | Wciecie nastepnej linii |
| `<<` (outdent) | Tak | Wyjdz z wciecia |
| `x` (delete char) | Tak | Usunie nastepny znak |
| `r` (replace char) | Tak | Zamieni nastepny znak |
| `p` (paste) | Tak | Wklei ponownie |
| `w` (move word) | **Nie** | Motion to nie zmiana! |
| `j` (move down) | **Nie** | Motion to nie zmiana! |
| `/search` | **Nie** | Wyszukiwanie to nie zmiana |
| `u` (undo) | **Nie** | Undo to nie zmiana |

**Kluczowa zasada**: `.` powtarza ostatnia zmiane, ale **nie** ruch kursora.
Musisz nawigowac samodzielnie, a potem naciskac `.`.

### Insert mode jako jedna zmiana

Wszystko co zrobisz od wejscia w Insert mode do wyjscia (`Esc`) to **jedna zmiana**:

```
ciw             -- zmien inner word (wejdz w Insert)
new_value       -- wpisz nowy tekst
<Esc>           -- wroc do Normal

Teraz . powtorzy: ciw + "new_value" + Esc
```

To oznacza, ze jesli chcesz zastosowac ta sama edycje w wielu miejscach:

```
1. ciw          -- zmien slowo
2. replacement  -- wpisz nowy tekst
3. Esc          -- wroc do Normal
4. n            -- znajdz nastepne wystapienie (po wczesniejszym /)
5. .            -- powtorz zmiane
6. n.           -- powtorz: znajdz + zmien
7. n.n.n.       -- itd.
```

### Potezne kombinacje z `.`

**Pattern 1: Zmiana slowa w wielu miejscach (`ciw` + `n.`)**

```
1. /oldName<CR>    -- wyszukaj slowo
2. ciw             -- zmien inner word
3. newName<Esc>    -- wpisz nowy tekst
4. n               -- nastepne wystapienie
5. .               -- powtorz zmiane
6. n.n.n.          -- powtarzaj az do konca
```

To jest szybsze niz `:%s` gdy chcesz zmienic **tylko wybrane** wystapienia (nie wszystkie).

**Pattern 2: Usuwanie slow (`daw` + `.`)**

```
1. daw     -- delete a word (slowo + spacja)
2. .       -- usun nastepne slowo
3. .       -- i nastepne
```

**Pattern 3: Dodawanie tekstu na koncu linii (`A` + `.`)**

```
1. A;Esc   -- dodaj `;` na koncu linii
2. j       -- nastepna linia
3. .       -- powtorz (dodaj `;` na koncu)
4. j.j.j.  -- powtarzaj na kolejnych liniach
```

**Pattern 4: Indent z `.`**

```
1. >>      -- wciecie linii
2. j       -- nastepna linia
3. .       -- powtorz wciecie
4. j.j.    -- dalej
```

### `.` z nvim-surround

> **Wazne**: Operacje nvim-surround sa powtarzalne komenda `.`! To otwiera
> potezne mozliwosci:

```
1. ysiw"   -- otocz slowo cudzyslow
2. w       -- nastepne slowo
3. .       -- powtorz otoczenie cudzyslow!
4. w.w.    -- dalej
```

```
1. ds"     -- usun cudzyslow
2. /"/     -- znajdz nastepne cudzyslow
3. .       -- powtorz usuniecie
```

```
1. cs"'    -- zmien " na '
2. n       -- nastepne wystapienie "
3. .       -- powtorz zmiane
```

### `.` z Comment.nvim

```
1. gcc     -- zakomentuj linie
2. j       -- nastepna linia
3. .       -- zakomentuj nastepna
4. j.j.    -- dalej
```

> **Uwaga**: `gcc` to toggle -- jesli linia jest juz zakomentowana, `.` ja odkomentuje.
> Uzywaj tego z uwaga.

### `.` z operatorem `=` (auto-indent)

```
1. ==      -- auto-indent biezacej linii
2. j       -- nastepna linia
3. .       -- powtorz auto-indent
```

### Kiedy `.` nie wystarczy?

Jesli operacja wymaga roznej nawigacji za kazdym razem lub roznego tekstu -- `.` nie
wystarczy. Wtedy uzywaj:

| Sytuacja | Narzedzie |
|----------|-----------|
| Identyczna zmiana, rozne miejsca | `.` (dot repeat) |
| Identyczna zmiana, wiele linii po kolei | `.` z `j` lub makro |
| Identyczna zmiana, wzorzec do wyszukania | `n.n.n.` |
| Rozne zmiany, wzorzec | `:s/old/new/gc` (substitution z confirm) |
| Zlozony ciag operacji, powtarzany | Makro (`q`) |

### Podsumowanie mentalnego modelu

```
Jednorazowa zmiana:        d, c, x, r, >>, <<, p, o, O, A, I...
Powtorzenie zmiany:        .
Powtorzenie z nawigacja:   n. lub j. lub w.
Zlozony ciag operacji:     makro (q)
Masowa zamiana tekstu:     :s/old/new/g
```

## Cwiczenia

### Cwiczenie 1: Przesuwanie linii (exercises/python/utils.py)

Otwierz `exercises/python/utils.py`. Cel: przenies funkcje `validate_email` (~linia 39)
**przed** `format_currency` (~linia 21) -- tak aby byla pierwsza.

1. Przejdz do linii `def validate_email` (~linia 39)
2. `V` -- wejdz w Visual Line
3. Zaznacz cala funkcje (do konca linii `return bool(...)`) -- uzyj `j` wielokrotnie lub `}` (paragraf)
4. `Alt+k` wielokrotnie -- przesuwaj blok w gore az bedzie nad `def format_currency`
5. `Esc` -- sprawdz wynik
6. `u` wielokrotnie -- cofnij

### Cwiczenie 2: Reorderowanie metod (exercises/python/utils.py)

Przesunimy `generate_token` (~linia 179) wyzej, tak aby byla tuz za `validate_email`:

1. Przejdz do `def generate_token`
2. `V` -- Visual Line -- zaznacz cala funkcje (z docstringiem)
3. `Alt+k` wielokrotnie az znajdzie sie we wlasciwym miejscu
4. `u` -- cofnij

### Cwiczenie 3: Laczenie linii (exercises/typescript/api-service.ts)

Otwierz `exercises/typescript/api-service.ts`. Znajdz deklaracje importu (~linie 10-17):

```typescript
import type {
  ApiResponse,
  PaginatedResponse,
  ...
} from "./interfaces";
```

1. Kursor na `import type {` (~linia 10)
2. `8J` -- polacz 8 linii w jedna (import stanie sie jednolinijkowy)
3. `u` -- cofnij

### Cwiczenie 4: `gJ` -- laczenie bez spacji (exercises/typescript/api-service.ts)

1. Znajdz dowolna wieloliniowa deklaracje w pliku
2. Uzyj `gJ` -- porownaj efekt z `J`
3. `u` -- cofnij

### Cwiczenie 5: Dot repeat z `ciw` (exercises/typescript/api-service.ts)

Cel: Zmien nazwe `baseUrl` na `apiUrl` w calym pliku:

1. `/baseUrl<CR>` -- znajdz pierwsze wystapienie
2. `ciw` -- zmien inner word
3. `apiUrl` -- wpisz nowy tekst
4. `Esc` -- wroc do Normal
5. `n` -- nastepne wystapienie
6. `.` -- powtorz zmiane (dot repeat!)
7. Powtarzaj `n.` az zmienisz wszystkie wystapienia (lub pomin niektorymi `n`)
8. `u` wielokrotnie -- cofnij

### Cwiczenie 6: Dot repeat z `A` (exercises/typescript/api-service.ts)

Cel: Dodaj komentarz `// TODO: add logging` na koncu kazdej metody publicznej:

1. Przejdz do `async getUsers` (~linia 104)
2. `A  // TODO: add logging` + `Esc`
3. Przejdz do `async getUser` (~linia 110) -- `j` wielokrotnie lub `s` (Flash)
4. `.` -- powtarza dodanie komentarza na koncu linii
5. Kontynuuj na kolejnych metodach: `async createUser`, `async updateUser`...
6. `u` wielokrotnie -- cofnij

### Cwiczenie 7: Dot repeat z `daw` (exercises/python/utils.py)

1. Przejdz do definicji `formats = [` w `parse_date` (~linia 144)
2. Kursor na jednym z formatow, np. `"%d/%m/%Y"` (~linia 149)
3. `daw` -- usun slowo (format + przecinek/spacja)
4. `.` -- usun nastepny format
5. `.` -- i nastepny
6. `u` wielokrotnie -- cofnij

### Cwiczenie 8: Dot repeat z nvim-surround (exercises/practice/surround.txt)

Otwierz `exercises/practice/surround.txt`:

1. Kursor na `apple` (linia 13)
2. `ysiw"` -- otocz cudzyslow
3. `w` -- nastepne slowo (`banana`)
4. `.` -- powtorz otoczenie! -> `"banana"`
5. `w.` -- `"cherry"`
6. Kontynuuj -- kazde `w.` otacza kolejne slowo

### Cwiczenie 9: `n.` pattern -- selektywna zamiana (exercises/python/models.py)

Otwierz `exercises/python/models.py`:

Cel: Zmien `datetime.now` na `datetime.utcnow` ale **tylko w niektorych miejscach**:

1. `/datetime.now<CR>` -- znajdz
2. Widzisz pierwsze wystapienie
3. `ciwdatetime.utcnow` + `Esc` -- hmm, `ciw` zmieni tylko jedno slowo. Lepiej:
4. `cf)datetime.utcnow()` + `Esc` -- zmien od kursora do `)` wlacznie
5. `n` -- nastepne wystapienie
6. `.` -- powtorz zmiane (lub `n` aby pominac)
7. `u` wielokrotnie -- cofnij

### Cwiczenie 10: Przesuwanie + komentarze + indent (polaczenie lekcji 10-14)

Otwierz `exercises/python/calculator.py`:

1. Przejdz do metody `sqrt` (~linia 150)
2. `gcc` -- zakomentuj linie z `def sqrt`
3. `j.` -- zakomentuj nastepna linie (docstring)
4. `j.j.j.j.` -- zakomentuj kolejne linie ciala metody
5. `u` wielokrotnie -- cofnij

Teraz sprobuj efektywniej:
1. `V` na `def sqrt`
2. Zaznacz cala metode (`}` lub `j` wielokrotnie)
3. `gc` -- zakomentuj caly blok jednym ruchem

Ktory sposob wolisz?

## Cwiczenie bonusowe

**Pelny workflow**: Otwierz `exercises/typescript/api-service.ts` i wykonaj te operacje:

1. Przesun metode `uploadFile` (~linia 158) nad `getOrders` uzywajac `V` + `Alt+k`
2. Zmien wszystkie `response.data` na `response.body` uzywajac `n.` pattern
3. Dodaj `console.log` na poczatku kazdej metody publicznej: `o    console.log("method called");` + `Esc`, potem Flash + `.`
4. Cofnij wszystko

**Speed challenge**: Zmierz czas dla kazdej metody:

| Zadanie | Metoda 1 | Metoda 2 |
|---------|----------|----------|
| Zmien 5 wystapien slowa | `:%s/old/new/gc` | `ciw` + `n.n.n.n.` |
| Zakomentuj 10 linii | `V9jgc` | `gcc` + `j.j.j.j.j.j.j.j.j.` |
| Otocz 5 slow cudzyslow | makro `qa ysiw" w q 4@a` | `ysiw"` + `w.w.w.w.` |

Porownaj ktora metoda jest szybsza w kazdym przypadku.

**Podsumowanie modulu 2**: Polacz wieze z lekcji 09-14:

1. `ysiw"` + `.` -- otaczanie i powtarzanie (lekcja 09 + 14)
2. `gcc` + `j.` -- komentowanie linia po linii (lekcja 10 + 14)
3. `s` + operator -- Flash z operatorami (lekcja 11 + 14)
4. makro z `Alt+j` -- automatyczne przesuwanie (lekcja 12 + 14)
5. `:s/` + `inccommand` -- substitution z podgladem (lekcja 13)

## Podsumowanie

### Tabela komend -- przesuwanie linii

| Komenda | Tryb | Opis |
|---------|------|------|
| `Alt+j` | Normal | Przesuwa linie w dol |
| `Alt+k` | Normal | Przesuwa linie w gore |
| `Alt+j` | Visual | Przesuwa blok w dol (zachowuje selekcje) |
| `Alt+k` | Visual | Przesuwa blok w gore (zachowuje selekcje) |
| `J` | Normal | Polacz linie (ze spacja) |
| `gJ` | Normal | Polacz linie (bez spacji) |
| `{count}J` | Normal | Polacz N linii |

### Tabela komend -- dot repeat

| Komenda | Opis |
|---------|------|
| `.` | Powtorz ostatnia zmiane |
| `n.` | Nastepne wyszukiwanie + powtorz zmiane |
| `j.` | Nastepna linia + powtorz zmiane |
| `w.` | Nastepne slowo + powtorz zmiane |

### Co jest "zmiana" (powtarzalne przez `.`)?

| Zmiana | Przyklad |
|--------|----------|
| Delete | `dw`, `dd`, `daw`, `diw`, `d$`, `x` |
| Change | `cw`, `ciw`, `ci"`, `cc`, `C`, `s` |
| Insert | `i`...`Esc`, `a`...`Esc`, `o`...`Esc`, `A`...`Esc` |
| Replace | `r`, `R` |
| Indent | `>>`, `<<` |
| Paste | `p`, `P` |
| Surround | `ysiw"`, `cs"'`, `ds"` (nvim-surround) |
| Comment | `gcc` (Comment.nvim) |

### Podsumowanie Modulu 2 (Intermediate)

Gratulacje! Ukonczyles Modul 2. Oto narzedzia, ktore opanowales:

| Lekcja | Temat | Kluczowa umiejetnosc |
|--------|-------|---------------------|
| 09 | nvim-surround | `ys`/`cs`/`ds` -- otaczanie tekstu |
| 10 | Komentarze i wciecia | `gcc`/`gc` + `>>` z zachowana selekcja |
| 11 | Flash.nvim | `s`/`S`/`r` -- skok, Treesitter, Remote |
| 12 | Makra | `q`/`@` -- nagrywanie i odtwarzanie |
| 13 | Substitution | `:%s` z `inccommand=split` |
| 14 | Przesuwanie i `.` | `Alt+j/k` + dot repeat |

### Co dalej?

W lekcji 15 zaczynasz Modul 3 (Advanced) -- bufory, okna, taby i zarzadzanie
wieloma plikami. Nauczysz sie pracowac z calymi projektami, nie tylko
pojedynczymi plikami.
