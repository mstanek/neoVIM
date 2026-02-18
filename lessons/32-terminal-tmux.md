# Lekcja 32: Terminal i tmux -- pelna kontrola

> Czas: ~30-45 min | Poziom: Advanced

---

## Cel lekcji

Nauczysz sie:

- Uzywac Toggleterm jako wbudowany terminal w Neovimie
- Korzystac z tmux popups (Cmd+Shift+key) do uruchamiania narzedzi w okienkach
- Zarzadzac sesjami tmux (tworzenie, przywracanie, nazwy)
- Laczyc terminal, tmux i Neovim w spojny workflow

---

## Teoria

### Toggleterm -- terminal wbudowany w Neovim

Toggleterm daje Ci terminal bez opuszczania Neovima. Zamiast przelaczac sie miedzy
oknami tmux, otwierasz terminal na dole ekranu jednym klawiszem:

| Klawisz | Dzialanie |
|---------|-----------|
| `Ctrl+\` | Toggle terminal (pokaz / ukryj) |

Terminal otwiera sie na dole ekranu z wysokoscia 15 linii i lekko przyciemnionym tlem
(shading factor=2). To pozwala wizualnie odroznic terminal od edytora.

```
  +------------------------------------------+
  |                                          |
  |              Neovim edytor               |
  |                                          |
  +------------------------------------------+
  | $ npm run test                           |  <- Toggleterm
  | PASS tests/api.test.ts                   |     (15 linii)
  | 42 tests passed                          |
  +------------------------------------------+
```

### Tryby w terminalu

Terminal w Neovimie ma swoj wlasny tryb -- **Terminal mode**. Kiedy wpisujesz komendy,
jestes w Terminal mode. Zeby wyjsc i uzywac normalnych komend Vim:

| Klawisz | Dzialanie |
|---------|-----------|
| `<Esc><Esc>` | Wyjdz z Terminal mode -> Normal mode (w buforze terminala) |
| `Ctrl+\` | Ukryj terminal (toggle) |

**Sekwencja pracy:**

1. `Ctrl+\` -- otwiera terminal (jestes w Terminal mode, mozesz wpisywac komendy)
2. Wpisujesz np. `npm run test` i Enter
3. Chcesz skopiowac fragment wyniku -> `<Esc><Esc>` (przechodzisz do Normal mode)
4. Nawigujesz `j`/`k`, zaznaczasz Visual mode, kopiujesz `y`
5. `Ctrl+\` -- ukrywasz terminal i wracasz do edytora

> **Twoja konfiguracja**: W terminalu `<Esc><Esc>` (podwojny Escape) jest zamapowany na
> wyjscie z Terminal mode. Pojedynczy Escape nie dziala -- to celowe, bo wiele programow
> terminalowych (np. fzf, htop) uzywa Esc do wlasnych celow.

### Normal mode w buforze terminala

Po nacisnieciu `<Esc><Esc>` jestes w Normal mode **wewnatrz bufora terminala**. Mozesz:

- Nawigowac po wyjsciu programu (`j`/`k`, `gg`, `G`)
- Szukac tekstu (`/pattern`)
- Zaznaczac i kopiowac (`v`, `y`)
- Przechodzic do innych okien (`Ctrl+h/j/k/l`)

Zeby wrocic do wpisywania komend -- nacisnij `i` lub `a` (jak wejscie w Insert mode,
ale w terminalu to wraca do Terminal mode).

### Tmux -- przypomnienie fundamentow

Tmux to warstwa **nad** terminalem. Daje sesje, okna i panele, ktore przetrwaja zamkniecie
terminala. Twoj prefix to `Ctrl+Space`.

**Panes (panele):**

| Skrot | Dzialanie |
|-------|-----------|
| `prefix + \|` | Nowy pane po prawej (split pionowy) |
| `prefix + -` | Nowy pane na dole (split poziomy) |
| `prefix + x` | Zamknij biezacy pane |
| `prefix + z` | Zoom toggle (fullscreen pane) |
| `Ctrl+h/j/k/l` | Nawigacja miedzy panes (i nvim windows) |
| `Alt+strzalki` | Nawigacja miedzy panes |

**Windows (okna/zakladki):**

| Skrot | Dzialanie |
|-------|-----------|
| `prefix + c` | Nowe okno |
| `prefix + ,` | Zmien nazwe okna |
| `Alt+1` do `Alt+9` | Bezposrednio do okna N |
| `Alt+n` / `Alt+p` | Nastepne / poprzednie okno |
| `Alt+Shift+Left/Right` | Nastepne / poprzednie okno |

**Resize:**

| Skrot | Dzialanie |
|-------|-----------|
| `prefix + H` | Zmniejsz szerokosc o 5 kolumn |
| `prefix + J` | Zwieksz wysokosc o 5 wierszy |
| `prefix + K` | Zmniejsz wysokosc o 5 wierszy |
| `prefix + L` | Zwieksz szerokosc o 5 kolumn |

Te skroty sa **repeatable** -- po pierwszym `prefix + H` mozesz trzymac `H`
bez ponownego wciskania prefixu.

**Copy mode:**

| Skrot | Dzialanie |
|-------|-----------|
| `prefix + [` | Wejdz w copy mode (nawigacja vi-style) |
| `v` | Rozpocznij zaznaczanie (w copy mode) |
| `y` | Skopiuj zaznaczenie do clipboard (pbcopy) |
| `q` | Wyjdz z copy mode |

> **Twoja konfiguracja**: Copy mode jest skonfigurowany w stylu vi. Skopiowany tekst
> trafia do systemowego clipboard (pbcopy na macOS). Mysz jest wlaczona -- zaznaczanie
> myszka tez dziala i pokazuje context menu (Copy, Copy & Stay, Search in Google,
> Select Word/Line/All).

**Right-click context menus w tmux:**

| Klik na... | Menu zawiera |
|------------|-------------|
| Pane | Split Horizontally/Vertically, Zoom, Resize, Close |
| Tab (pasek) | New Window, Rename, Move, Close |
| Session | New Session, Rename, Choose Session |

### Tmux popups -- kluczowa funkcja

To **najwazniejsza czesc** Twojego setupu terminalowego. Tmux popups to modalne okienka,
ktore pojawiaja sie nad Twoja sesja. Uruchamiasz w nich narzedzia bez przerywania pracy
w edytorze. Zamkniecie popupu (q/Esc) wraca Cie dokladnie tam, gdzie bylses.

**Jak to dziala technicznie**: Kitty terminal mapuje kombinacje `Cmd+Shift+key` na
sekwencje escape, ktore tmux interpretuje jako User keys i odpala `display-popup`
z odpowiednim programem.

| Klawisz | Narzedzie | Rozmiar | Opis |
|---------|-----------|---------|------|
| `Cmd+Shift+D` | LazyGit | 90x90% | Pelny klient Git (stage, commit, push, rebase) |
| `Cmd+Shift+Y` | Yazi | 80x85% | Przeglądarka plikow (preview, rename, delete) |
| `Cmd+Shift+N` | Notes editor | 40x80% | Edytor notatek (nvim w katalogu notes) |
| `Cmd+Shift+M` | Notes toggle | - | Panel boczny z notatkami |
| `Cmd+Shift+S` | Scratchpad | 50x80% | Tymczasowy notatnik (nie zapisuje sie) |
| `Cmd+Shift+H` | Cheat sheet | 60x85% | Scigawka (read-only) z keybindami |
| `Cmd+Shift+G` | Git quick view | 65x85% | Szybki przeglad stanu Git |
| `Cmd+Shift+J` | Daily journal | 50x80% | Dziennik -- wpisy z datami |
| `Cmd+Shift+K` | Lazydocker | 90x90% | Zarzadzanie Docker containers/images |
| `Cmd+Shift+B` | Lazysql | 90x90% | Klient SQL (polaczenie z bazami danych) |
| `Cmd+Shift+T` | Btop | 85x85% | Monitor systemu (CPU, RAM, procesy) |
| `Cmd+Shift+I` | Pet snippets | 70x80% | Manager snippetow komend shell |
| `Cmd+Shift+E` | Aerc | 90x90% | Klient email w terminalu |
| `Cmd+Shift+?` | Shortcuts help | 95x90% | Pomoc -- lista wszystkich skrotow |

> **Twoja konfiguracja**: Popups otwieraja sie z ciemnym tlem i zaokraglonymi rogami.
> Sa modalne -- nie mozesz wchodzic w interakcje z sesja pod spodem. Zamkniecie
> (q, Esc, lub wyjscie z programu) wraca Cie do stanu sprzed otwarcia.

### Najwazniejsze popups szczegolowo

**LazyGit (`Cmd+Shift+D`)** -- pelny klient Git w TUI:
- Lewy panel: pliki ze zmianami, galezie, commity, stash
- Prawy panel: diff wybranego pliku
- `space` -- stage/unstage pliku
- `c` -- commit
- `P` -- push
- `p` -- pull
- `?` -- pomoc ze skrotami

**Yazi (`Cmd+Shift+Y`)** -- przeglądarka plikow:
- Szybki podglad plikow (nawet obrazki w terminalu!)
- `Enter` -- wejdz do katalogu / otworz plik
- `d` -- usun, `r` -- zmien nazwe, `c` -- kopiuj
- Trzy kolumny: nawigacja + biezacy katalog + podglad

**Btop (`Cmd+Shift+T`)** -- monitor systemu:
- CPU, RAM, dysk, siec w czasie rzeczywistym
- Lista procesow z filtrami
- Przydatne do debugowania "czemu jest wolno"

### Tmux session management

Sesje pozwalaja grupowac prace nad roznymi projektami:

| Skrot | Dzialanie |
|-------|-----------|
| `prefix + $` | Zmien nazwe biezacej sesji |
| `prefix + d` | Detach (odlacz sie od sesji -- sesja zyje dalej) |
| `prefix + s` | Lista sesji (wybierz inna) |

> **Twoja konfiguracja**: Masz zainstalowane **tmux-resurrect** i **tmux-continuum**.
> Tmux automatycznie zapisuje stan sesji co 15 minut i przywraca go po restarcie
> terminala/komputera. Nie musisz pamietac o zapisywaniu -- Twoje layouty, okna,
> panele i katalogi robocze przywroca sie same.

**Vizualna roznica aktywnosci:**

| Element | Opis |
|---------|------|
| Aktywny pane | Normalne tlo (#1e1e2e -- Catppuccin Mocha base) |
| Nieaktywny pane | Ciemniejsze tlo (#1a1a1a) |

To subtelne przyciemnienie pomaga od razu zobaczyc, ktory pane jest aktywny.

---

## Cwiczenia

### Cwiczenie 1: Toggleterm -- podstawy

1. Otworz dowolny plik w Neovimie
2. Nacisnij `Ctrl+\` -- terminal pojawia sie na dole
3. Wpisz `ls -la` i Enter
4. Wpisz `pwd` i Enter
5. Nacisnij `Ctrl+\` -- terminal znika (ale proces nadal dziala)
6. Nacisnij `Ctrl+\` ponownie -- terminal wraca z poprzednim wyjsciem

### Cwiczenie 2: Normal mode w terminalu

1. Otworz terminal: `Ctrl+\`
2. Wpisz `echo "linia 1" && echo "linia 2" && echo "linia 3"` i Enter
3. Nacisnij `<Esc><Esc>` -- przechodzisz do Normal mode w buforze terminala
4. Nawiguj w gore klawiszem `k` -- mozesz przegladac wyjscie
5. Uzyj `/linia` zeby wyszukac tekst w wyjsciu
6. Zaznacz fragment: `v`, potem ruch, potem `y` (kopiowanie)
7. Nacisnij `i` zeby wrocic do Terminal mode
8. Ukryj terminal: `Ctrl+\`

### Cwiczenie 3: Terminal + edytor workflow

1. Otworz `exercises/python/calculator.py`
2. `Ctrl+\` -- otworz terminal
3. W terminalu wpisz: `python3 -c "print(2+2)"` -- szybki test
4. `<Esc><Esc>` -- Normal mode w terminalu
5. `Ctrl+k` -- przejdz do okna edytora (nad terminalem)
6. Edytuj cos w pliku
7. `Ctrl+j` -- wroc do terminala
8. `i` -- Terminal mode, wpisz kolejna komende
9. `Ctrl+\` -- ukryj terminal

### Cwiczenie 4: LazyGit popup

1. Nacisnij `Cmd+Shift+D` -- otwiera sie LazyGit w popupie
2. Przejrzyj interfejs:
   - Panel 1 (lewo-gora): Status / staged files
   - Panel 2 (lewo-srodek): Pliki ze zmianami
   - Panel 3 (prawo): Diff wybranego pliku
3. Nawiguj miedzy panelami: `Tab` lub `h`/`l`
4. Nawiguj w panelu: `j`/`k`
5. Nacisnij `?` -- pokaze sie pomoc z keybindami
6. Zamknij LazyGit: `q`
7. Jestes z powrotem dokladnie tam, gdzie byles

### Cwiczenie 5: Yazi popup

1. Nacisnij `Cmd+Shift+Y` -- otwiera sie Yazi (przegladarka plikow)
2. Nawiguj po katalogach: `j`/`k` (gora/dol), `l` (wejdz do katalogu), `h` (wyjdz)
3. Przejdz do `exercises/python/` -- zobaczysz podglad plikow po prawej
4. Nacisnij `Space` na pliku -- zaznacz go
5. Nacisnij `Esc` lub `q` zeby zamknac Yazi

### Cwiczenie 6: Monitor systemu

1. Nacisnij `Cmd+Shift+T` -- otwiera sie Btop
2. Przejrzyj zuzycie CPU (wykres na gorze)
3. Przejrzyj zuzycie RAM (wykres ponizej)
4. Przejrzyj liste procesow (na dole)
5. Nacisnij `f` -- filtruj procesy (wpisz np. `nvim`)
6. Nacisnij `Esc` zeby wyczyscic filtr
7. Zamknij Btop: `q`

### Cwiczenie 7: Tmux copy mode

1. W terminalu (tmux pane, nie Toggleterm) uruchom komende, ktora wypisze duzo tekstu:
   `ls -la /usr/local/bin`
2. Nacisnij `prefix + [` (Ctrl+Space, potem `[`) -- wchodzisz w copy mode
3. Nawiguj w gore: `k` lub `Ctrl+u` (page up)
4. Nacisnij `v` -- rozpocznij zaznaczanie
5. Zaznacz kilka linii (`j`/`k`)
6. Nacisnij `y` -- kopiujesz do clipboard
7. Wklej gdzies (`Cmd+V` lub `prefix + ]`)

### Cwiczenie 8: Scratchpad i notatki

1. Nacisnij `Cmd+Shift+S` -- otwiera sie Scratchpad
2. Zapisz notatke -- np. "pamietaj o refaktorze auth modulu"
3. Zamknij: `q` lub `Esc`
4. Nacisnij `Cmd+Shift+N` -- otwiera sie Notes editor
5. Przejrzyj notatki, dodaj cos
6. Zamknij: `:q` (to jest nvim w popupie)
7. Nacisnij `Cmd+Shift+J` -- otwiera sie Daily journal
8. Dodaj wpis z dzisiejsza data
9. Zamknij

### Cwiczenie 9: Pomoc i scigawki

1. Nacisnij `Cmd+Shift+H` -- otwiera sie Cheat sheet (read-only)
2. Przeczytaj dostepne skroty -- mozesz uzywac `/` do szukania
3. Zamknij: `q`
4. Nacisnij `Cmd+Shift+?` -- otwiera sie Shortcuts help
5. Przejrzyj pelna liste skrotow Cmd+Shift+*
6. Zamknij

### Cwiczenie 10: Pelny workflow z popups

1. Otworz plik w Neovimie: `exercises/typescript/store.ts`
2. `Cmd+Shift+D` -- LazyGit: sprawdz status repo, zamknij (`q`)
3. `Cmd+Shift+Y` -- Yazi: przejrzyj pliki, zamknij (`q`)
4. `Ctrl+\` -- Toggleterm: uruchom `echo "test"`, ukryj (`Ctrl+\`)
5. `Cmd+Shift+T` -- Btop: sprawdz system, zamknij (`q`)
6. Wroc do edytora -- jestes dokladnie tam, gdzie byles
7. Cel: popups NIE przerywaja pracy, sa jak szybkie "okienka" do zadan

---

## Cwiczenie bonusowe

**Zbuduj pelny workflow projektu:**

1. Uruchom Neovim z plikiem projektu
2. `<leader>i` -- wlacz IDE mode (neo-tree + aerial)
3. `Ctrl+\` -- otworz terminal, uruchom `npm run dev` (lub inny serwer)
4. `Ctrl+\` -- ukryj terminal (serwer dziala w tle)
5. Edytuj kod w edytorze
6. `Cmd+Shift+D` -- LazyGit: sprawdz diff, zrob commit, zamknij
7. `Cmd+Shift+T` -- Btop: sprawdz czy serwer nie zjada pamieci
8. `Ctrl+\` -- pokaz terminal: sprawdz logi serwera
9. `<Esc><Esc>` -- Normal mode: skopiuj blad z logow
10. `Ctrl+k` -- wroc do edytora, napraw blad
11. `Cmd+Shift+D` -- LazyGit: kolejny commit
12. Cel: wszystko bez opuszczania terminala, bez przelaczania do przegladarki

---

## Podsumowanie

### Nauczone komendy

| Komenda | Opis |
|---------|------|
| `Ctrl+\` | Toggle terminal (Toggleterm) |
| `<Esc><Esc>` | Wyjdz z Terminal mode (w terminalu) |
| `prefix + \|` / `prefix + -` | Split tmux (pion/poziom) |
| `prefix + z` | Zoom toggle (fullscreen pane) |
| `prefix + [` | Copy mode (vi-style) |
| `prefix + $` | Zmien nazwe sesji |
| `prefix + d` | Detach od sesji |
| `Cmd+Shift+D` | LazyGit popup |
| `Cmd+Shift+Y` | Yazi popup |
| `Cmd+Shift+N` | Notes editor popup |
| `Cmd+Shift+S` | Scratchpad popup |
| `Cmd+Shift+H` | Cheat sheet popup |
| `Cmd+Shift+T` | Btop popup |
| `Cmd+Shift+?` | Shortcuts help popup |

### Konfiguracja uzyta w tej lekcji

| Element | Wartosc / Opis |
|---------|---------------|
| Toggleterm | Horizontal, size=15, shading=2, `<Esc><Esc>` to exit |
| Tmux prefix | `Ctrl+Space` |
| Tmux popups | Kitty Cmd+Shift -> escape sequences -> tmux User keys |
| Tmux-resurrect | Auto-save sesji co 15 min, auto-restore po restarcie |
| Pane background | Aktywny: #1e1e2e, nieaktywny: #1a1a1a |

### Co dalej?

W **lekcji 33** poznasz **PPM (popup menu), Command Palette, Smart Open** i kolekcje
zaawansowanych trikow Vima -- od inkrement/dekrement przez undo time travel po
zaawansowane uzycie rejestrow i markow.
