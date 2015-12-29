%% -------------------------------------------------------------------
%% Copyright (c) 2015 Mark deVilliers.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-module (nif_executor).

-include_lib("mesos_pb.hrl").

-export ([  init/1,
            start/0,
            join/0,
            abort/0,
            stop/0,
            sendFrameworkMessage/1,
            sendStatusUpdate/1,
            destroy/0]).

-on_load(init/0).

-define(APPNAME, erlang_mesos).
-define(LIBNAME, executor).

init(Pid) when is_pid(Pid) ->
    io:format("nif_executor:init(~p)~n", [Pid]),
    nif_executor_init(Pid).

start() ->
    io:format("nif_executor:start()~n", []),
    nif_executor_start().

join() ->
    io:format("nif_executor:join()~n", []),
    nif_executor_join().

abort() ->
    io:format("nif_executor:abort()~n", []),
    nif_executor_abort().

stop() ->
    io:format("nif_executor:stop()~n", []),
    nif_executor_stop().

sendFrameworkMessage(Data) when is_list(Data)->
    io:format("nif_executor:sendFrameworkMessage(~p)~n", [Data]),
    nif_executor_sendFrameworkMessage(Data).

sendStatusUpdate(TaskStatus) when is_record(TaskStatus, 'TaskStatus') ->
    io:format("nif_executor:sendStatusUpdate(~p)~n", [TaskStatus]),
    nif_executor_sendStatusUpdate(mesos_pb:encode_msg(TaskStatus)).

destroy() ->
    io:format("nif_executor:destroy()~n", []),
    nif_executor_destroy().

% nif functions

nif_executor_init(_)->
    not_loaded(?LINE).
nif_executor_start() ->
    not_loaded(?LINE).
nif_executor_join() ->
    not_loaded(?LINE).
nif_executor_abort() ->
    not_loaded(?LINE).
nif_executor_stop() ->
    not_loaded(?LINE).
nif_executor_sendFrameworkMessage(_)->
    not_loaded(?LINE).
nif_executor_sendStatusUpdate(_) ->
    not_loaded(?LINE).
nif_executor_destroy() ->
	not_loaded(?LINE).
	
init() ->
    SoName = case code:priv_dir(?APPNAME) of
        {error, bad_name} ->
            case filelib:is_dir(filename:join(["..", priv])) of
                true ->
                    filename:join(["..", priv, ?LIBNAME]);
                _ ->
                    filename:join([priv, ?LIBNAME])
            end;
        Dir ->
            filename:join(Dir, ?LIBNAME)
    end,
    Ret = erlang:load_nif(SoName, 0),
    io:format("Loaded executor nif [~p]~n", [Ret]),
    Ret.

not_loaded(Line) ->
    exit({not_loaded, [{module, ?MODULE}, {line, Line}]}).
