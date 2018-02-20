let () =
  (*
  let module Queenbt = Backtrack.Make(Queenspb) in
  let final_inst = Queenbt.bt Queenspb.vars (Some Queenspb.empty) in
  match final_inst
  with None -> Printf.printf "Err...\n"
     | Some i -> Queenspb.print i
     *)
  let module Sudokubt = Backtrack.Make(Sudoku) in
  let final_inst = Sudokubt.bt Sudoku.vars (Some Sudoku.empty) in
  match final_inst
  with None -> Printf.printf "error\n"
     | Some i -> Sudoku.print i
