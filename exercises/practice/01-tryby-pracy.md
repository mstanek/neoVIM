# Cwiczenie 01: Tryby pracy

> Powiazana lekcja: `lessons/01-tryby-pracy.md`

## Instrukcje
- Tryby: Normal (`Esc`), Insert (`i`, `a`, `o`, `O`, `I`, `A`), Visual (`v`, `V`, `Ctrl+v`), Command-line (`:`)
- Nawigacja: `h/j/k/l` (lewo/dol/gora/prawo)
- Zapis: `:w`, wyjscie: `:q`, `:wq`, `:q!`
- Obserwuj lualine (pasek na dole) -- pokazuje aktualny tryb

## Cwiczenie 1: Przelaczanie trybów w sekwencji

Otworz ten plik w Neovimie. Wykonaj nastepujaca sekwencje i obserwuj tryb w lualine:

1. `Esc` -- upewnij sie ze jestes w Normal
2. `i` -- wejdz w Insert, wpisz: `test`
3. `Esc` -- wroc do Normal
4. `a` -- Append, wpisz: ` dopisany`
5. `Esc` -- wroc do Normal
6. `v` -- Visual char, przesun kursor `lll`
7. `Esc` -- wroc do Normal
8. `V` -- Visual line
9. `Esc` -- wroc do Normal
10. `:` -- Command-line, wpisz `echo "OK"`, Enter
11. `Esc` -- wroc do Normal

Sprobuj powtorzyc sekwencje bez patrzenia na instrukcje.

## Cwiczenie 2: Sześć sposobow wejscia w Insert

Ponizej znajduje sie blok tekstu. Uzyj kazdego z szesciu sposobow wejscia w Insert
w odpowiednim kontekscie. Po kazdej edycji wroc do Normal (`Esc`).

```
DOPISZ_PRZED_KURSOREM tutaj stoi tekst do edycji
rozpocznij pisanie NA_KONCU_LINII
NA_POCZATKU_LINII powinien pojawic sie nowy tekst
tekst DOPISZ_ZA_ZNAKIEM pod kursorem
```

Zadania:
1. Ustaw kursor na `t` w `tutaj`. Nacisnij `i`, wpisz `[wstawiono] `, `Esc`
2. Przejdz do linii 2. Nacisnij `A`, wpisz ` -- gotowe`, `Esc`
3. Przejdz do linii 3. Nacisnij `I`, wpisz `>>> `, `Esc`
4. Ustaw kursor na `Z` w `DOPISZ_ZA_ZNAKIEM`. Nacisnij `a`, wpisz `_TEKST`, `Esc`
5. Na dowolnej linii nacisnij `o` -- otworzy nowa linie ponizej. Wpisz `// nowa linia`, `Esc`
6. Na dowolnej linii nacisnij `O` -- otworzy nowa linie powyzej. Wpisz `// linia powyzej`, `Esc`

## Cwiczenie 3: Nawigacja h/j/k/l po kodzie

Nawiguj po ponizszym kodzie uzywajac WYLACZNIE `h/j/k/l`. Znajdz i policz ile razy
wystepuje slowo `result`. Nie uzywaj strzalek ani myszy!

```python
def process_items(items):
    result = []
    for item in items:
        if item.is_valid():
            processed = transform(item)
            result.append(processed)
    return result

def merge_results(result_a, result_b):
    merged_result = []
    for item in result_a:
        merged_result.append(item)
    for item in result_b:
        merged_result.append(item)
    return merged_result

def get_final_result(data):
    items = parse(data)
    result = process_items(items)
    return result
```

Odpowiedz: ile razy wystepuje `result` (sam lub jako czesc nazwy)?

## Cwiczenie 4: Nawigacja z count prefix

W ponizszym bloku tekstu cwicz nawigacje z liczba przed `j`/`k`:

```
Linia  1: start
Linia  2: --
Linia  3: --
Linia  4: --
Linia  5: cel A (uzyj 4j z linii 1)
Linia  6: --
Linia  7: --
Linia  8: --
Linia  9: --
Linia 10: cel B (uzyj 5j z cel A)
Linia 11: --
Linia 12: --
Linia 13: cel C (uzyj 3j z cel B)
Linia 14: --
Linia 15: koniec (uzyj 2k z konca zeby wrocic do cel C)
```

Zadania:
1. Ustaw kursor na "Linia 1". Nacisnij `4j` -- powinien ladowac na cel A
2. Z cel A nacisnij `5j` -- powinien ladowac na cel B
3. Z cel B nacisnij `3j` -- cel C
4. Z konca `2k` -- wroc do cel C

## Cwiczenie 5: Komendy Ex -- zapis, otwarcie, skakanie

Wykonaj ponizsze komendy w trybie Command-line (`:`):

1. `:w` -- zapisz biezacy plik
2. `:e exercises/python/utils.py` -- otworz plik Pythona
3. `:25` -- skocz do linii 25
4. `:1` -- skocz na poczatek pliku
5. `:$` -- skocz na koniec pliku
6. `:e #` -- wroc do poprzedniego pliku (ten plik cwiczeniowy)
7. `:w /tmp/test-tryby.md` -- zapisz kopie pod inna nazwa

## Cwiczenie 6: Rozpoznawanie trybu po zachowaniu

Ponizej lista zachowan. Okresl, w jakim trybie jestes, jesli dane klawisze daja opisany efekt:

1. Naciskasz `d` i znika litera -- jestes w trybie: ___________
2. Naciskasz `d` i nic nie znika, Vim czeka -- jestes w trybie: ___________
3. Naciskasz `j` i kursor idzie w dol -- jestes w trybie: ___________
4. Naciskasz `j` i w tekscie pojawia sie litera `j` -- jestes w trybie: ___________
5. Widzisz `:` na dole ekranu (lub popup noice) -- jestes w trybie: ___________
6. Tekst jest podswietlony na niebiesko -- jestes w trybie: ___________

Odpowiedzi: 1-Insert, 2-Normal, 3-Normal, 4-Insert, 5-Command-line, 6-Visual

## Cwiczenie 7: Edycja wieloliniowa

Przepisz ponizszy blok tak, aby kazda linia zawierala poprawna skladnie Pythona.
Uzywaj `i`, `a`, `A`, `o`, `I` w odpowiednich momentach. Po kazdej edycji wracaj do Normal.

Oryginal (skopiuj do nowego pliku lub edytuj ponizej):
```
x = 10
y = 20

print("x wynosi: " x)
print("y wynosi: " y)
```

Cel:
```
x = 10
y = 20
z = x + y
print("x wynosi: " + str(x))
print("y wynosi: " + str(y))
print("z wynosi: " + str(z))
```

Wskazowki:
- Uzyj `o` zeby dodac linie `z = x + y` pod `y = 20`
- Uzyj `A` na linii z `print("x wynosi: "` zeby dopisac ` + str(x))`
- Uzyj `o` na koncu zeby dodac nowa linie z `print("z...")`

## Cwiczenie bonusowe

Otworz plik `exercises/typescript/interfaces.ts` i wykonaj nastepujace zadania
uzywajac WYLACZNIE `h/j/k/l` + `i/a/o/O/A/I` (bez zadnych innych komend):

1. Znajdz interface `User` nawigujac `j`/`k`
2. Dodaj nowe pole `phone: string;` pod polem `email` (uzyj `o`)
3. Znajdz interface `Product` nawigujac `j`
4. Na linii z `price: number;` dopisz komentarz ` // in cents` na koncu (uzyj `A`)
5. Dodaj nowy interface powyzej `Product` (uzyj `O`):
   ```
   interface Category {
     id: number;
     name: string;
   }
   ```
6. Zapisz plik (`:w`) i cofnij wszystkie zmiany (`u` wielokrotnie)

Wyzwanie: zmierz czas. Powtorz cwiczenie i sprobuj zrobic to szybciej.
