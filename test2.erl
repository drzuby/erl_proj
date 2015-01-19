-module(test2).

-export([test/0]).

test() ->
  %compile:file(slownik),
  %compile:file(slownikSupOTP),
  %compile:file(slownikSupervisorOTP),
  slownikSupervisorOTP:start_link(),
  io:format("nowy_slownik:\n"),
  io:format("~w", [timer:tc(slownikSupOTP, nowy_slownik, [])]),
  io:format("\n\n\n"),

  io:format("dodaj_tlumaczenie:\n"),
  io:format("~w", [timer:tc(slownikSupOTP, dodaj_tlumaczenie, ["ulewa", "storm"])]),
  io:format("\n\n\n"),

  io:format("dodaj_nowe_slowo:\n"),
  io:format("~w", [timer:tc(slownikSupOTP, dodaj_nowe_slowo, ["kot", "cat"])]),
  io:format("\n\n\n"),

  io:format("zmien_tlumaczenia:\n"),
  io:format("~w", [timer:tc(slownikSupOTP, zmien_tlumaczenia, ["ulewa", "nothing"])]),
  io:format("\n\n\n"),

  io:format("przetlumacz_na_angielski:\n"),
  io:format("~w", [timer:tc(slownikSupOTP, przetlumacz_na_angielski_ets, ["kot"])]),
  io:format("\n\n\n").