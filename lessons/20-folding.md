# Lekcja 20: Folding — zwijanie blokow kodu

> Czas: ~30-45 min | Poziom: Intermediate

---

## Cel lekcji

Nauczysz sie:

- Zwijac i rozwijac bloki kodu (funkcje, klasy, komentarze)
- Uzywac foldow opartych na treesitter i indent
- Zwijac komentarze i docstringi, zeby skupic sie na kodzie
- Pracowac z dlugimi plikami dzieki foldingowi
- Rozumiec roznice miedzy foldmethod=expr a foldmethod=indent

---

## Teoria

### Czym jest folding

Folding to **zwijanie fragmentow kodu** — ukrywasz blok (np. funkcje,
klase, komentarz) za jedną linią podsumowania. Kod nadal istnieje,
po prostu go nie widzisz, dopoki nie rozwiniesz folda.

```
Przed zwijaniem:                   Po zwiniecia funkcji:

def calculate_total(items):        +-- def calculate_total(items): ··· (8 lines)
    """
    Calculate the total price      def format_output(result):
    of all items in the cart.          return f"Total: {result}"

    Args:
        items: list of items
    Returns:
        float: total price
    """
    total = 0
    for item in items:
        total += item.price
    return total

def format_output(result):
    return f"Total: {result}"
```

Zwinieta linia pokazuje pierwszy wiersz folda + liczbe ukrytych linii.

### Metody foldingu

Vim wspiera kilka metod foldingu:

| Metoda       | Jak dziala                           | Kiedy uzywana               |
|-------------|--------------------------------------|-----------------------------|
| `expr`      | Wyrazenie Lua/Vimscript decyduje     | Domyslna (treesitter)       |
| `indent`    | Wcięcia definiuja bloki              | Vue SFC (fallback)          |
| `syntax`    | Parser skladni Vim                   | Legacy, rzadko              |
| `marker`    | Markery `{{{` / `}}}` w kodzie      | Konfiguracje Vim            |
| `manual`    | Recznie definiowane foldy            | Rzadko                      |
| `diff`      | Automatyczne przy diffie             | vimdiff                     |

### Twoja konfiguracja

> **Metoda:** `foldmethod=expr` z treesitter `foldexpr`
>
> Treesitter rozumie strukture kodu — wie, gdzie zaczyna sie funkcja,
> klasa, blok if/else, komentarz. Dzieki temu foldy sa **semantyczne**,
> nie oparte na wcienciach.
>
> **Wyjątek:** Pliki Vue (`.vue`) uzywaja `foldmethod=indent`, bo
> treesitter ma problemy z Vue SFC (Single File Components —
> `<template>` + `<script>` + `<style>` w jednym pliku).
>
> **Poczatkowy stan:**
> ```lua
> vim.opt.foldlevel = 99        -- nie zwijaj niczego automatycznie
> vim.opt.foldlevelstart = 99   -- nowe buffery tez otwarte
> ```
>
> Wszystko jest **rozwinięte** domyslnie. Sam decydujesz, co chcesz zwinac.

### Podstawowe komendy

| Skrot   | Dzialanie                                       |
|---------|--------------------------------------------------|
| `zo`    | **Open** — rozwin fold pod kursorem              |
| `zc`    | **Close** — zwin fold pod kursorem               |
| `za`    | **Toggle** — przelacz fold (otwórz/zamknij)      |
| `zR`    | **Open ALL** — rozwin WSZYSTKIE foldy w pliku    |
| `zM`    | **Close ALL** — zwin WSZYSTKIE foldy w pliku     |
| `zr`    | Reduce fold level — rozwin o jeden poziom        |
| `zm`    | More folding — zwin o jeden poziom               |
| `zO`    | Rozwin fold rekurencyjnie (wszystkie wewnetrzne) |
| `zC`    | Zwin fold rekurencyjnie                          |

**Mnemotechnika:**

- `z` — prefix foldingu (wyobraz sobie zwijanie kartki papieru — "Z-fold")
- `o` — open, `c` — close, `a` — alternate (toggle)
- Wielkie litery (`R`, `M`, `O`, `C`) — "wiecej" (rekurencyjnie lub globalnie)

### Fold levels — poziomy zagniezdzen

Kazdy fold ma **level** — im glebiej zagniezdzony, tym wyzszy level:

```python
# Level 0 — top-level (nigdy nie zwijany przy foldlevel=99)
class Calculator:           # Level 1
    """Docstring"""         # Level 2

    def add(self, a, b):   # Level 2
        """Add numbers."""  # Level 3
        return a + b        # Level 3

    def multiply(self):    # Level 2
        result = 0          # Level 3
        for i in range(n):  # Level 3
            result += i     # Level 4
        return result       # Level 3
```

- `zM` — ustawia foldlevel na 0 → zwin wszystko (widoczny tylko top-level)
- `zR` — ustawia foldlevel na max → rozwin wszystko
- `zm` — foldlevel -= 1 → zwin o jeden poziom wiecej
- `zr` — foldlevel += 1 → rozwin o jeden poziom

### Twoje custom komendy — fold komentarzy

> **Zwijanie komentarzy i docstringow:**
>
> | Skrot          | Dzialanie                                         |
> |----------------|---------------------------------------------------|
> | `<leader>cc`   | Zwin WSZYSTKIE komentarze i docstringi             |
> | `<leader>cC`   | Rozwin i przywroc treesitter folding               |
> | `<leader>cR`   | Rozwin wszystko (`zR`)                             |
>
> **`<leader>cc`** uzywa treesitter do znalezienia wezlow typu `comment`
> i `string` (multiline — Python docstringi), potem selektywnie je zwija.
>
> To niezwykle przydatne w plikach z dlugimi docstringami (np. API docs,
> numpy-style docstrings). Jednym skrotem ukrywasz caly "szum" i widzisz
> czysty kod.

### Wyglad zwinietch linii

> W Twojej konfiguracji highlight `Folded` wyglada tak:
>
> - Kolor tekstu: `#565f89` (stonowany niebieski — Catppuccin Mocha)
> - Styl: *italic*
> - Brak tla — zwiniete linie nie wyrozniaja sie agresywnie
>
> Zwinieta linia wyglada mniej wiecej tak:
> ```
> +-- def calculate_total(items): ··· (8 lines)
> ```
> Delikatna, nieinwazyjna — wiesz, ze cos jest zwiniete, ale nie przeszkadza.

### Praktyczne zastosowania foldingu

| Scenariusz                          | Akcja                                |
|-------------------------------------|--------------------------------------|
| Dlugi plik, szukasz funkcji        | `zM` (zwin wszystko) → nawiguj → `zo` |
| Za duzo docstringow                | `<leader>cc` (zwin komentarze)        |
| Code review — skupienie na zmianach | Zwin niezmienione sekcje             |
| Prezentacja kodu                   | Zwin implementacje, pokaz interfejsy  |
| Debugging                          | Zwin sprawdzone funkcje               |

### foldmethod=indent (Vue)

Dla plikow Vue, folding opiera sie na wcienciach:

```vue
<template>                          <!-- Level 0 -->
  <div class="container">           <!-- Level 1 -->
    <h1>{{ title }}</h1>            <!-- Level 2 -->
    <DataTable                      <!-- Level 2 -->
      :items="items"                <!-- Level 3 -->
      :columns="columns"           <!-- Level 3 -->
    />                              <!-- Level 2 -->
  </div>                            <!-- Level 1 -->
</template>                         <!-- Level 0 -->

<script setup lang="ts">           <!-- Level 0 -->
import { ref } from 'vue'          <!-- Level 1 -->

const title = ref('My App')        <!-- Level 1 -->
</script>                           <!-- Level 0 -->
```

Indent-based folding jest mniej precyzyjny niz treesitter, ale dziala
niezawodnie z Vue SFC, gdzie treesitter ma problemy z przelaczaniem
miedzy jezykami (HTML → JS → CSS).

### Nawigacja miedzy foldami

| Skrot   | Dzialanie                                       |
|---------|--------------------------------------------------|
| `zj`    | Przejdz do nastepnego folda                      |
| `zk`    | Przejdz do poprzedniego folda                    |
| `[z`    | Przejdz do poczatku biezacego folda              |
| `]z`    | Przejdz do konca biezacego folda                 |

---

## Cwiczenia

### Cwiczenie 1: Podstawowe zwijanie i rozwijanie

1. Otworz `exercises/python/data_processing.py`
2. Ustaw kursor na linii z `def` (definicja funkcji)
3. Nacisnij `zc` — funkcja zostanie zwinieta
4. Zauwaz zwinieta linie z liczba ukrytych linii
5. Nacisnij `zo` — funkcja rozwinięta z powrotem
6. Nacisnij `za` — toggle (zwin, jesli rozwinięta i odwrotnie)

### Cwiczenie 2: Zwin/rozwin wszystko

1. W `data_processing.py` nacisnij `zM` — WSZYSTKO sie zwinie
2. Zauwaz, ze widzisz teraz tylko top-level definicje (klasy, funkcje)
3. To swietny widok "z lotu ptaka" na strukture pliku
4. Nacisnij `zR` — wszystko z powrotem rozwinięte
5. Nacisnij `zM` ponownie, potem uzyj `zo` na jednej funkcji

### Cwiczenie 3: Stopniowe zwijanie (zm/zr)

1. W `data_processing.py` zacznij z wszystkim rozwinietym (`zR`)
2. Nacisnij `zm` — zwinelo sie o 1 level (najglebiej zagniezdzony kod)
3. Nacisnij `zm` ponownie — kolejny level
4. Kontynuuj `zm` az zobaczysz tylko top-level
5. Teraz `zr` — rozwijaj po jednym levelu
6. `zr` ponownie — kolejny level sie rozwinil
7. To pozwala kontrolowac "szczegolowosc" widoku

### Cwiczenie 4: Zwijanie komentarzy

1. W `data_processing.py` zauwaz dlugie docstringi/komentarze
2. Nacisnij `<leader>cc` — WSZYSTKIE komentarze i docstringi sie zwina
3. Teraz widzisz czysty kod bez szumu dokumentacyjnego
4. Nacisnij `<leader>cC` — przywraca oryginalne folding (rozwinięte)
5. Alternatywnie: `<leader>cR` rozwin absolutnie wszystko (`zR`)

### Cwiczenie 5: Nawigacja po foldach

1. W `data_processing.py` zwin kilka funkcji (`zc` na kazdej)
2. Nacisnij `zj` — przeskoczysz do nastepnego folda
3. Nacisnij `zj` ponownie — kolejny fold
4. Nacisnij `zk` — wroc do poprzedniego
5. To szybki sposob skakania miedzy zwiniętymi blokami

### Cwiczenie 6: Fold w pliku Vue (indent)

1. Otworz `exercises/vue/UserCard.vue`
2. Zauwaz, ze folding dziala na bazie wciec (indent), nie treesitter
3. Nacisnij `zM` — sekcje `<template>`, `<script>`, `<style>` sie zwina
4. Rozwin `<template>` (`zo`) — zobaczysz HTML
5. Zwin ponownie (`zc`) — schludny widok sekcji SFC

### Cwiczenie 7: Rekurencyjne zwijanie

1. W pliku Python znajdz klase z wieloma metodami
2. Ustaw kursor na linii z `class`
3. Nacisnij `zC` (wielkie C) — zwinelo klase I wszystkie metody wewnatrz
4. Nacisnij `zO` (wielkie O) — rozwinelo klase I wszystkie metody
5. Porownaj z `zc`/`zo` ktore dzialaja tylko na jednym poziomie

### Cwiczenie 8: Praktyczny workflow — review kodu

1. Otworz `data_processing.py`
2. `zM` — zwin wszystko (widok z lotu ptaka)
3. Znajdz interesujaca Cie funkcje w liscie
4. `zo` — rozwin tylko ta funkcje
5. Przeanalizuj kod
6. `zc` — zwin z powrotem
7. `zj` — przejdz do nastepnej, `zo` — rozwin
8. Ten workflow pozwala skupic sie na jednej funkcji naraz

### Cwiczenie 9: Mieszany workflow z komentarzami

1. `zR` — rozwin wszystko
2. `<leader>cc` — zwin komentarze (ale kod zostaje rozwiniety)
3. Przegladaj czysty kod
4. Gdy potrzebujesz docstringa — `zo` na zwinietym komentarzu
5. Przeczytaj, `zc` — zwin z powrotem
6. `<leader>cC` — przywroc pelny widok

### Cwiczenie 10: Fold columns (opcjonalne)

1. Uruchom `:set foldcolumn=2` — po lewej stronie pojawi sie kolumna foldow
2. Zobaczysz `+` przy zwiniętych i `-`/`|` przy rozwiniętych foldach
3. To wizualny indicator glebokosci foldow
4. `:set foldcolumn=0` — ukryj kolumne (domyslnie ukryta w Twojej konfiguracji)

---

## Cwiczenie bonusowe

**Scenariusz: analiza dlugiego pliku**

Dostajesz do przegladniecia duzy plik Python z 20+ funkcjami i dlugimi
docstringami. Musisz znalezc i zrozumiec 3 kluczowe funkcje.

1. Otworz `exercises/python/data_processing.py`
2. Najpierw: `zM` — zwin wszystko, zeby zobaczyc strukture
3. Policz ile jest funkcji/klas — widok "spis tresci"
4. `<leader>fs` (Telescope Symbols) — alternatywny widok struktury
5. Wróc do pliku: `zR` → `<leader>cc` — rozwin kod, zwin komentarze
6. Znajdz interesujace funkcje i przeanalizuj ich logike
7. Na jednej funkcji uzyj `zC` (rekurencyjne zwijanie) zeby ja "schowac"
   po przeanalizowaniu
8. Powtorz na pozostalych — w koncu zostajesz z 3 rozwiniętymi funkcjami
   i reszta zwinieta
9. `<leader>cC` + `zR` — przywroc wszystko na koniec

---

## Podsumowanie

| Skrot / Komenda   | Dzialanie                                  |
|-------------------|--------------------------------------------|
| `zo` / `zc`       | Rozwin / zwin fold pod kursorem            |
| `za`              | Toggle fold                                |
| `zR` / `zM`       | Rozwin / zwin WSZYSTKO                    |
| `zr` / `zm`       | Rozwin / zwin o 1 level                   |
| `zO` / `zC`       | Rozwin / zwin rekurencyjnie               |
| `zj` / `zk`       | Nastepny / poprzedni fold                 |
| `<leader>cc`      | Zwin komentarze i docstringi              |
| `<leader>cC`      | Rozwin i przywroc folding                 |
| `<leader>cR`      | Rozwin wszystko (`zR`)                    |

### Podsumowanie modulu 3

Lekcje 15-20 pokryly **nawigacje i zarzadzanie workspace'em**:

| Lekcja | Temat           | Kluczowa umiejetnosc                       |
|--------|-----------------|--------------------------------------------|
| 15     | Buffers         | Zarzadzanie otwartymi plikami              |
| 16     | Windows/Splits  | Dzielenie ekranu, integracja z tmux        |
| 17     | Telescope       | Fuzzy finding — pliki, tekst, keymaps      |
| 18     | Neo-tree        | Drzewo plikow, operacje na strukturze      |
| 19     | Yazi            | Zaawansowany file manager, bulk operations |
| 20     | Folding         | Zwijanie kodu, fokus na istotnych czesciach|

Opanowales narzedzia do **efektywnej pracy z wieloma plikami** —
od otwierania i wyszukiwania, przez organizacje ekranu, po zarzadzanie
widocznoscia kodu. Nastepny modul bedzie poswiecony **edycji kodu
z pomoca LSP, autocompletion i snippets**.
