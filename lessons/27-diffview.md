# Lekcja 27: Diffview -- przegladanie zmian

> Czas: ~35-45 min | Poziom: Intermediate

---

## Cel lekcji

Nauczysz sie:

- Otwierac Diffview do przegladania wszystkich zmian w repozytorium
- Nawigowac po panelu plikow i diff view
- Stage/unstage plikow bezposrednio z Diffview
- Przegladac historie commitow dla pojedynczego pliku
- Efektywnie review'owac zmiany przed commitem

---

## Teoria

### Gitsigns vs Diffview

W lekcji 26 poznales gitsigns, ktory dziala na poziomie **pojedynczego pliku**.
Diffview to nastepny poziom -- pokazuje zmiany w **calym repozytorium** naraz,
z podzialem na pliki, w przejrzystym interfejsie side-by-side.

| Cecha | Gitsigns | Diffview |
|-------|----------|----------|
| Zakres | Pojedynczy plik | Cale repozytorium |
| Widok | Znaki w gutter + floating | Pelnoekranowy split |
| Staging | Nie | Tak (s/S/U) |
| Historia | Nie | Tak (file history) |
| Kiedy uzywac | Szybki podglad zmian | Review przed commitem |

### DiffviewOpen -- pelny przeglad zmian

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gd` | Otworz Diffview -- wszystkie zmiany (staged + unstaged) |

Diffview otwiera pelnoekranowy widok z dwoma glownymi obszarami:

```
+------------------------------------------+-------------------------------------------+
│  File panel (width=40)                   │  Diff view (side-by-side)                 │
│                                          │                                           │
│  Changes (3)                             │  LEFT: wersja HEAD      RIGHT: working    │
│  ├── src/                                │                                           │
│  │   ├── api.py                          │  - timeout = 60         + timeout = 30    │
│  │   └── models.py                       │                         + retries = 3     │
│  └── tests/                              │    return run(data)       return run(data) │
│      └── test_api.py                     │                                           │
│                                          │                                           │
│  Staged Changes (1)                      │                                           │
│  └── config.yaml                         │                                           │
│                                          │                                           │
+------------------------------------------+-------------------------------------------+
```

> **Twoja konfiguracja**: Panel plikow ma szerokosc 40 znakow, wyswietla drzewo katalogow
> (tree listing style) z `flatten_dirs` -- katalogi z jednym podkatalogiem sa zwijane
> w jedna linie (np. `src/api/` zamiast `src/` → `api/`). Diff uzywa `enhanced_diff_hl`
> dla lepszego podswietlania zmian na poziomie slow (nie tylko calych linii).

### Layout Diffview

Diffview uzywa **side-by-side layout**:

- **Lewa strona**: wersja z HEAD (ostatni commit)
- **Prawa strona**: wersja robocza (working tree)

Kolory podswietlania:

| Kolor | Element | Znaczenie |
|-------|---------|-----------|
| Ciemne zielone tlo | `DiffAdd` | Dodane linie |
| Ciemne czerwone tlo | `DiffDelete` | Usuniete linie |
| Ciemne niebieskie tlo | `DiffChange` | Zmienione linie (cala linia) |
| Jasniejsze niebieskie tlo | `DiffText` | Konkretny fragment zmiany w linii |

Filler lines (puste linie do wyrownania) sa wyswietlane jako **puste przestrzenie**
(nie dashes), co daje czysty, czytelny widok.

### Keybindings w panelu plikow

Panel plikow (lewa strona) to Twoje centrum dowodzenia:

| Klawisz | Dzialanie |
|---------|-----------|
| `j` / `k` | Nawigacja miedzy plikami |
| `<CR>` (Enter) | Otworz diff dla wybranego pliku |
| `s` | **Stage/unstage** plik (toggle) |
| `S` | **Stage all** -- dodaj wszystkie pliki do staging area |
| `U` | **Unstage all** -- usun wszystkie pliki ze staging area |
| `X` | **Restore** -- odrzuc zmiany w pliku (niebezpieczne!) |
| `L` | Otworz **commit log** |
| `zo` | Rozwin fold |
| `zc` | Zwin fold |
| `za` | Toggle fold |
| `zR` | Rozwin wszystkie foldy |
| `zM` | Zwin wszystkie foldy |
| `q` | Zamknij Diffview |

> **Uwaga**: `X` (restore) **nieodwracalnie** odrzuca zmiany w pliku! Jest to odpowiednik
> `git checkout -- plik`. Uzywaj ostroznie.

### Keybindings w diff view

Diff view (prawa strona) pozwala przegladac zmiany:

| Klawisz | Dzialanie |
|---------|-----------|
| `<Tab>` | Nastepny plik (next entry) |
| `<S-Tab>` | Poprzedni plik (prev entry) |
| `gf` | Otworz aktualny plik (opusc diff, otworz bufor) |
| `<leader>e` | Toggle panel plikow (schowaj/pokaz) |

`<Tab>` i `<S-Tab>` pozwalaja szybko przeskakiwac miedzy plikami bez wracania
do panelu -- to najszybszy sposob na review wielu plikow po kolei.

### Zamykanie Diffview

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gc` | Zamknij Diffview (z dowolnego miejsca) |
| `q` | Zamknij Diffview (w panelu plikow) |

Oba sposoby przywracaja normalny widok edytora. `<leader>gc` dziala globalnie --
mozesz go uzyc nawet gdy jestes w diff view, nie w panelu plikow.

### File History -- historia pliku

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gh` | Historia commitow dla biezacego pliku |

`DiffviewFileHistory %` otwiera liste **wszystkich commitow**, ktore zmienily biezacy plik.
Dla kazdego commita widzisz:

- Hash commita (skrocony)
- Autora
- Date
- Commit message
- Diff -- co dokladnie sie zmienilo w tym uzyciu

```
+------------------------------------------+-------------------------------------------+
│  Commit list                             │  Diff for selected commit                 │
│                                          │                                           │
│  a1b2c3d  Add validation      2d ago     │  - return data                            │
│  e4f5g6h  Fix timeout         5d ago     │  + if not data:                           │
│  i7j8k9l  Initial impl        1w ago     │  +     raise ValueError("empty")          │
│                                          │  + return data                            │
│                                          │                                           │
+------------------------------------------+-------------------------------------------+
```

To doskonale narzedzie do zrozumienia **ewolucji pliku** -- kto, kiedy i dlaczego
wprowadzil kazda zmiane.

### Diffview vs git diff w terminalu

| Cecha | `git diff` (terminal) | Diffview |
|-------|----------------------|----------|
| Format | Unified diff (inline) | Side-by-side |
| Nawigacja | Scroll (less/delta) | Vim motions + Tab |
| Staging | Osobna komenda | `s` w panelu |
| Podswietlanie | delta (jesli skonfigurowane) | Enhanced diff highlight |
| Historia pliku | `git log -p -- plik` | `<leader>gh` z nawigacja |

Diffview nie zastepuje terminala, ale znacznie upraszcza review zmian przed commitem.

---

## Cwiczenia

### Przygotowanie

Upewnij sie, ze repozytorium cwiczeniowe jest przygotowane:

```bash
cd ~/GIT/vim-tutor/exercises/git-exercise
bash setup-git-exercise.sh
cd repo
nvim .
```

Dokonaj kilku zmian w roznych plikach (zmien wartosci, dodaj linie, usun cos),
zeby miec material do review.

### Cwiczenie 1: Otwieranie Diffview

1. Upewnij sie, ze masz niezapisane zmiany w kilku plikach (jesli nie, dokonaj ich)
2. Nacisnij `<leader>gd` -- Diffview sie otworzy
3. Zaobserwuj layout: panel plikow po lewej, diff po prawej
4. Przejrzyj panel plikow -- pliki sa pogrupowane (Changes / Staged Changes)
5. Zamknij Diffview: `<leader>gc`

### Cwiczenie 2: Nawigacja po plikach

1. Otworz Diffview (`<leader>gd`)
2. W panelu plikow uzyj `j`/`k` do nawigacji
3. Nacisnij `Enter` na wybranym pliku -- po prawej pojawi sie jego diff
4. Wroc do panelu (`<leader>e` lub przejdz do lewego okna)
5. Wybierz inny plik -- diff sie zmieni
6. Zamknij: `<leader>gc`

### Cwiczenie 3: Nawigacja Tab w diff view

1. Otworz Diffview (`<leader>gd`)
2. Wybierz pierwszy plik (Enter)
3. W diff view nacisnij `<Tab>` -- przeskoczy na nastepny plik
4. Nacisnij `<Tab>` jeszcze raz -- kolejny plik
5. `<S-Tab>` -- wroc do poprzedniego pliku
6. To najszybszy sposob na przegladanie wszystkich zmian po kolei

### Cwiczenie 4: Staging i unstaging

1. Otworz Diffview (`<leader>gd`)
2. W panelu plikow ustaw kursor na pliku w sekcji "Changes"
3. Nacisnij `s` -- plik przejdzie do sekcji "Staged Changes"
4. Nacisnij `s` ponownie -- plik wroci do "Changes" (unstage)
5. Nacisnij `S` -- wszystkie pliki zostana staged
6. Nacisnij `U` -- wszystkie pliki zostana unstaged
7. Stage 1-2 pliki selektywnie (`s` na wybranych)

### Cwiczenie 5: Restore (odrzucanie zmian)

1. Dokonaj zmiany w pliku, ktora chcesz odrzucic (np. dodaj przypadkowy tekst)
2. Otworz Diffview (`<leader>gd`)
3. W panelu plikow znajdz ten plik
4. Nacisnij `X` -- zmiana zostanie odrzucona (plik wroci do wersji HEAD)
5. **Uwaga**: ta operacja jest nieodwracalna! Uzywaj ostroznie

### Cwiczenie 6: Commit log

1. Otworz Diffview (`<leader>gd`)
2. W panelu plikow nacisnij `L`
3. Przejrzyj liste commitow -- zobaczysz historie repozytorium
4. Wybierz commit, zeby zobaczyc jego diff
5. Zamknij log

### Cwiczenie 7: File history

1. Otworz plik, ktory ma kilka commitow w historii
2. Nacisnij `<leader>gh` -- otworzy sie DiffviewFileHistory
3. Przejrzyj liste commitow dla tego pliku
4. Uzyj `j`/`k` do nawigacji miedzy commitami
5. Nacisnij Enter na commicie -- po prawej zobaczysz diff z tego commita
6. Przewin diff, zeby zobaczyc pelny zakres zmian
7. Przejdz do starszego commita -- porownaj jak plik ewoluowal
8. Zamknij: `<leader>gc`

### Cwiczenie 8: Toggle file panel

1. Otworz Diffview (`<leader>gd`)
2. Przejdz do diff view (Enter na pliku)
3. Nacisnij `<leader>e` -- panel plikow zniknie, diff zajmie pelna szerokosc
4. Nacisnij `<leader>e` ponownie -- panel wrocil
5. Przydatne gdy chcesz widziec wiecej kodu w diff

### Cwiczenie 9: Otwarcie pliku z Diffview

1. Otworz Diffview (`<leader>gd`)
2. Przejdz do diff view dla wybranego pliku
3. Nacisnij `gf` -- Diffview sie zamknie i otworzy sie normalny bufor tego pliku
4. Mozesz teraz edytowac plik normalnie
5. Wroc do Diffview (`<leader>gd`) zeby kontynuowac review

---

## Cwiczenie bonusowe

**Scenariusz: pelny review przed commitem**

1. Dokonaj zmian w 3-4 roznych plikach repozytorium (dodaj funkcje, zmien wartosci,
   napraw komentarze)
2. Otworz Diffview (`<leader>gd`)
3. Przejrzyj KAZDY plik uzywajac `<Tab>` -- upewnij sie, ze kazda zmiana jest celowa
4. Stage pliki, ktore sa gotowe do commita (`s` na wybranych plikach)
5. Przejrzyj historie jednego z plikow (`gf` zeby otworzyc, potem `<leader>gh`)
6. Wroc do Diffview (`<leader>gd`)
7. Upewnij sie, ze sekcja "Staged Changes" zawiera dokladnie to co chcesz commitnac
8. Zamknij Diffview (`<leader>gc`)

**Wyzwanie**: Znajdz w file history commit, w ktorym konkretna linia zostala dodana,
uzywajac tylko `<leader>gh` i nawigacji `j`/`k`.

---

## Podsumowanie

### Nauczone komendy

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gd` | DiffviewOpen -- przegladanie wszystkich zmian |
| `<leader>gc` | DiffviewClose -- zamknij Diffview |
| `<leader>gh` | DiffviewFileHistory % -- historia biezacego pliku |
| `s` | Stage/unstage plik (w panelu plikow) |
| `S` | Stage all |
| `U` | Unstage all |
| `X` | Restore -- odrzuc zmiany (nieodwracalne!) |
| `L` | Commit log |
| `<Tab>` / `<S-Tab>` | Nastepny/poprzedni plik w diff view |
| `gf` | Otworz plik (opusc Diffview) |
| `<leader>e` | Toggle panel plikow |
| `zo`/`zc`/`za`/`zR`/`zM` | Fold controls w panelu |
| `q` | Zamknij Diffview (w panelu) |

### Kolory diff

| Kolor tla | Element | Znaczenie |
|-----------|---------|-----------|
| Ciemny zielony | `DiffAdd` | Dodane linie |
| Ciemny czerwony | `DiffDelete` | Usuniete linie |
| Ciemny niebieski | `DiffChange` | Zmienione linie |
| Jasniejszy niebieski | `DiffText` | Zmieniony fragment w linii |

### Konfiguracja uzyta w tej lekcji

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| `enhanced_diff_hl` | `true` | Podswietlanie zmian na poziomie slow |
| File panel width | `40` | Szerokosc panelu plikow |
| Listing style | `tree` + `flatten_dirs` | Drzewo katalogow ze zwijaniem |
| Layout | Side-by-side | Dwie kolumny: HEAD vs working |

### Co dalej?

W **lekcji 28** poznasz **LazyGit** -- pelny klient TUI do operacji git
(commit, push, rebase, cherry-pick) oraz **Git Graph** do wizualizacji
historii branchow w formie ASCII art.
