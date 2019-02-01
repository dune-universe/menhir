(* This grammar was accepted by Menhir prior to 2019/02/01,
   even though its expansion does not terminate.

   This problem has been reported by Stéphane Lescuyer.

   See https://gitlab.inria.fr/fpottier/menhir/issues/4

*)

%token A
%start<unit> start
%%

start:
 seq(A) {}

(* If wrap does not use its argument, we shall not complain. *)
wrap(t):
 A {}

seq(t):
| wrap(seq(wrap(t))) {}
