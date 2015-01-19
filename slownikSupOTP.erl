-module(slownikSupOTP).
-behaviour(gen_server).

-export([start_link/0, init/1, handle_call/3, handle_cast/2, code_change/3, handle_info/2, terminate/2, stop/0, crash/0, check/2]).
-export([nowy_slownik_ets/0, dodaj_tlumaczenie_ets/2, dodaj_nowe_slowo_ets/2, zmien_tlumaczenia_ets/2, przetlumacz_na_angielski_ets/1]).
-export([nowy_slownik/0, dodaj_tlumaczenie/2, dodaj_nowe_slowo/2, zmien_tlumaczenia/2, przetlumacz_na_angielski/1]).


start_link() ->
  gen_server:start_link({local, slownikSupOTP}, ?MODULE, [], []).

init([]) ->
  {ok, []}.

%%funkcje obslugujace slownik w wersji ets:
nowy_slownik_ets() ->
  gen_server:call(slownikSupOTP, {nowy_slownik_ets}).

dodaj_tlumaczenie_ets(Wersja_polska, Tlumaczenie) ->
  gen_server:call(slownikSupOTP, {dodaj_tlumaczenie_ets, Wersja_polska, Tlumaczenie}).

dodaj_nowe_slowo_ets(Wersja_polska, Lista_tlumaczen) ->
  gen_server:call(slownikSupOTP, {dodaj_nowe_slowo_ets, Wersja_polska, Lista_tlumaczen}).

zmien_tlumaczenia_ets(Wersja_polska, Lista_nowych_tlumaczen) ->
  gen_server:call(slownikSupOTP, {zmien_tlumaczenia_ets, Wersja_polska, Lista_nowych_tlumaczen}).

przetlumacz_na_angielski_ets( Wersja_polska) ->
  gen_server:call(slownikSupOTP, {przetlumacz_na_angielski_ets, Wersja_polska}).

%%funkcje obslugujace slownik przechowywany w tablicy:
nowy_slownik() ->
  gen_server:call(slownikSupOTP, {nowy_slownik}).

dodaj_tlumaczenie(Wersja_polska, Tlumaczenie) ->
  gen_server:call(slownikSupOTP, {dodaj_tlumaczenie, Wersja_polska, Tlumaczenie}).

dodaj_nowe_slowo(Wersja_polska, Tlumaczenia) ->
  gen_server:call(slownikSupOTP, {dodaj_nowe_slowo, Wersja_polska, Tlumaczenia}).

zmien_tlumaczenia(Wersja_polska, Lista_nowych_tlumaczen)->
  gen_server:call(slownikSupOTP, {zmien_tlumaczenia, Wersja_polska, Lista_nowych_tlumaczen}).

przetlumacz_na_angielski(Wersja_polska) ->
  gen_server:call(slownikSupOTP, {przetlumacz_na_angielski, Wersja_polska}).





%z ets:
handle_call({nowy_slownik_ets}, _, Slownik) ->
  check(Slownik, slownik:nowy_slownik_ets());

handle_call({dodaj_tlumaczenie_ets, Wersja_polska, Wersja_angielska}, _, Slownik) ->
  check(Slownik, slownik:dodaj_tlumaczenie_ets(Wersja_polska, Wersja_angielska));

handle_call({dodaj_nowe_slowo_ets, Wersja_polska, Wersja_angielska}, _, Slownik) ->
  check(Slownik, slownik:dodaj_nowe_slowo_ets(Wersja_polska, Wersja_angielska));

handle_call({zmien_tlumaczenia_ets, Wersja_polska, Lista_nowych_tlumaczen}, _, Slownik) ->
  check(Slownik, slownik:zmien_tlumaczenia_ets(Wersja_polska, Lista_nowych_tlumaczen));

handle_call({przetlumacz_na_angielski_ets, Wersja_polska}, _, Slownik) ->
{reply, slownik:przetlumacz_na_angielski_ets(Wersja_polska), Slownik};

%bez ets:
handle_call({nowy_slownik}, _, Slownik) ->
  check(Slownik, slownik:nowy_slownik());

handle_call({dodaj_tlumaczenie, Wersja_polska, Wersja_angielska}, _, Slownik) ->
  check(Slownik, slownik:dodaj_tlumaczenie(Wersja_polska, Wersja_angielska, Slownik));

handle_call({dodaj_nowe_slowo, Wersja_polska, Tlumaczenia}, _, Slownik) ->
  check(Slownik, slownik:dodaj_nowe_slowo(Wersja_polska, Tlumaczenia, Slownik));

handle_call({zmien_tlumaczenia, Wersja_polska, Lista_nowych_tlumaczen}, _, Slownik) ->
  check(Slownik, slownik:zmien_tlumaczenia(Wersja_polska, Lista_nowych_tlumaczen, Slownik));

handle_call({przetlumacz_na_angielski, Wersja_polska}, _, Slownik) ->
  {reply, slownik:przetlumacz_na_angielski(Wersja_polska, Slownik), Slownik}.


%%inne funkcje
handle_cast(stop, Slownik) ->
  {stop, normal, Slownik};
handle_cast(crash, Slownik) ->
  1/0,
  {noreply, Slownik}.

handle_info(_Message, Slownik) ->
  {noreply, Slownik}.

code_change(_OldVsn, slownik, _Extra) ->
  {ok, slownik}.

terminate(Reason, _Value) ->
  io:format("Server stopped.~n"),
  Reason.

check(slownik, {error, Description}) ->
  {reply, {error, Description}, slownik};
check(_, NowySlownik) ->
  {reply, ok, NowySlownik}.

crash() ->
  gen_server:cast(slownikSupOTP, crash).

stop() ->
  gen_server: cast(slownikSupOTP, stop).