(******************************************************************************)
(*                                                                            *)
(*                                   Menhir                                   *)
(*                                                                            *)
(*                       François Pottier, Inria Paris                        *)
(*              Yann Régis-Gianas, PPS, Université Paris Diderot              *)
(*                                                                            *)
(*  Copyright Inria. All rights reserved. This file is distributed under the  *)
(*  terms of the GNU General Public License version 2, as described in the    *)
(*  file LICENSE.                                                             *)
(*                                                                            *)
(******************************************************************************)

(* This signature describes several implementations of sets, including
   [Patricia], [AtomicBitSet], and [SparseBitSet]. *)

module type S = sig

  (* Elements are assumed to have a natural total order. *)

  type element

  (* Sets. *)

  type t

  (* The empty set. *)

  val empty: t

  (* [is_empty s] tells whether [s] is the empty set. *)

  val is_empty: t -> bool

  (* [singleton x] returns a singleton set containing [x] as its only
     element. *)

  val singleton: element -> t

  (* [is_singleton s] tests whether [s] is a singleton set. *)

  val is_singleton: t -> bool

  (* [cardinal s] returns the cardinal of [s]. *)

  val cardinal: t -> int

  (* [choose s] returns an arbitrarily chosen element of [s], if [s]
     is nonempty, and raises [Not_found] otherwise. *)

  val choose: t -> element

  (* [mem x s] returns [true] if and only if [x] appears in the set
     [s]. *)

  val mem: element -> t -> bool

  (* [add x s] returns a set whose elements are all elements of [s],
     plus [x]. *)

  val add: element -> t -> t

  (* [remove x s] returns a set whose elements are all elements of
     [s], except [x]. *)

  val remove: element -> t -> t

  (* [union s1 s2] returns the union of the sets [s1] and [s2]. *)

  val union: t -> t -> t

  (* [inter s t] returns the set intersection of [s] and [t], that is,
     $s\cap t$. *)

  val inter: t -> t -> t

  (* [disjoint s1 s2] returns [true] if and only if the sets [s1] and
     [s2] are disjoint, i.e. iff their intersection is empty. *)

  val disjoint: t -> t -> bool

  (* [iter f s] invokes [f x], in turn, for each element [x] of the
     set [s]. Elements are presented to [f] in increasing order. *)

  val iter: (element -> unit) -> t -> unit

  (* [fold f s seed] invokes [f x accu], in turn, for each element [x]
     of the set [s]. Elements are presented to [f] in increasing
     order. The initial value of [accu] is [seed]; then, at each new
     call, its value is the value returned by the previous invocation
     of [f]. The value returned by [fold] is the final value of
     [accu]. In other words, if $s = \{ x_1, x_2, \ldots, x_n \}$,
     where $x_1 < x_2 < \ldots < x_n$, then [fold f s seed] computes
     $([f]\,x_n\,\ldots\,([f]\,x_2\,([f]\,x_1\,[seed]))\ldots)$. *)

  val fold: (element -> 'b -> 'b) -> t -> 'b -> 'b

  (* [elements s] is a list of all elements in the set [s]. *)

  val elements: t -> element list

  (* [compare] is an ordering over sets. *)

  val compare: t -> t -> int

  (* [equal] implements equality over sets. *)

  val equal: t -> t -> bool

  (* [subset] implements the subset predicate over sets. *)

  val subset: t -> t -> bool

   (* [quick_subset s1 s2] is a fast test for the set inclusion [s1 ⊆ s2].

      The sets [s1] and [s2] must be nonempty.

      It must be known ahead of time that either [s1] is a subset of [s2] or
      these sets are disjoint: that is, [s1 ⊆ s2 ⋁ s1 ∩ s2 = ∅] must hold.

      Under this hypothesis, [quick_subset s1 s2] can be implemented simply
      by picking an arbitrary element of [s1] (if there is one) and testing
      whether it is a member of [s2]. *)
   val quick_subset: t -> t -> bool

   (** {1 Decomposing sets}

       The following functions implement the signature [Refine.DECOMPOSABLE].
       We cannot refer to this signature here because [Refine] is implemented
       using bitsets; that would create a reference cycle. *)

   val compare_minimum : t -> t -> int
   val extract_unique_prefix : t -> t -> t * t
   val extract_shared_prefix : t -> t -> t * (t * t)
   val interval_union : t list -> t
end
