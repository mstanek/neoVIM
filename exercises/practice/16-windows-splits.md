# Cwiczenie 16: Windows i splits

> Powiazana lekcja: `lessons/16-windows-splits.md`

## Instrukcje
- `Ctrl+w v` / `:vsplit` -- split pionowy (nowe okno po prawej)
- `Ctrl+w s` / `:split` -- split poziomy (nowe okno na dole)
- `Ctrl+h/j/k/l` -- nawigacja miedzy oknami (bezszwowa z tmux)
- `Ctrl+w q` -- zamknij biezace okno
- `Ctrl+w o` -- zamknij WSZYSTKIE oprocz biezacego
- `Ctrl+w =` -- wyrownaj okna, `Ctrl+w _` / `Ctrl+w |` -- maksymalizuj
- `Ctrl+w r` -- rotuj okna, `Ctrl+w x` -- zamien z nastepnym
- tmux: `prefix + |` split, `prefix + -` split, `prefix + z` zoom

## Cwiczenie 1: Porownanie dwoch implementacji

Otworz dwie wersje utils obok siebie:

1. Otworz `exercises/python/utils.py`
2. `Ctrl+w v` -- split pionowy
3. W nowym oknie: `:e exercises/typescript/utils.ts`
4. Nawiguj `Ctrl+h` / `Ctrl+l` miedzy oknami
5. Porownaj implementacje -- jakie roznice widzisz miedzy Python a TypeScript?
6. Zamknij prawe okno: przejdz do niego (`Ctrl+l`) i `Ctrl+w q`

## Cwiczenie 2: Layout kod + interfejsy

Typowy setup do pracy z TypeScript -- kod po lewej, typy po prawej:

1. Otworz `exercises/typescript/api-service.ts`
2. `Ctrl+w v` -- split pionowy
3. W prawym oknie: `:e exercises/typescript/interfaces.ts`
4. Przejdz z powrotem do lewego okna (`Ctrl+h`)
5. Edytuj kod w `api-service.ts`, a typy sprawdzaj w `interfaces.ts`
6. Przelaczaj sie `Ctrl+h` / `Ctrl+l` -- to podstawowy workflow TypeScript

## Cwiczenie 3: Layout z trzema oknami (L-shape)

Stworz layout: duzy edytor po lewej, dwa mniejsze po prawej:

1. Otworz `exercises/python/calculator.py`
2. `Ctrl+w v` -- split pionowy
3. Przejdz do prawego okna (`Ctrl+l`)
4. `Ctrl+w s` -- split poziomy w prawym oknie
5. W gornym prawym: `:e exercises/python/utils.py`
6. W dolnym prawym (`Ctrl+j`): `:e exercises/python/models.py`
7. Przetrenuj nawigacje: `Ctrl+h` do glownego, `Ctrl+l` + `Ctrl+j/k` po prawej
8. `Ctrl+w =` -- wyrownaj wszystkie okna

## Cwiczenie 4: Resize okien Neovim

Kontynuujac layout z cwiczenia 3:

1. Przejdz do lewego okna (`Ctrl+h`)
2. `20 Ctrl+w >` -- poszerz lewe okno o 20 kolumn (to Twoj glowny edytor)
3. `Ctrl+w =` -- wyrownaj z powrotem
4. `Ctrl+w |` -- maksymalizuj szerokosc lewego okna
5. `Ctrl+w =` -- wyrownaj
6. Przejdz do gornego prawego (`Ctrl+l`), nacisnij `Ctrl+w _` -- maksymalizuj wysokosc
7. `Ctrl+w =` -- wyrownaj wszystko z powrotem

## Cwiczenie 5: Ten sam buffer w dwoch oknach

Przydatne gdy pracujesz z dlugim plikiem -- definicje na gorze, uzycia na dole:

1. Otworz `exercises/python/data_processing.py`
2. `Ctrl+w s` -- split poziomy (ten sam plik w obu oknach!)
3. W gornym oknie: przejdz do importow na gorze (`gg`)
4. W dolnym oknie (`Ctrl+j`): przejdz do ostatniej funkcji (`G`)
5. Teraz widzisz gora i dol tego samego pliku jednoczesnie
6. Edytuj w jednym oknie -- zmiany sa widoczne w obu natychmiast!
7. Zamknij dodatkowe okno: `Ctrl+w q`

## Cwiczenie 6: Otwieranie z Telescope do splitu

Uzywaj Telescope do otwierania plikow bezposrednio w splitach:

1. Otworz dowolny plik
2. `<leader>ff` -- Telescope find files
3. Wpisz `calculator` i nacisnij `Ctrl+v` -- otworzy sie w vsplit
4. `<leader>ff` ponownie, wpisz `interfaces` i nacisnij `Ctrl+x` -- hsplit
5. Masz 3 okna, kazde otwarte bezposrednio z Telescope
6. `Ctrl+w o` -- zamknij wszystkie oprocz biezacego

## Cwiczenie 7: Tmux panes + Neovim splits

Polaczony workflow -- Neovim po lewej, terminal po prawej:

1. W tmux: `prefix + |` -- nowy pane po prawej
2. W lewym pane uruchom Neovim z projektem
3. W Neovim zrob `Ctrl+w v` -- teraz masz 2 okna nvim + 1 pane tmux
4. Uzyj `Ctrl+h/j/k/l` do nawigacji miedzy WSZYSTKIMI panelami
5. Zauwaz, ze przejscie z Neovim do tmux jest bezszwowe (vim-tmux-navigator)
6. `prefix + z` na pane terminala -- zoom, uruchom komende, `prefix + z` powrot

## Cwiczenie bonusowe

**Scenariusz: code review setup z 4 oknami**

Przygotuj layout do przegladu PR ktory zmienia model, serwis i testy:

1. Otworz `exercises/python/models.py`
2. `Ctrl+w v` -- split pionowy
3. W prawym oknie: `:e exercises/python/calculator.py`
4. Przejdz do lewego (`Ctrl+h`), `Ctrl+w s` -- split poziomy
5. W dolnym lewym (`Ctrl+j`): `:e exercises/python/utils.py`
6. Przejdz do prawego gornego (`Ctrl+l`, `Ctrl+k`), `Ctrl+w s`
7. W dolnym prawym: `:e exercises/python/data_processing.py`
8. Masz layout 2x2 -- idealny do review 4 plikow
9. Uzyj `Ctrl+w =` zeby wyrownac
10. Nawiguj miedzy oknami, czytaj kod
11. Na koniec: `Ctrl+w o` -- zamknij wszystko oprocz biezacego
