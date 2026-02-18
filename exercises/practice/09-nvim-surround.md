# Cwiczenie 09: nvim-surround

> Powiazana lekcja: `lessons/09-nvim-surround.md`

## Instrukcje
- `ys{motion}{char}` -- dodaj otoczenie (np. `ysiw"` = otocz slowo cudzyslowami)
- `cs{old}{new}` -- zmien otoczenie (np. `cs"'` = zmien `"` na `'`)
- `ds{char}` -- usun otoczenie (np. `ds"` = usun cudzyslowy)
- `yss{char}` -- otocz cala linie
- `S{char}` -- otocz zaznaczenie w trybie Visual
- `)` / `]` / `}` -- bez spacji; `(` / `[` / `{` -- ze spacjami wewnatrz
- `t` -- tag HTML (do `cst`, `dst`)
- `f` -- function surround (np. `ysiwf` + nazwa)
- `.` -- dot repeat dziala ze wszystkimi operacjami surround

## Cwiczenie 1: Otaczanie argumentow funkcji

Otocz kazda nazwe zmiennej cudzyslowami (`ysiw"`), a potem cale wyrazenie nawiasami (`yss)`):

```python
name = request.get(username)
age = request.get(age)
email = request.get(email_address)
role = request.get(default_role)
department = request.get(dept)
```

Oczekiwany wynik:
```python
name = request.get("username")
```

## Cwiczenie 2: Zamiana typow nawiasow

Zmien nawiasy okragle na kwadratowe (`cs)]`), a klamrowe na okragle (`cs})`):

```javascript
const fruits = (apple, banana, cherry);
const vegs = (carrot, onion, pepper);
const nums = {1, 2, 3, 4, 5};
const flags = {true, false, true};
const mixed = (hello, {world}, (nested));
```

## Cwiczenie 3: Usuwanie otoczenia w kodzie

Usun niepotrzebne otoczenia uzywajac `ds"`, `ds)`, `dst`:

```typescript
const x = ("value");
const y = (("nested"));
const label = <span>"important"</span>;
const result = ("calculated");
const msg = <div><b>"Hello"</b></div>;
```

Hint: Na linii z `msg` uzyj `dst` dwukrotnie (zewnetrzny tag, potem wewnetrzny), potem `ds"`.

## Cwiczenie 4: Konwersja stringow do template literals

Zmien cudzyslowy `"` na backticki `` ` `` uzywajac `cs"`` `:

```typescript
const greeting = "Hello, " + name + "!";
const url = "https://api.com/v1/users/" + userId;
const query = "SELECT * FROM " + table + " WHERE id = " + id;
const msg = "Found " + count + " results in " + duration + "ms";
const path = "uploads/" + folder + "/" + filename;
```

## Cwiczenie 5: Praca z tagami HTML

1. Otocz slowa tagami (np. `ysiw<strong>`)
2. Zmien tagi (`cst<em>`)
3. Usun tagi (`dst`)

```html
<p>To jest zwykly tekst z waznym slowem i naglowkiem</p>

<div class="alert">
  <span class="label">Warning</span>
  <span class="message">Disk space low</span>
  <b>Action required</b>
</div>

<ul>
  <li><a href="#">First item</a></li>
  <li><a href="#">Second item</a></li>
  <li><a href="#">Third item</a></li>
</ul>
```

Zadania:
1. Otocz slowo `waznym` tagiem `<strong>` (`ysiw<strong>`)
2. Otocz `naglowkiem` tagiem `<em>` (`ysiw<em>`)
3. Zmien `<span class="label">` na `<div class="label">` (`cst<div class="label">`)
4. Usun tagi `<b>` wokol "Action required" (`dst`)
5. Zmien `<a href="#">` na `<a href="/page">` (`cst<a href="/page">`)

## Cwiczenie 6: Function surround

Uzyj `ysiwf` + nazwa funkcji aby otoczyd slowa wywolaniami:

```python
data = raw_input
count = items
output = result
valid = user_email
encoded = payload
```

Zadania:
1. Kursor na `raw_input` -- `ysiwf` + `sanitize` -- wynik: `sanitize(raw_input)`
2. Kursor na `items` -- `ysiwf` + `len` -- wynik: `len(items)`
3. Kursor na `result` -- `ysiwf` + `json.dumps` -- wynik: `json.dumps(result)`
4. Kursor na `user_email` -- `ysiwf` + `validate` -- wynik: `validate(user_email)`
5. Kursor na `payload` -- `ysiwf` + `base64.encode` -- wynik: `base64.encode(payload)`

## Cwiczenie 7: Dot repeat z surround

Uzyj `ysiw"` na pierwszym slowie, a potem `.` (dot repeat) + `w` na kolejnych:

```
server_host
server_port
database_name
database_user
database_pass
redis_url
cache_ttl
log_level
```

Cel: Kazde slowo powinno byc otoczone cudzyslowami. Sekwencja: `ysiw"` na pierwszym, potem `j.` na kazdym nastepnym.

## Cwiczenie bonusowe

**Refaktor Vue template**: Wykonaj wszystkie operacje bez wchodzenia w tryb Insert:

```html
<div class="container">
  <span>{{ user.name }}</span>
  <span>{{ user.email }}</span>
  <p class="bio">{{ user.bio }}</p>
  <div class="avatar">
    <img src="avatar.png">
  </div>
  <a href="#">Edit profile</a>
  <button>Save</button>
</div>
```

1. Zmien wszystkie `<span>` na `<strong>` (`cst<strong>`, potem `j.`)
2. Zmien `<p class="bio">` na `<blockquote>` (`cst<blockquote>`)
3. Zmien `<div class="avatar">` na `<figure>` (`cst<figure>`)
4. Zmien `<a href="#">` na `<a href="/edit">` (`cst<a href="/edit">`)
5. Otocz `<button>Save</button>` dodatkowym tagiem `<form>` (Visual: `vat`, potem `S<form>`)
