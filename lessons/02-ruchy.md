# Lekcja 02: Ruchy (motions)

> Czas: ~35-45 min | Poziom: Beginner

## Cel lekcji

Opanowanie systemu ruchow (motions) w Vimie -- od nawigacji po slowach, przez skakanie do
znakow, az po poruszanie sie miedzy paragrafami i po calym pliku. Motions to fundament
efektywnej pracy -- laczymy je z operatorami w lekcji 03.

## Teoria

### Czym sa motions?

Motion (ruch) to komenda, ktora przenosi kursor z jednego miejsca na drugie. W lekcji 01
poznales najprostsze motions: `h/j/k/l`. Teraz poznasz potezniejsze ruchy, ktore pozwalaja
przeskakiwac o calke slowa, linie czy paragrafy.

**Kluczowa idea**: Motions same w sobie przesuwaja kursor. Ale w polaczeniu z operatorami
(lekcja 03) definiuja **zakres operacji**. Na przyklad `dw` = `d` (delete) + `w` (word) =
usun do nastepnego slowa.

### Ruchy po slowach (word motions)

Vim rozroznia dwa typy "slow":

- **word** (male `w`) -- ciag znakow alfanumerycznych lub podkreslnikow, oddzielony
  interpunkcja lub spacjami. Przyklad: w `hello_world.test()` sa 5 word: `hello_world`, `.`,
  `test`, `(`, `)`
- **WORD** (duze `W`) -- ciag dowolnych znakow oddzielony **tylko** spacjami/tabulatorami.
  Przyklad: w `hello_world.test()` jest 1 WORD: `hello_world.test()`

| Klawisz | Opis | Typ |
|---------|------|-----|
| `w` | Poczatek nastepnego word | word |
| `b` | Poczatek poprzedniego word | word |
| `e` | Koniec biezacego/nastepnego word | word |
| `ge` | Koniec poprzedniego word | word |
| `W` | Poczatek nastepnego WORD | WORD |
| `B` | Poczatek poprzedniego WORD | WORD |
| `E` | Koniec biezacego/nastepnego WORD | WORD |
| `gE` | Koniec poprzedniego WORD | WORD |

**Wizualizacja** -- kursor oznaczony `^`:

```
def calculate_price(base_amount, tax_rate=0.23):
^                            w-->^
                                 w--->^
    b<---^
```

```
self.data["user-name"] = get_value()
^         w-->^                          # word: skacze do [
^                      W------------>^   # WORD: skacze do =
```

**Kiedy uzywac `w` vs `W`**: Uzyj `w` do precyzyjnej nawigacji w kodzie (skakanie po
identyfikatorach, operatorach). Uzyj `W` gdy chcesz szybko przeskoczyc caly "wyraz" z
interpunkcja.

### Ruchy po linii (line motions)

| Klawisz | Opis |
|---------|------|
| `0` | Poczatek linii (kolumna 0) |
| `^` | Pierwszy nie-bialy znak linii (poczatek wciecia) |
| `$` | Koniec linii |
| `g_` | Ostatni nie-bialy znak linii |

**Roznica miedzy `0` i `^`**:
```
    def hello():
^                   # 0 -- kursor na kolumnie 0 (spacja/tab)
    ^               # ^ -- kursor na 'd' (pierwszy nie-bialy znak)
```

**Roznica miedzy `$` i `g_`**:
Zazwyczaj identyczne. `g_` pomija trailing whitespace, `$` nie. W praktyce `$` jest
uzywane znacznie czesciej.

### Ruchy w pionie

| Klawisz | Opis |
|---------|------|
| `j` | Linia nizej |
| `k` | Linia wyzej |
| `{count}j` | N linii nizej, np. `10j` = 10 linii w dol |
| `{count}k` | N linii wyzej, np. `5k` = 5 linii do gory |
| `+` | Pierwszy nie-bialy znak nastepnej linii |
| `-` | Pierwszy nie-bialy znak poprzedniej linii |

> **Tip**: Uzyj `{count}j` / `{count}k` do szybszego poruszania sie w pionie.
> Np. `12j` przenosi 12 linii w dol. Numery linii (`number = true`) pomagaja
> oszacowac ile linii musisz przeskoczyc.

### Ruchy po pliku (file motions)

| Klawisz | Opis |
|---------|------|
| `gg` | Poczatek pliku (linia 1) |
| `G` | Koniec pliku (ostatnia linia) |
| `{count}G` | Skocz do linii N, np. `42G` = linia 42 |
| `:{count}` | Skocz do linii N (Command-line), np. `:42` |
| `{count}%` | Skocz do N% pliku, np. `50%` = polowa pliku |
| `Ctrl+d` | Pol ekranu w dol (down) |
| `Ctrl+u` | Pol ekranu w gore (up) |
| `Ctrl+f` | Caly ekran w dol (forward) |
| `Ctrl+b` | Caly ekran w gore (backward) |

> **Twoja konfiguracja**: `scrolloff = 8` dziala rowniez przy `Ctrl+d` / `Ctrl+u` --
> po przewiniciu kursor nigdy nie bedzie blizej niz 8 linii od krawedzi ekranu.

### Ruchy po paragrafach

Vim traktuje **pusty wiersz** jako separator paragrafow. W kodzie to oznacza bloki
oddzielone pustymi liniami.

| Klawisz | Opis |
|---------|------|
| `{` | Poczatek poprzedniego paragrafu (poprzednia pusta linia) |
| `}` | Poczatek nastepnego paragrafu (nastepna pusta linia) |

To niezwykle przydatne w kodzie -- `}` skacze do nastepnej pustej linii, czyli zazwyczaj
do poczatku nastepnej funkcji/klasy/bloku.

```python
def first():          # <- kursor tutaj
    pass

                      # <- } przeniesie tutaj
def second():
    pass

                      # <- kolejne } przeniesie tutaj
def third():
    pass
```

### Szukanie znakow w linii (character find)

Jedne z najpotezniejszych i najczesciej uzywanych motions:

| Klawisz | Opis |
|---------|------|
| `f{char}` | **Find** -- skocz DO znaku `char` w prawo |
| `F{char}` | Find -- skocz DO znaku `char` w lewo |
| `t{char}` | **Till** -- skocz PRZED znak `char` w prawo |
| `T{char}` | Till -- skocz ZA znak `char` w lewo |
| `;` | Powtorz ostatni `f`/`F`/`t`/`T` w tym samym kierunku |
| `,` | Powtorz ostatni `f`/`F`/`t`/`T` w odwrotnym kierunku |

**Roznica miedzy `f` i `t`**:
```
def calculate(amount, tax_rate):
         ^                         # kursor na 'c' w calculate
         fc-->          ^          # f( -- kursor NA '('
         tc-->        ^            # t( -- kursor PRZED '(' (na 'e')
```

`t` jest szczegolnie przydatny z operatorami. Przyklad: `dt)` = "delete till )" = usun
wszystko az do nawiasu (ale nie sam nawias).

**Powtarzanie z `;` i `,`**:
```
prices = [10.50, 20.75, 30.00, 45.25]
^                                        # kursor na poczatku
f,-->          ^                         # f, -- skocz do pierwszego przecinka
               ;-->          ^           # ; -- skocz do drugiego przecinka
               ;-->                ^     # ; -- skocz do trzeciego
                             ,<--^       # , -- wroc do drugiego
```

### Ruchy po matchujacych parach

| Klawisz | Opis |
|---------|------|
| `%` | Skocz do matchujacego nawiasu: `(`, `)`, `[`, `]`, `{`, `}` |

Umiesz kursor na `(` i nacisnij `%` -- kursor przeskoczy do matchujacego `)`. I odwrotnie.

### Dodatkowe przydatne ruchy

| Klawisz | Opis |
|---------|------|
| `H` | Gora widocznego ekranu (High) |
| `M` | Srodek widocznego ekranu (Middle) |
| `L` | Dol widocznego ekranu (Low) |
| `zz` | Wycentruj ekran na biezacej linii |
| `zt` | Biezaca linia na gorze ekranu |
| `zb` | Biezaca linia na dole ekranu |

> **Uwaga**: Flash.nvim (`s`) to plugin do szybkiego skakania -- zostanie omowiony
> w osobnej lekcji. Tutaj skupiamy sie na natywnych motions Vima, ktore dzialaja
> w kazdej instalacji.

> **Twoja konfiguracja**: `wrap = true` oznacza, ze dlugie linie sa zawijane wizualnie.
> Komendy `j`/`k` poruszaja sie po **liniach logicznych** (zakonczonych `\n`).
> Jesli chcesz poruszac sie po **liniach wizualnych** (zawinieciach), uzyj `gj`/`gk`.

### Motions z count

Prawie kazdy motion mozna poprzedzic liczba:

| Przyklad | Opis |
|----------|------|
| `3w` | 3 slowa do przodu |
| `5j` | 5 linii w dol |
| `2f.` | Drugi znak `.` w linii |
| `10b` | 10 slow do tylu |
| `3}` | 3 paragrafy do przodu |

## Cwiczenia

### Cwiczenie 1: Word motions

Otworz plik:
```
nvim exercises/practice/motions.txt
```

Wpisz (lub upewnij sie ze jest) nastepujacy tekst:
```
name = "John Doe"
email = "john.doe@example.com"
age = 30
is_active = True
user_data = {"name": name, "email": email, "active": is_active}
```

1. Ustaw kursor na `n` w `name` (pierwsza linia)
2. Uzyj `w` aby przejsc slowo po slowie do konca linii -- policz ile razy naciskasz `w`
3. Wroc na poczatek linii (`0`) i uzyj `W` -- policz ile razy naciskasz `W`
4. Porownaj: `w` traktuje `"`, `=` jako osobne slowa; `W` skacze po spacjach
5. Przejdz do linii z `user_data` i przecwicz `w` vs `W` na zlozonym wyrazeniu

### Cwiczenie 2: Line motions

Uzyj pliku `exercises/python/utils.py`:
```
nvim exercises/python/utils.py
```

1. Przejdz do linii z `def format_currency(...)` (linia ~21)
2. Nacisnij `0` -- kursor na poczatku linii (kolumna 0)
3. Nacisnij `^` -- kursor na `d` w `def` (pierwszy nie-bialy znak)
4. Nacisnij `$` -- kursor na koncu linii (po `:`)
5. Przejdz do linii z kodem wewnatrz funkcji (np. linia z `symbols = ...`)
6. Porownaj `0` (na poczatku, przed wcieciem) vs `^` (na pierwszym znaku kodu)

### Cwiczenie 3: File motions

W pliku `exercises/python/calculator.py`:
```
nvim exercises/python/calculator.py
```

1. `gg` -- skocz na poczatek pliku
2. `G` -- skocz na koniec pliku
3. `50G` -- skocz do linii 50
4. `:100` -- skocz do linii 100
5. `Ctrl+d` -- pol ekranu w dol (zwroc uwage na scrolloff)
6. `Ctrl+u` -- pol ekranu w gore
7. `50%` -- skocz do polowy pliku

### Cwiczenie 4: Paragraph motions

W pliku `exercises/python/utils.py`:

1. Ustaw kursor na poczatku pliku (`gg`)
2. Nacisnij `}` -- przeskocz do nastepnego pustego wiersza
3. Powtorz `}` kilka razy -- obserwuj jak skacze miedzy funkcjami
4. Uzyj `{` zeby wrocic do poprzednich blokow
5. Sprobuj `3}` -- przeskocz 3 bloki na raz

### Cwiczenie 5: Character find

Wpisz w `exercises/practice/motions.txt` nastepujaca linie:
```
prices = [10.50, 20.75, 30.00, 45.25, 99.99]
```

1. Ustaw kursor na `p` w `prices` (`0`)
2. `f=` -- skocz do znaku `=`
3. `f,` -- skocz do pierwszego przecinka
4. `;` -- nastepny przecinek
5. `;` -- kolejny przecinek
6. `,` -- wroc do poprzedniego przecinka
7. `0` -- wroc na poczatek
8. `f9` -- pierwszy `9`
9. `;` -- nastepny `9`
10. `F.` -- szukaj `.` w lewo

### Cwiczenie 6: Find vs Till

W pliku `exercises/python/calculator.py`, znajdz linie z:
```python
def add(self, a: float, b: float) -> float:
```

1. Ustaw kursor na `d` w `def`
2. `f(` -- kursor NA `(`
3. `0` -- wroc na poczatek
4. `t(` -- kursor PRZED `(` (na `d` z `add`)
5. `0` -- wroc na poczatek
6. `f:` -- pierwszy dwukropek (po `a`)
7. `;` -- drugi dwukropek (po `b`)
8. `;` -- trzeci dwukropek (na koncu linii)

### Cwiczenie 7: Matchujace nawiasy

W pliku `exercises/python/calculator.py`:

1. Znajdz linie z `def chain(self, initial: float, *operations: tuple[str, float]) -> float:`
2. Ustaw kursor na `(` po `chain`
3. Nacisnij `%` -- kursor przeskoczy na matchujacy `)`
4. Nacisnij `%` ponownie -- wroci na `(`
5. Wejdz do ciala metody i znajdz `dispatch = {`
6. Ustaw kursor na `{`
7. `%` -- skocz do zamykajacego `}`

### Cwiczenie 8: Scroll i ekran

W dowolnym dluzszym pliku (np. `exercises/python/calculator.py`):

1. `gg` -- poczatek pliku
2. `Ctrl+d` -- pol ekranu w dol (obserwuj jak scrolloff utrzymuje kontekst)
3. `Ctrl+d` -- jeszcze pol ekranu
4. `zz` -- wycentruj ekran na biezacej linii
5. `H` -- kursor na gorze ekranu
6. `L` -- kursor na dole ekranu
7. `M` -- kursor na srodku ekranu
8. `zt` -- obecna linia na gorze ekranu

## Cwiczenie bonusowe

Otwórz `exercises/python/models.py` i wykonaj nastepujace zadania uzywajac TYLKO motions
z tej lekcji (bez strzalek, bez wyszukiwania `/`):

1. Przejdz do klasy `Order` (uzyj `}` do skakania miedzy blokami)
2. Znajdz metode `cancel` (uzyj `}` lub `/cancel` -- ale sprobuj bez szukania!)
3. W linii `if self.status in (OrderStatus.SHIPPED, OrderStatus.DELIVERED):` uzyj `f(` i `%`
   zeby przeskoczyc miedzy nawiasami
4. Przejdz do metody `add_item` uzywajac `{` (w gore)
5. W sygnaturze `def add_item(self, product: Product, quantity: int) -> OrderItem:` policz
   ile razy trzeba nacisnac `w` zeby przejsc od `def` do konca linii
6. Policz ile razy trzeba nacisnac `W` -- powinno byc mniej

**Wyzwanie**: Nawiguj po calym pliku uzywajac **tylko**: `w`, `b`, `e`, `W`, `B`, `f`, `t`,
`;`, `{`, `}`, `gg`, `G`, `0`, `$`, `^`. Zadnych strzalek, zadnego `h/j/k/l`!

## Podsumowanie

### Nauczone komendy

| Kategoria | Komenda | Opis |
|-----------|---------|------|
| Word | `w` / `b` / `e` | Nastepne/poprzednie/koniec word |
| WORD | `W` / `B` / `E` | Nastepne/poprzednie/koniec WORD |
| Linia | `0` / `^` / `$` | Poczatek/pierwszy znak/koniec linii |
| Plik | `gg` / `G` / `{n}G` | Poczatek/koniec/linia N |
| Paragraf | `{` / `}` | Poprzedni/nastepny paragraf |
| Szukanie znaku | `f` / `F` / `t` / `T` | Find/Till w prawo/lewo |
| Powtarzanie | `;` / `,` | Powtorz/odwroc ostatni find |
| Para | `%` | Matchujacy nawias |
| Scroll | `Ctrl+d/u/f/b` | Pol/caly ekran dol/gora |
| Ekran | `H` / `M` / `L` | Gora/srodek/dol ekranu |
| Centrowanie | `zz` / `zt` / `zb` | Centruj/gora/dol |
| Count | `{n}{motion}` | Powtorz motion N razy |

### Konfiguracja uzyta w tej lekcji

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| `scrolloff` | `8` | Kontekst 8 linii przy scrollowaniu |
| `wrap` | `true` | Dlugie linie zawijane wizualnie |
| `number` | `true` | Numery linii pomagaja w `{n}G` |

### Co dalej?

W **lekcji 03** polaczysz motions z **operatorami** (`d`, `c`, `y`). Poznasz formule
`operator + motion` -- fundament edycji w Vimie. Na przyklad `dw` (usun slowo),
`c$` (zmien do konca linii), `y3j` (kopiuj 3 linie w dol).
