# Cwiczenie 33: PPM, Command Palette i zaawansowane triki

> Powiazana lekcja: `lessons/33-tips-tricks.md`

## Instrukcje
- Right-click -- PPM (popup menu z kontekstowymi opcjami + skrotami w `[]`)
- `Ctrl+Q` -- Command Palette (szukaj dowolnej komendy)
- `Ctrl+P` -- Smart Open (pliki + recent + bufory)
- `gv` -- ponownie zaznacz ostatnia selekcje Visual
- `gi` -- wroc do ostatniego Insert i wejdz w Insert mode
- `Ctrl+o` (w Insert) -- wykonaj jedna komende Normal, wroc do Insert
- `gU{motion}` / `gu{motion}` / `g~{motion}` -- uppercase / lowercase / toggle
- `Ctrl+a` / `Ctrl+x` -- inkrement / dekrement liczby
- `g Ctrl+a` -- tworzenie sekwencji (w Visual Block)
- `m{a-z}` / `m{A-Z}` -- marks lokalne / globalne
- `:earlier Xm` / `:later Xm` -- undo time travel
- `:.!command` / `:%!command` -- zamien linie/plik na wyjscie komendy shell

## Cwiczenie 1: PPM -- poznaj opcje menu

1. Otworz `exercises/python/data_processing.py`
2. Ustaw kursor na nazwie klasy i kliknij prawym przyciskiem
3. Przejrzyj sekcje menu: Clipboard, Navigate, Refactor, Git...
4. Wybierz "Peek Definition" -- podglad definicji w popupie
5. `Esc` zeby zamknac peek
6. Kliknij prawym na innej nazwie, wybierz "References"
7. Zaznacz 3 linie (`V`, `jj`), kliknij prawym -- zauwaz inne opcje (Visual mode)
8. Wybierz "Comment" -- zakomentuje zaznaczenie

## Cwiczenie 2: Command Palette -- odkrywanie komend

1. `Ctrl+Q` -- otworz Command Palette
2. Wpisz `color` -- znajdz komendy zwiazane z kolorami/theme
3. `Esc`, otworz ponownie
4. Wpisz `lsp` -- przejrzyj komendy LSP (restart, info, log)
5. `Esc`, otworz ponownie
6. Wpisz `snacks` -- zobacz komendy Snacks (dashboard, notifier, etc.)
7. `Esc`, otworz ponownie
8. Wpisz `noice` -- komendy Noice (history, dismiss, etc.)
9. Cel: Command Palette to sposob na znalezienie komendy, gdy nie znasz skrotu

## Cwiczenie 3: Smart Open -- szybkie otwieranie plikow

1. `Ctrl+P` -- otworz Smart Open
2. Wpisz `calc` -- powinien pojawic sie `calculator.py`
3. `Enter` -- otworz plik
4. `Ctrl+P`, wpisz `vue` -- zobaczysz pliki `.vue`
5. `Enter` na `UserCard.vue`
6. `Ctrl+P`, wpisz `brok` -- pliki z "broken" w nazwie
7. Zauwaz priorytet: bufory (otwarte pliki) sa na gorze listy
8. Powtorz: `Ctrl+P`, wpisz `dat` -- `data_processing.py` moze byc wysoko (recent)

## Cwiczenie 4: Inkrement/dekrement -- edycja liczb

Wpisz ponizszy blok w nowym buforze (`:enew`, tryb Insert):

```css
.box-1 { margin: 5px; padding: 10px; z-index: 1; }
.box-2 { margin: 5px; padding: 10px; z-index: 1; }
.box-3 { margin: 5px; padding: 10px; z-index: 1; }
.box-4 { margin: 5px; padding: 10px; z-index: 1; }
.box-5 { margin: 5px; padding: 10px; z-index: 1; }
```

Zadania:
1. Ustaw kursor na `5` (margin) w pierwszej linii, `10 Ctrl+a` -- zmieni na 15
2. Ustaw kursor na `10` (padding) w pierwszej linii, `Ctrl+x` -- zmieni na 9
3. Zaznacz kolumne `z-index: 1` we wszystkich liniach: `Ctrl+v`, zaznacz w dol
4. `g Ctrl+a` -- zamieni `1, 1, 1, 1, 1` na `1, 2, 3, 4, 5`

## Cwiczenie 5: Tworzenie sekwencji -- praktyczny przyklad

Wpisz w nowym buforze (`:enew`):

```
item 0: first
item 0: second
item 0: third
item 0: fourth
item 0: fifth
item 0: sixth
item 0: seventh
item 0: eighth
```

1. Ustaw kursor na pierwszym `0`
2. `Ctrl+v` -- Visual Block, zaznacz wszystkie `0` w dol (`7j`)
3. `g Ctrl+a` -- zamieni na sekwencje `1, 2, 3, 4, 5, 6, 7, 8`
4. Cofnij: `u`
5. Sprobuj inaczej: zaznacz ponownie, `5 g Ctrl+a` -- sekwencja `5, 10, 15, 20...`

## Cwiczenie 6: Zmiana wielkosci liter -- refaktoring nazw

Wpisz w nowym buforze:

```
user_name
api_response
data_loader
http_client
session_manager
```

Zadania:
1. Kursor na `user_name`: `gUiw` -- zamieni na `USER_NAME` (uppercase inner word)
2. `guiw` -- wroc do `user_name`
3. Kursor na `api_response`: `gU$` -- uppercase do konca linii
4. `guu` -- cala linia lowercase
5. Kursor na `d` w `data_loader`: `g~w` -- toggle case: `DATA_loader`
6. Zaznacz 3 linie (`V`, `jj`): `gU` -- wszystkie uppercase

## Cwiczenie 7: Marks -- skakanie miedzy punktami kodu

1. Otworz `exercises/python/data_processing.py`
2. Znajdz pierwsza klase -- ustaw mark: `ma`
3. Znajdz pierwsza funkcje standalone -- ustaw mark: `mb`
4. Przejdz na koniec pliku: `G`
5. `` `a `` -- skok do klasy, `` `b `` -- skok do funkcji
6. Ustaw mark globalny: `mP` (P jak Python)
7. Otworz `exercises/typescript/api-service.ts`
8. Ustaw mark globalny: `mT` (T jak TypeScript)
9. `` `P `` -- skok do Pythona, `` `T `` -- skok do TypeScript
10. `` `P `` ponownie -- nawigacja miedzy plikami jednym skrotem

## Cwiczenie 8: Komendy shell i undo time travel

1. Otworz nowy bufor: `:enew`
2. Wpisz kilka linii tekstu (np. lista zakupow)
3. Na pustej linii wpisz: `:r !date` -- wstawi biezaca date
4. Na nowej linii wpisz: `:r !whoami` -- wstawi nazwe uzytkownika
5. Wpisz linie: `{"name": "test", "value": 42}`
6. Ustaw kursor na tej linii: `:.!python3 -c "import sys,json; print(json.dumps(json.loads(sys.stdin.read()), indent=2))"`
   -- sformatuje JSON
7. Poczekaj ~30 sekund, dodaj nowy tekst
8. `:earlier 30s` -- cofnij stan pliku o 30 sekund
9. `:later 30s` -- wroc do przodu
10. `:earlier 3f` -- cofnij o 3 zapisy pliku (jesli zapisywales)

## Cwiczenie bonusowe

**Speedrun zaawansowanych operacji -- wykonaj kazda w <5 sekund:**

1. `Ctrl+P`, `models`, Enter -- otworz plik, ustaw mark: `mM`
2. `Ctrl+P`, `api`, Enter -- otworz drugi, ustaw mark: `mA`
3. `` `M `` -- skok do modeli, zaznacz nazwe klasy (`viw`), `gU` (uppercase)
4. Cofnij (`u`), `gv` (ponownie zaznacz), `gu` (lowercase), cofnij (`u`)
5. `gi` -- wroc do ostatniego Insert, `Esc`, `` `A `` -- skok do API
6. Znajdz liczbe, `5 Ctrl+a` -- zwieksz o 5, cofnij `u`
7. PPM (right-click) -- "Blame", `Cmd+Shift+D` -- LazyGit, `q`
8. `Ctrl+Q` -- Command Palette: `noice`, wybierz "Noice History"
