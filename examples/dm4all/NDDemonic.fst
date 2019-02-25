module NDDemonic

module List = FStar.List.Tot

let repr (a:Type) = list a

let return (a:Type u#a) (x:a) = [x]

let bind (a : Type u#aa) (b : Type u#bb)
    (l : repr a) (f : a -> repr b) = List.flatten (List.map f l)

(* let choose (#a : Type) (x y : a) : repr a = [x;y] *)

(* Demonic interpretation *)
let interp (#a:Type) (l : repr a) : pure_wp a =
    fun p -> forall (x:a). List.memP x l ==> p x

total
reifiable
reflectable
new_effect {
  ND : a:Type -> Effect
  with
       repr      = repr
     ; return    = return
     ; bind      = bind

     ; wp_type   = pure_wp
     ; return_wp = pure_return
     ; bind_wp   = pure_bind_wp

     ; interp    = interp

     (* ; choose    = choose *)
}

let test1 () : ND int (fun p -> p 5 /\ p 3) = 5
let test2 () : ND int (fun p -> p 5 /\ p 3) = 3

(* can't use test1 since its definition is transparent to SMT *)
assume val f : unit -> ND int (fun p -> p 5 /\ p 3)


let typeof #a (x:a) = a

let test_rel0 () = reify (f ())

let ty = typeof (test_rel0 ())

#set-options "--debug NDDemonic --debug_level SMTQuery"

let test_rel1 () : l:repr int{forall p. p 5 /\ p 3 ==> (forall x. List.memP x l ==> p x)} = reify (f ())


[@expect_failure]
let test_rel2 () : l:repr int{forall p. p 3 ==> (forall x. List.memP x l ==> p x)} = reify (f ())

[@expect_failure]
let test_rel3 () : l:repr int{forall p. p 5 ==> (forall x. List.memP x l ==> p x)} = reify (f ())

// Whoa! This used to succeed since the effect is marked as reifiable,
// and Rel compares the representation types on each side for the
// subtyping. and both are just `unit -> list a`. I changed it to check
// the WPs via stronger-than instead of always unfolding.
[@expect_failure]
let test3 () : ND int (fun p -> p 5 /\ p 3) = 4

effect Nd (a:Type) (pre:pure_pre) (post:pure_post' a pre) =
        ND a (fun (p:pure_post a) -> pre /\ (forall (pure_result:a). post pure_result ==> p pure_result))

effect NDTot (a:Type) = ND a (pure_null_wp a)

val choose : #a:Type0 -> x:a -> y:a -> ND a (fun p -> p x /\ p y)
let choose #a x y =
    ND?.reflect [x;y]

val fail : #a:Type0 -> unit -> ND a (fun p -> True)
let fail #a () =
    ND?.reflect []

let test () : ND int (fun p -> forall (x:int). 0 <= x /\ x < 10 ==> p x) =
    let x = choose 0 1 in
    let y = choose 2 3 in
    let z = choose 4 5 in
    x + y + z

[@expect_failure]
let test_bad () : ND int (fun p -> forall (x:int). 0 <= x /\ x < 5 ==> p x) =
    let x = choose 0 1 in
    let y = choose 2 3 in
    let z = choose 4 5 in
    x + y + z

let rec pick #a (l : list a) : ND a (fun p -> forall x. List.memP x l ==> p x) =
    match l with
    | [] -> fail ()
    | x::xs ->
      // choose x (pick xs)
      // ^ this is wrong! it will call `pick xs` before choosing and always
      //   end up returning []
      if choose true false
      then x
      else pick xs

let guard (b:bool) : ND unit (fun p -> b ==> p ()) =
  if b
  then ()
  else fail ()

let ( * ) = op_Multiply

let pyths () : ND (int & int & int) (fun p -> forall x y z. x*x + y*y == z*z ==> p (x,y,z)) =
  let l = [1;2;3;4;5;6;7;8;9;10] in
  let x = pick l in
  let y = pick l in
  let z = pick l in
  (* funny, using == here gives a terrible error message: "Could not prove-postcondition" *)
  guard (x*x + y*y = z*z);
  (x,y,z)

(* Check ND.ml for the triples:

let (pyths_norm : unit -> (Prims.int * Prims.int * Prims.int) Prims.list) =
  fun uu____1038  ->
    [((Prims.parse_int "3"), (Prims.parse_int "4"), (Prims.parse_int "5"));
    ((Prims.parse_int "4"), (Prims.parse_int "3"), (Prims.parse_int "5"));
    ((Prims.parse_int "6"), (Prims.parse_int "8"), (Prims.parse_int "10"));
    ((Prims.parse_int "8"), (Prims.parse_int "6"), (Prims.parse_int "10"))]
*)
let pyths_norm () = normalize_term (reify (pyths ()))

let test_reify_1 () = assert (reify (test1 ()) ==  [5])
let test_reify_2 () = assert (reify (test2 ()) ==  [3])
let test_reify_3 () = assert (reify (test1 ()) =!= [4])

[@expect_failure]
let _ = assert False
