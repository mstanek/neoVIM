# Lekcja 31: Spectre i Todo -- wyszukiwanie i zarzadzanie zadaniami

> Czas: ~30-45 min | Poziom: Advanced

---

## Cel lekcji

Nauczysz sie:

- Uzywac Spectre do project-wide search & replace z podgladem zmian
- Nawigowac po todo-comments w kodzie (`TODO`, `FIXME`, `HACK`, `WARN`, `PERF`, `NOTE`)
- Zarzadzac zadaniami w dedykowanym systemie todo notes (pliki `*/notes/todo.md`)
- Laczyc Spectre, todo-comments i todo notes w codziennym workflow

---

## Teoria

### Spectre -- search & replace na sterydach

Spectre to narzedzie do **wyszukiwania i zamiany tekstu w calym projekcie** z podgladem
wynikow w czasie rzeczywistym. W przeciwienstwie do `:substitute` dziala na wielu plikach
jednoczesnie i pokazuje kazda zmiane zanim ja zatwierdzisz.

| Klawisz | Dzialanie |
|---------|-----------|
| `<leader>S` | Toggle Spectre (otwiera/zamyka panel) |
| `<leader>sw` | Szukaj slowa pod kursorem (w calym projekcie) |
| `<leader>sp` | Szukaj w biezacym pliku |

**Interfejs Spectre:**

```
+------------------------------------------------------------------+
| Spectre                                                           |
|                                                                   |
| Search:  UserDTO_______________                                   |
| Replace: UserResponse__________                                   |
| Path:    **/*.ts_______________                                   |
|                                                                   |
| --- Results ---                                                   |
| api-service.ts                                                    |
|   L42: export interface UserDTO {        -> UserResponse          |
|   L58: function getUser(): UserDTO {     -> UserResponse          |
| interfaces.ts                                                     |
|   L15: type Response = UserDTO[];        -> UserResponse[]        |
|                                                                   |
+------------------------------------------------------------------+
```

W panelu Spectre wpisujesz wzorzec wyszukiwania (Search), tekst zamiany (Replace) i
opcjonalnie filtr sciezek (Path). Wyniki pojawiaja sie na zywo z kolorowym podgladem:

| Kolor | Znaczenie |
|-------|-----------|
| DiffDelete (czerwony) | Dopasowany tekst -- to zostanie zamienione |
| DiffAdd (zielony) | Tekst zamiany -- to pojawi sie po zatwierdzeniu |

**Komendy wewnatrz Spectre:**

| Klawisz (w panelu Spectre) | Dzialanie |
|-----------------------------|-----------|
| `Enter` | Przejdz do wybranego wyniku w pliku |
| `dd` | Usun (ignoruj) wybrany wynik |
| `<leader>R` | Zamien wszystkie wyniki (replace all) |
| `<leader>rc` | Zamien biezacy wynik |
| `<leader>v` | Zmien widok (toggle wynikow) |
| `tu` | Toggle update on type (live preview) |
| `ti` | Toggle ignore case |
| `th` | Toggle hidden files |
| `I` | Toggle regex mode |

> **Twoja konfiguracja**: Spectre uzywa kolorow Catppuccin Mocha -- DiffDelete/DiffAdd
> sa czytelne na ciemnym tle. Panel otwiera sie na pelna szerokosc na dole ekranu.

### Regex w Spectre

Spectre wspiera pelne wyrazenia regularne. Kilka przydatnych przykladow:

| Pattern | Dopasowuje | Uzycie |
|---------|-----------|--------|
| `UserDTO` | dokladny tekst | Prosta zamiana nazwy |
| `get\w+` | `getUser`, `getName`, `getData`... | Wszystkie gettery |
| `console\.log\(.*\)` | wszystkie `console.log()` | Czyszczenie debugowania |
| `TODO:?\s*(.*)` | komentarze TODO z trescia | Porzadkowanie komentarzy |
| `import.*from ['"]\.\.` | relative imports z `..` | Refaktor importow |

### Workflow Spectre -- refaktoring

Typowy scenariusz: zmieniasz nazwe typu/interfejsu w wielu plikach jednoczesnie.

1. Ustaw kursor na nazwie, ktora chcesz zmienic (np. `UserDTO`)
2. `<leader>sw` -- Spectre otwiera sie z tym slowem w polu Search
3. Wpisz nowa nazwe w polu Replace (np. `UserResponse`)
4. Przejrzyj wyniki -- kazdy wynik pokazuje plik i linie z podgladem zmiany
5. Usun wyniki, ktorych nie chcesz zmieniac (`dd` na wybranym wierszu)
6. `<leader>R` -- zamien wszystkie pozostale wyniki
7. `<leader>S` -- zamknij Spectre

### Todo-comments -- kolorowe znakowania w kodzie

Todo-comments to plugin, ktory **podswietla** specjalne komentarze w kodzie i pozwala
po nich nawigowac. Nie musisz nic konfigurowac -- wystarczy pisac komentarze z prefiksem:

| Prefix | Kolor | Znaczenie |
|--------|-------|-----------|
| `TODO:` | niebieski | Cos do zrobienia |
| `FIXME:` | czerwony | Blad do naprawienia |
| `HACK:` | pomaranczowy | Tymczasowe rozwiazanie / obejscie |
| `WARN:` | zolty | Ostrzezenie |
| `PERF:` | fioletowy | Problem wydajnosciowy |
| `NOTE:` | zielony | Notatka informacyjna |

**Przyklad w kodzie:**

```python
# TODO: dodac walidacje danych wejsciowych
# FIXME: race condition przy concurrent access
# HACK: obejscie buga w bibliotece v2.3.1
# WARN: ta funkcja modyfikuje stan globalny
# PERF: N+1 query -- rozwazyc eager loading
# NOTE: format daty zgodny z ISO 8601
```

Kazdy z tych komentarzy wyswietli sie z wyrazistym kolorem i ikona w kodzie.

**Nawigacja po todo-comments:**

| Klawisz | Dzialanie |
|---------|-----------|
| `<leader>ft` | Znajdz WSZYSTKIE TODO/FIXME/etc. w projekcie (Telescope) |
| `]t` | Skocz do nastepnego TODO |
| `[t` | Skocz do poprzedniego TODO |

`<leader>ft` otwiera Telescope picker z lista wszystkich todo-comments w projekcie.
Mozesz filtrowac po tresci, nazwie pliku, lub typie (TODO, FIXME itd.).

> **Twoja konfiguracja**: Todo-comments uzywa ikon z Nerd Fonts i kolorow Catppuccin Mocha.
> Kazdy typ ma swoja ikone i kolor tla -- dobrze widoczne nawet w dlugich plikach.

### Todo notes system -- zarzadzanie zadaniami

To autorski system zarzadzania zadaniami w plikach markdown. Dziala w kazdym pliku
o sciezce pasujacym do `*/notes/todo.md`. Plik ma strukture z trzema sekcjami:

```markdown
## In Progress
- [x] Zrefaktorowac modul auth @created(2026-02-15)
- [ ] Dodac testy do API endpoint @created(2026-02-18)

## Backlog
- [ ] Migracja bazy danych @created(2026-02-10)
- [ ] Dokumentacja REST API @created(2026-02-12)

## Done
- [x] Setup CI/CD pipeline @created(2026-02-01) @done(2026-02-14)
```

**Keybindy w plikach todo (Normal mode):**

| Klawisz | Dzialanie |
|---------|-----------|
| `Enter` | Toggle checkbox (`[ ]` <-> `[x]`) |
| `<leader>ta` | Dodaj nowe zadanie (na gorze biezacej sekcji) |
| `<leader>tx` | Smart toggle done -- zaznacz i przenies do odpowiedniej sekcji |
| `<leader>td` | Przenies zadanie do sekcji Done |
| `<leader>ti` | Przenies zadanie do sekcji In Progress |
| `<leader>tb` | Przenies zadanie do sekcji Backlog |
| `<leader>tD` | Usun zadanie |
| `<leader>tk` | Przenies zadanie w gore (w ramach sekcji) |
| `<leader>tj` | Przenies zadanie w dol (w ramach sekcji) |
| `<leader>tA` | Archiwizuj stare zadania Done (>7 dni) |

**Automatyczne funkcje:**

| Feature | Opis |
|---------|------|
| `@created(date)` | Automatycznie dodawany timestamp przy tworzeniu |
| `@done(date)` | Automatycznie dodawany przy przenoszeniu do Done |
| Auto-save | Plik zapisuje sie automatycznie po wyjsciu z Insert mode |
| Auto-archive | Zadania w Done starsze niz 7 dni -> archiwizowane przez `<leader>tA` |

> **Twoja konfiguracja**: System todo notes aktywuje sie automatycznie w plikach
> `*/notes/todo.md`. W innych plikach markdown te keybindy nie dzialaja.

### Polaczenie narzedzi

Te trzy narzedzia uzupelniaja sie:

```
  Todo-comments (w kodzie)        Todo notes (zarzadzanie)
  ┌─────────────────────┐         ┌─────────────────────┐
  │ // TODO: zrobic X   │         │ ## In Progress      │
  │ // FIXME: naprawic Y│   ───►  │ - [ ] zrobic X      │
  │ // NOTE: uwaga Z    │         │ - [ ] naprawic Y    │
  └─────────────────────┘         └─────────────────────┘
         │                                  │
         │ <leader>ft                       │ <leader>tx
         ▼                                  ▼
  Telescope (przeglad)            Przeniesienie do Done
```

Typowy workflow:
1. Piszesz `TODO:` w kodzie kiedy cos wymaga uwagi
2. `<leader>ft` -- przegladasz wszystkie TODO w projekcie
3. Przenosisz wazne do pliku `notes/todo.md` i zarzadzasz priorytetami
4. Kiedy skonczone -- `<leader>tx` przenosi do Done
5. Spectre pomaga zmienic kod (np. zamiana nazw po refaktorze)

---

## Cwiczenia

### Cwiczenie 1: Podstawowe uzycie Spectre

1. Otworz dowolny plik z projektu, np. `exercises/typescript/api-service.ts`
2. Nacisnij `<leader>S` -- otwiera sie panel Spectre
3. Wpisz `function` w polu Search
4. Obserwuj wyniki -- kazda linia zawierajaca "function" jest wylistowana
5. Nacisnij `Enter` na jednym z wynikow -- przeniesie Cie do tej linii w pliku
6. Nacisnij `<leader>S` zeby zamknac Spectre

### Cwiczenie 2: Search word under cursor

1. Otworz `exercises/typescript/interfaces.ts`
2. Ustaw kursor na slowie `string` (gdziekolwiek w pliku)
3. Nacisnij `<leader>sw` -- Spectre otwiera sie z `string` w polu Search
4. Przejrzyj ile razy `string` wystepuje w projekcie
5. Zamknij Spectre: `<leader>S`

### Cwiczenie 3: Szukaj w biezacym pliku

1. Otworz `exercises/python/data_processing.py`
2. Nacisnij `<leader>sp` -- Spectre otwiera sie z filtrem na biezacy plik
3. Wpisz `self` w polu Search
4. Zobaczysz wyniki TYLKO z biezacego pliku
5. Zamknij Spectre: `<leader>S`

### Cwiczenie 4: Praktyczny search & replace

1. Otworz `exercises/typescript/api-service.ts`
2. Ustaw kursor na `ApiResponse` i nacisnij `<leader>sw`
3. W polu Replace wpisz `ServiceResponse`
4. Przejrzyj podglad zmian -- czerwony (stary tekst) vs zielony (nowy)
5. Usun kilka wynikow, ktorych nie chcesz zmieniac (`dd` na wybranej linii)
6. **NIE zatwierdzaj zmian** (to cwiczenie) -- zamknij Spectre: `<leader>S`
7. Wazne: dopoki nie nacisniesz `<leader>R`, zadne pliki nie zostana zmienione

### Cwiczenie 5: Regex w Spectre

1. Otworz Spectre: `<leader>S`
2. Wlacz regex mode: `I` (w panelu Spectre)
3. Wpisz w Search: `console\.log\(.*\)`
4. Przejrzyj wyniki -- zobaczysz wszystkie `console.log()` w projekcie
5. Mozesz uzyc Replace: (pusty) -- zeby usunac te linie
6. Zamknij bez zatwierdzania: `<leader>S`

### Cwiczenie 6: Todo-comments -- nawigacja

1. Otworz `exercises/python/calculator.py`
2. Nacisnij `]t` kilka razy -- skaczesz do kolejnych komentarzy TODO/FIXME/NOTE
3. Nacisnij `[t` -- wracasz do poprzednich
4. Nacisnij `<leader>ft` -- otwiera sie Telescope z WSZYSTKIMI todo-comments w projekcie
5. Przejrzyj liste, zwroc uwage na kolory i typy
6. Wybierz dowolny wynik (Enter) -- przeniesie Cie do tego komentarza

### Cwiczenie 7: Todo-comments -- rozpoznawanie typow

1. Otworz `exercises/python/data_processing.py`
2. Dodaj nastepujace komentarze w roznych miejscach (tryb Insert):
   ```
   # TODO: zoptymalizowac ten fragment
   # FIXME: bledna walidacja danych
   # HACK: tymczasowe obejscie
   # NOTE: zmienione w wersji 2.0
   ```
3. Wroc do Normal mode i obserwuj kolorowe podswietlenia
4. Nacisnij `]t` i `[t` zeby nawigowac miedzy dodanymi komentarzami
5. Nacisnij `<leader>ft` -- Twoje nowe komentarze powinny pojawic sie w liscie
6. Cofnij zmiany: `u` wielokrotnie (nie zapisuj pliku)

### Cwiczenie 8: Todo notes -- tworzenie i zarzadzanie

> To cwiczenie wymaga pliku `notes/todo.md` w dowolnym projekcie.

1. Stworz plik `notes/todo.md` jesli nie istnieje (`:e notes/todo.md`)
2. Dodaj strukture:
   ```markdown
   ## In Progress

   ## Backlog

   ## Done
   ```
3. Ustaw kursor w sekcji Backlog i nacisnij `<leader>ta` -- dodaje nowe zadanie
4. Wpisz tresc zadania, wroc do Normal mode
5. Nacisnij `<leader>ti` -- przenosi zadanie do In Progress
6. Nacisnij `<leader>tx` -- zaznacza jako zrobione i przenosi do Done
7. Obserwuj, ze daty `@created` i `@done` dodaja sie automatycznie

### Cwiczenie 9: Todo notes -- reorderowanie i usuwanie

1. W pliku `notes/todo.md` dodaj 3 zadania w sekcji Backlog (`<leader>ta` x3)
2. Ustaw kursor na srodkowym zadaniu
3. `<leader>tk` -- przenies zadanie w gore
4. `<leader>tj` -- przenies zadanie w dol
5. `<leader>tD` -- usun zadanie
6. Dodaj 2 nowe zadania, przenies jedno do In Progress (`<leader>ti`)
7. Przenies drugie do Done (`<leader>td`)

### Cwiczenie 10: Pelny workflow -- od TODO w kodzie do zarzadzania

1. Otworz `exercises/typescript/store.ts`
2. Dodaj komentarz `// TODO: dodac walidacje preferencji` gdzies w kodzie
3. Nacisnij `<leader>ft` -- znajdz swoje TODO w liscie Telescope
4. Otworz `notes/todo.md` i dodaj to samo zadanie (`<leader>ta`)
5. Wroc do kodu i uzywaj `]t`/`[t` do nawigacji po todo-comments
6. Cofnij zmiany w pliku TS: `u` wielokrotnie

---

## Cwiczenie bonusowe

**Pelny refaktoring z Spectre + todo-comments:**

1. Otworz `exercises/typescript/api-service.ts`
2. Dodaj komentarz `// TODO: zmien ApiResponse na ServiceResponse` na gorze pliku
3. Ustaw kursor na `ApiResponse` gdzies w kodzie
4. `<leader>sw` -- Spectre otwiera sie z tym slowem
5. W Replace wpisz `ServiceResponse`
6. Przejrzyj WSZYSTKIE wyniki w calym projekcie
7. Usun wyniki z plikow, ktorych nie chcesz zmieniac (`dd`)
8. **Opcjonalnie**: zatwierdz (`<leader>R`) lub zamknij bez zmian (`<leader>S`)
9. Nacisnij `<leader>ft` -- Twoje TODO nadal widoczne w liscie
10. Cel: naucz sie laczyc search & replace z organizacja zadan

---

## Podsumowanie

### Nauczone komendy

| Komenda | Opis |
|---------|------|
| `<leader>S` | Toggle Spectre (project-wide search & replace) |
| `<leader>sw` | Szukaj slowa pod kursorem w Spectre |
| `<leader>sp` | Szukaj w biezacym pliku (Spectre) |
| `<leader>ft` | Znajdz wszystkie TODO/FIXME/etc. (Telescope) |
| `]t` / `[t` | Nastepny / poprzedni todo-comment |
| `<leader>ta` | Dodaj zadanie (todo notes) |
| `<leader>tx` | Smart toggle done (todo notes) |
| `<leader>td` | Przenies do Done (todo notes) |
| `<leader>ti` | Przenies do In Progress (todo notes) |
| `<leader>tb` | Przenies do Backlog (todo notes) |
| `<leader>tD` | Usun zadanie (todo notes) |
| `<leader>tk/tj` | Przenies zadanie w gore / w dol (todo notes) |
| `<leader>tA` | Archiwizuj stare Done (todo notes) |

### Konfiguracja uzyta w tej lekcji

| Element | Wartosc / Opis |
|---------|---------------|
| Spectre | DiffDelete/DiffAdd highlighting, regex support |
| Todo-comments | 6 typow: TODO, FIXME, HACK, WARN, PERF, NOTE |
| Todo notes | Aktywne w `*/notes/todo.md`, auto-save, auto-archive >7 dni |

### Co dalej?

W **lekcji 32** poznasz **terminal i tmux** na zaawansowanym poziomie -- Toggleterm,
tmux popups (Cmd+Shift+key), zarzadzanie sesjami i pelna kontrole nad srodowiskiem
terminalowym.
