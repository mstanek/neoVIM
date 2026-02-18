# Lekcja 12: Makra -- automatyzacja powtarzalnych edycji

> Czas: ~35-45 min | Poziom: Intermediate

## Cel lekcji

Opanowanie systemu makr w Vimie -- nagrywanie, odtwarzanie, edycja i zaawansowane
techniki (makra rekurencyjne, makra z wyszukiwaniem). Makra to najpotezniejsze narzedzie
automatyzacji wbudowane w Vima.

## Teoria

### Czym sa makra?

Makro to nagrana sekwencja klawiszy, ktora mozesz odtworzyc dowolna ilosc razy.
Podczas gdy `.` (dot repeat) powtarza ostatnia **pojedyncza zmiane**, makro powtarza
**dowolnie zlozony ciag operacji** -- nawigacja, edycja, wyszukiwanie, wszystko.

### Nagrywanie makra: `q{reg}`

| Klawisz | Opis |
|---------|------|
| `q{reg}` | Rozpocznij nagrywanie do rejestru `{reg}` (a-z) |
| (wykonaj operacje) | Kazde nacisniecie klawisza jest nagrywane |
| `q` | Zakoncz nagrywanie |

**Rejestry** to po prostu litery od `a` do `z`. Kazdy rejestr przechowuje jedno makro.
Mozesz miec 26 roznych makr jednoczesnie.

```
Przyklad:
1. qa        -- zacznij nagrywanie do rejestru 'a'
2. 0         -- idz na poczatek linii
3. i# <Esc>  -- wstaw "# " na poczatku
4. j         -- przejdz do nastepnej linii
5. q         -- zakoncz nagrywanie
```

Podczas nagrywania w lualine pojawi sie informacja o nagrywaniu (np. `recording @a`).

### Odtwarzanie makra: `@{reg}`

| Komenda | Opis |
|---------|------|
| `@{reg}` | Odtworz makro z rejestru `{reg}` |
| `@@` | Odtworz ostatnio uzyte makro (repeat last) |
| `{count}@{reg}` | Odtworz makro `{count}` razy |

```
Przyklad (kontynuacja):
@a         -- dodaj "# " do nastepnej linii
@@         -- powtorz (jeszcze jedna linia)
5@a        -- powtorz 5 razy (5 kolejnych linii)
```

### Zasady nagrywania dobrych makr

Makra sa potezne, ale wymagaja dyscypliny przy nagrywaniu. Zle nagrane makro nie zadziala
na kolejnych liniach. Oto kluczowe zasady:

**1. Zaczynaj od przewidywalnej pozycji**

```
ZLE:  qa  dw  q        -- kursor moze byc gdziekolwiek w linii
DOBRZE: qa  0  dw  q   -- 0 na poczatek linii -- zawsze to samo
```

**2. Koncz w pozycji gotowej do powtorzenia**

```
ZLE:  qa  0  i# <Esc>  q         -- kursor zostaje na tej samej linii
DOBRZE: qa  0  i# <Esc>  j  q    -- j przenosi na nastepna linie
```

**3. Uzywaj bezwzglednych ruchow, nie wzglednych**

```
ZLE:  qa  wwww  diw  q      -- zaklada dokladnie 4 slowa
DOBRZE: qa  0f=ldiw  q      -- f= szuka znaku = niezaleznie od pozycji
```

**4. Uzywaj wyszukiwania zamiast liczenia**

```
ZLE:  qa  5j  dd  q          -- zaklada dokladnie 5 linii
DOBRZE: qa  /pattern<CR>  dd  q  -- szuka wzorca
```

### Makro z count: `{count}@{reg}`

Makro mozesz odtworzyc wielokrotnie podajac count:

```
10@a     -- odtworz makro 'a' 10 razy
100@a    -- odtworz 100 razy
```

**Wazne**: Jesli makro napotka blad (np. wyszukiwanie nie znajdzie wzorca, kursor
na koncu pliku), makro **zatrzymuje sie**. To jest feature, nie bug -- pozwala na
bezpieczne uzywanie duzych countow.

```
Bezpieczne podejscie:
1. Nagraj makro na jednej linii
2. Przetestuj: @a -- dziala na nastepnej linii?
3. 1000@a -- odtworz "duzo" razy -- zatrzyma sie samo na koncu danych
```

### Makra rekurencyjne

Makro rekurencyjne to makro, ktore **wywoluje samo siebie** na koncu:

```
1. qaq       -- wyczysc rejestr 'a' (nagraj puste makro)
2. qa        -- zacznij nagrywanie do 'a'
3. 0         -- poczatek linii
4. i# <Esc>  -- wstaw "# "
5. j         -- nastepna linia
6. @a        -- wywolaj makro 'a' (rekurencja!)
7. q         -- zakoncz nagrywanie
```

**Dlaczego `qaq` na poczatku?** Kiedy nagrywasz `qa...@a...q`, w kroku 6 odtwarzasz
stara zawartosc rejestru `a`. Czyszczac go najpierw (`qaq` = nagraj puste makro do `a`),
zapewniasz ze `@a` w kroku 6 nie zrobi nic -- ale po zakonczeniu nagrywania, `a` bedzie
juz zawierac pelne makro z rekurencja.

Makro rekurencyjne dziala do momentu bledu (koniec pliku, nie znaleziono wzorca).

### Podgladanie makr: `:reg {reg}`

Makra sa przechowywane w rejestrach -- tych samych, co yank/paste:

```vim
:reg a       -- pokaz zawartosc rejestru 'a'
:reg abc     -- pokaz rejestry a, b, c
:reg         -- pokaz wszystkie rejestry
```

Wyswietla sie cos takiego:
```
"a   0i# ^[j
```

Gdzie `^[` to Escape. To jest dokladna sekwencja klawiszy nagrana w makrze.

### Edycja makr

Poniewaz makra sa w rejestrach, mozesz je edytowac jak zwykly tekst:

**Metoda: paste -> edit -> yank back**

```
1. "ap       -- wklej zawartosc rejestru 'a' (paste)
2.           -- edytuj tekst -- to jest Twoje makro jako tekst
3. 0"ay$     -- zaznacz cala linie i skopiuj do rejestru 'a'
4. dd        -- usun linie z makrem
```

**Alternatywna metoda: `:let`**

```vim
:let @a = "0i# \<Esc>j"    -- ustaw rejestr 'a' bezposrednio
```

Uwaga na specjalne znaki: `\<Esc>` to Escape, `\<CR>` to Enter.

### Dopisywanie do makra: `q{REG}` (duza litera)

Uzyj duzej litery rejestru, aby **dopisac** do istniejacego makra:

```
qa  ...  q    -- nagraj makro do 'a'
qA  ...  q    -- dopisz do makra 'a' (duze A!)
```

To przydatne, gdy zapomniales dodac `j` na koncu makra:
```
qA  j  q      -- dopisz 'j' do makra 'a'
```

### Typowe wzorce makr

**Wzorzec 1: Transformacja linia po linii**

```
qa          -- nagrywaj
0           -- poczatek linii
(edycje)    -- transformuj linie
j           -- nastepna linia
q           -- stop
```

**Wzorzec 2: Wyszukiwanie i transformacja**

```
qa          -- nagrywaj
/pattern<CR>-- znajdz nastepne wystapienie
(edycje)    -- transformuj
q           -- stop
```

**Wzorzec 3: Transformacja z wieloma liniami**

```
qa          -- nagrywaj
(nawiguj do poczatku bloku)
(edycje wieloliniowe)
(nawiguj do nastepnego bloku)
q           -- stop
```

## Cwiczenia

### Cwiczenie 1: CSV to JSON (exercises/practice/macros.txt)

Otwierz `exercises/practice/macros.txt`. Exercise 1 (linie 10-21) -- wiersz naglowkowy +
10 wierszy CSV. Cel: zamienic kazdy wiersz danych na obiekt JSON.

Z `Alice,30,Warsaw` na `{"name": "Alice", "age": "30", "city": "Warsaw"}`

1. Usun wiersz naglowkowy (`name,age,city`) -- `dd`
2. Ustaw kursor na linii `Alice,30,Warsaw`
3. Nagraj makro:
   ```
   qa                    -- start recording to 'a'
   0                     -- poczatek linii
   i{"name": "<Esc>      -- wstaw poczatek JSON
   f,                    -- znajdz pierwszy przecinek
   s", "age": "<Esc>     -- zamien przecinek na separator JSON
   f,                    -- znajdz drugi przecinek
   s", "city": "<Esc>    -- zamien drugi przecinek
   A"}<Esc>              -- dodaj zamkniecie na koncu
   j                     -- nastepna linia
   q                     -- stop recording
   ```
4. Przetestuj: `@a` -- sprawdz czy dziala na `Bob,25,Krakow`
5. `8@a` -- odtworz na pozostalych 8 liniach

### Cwiczenie 2: Dodawanie cudzyslow (exercises/practice/macros.txt)

Exercise 2 (linie 26-35) -- `key = value` do `key = "value"`:

1. Kursor na `host = localhost`
2. Nagraj makro:
   ```
   qa
   0f=ll         -- znajdz '=', przeskocz o 2 (za spacje)
   i"<Esc>       -- wstaw " przed wartoscia
   A"<Esc>       -- dodaj " na koncu
   j             -- nastepna linia
   q
   ```
3. `9@a` -- odtworz na pozostalych liniach

### Cwiczenie 3: Deklaracje zmiennych (exercises/practice/macros.txt)

Exercise 3 (linie 40-49) -- z `userName` na `const userName: string = "";`:

1. Kursor na `userName`
2. Nagraj makro:
   ```
   qa
   0                   -- poczatek linii
   iconst <Esc>        -- wstaw "const " przed nazwa
   A: string = "";<Esc>  -- dodaj typ i wartosc na koncu
   j                   -- nastepna linia
   q
   ```
3. `9@a` -- odtworz na pozostalych

### Cwiczenie 4: List to dict (exercises/practice/macros.txt)

Exercise 4 (linie 54-63) -- z `name: Alice Johnson` na `"name": "Alice Johnson",`:

1. Kursor na `name: Alice Johnson`
2. Nagraj makro:
   ```
   qa
   0i"<Esc>            -- wstaw " na poczatku
   f:i"<Esc>           -- wstaw " przed dwukropkiem
   la "<Esc>           -- przeskocz dwukropek, wstaw spacje i "
   A",<Esc>            -- dodaj ", na koncu
   j
   q
   ```
3. `9@a`

### Cwiczenie 5: Error handling (exercises/practice/macros.txt)

Exercise 5 (linie 70-74) -- otocz kazda linie blokiem try/except. To bardziej zlozone makro:

1. Kursor na `result = fetchData(url)`
2. Nagraj makro:
   ```
   qa
   0                       -- poczatek linii
   Otry:<Esc>              -- nowa linia powyzej: "try:"
   jI    <Esc>             -- wcij oryginalna linie (4 spacje)
   oexcept Exception as e:<Esc>  -- nowa linia: except
   o    logger.error(f"Failed: {e}")<Esc>  -- nowa linia: logger
   jj                      -- przeskocz do nastepnego task
   q
   ```
3. `4@a`

**Uwaga**: To makro jest trudne do nagrania bezbladnie. Jesli sie nie uda za pierwszym
razem -- `u` i probuj ponownie. Mozesz tez zrobic prostsze makro i dokonczyc recznie.

### Cwiczenie 6: Edycja makra (exercises/practice/macros.txt)

1. Nagraj proste makro do rejestru `b`: `qb0i// <Esc>jq`
2. Sprawdz: `:reg b` -- zobaczysz `0i// ^[j`
3. Otwierz pusta linie, wklej rejestr: `"bp`
4. Zmien `//` na `#` (bo chcesz komentarze Python)
5. Skopiuj z powrotem: `0"by$`
6. Usun linie: `dd`
7. Przetestuj nowe makro: `@b`

### Cwiczenie 7: Makro rekurencyjne (exercises/practice/macros.txt)

Exercise 6 (linie 78-95) -- dodaj `- ` przed kazda niepusta linia:

1. `qaq` -- wyczysc rejestr `a`
2. Kursor na pierwszej linii danych (`Shopping list...`)
3. Nagraj makro rekurencyjne:
   ```
   qa
   0i- <Esc>    -- wstaw "- " na poczatku
   j             -- nastepna linia
   @a            -- wywolaj siebie (rekurencja)
   q
   ```
4. `@a` -- makro automatycznie przetworzy wszystkie linie do konca pliku

**Problem**: To makro doda `- ` rowniez do pustych linii. Lepsze podejscie:
```
qa
:s/^/- /<CR>    -- zamien poczatek linii na "- "
j               -- nastepna linia
@a              -- rekurencja
q
```

### Cwiczenie 8: Makro na realnym kodzie (exercises/python/utils.py)

Otwierz `exercises/python/utils.py`. Dodaj logowanie do kazdej funkcji:

1. Kursor na `def format_currency` (~linia 21)
2. Nagraj makro:
   ```
   qa
   /def <CR>          -- znajdz nastepna definicje funkcji
   j                  -- nastepna linia (w ciele funkcji)
   O    print(f"DEBUG: entering function")<Esc>  -- dodaj log
   q
   ```
3. `@a` powtarzaj -- makro bedzie szukac `def ` i dodawac log
4. Cofnij wszystko: wielokrotne `u`

## Cwiczenie bonusowe

**Wyzwanie CSV -> JSON (pelna konwersja)**: W `exercises/practice/macros.txt`, Exercise 1:

1. Skonwertuj wszystkie wiersze CSV do formatu JSON
2. Dodaj na poczatku `[` a na koncu `]`
3. Zamien ostatni `,` na nic (ostatni element tablicy nie ma przecinka)
4. Wynik powinien byc poprawnym JSON -- zweryfikuj mentalnie strukture

**Wyzwanie: makro w makrze**: Nagraj makro `a` ktore robi prosta edycje, i makro `b`
ktore wywoluje `@a` wielokrotnie z dodatkowa logika (np. przeskakuje puste linie).

## Podsumowanie

### Tabela komend

| Komenda | Opis |
|---------|------|
| `q{reg}` | Rozpocznij nagrywanie makra do rejestru |
| `q` | Zakoncz nagrywanie |
| `@{reg}` | Odtworz makro z rejestru |
| `@@` | Powtorz ostatnio odtworzone makro |
| `{count}@{reg}` | Odtworz makro N razy |
| `q{REG}` (duza litera) | Dopisz do istniejacego makra |
| `:reg {reg}` | Pokaz zawartosc rejestru (podejrzyj makro) |
| `"ap` | Wklej makro jako tekst (do edycji) |
| `"ay$` | Skopiuj edytowane makro z powrotem do rejestru |
| `qaq` | Wyczysc rejestr 'a' (nagraj puste makro) |

### Zasady dobrych makr

| Zasada | Przyklad |
|--------|----------|
| Zaczynaj od `0` lub `^` | Przewidywalna pozycja startowa |
| Koncz `j` lub wyszukiwaniem | Gotowy do powtorzenia |
| Uzywaj `f`/`/` zamiast `w` wielokrotnie | Niezaleznosc od dlugosci |
| Testuj na jednej linii przed `{count}@` | Unikanie masowych bledow |
| Duzy count + auto-stop | `1000@a` zatrzyma sie na bledzie |

### Co dalej?

W nastepnej lekcji (13) poznasz substitution (`:s/old/new/`) -- potezne narzedzie
wyszukiwania i zamiany z regex, grupami, backreferences i specjalna przewaga Twojej
konfiguracji: `inccommand=split` daje Ci podglad zmian na zywo!
