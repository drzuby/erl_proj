-module(slownikSupervisorOTP).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
  supervisor:start_link({local, slownikSupervisorOTP}, ?MODULE, []).

init(_) ->
  {ok, {{one_for_all, 2, 2000}, [{slownikSupOTP, {slownikSupOTP, start_link, []}, permanent, brutal_kill, worker, [slownikSupOTP]}]}}.