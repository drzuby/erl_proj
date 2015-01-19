-module(test).

-export([test/0]).

test() ->
  %compile:file(slownik),
  %compile:file(slownikSupOTP),
  %compile:file(slownikSupervisorOTP),
  slownikSupervisorOTP:start_link(),
  io:format("nowy_slownik_ets:\n"),
  io:format("~w", [timer:tc(slownikSupOTP, nowy_slownik_ets, [])]),
  io:format("\n\n\n"),

  io:format("dodaj_tlumaczenie_ets:\n"),
  io:format("~w", [timer:tc(slownikSupOTP, dodaj_tlumaczenie_ets, ["ulewa", "storm"])]),
  io:format("\n\n\n"),

  io:format("dodaj_nowe_slowo_ets:\n"),
  io:format("~w", [timer:tc(slownikSupOTP, dodaj_nowe_slowo_ets, ["kot", "cat"])]),
  io:format("\n\n\n"),

  io:format("zmien_tlumaczenia_ets:\n"),
  io:format("~w", [timer:tc(slownikSupOTP, zmien_tlumaczenia_ets, ["ulewa", "nothing"])]),
  io:format("\n\n\n"),

  io:format("przetlumacz_na_angielski_ets:\n"),
  io:format("~w", [timer:tc(slownikSupOTP, przetlumacz_na_angielski_ets, ["ulewa"])]),
  io:format("\n\n\n"),

  io:format("toDETS:\n"),
  io:format("~w", [timer:tc(slownikSupOTP, toDETS, [])]),
  io:format("\n\n\n").