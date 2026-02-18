# Lekcja 01: Tryby pracy

> Czas: ~30-45 min | Poziom: Beginner

## Cel lekcji

Zrozumienie fundamentalnej koncepcji Vima -- trybów pracy. Nauczysz sie przechodzic miedzy trybami
Normal, Insert, Visual i Command-line, a takze wykonasz pierwsze ruchy kursorem za pomoca `h/j/k/l`.

## Teoria

### Dlaczego tryby?

Vim dziala inaczej niz typowy edytor. W VSCode, Sublime czy nano kazdy nacisniety klawisz
wstawia tekst. W Vimie to zachowanie dotyczy **tylko trybu Insert**. W trybie Normal klawisze
sa **komendami** -- `d` kasuje, `y` kopiuje, `w` przesuwa kursor o slowo. Dzieki temu cala
klawiatura staje sie zestawem skrotow bez potrzeby trzymania Ctrl/Alt/Cmd.

### Cztery glowne tryby

| Tryb | Ikona w lualine | Jak wejsc | Cel |
|------|-----------------|-----------|-----|
| **Normal** | `NORMAL` | `Esc` z dowolnego trybu | Nawigacja, operacje na tekscie |
| **Insert** | `INSERT` | `i`, `a`, `o`, `O`, `A`, `I` | Wpisywanie tekstu |
| **Visual** | `VISUAL` / `V-LINE` / `V-BLOCK` | `v`, `V`, `Ctrl+v` | Zaznaczanie tekstu |
| **Command-line** | `COMMAND` | `:` | Komendy Ex (zapis, wyjscie, wyszukiwanie) |

> **Twoja konfiguracja**: Masz `showmode = false`, wiec Vim **nie wyswietla** trybu w dolnym
> rogu ekranu. Zamiast tego **lualine** pokazuje aktualny tryb w pasku statusu na dole --
> kolorowy segment po lewej stronie zmienia sie w zaleznosci od trybu.

### Tryb Normal -- domyslny i najwazniejszy

Kiedy otwierasz plik, jestes w trybie Normal. To jest Twoj "dom" -- wracasz tu po kazdej
operacji. Wiekszosci czasu w Vimie spedzisz wlasnie tutaj, nawigujac i manipulujac tekstem.

**Zasada**: Jesli nie wiesz w jakim jestes trybie -- nacisnij `Esc`. Zawsze wroci Cie do Normal.

### Wchodzenie w tryb Insert

Istnieje wiele sposobow przejscia do trybu Insert. Kazdy umieszcza kursor w innym miejscu:

| Klawisz | Opis | Kiedy uzywac |
|---------|------|--------------|
| `i` | **Insert** przed kursorem | Najczesciej -- wstawiasz tekst w miejscu kursora |
| `a` | **Append** za kursorem | Chcesz dopisac cos za biezacym znakiem |
| `I` | Insert na poczatku linii (pierwszy nie-bialy znak) | Dodajesz cos na poczatku linii |
| `A` | Append na koncu linii | Dopisujesz cos na koniec linii |
| `o` | **Open** nowa linie ponizej | Tworzysz nowa linie i od razu piszesz |
| `O` | Open nowa linie powyzej | j.w., ale powyzej biezacej linii |

**Tip**: Raczej uzywaj `i`/`a` niz strzalek do pozycjonowania kursora w trybie Insert.
Jesli musisz przesunac kursor daleko -- wroc do Normal (`Esc`), nawiguj, potem wejdz w Insert.

### Wychodzenie z trybu Insert

| Klawisz | Opis |
|---------|------|
| `Esc` | Standardowy sposob powrotu do Normal |
| `Ctrl+[` | Alternatywa dla `Esc` (ten sam keycode) |
| `Ctrl+c` | Wraca do Normal, ale nie wyzwala autocmd InsertLeave |

**Rekomendacja**: Uzywaj `Esc`. Jest jednoznaczny i zawsze dziala poprawnie.

### Tryb Visual -- zaznaczanie tekstu

Tryb Visual pozwala zaznaczac tekst, a nastepnie wykonywac na nim operacje. Trzy warianty:

| Klawisz | Wariant | Opis |
|---------|---------|------|
| `v` | Character-wise | Zaznaczanie po znakach |
| `V` | Line-wise | Zaznaczanie calych linii |
| `Ctrl+v` | Block-wise | Zaznaczanie prostokątnego bloku (kolumny) |

Visual mode zostanie szczegolowo omowiony w lekcji 05.

### Tryb Command-line

Nacisnij `:` w trybie Normal, aby wejsc w tryb Command-line. Na dole ekranu pojawi sie
prompt `:`, w ktorym mozesz wpisywac komendy:

| Komenda | Opis |
|---------|------|
| `:w` | Zapisz plik (write) |
| `:q` | Zamknij bufor (quit) |
| `:wq` lub `:x` | Zapisz i zamknij |
| `:q!` | Zamknij bez zapisywania (force quit) |
| `:e nazwa_pliku` | Otworz plik |
| `:{numer}` | Skocz do linii o podanym numerze |

> **Twoja konfiguracja**: Masz plugin **noice.nvim**, wiec linia komend moze byc wyswietlana
> jako popup zamiast na samym dole ekranu. Zachowanie jest identyczne, zmienia sie tylko wyglad.

### Poruszanie sie w trybie Normal: h/j/k/l

Vim uzywa klawiszy `h`, `j`, `k`, `l` zamiast strzalek:

```
        k
        ^
        |
  h <---+---> l
        |
        v
        j
```

| Klawisz | Kierunek | Mnemonic |
|---------|----------|----------|
| `h` | Lewo | Najbardziej na lewo z czworki |
| `j` | Dol | `j` wyglada jak strzalka w dol (haczykowata) |
| `k` | Gora | `k` wyglada jak strzalka w gore |
| `l` | Prawo | Najbardziej na prawo z czworki |

**Dlaczego nie strzalki?** Klawisze `h/j/k/l` sa w home row -- palce nie musza sie ruszac.
Po kilku dniach praktyki nawigacja staje sie odruchowa i znacznie szybsza.

> **Twoja konfiguracja**: `scrolloff = 8` oznacza, ze kursor nigdy nie zblizy sie do gornej
> ani dolnej krawedzi ekranu na mniej niz 8 linii. Kiedy przesuwasz kursor w dol (`j`),
> ekran zaczyna sie przewijac zanim kursor dotrze do ostatniej widocznej linii. To daje
> lepszy kontekst -- zawsze widzisz co jest przed i za kursorem.

> **Twoja konfiguracja**: `number = true` wlacza numery linii po lewej stronie. Dzieki temu
> latwiej orientujesz sie w pliku i mozesz skakac do konkretnych linii (`:42` przenosi do linii 42).

### which-key -- Twoj przewodnik po skrotach

> **Twoja konfiguracja**: Masz zainstalowany plugin **which-key.nvim**. Kiedy nacisniesz
> klawisz Leader (`Space`) i poczekasz chwile, pojawi sie popup ze wszystkimi dostepnymi
> skrotami. To doskonale narzedzie do odkrywania nowych komend!
>
> Sprobuj: nacisnij `Space` i poczekaj sekunde. Zobaczysz liste grup skrotow.

### Schemat przejsc miedzy trybami

```
                    i, a, o, O, I, A
            Normal ──────────────────► Insert
              │  ▲                      │
              │  │         Esc          │
              │  └──────────────────────┘
              │
              │  v, V, Ctrl+v           Esc
              ├──────────────► Visual ──────┐
              │                             │
              │  :                     Esc  │
              ├──────────────► Command ─────┤
              │                             │
              ◄─────────────────────────────┘
```

Kazdy tryb wraca do Normal przez `Esc`. Nie ma bezposredniego przejscia z Insert do Visual
(musisz najpierw wrocic do Normal).

## Cwiczenia

Otworz plik cwiczeniowy:
```
nvim exercises/practice/motions.txt
```

> Jesli plik jeszcze nie istnieje, stworz go komenda `:e exercises/practice/motions.txt`
> i zacznij wpisywac tekst z cwiczen.

### Cwiczenie 1: Rozpoznawanie trybu

1. Otworz dowolny plik (`nvim exercises/practice/motions.txt`)
2. Spójrz na lualine (pasek na dole) -- powinno pisac `NORMAL`
3. Nacisnij `i` -- tryb zmieni sie na `INSERT`
4. Nacisnij `Esc` -- wroc do `NORMAL`
5. Nacisnij `v` -- tryb zmieni sie na `VISUAL`
6. Nacisnij `Esc` -- wroc do `NORMAL`
7. Nacisnij `:` -- zobaczysz prompt komend (noice popup)
8. Nacisnij `Esc` -- wroc do `NORMAL`

**Cel**: Zapamietaj, ze `Esc` ZAWSZE wraca do Normal.

### Cwiczenie 2: Wpisywanie tekstu roznymi sposobami

1. W trybie Normal nacisnij `i` i wpisz: `Witaj w Vimie!`
2. Nacisnij `Esc`
3. Nacisnij `o` -- otworzy sie nowa linia ponizej, jestes w Insert
4. Wpisz: `To jest druga linia.`
5. Nacisnij `Esc`
6. Nacisnij `O` -- nowa linia powyzej biezacej
7. Wpisz: `A to jest linia pomiedzy.`
8. Nacisnij `Esc`
9. Nacisnij `A` -- kursor przesunie sie na koniec linii, jestes w Insert
10. Dopisz: ` <- dopisane na koncu`
11. Nacisnij `Esc`

### Cwiczenie 3: Nawigacja h/j/k/l

1. W trybie Normal uzyj `j` zeby zjechac 5 linii w dol
2. Uzyj `k` zeby wrocic 3 linie do gory
3. Uzyj `l` zeby przesunac kursor 10 znakow w prawo
4. Uzyj `h` zeby wrocic 5 znakow w lewo
5. Obserwuj jak `scrolloff=8` dziala -- sprobuj zjechac na dol pliku klawiszem `j`
   i zwroc uwage, ze ekran zaczyna sie przewijac zanim kursor dotrze do ostatniej linii

### Cwiczenie 4: Strzalki vs h/j/k/l

1. Nawiguj strzalkami przez 30 sekund -- zwroc uwage jak daleko od home row sa Twoje palce
2. Nawiguj `h/j/k/l` przez 30 sekund -- palce zostaja na miejscu
3. Powtorz punkt 2 jeszcze kilka razy -- chodzi o budowanie muscle memory

> **Tip**: Na poczatku bedzie nienaturalnie. To normalne. Po 2-3 dniach konsekwentnego
> uzywania `h/j/k/l` strzalki beda Ci sie wydawac wolne.

### Cwiczenie 5: Zapis i wyjscie

1. Wpisz kilka linii tekstu (tryb Insert)
2. Wroc do Normal (`Esc`)
3. Zapisz plik: `:w` + Enter
4. Zamknij plik: `:q` + Enter
5. Otworz ponownie: `nvim exercises/practice/motions.txt`
6. Sprawdz czy tekst sie zachowal
7. Zamknij bez zapisywania: `:q!` (przydatne gdy zrobisz cos zlego)

### Cwiczenie 6: Komendy Ex

1. Otworz plik z kodem: `:e exercises/python/calculator.py`
2. Skocz do linii 50: `:50` + Enter
3. Skocz na poczatek pliku: `:1` + Enter (albo `gg` w Normal -- poznasz to w nastepnej lekcji)
4. Skocz na koniec: `:$` + Enter (albo `G`)
5. Zapisz kopie pliku: `:w /tmp/kopia.py`

### Cwiczenie 7: which-key

1. W trybie Normal nacisnij `Space` i poczekaj 1 sekunde
2. Przejrzyj dostepne grupy skrotow
3. Nacisnij `Esc` zeby zamknac popup
4. Nie musisz teraz zapamietywac tych skrotow -- bedziesz je poznawac stopniowo

## Cwiczenie bonusowe

Otworz plik `exercises/python/utils.py` i wykonaj nastepujace zadania uzywajac TYLKO
`h/j/k/l` do nawigacji (bez strzalek!) oraz `i`/`a`/`o`/`A` do wstawiania tekstu:

1. Przejdz do funkcji `validate_email` (linia ~39)
2. Ponizej docstringu dodaj komentarz: `# TODO: add support for international domains`
3. Przejdz do funkcji `slugify` (linia ~52)
4. Na koncu linii z `return` dopisz komentarz: `  # cleaned slug`
5. Zapisz plik (`:w`)

**Wyzwanie**: Sprobuj nie uzywac strzalek ani myszy przez cale cwiczenie!

## Podsumowanie

### Nauczone komendy

| Komenda | Tryb | Opis |
|---------|------|------|
| `i` | Normal -> Insert | Wstaw przed kursorem |
| `a` | Normal -> Insert | Wstaw za kursorem |
| `o` | Normal -> Insert | Nowa linia ponizej |
| `O` | Normal -> Insert | Nowa linia powyzej |
| `I` | Normal -> Insert | Wstaw na poczatku linii |
| `A` | Normal -> Insert | Wstaw na koncu linii |
| `Esc` | Dowolny -> Normal | Powrot do trybu Normal |
| `v` | Normal -> Visual | Zaznaczanie po znakach |
| `V` | Normal -> Visual | Zaznaczanie linii |
| `Ctrl+v` | Normal -> Visual | Zaznaczanie bloku |
| `:` | Normal -> Command | Wejscie w tryb komend |
| `h/j/k/l` | Normal | Ruch: lewo/dol/gora/prawo |
| `:w` | Command | Zapisz plik |
| `:q` | Command | Zamknij bufor |
| `:wq` | Command | Zapisz i zamknij |
| `:q!` | Command | Zamknij bez zapisywania |

### Konfiguracja uzyta w tej lekcji

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| `showmode` | `false` | Tryb wyswietlany przez lualine, nie wbudowany |
| `scrolloff` | `8` | 8 linii kontekstu nad/pod kursorem |
| `number` | `true` | Numery linii widoczne po lewej |

### Co dalej?

W **lekcji 02** poznasz **ruchy (motions)** -- sposob na szybka nawigacje po slowach, liniach,
paragrafach i znakach. Przejdziesz od powolnego `h/j/k/l` do blyskawicznego `w`, `b`, `f`, `}`.
