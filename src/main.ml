let () =
  (*
  let module Queenbt = Backtrack.Make(Queenspb) in
  let final_inst = Queenbt.bt Queenspb.vars Queenspb.empty in
  Queenspb.print final_inst
     *)
  let module Sudokubt = Backtrack.Make(Sudoku) in
  let fi, nv = Sudoku.load Sys.argv.(1) in
  if Sudoku.consistent fi then
    begin
      Sudoku.print fi ;
      let final_inst = Sudokubt.bt nv fi in
      Sudoku.print final_inst
    end
      else
        begin
          Sudoku.print fi ;
          failwith "initial problem not consistent"
        end
