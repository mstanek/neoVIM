# Cwiczenie 32: Terminal i tmux

> Powiazana lekcja: `lessons/32-terminal-tmux.md`

## Instrukcje
- `Ctrl+\` -- toggle terminal (Toggleterm)
- `Esc Esc` -- wyjdz z Terminal mode do Normal mode (w buforze terminala)
- `i` / `a` -- wroc do Terminal mode z Normal mode
- Tmux prefix: `Ctrl+Space`
- `prefix + |` / `prefix + -` -- split pion / poziom
- `prefix + z` -- zoom toggle (fullscreen pane)
- `prefix + [` -- copy mode (vi-style), `v` zaznacz, `y` kopiuj
- `prefix + H/J/K/L` -- resize pane (repeatable)
- Popups: `Cmd+Shift+D` (LazyGit), `Cmd+Shift+Y` (Yazi), `Cmd+Shift+T` (Btop)
- Popups: `Cmd+Shift+S` (Scratchpad), `Cmd+Shift+H` (Cheat sheet), `Cmd+Shift+?` (Help)

## Cwiczenie 1: Toggleterm -- uruchamianie komend bez opuszczania edytora

1. Otworz `exercises/python/calculator.py`
2. `Ctrl+\` -- otworz terminal
3. Wpisz: `python3 exercises/python/calculator.py` (lub odpowiednik) i Enter
4. Przejrzyj wynik
5. `Ctrl+\` -- ukryj terminal
6. Edytuj cos w pliku (np. zmien wartosc)
7. `Ctrl+\` -- pokaz terminal (poprzedni wynik nadal widoczny)
8. Strzalka w gore -- poprzednia komenda, Enter -- uruchom ponownie
9. `Ctrl+\` -- ukryj

## Cwiczenie 2: Kopiowanie z wyjscia terminala

1. `Ctrl+\` -- otworz terminal
2. Wpisz: `ls -la exercises/` i Enter
3. `Esc Esc` -- przejdz do Normal mode w buforze terminala
4. Nawiguj do linii z `python` (uzyj `k` lub `/python`)
5. `V` -- Visual line, zaznacz 2-3 linie (`j`)
6. `y` -- skopiuj
7. `Ctrl+\` -- ukryj terminal
8. W edytorze otworz nowy bufor `:enew` i wklej: `p`
9. Masz skopiowane wyjscie terminala w buforze edytora

## Cwiczenie 3: Nawigacja terminal -- edytor

1. Otworz `exercises/typescript/store.ts`
2. `Ctrl+\` -- otworz terminal
3. Wpisz: `wc -l exercises/typescript/*.ts` i Enter
4. `Esc Esc` -- Normal mode w terminalu
5. `Ctrl+k` -- przejdz do edytora (okno nad terminalem)
6. Przejrzyj kod w edytorze
7. `Ctrl+j` -- wroc do terminala
8. `i` -- Terminal mode, wpisz nastepna komende
9. Powtorz cykl 3x: edytor (`Ctrl+k`) -> terminal (`Ctrl+j`) -> komenda (`i`)

## Cwiczenie 4: Tmux splits -- rownolegle zadania

1. Stworz split pionowy: `prefix + |` (Ctrl+Space, potem |)
2. W nowym pane wpisz: `watch -n 2 date` (zegar aktualizujacy sie co 2s)
3. Wroc do poprzedniego pane: `Ctrl+h`
4. Stworz split poziomy: `prefix + -`
5. Masz 3 panes -- uzyj `Ctrl+h/j/k/l` do nawigacji miedzy nimi
6. Zoom na jednym pane: `prefix + z` -- rozwija sie na caly ekran
7. `prefix + z` ponownie -- wraca do layoutu
8. Zamknij dodatkowe panes: `prefix + x` (potwierdz `y`) w kazdym

## Cwiczenie 5: Tmux resize i windows

1. Stworz split: `prefix + |`
2. Zmien rozmiar lewego pane: `prefix + L` (zwieksz szerokosc) -- trzymaj `L`
3. `prefix + H` -- zmniejsz szerokosc
4. Stworz nowe okno tmux: `prefix + c`
5. Nadaj mu nazwe: `prefix + ,` -- wpisz `testy`, Enter
6. Wroc do poprzedniego okna: `Alt+Shift+Left` (lub `Alt+1`)
7. Przejdz do okna `testy`: `Alt+Shift+Right` (lub `Alt+2`)
8. Zamknij okno: wpisz `exit` w shellu

## Cwiczenie 6: Copy mode -- precyzyjne kopiowanie

1. W terminalu tmux (nie Toggleterm) uruchom:
   `cat exercises/python/data_processing.py`
2. `prefix + [` -- wejdz w copy mode
3. Nawiguj do definicji klasy: `/class`, Enter
4. `v` -- rozpocznij zaznaczanie
5. Zaznacz cala definicje klasy (kilka linii w dol: `j` lub `}`)
6. `y` -- kopiuj do clipboard
7. Otwroz nowy plik w Neovimie i wklej: `Cmd+V`
8. Skopiowany fragment powinien pojawic sie w edytorze

## Cwiczenie 7: Tmux popups -- szybkie narzedzia

Wykonaj kazdy popup i zamknij go -- cel to zapamietanie skrotow:

1. `Cmd+Shift+D` -- LazyGit: nawiguj panelami (`Tab`), przejrzyj status, `q`
2. `Cmd+Shift+Y` -- Yazi: przejdz do `exercises/vue/`, podejrzyj plik, `q`
3. `Cmd+Shift+T` -- Btop: sprawdz procesy, znajdz `nvim` (filtr `f`), `q`
4. `Cmd+Shift+S` -- Scratchpad: wpisz notatke "do sprawdzenia: auth module", `Esc`, `q`
5. `Cmd+Shift+H` -- Cheat sheet: wyszukaj `/spectre`, `q`
6. Zmierz czas -- kazdy popup powinien trwac <10 sekund

## Cwiczenie 8: Sesje tmux -- organizacja projektow

1. Sprawdz nazwe biezacej sesji: `prefix + s` (lista sesji), `Esc`
2. Zmien nazwe sesji: `prefix + $` -- wpisz `vim-tutor`, Enter
3. Stworz nowa sesje tmux z terminala:
   - `Ctrl+\` (Toggleterm), wpisz: `tmux new-session -d -s experiments`
   - `Ctrl+\` (ukryj)
4. Przelacz sie: `prefix + s` -- zobaczysz dwie sesje, wybierz `experiments`
5. Wroc do `vim-tutor`: `prefix + s`, wybierz ja
6. Detach od sesji: `prefix + d` (sesja zyje w tle)
7. Z powrotem: `tmux attach -t vim-tutor`

## Cwiczenie bonusowe

**Development workflow -- serwer + edytor + monitoring:**

1. Otworz plik projektu w Neovimie
2. Stworz layout tmux: `prefix + |` (split), w nowym pane wpisz `htop`
3. Wroc do Neovima: `Ctrl+h`
4. `Ctrl+\` -- Toggleterm: wpisz `echo "server simulation"` (udaj serwer)
5. `Ctrl+\` -- ukryj terminal
6. Edytuj kod -- wlacz IDE mode: `<leader>i`
7. `Cmd+Shift+D` -- LazyGit: przejrzyj diff, `q`
8. `Ctrl+\` -- pokaz terminal: sprawdz "logi serwera"
9. `Esc Esc` -- Normal mode: `/error` (szukaj bledow w wyjsciu)
10. `Ctrl+k` -- wroc do edytora
11. `prefix + z` -- zoom na Neovimie (fullscreen do skupionej pracy)
12. `prefix + z` -- wroc do pelnego layoutu
13. Zamknij dodatkowy pane: `Ctrl+l`, `prefix + x`, `y`
14. Wylaczy IDE mode: `<leader>i`
