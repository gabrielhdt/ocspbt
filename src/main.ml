let () =
  let module Queenbt = Backtrack.Make(Queenspb) in
  let final_inst = Queenbt.bt Queenspb.vars Queenspb.empty in
  Queenspb.print final_inst
  (*
  let module Sudokubt = Backtrack.Make(Sudoku) in
  let final_inst = Sudokubt.bt Sudoku.vars Sudoku.empty in
  Sudoku.print final_inst
     *)
