(* Input-output utilities. *)

(* [try/finally] *)

val try_finally : (unit -> 'a) -> (unit -> unit) -> 'a

(* [exhaust channel] reads all of the data that's available on [channel].
   It does not assume that the length of the data is known ahead of time.
   It does not close the channel. *)

val exhaust: in_channel -> string

(* [invoke command] invokes an external command (which expects no input)
   and returns its output, if the command succeeds. It returns [None] if
   the command fails. *)

val invoke: string -> string option

(* [winvoke writers command cleaners] invokes each of the [writer]
   functions, invokes the command [command], and runs each of the
   [cleaner] functions. Then, it either returns the command's output,
   if the command succeeded, or exits, otherwise. *)

val winvoke: (unit -> unit) list -> string -> (unit -> unit) list -> string

