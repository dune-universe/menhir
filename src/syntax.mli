(* Terminals and nonterminal symbols are strings. Identifiers
   (which are used to refer to a symbol's semantic value) are
   strings. A file name is a string. *)

type terminal =
    string

type nonterminal =
    string 

type symbol =
    string 

type identifier = 
    string 

type filename = 
    string

(* A trailer is a source file fragment. *)

type trailer =
    Stretch.t

(* Objective Caml semantic actions are represented as stretches. *)

type action =
    Action.t

type token_associativity = 
    LeftAssoc 
  | RightAssoc
  | NonAssoc
  | UndefinedAssoc

type precedence_level = 
    UndefinedPrecedence 

  (* Items are incomparable when they originate in different files. A
     brand of type [Mark.t] is used to record an item's origin. The
     positions allow locating certain warnings. *)

  | PrecedenceLevel of Mark.t * int * Lexing.position * Lexing.position
                                    
type token_properties =
    {
	       tk_filename      : filename;
	       tk_ocamltype     : Stretch.ocamltype option;
	       tk_position	: Positions.t;
      mutable  tk_associativity : token_associativity;
      mutable  tk_priority      : precedence_level; (* TEMPORARY terminologie toujours pas coherente *)
      mutable  tk_is_declared   : bool; 
    }

type parameter = 
  | ParameterVar of symbol Positions.located
  | ParameterApp of symbol Positions.located * parameters

and parameters = 
    parameter list

type declaration =

    (* Raw Objective Caml code. *)

  | DCode of Stretch.t

    (* Raw Objective Caml functor parameter. *)

  | DParameter of Stretch.ocamltype (* really a stretch *)

    (* Terminal symbol (token) declaration. *)

  | DToken of Stretch.ocamltype option * terminal

    (* Start symbol declaration. *)

  | DStart of nonterminal 

    (* Priority and associativity declaration. *)

  | DTokenProperties of terminal * token_associativity * precedence_level

    (* Type declaration. *)

  | DType of Stretch.ocamltype * parameter

(* A [%prec] annotation is optional. A production can carry at most one.
   If there is one, it is a symbol name. *)

type branch_prec_annotation =
    symbol Positions.located option

type branch_reduce_precedence =
    precedence_level

type producer =
    identifier Positions.located * parameter

type parameterized_branch =
    { 
      pr_branch_position	   : Positions.t;
      pr_producers		   : producer list;
      pr_action			   : action; 
      pr_branch_prec_annotation    : branch_prec_annotation;
      pr_branch_reduce_precedence  : branch_reduce_precedence
    }

type parameterized_rule =
    {
      pr_public_flag	   : bool;
      pr_inline_flag	   : bool;
      pr_nt		   : nonterminal;
      pr_positions	   : Positions.t list;
      pr_parameters	   : symbol list;
      pr_branches	   : parameterized_branch list;
    }

