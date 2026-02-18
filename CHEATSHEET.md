# Sciaga — Kompletny przeglad keybindingow

Leader: `Space` | Tmux prefix: `Ctrl+Space`

---

## Podstawowe

| Skrot              | Opis                          | Kontekst        |
|--------------------|-------------------------------|-----------------|
| `<leader>w`        | Zapisz plik                   | Normal          |
| `<leader>q`        | Smart quit                    | Normal          |
| `<Esc>`            | Wyczysc szukanie              | Normal          |
| `<leader><space>`  | Wyczysc szukanie              | Normal          |
| `i`                | Insert przed kursorem         | Normal          |
| `a`                | Insert za kursorem            | Normal          |
| `I`                | Insert poczatek linii         | Normal          |
| `A`                | Insert koniec linii           | Normal          |
| `o`                | Nowa linia ponizej + insert   | Normal          |
| `O`                | Nowa linia powyzej + insert   | Normal          |
| `<Esc>`            | Powrot do Normal              | Insert/Visual   |
| `:`                | Command-line mode             | Normal          |
| `.`                | Powtorz ostatnia zmiane       | Normal          |

---

## Ruchy (motions)

| Skrot          | Opis                                    |
|----------------|-----------------------------------------|
| `h/j/k/l`     | Lewo / dol / gora / prawo              |
| `w`            | Poczatek nastepnego word                |
| `W`            | Poczatek nastepnego WORD                |
| `b`            | Poczatek poprzedniego word              |
| `B`            | Poczatek poprzedniego WORD              |
| `e`            | Koniec biezacego/nastepnego word        |
| `E`            | Koniec biezacego/nastepnego WORD        |
| `ge`           | Koniec poprzedniego word                |
| `0`            | Poczatek linii                          |
| `$`            | Koniec linii                            |
| `^`            | Pierwszy non-blank znak                 |
| `gg`           | Poczatek pliku                          |
| `G`            | Koniec pliku                            |
| `{count}G`     | Idz do linii {count}                    |
| `{`            | Poprzedni pusty wiersz (paragraph)      |
| `}`            | Nastepny pusty wiersz (paragraph)       |
| `%`            | Matching bracket                        |
| `f{char}`      | Znajdz {char} w prawo (wlacznie)       |
| `F{char}`      | Znajdz {char} w lewo (wlacznie)        |
| `t{char}`      | Do {char} w prawo (przed nim)           |
| `T{char}`      | Do {char} w lewo (przed nim)            |
| `;`            | Powtorz f/F/t/T w przod                |
| `,`            | Powtorz f/F/t/T w tyl                  |
| `Ctrl+d`       | Pol strony w dol                        |
| `Ctrl+u`       | Pol strony w gore                       |
| `Ctrl+f`       | Cala strona w dol                       |
| `Ctrl+b`       | Cala strona w gore                      |
| `H`            | Gora widocznego ekranu                  |
| `M`            | Srodek widocznego ekranu                |
| `L`            | Dol widocznego ekranu                   |
| `zz`           | Centruj kursor na ekranie               |
| `zt`           | Kursor na gorze ekranu                  |
| `zb`           | Kursor na dole ekranu                   |

---

## Operatory

Operatory lacza sie z motions i text objects: `{operator}{motion}` lub `{operator}{text-object}`.

| Skrot  | Opis                              |
|--------|-----------------------------------|
| `d`    | Delete (usun)                     |
| `c`    | Change (usun + insert)            |
| `y`    | Yank (kopiuj)                     |
| `>`    | Indent w prawo                    |
| `<`    | Indent w lewo                     |
| `gU`   | Uppercase                         |
| `gu`   | Lowercase                         |
| `g~`   | Toggle case                       |
| `=`    | Auto-indent                       |
| `!`    | Filter przez zewnetrzny program   |

**Podwojenie = cala linia:** `dd`, `cc`, `yy`, `>>`, `<<`

**Przyklady kombinacji:**

| Kombinacja | Opis                                        |
|------------|---------------------------------------------|
| `dw`       | Usun do nastepnego word                     |
| `d$` / `D` | Usun do konca linii                        |
| `d0`       | Usun do poczatku linii                      |
| `dgg`      | Usun do poczatku pliku                      |
| `dG`       | Usun do konca pliku                         |
| `ci"`      | Zmien tekst wewnatrz cudzyslowow           |
| `ya(`      | Kopiuj tekst z nawiasami wlacznie           |
| `>i{`      | Indent blok wewnatrz klamr                  |
| `gUiw`     | Uppercase biezacego word                    |

---

## Text Objects

Format: `{i|a}{object}` — `i` = inside (bez ogranicznikow), `a` = around (z ogranicznikami).

### Wbudowane text objects

| Object   | Opis                        |
|----------|-----------------------------|
| `iw/aw`  | Word                        |
| `iW/aW`  | WORD                        |
| `is/as`  | Sentence                    |
| `ip/ap`  | Paragraph                   |
| `i"/a"`  | Tekst w `"`                 |
| `i'/a'`  | Tekst w `'`                 |
| `` i`/a` `` | Tekst w `` ` ``          |
| `i(/a(`  | Tekst w `()`               |
| `i)/a)`  | Tekst w `()` (alias)       |
| `ib/ab`  | Tekst w `()` (alias)       |
| `i{/a{`  | Tekst w `{}`               |
| `iB/aB`  | Tekst w `{}` (alias)       |
| `i[/a[`  | Tekst w `[]`               |
| `i</a<`  | Tekst w `<>`               |
| `it/at`  | Tekst w HTML/XML tag        |

### mini.ai (dodatkowe text objects)

| Object   | Opis                        |
|----------|-----------------------------|
| `if/af`  | Function                    |
| `ic/ac`  | Class                       |
| `iq/aq`  | Quote (dowolny typ)         |
| `ia/aa`  | Argument                    |
| `in/an`  | Number                      |

---

## Visual Mode

| Skrot              | Opis                                          |
|--------------------|-----------------------------------------------|
| `v`                | Visual characterwise                          |
| `V`                | Visual linewise                               |
| `Ctrl+v`           | Visual blockwise                              |
| `gv`               | Przywroc ostatnia selekcje                    |
| `o`                | Przeskocz na drugi koniec selekcji            |
| `</>`              | Indent z automatycznym zachowaniem selekcji   |
| `Alt+j`            | Przesun zaznaczone linie w dol                |
| `Alt+k`            | Przesun zaznaczone linie w gore               |
| `S{char}`          | Surround selekcje (nvim-surround)             |
| `gc`               | Toggle komentarz (comment.nvim)               |
| `J`                | Polacz zaznaczone linie                       |
| `u` / `U`          | Lowercase / Uppercase selekcji                |

---

## Szukanie

| Skrot              | Opis                                   | Kontekst |
|--------------------|----------------------------------------|----------|
| `/{pattern}`       | Szukaj w przod                         | Normal   |
| `?{pattern}`       | Szukaj w tyl                           | Normal   |
| `n`                | Nastepne trafienie                     | Normal   |
| `N`                | Poprzednie trafienie                   | Normal   |
| `*`                | Szukaj word pod kursorem (w przod)     | Normal   |
| `#`                | Szukaj word pod kursorem (w tyl)       | Normal   |
| `<Esc>`            | Wyczysc podswietlenie szukania         | Normal   |
| `<leader><space>`  | Wyczysc podswietlenie szukania         | Normal   |
| `<leader>/`        | Fuzzy search w biezacym buforze        | Normal   |
| `<leader>sw`       | Szukaj word pod kursorem (Telescope)   | Normal   |
| `<leader>fg`       | Live grep (Telescope)                  | Normal   |

**Ustawienie:** `inccommand=split` — podglad substitution na zywo w split.

---

## Rejestry

| Rejestr       | Opis                                          |
|---------------|-----------------------------------------------|
| `""`          | Domyslny (ostatni d/c/y/s)                   |
| `"+`          | Systemowy clipboard (= `unnamedplus`)         |
| `"0`          | Ostatni yank (nie delete)                     |
| `"a`-`"z`    | Nazwane rejestry                              |
| `"A`-`"Z`    | Dopisz do nazwanego rejestru                  |
| `"_`          | Black hole (usun bez zapisu)                  |
| `"/`          | Ostatnie wyszukiwanie                         |
| `":`          | Ostatnia komenda                              |
| `".`          | Ostatni wstawiony tekst                       |
| `"%`          | Nazwa biezacego pliku                         |

| Skrot              | Opis                                   |
|--------------------|----------------------------------------|
| `"{reg}y{motion}`  | Kopiuj do rejestru {reg}               |
| `"{reg}p`          | Wklej z rejestru {reg}                 |
| `"{reg}d{motion}`  | Usun do rejestru {reg}                 |
| `:registers`       | Pokaz zawartosc rejestrow              |
| `Ctrl+r {reg}`     | Wstaw z rejestru w Insert mode         |

---

## Undo / Redo

| Skrot       | Opis                                         |
|-------------|----------------------------------------------|
| `u`         | Undo                                         |
| `Ctrl+r`    | Redo                                         |
| `U`         | Undo wszystkich zmian w biezacej linii       |

**Ustawienie:** `undofile=true` — historia undo przetrwa zamkniecie pliku.

---

## nvim-surround

| Skrot                  | Opis                                        | Kontekst          |
|------------------------|---------------------------------------------|--------------------|
| `ys{motion}{char}`     | Dodaj surround                              | Normal             |
| `yss{char}`            | Surround cala linie                         | Normal             |
| `cs{old}{new}`         | Zmien surround                              | Normal             |
| `ds{char}`             | Usun surround                               | Normal             |
| `S{char}`              | Surround selekcje                           | Visual             |

**Przyklady:**

| Komenda       | Przed            | Po                  |
|---------------|------------------|---------------------|
| `ysiw"`       | `hello`          | `"hello"`           |
| `ysiw)`       | `hello`          | `(hello)`           |
| `ysiw(`       | `hello`          | `( hello )`         |
| `cs"'`        | `"hello"`        | `'hello'`           |
| `cs"<div>`    | `"hello"`        | `<div>hello</div>`  |
| `ds"`         | `"hello"`        | `hello`             |
| `yss)`        | `hello world`    | `(hello world)`     |

**Uwaga:** Otwierajacy nawias `(` dodaje spacje, zamykajacy `)` nie dodaje.

---

## Komentarze (comment.nvim)

| Skrot              | Opis                              | Kontekst |
|--------------------|-----------------------------------|----------|
| `gcc`              | Toggle komentarz linii            | Normal   |
| `gc{motion}`       | Toggle komentarz (motion)         | Normal   |
| `gc`               | Toggle komentarz selekcji         | Visual   |
| `gcip`             | Toggle komentarz paragrafu        | Normal   |

**Indent:** `guess-indent` automatycznie wykrywa styl wciec pliku.

| Skrot      | Opis                                           | Kontekst |
|------------|-------------------------------------------------|----------|
| `>>`       | Indent linie w prawo                            | Normal   |
| `<<`       | Indent linie w lewo                             | Normal   |
| `>`        | Indent selekcje (zachowuje selekcje)            | Visual   |
| `<`        | Outdent selekcje (zachowuje selekcje)           | Visual   |
| `={motion}`| Auto-indent                                     | Normal   |
| `==`       | Auto-indent biezaca linie                       | Normal   |

---

## Flash.nvim

| Skrot              | Opis                                    | Kontekst          |
|--------------------|-----------------------------------------|--------------------|
| `s`                | Flash jump — skocz do znaku             | Normal/Visual      |
| `S`                | Flash treesitter — zaznacz wezly        | Normal/Visual      |
| `r`                | Flash remote — operacja na zdalnym celu | Operator-pending   |

**Workflow Flash jump:** wcisnij `s`, wpisz 1-2 znaki, wcisnij wyswietlona etykiete.
**Workflow Flash treesitter:** `S` podswietli wezly drzewa skladni — wcisnij etykiete aby zaznaczyc.

---

## Telescope

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `Ctrl+P`           | Smart open (Snacks.picker.smart)        |
| `Ctrl+Q`           | Command palette (Telescope commands)    |
| `<leader>ff`       | Szukaj plikow                           |
| `<leader>fg`       | Live grep (szukaj w tresci)             |
| `<leader>fb`       | Lista buforow                           |
| `<leader>fh`       | Pomoc (help tags)                       |
| `<leader>fr`       | Ostatnio otwierane pliki                |
| `<leader>fk`       | Keymaps                                 |
| `<leader>fs`       | Symbole (Aerial)                        |
| `<leader>sr`       | Resume — wznow ostatnie wyszukiwanie    |
| `<leader>sw`       | Szukaj word pod kursorem                |
| `<leader>sd`       | Diagnostyka                             |
| `<leader>/`        | Fuzzy search w biezacym buforze         |

---

## Neo-tree

| Skrot              | Opis                                    | Kontekst          |
|--------------------|-----------------------------------------|--------------------|
| `<leader>e`        | Toggle Neo-tree                         | Normal             |

**Operacje wewnatrz Neo-tree:**

| Skrot  | Opis                              |
|--------|-----------------------------------|
| `a`    | Dodaj plik                        |
| `A`    | Dodaj katalog                     |
| `d`    | Usun                              |
| `r`    | Zmien nazwe                       |
| `c`    | Kopiuj                            |
| `m`    | Przenies                          |
| `p`    | Wklej                             |
| `R`    | Odswiez                           |
| `H`    | Toggle ukryte pliki               |
| `?`    | Pomoc (lista skrotow)             |
| `Enter`| Otworz plik                       |
| `s`    | Otworz w split poziomym           |
| `S`    | Otworz w split pionowym           |

---

## Yazi

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>E`        | Otworz Yazi (file manager)              |
| `<leader>ew`       | Otworz Yazi w cwd                       |

---

## Buffers

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `Ctrl+T`           | Nastepny bufor (`Ctrl+Tab` w Kitty)     |
| `Ctrl+Y`           | Poprzedni bufor (`Ctrl+Shift+Tab`)      |
| `Shift+H`          | Poprzedni bufor                         |
| `Shift+L`          | Nastepny bufor                          |
| `<leader>bd`       | Usun bufor                              |
| `<leader>fb`       | Lista buforow (Telescope)               |

---

## Windows & Splits

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `Ctrl+h`           | Okno w lewo                             |
| `Ctrl+j`           | Okno w dol                              |
| `Ctrl+k`           | Okno w gore                             |
| `Ctrl+l`           | Okno w prawo                            |
| `:split` / `:sp`   | Horizontal split                        |
| `:vsplit` / `:vs`  | Vertical split                          |
| `Ctrl+w =`         | Wyrownaj rozmiary okien                 |
| `Ctrl+w _`         | Maksymalizuj wysokosc                   |
| `Ctrl+w \|`        | Maksymalizuj szerokosc                  |
| `Ctrl+w r`         | Rotuj okna                              |
| `Ctrl+w o`         | Zamknij inne okna (:only)               |
| `Ctrl+w q`         | Zamknij okno                            |

---

## LSP

### Nawigacja

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `gd`               | Go to definition                        |
| `grd`              | Go to definition (LSP)                  |
| `gr`               | Go to references                        |
| `grr`              | Go to references (LSP)                  |
| `gri`              | Go to implementation                    |
| `grt`              | Go to type definition                   |
| `grD`              | Go to declaration                       |
| `gp`               | Peek definition (podglad)               |
| `K`                | Hover — dokumentacja pod kursorem       |
| `gK`               | Signature help                          |

### Diagnostyka

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>ld`       | Diagnostyka biezacej linii              |
| `[d`               | Poprzednia diagnostyka                  |
| `]d`               | Nastepna diagnostyka                    |
| `<leader>sd`       | Diagnostyka (Telescope)                 |

### Akcje

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>ca`       | Code action                             |
| `gra`              | Code action (LSP)                       |
| `<leader>rn`       | Rename                                  |
| `grn`              | Rename (LSP)                            |
| `<leader>cf`       | Format                                  |
| `<leader>th`       | Toggle inlay hints                      |

---

## Git

### Gitsigns

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>gb`       | Git blame (biezaca linia)               |
| `<leader>gp`       | Preview hunk                            |

### Diffview

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>gd`       | Otworz diffview                         |
| `<leader>gD`       | Toggle diff file (winbar: HEAD/Current) |
| `<leader>gc`       | Zamknij diffview                        |

### LazyGit & Git Graph

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>gg`       | Otworz LazyGit                          |
| `<leader>gf`       | LazyGit — biezacy plik                  |
| `<leader>gl`       | Git graph                               |

### Git status i historia

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>gs`       | Git status panel                        |
| `<leader>gh`       | Historia pliku (file history)           |

---

## Trouble

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>xx`       | Diagnostyka (caly projekt)              |
| `<leader>xX`       | Diagnostyka (biezacy bufor)             |
| `<leader>xs`       | Symbole                                 |
| `<leader>xl`       | LSP (definicje/referencje)              |
| `<leader>xq`       | Quickfix list                           |

---

## Spectre

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>S`        | Toggle Spectre (find & replace)         |
| `<leader>sw`       | Szukaj word pod kursorem                |
| `<leader>sp`       | Szukaj w biezacym pliku                 |

---

## Folding

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `zo`               | Otworz fold                             |
| `zc`               | Zamknij fold                            |
| `za`               | Toggle fold                             |
| `zR`               | Otworz wszystkie foldy                  |
| `zM`               | Zamknij wszystkie foldy                 |
| `<leader>cc`       | Fold komentarze                         |
| `<leader>cC`       | Unfold (przywroc)                       |
| `<leader>cR`       | Unfold all                              |

**Metoda:** `foldmethod=expr` (treesitter) lub `indent` (Vue).

---

## Aerial & Namu

### Aerial

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>o`        | Toggle outline (Aerial)                 |
| `<leader>O`        | Aerial nawigacja                        |
| `<leader>or`       | Refresh Aerial                          |
| `{`                | Poprzedni symbol                        |
| `}`                | Nastepny symbol                         |

### Namu

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>ss`       | Symbole (Namu)                          |
| `<leader>sw`       | Workspace symbols                       |
| `<leader>st`       | Treesitter nodes                        |

---

## Dropbar

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>dp`       | Dropbar pick (breadcrumb nawigacja)     |

---

## Todo-comments

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>ft`       | Znajdz TODO (Telescope)                |
| `]t`               | Nastepne TODO                           |
| `[t`               | Poprzednie TODO                         |

---

## Terminal (toggleterm)

| Skrot              | Opis                                    | Kontekst          |
|--------------------|-----------------------------------------|--------------------|
| `Ctrl+\`           | Toggle terminal                         | Normal/Terminal    |
| `<Esc><Esc>`       | Wyjdz z terminal mode                  | Terminal           |

---

## Tmux

Prefix: `Ctrl+Space`

### Nawigacja paneli

| Skrot                     | Opis                                |
|---------------------------|-------------------------------------|
| `prefix + h/j/k/l`       | Nawigacja miedzy panelami           |
| `Alt + arrows`            | Nawigacja miedzy panelami           |

### Nawigacja okien

| Skrot                     | Opis                                |
|---------------------------|-------------------------------------|
| `Alt+Shift+arrows`        | Przelaczanie okien                  |
| `Alt+1` - `Alt+9`         | Bezposredni skok do okna            |
| `Alt+n`                   | Nastepne okno                       |
| `Alt+p`                   | Poprzednie okno                     |

### Zarzadzanie

| Skrot                     | Opis                                |
|---------------------------|-------------------------------------|
| `prefix + \|`             | Split pionowy                       |
| `prefix + -`              | Split poziomy                       |
| `prefix + c`              | Nowe okno                           |
| `prefix + H/J/K/L`        | Resize panelu                       |

### Copy mode

| Skrot                     | Opis                                |
|---------------------------|-------------------------------------|
| `prefix + [`              | Wejdz w copy mode                   |
| `v`                       | Zacznij selekcje (w copy mode)      |
| `y`                       | Kopiuj selekcje (w copy mode)       |

---

## Tmux Popups (Cmd+Shift+...)

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `Cmd+Shift+D`      | LazyGit (popup)                        |
| `Cmd+Shift+Y`      | Yazi (popup)                           |
| `Cmd+Shift+N`      | Notes                                  |
| `Cmd+Shift+H`      | Cheatsheet                             |
| `Cmd+Shift+G`      | Git quick                              |
| `Cmd+Shift+K`      | LazyDocker                             |
| `Cmd+Shift+B`      | LazySql                                |
| `Cmd+Shift+T`      | btop                                   |
| `Cmd+Shift+?`      | Shortcuts                              |
| `Cmd+Shift+I`      | pet snippets                           |
| `Cmd+Shift+E`      | aerc (email)                           |
| `Cmd+Shift+S`      | Scratchpad                             |
| `Cmd+Shift+J`      | Journal                                |

---

## IDE Mode & Panele

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>i`        | IDE mode (Neo-tree + Aerial)            |

---

## Przesuwanie linii

| Skrot              | Opis                                    | Kontekst          |
|--------------------|-----------------------------------------|--------------------|
| `Alt+j`            | Przesun linie / selekcje w dol          | Normal/Visual      |
| `Alt+k`            | Przesun linie / selekcje w gore         | Normal/Visual      |

---

## Config

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>ve`       | Edytuj konfiguracje Neovim              |
| `<leader>vr`       | Przeladuj konfiguracje Neovim           |

---

## Markdown

| Skrot              | Opis                                    |
|--------------------|-----------------------------------------|
| `<leader>mp`       | Markdown preview                        |
| `<leader>mr`       | Render markdown toggle                  |

---

## Ustawienia

| Opcja                  | Wartosc                                 |
|------------------------|-----------------------------------------|
| `scrolloff`            | `8`                                     |
| `clipboard`            | `unnamedplus` (systemowy)               |
| `inccommand`           | `split` (podglad substitution)          |
| `foldmethod`           | `expr` (treesitter) / `indent` (Vue)    |
| `undofile`             | `true` (persistentne undo)              |
| `number`               | `true`                                  |
| `relativenumber`       | `false`                                 |
| `wrap`                 | `true`                                  |
| `linebreak`            | `true`                                  |
