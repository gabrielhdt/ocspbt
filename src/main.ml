let () =
  (*
  let module Queenbt = Backtrack.Make(Queenspb) in
  let init_inst = Queenspb.Inst.empty in
  if Queenspb.Inst.consistent init_inst = Queenspb.Inst.empty then
    begin
      let final_inst = Queenbt.cbj Queenspb.Var.init init_inst in
      Queenspb.Inst.print final_inst ;
    end
  else
    begin
      failwith "initial problem not consistent"
    end
    *)
  let module Sudokubt = Backtrack.Make(Sudoku) in
  let fi, nv = Sudoku.load Sys.argv.(1) in
  if Sudoku.Inst.consistent fi = Sudoku.Inst.empty then
    begin
      Sudoku.Inst.print fi ;
      let final_inst = Sudokubt.bt nv fi in
      Sudoku.Inst.print final_inst
    end
      else
        begin
          Sudoku.Inst.print fi ;
          failwith "initial problem not consistent"
        end
