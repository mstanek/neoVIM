# Lekcja 26: Gitsigns -- zmiany w kodzie

> Czas: ~30-45 min | Poziom: Intermediate

---

## Cel lekcji

Nauczysz sie:

- Czytac znaki gitsigns w gutter (kolumna po lewej stronie kodu)
- Korzystac z inline blame do sledzenia kto i kiedy zmienil kazda linie
- Podgladac hunki (fragmenty zmian) w floating window
- Otwierac side-by-side diff biezacego pliku z wersja HEAD
- Nawigowac miedzy hunkami w pliku

---

## Teoria

### Czym jest Gitsigns?

Gitsigns to plugin, ktory integruje informacje z `git diff` bezposrednio w edytorze.
Nie musisz wychodzic do terminala -- widzisz ktore linie zostaly dodane, zmienione
lub usuniete **w czasie rzeczywistym**, podczas edycji pliku.

Gitsigns dziala na poziomie pojedynczego pliku (w przeciwienstwie do Diffview, ktory
pokazuje zmiany w calym repozytorium -- lekcja 27).

### Znaki w gutter (signs)

Po lewej stronie kodu, obok numerow linii, gitsigns wyswietla kolorowe znaki:

| Znak | Kolor | Znaczenie | Kiedy sie pojawia |
|------|-------|-----------|-------------------|
| `│` | Zielony | **Dodana linia** (add) | Nowa linia, ktorej nie ma w HEAD |
| `│` | Niebieski | **Zmieniona linia** (change) | Linia istniejaca w HEAD, ale zmodyfikowana |
| `_` | Czerwony | **Usunieta linia** (delete) | Pod ta linia w HEAD byla usnieta linia |
| `‾` | Czerwony | **Usunieta na gorze** (topdelete) | Nad ta linia w HEAD byla usunieta linia |
| `~` | Fioletowy | **Zmiana + usuniecie** (changedelete) | Linia zmieniona i sasiednia usunieta |

**Wizualizacja**:

```
  1  │ import os                    # │ zielony -- linia dodana
  2    from pathlib import Path     #   bez znaku -- linia niezmieniona
  3  │ TIMEOUT = 30                 # │ niebieski -- linia zmieniona (bylo 60)
  4  _ def process():               # _ czerwony -- pod linia 3 cos zostalo usuniete
  5    return True
```

> **Twoja konfiguracja**: Znaki sa ustawione na `│` (add/change), `_` (delete),
> `‾` (topdelete), `~` (changedelete). Sa widoczne zawsze, dopoki plik jest w repozytorium git.

### Current line blame

Gitsigns wyswietla **inline blame** -- szary tekst na koncu kazdej linii, ktory
pokazuje kto ostatnio zmienil ta linie, kiedy i z jakim commit message.

```
  42    def calculate_tax(amount):    jkowalski, 3 days ago • Add tax calculation
```

To dziala automatycznie -- nie musisz nic naciskac. Wystarczy przesunac kursor na
interesujaca linie i poczekac chwile. Blame pojawi sie jako wirtualny tekst (virtual text)
w przyciemnionym kolorze.

> **Twoja konfiguracja**: `current_line_blame = true` -- blame jest **zawsze wlaczony**.
> Nie musisz go aktywowac -- informacja o autorze, dacie i commit message widnieje
> przy kazdej linii, na ktorej stoi kursor.

### Blame line -- pelna informacja

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gb` | Otworz floating window z pelnym blame dla biezacej linii |

Floating window blame pokazuje wiecej szczegolow niz inline blame:

- Pelny hash commita
- Autor i data
- Pelny commit message (moze byc wieloliniowy)
- Diff stat (ile linii dodanych/usunietych w tym uzyciu)

To przydatne, gdy inline blame jest uciety (dlugi commit message) albo gdy potrzebujesz
hash commita.

### Preview hunk -- podglad zmiany

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gp` | Otworz floating window z diffem dla biezacego hunk |

**Hunk** to ciagly blok zmian (dodane/zmienione/usuniete linie obok siebie).
`<leader>gp` otwiera floating window, ktory pokazuje co dokladnie sie zmienilo:

- Linie oznaczone `-` (czerwone) -- co bylo wczesniej
- Linie oznaczone `+` (zielone) -- co jest teraz
- Kontekst -- kilka linii przed i po zmianie

```
┌────────────────────────────────────────┐
│ @@ -10,3 +10,4 @@                      │
│  def process(data):                    │
│ -    timeout = 60                      │  <- stara wartosc (czerwona)
│ +    timeout = 30                      │  <- nowa wartosc (zielona)
│ +    retries = 3                       │  <- dodana linia (zielona)
│      return run(data, timeout)         │
└────────────────────────────────────────┘
```

### Diff current file -- porownanie side-by-side

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gD` | Toggle diff biezacego pliku z HEAD |

To otwiera **side-by-side split**:

```
+----------------------------+----------------------------+
│  HEAD (index)              │  Current (working)         │
│  (wersja z ostatniego      │  (Twoja biezaca wersja     │
│   commita)                 │   z niezapisanymi zmianami) │
+----------------------------+----------------------------+
│  def process(data):        │  def process(data):        │
│      timeout = 60          │      timeout = 30          │  <- roznica podswietlona
│                            │      retries = 3           │  <- dodana linia
│      return run(data)      │      return run(data)      │
+----------------------------+----------------------------+
```

Kluczowe cechy:

- **Lewe okno**: wersja HEAD (ostatni commit) z winbar label "HEAD (index)" na czerwonym tle
- **Prawe okno**: biezaca wersja robocza z winbar label "Current (working)" na zielonym tle
- **Scrollbind**: oba okna przewijaja sie synchronicznie
- **Toggle**: nacisnij `<leader>gD` ponownie, zeby zamknac diff i wrocic do normalnego widoku

> **Twoja konfiguracja**: Diff uzywa `gitsigns.diffthis()`. Lewe okno jest readonly
> (nie mozesz edytowac wersji HEAD). Prawe okno to Twoj normalny bufor -- mozesz
> w nim edytowac, a zmiany beda widoczne w czasie rzeczywistym.

### Nawigacja miedzy hunkami

Gitsigns udostepnia standardowe keybindings do skakania miedzy hunkami:

| Skrot | Dzialanie |
|-------|-----------|
| `]c` | Nastepny hunk (nastepna zmiana) |
| `[c` | Poprzedni hunk (poprzednia zmiana) |

Dzieki temu mozesz szybko przeskakiwac miedzy zmienionymi fragmentami pliku
bez reczengo przewijania i szukania zielonych/niebieskich znakow w gutter.

### Workflow z gitsigns

Typowy scenariusz pracy z gitsigns:

1. Edytujesz plik -- w gutter pojawiaja sie znaki `│`
2. Widzisz inline blame na kazdej linii -- wiesz kto co ostatnio zmienil
3. `]c` / `[c` -- skaciesz miedzy hunkami
4. `<leader>gp` -- podgladasz co dokladnie zmieniles (preview hunk)
5. `<leader>gD` -- otwierasz pelny side-by-side diff z HEAD
6. Gdy jestes gotowy -- przechodzisz do Diffview (`<leader>gd`) aby zobaczyc wszystkie pliki

---

## Cwiczenia

### Przygotowanie

Uruchom skrypt przygotowujacy repozytorium cwiczeniowe:

```bash
cd ~/GIT/vim-tutor/exercises/git-exercise
bash setup-git-exercise.sh
```

Nastepnie otworz Neovim w katalogu repo:

```bash
cd ~/GIT/vim-tutor/exercises/git-exercise/repo
nvim .
```

### Cwiczenie 1: Odczytywanie znakow w gutter

1. Otworz dowolny plik z repozytorium cwiczeniowego (`Ctrl+P`)
2. Dokonaj kilku zmian:
   - Dodaj nowa linie (powinna pojawic sie zielona `│`)
   - Zmien istniejaca linie (powinna pojawic sie niebieska `│`)
   - Usun linie -- postaw kursor na linii i nacisnij `dd` (pod spodem pojawi sie `_`)
3. Zaobserwuj znaki w gutter -- kazdy typ zmiany ma inny kolor
4. Cofnij zmiany (`u` wielokrotnie) -- znaki powinny zniknac

### Cwiczenie 2: Inline blame

1. Otworz plik, ktory ma kilka commitow w historii
2. Przesun kursor na rozne linie
3. Obserwuj szary tekst inline blame na koncu kazdej linii
4. Zauwaz, ze blame pokazuje: autora, czas (np. "3 days ago") i commit message
5. Znajdz linie dodana w najnowszym uzyciu -- blame powinien to potwierdzac

### Cwiczenie 3: Pelny blame

1. Ustaw kursor na interesujacj linii
2. Nacisnij `<leader>gb` -- otworzy sie floating window z pelnym blame
3. Przeczytaj informacje: hash, autor, data, commit message
4. Zamknij floating window (`Esc` lub `q`)
5. Przejdz do innej linii i powtorz -- porownaj commity

### Cwiczenie 4: Preview hunk

1. Dokonaj zmian w pliku: zmien wartosc zmiennej, dodaj komentarz, usun linie
2. Ustaw kursor na linii ze znakiem `│` w gutter
3. Nacisnij `<leader>gp` -- floating window pokaze diff hunk
4. Przeczytaj diff: linie `-` (usuwane) i `+` (dodawane)
5. Zamknij floating window
6. Przejdz do innego hunk (`]c`) i powtorz preview

### Cwiczenie 5: Nawigacja miedzy hunkami

1. Dokonaj zmian w roznych miejscach pliku (poczatek, srodek, koniec)
2. Wroc na poczatek pliku (`gg`)
3. Nacisnij `]c` -- kursor przeskoczy do pierwszego hunk
4. Nacisnij `]c` ponownie -- nastepny hunk
5. Kontynuuj do konca pliku
6. Uzyj `[c` zeby wrocic do poprzednich hunkow
7. Na kazdym hunku uzyj `<leader>gp` zeby zobaczyc co zmieniles

### Cwiczenie 6: Diff side-by-side

1. Dokonaj kilku zmian w pliku (zmien wartosci, dodaj linie)
2. Nacisnij `<leader>gD` -- otworzy sie side-by-side split
3. Zaobserwuj:
   - Lewe okno: "HEAD (index)" -- oryginalna wersja
   - Prawe okno: "Current (working)" -- Twoje zmiany
   - Roznice sa podswietlone kolorami
4. Przewin obie strony jednoczesnie (scrollbind)
5. Nacisnij `<leader>gD` ponownie -- diff sie zamknie, wroci normalny widok

### Cwiczenie 7: Diff + edycja w czasie rzeczywistym

1. Otworz diff side-by-side (`<leader>gD`)
2. W prawym oknie (Current) dokonaj dodatkowej zmiany
3. Zaobserwuj, ze diff aktualizuje sie natychmiast -- nowa zmiana pojawia sie
   jako podswietlony fragment
4. Cofnij zmiane (`u`) -- diff sie zaktualizuje
5. Zamknij diff (`<leader>gD`)

### Cwiczenie 8: Kompletny workflow

1. Otworz plik z repozytorium
2. Sprawdz inline blame -- kto ostatnio edytowal plik?
3. Dokonaj zmian w 3 roznych miejscach pliku
4. Uzyj `]c` / `[c` do nawigacji miedzy hunkami
5. Na kazdym hunku uzyj `<leader>gp` do podgladu
6. Otworz pelny diff (`<leader>gD`) -- przejrzyj wszystkie zmiany naraz
7. Zamknij diff i cofnij zmiany (`u` wielokrotnie)

---

## Cwiczenie bonusowe

**Scenariusz: code review na poziomie pojedynczego pliku**

1. Otworz plik z wieloma commitami w historii
2. Przejrzyj inline blame na roznych liniach -- zidentyfikuj najnowsze zmiany
3. Uzyj `<leader>gb` na 3 roznych liniach -- zapisz (mentalnie) hash commita kazdej
4. Dokonaj wlasnych zmian w 4-5 miejscach pliku
5. Nawiguj miedzy hunkami (`]c`/`[c`) i podgladaj kazdy (`<leader>gp`)
6. Otworz diff side-by-side (`<leader>gD`) -- przejrzyj pelny obraz zmian
7. Zamknij diff, cofnij wszystkie zmiany

**Wyzwanie**: Sprobuj zidentyfikowac ktore linie pochodza z roznych commitow, korzystajac
tylko z inline blame (bez otwierania terminala).

---

## Podsumowanie

### Nauczone komendy

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gb` | Blame line -- pelna informacja o commit w floating window |
| `<leader>gp` | Preview hunk -- floating diff biezacej zmiany |
| `<leader>gD` | Toggle diff side-by-side z HEAD (split view) |
| `]c` | Nastepny hunk (nastepna zmiana w pliku) |
| `[c` | Poprzedni hunk (poprzednia zmiana w pliku) |

### Znaki gitsigns

| Znak | Znaczenie |
|------|-----------|
| `│` (zielony) | Dodana linia |
| `│` (niebieski) | Zmieniona linia |
| `_` | Usunieta linia ponizej |
| `‾` | Usunieta linia powyzej |
| `~` | Zmiana + usuniecie |

### Konfiguracja uzyta w tej lekcji

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| `current_line_blame` | `true` | Inline blame zawsze widoczny |
| Signs: add/change | `│` | Pionowa kreska obok dodanych/zmienionych linii |
| Signs: delete | `_` | Podkreslnik przy usunietych liniach |
| `diffthis()` | `<leader>gD` | Side-by-side split z winbar labels |

### Co dalej?

W **lekcji 27** poznasz **Diffview** -- narzedie do przegladania zmian w **calym repozytorium**
naraz. Zobaczysz panel plikow z tree view, staging/unstaging, i historie commitow
dla poszczegolnych plikow.
