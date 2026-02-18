# Cwiczenie 20: Folding

> Powiazana lekcja: `lessons/20-folding.md`

## Instrukcje
- `zo` / `zc` -- rozwin / zwin fold pod kursorem
- `za` -- toggle fold
- `zR` / `zM` -- rozwin / zwin WSZYSTKO
- `zr` / `zm` -- rozwin / zwin o 1 level
- `zO` / `zC` -- rozwin / zwin rekurencyjnie
- `zj` / `zk` -- nastepny / poprzedni fold
- `[z` / `]z` -- poczatek / koniec biezacego folda
- `<leader>cc` -- zwin komentarze i docstringi
- `<leader>cC` -- rozwin i przywroc treesitter folding
- `<leader>cR` -- rozwin wszystko (`zR`)
- foldmethod=expr (treesitter), Vue: foldmethod=indent

## Cwiczenie 1: Mapa pliku -- widok z lotu ptaka

1. Otworz `exercises/python/data_processing.py`
2. `zM` -- zwin WSZYSTKO
3. Teraz widzisz tylko naglowki: nazwy klas, funkcji, importy
4. Policz ile jest top-level definicji (klas/funkcji)
5. Zanotuj sobie mentalnie strukture pliku
6. `zR` -- rozwin wszystko z powrotem
7. Porownaj: `zM` daje Ci "spis tresci", `zR` daje pelny kod

## Cwiczenie 2: Selektywne otwieranie

1. W `data_processing.py` nacisnij `zM` (zwin wszystko)
2. Nawiguj do pierwszej zwini etej funkcji
3. `zo` -- rozwin TYLKO ta jedną funkcje
4. Przeczytaj jej kod
5. `zc` -- zwin ja z powrotem
6. `zj` -- przejdz do nastepnego folda
7. `zo` -- rozwin nastepna
8. Powtorz: `zc`, `zj`, `zo` -- przeglad funkcja po funkcji

## Cwiczenie 3: Stopniowe odkrywanie (zm/zr)

1. W `data_processing.py` zacznij z `zR` (wszystko rozwin iete)
2. `zm` -- zwija najglebszy level (wewnetrzne bloki)
3. `zm` -- kolejny level sie zwinal
4. `zm` -- i kolejny...
5. Kontynuuj az zostanie sam top-level
6. Teraz odwrotnie: `zr` -- rozwin o 1 level
7. `zr` -- kolejny level
8. Obserwuj jak kod "wyplywa" level po levelu

To jak regulacja "szczegolow osci" widoku kodu.

## Cwiczenie 4: Zwijanie komentarzy w Pythonie

1. Otworz `exercises/python/calculator.py`
2. Przegladnij plik -- zauwaz docstringi (potrojne cudzyslowy)
3. `<leader>cc` -- zwin WSZYSTKIE komentarze i docstringi
4. Teraz widzisz TYLKO kod -- bez szumu dokumentacyjnego
5. Najedz na zwiniety docstring, nacisnij `zo` -- podejrzyj go
6. `zc` -- zwin z powrotem
7. `<leader>cC` -- przywroc pelny widok

## Cwiczenie 5: Folding w TypeScript

1. Otworz `exercises/typescript/api-service.ts`
2. `zM` -- zwin wszystko
3. Zauwaz, ze treesitter rozumie TypeScript: klasy, metody, interfejsy
4. Rozwin tylko jedna metode: `zo`
5. Przeczytaj implementacje
6. `zc` -- zwin
7. Teraz: `zR`, potem `<leader>cc` -- zwin komentarze, zostaw kod

Porownaj z Pythonem -- ten sam workflow, inny jezyk, ta sama zasada.

## Cwiczenie 6: Folding w Vue (indent-based)

1. Otworz `exercises/vue/UserCard.vue`
2. Zauwaz: Vue uzywa `foldmethod=indent` (nie treesitter)
3. `zM` -- zwin wszystko
4. Powinny byc widoczne 3 sekcje: `<template>`, `<script>`, `<style>`
5. `zo` na `<template>` -- rozwin HTML
6. `zc` -- zwin z powrotem
7. `zo` na `<script>` -- rozwin logike
8. `zc`, `zo` na `<style>` -- rozwin style

Indent-based folding jest mniej precyzyjny, ale dobrze dzieli Vue SFC na sekcje.

## Cwiczenie 7: Nawigacja miedzy foldami

1. Otworz `exercises/python/data_processing.py`
2. Zwin kilka funkcji recznie: ustaw kursor na `def`, `zc`
3. Zwin 4-5 roznych funkcji
4. Teraz: `gg` -- wroc na gore pliku
5. `zj` -- skocz do pierwszego folda
6. `zj` -- skocz do nastepnego
7. `zk` -- wroc do poprzedniego
8. Na jednym foldzie: `zo` -- rozwin go
9. `[z` -- przejdz do poczatku tego folda
10. `]z` -- przejdz do konca tego folda

## Cwiczenie 8: Rekurencyjne zwijanie klas

1. Otworz `exercises/typescript/api-service.ts` (lub plik z klasami)
2. Znajdz definicje klasy
3. Ustaw kursor na linii z `class`
4. `zC` (wielkie C) -- zwinela sie klasa ORAZ wszystkie metody wewnatrz
5. `zO` (wielkie O) -- rozwinela sie klasa ORAZ wszystkie metody
6. Porownaj z `zc` (zwija tylko klase, metody zostaja rozwin iete)
7. `zC` jest idealny do "schowania" calej klasy za jedna linia

## Cwiczenie bonusowe

**Scenariusz: review dlugiego pliku z fokusem na zmianach**

Dostajesz do przegladniecia plik `exercises/python/data_processing.py`.
Musisz znalezc i przeanalizowac 2 konkretne funkcje, ignorujac reszte:

1. Otworz plik
2. `zM` -- zwin wszystko (widok "spis tresci")
3. Przegladnij nazwy funkcji -- znajdz 2, ktore Cie interesuja
4. Na pierwszej: `zo` -- rozwin
5. `<leader>cc` -- zwin komentarze/docstringi (zobaczyc czysty kod)
6. Przeanalizuj logike
7. Na drugiej interesujac ej funkcji: `zj` do niej, `zo`
8. Przeanalizuj
9. Teraz masz 2 rozwin iete funkcje, reszta zwin ieta -- idealny fokus
10. `zR` -- rozwin wszystko na koniec
11. `<leader>cC` -- przywroc normalne folding

**Bonus**: Otworz `exercises/vue/DataTable.vue` i uzyj foldingu, zeby
skupic sie kolejno na `<template>`, `<script>`, `<style>` -- rozwin
tylko jedna sekcje naraz (`zM` + `zo` na wybranej).
