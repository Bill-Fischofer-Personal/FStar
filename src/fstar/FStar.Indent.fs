#light "off"
module FStar.Indent
open FStar.ST
open FStar.All

open FStar.Util
open FStar.Parser.ToDocument

module D = FStar.Parser.Driver
module P = FStar.Pprint

type printing_mode =
  | ToTempFile
  | FromTempToStdout
  | FromTempToFile

let temp_file_name f = format1 "%s.indent_.fst" f

let generate (m: printing_mode) filenames =
    let parse_and_indent (m: printing_mode) filename =
        let inf, outf =
          match m with
          | ToTempFile -> filename, Some (open_file_for_writing (temp_file_name filename))
          | FromTempToFile -> (temp_file_name filename), Some (open_file_for_writing filename)
          | FromTempToStdout -> (temp_file_name filename), None
        in
        let modul, comments = D.parse_file inf in
        let leftover_comments =
            let comments = List.rev comments in
            let doc, comments = modul_with_comments_to_document modul comments in
                            (* TODO : some problem with the F# generated floats *)
            (match outf with
             | Some f -> append_to_file f <| P.pretty_string (float_of_string "1.0") 100 doc
             | None -> P.pretty_out_channel (float_of_string "1.0") 100 doc stdout);
            comments
        in
        if not (FStar.List.isEmpty leftover_comments) then
          (* TODO : We could setup the leftover comments a little more nicely *)
          let left_over_doc =
             P.concat  [P.hardline ; P.hardline ; comments_to_document leftover_comments]
          in
          match outf with
          | Some f -> append_to_file f <| P.pretty_string (float_of_string "1.0") 100 left_over_doc
          | None -> P.pretty_out_channel (float_of_string "1.0") 100 left_over_doc stdout
    in
    List.iter (parse_and_indent m) filenames;
    match m with
    | FromTempToFile
    | FromTempToStdout -> List.iter (fun f -> delete_file (temp_file_name f)) filenames
    | ToTempFile -> ()
