let () =
  (*
  let module Queenbt = Backtrack.Make(Queenspb) in
  let final_inst = Queenbt.bt Queenspb.vars Queenspb.empty in
  Queenspb.print final_inst
     *)
  let module Sudokubt = Backtrack.Make(Sudoku) in
  let fi, nv = Sudoku.load "data/sudoku1.json" in
  if Sudoku.consistent fi then
    begin
      Sudoku.print fi ;
      let final_inst = Sudokubt.bt nv fi in
      Sudoku.print final_inst
    end
  else failwith "initial problem not consistent"
