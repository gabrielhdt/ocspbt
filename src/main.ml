let () =
  let module Queenbt = Backtrack.Make(Queenspb) in
  let final_inst = Queenbt.bt Queenspb.vars (Some Queenspb.empty) in
  match final_inst
  with None -> Printf.printf "Err...\n"
     | Some i -> Queenspb.print i
