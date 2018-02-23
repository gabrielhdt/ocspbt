let () =
  (*
  let module Queenbt = Backtrack.Make(Queenspb) in
  let final_inst = Queenbt.bt Queenspb.Var.init Queenspb.Inst.empty in
  Queenspb.Inst.print final_inst ;
  let inst_cbj = Queenbt.cbj Queenspb.Var.init Queenspb.Inst.empty in
  Queenspb.Inst.print inst_cbj
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
