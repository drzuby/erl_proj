-module(test).

-export([test/0]).

test() ->
  %compile:file(slownik),
  %compile:file(slownikSupOTP),
  %compile:file(slownikSupervisorOTP),
  slownikSupervisorOTP:start_link(),
  io:format("\nnowy_slownik_ets:\n"),
  io:format("~w\n\n", [timer:tc(slownikSupOTP, nowy_slownik_ets, [])]),

  io:format("dodaj_tlumaczenie_ets:\n"),
  io:format("~w\n\n", [timer:tc(slownikSupOTP, dodaj_tlumaczenie_ets, ["ulewa", "storm"])]),

  io:format("dodaj_nowe_slowo_ets:\n"),
  io:format("~w\n\n", [timer:tc(slownikSupOTP, dodaj_nowe_slowo_ets, ["kot", "cat"])]),

  io:format("zmien_tlumaczenia_ets:\n"),
  io:format("~w\n\n", [timer:tc(slownikSupOTP, zmien_tlumaczenia_ets, ["ulewa", "nothing"])]),

  io:format("przetlumacz_na_angielski_ets:\n"),
  io:format("~w\n\n", [timer:tc(slownikSupOTP, przetlumacz_na_angielski_ets, ["kot"])]),

  io:format("toDETS:\n"),
  io:format("~w\n\n", [timer:tc(slownikSupOTP, toDETS, [])]).