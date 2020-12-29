type dyn = Num of int | Str of string

type promise = Pending | Resolved of dyn | Rejected of dyn

let promisify : promise ref = ref Pending 

let resolve (p: promise ref) (e: dyn): promise ref =
  match !p with 
    Pending -> ref (Resolved e)
  | _ -> p 
;;

let reject (p: promise ref) (e: dyn): promise ref =
  match !p with 
    Pending -> ref (Rejected e)
  | _ -> p 
;;

let rec waitToBeResolved (p: promise ref) :  promise ref =
  match !p with 
    Resolved _ -> p 
  | _ -> waitToBeResolved p 
;;

let rec waitToBeRejected (p: promise ref) :  promise ref =
  match !p with 
    Rejected _ -> p 
  | _ -> waitToBeRejected p 
;;

let rec onResolve (p_pre: promise ref) (p_post: promise ref) (f: dyn -> dyn): promise ref =
  let p_pre' = waitToBeResolved p_pre in 
  match !p_pre' with 
  | Resolved e -> ref (Resolved (f e)) 
  | _ -> ref Pending 
;;

let rec onReject (p_pre: promise ref) (p_post: promise ref) (f: dyn -> dyn): promise ref =
  let p_pre' = waitToBeRejected p_pre in 
  match !p_pre' with 
  | Rejected e -> ref (Resolved (f e)) 
  | _ -> ref Pending 
;;

let link (p_pre: promise ref) (p_post: promise ref) : promise ref =
  p_post := !p_pre;
  p_post
  ;;

let id a = a ;;

let _then (p: promise ref) (f_resolve: dyn -> dyn) (f_reject: dyn -> dyn) : promise ref =
  p
  ;;

let _catch (p: promise ref) (f_reject: dyn -> dyn) = _then p id f_reject ;;


let main = print_string ("song yahui");