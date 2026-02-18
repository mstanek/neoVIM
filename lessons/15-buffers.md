# Lekcja 15: Buffers — zarzadzanie otwartymi plikami

> Czas: ~30-45 min | Poziom: Intermediate

---

## Cel lekcji

Nauczysz sie:

- Czym jest buffer i jak rozni sie od window i tab
- Nawigowac miedzy bufferami za pomoca skrotow klawiszowych
- Uzywac smart picker (`Ctrl+P`) do inteligentnego otwierania plikow
- Zarzadzac bufferami: otwieranie, zamykanie, przeglad listy
- Rozpoznawac stany bufferow na bufferline

---

## Teoria

### Buffer vs Window vs Tab

W Vimie te trzy pojecia sa czesto mylone. Oto kluczowa roznica:

| Pojecie   | Co to jest                          | Analogia                        |
|-----------|-------------------------------------|---------------------------------|
| **Buffer** | Plik zaladowany do pamieci         | Zakladka w przegladarce         |
| **Window** | Widoczny prostokat (viewport)      | Panel w przegladarce            |
| **Tab**    | Uklad okien (layout/workspace)     | Osobne okno przegladarki        |

Kluczowa zasada: **jeden plik = jeden buffer**. Mozesz miec 20 otwartych bufferow,
ale widziec tylko 2-3 w oknach. Reszta zyje w pamieci jako **hidden buffers**.

```
+----------------------------------------------------+
| Bufferline: [models.py] [utils.py*] [api.ts]       |  <-- buffers (zakladki u gory)
+------------------------+---------------------------+
|                        |                           |
|   Window 1             |   Window 2                |  <-- windows (viewports)
|   (shows utils.py)     |   (shows api.ts)          |
|                        |                           |
+------------------------+---------------------------+
|                    Tab 1                            |  <-- tab (layout)
+----------------------------------------------------+
```

### Bufferline — wizualny pasek bufferow

U gory ekranu widzisz pasek **bufferline** — wyglada jak zakladki w przegladarce.
Kazdy otwarty buffer ma swoja zakladke z:

- Nazwa pliku
- Ikona typu pliku (Nerd Fonts)
- Oznaczenie modyfikacji `[+]` gdy plik ma niezapisane zmiany
- Numer buffera

### Twoja konfiguracja

> **Nawigacja miedzy bufferami:**
>
> | Skrot               | Dzialanie                                           |
> |---------------------|-----------------------------------------------------|
> | `Shift+H`           | Poprzedni buffer                                    |
> | `Shift+L`           | Nastepny buffer                                     |
> | `Ctrl+Tab` (Kitty: `Ctrl+T`) | Nastepny buffer (cycle)                   |
> | `Ctrl+Shift+Tab` (Kitty: `Ctrl+Y`) | Poprzedni buffer (cycle)           |
> | `Cmd+P` (Kitty: `Ctrl+P`) | Snacks.picker.smart() — inteligentny picker   |
> | `<leader>bd`        | Usun biezacy buffer (smart delete)                  |
> | `<leader>fb`        | Telescope buffer picker z podgladem                 |

### Otwieranie plikow

Istnieje kilka sposobow otwierania plikow jako bufferow:

| Metoda                    | Kiedy uzywac                                    |
|---------------------------|-------------------------------------------------|
| `Ctrl+P` (smart picker)  | Najczesciej — szuka pliki, recent, buffers      |
| `<leader>ff`              | Szukanie pliku po nazwie (Telescope)            |
| `<leader>fr`              | Ostatnio otwierane pliki                        |
| `<leader>fb`              | Przeglad otwartych bufferow z preview           |
| `<leader>e` (Neo-tree)    | Wizualne przeglądanie drzewa plikow             |
| `:e sciezka/plik.py`      | Reczne otwarcie po sciezce                      |

### Smart picker — Snacks.picker.smart()

`Ctrl+P` (zmapowany z `Cmd+P` przez Kitty) to Twoj **glowny sposob otwierania plikow**.
Smart picker laczy w sobie:

- Wyszukiwanie plikow w projekcie
- Ostatnio otwierane pliki (recent)
- Aktualnie otwarte buffers

Dzieki temu jeden skrot obsluguje 90% przypadkow — wystarczy wpisac fragment nazwy
pliku i nacisnac Enter.

### Komendy bufferow (native Vim)

| Komenda         | Dzialanie                                       |
|-----------------|-------------------------------------------------|
| `:ls`           | Lista wszystkich bufferow                       |
| `:buffers`      | Alias dla `:ls`                                 |
| `:b nazwa`      | Przelacz na buffer (partial match)              |
| `:b 3`          | Przelacz na buffer nr 3                         |
| `:bn`           | Nastepny buffer                                 |
| `:bp`           | Poprzedni buffer                                |
| `:bd`           | Usun biezacy buffer                             |
| `:bd!`          | Usun buffer bez zapisywania zmian               |
| `:%bd`          | Usun WSZYSTKIE buffery                          |

### Stany bufferow

| Symbol w `:ls` | Stan          | Opis                                       |
|----------------|---------------|---------------------------------------------|
| `%`            | current       | Aktualnie wyswietlany buffer               |
| `#`            | alternate     | Poprzedni buffer (przelacz przez `Ctrl+^`)  |
| `a`            | active        | Zaladowany i widoczny w oknie              |
| `h`            | hidden        | Zaladowany, ale nie widoczny               |
| `+`            | modified      | Ma niezapisane zmiany                      |
| `-`            | readonly      | Tylko do odczytu                           |

Na bufferline zmodyfikowane buffery sa oznaczone ikona `[+]` lub zmieniony kolorystyke.

### Alternate buffer — szybkie przelaczanie

`Ctrl+^` (lub `Ctrl+6`) przelacza miedzy **biezacym** a **alternate** bufferem.
To najszybszy sposob na skakanie miedzy dwoma plikami, nad ktorymi pracujesz
jednoczesnie (np. komponent + test, model + migration).

### Smart buffer delete

`<leader>bd` nie po prostu zamyka buffer — robi to **inteligentnie**:

1. Przelacza na nastepny buffer
2. Dopiero wtedy zamyka poprzedni
3. Nie zostawia pustego okna

Dzieki temu nigdy nie skończysz z pustym ekranem po zamknieciu ostatniego
widocznego buffera.

---

## Cwiczenia

### Cwiczenie 1: Otwieranie wielu plikow

1. Otworz plik `exercises/python/calculator.py` za pomoca `Ctrl+P`
2. Bez zamykania, otworz `exercises/python/utils.py` (tez `Ctrl+P`)
3. Otworz jeszcze `exercises/python/models.py`
4. Spójrz na bufferline u góry — powinny byc widoczne 3 zakladki
5. Uzyj `:ls` zeby zobaczyc liste bufferow w command line

### Cwiczenie 2: Nawigacja Shift+H / Shift+L

1. Majac otwarte 3 buffery z cwiczenia 1:
2. Nacisnij `Shift+L` — przejdz na nastepny buffer
3. Nacisnij `Shift+L` jeszcze raz — kolejny buffer
4. Nacisnij `Shift+H` — wroc na poprzedni
5. Powtorz kilka razy, obserwujac ktora zakladka jest aktywna na bufferline

### Cwiczenie 3: Ctrl+Tab cycling

1. Uzyj `Ctrl+Tab` (Kitty wysyla `Ctrl+T`) zeby przejsc na nastepny buffer
2. Uzyj `Ctrl+Shift+Tab` (Kitty wysyla `Ctrl+Y`) zeby wrocic
3. Porownaj z `Shift+H/L` — efekt ten sam, inna ergonomia
4. Wybierz metode, ktora bardziej Ci odpowiada

### Cwiczenie 4: Telescope buffer picker

1. Nacisnij `<leader>fb` — otworzy sie Telescope z lista bufferow
2. Zauwaz, ze kazdy buffer ma podglad (preview) po prawej stronie
3. Uzyj strzalek lub `Ctrl+n/p` zeby nawigowac
4. Nacisnij `Enter` zeby przejsc do wybranego buffera
5. Ponownie `<leader>fb` — wpisz fragment nazwy pliku, zeby przefiltrowac

### Cwiczenie 5: Smart picker w akcji

1. Nacisnij `Ctrl+P` — otworzy sie Snacks.picker.smart()
2. Wpisz `calc` — powinien pojawic sie `calculator.py`
3. Wyczysc i wpisz `mod` — powinien pojawic sie `models.py`
4. Otwórz plik, potem `Ctrl+P` ponownie — zauwaz, ze ostatnio otwierane
   pliki sa wyzej na liscie

### Cwiczenie 6: Zamykanie bufferow

1. Przejdz na buffer `models.py` (uzyj `Shift+H/L` lub `Ctrl+P`)
2. Nacisnij `<leader>bd` — buffer zostanie zamkniety, przejdziesz na nastepny
3. Sprawdz bufferline — `models.py` zniknelo
4. Uzyj `:ls` zeby potwierdzic

### Cwiczenie 7: Alternate buffer

1. Otworz `calculator.py` i `utils.py`
2. Bedzac w `calculator.py`, przejdz do `utils.py` (`Shift+L`)
3. Nacisnij `Ctrl+^` — wroci do `calculator.py`
4. Nacisnij `Ctrl+^` ponownie — z powrotem w `utils.py`
5. To najszybsze przelaczanie miedzy dwoma plikami!

### Cwiczenie 8: Otwieranie z roznych zrodel

1. `<leader>fr` — otworz plik z listy recent files
2. `<leader>ff` — otworz nowy plik po nazwie (Telescope find files)
3. `Ctrl+P` — smart picker (laczy pliki + recent + buffers)
4. Porownaj — smart picker jest najwygodniejszy do codziennej pracy

---

## Cwiczenie bonusowe

**Scenariusz: praca z wieloma plikami**

1. Otworz 5 roznych plikow z katalogu `exercises/` (uzywaj `Ctrl+P`)
2. Za pomoca `Shift+H/L` przejdz do trzeciego pliku
3. Zrob drobna edycje (dodaj komentarz) — zauwaz `[+]` na bufferline
4. Zapisz (`:w`) — `[+]` zniknie
5. Uzyj `<leader>fb` zeby przegladnac wszystkie buffery z podgladem
6. Zamknij 3 z 5 bufferow uzywajac `<leader>bd`
7. Sprawdz `:ls` — powinny zostac 2 buffery
8. Uzyj `Ctrl+^` do przelaczania miedzy nimi

---

## Podsumowanie

| Skrot / Komenda      | Dzialanie                               |
|----------------------|-----------------------------------------|
| `Shift+H` / `Shift+L` | Poprzedni / nastepny buffer           |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Cycle bufferow               |
| `Ctrl+P`             | Smart picker (pliki + recent + buffers) |
| `<leader>bd`         | Smart delete buffer                     |
| `<leader>fb`         | Telescope buffer picker                 |
| `:ls`                | Lista bufferow                          |
| `Ctrl+^`             | Alternate buffer (toggle)               |
| `:b nazwa`           | Przelacz na buffer po nazwie            |

**Nastepna lekcja:** Windows, splits i tmux — jak dzielic ekran na wiele paneli
i plynnie nawigowac miedzy Neovim a tmux.
