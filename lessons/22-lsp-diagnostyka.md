# Lekcja 22: LSP diagnostyka -- bledy i ostrzezenia

> Czas: ~30-45 min | Poziom: Intermediate

## Cel lekcji

Nauczysz sie czytac i nawigowac po diagnostyce LSP -- bledach, ostrzezeniach, informacjach
i hintach. Zrozumiesz jak Neovim wyswietla problemy (sign column, virtual text, undercurl),
jak skakac miedzy nimi i jak wyciagac pelne informacje o bledach.

## Teoria

### Czym jest diagnostyka?

Diagnostyka to informacje od language servera o problemach w kodzie. Dziala jak kompilator
w czasie rzeczywistym -- nie musisz uruchamiac programu, zeby zobaczyc bledy typow,
brakujace importy czy nieosiagalny kod.

Kazdy diagnostic ma:
- **Severity** (poziom waznosci)
- **Message** (opis problemu)
- **Source** (ktory LSP server/narzedzie go wygenerowal)
- **Range** (dokladna pozycja w kodzie)

### Poziomy diagnostyki

| Poziom | Ikona | Kolor (Catppuccin) | Opis |
|--------|-------|---------------------|------|
| ERROR | 󰅚 | Czerwony (red) | Blad uniemozliwiajacy kompilacje/uruchomienie |
| WARN | 󰀪 | Zolty (yellow) | Ostrzezenie -- kod zadziala, ale cos jest nie tak |
| INFO | 󰋽 | Niebieski (blue) | Informacja -- sugestia, nie problem |
| HINT | 󰌶 | Turkusowy (teal) | Podpowiedz -- styl kodu, konwencja |

> **Twoja konfiguracja**: `severity_sort = true` -- diagnostyki sa sortowane po waznosci.
> Bledy (ERROR) sa zawsze na gorze listy, potem ostrzezenia itd. Dzieki temu najwazniejsze
> problemy widzisz jako pierwsze.

### Gdzie widac diagnostyke?

Diagnostyka wyswietla sie w kilku miejscach jednoczesnie:

#### 1. Sign column (kolumna znakow)

Po lewej stronie numeru linii pojawiaja sie ikony:

```
 󰅚  23 │     return math.sqrt(a ** 2 + b ** 2)
    24 │
 󰀪  25 │     host = config["database"]["host"]
```

Ikona wskazuje linie z problemem i jej poziom waznosci.

#### 2. Virtual text

Na koncu linii z bledem pojawia sie tekst z opisem problemu:

```python
return math.sqrt(a ** 2 + b ** 2)  # "math" is not defined
```

> **Twoja konfiguracja**: Virtual text wyswietla source "if_many" -- nazwa zrodla
> (np. `Pyright`, `ts_ls`) pojawia sie tylko jesli jest wiecej niz jeden zrodlowy
> LSP server/linter. Dzieki temu tekst jest krotszy kiedy pracujesz z jednym jezykiem.

#### 3. Underline (undercurl)

Problemowy fragment kodu jest podkreslony falistym podkresleniem.

> **Twoja konfiguracja**: Underline jest wlaczony **tylko dla ERROR**. Ostrzezenia
> i informacje NIE sa podkreslane -- to zmniejsza wizualny szum. W terminalu Kitty
> widzisz prawdziwy undercurl (falisty), nie zwykly underline.

#### 4. Floating window

Pelny opis diagnostyki wyswietla sie w floating window po uzyciu `<leader>ld`
lub hover (`K` na linii z bledem).

### Hover: `K`

Klawisz `K` w trybie Normal wyswietla **hover information** -- floating window
z informacjami o symbolu pod kursorem:

| Kontekst | Co pokazuje `K` |
|----------|-----------------|
| Na funkcji | Sygnatura + docstring |
| Na klasie | Opis klasy + pola |
| Na zmiennej | Typ zmiennej |
| Na imporcie | Informacje o module |
| Na bledzie | Wiadomosc diagnostyczna |

```
┌─────────────────────────────────────────────────┐
│ (function) def calculate_hypotenuse(             │
│     a: float,                                    │
│     b: float                                     │
│ ) -> float                                       │
│                                                  │
│ Calculate the hypotenuse of a right triangle.    │
└─────────────────────────────────────────────────┘
```

> **Twoja konfiguracja**: Floating window ma zaokraglone ramki (`rounded` border).
> Styl jest spatrzyjny z motywem Catppuccin Mocha.

### Signature Help: `gK`

Podczas pisania argumentow funkcji, `gK` pokazuje sygnature -- jakie parametry
przyjmuje funkcja, jakie sa ich typy i ktory parametr aktualnie wypelniasz.

```python
greet(name, |)
      ^^^^^
┌─────────────────────────────────────────┐
│ greet(name: str, greeting: str,          │
│       punctuation: str) -> str           │
│       ^^^^^^^^^^^                        │
│       aktualny parametr                  │
└─────────────────────────────────────────┘
```

Roznica miedzy `K` a `gK`:
- `K` (hover) -- ogolne informacje o symbolu
- `gK` (signature help) -- parametry biezacego wywolania funkcji

### Line Diagnostics: `<leader>ld`

Otwiera floating window z **pelnym opisem** wszystkich diagnostyk na biezacej linii.
Pokazuje:
- Poziom (ERROR/WARN/INFO/HINT)
- Pelna wiadomosc bledu
- Zrodlo (np. `Pyright`, `ts_ls`)

Jest to szczegolnie przydatne kiedy virtual text jest obciety (dlugie wiadomosci)
lub kiedy na jednej linii jest wiecej niz jeden problem.

```
┌────────────────────────────────────────────────────────┐
│ 󰅚 Error [Pyright]                                     │
│ Argument missing for parameter "greeting" (reportCall  │
│ IssueNone)                                             │
│                                                        │
│ 󰅚 Error [Pyright]                                     │
│ Argument missing for parameter "punctuation" (reportC  │
│ allIssueNone)                                          │
└────────────────────────────────────────────────────────┘
```

### Nawigacja miedzy diagnostykami: `[d` / `]d`

| Klawisz | Opis |
|---------|------|
| `]d` | Skocz do nastepnego diagnostiku (w dol pliku) |
| `[d` | Skocz do poprzedniego diagnostiku (w gore pliku) |

Te klawisze przeskakuja miedzy **wszystkimi** diagnostykami w pliku -- bledami,
ostrzezeniami, informacjami i hintami. Dzieki `severity_sort` bledy maja priorytet.

**Typowy workflow naprawiania bledow**:
1. `]d` -- skocz do pierwszego bledu
2. Przeczytaj wiadomosc (virtual text lub `<leader>ld`)
3. Napraw blad
4. `]d` -- nastepny blad
5. Powtarzaj az do konca pliku
6. `[d` -- wroc jesli pominales cos

### Konfiguracja diagnostyki -- podsumowanie

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| `severity_sort` | `true` | Bledy na gorze listy |
| `float.border` | `rounded` | Zaokraglone ramki floating windows |
| `underline.severity` | `ERROR` only | Podkreslenie tylko dla bledow |
| `signs` | 󰅚 󰀪 󰋽 󰌶 | Ikony Nerd Font w sign column |
| `virtual_text.source` | `"if_many"` | Zrodlo tylko jesli >1 LSP |

### Co generuje diagnostyke?

Nie tylko LSP server generuje diagnostyke. W Twoim setupie kilka narzedzi
moze zglaszac problemy:

| Narzedzie | Typ diagnostyk |
|-----------|---------------|
| pyright | Bledy typow Python, brakujace importy |
| ts_ls | Bledy TypeScript, problemy z typami |
| vue_ls | Bledy szablonow Vue, props validation |
| lua_ls | Bledy Lua (w plikach konfiguracyjnych Neovim) |

## Cwiczenia

### Cwiczenie 1: Odczytywanie diagnostyki w Python

Otworz `exercises/python/broken.py`:

1. Zwroc uwage na ikony 󰅚 w sign column -- kazda oznacza linie z bledem
2. Pierwsza linia z bledem to `return math.sqrt(...)` (~linia 20)
3. Przeczytaj virtual text na koncu linii -- powinno pisac cos o `"math" is not defined`
4. Ustaw kursor na `math` i nacisnij `K` -- hover pokaze Ci ze `math` nie jest zaimportowany
5. Nacisnij `<leader>ld` -- floating window z pelna wiadomoscia diagnostyczna

### Cwiczenie 2: Nawigacja po bledach

Kontynuuj w `exercises/python/broken.py`:

1. Idz na poczatek pliku (`gg`)
2. Nacisnij `]d` -- skaczesz do pierwszego bledu (`math` nie zdefiniowany)
3. Nacisnij `]d` ponownie -- nastepny blad (`config` nie zdefiniowany)
4. Kontynuuj `]d` -- przejdz przez wszystkie bledy w pliku:
   - `math` is not defined (~linia 20)
   - `config` is not defined (~linia 26)
   - Missing arguments w `greet("Alice")` (~linia 36)
   - Type mismatch w `add_numbers("hello", "world")` (~linia 44)
   - `phone` attribute nie istnieje (~linia 54)
   - Incompatible return type `None` (~linia 62)
   - Unreachable code (~linia 70)
   - `total` possibly unbound (~linia 79)
   - Wrong key type `int` vs `str` (~linia 84)
5. Wroc na poczatek `[d` wielokrotnie

### Cwiczenie 3: Hover na roznych symbolach

Kontynuuj w `exercises/python/broken.py`:

1. Ustaw kursor na `Optional` (import, ~linia 3) i nacisnij `K`
   - Hover pokaze Ci definicje `Optional` z modulu `typing`
2. Ustaw kursor na nazwie funkcji `get_database_url` (~linia 24) i nacisnij `K`
   - Hover pokaze sygnature: `def get_database_url() -> str`
3. Ustaw kursor na klase `User` (~linia 48) i nacisnij `K`
   - Hover pokaze definicje klasy z jej polami
4. Ustaw kursor na `user.phone` (~linia 54) i nacisnij `K`
   - Hover pokaze blad: attribute `phone` nie istnieje na `User`

### Cwiczenie 4: Diagnostyka TypeScript

Otworz `exercises/typescript/broken.ts`:

1. `gg` -- idz na poczatek
2. `]d` -- przejdz przez bledy:
   - Missing `email` w obiekcie `admin` (~linia 23)
   - Type `number` not assignable to `string` (~linia 34)
   - Property `description` does not exist (~linia 44)
   - Argument type mismatch `string` vs `number[]` (~linia 52)
   - `await` in non-async function (~linia 68)
   - Return type mismatch `string` vs `number` (~linia 75)
   - Private member access (~linia 94)
   - Object possibly null (~linia 99)
   - Readonly assignment (~linia 109)
3. Na kazdym bledzie nacisnij `<leader>ld` i przeczytaj pelny opis

### Cwiczenie 5: Line Diagnostics z wieloma bledami

Otworz `exercises/python/broken.py`:

1. Idz do linii `message = greet("Alice")` (~linia 36)
2. Nacisnij `<leader>ld` -- powinna sie pojawic lista bledow:
   - Brakujacy argument `greeting`
   - Brakujacy argument `punctuation`
3. Zwroc uwage na format: ikona, poziom, zrodlo (Pyright), tresc
4. Zamknij floating window (`Esc` lub `q`)

### Cwiczenie 6: Rozroznianie severity levels

Otworz `exercises/python/broken.py`:

1. Sprawdz ktore bledy maja undercurl (faliste podkreslenie) -- powinny to byc TYLKO
   linie z ERROR (czerwone undercurl w Kitty)
2. Sprawdz sign column -- ikona 󰅚 dla errors, 󰀪 dla warnings
3. Zwroc uwage na kolory ikon -- czerwony vs zolty

### Cwiczenie 7: Hover documentation na dobrym kodzie

Otworz `exercises/python/calculator.py` (plik BEZ bledow):

1. Ustaw kursor na nazwie metody `divide` (~linia 121) i nacisnij `K`
   - Hover pokaze pelny docstring z Args i Raises
2. Ustaw kursor na `DivisionByZeroError` (~linia 135) i nacisnij `K`
   - Hover pokaze definicje exception
3. Ustaw kursor na `math.sqrt` (~linia 164) i nacisnij `K`
   - Hover pokaze dokumentacje z modulu `math`
4. Ustaw kursor na dekorator `@dataclass` (~linia 64) i nacisnij `K`
   - Hover pokaze dokumentacje `dataclass` z opisem parametrow

### Cwiczenie 8: Signature Help

Otworz `exercises/python/calculator.py`:

1. Idz na koniec pliku
2. Wejdz w tryb Insert (`o` -- nowa linia)
3. Wpisz `calc = Calculator(` -- powinien sie pojawic signature help
4. Jesli nie -- nacisnij `gK` w trybie Normal na nawiasie
5. Zwroc uwage na podswietlony parametr `precision: int = 10`
6. Nacisnij `Esc` i cofnij zmiany (`u`)

### Cwiczenie 9: Virtual text source

Otworz `exercises/typescript/broken.ts`:

1. Sprawdz virtual text na koncu linii z bledem
2. Zwroc uwage czy widac nazwe zrodla (np. `ts(2322)`) -- kody bledow TypeScript
3. Porownaj z `exercises/python/broken.py` -- tam zrodlem jest Pyright
4. Virtual text source powinno sie pojawiac bo masz tylko jeden LSP server per filetype

### Cwiczenie 10: Diagnostyka Vue

Otworz `exercises/vue/UserCard.vue` (o ile zawiera bledy lub dodaj tymczasowy blad):

1. W sekcji `<script setup lang="ts">` dodaj linie: `const x: number = "hello";`
2. Poczekaj chwile na diagnostyke (vue_ls + ts plugin moze potrzebowac sekundy)
3. Sprawdz czy pojawila sie ikona 󰅚 i virtual text
4. Nacisnij `K` na bledzie
5. Cofnij zmiane (`u`) -- diagnostyka powinna zniknac

## Cwiczenie bonusowe

Otworz `exercises/python/broken.py` i wykonaj pelny "audit bledow":

1. Idz na poczatek pliku (`gg`)
2. Nawiguj `]d` do kazdego bledu
3. Dla kazdego:
   a. Przeczytaj virtual text
   b. Nacisnij `<leader>ld` zeby zobaczyc pelna wiadomosc
   c. Nacisnij `K` zeby sprawdzic hover
   d. Zapisz w glowie co jest nie tak (ale NIE naprawiaj -- to zrobimy w lekcji 23!)
4. Policz ile jest bledow w pliku
5. Zastanow sie ktore bledy sa trywialne (brakujacy import) a ktore wymagaja zmian logiki

## Podsumowanie

### Nauczone komendy

| Komenda | Opis |
|---------|------|
| `K` | Hover -- dokumentacja, typ, sygnatura symbolu |
| `gK` | Signature Help -- parametry biezacego wywolania |
| `<leader>ld` | Line Diagnostics -- pelny opis bledow na linii |
| `]d` | Nastepny diagnostik |
| `[d` | Poprzedni diagnostik |

### Elementy diagnostyki

| Element | Gdzie widac | Opis |
|---------|------------|------|
| Sign column | Lewa strona (ikony 󰅚 󰀪 󰋽 󰌶) | Ikona severity na linii |
| Virtual text | Koniec linii z bledem | Skrocony opis problemu |
| Underline/Undercurl | Na blednym fragmencie | Tylko dla ERROR (Kitty = undercurl) |
| Floating window | `<leader>ld` lub `K` | Pelny opis z zrodlem |

### Konfiguracja uzyta w tej lekcji

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| `severity_sort` | `true` | Bledy przed ostrzezeniami |
| `underline` | ERROR only | Mniej wizualnego szumu |
| `virtual_text.source` | `"if_many"` | Source widoczny przy wielu LSP |
| `float.border` | `rounded` | Estetyczne floating windows |
| `signs` | Nerd Font icons | 󰅚 󰀪 󰋽 󰌶 w sign column |

### Co dalej?

W **lekcji 23** poznasz **akcje LSP** -- code actions do automatycznego naprawiania bledow,
rename do zmiany nazw symboli w calym projekcie, formatowanie kodu przez conform.nvim
i system completion (nvim-cmp).
