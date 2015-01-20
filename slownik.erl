-module(slownik).

-export([nowy_slownik_ets/0, dodaj_tlumaczenie_ets/2, dodaj_nowe_slowo_ets/2, zmien_tlumaczenia_ets/2, przetlumacz_na_angielski_ets/1, toDETS/0, print/1]).
-export([nowy_slownik/0, dodaj_tlumaczenie/3, dodaj_nowe_slowo/3, zmien_tlumaczenia/3, przetlumacz_na_angielski/2]).

-record(slowo, {wersja_polska, wersja_angielska=[]}).


%%wersja z ets:
dane() -> [
  {slowo, "aktualny", ["current", "present"]},
  {slowo, "aleja", ["alley", "avenue"]},
  {slowo, "autentyczny", ["authentic", "genuine"]},
  {slowo, "bagietka", ["baguette"]},
  {slowo, "barwny", ["colourful", "colorful"]},
  {slowo, "chleb", ["bread"]},
  {slowo, "chłodzić", ["cool", "chill", "refrigerate"]},
  {slowo, "drabina", ["ladder", "stepladder"]},
  {slowo, "historia", ["history", "story"]},
  {slowo, "ilość", ["amount", "quantity"]},
  {slowo, "kasjer", ["cashier", "teller"]},
  {slowo, "kawałek", ["bit", "piece"]},
  {slowo, "ognisty", ["fiery", "flaming"]},
  {slowo, "południe", ["noon", "midday"]},
  {slowo, "salon", ["living room", "sitting room", "drawing room", "lounge"]},
  {slowo, "ulewa", ["downpour", "rainstorm"]},
  {slowo, "wartość", ["value", "worth"]}
].

%%tworzy nowy slownik
nowy_slownik_ets() ->
  ets:new(nasz_slownik, [{keypos, #slowo.wersja_polska}, named_table, ordered_set]),
  ets:insert(nasz_slownik, dane()).
  %print(nasz_slownik).

%%funkcja dodaje nowe tlumaczenie do istniejacego slowa zachowujac poprzednie tlumaczenia
dodaj_tlumaczenie_ets(Wersja_polska, Tlumaczenie) ->
  Poprzednie_tlumaczenia = ets:lookup_element(nasz_slownik, Wersja_polska, #slowo.wersja_angielska ),
  ets:insert(nasz_slownik, #slowo{wersja_polska = Wersja_polska, wersja_angielska = [Tlumaczenie] ++ Poprzednie_tlumaczenia}).
  %print(nasz_slownik).

%%funkcja dodaje nowe slowo o ile ono sie juz w slowniu nie znajduje
dodaj_nowe_slowo_ets(Wersja_polska, Lista_tlumaczen) ->
  ets:insert_new(nasz_slownik, {slowo, Wersja_polska, Lista_tlumaczen}).
  %print(nasz_slownik).

%%funkcja nadpisuje tlumaczenia do istniejacego slowa lub dodaje nowe slowo
zmien_tlumaczenia_ets(Wersja_polska, Lista_nowych_tlumaczen) ->
  ets:insert(nasz_slownik, {slowo, Wersja_polska, Lista_nowych_tlumaczen}).
  %print(nasz_slownik).

%%funkcja wypisuje wartosci dla danego klucza
przetlumacz_na_angielski_ets(Wersja_polska) ->
  ets:lookup_element(nasz_slownik, Wersja_polska, #slowo.wersja_angielska ).





%%wersja bez ets - dane sa przechowywane w tablicy:
nowy_slownik() ->
  dane().

%%funkcja dodaje nowe slowo z tlumaczeniem lub jesli juz istnieje dodaje do listy tlumaczen wersje angielska slowa
dodaj_tlumaczenie(Wersja_polska, Tlumaczenie, []) ->
  [#slowo{wersja_polska = Wersja_polska, wersja_angielska = Tlumaczenie}];
dodaj_tlumaczenie(Wersja_polska, Tlumaczenie, [H = #slowo{wersja_polska = Wersja_polska} | _]) ->
  [#slowo{wersja_polska = Wersja_polska, wersja_angielska = [Tlumaczenie] ++ H#slowo.wersja_angielska}];
dodaj_tlumaczenie(Wersja_polska, Tlumaczenie, [H | T]) ->
  [H | dodaj_tlumaczenie(Wersja_polska, Tlumaczenie, T)].

%%funkcja dodaje nowe slowo z tlumaczeniem
dodaj_nowe_slowo(Wersja_polska, Tlumaczenia, L) ->
  [#slowo{wersja_polska = Wersja_polska, wersja_angielska = Tlumaczenia} | L].

%%funkcja nadpisuje tlumaczenia do istniejacego slowa
zmien_tlumaczenia(Wersja_polska, Lista_nowych_tlumaczen, []) ->
  [#slowo{wersja_polska = Wersja_polska, wersja_angielska = Lista_nowych_tlumaczen}];
zmien_tlumaczenia(Wersja_polska, Lista_nowych_tlumaczen, [#slowo{wersja_polska = Wersja_polska} | _]) ->
  [#slowo{wersja_polska = Wersja_polska, wersja_angielska = Lista_nowych_tlumaczen}];
zmien_tlumaczenia(Wersja_polska, Lista_nowych_tlumaczen, [H | T]) ->
  [H | zmien_tlumaczenia(Wersja_polska,Lista_nowych_tlumaczen, T)].

%%funkcja wypisuje wartosci dla danego klucza
przetlumacz_na_angielski(_, []) ->
  [];
przetlumacz_na_angielski(Wersja_polska, [H = #slowo{wersja_polska = Wersja_polska} | _]) ->
  H#slowo.wersja_angielska;
przetlumacz_na_angielski(Wersja_polska, [_ | T]) ->
  przetlumacz_na_angielski(Wersja_polska, T).


%%funkcja wypisuje tabelę ets
print(Slownik) ->
  First = ets:first(Slownik),
  Values = ets:lookup(Slownik, First),
  print(Slownik, First, Values).
print(_, '$end_of_table', _) -> ok;
print(Slownik, Key, Values) ->
  io:format("~w~w\n", [Key, Values]),
  Next = ets:next(Slownik, Key),
  NewValues = ets:lookup(Slownik, Next),
  print(Slownik, Next, NewValues).

%%funkcja sprawdza poprawność importu i eksportu tablicy ets do tablicy dets
toDETS() ->
  ets:tab2file(nasz_slownik, slownik),
  dets:open_file(slownik, []),
  dets:close(slownik).