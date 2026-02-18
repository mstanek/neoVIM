# Cwiczenie 30: IDE mode i panele

> Powiazana lekcja: `lessons/30-ide-mode-panele.md`

## Instrukcje
- `<leader>i` -- toggle IDE mode (neo-tree + aerial + focus edytor)
- `<leader>e` -- toggle neo-tree (eksplorator plikow)
- `<leader>o` -- toggle aerial (outline) / zamyka git status
- `<leader>gs` -- toggle git status / zamyka aerial
- `Ctrl+h/j/k/l` -- nawigacja miedzy oknami
- `<Space>` + czekaj -- which-key (podglad wszystkich keybindow)
- Neo-tree: `a` (nowy), `d` (usun), `r` (rename), `/` (filtruj), `?` (pomoc)
- Aerial: `Enter` (skocz), `{`/`}` (prev/next), `l`/`h` (rozwin/zwin)

## Cwiczenie 1: Operacje na plikach w neo-tree

1. Wlacz IDE mode: `<leader>i`
2. Przejdz do neo-tree: `Ctrl+h`
3. Nawiguj do katalogu `exercises/python/` (`j`/`k` + `Enter`)
4. Nacisnij `a` -- wpisz nazwe `temp_test.py`, Enter (tworzy nowy plik)
5. Nacisnij `r` na nowym pliku -- zmien nazwe na `temp_renamed.py`
6. Nacisnij `y` -- skopiuj nazwe pliku do clipboard
7. Nacisnij `d` -- usun plik (potwierdz)
8. Wroc do edytora: `Ctrl+l`

## Cwiczenie 2: Filtrowanie i kopiowanie sciezek w neo-tree

1. Wlacz neo-tree: `<leader>e`
2. Przejdz do neo-tree: `Ctrl+h`
3. Nacisnij `/` -- wpisz `store` -- powinien pojawic sie `store.ts`
4. Nacisnij `Enter` na wyniku -- otwiera plik
5. Wroc do neo-tree: `Ctrl+h`
6. Nacisnij `/` ponownie -- wpisz `.vue` -- filtruj pliki Vue
7. Otworz `UserCard.vue`
8. Wroc do neo-tree: `Ctrl+h`
9. Nacisnij `Y` na pliku -- skopiuj wzgledna sciezke do clipboard
10. Nacisnij `.` -- pokaz/ukryj ukryte pliki (np. `.gitignore`)
11. Nacisnij `?` -- przejrzyj pelna pomoc neo-tree, `q` zeby zamknac
12. Zamknij neo-tree: `<leader>e`

## Cwiczenie 3: Nawigacja po strukturze pliku z aerial

1. Otworz `exercises/python/data_processing.py`
2. Wlacz aerial: `<leader>o`
3. Przejdz do aerial: `Ctrl+l`
4. Nacisnij `L` -- rozwin wszystkie galezie (zobaczysz klasy + ich metody)
5. Uzyj `}` kilka razy -- skaczesz do kolejnych symboli
6. Uzyj `{` -- cofasz sie do poprzednich
7. Nacisnij `H` -- zwin wszystkie galezie
8. Rozwin konkretna klase: `l` na wybranej pozycji
9. `Enter` na dowolnej metodzie -- kursor w edytorze skoczy do niej
10. Zamknij aerial: `<leader>o`

## Cwiczenie 4: Szybkie przelaczanie miedzy plikami

1. Wlacz IDE mode: `<leader>i`
2. `Ctrl+h` -- przejdz do neo-tree
3. Otworz `exercises/python/calculator.py` (Enter)
4. Przejrzyj aerial po prawej -- widoczne funkcje `add`, `subtract` itd.
5. `Ctrl+h` -- wroc do neo-tree
6. Otworz `exercises/typescript/api-service.ts` (Enter)
7. Aerial automatycznie sie aktualizuje -- teraz widac interfejsy i funkcje TS
8. Powtorz 3x z roznymi plikami -- zauwaz jak aerial reaguje na zmiane pliku

## Cwiczenie 5: Dwa layouty -- development vs review

1. Zbuduj layout development:
   - `<leader>i` -- neo-tree + aerial
   - `Ctrl+l` (do aerial), `Enter` na symbolu, `Ctrl+h` (do edytora)
2. Przelacz na layout review:
   - `<leader>gs` -- zamien aerial na git status
   - `Ctrl+l` -- przejdz do git status, przejrzyj zmiany
3. Wroc do development:
   - `<leader>o` -- zamien git status na aerial
4. Przelacz 5 razy miedzy `<leader>gs` i `<leader>o`
5. Zamknij wszystko: `<leader>i`

## Cwiczenie 6: Which-key -- budowanie nawyku

1. Nacisnij `<Space>` i czekaj -- przeczytaj liste kategorii
2. Wejdz w `<Space>b` (bufory) -- przeczytaj dostepne akcje, `Esc`
3. Wejdz w `<Space>f` (find) -- przeczytaj, `Esc`
4. Wejdz w `<Space>g` (git) -- przeczytaj, `Esc`
5. Wejdz w `<Space>l` (LSP) -- przeczytaj, `Esc`
6. Wejdz w `<Space>t` (todo) -- przeczytaj, `Esc`
7. Cel: uzywaj which-key zamiast szukac w notatkach. Nacisnij Space i czekaj

## Cwiczenie 7: Layout z trouble (diagnostyka)

1. Otworz `exercises/python/broken.py` (plik z bledami)
2. Wlacz IDE mode: `<leader>i`
3. Nacisnij `<leader>xd` -- otwiera trouble z diagnostyka na dole
4. Masz teraz 4 panele: neo-tree | edytor | aerial + trouble na dole
5. Nawiguj do trouble: `Ctrl+j`
6. Przejrzyj bledy, `Enter` na bledzie -- skoczy do niego w edytorze
7. Wroc do trouble: `Ctrl+j`, przejdz do nastepnego bledu
8. Zamknij trouble: `<leader>xd`
9. Przelacz aerial na git status: `<leader>gs`
10. Masz teraz: neo-tree | edytor | git status
11. Wroc do aerial: `<leader>o`
12. Zamknij IDE mode: `<leader>i`

## Cwiczenie 8: Praca z wieloma buforami w IDE mode

1. Wlacz IDE mode: `<leader>i`
2. W neo-tree otworz `exercises/python/models.py` (Enter)
3. Otworz split pionowy: `Ctrl+w v`
4. W nowym oknie otworz inny plik: `Ctrl+P`, wpisz `utils`, Enter
5. Aerial po prawej pokazuje strukture aktywnego pliku
6. `Ctrl+h` -- przejdz do lewego okna, aerial aktualizuje sie
7. `Ctrl+l` -- przejdz do prawego okna, aerial znow sie zmienia
8. Zamknij split: `Ctrl+w q`
9. Zamknij IDE mode: `<leader>i`

## Cwiczenie bonusowe

**Multi-file code exploration -- zbuduj pelny workflow:**

1. Zacznij od czystego edytora (bez paneli)
2. `Ctrl+P` -- Smart Open, wpisz `models`, Enter (otwierasz `models.py`)
3. Chcesz zobaczyc strukture -- `<leader>o` (wlacz aerial)
4. W aerial znajdz klase, `Enter` -- skok do niej
5. Chcesz sprawdzic inny plik -- `<leader>e` (dodaj neo-tree)
6. W neo-tree otworz `exercises/typescript/interfaces.ts`
7. Porownaj struktury -- aerial pokazuje interfejsy TS
8. Chcesz sprawdzic git -- `<leader>gs` (zamien aerial na git status)
9. Przejrzyj status, wroc do aerial: `<leader>o`
10. Otworz split: `Ctrl+w v`, w nowym oknie otworz `api-service.ts` przez `Ctrl+P`
11. Masz: neo-tree | edytor 1 | edytor 2 | aerial -- porownujesz dwa pliki
12. Zamknij split: `Ctrl+w q`, zamknij panele: `<leader>i`
