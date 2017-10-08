open Prims
let qual_id: FStar_Ident.lident -> FStar_Ident.ident -> FStar_Ident.lident =
  fun lid  ->
    fun id  ->
      let uu____9 =
        FStar_Ident.lid_of_ids
          (FStar_List.append lid.FStar_Ident.ns [lid.FStar_Ident.ident; id]) in
      FStar_Ident.set_lid_range uu____9 id.FStar_Ident.idRange
let mk_discriminator: FStar_Ident.lident -> FStar_Ident.lident =
  fun lid  ->
    FStar_Ident.lid_of_ids
      (FStar_List.append lid.FStar_Ident.ns
         [FStar_Ident.mk_ident
            ((Prims.strcat FStar_Ident.reserved_prefix
                (Prims.strcat "is_"
                   (lid.FStar_Ident.ident).FStar_Ident.idText)),
              ((lid.FStar_Ident.ident).FStar_Ident.idRange))])
let is_name: FStar_Ident.lident -> Prims.bool =
  fun lid  ->
    let c =
      FStar_Util.char_at (lid.FStar_Ident.ident).FStar_Ident.idText
        (Prims.parse_int "0") in
    FStar_Util.is_upper c
let arg_of_non_null_binder:
  'Auu____23 .
    (FStar_Syntax_Syntax.bv,'Auu____23) FStar_Pervasives_Native.tuple2 ->
      (FStar_Syntax_Syntax.term,'Auu____23) FStar_Pervasives_Native.tuple2
  =
  fun uu____35  ->
    match uu____35 with
    | (b,imp) ->
        let uu____42 = FStar_Syntax_Syntax.bv_to_name b in (uu____42, imp)
let args_of_non_null_binders:
  FStar_Syntax_Syntax.binders ->
    (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.aqual)
      FStar_Pervasives_Native.tuple2 Prims.list
  =
  fun binders  ->
    FStar_All.pipe_right binders
      (FStar_List.collect
         (fun b  ->
            let uu____66 = FStar_Syntax_Syntax.is_null_binder b in
            if uu____66
            then []
            else (let uu____78 = arg_of_non_null_binder b in [uu____78])))
let args_of_binders:
  FStar_Syntax_Syntax.binders ->
    (FStar_Syntax_Syntax.binders,FStar_Syntax_Syntax.args)
      FStar_Pervasives_Native.tuple2
  =
  fun binders  ->
    let uu____103 =
      FStar_All.pipe_right binders
        (FStar_List.map
           (fun b  ->
              let uu____149 = FStar_Syntax_Syntax.is_null_binder b in
              if uu____149
              then
                let b1 =
                  let uu____167 =
                    FStar_Syntax_Syntax.new_bv FStar_Pervasives_Native.None
                      (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort in
                  (uu____167, (FStar_Pervasives_Native.snd b)) in
                let uu____168 = arg_of_non_null_binder b1 in (b1, uu____168)
              else
                (let uu____182 = arg_of_non_null_binder b in (b, uu____182)))) in
    FStar_All.pipe_right uu____103 FStar_List.unzip
let name_binders:
  FStar_Syntax_Syntax.binder Prims.list ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
      FStar_Pervasives_Native.tuple2 Prims.list
  =
  fun binders  ->
    FStar_All.pipe_right binders
      (FStar_List.mapi
         (fun i  ->
            fun b  ->
              let uu____265 = FStar_Syntax_Syntax.is_null_binder b in
              if uu____265
              then
                let uu____270 = b in
                match uu____270 with
                | (a,imp) ->
                    let b1 =
                      let uu____278 =
                        let uu____279 = FStar_Util.string_of_int i in
                        Prims.strcat "_" uu____279 in
                      FStar_Ident.id_of_text uu____278 in
                    let b2 =
                      {
                        FStar_Syntax_Syntax.ppname = b1;
                        FStar_Syntax_Syntax.index = (Prims.parse_int "0");
                        FStar_Syntax_Syntax.sort =
                          (a.FStar_Syntax_Syntax.sort)
                      } in
                    (b2, imp)
              else b))
let name_function_binders:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun t  ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_arrow (binders,comp) ->
        let uu____312 =
          let uu____315 =
            let uu____316 =
              let uu____329 = name_binders binders in (uu____329, comp) in
            FStar_Syntax_Syntax.Tm_arrow uu____316 in
          FStar_Syntax_Syntax.mk uu____315 in
        uu____312 FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
    | uu____347 -> t
let null_binders_of_tks:
  (FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.aqual)
    FStar_Pervasives_Native.tuple2 Prims.list -> FStar_Syntax_Syntax.binders
  =
  fun tks  ->
    FStar_All.pipe_right tks
      (FStar_List.map
         (fun uu____388  ->
            match uu____388 with
            | (t,imp) ->
                let uu____399 =
                  let uu____400 = FStar_Syntax_Syntax.null_binder t in
                  FStar_All.pipe_left FStar_Pervasives_Native.fst uu____400 in
                (uu____399, imp)))
let binders_of_tks:
  (FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.aqual)
    FStar_Pervasives_Native.tuple2 Prims.list -> FStar_Syntax_Syntax.binders
  =
  fun tks  ->
    FStar_All.pipe_right tks
      (FStar_List.map
         (fun uu____451  ->
            match uu____451 with
            | (t,imp) ->
                let uu____468 =
                  FStar_Syntax_Syntax.new_bv
                    (FStar_Pervasives_Native.Some (t.FStar_Syntax_Syntax.pos))
                    t in
                (uu____468, imp)))
let binders_of_freevars:
  FStar_Syntax_Syntax.bv FStar_Util.set ->
    FStar_Syntax_Syntax.binder Prims.list
  =
  fun fvs  ->
    let uu____479 = FStar_Util.set_elements fvs in
    FStar_All.pipe_right uu____479
      (FStar_List.map FStar_Syntax_Syntax.mk_binder)
let mk_subst: 'Auu____490 . 'Auu____490 -> 'Auu____490 Prims.list =
  fun s  -> [s]
let subst_of_list:
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.args -> FStar_Syntax_Syntax.subst_t
  =
  fun formals  ->
    fun actuals  ->
      if (FStar_List.length formals) = (FStar_List.length actuals)
      then
        FStar_List.fold_right2
          (fun f  ->
             fun a  ->
               fun out  ->
                 (FStar_Syntax_Syntax.NT
                    ((FStar_Pervasives_Native.fst f),
                      (FStar_Pervasives_Native.fst a)))
                 :: out) formals actuals []
      else failwith "Ill-formed substitution"
let rename_binders:
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.binders -> FStar_Syntax_Syntax.subst_t
  =
  fun replace_xs  ->
    fun with_ys  ->
      if (FStar_List.length replace_xs) = (FStar_List.length with_ys)
      then
        FStar_List.map2
          (fun uu____581  ->
             fun uu____582  ->
               match (uu____581, uu____582) with
               | ((x,uu____600),(y,uu____602)) ->
                   let uu____611 =
                     let uu____618 = FStar_Syntax_Syntax.bv_to_name y in
                     (x, uu____618) in
                   FStar_Syntax_Syntax.NT uu____611) replace_xs with_ys
      else failwith "Ill-formed substitution"
let rec unmeta: FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term =
  fun e  ->
    let e1 = FStar_Syntax_Subst.compress e in
    match e1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_meta (e2,uu____626) -> unmeta e2
    | FStar_Syntax_Syntax.Tm_ascribed (e2,uu____632,uu____633) -> unmeta e2
    | uu____674 -> e1
let rec unmeta_safe: FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term =
  fun e  ->
    let e1 = FStar_Syntax_Subst.compress e in
    match e1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_meta (e',m) ->
        (match m with
         | FStar_Syntax_Syntax.Meta_monadic uu____686 -> e1
         | FStar_Syntax_Syntax.Meta_monadic_lift uu____693 -> e1
         | uu____702 -> unmeta_safe e')
    | FStar_Syntax_Syntax.Tm_ascribed (e2,uu____704,uu____705) ->
        unmeta_safe e2
    | uu____746 -> e1
let rec univ_kernel:
  FStar_Syntax_Syntax.universe ->
    (FStar_Syntax_Syntax.universe,Prims.int) FStar_Pervasives_Native.tuple2
  =
  fun u  ->
    match u with
    | FStar_Syntax_Syntax.U_unknown  -> (u, (Prims.parse_int "0"))
    | FStar_Syntax_Syntax.U_name uu____759 -> (u, (Prims.parse_int "0"))
    | FStar_Syntax_Syntax.U_unif uu____760 -> (u, (Prims.parse_int "0"))
    | FStar_Syntax_Syntax.U_zero  -> (u, (Prims.parse_int "0"))
    | FStar_Syntax_Syntax.U_succ u1 ->
        let uu____770 = univ_kernel u1 in
        (match uu____770 with | (k,n1) -> (k, (n1 + (Prims.parse_int "1"))))
    | FStar_Syntax_Syntax.U_max uu____781 ->
        failwith "Imposible: univ_kernel (U_max _)"
    | FStar_Syntax_Syntax.U_bvar uu____788 ->
        failwith "Imposible: univ_kernel (U_bvar _)"
let constant_univ_as_nat: FStar_Syntax_Syntax.universe -> Prims.int =
  fun u  ->
    let uu____797 = univ_kernel u in FStar_Pervasives_Native.snd uu____797
let rec compare_univs:
  FStar_Syntax_Syntax.universe -> FStar_Syntax_Syntax.universe -> Prims.int =
  fun u1  ->
    fun u2  ->
      match (u1, u2) with
      | (FStar_Syntax_Syntax.U_bvar uu____810,uu____811) ->
          failwith "Impossible: compare_univs"
      | (uu____812,FStar_Syntax_Syntax.U_bvar uu____813) ->
          failwith "Impossible: compare_univs"
      | (FStar_Syntax_Syntax.U_unknown ,FStar_Syntax_Syntax.U_unknown ) ->
          Prims.parse_int "0"
      | (FStar_Syntax_Syntax.U_unknown ,uu____814) -> - (Prims.parse_int "1")
      | (uu____815,FStar_Syntax_Syntax.U_unknown ) -> Prims.parse_int "1"
      | (FStar_Syntax_Syntax.U_zero ,FStar_Syntax_Syntax.U_zero ) ->
          Prims.parse_int "0"
      | (FStar_Syntax_Syntax.U_zero ,uu____816) -> - (Prims.parse_int "1")
      | (uu____817,FStar_Syntax_Syntax.U_zero ) -> Prims.parse_int "1"
      | (FStar_Syntax_Syntax.U_name u11,FStar_Syntax_Syntax.U_name u21) ->
          FStar_String.compare u11.FStar_Ident.idText u21.FStar_Ident.idText
      | (FStar_Syntax_Syntax.U_name uu____820,FStar_Syntax_Syntax.U_unif
         uu____821) -> - (Prims.parse_int "1")
      | (FStar_Syntax_Syntax.U_unif uu____830,FStar_Syntax_Syntax.U_name
         uu____831) -> Prims.parse_int "1"
      | (FStar_Syntax_Syntax.U_unif u11,FStar_Syntax_Syntax.U_unif u21) ->
          let uu____858 = FStar_Syntax_Unionfind.univ_uvar_id u11 in
          let uu____859 = FStar_Syntax_Unionfind.univ_uvar_id u21 in
          uu____858 - uu____859
      | (FStar_Syntax_Syntax.U_max us1,FStar_Syntax_Syntax.U_max us2) ->
          let n1 = FStar_List.length us1 in
          let n2 = FStar_List.length us2 in
          if n1 <> n2
          then n1 - n2
          else
            (let copt =
               let uu____890 = FStar_List.zip us1 us2 in
               FStar_Util.find_map uu____890
                 (fun uu____905  ->
                    match uu____905 with
                    | (u11,u21) ->
                        let c = compare_univs u11 u21 in
                        if c <> (Prims.parse_int "0")
                        then FStar_Pervasives_Native.Some c
                        else FStar_Pervasives_Native.None) in
             match copt with
             | FStar_Pervasives_Native.None  -> Prims.parse_int "0"
             | FStar_Pervasives_Native.Some c -> c)
      | (FStar_Syntax_Syntax.U_max uu____919,uu____920) ->
          - (Prims.parse_int "1")
      | (uu____923,FStar_Syntax_Syntax.U_max uu____924) ->
          Prims.parse_int "1"
      | uu____927 ->
          let uu____932 = univ_kernel u1 in
          (match uu____932 with
           | (k1,n1) ->
               let uu____939 = univ_kernel u2 in
               (match uu____939 with
                | (k2,n2) ->
                    let r = compare_univs k1 k2 in
                    if r = (Prims.parse_int "0") then n1 - n2 else r))
let eq_univs:
  FStar_Syntax_Syntax.universe -> FStar_Syntax_Syntax.universe -> Prims.bool
  =
  fun u1  ->
    fun u2  ->
      let uu____956 = compare_univs u1 u2 in
      uu____956 = (Prims.parse_int "0")
let ml_comp:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Range.range -> FStar_Syntax_Syntax.comp
  =
  fun t  ->
    fun r  ->
      FStar_Syntax_Syntax.mk_Comp
        {
          FStar_Syntax_Syntax.comp_univs = [FStar_Syntax_Syntax.U_zero];
          FStar_Syntax_Syntax.effect_name =
            (FStar_Ident.set_lid_range FStar_Parser_Const.effect_ML_lid r);
          FStar_Syntax_Syntax.result_typ = t;
          FStar_Syntax_Syntax.effect_args = [];
          FStar_Syntax_Syntax.flags = [FStar_Syntax_Syntax.MLEFFECT]
        }
let comp_effect_name:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> FStar_Ident.lident
  =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 -> c1.FStar_Syntax_Syntax.effect_name
    | FStar_Syntax_Syntax.Total uu____984 ->
        FStar_Parser_Const.effect_Tot_lid
    | FStar_Syntax_Syntax.GTotal uu____993 ->
        FStar_Parser_Const.effect_GTot_lid
let comp_flags:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.cflags Prims.list
  =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total uu____1014 -> [FStar_Syntax_Syntax.TOTAL]
    | FStar_Syntax_Syntax.GTotal uu____1023 ->
        [FStar_Syntax_Syntax.SOMETRIVIAL]
    | FStar_Syntax_Syntax.Comp ct -> ct.FStar_Syntax_Syntax.flags
let comp_set_flags:
  FStar_Syntax_Syntax.comp ->
    FStar_Syntax_Syntax.cflags Prims.list ->
      FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax
  =
  fun c  ->
    fun f  ->
      let comp_to_comp_typ c1 =
        match c1.FStar_Syntax_Syntax.n with
        | FStar_Syntax_Syntax.Comp c2 -> c2
        | FStar_Syntax_Syntax.Total (t,u_opt) ->
            let uu____1062 =
              let uu____1063 = FStar_Util.map_opt u_opt (fun x  -> [x]) in
              FStar_Util.dflt [] uu____1063 in
            {
              FStar_Syntax_Syntax.comp_univs = uu____1062;
              FStar_Syntax_Syntax.effect_name = (comp_effect_name c1);
              FStar_Syntax_Syntax.result_typ = t;
              FStar_Syntax_Syntax.effect_args = [];
              FStar_Syntax_Syntax.flags = (comp_flags c1)
            }
        | FStar_Syntax_Syntax.GTotal (t,u_opt) ->
            let uu____1090 =
              let uu____1091 = FStar_Util.map_opt u_opt (fun x  -> [x]) in
              FStar_Util.dflt [] uu____1091 in
            {
              FStar_Syntax_Syntax.comp_univs = uu____1090;
              FStar_Syntax_Syntax.effect_name = (comp_effect_name c1);
              FStar_Syntax_Syntax.result_typ = t;
              FStar_Syntax_Syntax.effect_args = [];
              FStar_Syntax_Syntax.flags = (comp_flags c1)
            } in
      let uu___169_1108 = c in
      let uu____1109 =
        let uu____1110 =
          let uu___170_1111 = comp_to_comp_typ c in
          {
            FStar_Syntax_Syntax.comp_univs =
              (uu___170_1111.FStar_Syntax_Syntax.comp_univs);
            FStar_Syntax_Syntax.effect_name =
              (uu___170_1111.FStar_Syntax_Syntax.effect_name);
            FStar_Syntax_Syntax.result_typ =
              (uu___170_1111.FStar_Syntax_Syntax.result_typ);
            FStar_Syntax_Syntax.effect_args =
              (uu___170_1111.FStar_Syntax_Syntax.effect_args);
            FStar_Syntax_Syntax.flags = f
          } in
        FStar_Syntax_Syntax.Comp uu____1110 in
      {
        FStar_Syntax_Syntax.n = uu____1109;
        FStar_Syntax_Syntax.pos = (uu___169_1108.FStar_Syntax_Syntax.pos);
        FStar_Syntax_Syntax.vars = (uu___169_1108.FStar_Syntax_Syntax.vars)
      }
let comp_to_comp_typ:
  FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.comp_typ =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 -> c1
    | FStar_Syntax_Syntax.Total (t,FStar_Pervasives_Native.Some u) ->
        {
          FStar_Syntax_Syntax.comp_univs = [u];
          FStar_Syntax_Syntax.effect_name = (comp_effect_name c);
          FStar_Syntax_Syntax.result_typ = t;
          FStar_Syntax_Syntax.effect_args = [];
          FStar_Syntax_Syntax.flags = (comp_flags c)
        }
    | FStar_Syntax_Syntax.GTotal (t,FStar_Pervasives_Native.Some u) ->
        {
          FStar_Syntax_Syntax.comp_univs = [u];
          FStar_Syntax_Syntax.effect_name = (comp_effect_name c);
          FStar_Syntax_Syntax.result_typ = t;
          FStar_Syntax_Syntax.effect_args = [];
          FStar_Syntax_Syntax.flags = (comp_flags c)
        }
    | uu____1145 ->
        failwith "Assertion failed: Computation type without universe"
let is_named_tot:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 ->
        FStar_Ident.lid_equals c1.FStar_Syntax_Syntax.effect_name
          FStar_Parser_Const.effect_Tot_lid
    | FStar_Syntax_Syntax.Total uu____1155 -> true
    | FStar_Syntax_Syntax.GTotal uu____1164 -> false
let is_total_comp:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool =
  fun c  ->
    (FStar_Ident.lid_equals (comp_effect_name c)
       FStar_Parser_Const.effect_Tot_lid)
      ||
      (FStar_All.pipe_right (comp_flags c)
         (FStar_Util.for_some
            (fun uu___157_1184  ->
               match uu___157_1184 with
               | FStar_Syntax_Syntax.TOTAL  -> true
               | FStar_Syntax_Syntax.RETURN  -> true
               | uu____1185 -> false)))
let is_total_lcomp: FStar_Syntax_Syntax.lcomp -> Prims.bool =
  fun c  ->
    (FStar_Ident.lid_equals c.FStar_Syntax_Syntax.eff_name
       FStar_Parser_Const.effect_Tot_lid)
      ||
      (FStar_All.pipe_right c.FStar_Syntax_Syntax.cflags
         (FStar_Util.for_some
            (fun uu___158_1193  ->
               match uu___158_1193 with
               | FStar_Syntax_Syntax.TOTAL  -> true
               | FStar_Syntax_Syntax.RETURN  -> true
               | uu____1194 -> false)))
let is_tot_or_gtot_lcomp: FStar_Syntax_Syntax.lcomp -> Prims.bool =
  fun c  ->
    ((FStar_Ident.lid_equals c.FStar_Syntax_Syntax.eff_name
        FStar_Parser_Const.effect_Tot_lid)
       ||
       (FStar_Ident.lid_equals c.FStar_Syntax_Syntax.eff_name
          FStar_Parser_Const.effect_GTot_lid))
      ||
      (FStar_All.pipe_right c.FStar_Syntax_Syntax.cflags
         (FStar_Util.for_some
            (fun uu___159_1202  ->
               match uu___159_1202 with
               | FStar_Syntax_Syntax.TOTAL  -> true
               | FStar_Syntax_Syntax.RETURN  -> true
               | uu____1203 -> false)))
let is_partial_return:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool =
  fun c  ->
    FStar_All.pipe_right (comp_flags c)
      (FStar_Util.for_some
         (fun uu___160_1215  ->
            match uu___160_1215 with
            | FStar_Syntax_Syntax.RETURN  -> true
            | FStar_Syntax_Syntax.PARTIAL_RETURN  -> true
            | uu____1216 -> false))
let is_lcomp_partial_return: FStar_Syntax_Syntax.lcomp -> Prims.bool =
  fun c  ->
    FStar_All.pipe_right c.FStar_Syntax_Syntax.cflags
      (FStar_Util.for_some
         (fun uu___161_1224  ->
            match uu___161_1224 with
            | FStar_Syntax_Syntax.RETURN  -> true
            | FStar_Syntax_Syntax.PARTIAL_RETURN  -> true
            | uu____1225 -> false))
let is_tot_or_gtot_comp:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool =
  fun c  ->
    (is_total_comp c) ||
      (FStar_Ident.lid_equals FStar_Parser_Const.effect_GTot_lid
         (comp_effect_name c))
let is_pure_effect: FStar_Ident.lident -> Prims.bool =
  fun l  ->
    ((FStar_Ident.lid_equals l FStar_Parser_Const.effect_Tot_lid) ||
       (FStar_Ident.lid_equals l FStar_Parser_Const.effect_PURE_lid))
      || (FStar_Ident.lid_equals l FStar_Parser_Const.effect_Pure_lid)
let is_pure_comp:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total uu____1246 -> true
    | FStar_Syntax_Syntax.GTotal uu____1255 -> false
    | FStar_Syntax_Syntax.Comp ct ->
        ((is_total_comp c) ||
           (is_pure_effect ct.FStar_Syntax_Syntax.effect_name))
          ||
          (FStar_All.pipe_right ct.FStar_Syntax_Syntax.flags
             (FStar_Util.for_some
                (fun uu___162_1268  ->
                   match uu___162_1268 with
                   | FStar_Syntax_Syntax.LEMMA  -> true
                   | uu____1269 -> false)))
let is_ghost_effect: FStar_Ident.lident -> Prims.bool =
  fun l  ->
    ((FStar_Ident.lid_equals FStar_Parser_Const.effect_GTot_lid l) ||
       (FStar_Ident.lid_equals FStar_Parser_Const.effect_GHOST_lid l))
      || (FStar_Ident.lid_equals FStar_Parser_Const.effect_Ghost_lid l)
let is_pure_or_ghost_comp:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool =
  fun c  -> (is_pure_comp c) || (is_ghost_effect (comp_effect_name c))
let is_pure_lcomp: FStar_Syntax_Syntax.lcomp -> Prims.bool =
  fun lc  ->
    ((is_total_lcomp lc) || (is_pure_effect lc.FStar_Syntax_Syntax.eff_name))
      ||
      (FStar_All.pipe_right lc.FStar_Syntax_Syntax.cflags
         (FStar_Util.for_some
            (fun uu___163_1289  ->
               match uu___163_1289 with
               | FStar_Syntax_Syntax.LEMMA  -> true
               | uu____1290 -> false)))
let is_pure_or_ghost_lcomp: FStar_Syntax_Syntax.lcomp -> Prims.bool =
  fun lc  ->
    (is_pure_lcomp lc) || (is_ghost_effect lc.FStar_Syntax_Syntax.eff_name)
let is_pure_or_ghost_function: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____1299 =
      let uu____1300 = FStar_Syntax_Subst.compress t in
      uu____1300.FStar_Syntax_Syntax.n in
    match uu____1299 with
    | FStar_Syntax_Syntax.Tm_arrow (uu____1303,c) -> is_pure_or_ghost_comp c
    | uu____1321 -> true
let is_lemma_comp:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp ct ->
        FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name
          FStar_Parser_Const.effect_Lemma_lid
    | uu____1331 -> false
let is_lemma: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____1336 =
      let uu____1337 = FStar_Syntax_Subst.compress t in
      uu____1337.FStar_Syntax_Syntax.n in
    match uu____1336 with
    | FStar_Syntax_Syntax.Tm_arrow (uu____1340,c) -> is_lemma_comp c
    | uu____1358 -> false
let head_and_args:
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,(FStar_Syntax_Syntax.term'
                                                             FStar_Syntax_Syntax.syntax,
                                                            FStar_Syntax_Syntax.aqual)
                                                            FStar_Pervasives_Native.tuple2
                                                            Prims.list)
      FStar_Pervasives_Native.tuple2
  =
  fun t  ->
    let t1 = FStar_Syntax_Subst.compress t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_app (head1,args) -> (head1, args)
    | uu____1424 -> (t1, [])
let rec head_and_args':
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.term,(FStar_Syntax_Syntax.term'
                                 FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.aqual)
                                FStar_Pervasives_Native.tuple2 Prims.list)
      FStar_Pervasives_Native.tuple2
  =
  fun t  ->
    let t1 = FStar_Syntax_Subst.compress t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_app (head1,args) ->
        let uu____1490 = head_and_args' head1 in
        (match uu____1490 with
         | (head2,args') -> (head2, (FStar_List.append args' args)))
    | uu____1547 -> (t1, [])
let un_uinst: FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term =
  fun t  ->
    let t1 = FStar_Syntax_Subst.compress t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_uinst (t2,uu____1568) ->
        FStar_Syntax_Subst.compress t2
    | uu____1573 -> t1
let is_smt_lemma: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____1578 =
      let uu____1579 = FStar_Syntax_Subst.compress t in
      uu____1579.FStar_Syntax_Syntax.n in
    match uu____1578 with
    | FStar_Syntax_Syntax.Tm_arrow (uu____1582,c) ->
        (match c.FStar_Syntax_Syntax.n with
         | FStar_Syntax_Syntax.Comp ct when
             FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name
               FStar_Parser_Const.effect_Lemma_lid
             ->
             (match ct.FStar_Syntax_Syntax.effect_args with
              | _req::_ens::(pats,uu____1604)::uu____1605 ->
                  let pats' = unmeta pats in
                  let uu____1649 = head_and_args pats' in
                  (match uu____1649 with
                   | (head1,uu____1665) ->
                       let uu____1686 =
                         let uu____1687 = un_uinst head1 in
                         uu____1687.FStar_Syntax_Syntax.n in
                       (match uu____1686 with
                        | FStar_Syntax_Syntax.Tm_fvar fv ->
                            FStar_Syntax_Syntax.fv_eq_lid fv
                              FStar_Parser_Const.cons_lid
                        | uu____1691 -> false))
              | uu____1692 -> false)
         | uu____1701 -> false)
    | uu____1702 -> false
let is_ml_comp:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 ->
        (FStar_Ident.lid_equals c1.FStar_Syntax_Syntax.effect_name
           FStar_Parser_Const.effect_ML_lid)
          ||
          (FStar_All.pipe_right c1.FStar_Syntax_Syntax.flags
             (FStar_Util.for_some
                (fun uu___164_1715  ->
                   match uu___164_1715 with
                   | FStar_Syntax_Syntax.MLEFFECT  -> true
                   | uu____1716 -> false)))
    | uu____1717 -> false
let comp_result:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total (t,uu____1731) -> t
    | FStar_Syntax_Syntax.GTotal (t,uu____1741) -> t
    | FStar_Syntax_Syntax.Comp ct -> ct.FStar_Syntax_Syntax.result_typ
let set_result_typ:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.comp
  =
  fun c  ->
    fun t  ->
      match c.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Total uu____1763 ->
          FStar_Syntax_Syntax.mk_Total t
      | FStar_Syntax_Syntax.GTotal uu____1772 ->
          FStar_Syntax_Syntax.mk_GTotal t
      | FStar_Syntax_Syntax.Comp ct ->
          FStar_Syntax_Syntax.mk_Comp
            (let uu___171_1784 = ct in
             {
               FStar_Syntax_Syntax.comp_univs =
                 (uu___171_1784.FStar_Syntax_Syntax.comp_univs);
               FStar_Syntax_Syntax.effect_name =
                 (uu___171_1784.FStar_Syntax_Syntax.effect_name);
               FStar_Syntax_Syntax.result_typ = t;
               FStar_Syntax_Syntax.effect_args =
                 (uu___171_1784.FStar_Syntax_Syntax.effect_args);
               FStar_Syntax_Syntax.flags =
                 (uu___171_1784.FStar_Syntax_Syntax.flags)
             })
let is_trivial_wp:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool =
  fun c  ->
    FStar_All.pipe_right (comp_flags c)
      (FStar_Util.for_some
         (fun uu___165_1796  ->
            match uu___165_1796 with
            | FStar_Syntax_Syntax.TOTAL  -> true
            | FStar_Syntax_Syntax.RETURN  -> true
            | uu____1797 -> false))
let primops: FStar_Ident.lident Prims.list =
  [FStar_Parser_Const.op_Eq;
  FStar_Parser_Const.op_notEq;
  FStar_Parser_Const.op_LT;
  FStar_Parser_Const.op_LTE;
  FStar_Parser_Const.op_GT;
  FStar_Parser_Const.op_GTE;
  FStar_Parser_Const.op_Subtraction;
  FStar_Parser_Const.op_Minus;
  FStar_Parser_Const.op_Addition;
  FStar_Parser_Const.op_Multiply;
  FStar_Parser_Const.op_Division;
  FStar_Parser_Const.op_Modulus;
  FStar_Parser_Const.op_And;
  FStar_Parser_Const.op_Or;
  FStar_Parser_Const.op_Negation]
let is_primop_lid: FStar_Ident.lident -> Prims.bool =
  fun l  ->
    FStar_All.pipe_right primops
      (FStar_Util.for_some (FStar_Ident.lid_equals l))
let is_primop:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax -> Prims.bool =
  fun f  ->
    match f.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        is_primop_lid (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
    | uu____1815 -> false
let rec unascribe: FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term =
  fun e  ->
    let e1 = FStar_Syntax_Subst.compress e in
    match e1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_ascribed (e2,uu____1822,uu____1823) ->
        unascribe e2
    | uu____1864 -> e1
let rec ascribe:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    ((FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.comp'
                                                             FStar_Syntax_Syntax.syntax)
       FStar_Util.either,FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
                           FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2 ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun t  ->
    fun k  ->
      match t.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_ascribed (t',uu____1914,uu____1915) ->
          ascribe t' k
      | uu____1956 ->
          FStar_Syntax_Syntax.mk
            (FStar_Syntax_Syntax.Tm_ascribed
               (t, k, FStar_Pervasives_Native.None))
            FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
type eq_result =
  | Equal
  | NotEqual
  | Unknown[@@deriving show]
let uu___is_Equal: eq_result -> Prims.bool =
  fun projectee  ->
    match projectee with | Equal  -> true | uu____1981 -> false
let uu___is_NotEqual: eq_result -> Prims.bool =
  fun projectee  ->
    match projectee with | NotEqual  -> true | uu____1986 -> false
let uu___is_Unknown: eq_result -> Prims.bool =
  fun projectee  ->
    match projectee with | Unknown  -> true | uu____1991 -> false
let rec eq_tm:
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> eq_result =
  fun t1  ->
    fun t2  ->
      let canon_app t =
        let uu____2012 =
          let uu____2025 = unascribe t in head_and_args' uu____2025 in
        match uu____2012 with
        | (hd1,args) ->
            FStar_Syntax_Syntax.mk_Tm_app hd1 args
              FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos in
      let t11 = canon_app t1 in
      let t21 = canon_app t2 in
      let equal_if uu___166_2055 = if uu___166_2055 then Equal else Unknown in
      let equal_iff uu___167_2060 = if uu___167_2060 then Equal else NotEqual in
      let eq_and f g = match f with | Equal  -> g () | uu____2074 -> Unknown in
      let eq_inj f g =
        match (f, g) with
        | (Equal ,Equal ) -> Equal
        | (NotEqual ,uu____2082) -> NotEqual
        | (uu____2083,NotEqual ) -> NotEqual
        | (Unknown ,uu____2084) -> Unknown
        | (uu____2085,Unknown ) -> Unknown in
      let equal_data f1 args1 f2 args2 =
        let uu____2123 = FStar_Syntax_Syntax.fv_eq f1 f2 in
        if uu____2123
        then
          let uu____2127 = FStar_List.zip args1 args2 in
          FStar_All.pipe_left
            (FStar_List.fold_left
               (fun acc  ->
                  fun uu____2185  ->
                    match uu____2185 with
                    | ((a1,q1),(a2,q2)) ->
                        let uu____2213 = eq_tm a1 a2 in eq_inj acc uu____2213)
               Equal) uu____2127
        else NotEqual in
      match ((t11.FStar_Syntax_Syntax.n), (t21.FStar_Syntax_Syntax.n)) with
      | (FStar_Syntax_Syntax.Tm_name a,FStar_Syntax_Syntax.Tm_name b) ->
          equal_if (FStar_Syntax_Syntax.bv_eq a b)
      | (FStar_Syntax_Syntax.Tm_fvar f,FStar_Syntax_Syntax.Tm_fvar g) ->
          if
            (f.FStar_Syntax_Syntax.fv_qual =
               (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor))
              &&
              (g.FStar_Syntax_Syntax.fv_qual =
                 (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor))
          then equal_data f [] g []
          else
            (let uu____2232 = FStar_Syntax_Syntax.fv_eq f g in
             equal_if uu____2232)
      | (FStar_Syntax_Syntax.Tm_uinst (f,us),FStar_Syntax_Syntax.Tm_uinst
         (g,vs)) ->
          let uu____2245 = eq_tm f g in
          eq_and uu____2245
            (fun uu____2248  ->
               let uu____2249 = eq_univs_list us vs in equal_if uu____2249)
      | (FStar_Syntax_Syntax.Tm_constant c,FStar_Syntax_Syntax.Tm_constant d)
          ->
          let uu____2252 = FStar_Const.eq_const c d in equal_iff uu____2252
      | (FStar_Syntax_Syntax.Tm_uvar
         (u1,uu____2254),FStar_Syntax_Syntax.Tm_uvar (u2,uu____2256)) ->
          let uu____2305 = FStar_Syntax_Unionfind.equiv u1 u2 in
          equal_if uu____2305
      | (FStar_Syntax_Syntax.Tm_app (h1,args1),FStar_Syntax_Syntax.Tm_app
         (h2,args2)) ->
          let uu____2350 =
            let uu____2355 =
              let uu____2356 = un_uinst h1 in
              uu____2356.FStar_Syntax_Syntax.n in
            let uu____2359 =
              let uu____2360 = un_uinst h2 in
              uu____2360.FStar_Syntax_Syntax.n in
            (uu____2355, uu____2359) in
          (match uu____2350 with
           | (FStar_Syntax_Syntax.Tm_fvar f1,FStar_Syntax_Syntax.Tm_fvar f2)
               when
               (f1.FStar_Syntax_Syntax.fv_qual =
                  (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor))
                 &&
                 (f2.FStar_Syntax_Syntax.fv_qual =
                    (FStar_Pervasives_Native.Some
                       FStar_Syntax_Syntax.Data_ctor))
               -> equal_data f1 args1 f2 args2
           | uu____2369 ->
               let uu____2374 = eq_tm h1 h2 in
               eq_and uu____2374 (fun uu____2376  -> eq_args args1 args2))
      | (FStar_Syntax_Syntax.Tm_type u,FStar_Syntax_Syntax.Tm_type v1) ->
          let uu____2379 = eq_univs u v1 in equal_if uu____2379
      | (FStar_Syntax_Syntax.Tm_meta (t12,uu____2381),uu____2382) ->
          eq_tm t12 t21
      | (uu____2387,FStar_Syntax_Syntax.Tm_meta (t22,uu____2389)) ->
          eq_tm t11 t22
      | uu____2394 -> Unknown
and eq_args:
  FStar_Syntax_Syntax.args -> FStar_Syntax_Syntax.args -> eq_result =
  fun a1  ->
    fun a2  ->
      match (a1, a2) with
      | ([],[]) -> Equal
      | ((a,uu____2430)::a11,(b,uu____2433)::b1) ->
          let uu____2487 = eq_tm a b in
          (match uu____2487 with
           | Equal  -> eq_args a11 b1
           | uu____2488 -> Unknown)
      | uu____2489 -> Unknown
and eq_univs_list:
  FStar_Syntax_Syntax.universes ->
    FStar_Syntax_Syntax.universes -> Prims.bool
  =
  fun us  ->
    fun vs  ->
      ((FStar_List.length us) = (FStar_List.length vs)) &&
        (FStar_List.forall2 eq_univs us vs)
let rec unrefine: FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term =
  fun t  ->
    let t1 = FStar_Syntax_Subst.compress t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_refine (x,uu____2502) ->
        unrefine x.FStar_Syntax_Syntax.sort
    | FStar_Syntax_Syntax.Tm_ascribed (t2,uu____2508,uu____2509) ->
        unrefine t2
    | uu____2550 -> t1
let rec is_unit: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____2555 =
      let uu____2556 = unrefine t in uu____2556.FStar_Syntax_Syntax.n in
    match uu____2555 with
    | FStar_Syntax_Syntax.Tm_type uu____2559 -> true
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.unit_lid) ||
          (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.squash_lid)
    | FStar_Syntax_Syntax.Tm_uinst (t1,uu____2562) -> is_unit t1
    | uu____2567 -> false
let rec non_informative: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____2572 =
      let uu____2573 = unrefine t in uu____2573.FStar_Syntax_Syntax.n in
    match uu____2572 with
    | FStar_Syntax_Syntax.Tm_type uu____2576 -> true
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        ((FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.unit_lid) ||
           (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.squash_lid))
          || (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.erased_lid)
    | FStar_Syntax_Syntax.Tm_app (head1,uu____2579) -> non_informative head1
    | FStar_Syntax_Syntax.Tm_uinst (t1,uu____2601) -> non_informative t1
    | FStar_Syntax_Syntax.Tm_arrow (uu____2606,c) ->
        (is_tot_or_gtot_comp c) && (non_informative (comp_result c))
    | uu____2624 -> false
let is_fun: FStar_Syntax_Syntax.term -> Prims.bool =
  fun e  ->
    let uu____2629 =
      let uu____2630 = FStar_Syntax_Subst.compress e in
      uu____2630.FStar_Syntax_Syntax.n in
    match uu____2629 with
    | FStar_Syntax_Syntax.Tm_abs uu____2633 -> true
    | uu____2650 -> false
let is_function_typ: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____2655 =
      let uu____2656 = FStar_Syntax_Subst.compress t in
      uu____2656.FStar_Syntax_Syntax.n in
    match uu____2655 with
    | FStar_Syntax_Syntax.Tm_arrow uu____2659 -> true
    | uu____2672 -> false
let rec pre_typ: FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term =
  fun t  ->
    let t1 = FStar_Syntax_Subst.compress t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_refine (x,uu____2679) ->
        pre_typ x.FStar_Syntax_Syntax.sort
    | FStar_Syntax_Syntax.Tm_ascribed (t2,uu____2685,uu____2686) ->
        pre_typ t2
    | uu____2727 -> t1
let destruct:
  FStar_Syntax_Syntax.term ->
    FStar_Ident.lident ->
      (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.aqual)
        FStar_Pervasives_Native.tuple2 Prims.list
        FStar_Pervasives_Native.option
  =
  fun typ  ->
    fun lid  ->
      let typ1 = FStar_Syntax_Subst.compress typ in
      let uu____2747 =
        let uu____2748 = un_uinst typ1 in uu____2748.FStar_Syntax_Syntax.n in
      match uu____2747 with
      | FStar_Syntax_Syntax.Tm_app (head1,args) ->
          let head2 = un_uinst head1 in
          (match head2.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Tm_fvar tc when
               FStar_Syntax_Syntax.fv_eq_lid tc lid ->
               FStar_Pervasives_Native.Some args
           | uu____2803 -> FStar_Pervasives_Native.None)
      | FStar_Syntax_Syntax.Tm_fvar tc when
          FStar_Syntax_Syntax.fv_eq_lid tc lid ->
          FStar_Pervasives_Native.Some []
      | uu____2827 -> FStar_Pervasives_Native.None
let lids_of_sigelt:
  FStar_Syntax_Syntax.sigelt -> FStar_Ident.lident Prims.list =
  fun se  ->
    match se.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_let (uu____2844,lids) -> lids
    | FStar_Syntax_Syntax.Sig_bundle (uu____2850,lids) -> lids
    | FStar_Syntax_Syntax.Sig_inductive_typ
        (lid,uu____2861,uu____2862,uu____2863,uu____2864,uu____2865) -> 
        [lid]
    | FStar_Syntax_Syntax.Sig_effect_abbrev
        (lid,uu____2875,uu____2876,uu____2877,uu____2878) -> [lid]
    | FStar_Syntax_Syntax.Sig_datacon
        (lid,uu____2884,uu____2885,uu____2886,uu____2887,uu____2888) -> 
        [lid]
    | FStar_Syntax_Syntax.Sig_declare_typ (lid,uu____2894,uu____2895) ->
        [lid]
    | FStar_Syntax_Syntax.Sig_assume (lid,uu____2897,uu____2898) -> [lid]
    | FStar_Syntax_Syntax.Sig_new_effect_for_free n1 ->
        [n1.FStar_Syntax_Syntax.mname]
    | FStar_Syntax_Syntax.Sig_new_effect n1 -> [n1.FStar_Syntax_Syntax.mname]
    | FStar_Syntax_Syntax.Sig_sub_effect uu____2901 -> []
    | FStar_Syntax_Syntax.Sig_pragma uu____2902 -> []
    | FStar_Syntax_Syntax.Sig_main uu____2903 -> []
let lid_of_sigelt:
  FStar_Syntax_Syntax.sigelt ->
    FStar_Ident.lident FStar_Pervasives_Native.option
  =
  fun se  ->
    match lids_of_sigelt se with
    | l::[] -> FStar_Pervasives_Native.Some l
    | uu____2915 -> FStar_Pervasives_Native.None
let quals_of_sigelt:
  FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.qualifier Prims.list =
  fun x  -> x.FStar_Syntax_Syntax.sigquals
let range_of_sigelt: FStar_Syntax_Syntax.sigelt -> FStar_Range.range =
  fun x  -> x.FStar_Syntax_Syntax.sigrng
let range_of_lb:
  'Auu____2934 'Auu____2935 .
    ((FStar_Syntax_Syntax.bv,FStar_Ident.lid) FStar_Util.either,'Auu____2935,
      'Auu____2934) FStar_Pervasives_Native.tuple3 -> FStar_Range.range
  =
  fun uu___168_2949  ->
    match uu___168_2949 with
    | (FStar_Util.Inl x,uu____2961,uu____2962) ->
        FStar_Syntax_Syntax.range_of_bv x
    | (FStar_Util.Inr l,uu____2968,uu____2969) -> FStar_Ident.range_of_lid l
let range_of_arg:
  'Auu____2980 'Auu____2981 .
    ('Auu____2981 FStar_Syntax_Syntax.syntax,'Auu____2980)
      FStar_Pervasives_Native.tuple2 -> FStar_Range.range
  =
  fun uu____2991  ->
    match uu____2991 with | (hd1,uu____2999) -> hd1.FStar_Syntax_Syntax.pos
let range_of_args:
  'Auu____3012 'Auu____3013 .
    ('Auu____3013 FStar_Syntax_Syntax.syntax,'Auu____3012)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      FStar_Range.range -> FStar_Range.range
  =
  fun args  ->
    fun r  ->
      FStar_All.pipe_right args
        (FStar_List.fold_left
           (fun r1  -> fun a  -> FStar_Range.union_ranges r1 (range_of_arg a))
           r)
let mk_app:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.aqual)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun f  ->
    fun args  ->
      let r = range_of_args args f.FStar_Syntax_Syntax.pos in
      FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_app (f, args))
        FStar_Pervasives_Native.None r
let mk_data:
  FStar_Ident.lident ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.aqual)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun l  ->
    fun args  ->
      match args with
      | [] ->
          let uu____3137 =
            let uu____3140 =
              let uu____3141 =
                let uu____3148 =
                  FStar_Syntax_Syntax.fvar l
                    FStar_Syntax_Syntax.Delta_constant
                    (FStar_Pervasives_Native.Some
                       FStar_Syntax_Syntax.Data_ctor) in
                (uu____3148,
                  (FStar_Syntax_Syntax.Meta_desugared
                     FStar_Syntax_Syntax.Data_app)) in
              FStar_Syntax_Syntax.Tm_meta uu____3141 in
            FStar_Syntax_Syntax.mk uu____3140 in
          uu____3137 FStar_Pervasives_Native.None
            (FStar_Ident.range_of_lid l)
      | uu____3152 ->
          let e =
            let uu____3164 =
              FStar_Syntax_Syntax.fvar l FStar_Syntax_Syntax.Delta_constant
                (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor) in
            mk_app uu____3164 args in
          FStar_Syntax_Syntax.mk
            (FStar_Syntax_Syntax.Tm_meta
               (e,
                 (FStar_Syntax_Syntax.Meta_desugared
                    FStar_Syntax_Syntax.Data_app)))
            FStar_Pervasives_Native.None e.FStar_Syntax_Syntax.pos
let mangle_field_name: FStar_Ident.ident -> FStar_Ident.ident =
  fun x  ->
    FStar_Ident.mk_ident
      ((Prims.strcat "__fname__" x.FStar_Ident.idText),
        (x.FStar_Ident.idRange))
let unmangle_field_name: FStar_Ident.ident -> FStar_Ident.ident =
  fun x  ->
    if FStar_Util.starts_with x.FStar_Ident.idText "__fname__"
    then
      let uu____3177 =
        let uu____3182 =
          FStar_Util.substring_from x.FStar_Ident.idText
            (Prims.parse_int "9") in
        (uu____3182, (x.FStar_Ident.idRange)) in
      FStar_Ident.mk_ident uu____3177
    else x
let field_projector_prefix: Prims.string = "__proj__"
let field_projector_sep: Prims.string = "__item__"
let field_projector_contains_constructor: Prims.string -> Prims.bool =
  fun s  -> FStar_Util.starts_with s field_projector_prefix
let mk_field_projector_name_from_string:
  Prims.string -> Prims.string -> Prims.string =
  fun constr  ->
    fun field  ->
      Prims.strcat field_projector_prefix
        (Prims.strcat constr (Prims.strcat field_projector_sep field))
let mk_field_projector_name_from_ident:
  FStar_Ident.lident -> FStar_Ident.ident -> FStar_Ident.lident =
  fun lid  ->
    fun i  ->
      let j = unmangle_field_name i in
      let jtext = j.FStar_Ident.idText in
      let newi =
        if field_projector_contains_constructor jtext
        then j
        else
          FStar_Ident.mk_ident
            ((mk_field_projector_name_from_string
                (lid.FStar_Ident.ident).FStar_Ident.idText jtext),
              (i.FStar_Ident.idRange)) in
      FStar_Ident.lid_of_ids (FStar_List.append lid.FStar_Ident.ns [newi])
let mk_field_projector_name:
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.bv ->
      Prims.int ->
        (FStar_Ident.lident,FStar_Syntax_Syntax.bv)
          FStar_Pervasives_Native.tuple2
  =
  fun lid  ->
    fun x  ->
      fun i  ->
        let nm =
          let uu____3225 = FStar_Syntax_Syntax.is_null_bv x in
          if uu____3225
          then
            let uu____3226 =
              let uu____3231 =
                let uu____3232 = FStar_Util.string_of_int i in
                Prims.strcat "_" uu____3232 in
              let uu____3233 = FStar_Syntax_Syntax.range_of_bv x in
              (uu____3231, uu____3233) in
            FStar_Ident.mk_ident uu____3226
          else x.FStar_Syntax_Syntax.ppname in
        let y =
          let uu___172_3236 = x in
          {
            FStar_Syntax_Syntax.ppname = nm;
            FStar_Syntax_Syntax.index =
              (uu___172_3236.FStar_Syntax_Syntax.index);
            FStar_Syntax_Syntax.sort =
              (uu___172_3236.FStar_Syntax_Syntax.sort)
          } in
        let uu____3237 = mk_field_projector_name_from_ident lid nm in
        (uu____3237, y)
let set_uvar:
  FStar_Syntax_Syntax.uvar -> FStar_Syntax_Syntax.term -> Prims.unit =
  fun uv  ->
    fun t  ->
      let uu____3246 = FStar_Syntax_Unionfind.find uv in
      match uu____3246 with
      | FStar_Pervasives_Native.Some uu____3249 ->
          let uu____3250 =
            let uu____3251 =
              let uu____3252 = FStar_Syntax_Unionfind.uvar_id uv in
              FStar_All.pipe_left FStar_Util.string_of_int uu____3252 in
            FStar_Util.format1 "Changing a fixed uvar! ?%s\n" uu____3251 in
          failwith uu____3250
      | uu____3253 -> FStar_Syntax_Unionfind.change uv t
let qualifier_equal:
  FStar_Syntax_Syntax.qualifier ->
    FStar_Syntax_Syntax.qualifier -> Prims.bool
  =
  fun q1  ->
    fun q2  ->
      match (q1, q2) with
      | (FStar_Syntax_Syntax.Discriminator
         l1,FStar_Syntax_Syntax.Discriminator l2) ->
          FStar_Ident.lid_equals l1 l2
      | (FStar_Syntax_Syntax.Projector
         (l1a,l1b),FStar_Syntax_Syntax.Projector (l2a,l2b)) ->
          (FStar_Ident.lid_equals l1a l2a) &&
            (l1b.FStar_Ident.idText = l2b.FStar_Ident.idText)
      | (FStar_Syntax_Syntax.RecordType
         (ns1,f1),FStar_Syntax_Syntax.RecordType (ns2,f2)) ->
          ((((FStar_List.length ns1) = (FStar_List.length ns2)) &&
              (FStar_List.forall2
                 (fun x1  ->
                    fun x2  -> x1.FStar_Ident.idText = x2.FStar_Ident.idText)
                 f1 f2))
             && ((FStar_List.length f1) = (FStar_List.length f2)))
            &&
            (FStar_List.forall2
               (fun x1  ->
                  fun x2  -> x1.FStar_Ident.idText = x2.FStar_Ident.idText)
               f1 f2)
      | (FStar_Syntax_Syntax.RecordConstructor
         (ns1,f1),FStar_Syntax_Syntax.RecordConstructor (ns2,f2)) ->
          ((((FStar_List.length ns1) = (FStar_List.length ns2)) &&
              (FStar_List.forall2
                 (fun x1  ->
                    fun x2  -> x1.FStar_Ident.idText = x2.FStar_Ident.idText)
                 f1 f2))
             && ((FStar_List.length f1) = (FStar_List.length f2)))
            &&
            (FStar_List.forall2
               (fun x1  ->
                  fun x2  -> x1.FStar_Ident.idText = x2.FStar_Ident.idText)
               f1 f2)
      | uu____3326 -> q1 = q2
let abs:
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.residual_comp FStar_Pervasives_Native.option ->
        FStar_Syntax_Syntax.term
  =
  fun bs  ->
    fun t  ->
      fun lopt  ->
        let close_lopt lopt1 =
          match lopt1 with
          | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
          | FStar_Pervasives_Native.Some rc ->
              let uu____3360 =
                let uu___173_3361 = rc in
                let uu____3362 =
                  FStar_Util.map_opt rc.FStar_Syntax_Syntax.residual_typ
                    (FStar_Syntax_Subst.close bs) in
                {
                  FStar_Syntax_Syntax.residual_effect =
                    (uu___173_3361.FStar_Syntax_Syntax.residual_effect);
                  FStar_Syntax_Syntax.residual_typ = uu____3362;
                  FStar_Syntax_Syntax.residual_flags =
                    (uu___173_3361.FStar_Syntax_Syntax.residual_flags)
                } in
              FStar_Pervasives_Native.Some uu____3360 in
        match bs with
        | [] -> t
        | uu____3373 ->
            let body =
              let uu____3375 = FStar_Syntax_Subst.close bs t in
              FStar_Syntax_Subst.compress uu____3375 in
            (match ((body.FStar_Syntax_Syntax.n), lopt) with
             | (FStar_Syntax_Syntax.Tm_abs
                (bs',t1,lopt'),FStar_Pervasives_Native.None ) ->
                 let uu____3403 =
                   let uu____3406 =
                     let uu____3407 =
                       let uu____3424 =
                         let uu____3431 = FStar_Syntax_Subst.close_binders bs in
                         FStar_List.append uu____3431 bs' in
                       let uu____3442 = close_lopt lopt' in
                       (uu____3424, t1, uu____3442) in
                     FStar_Syntax_Syntax.Tm_abs uu____3407 in
                   FStar_Syntax_Syntax.mk uu____3406 in
                 uu____3403 FStar_Pervasives_Native.None
                   t1.FStar_Syntax_Syntax.pos
             | uu____3458 ->
                 let uu____3465 =
                   let uu____3468 =
                     let uu____3469 =
                       let uu____3486 = FStar_Syntax_Subst.close_binders bs in
                       let uu____3487 = close_lopt lopt in
                       (uu____3486, body, uu____3487) in
                     FStar_Syntax_Syntax.Tm_abs uu____3469 in
                   FStar_Syntax_Syntax.mk uu____3468 in
                 uu____3465 FStar_Pervasives_Native.None
                   t.FStar_Syntax_Syntax.pos)
let arrow:
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
    FStar_Pervasives_Native.tuple2 Prims.list ->
    FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun bs  ->
    fun c  ->
      match bs with
      | [] -> comp_result c
      | uu____3527 ->
          let uu____3534 =
            let uu____3537 =
              let uu____3538 =
                let uu____3551 = FStar_Syntax_Subst.close_binders bs in
                let uu____3552 = FStar_Syntax_Subst.close_comp bs c in
                (uu____3551, uu____3552) in
              FStar_Syntax_Syntax.Tm_arrow uu____3538 in
            FStar_Syntax_Syntax.mk uu____3537 in
          uu____3534 FStar_Pervasives_Native.None c.FStar_Syntax_Syntax.pos
let flat_arrow:
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
    FStar_Pervasives_Native.tuple2 Prims.list ->
    FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun bs  ->
    fun c  ->
      let t = arrow bs c in
      let uu____3585 =
        let uu____3586 = FStar_Syntax_Subst.compress t in
        uu____3586.FStar_Syntax_Syntax.n in
      match uu____3585 with
      | FStar_Syntax_Syntax.Tm_arrow (bs1,c1) ->
          (match c1.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Total (tres,uu____3612) ->
               let uu____3621 =
                 let uu____3622 = FStar_Syntax_Subst.compress tres in
                 uu____3622.FStar_Syntax_Syntax.n in
               (match uu____3621 with
                | FStar_Syntax_Syntax.Tm_arrow (bs',c') ->
                    FStar_Syntax_Syntax.mk
                      (FStar_Syntax_Syntax.Tm_arrow
                         ((FStar_List.append bs1 bs'), c'))
                      FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
                | uu____3657 -> t)
           | uu____3658 -> t)
      | uu____3659 -> t
let refine:
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun b  ->
    fun t  ->
      let uu____3670 =
        let uu____3671 = FStar_Syntax_Syntax.range_of_bv b in
        FStar_Range.union_ranges uu____3671 t.FStar_Syntax_Syntax.pos in
      let uu____3672 =
        let uu____3675 =
          let uu____3676 =
            let uu____3683 =
              let uu____3684 =
                let uu____3685 = FStar_Syntax_Syntax.mk_binder b in
                [uu____3685] in
              FStar_Syntax_Subst.close uu____3684 t in
            (b, uu____3683) in
          FStar_Syntax_Syntax.Tm_refine uu____3676 in
        FStar_Syntax_Syntax.mk uu____3675 in
      uu____3672 FStar_Pervasives_Native.None uu____3670
let branch: FStar_Syntax_Syntax.branch -> FStar_Syntax_Syntax.branch =
  fun b  -> FStar_Syntax_Subst.close_branch b
let rec arrow_formals_comp:
  FStar_Syntax_Syntax.term ->
    ((FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
       FStar_Pervasives_Native.tuple2 Prims.list,FStar_Syntax_Syntax.comp)
      FStar_Pervasives_Native.tuple2
  =
  fun k  ->
    let k1 = FStar_Syntax_Subst.compress k in
    match k1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
        let uu____3736 = FStar_Syntax_Subst.open_comp bs c in
        (match uu____3736 with
         | (bs1,c1) ->
             let uu____3753 = is_tot_or_gtot_comp c1 in
             if uu____3753
             then
               let uu____3764 = arrow_formals_comp (comp_result c1) in
               (match uu____3764 with
                | (bs',k2) -> ((FStar_List.append bs1 bs'), k2))
             else (bs1, c1))
    | uu____3810 ->
        let uu____3811 = FStar_Syntax_Syntax.mk_Total k1 in ([], uu____3811)
let rec arrow_formals:
  FStar_Syntax_Syntax.term ->
    ((FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
       FStar_Pervasives_Native.tuple2 Prims.list,FStar_Syntax_Syntax.term'
                                                   FStar_Syntax_Syntax.syntax)
      FStar_Pervasives_Native.tuple2
  =
  fun k  ->
    let uu____3838 = arrow_formals_comp k in
    match uu____3838 with | (bs,c) -> (bs, (comp_result c))
let abs_formals:
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.binders,FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.residual_comp
                                                            FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple3
  =
  fun t  ->
    let subst_lcomp_opt s l =
      match l with
      | FStar_Pervasives_Native.Some rc ->
          let uu____3915 =
            let uu___174_3916 = rc in
            let uu____3917 =
              FStar_Util.map_opt rc.FStar_Syntax_Syntax.residual_typ
                (FStar_Syntax_Subst.subst s) in
            {
              FStar_Syntax_Syntax.residual_effect =
                (uu___174_3916.FStar_Syntax_Syntax.residual_effect);
              FStar_Syntax_Syntax.residual_typ = uu____3917;
              FStar_Syntax_Syntax.residual_flags =
                (uu___174_3916.FStar_Syntax_Syntax.residual_flags)
            } in
          FStar_Pervasives_Native.Some uu____3915
      | uu____3924 -> l in
    let rec aux t1 abs_body_lcomp =
      let uu____3952 =
        let uu____3953 =
          let uu____3956 = FStar_Syntax_Subst.compress t1 in
          FStar_All.pipe_left unascribe uu____3956 in
        uu____3953.FStar_Syntax_Syntax.n in
      match uu____3952 with
      | FStar_Syntax_Syntax.Tm_abs (bs,t2,what) ->
          let uu____3994 = aux t2 what in
          (match uu____3994 with
           | (bs',t3,what1) -> ((FStar_List.append bs bs'), t3, what1))
      | uu____4054 -> ([], t1, abs_body_lcomp) in
    let uu____4067 = aux t FStar_Pervasives_Native.None in
    match uu____4067 with
    | (bs,t1,abs_body_lcomp) ->
        let uu____4109 = FStar_Syntax_Subst.open_term' bs t1 in
        (match uu____4109 with
         | (bs1,t2,opening) ->
             let abs_body_lcomp1 = subst_lcomp_opt opening abs_body_lcomp in
             (bs1, t2, abs_body_lcomp1))
let mk_letbinding:
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.fv) FStar_Util.either ->
    FStar_Syntax_Syntax.univ_name Prims.list ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Ident.lident ->
          FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
            FStar_Syntax_Syntax.letbinding
  =
  fun lbname  ->
    fun univ_vars  ->
      fun typ  ->
        fun eff  ->
          fun def  ->
            {
              FStar_Syntax_Syntax.lbname = lbname;
              FStar_Syntax_Syntax.lbunivs = univ_vars;
              FStar_Syntax_Syntax.lbtyp = typ;
              FStar_Syntax_Syntax.lbeff = eff;
              FStar_Syntax_Syntax.lbdef = def
            }
let close_univs_and_mk_letbinding:
  FStar_Syntax_Syntax.fv Prims.list FStar_Pervasives_Native.option ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.fv) FStar_Util.either ->
      FStar_Ident.ident Prims.list ->
        FStar_Syntax_Syntax.term ->
          FStar_Ident.lident ->
            FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.letbinding
  =
  fun recs  ->
    fun lbname  ->
      fun univ_vars  ->
        fun typ  ->
          fun eff  ->
            fun def  ->
              let def1 =
                match (recs, univ_vars) with
                | (FStar_Pervasives_Native.None ,uu____4223) -> def
                | (uu____4234,[]) -> def
                | (FStar_Pervasives_Native.Some fvs,uu____4246) ->
                    let universes =
                      FStar_All.pipe_right univ_vars
                        (FStar_List.map
                           (fun _0_28  -> FStar_Syntax_Syntax.U_name _0_28)) in
                    let inst1 =
                      FStar_All.pipe_right fvs
                        (FStar_List.map
                           (fun fv  ->
                              (((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v),
                                universes))) in
                    FStar_Syntax_InstFV.instantiate inst1 def in
              let typ1 = FStar_Syntax_Subst.close_univ_vars univ_vars typ in
              let def2 = FStar_Syntax_Subst.close_univ_vars univ_vars def1 in
              mk_letbinding lbname univ_vars typ1 eff def2
let open_univ_vars_binders_and_comp:
  FStar_Syntax_Syntax.univ_names ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      FStar_Syntax_Syntax.comp ->
        (FStar_Syntax_Syntax.univ_names,(FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
                                          FStar_Pervasives_Native.tuple2
                                          Prims.list,FStar_Syntax_Syntax.comp)
          FStar_Pervasives_Native.tuple3
  =
  fun uvs  ->
    fun binders  ->
      fun c  ->
        match binders with
        | [] ->
            let uu____4349 = FStar_Syntax_Subst.open_univ_vars_comp uvs c in
            (match uu____4349 with | (uvs1,c1) -> (uvs1, [], c1))
        | uu____4378 ->
            let t' = arrow binders c in
            let uu____4388 = FStar_Syntax_Subst.open_univ_vars uvs t' in
            (match uu____4388 with
             | (uvs1,t'1) ->
                 let uu____4407 =
                   let uu____4408 = FStar_Syntax_Subst.compress t'1 in
                   uu____4408.FStar_Syntax_Syntax.n in
                 (match uu____4407 with
                  | FStar_Syntax_Syntax.Tm_arrow (binders1,c1) ->
                      (uvs1, binders1, c1)
                  | uu____4449 -> failwith "Impossible"))
let is_tuple_constructor: FStar_Syntax_Syntax.typ -> Prims.bool =
  fun t  ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Parser_Const.is_tuple_constructor_string
          ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str
    | uu____4467 -> false
let is_dtuple_constructor: FStar_Syntax_Syntax.typ -> Prims.bool =
  fun t  ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Parser_Const.is_dtuple_constructor_lid
          (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
    | uu____4473 -> false
let is_lid_equality: FStar_Ident.lident -> Prims.bool =
  fun x  -> FStar_Ident.lid_equals x FStar_Parser_Const.eq2_lid
let is_forall: FStar_Ident.lident -> Prims.bool =
  fun lid  -> FStar_Ident.lid_equals lid FStar_Parser_Const.forall_lid
let is_exists: FStar_Ident.lident -> Prims.bool =
  fun lid  -> FStar_Ident.lid_equals lid FStar_Parser_Const.exists_lid
let is_qlid: FStar_Ident.lident -> Prims.bool =
  fun lid  -> (is_forall lid) || (is_exists lid)
let is_equality:
  FStar_Ident.lident FStar_Syntax_Syntax.withinfo_t -> Prims.bool =
  fun x  -> is_lid_equality x.FStar_Syntax_Syntax.v
let lid_is_connective: FStar_Ident.lident -> Prims.bool =
  let lst =
    [FStar_Parser_Const.and_lid;
    FStar_Parser_Const.or_lid;
    FStar_Parser_Const.not_lid;
    FStar_Parser_Const.iff_lid;
    FStar_Parser_Const.imp_lid] in
  fun lid  -> FStar_Util.for_some (FStar_Ident.lid_equals lid) lst
let is_constructor:
  FStar_Syntax_Syntax.term -> FStar_Ident.lident -> Prims.bool =
  fun t  ->
    fun lid  ->
      let uu____4513 =
        let uu____4514 = pre_typ t in uu____4514.FStar_Syntax_Syntax.n in
      match uu____4513 with
      | FStar_Syntax_Syntax.Tm_fvar tc ->
          FStar_Ident.lid_equals
            (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v lid
      | uu____4518 -> false
let rec is_constructed_typ:
  FStar_Syntax_Syntax.term -> FStar_Ident.lident -> Prims.bool =
  fun t  ->
    fun lid  ->
      let uu____4527 =
        let uu____4528 = pre_typ t in uu____4528.FStar_Syntax_Syntax.n in
      match uu____4527 with
      | FStar_Syntax_Syntax.Tm_fvar uu____4531 -> is_constructor t lid
      | FStar_Syntax_Syntax.Tm_app (t1,uu____4533) ->
          is_constructed_typ t1 lid
      | FStar_Syntax_Syntax.Tm_uinst (t1,uu____4555) ->
          is_constructed_typ t1 lid
      | uu____4560 -> false
let rec get_tycon:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term FStar_Pervasives_Native.option
  =
  fun t  ->
    let t1 = pre_typ t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_bvar uu____4570 ->
        FStar_Pervasives_Native.Some t1
    | FStar_Syntax_Syntax.Tm_name uu____4571 ->
        FStar_Pervasives_Native.Some t1
    | FStar_Syntax_Syntax.Tm_fvar uu____4572 ->
        FStar_Pervasives_Native.Some t1
    | FStar_Syntax_Syntax.Tm_app (t2,uu____4574) -> get_tycon t2
    | uu____4595 -> FStar_Pervasives_Native.None
let is_interpreted: FStar_Ident.lident -> Prims.bool =
  fun l  ->
    let theory_syms =
      [FStar_Parser_Const.op_Eq;
      FStar_Parser_Const.op_notEq;
      FStar_Parser_Const.op_LT;
      FStar_Parser_Const.op_LTE;
      FStar_Parser_Const.op_GT;
      FStar_Parser_Const.op_GTE;
      FStar_Parser_Const.op_Subtraction;
      FStar_Parser_Const.op_Minus;
      FStar_Parser_Const.op_Addition;
      FStar_Parser_Const.op_Multiply;
      FStar_Parser_Const.op_Division;
      FStar_Parser_Const.op_Modulus;
      FStar_Parser_Const.op_And;
      FStar_Parser_Const.op_Or;
      FStar_Parser_Const.op_Negation] in
    FStar_Util.for_some (FStar_Ident.lid_equals l) theory_syms
let is_fstar_tactics_embed: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____4607 =
      let uu____4608 = un_uinst t in uu____4608.FStar_Syntax_Syntax.n in
    match uu____4607 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Syntax_Syntax.fv_eq_lid fv
          FStar_Parser_Const.fstar_refl_embed_lid
    | uu____4612 -> false
let is_fstar_tactics_quote: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____4617 =
      let uu____4618 = un_uinst t in uu____4618.FStar_Syntax_Syntax.n in
    match uu____4617 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.quote_lid
    | uu____4622 -> false
let is_fstar_tactics_by_tactic: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____4627 =
      let uu____4628 = un_uinst t in uu____4628.FStar_Syntax_Syntax.n in
    match uu____4627 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.by_tactic_lid
    | uu____4632 -> false
let ktype: FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_type FStar_Syntax_Syntax.U_unknown)
    FStar_Pervasives_Native.None FStar_Range.dummyRange
let ktype0: FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_type FStar_Syntax_Syntax.U_zero)
    FStar_Pervasives_Native.None FStar_Range.dummyRange
let type_u:
  Prims.unit ->
    (FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.universe)
      FStar_Pervasives_Native.tuple2
  =
  fun uu____4644  ->
    let u =
      let uu____4650 = FStar_Syntax_Unionfind.univ_fresh () in
      FStar_All.pipe_left (fun _0_29  -> FStar_Syntax_Syntax.U_unif _0_29)
        uu____4650 in
    let uu____4667 =
      FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_type u)
        FStar_Pervasives_Native.None FStar_Range.dummyRange in
    (uu____4667, u)
let attr_substitute: FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax =
  let uu____4674 =
    let uu____4677 =
      let uu____4678 =
        let uu____4679 =
          FStar_Ident.lid_of_path ["FStar"; "Pervasives"; "Substitute"]
            FStar_Range.dummyRange in
        FStar_Syntax_Syntax.lid_as_fv uu____4679
          FStar_Syntax_Syntax.Delta_constant FStar_Pervasives_Native.None in
      FStar_Syntax_Syntax.Tm_fvar uu____4678 in
    FStar_Syntax_Syntax.mk uu____4677 in
  uu____4674 FStar_Pervasives_Native.None FStar_Range.dummyRange
let exp_true_bool: FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_bool true))
    FStar_Pervasives_Native.None FStar_Range.dummyRange
let exp_false_bool: FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_bool false))
    FStar_Pervasives_Native.None FStar_Range.dummyRange
let exp_unit: FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_constant FStar_Const.Const_unit)
    FStar_Pervasives_Native.None FStar_Range.dummyRange
let exp_int: Prims.string -> FStar_Syntax_Syntax.term =
  fun s  ->
    FStar_Syntax_Syntax.mk
      (FStar_Syntax_Syntax.Tm_constant
         (FStar_Const.Const_int (s, FStar_Pervasives_Native.None)))
      FStar_Pervasives_Native.None FStar_Range.dummyRange
let exp_string: Prims.string -> FStar_Syntax_Syntax.term =
  fun s  ->
    FStar_Syntax_Syntax.mk
      (FStar_Syntax_Syntax.Tm_constant
         (FStar_Const.Const_string (s, FStar_Range.dummyRange)))
      FStar_Pervasives_Native.None FStar_Range.dummyRange
let fvar_const: FStar_Ident.lident -> FStar_Syntax_Syntax.term =
  fun l  ->
    FStar_Syntax_Syntax.fvar l FStar_Syntax_Syntax.Delta_constant
      FStar_Pervasives_Native.None
let tand: FStar_Syntax_Syntax.term = fvar_const FStar_Parser_Const.and_lid
let tor: FStar_Syntax_Syntax.term = fvar_const FStar_Parser_Const.or_lid
let timp: FStar_Syntax_Syntax.term =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.imp_lid
    (FStar_Syntax_Syntax.Delta_defined_at_level (Prims.parse_int "1"))
    FStar_Pervasives_Native.None
let tiff: FStar_Syntax_Syntax.term =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.iff_lid
    (FStar_Syntax_Syntax.Delta_defined_at_level (Prims.parse_int "2"))
    FStar_Pervasives_Native.None
let t_bool: FStar_Syntax_Syntax.term = fvar_const FStar_Parser_Const.bool_lid
let t_false: FStar_Syntax_Syntax.term =
  fvar_const FStar_Parser_Const.false_lid
let t_true: FStar_Syntax_Syntax.term = fvar_const FStar_Parser_Const.true_lid
let b2t_v: FStar_Syntax_Syntax.term = fvar_const FStar_Parser_Const.b2t_lid
let t_not: FStar_Syntax_Syntax.term = fvar_const FStar_Parser_Const.not_lid
let mk_conj_opt:
  FStar_Syntax_Syntax.term FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term FStar_Pervasives_Native.option
  =
  fun phi1  ->
    fun phi2  ->
      match phi1 with
      | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.Some phi2
      | FStar_Pervasives_Native.Some phi11 ->
          let uu____4728 =
            let uu____4731 =
              FStar_Range.union_ranges phi11.FStar_Syntax_Syntax.pos
                phi2.FStar_Syntax_Syntax.pos in
            let uu____4732 =
              let uu____4735 =
                let uu____4736 =
                  let uu____4751 =
                    let uu____4754 = FStar_Syntax_Syntax.as_arg phi11 in
                    let uu____4755 =
                      let uu____4758 = FStar_Syntax_Syntax.as_arg phi2 in
                      [uu____4758] in
                    uu____4754 :: uu____4755 in
                  (tand, uu____4751) in
                FStar_Syntax_Syntax.Tm_app uu____4736 in
              FStar_Syntax_Syntax.mk uu____4735 in
            uu____4732 FStar_Pervasives_Native.None uu____4731 in
          FStar_Pervasives_Native.Some uu____4728
let mk_binop:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun op_t  ->
    fun phi1  ->
      fun phi2  ->
        let uu____4784 =
          FStar_Range.union_ranges phi1.FStar_Syntax_Syntax.pos
            phi2.FStar_Syntax_Syntax.pos in
        let uu____4785 =
          let uu____4788 =
            let uu____4789 =
              let uu____4804 =
                let uu____4807 = FStar_Syntax_Syntax.as_arg phi1 in
                let uu____4808 =
                  let uu____4811 = FStar_Syntax_Syntax.as_arg phi2 in
                  [uu____4811] in
                uu____4807 :: uu____4808 in
              (op_t, uu____4804) in
            FStar_Syntax_Syntax.Tm_app uu____4789 in
          FStar_Syntax_Syntax.mk uu____4788 in
        uu____4785 FStar_Pervasives_Native.None uu____4784
let mk_neg:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun phi  ->
    let uu____4825 =
      let uu____4828 =
        let uu____4829 =
          let uu____4844 =
            let uu____4847 = FStar_Syntax_Syntax.as_arg phi in [uu____4847] in
          (t_not, uu____4844) in
        FStar_Syntax_Syntax.Tm_app uu____4829 in
      FStar_Syntax_Syntax.mk uu____4828 in
    uu____4825 FStar_Pervasives_Native.None phi.FStar_Syntax_Syntax.pos
let mk_conj:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  = fun phi1  -> fun phi2  -> mk_binop tand phi1 phi2
let mk_conj_l:
  FStar_Syntax_Syntax.term Prims.list -> FStar_Syntax_Syntax.term =
  fun phi  ->
    match phi with
    | [] ->
        FStar_Syntax_Syntax.fvar FStar_Parser_Const.true_lid
          FStar_Syntax_Syntax.Delta_constant FStar_Pervasives_Native.None
    | hd1::tl1 -> FStar_List.fold_right mk_conj tl1 hd1
let mk_disj:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  = fun phi1  -> fun phi2  -> mk_binop tor phi1 phi2
let mk_disj_l:
  FStar_Syntax_Syntax.term Prims.list -> FStar_Syntax_Syntax.term =
  fun phi  ->
    match phi with
    | [] -> t_false
    | hd1::tl1 -> FStar_List.fold_right mk_disj tl1 hd1
let mk_imp:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  = fun phi1  -> fun phi2  -> mk_binop timp phi1 phi2
let mk_iff:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  = fun phi1  -> fun phi2  -> mk_binop tiff phi1 phi2
let b2t:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun e  ->
    let uu____4919 =
      let uu____4922 =
        let uu____4923 =
          let uu____4938 =
            let uu____4941 = FStar_Syntax_Syntax.as_arg e in [uu____4941] in
          (b2t_v, uu____4938) in
        FStar_Syntax_Syntax.Tm_app uu____4923 in
      FStar_Syntax_Syntax.mk uu____4922 in
    uu____4919 FStar_Pervasives_Native.None e.FStar_Syntax_Syntax.pos
let teq: FStar_Syntax_Syntax.term = fvar_const FStar_Parser_Const.eq2_lid
let mk_untyped_eq2:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun e1  ->
    fun e2  ->
      let uu____4957 =
        FStar_Range.union_ranges e1.FStar_Syntax_Syntax.pos
          e2.FStar_Syntax_Syntax.pos in
      let uu____4958 =
        let uu____4961 =
          let uu____4962 =
            let uu____4977 =
              let uu____4980 = FStar_Syntax_Syntax.as_arg e1 in
              let uu____4981 =
                let uu____4984 = FStar_Syntax_Syntax.as_arg e2 in
                [uu____4984] in
              uu____4980 :: uu____4981 in
            (teq, uu____4977) in
          FStar_Syntax_Syntax.Tm_app uu____4962 in
        FStar_Syntax_Syntax.mk uu____4961 in
      uu____4958 FStar_Pervasives_Native.None uu____4957
let mk_eq2:
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  =
  fun u  ->
    fun t  ->
      fun e1  ->
        fun e2  ->
          let eq_inst = FStar_Syntax_Syntax.mk_Tm_uinst teq [u] in
          let uu____5007 =
            FStar_Range.union_ranges e1.FStar_Syntax_Syntax.pos
              e2.FStar_Syntax_Syntax.pos in
          let uu____5008 =
            let uu____5011 =
              let uu____5012 =
                let uu____5027 =
                  let uu____5030 = FStar_Syntax_Syntax.iarg t in
                  let uu____5031 =
                    let uu____5034 = FStar_Syntax_Syntax.as_arg e1 in
                    let uu____5035 =
                      let uu____5038 = FStar_Syntax_Syntax.as_arg e2 in
                      [uu____5038] in
                    uu____5034 :: uu____5035 in
                  uu____5030 :: uu____5031 in
                (eq_inst, uu____5027) in
              FStar_Syntax_Syntax.Tm_app uu____5012 in
            FStar_Syntax_Syntax.mk uu____5011 in
          uu____5008 FStar_Pervasives_Native.None uu____5007
let mk_has_type:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun t  ->
    fun x  ->
      fun t'  ->
        let t_has_type = fvar_const FStar_Parser_Const.has_type_lid in
        let t_has_type1 =
          FStar_Syntax_Syntax.mk
            (FStar_Syntax_Syntax.Tm_uinst
               (t_has_type,
                 [FStar_Syntax_Syntax.U_zero; FStar_Syntax_Syntax.U_zero]))
            FStar_Pervasives_Native.None FStar_Range.dummyRange in
        let uu____5064 =
          let uu____5067 =
            let uu____5068 =
              let uu____5083 =
                let uu____5086 = FStar_Syntax_Syntax.iarg t in
                let uu____5087 =
                  let uu____5090 = FStar_Syntax_Syntax.as_arg x in
                  let uu____5091 =
                    let uu____5094 = FStar_Syntax_Syntax.as_arg t' in
                    [uu____5094] in
                  uu____5090 :: uu____5091 in
                uu____5086 :: uu____5087 in
              (t_has_type1, uu____5083) in
            FStar_Syntax_Syntax.Tm_app uu____5068 in
          FStar_Syntax_Syntax.mk uu____5067 in
        uu____5064 FStar_Pervasives_Native.None FStar_Range.dummyRange
let lex_t: FStar_Syntax_Syntax.term = fvar_const FStar_Parser_Const.lex_t_lid
let lex_top: FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax =
  let uu____5104 =
    let uu____5107 =
      let uu____5108 =
        let uu____5115 =
          FStar_Syntax_Syntax.fvar FStar_Parser_Const.lextop_lid
            FStar_Syntax_Syntax.Delta_constant
            (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor) in
        (uu____5115, [FStar_Syntax_Syntax.U_zero]) in
      FStar_Syntax_Syntax.Tm_uinst uu____5108 in
    FStar_Syntax_Syntax.mk uu____5107 in
  uu____5104 FStar_Pervasives_Native.None FStar_Range.dummyRange
let lex_pair: FStar_Syntax_Syntax.term =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.lexcons_lid
    FStar_Syntax_Syntax.Delta_constant
    (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor)
let tforall: FStar_Syntax_Syntax.term =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.forall_lid
    (FStar_Syntax_Syntax.Delta_defined_at_level (Prims.parse_int "1"))
    FStar_Pervasives_Native.None
let t_haseq: FStar_Syntax_Syntax.term =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.haseq_lid
    FStar_Syntax_Syntax.Delta_constant FStar_Pervasives_Native.None
let lcomp_of_comp:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.lcomp
  =
  fun c0  ->
    let uu____5129 =
      match c0.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Total uu____5142 ->
          (FStar_Parser_Const.effect_Tot_lid, [FStar_Syntax_Syntax.TOTAL])
      | FStar_Syntax_Syntax.GTotal uu____5153 ->
          (FStar_Parser_Const.effect_GTot_lid,
            [FStar_Syntax_Syntax.SOMETRIVIAL])
      | FStar_Syntax_Syntax.Comp c ->
          ((c.FStar_Syntax_Syntax.effect_name),
            (c.FStar_Syntax_Syntax.flags)) in
    match uu____5129 with
    | (eff_name,flags) ->
        {
          FStar_Syntax_Syntax.eff_name = eff_name;
          FStar_Syntax_Syntax.res_typ = (comp_result c0);
          FStar_Syntax_Syntax.cflags = flags;
          FStar_Syntax_Syntax.comp = ((fun uu____5174  -> c0))
        }
let mk_residual_comp:
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
      FStar_Pervasives_Native.option ->
      FStar_Syntax_Syntax.cflags Prims.list ->
        FStar_Syntax_Syntax.residual_comp
  =
  fun l  ->
    fun t  ->
      fun f  ->
        {
          FStar_Syntax_Syntax.residual_effect = l;
          FStar_Syntax_Syntax.residual_typ = t;
          FStar_Syntax_Syntax.residual_flags = f
        }
let residual_tot:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.residual_comp
  =
  fun t  ->
    {
      FStar_Syntax_Syntax.residual_effect = FStar_Parser_Const.effect_Tot_lid;
      FStar_Syntax_Syntax.residual_typ = (FStar_Pervasives_Native.Some t);
      FStar_Syntax_Syntax.residual_flags = [FStar_Syntax_Syntax.TOTAL]
    }
let residual_comp_of_comp:
  FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.residual_comp =
  fun c  ->
    {
      FStar_Syntax_Syntax.residual_effect = (comp_effect_name c);
      FStar_Syntax_Syntax.residual_typ =
        (FStar_Pervasives_Native.Some (comp_result c));
      FStar_Syntax_Syntax.residual_flags = (comp_flags c)
    }
let residual_comp_of_lcomp:
  FStar_Syntax_Syntax.lcomp -> FStar_Syntax_Syntax.residual_comp =
  fun lc  ->
    {
      FStar_Syntax_Syntax.residual_effect = (lc.FStar_Syntax_Syntax.eff_name);
      FStar_Syntax_Syntax.residual_typ =
        (FStar_Pervasives_Native.Some (lc.FStar_Syntax_Syntax.res_typ));
      FStar_Syntax_Syntax.residual_flags = (lc.FStar_Syntax_Syntax.cflags)
    }
let mk_forall_aux:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.bv ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun fa  ->
    fun x  ->
      fun body  ->
        let uu____5239 =
          let uu____5242 =
            let uu____5243 =
              let uu____5258 =
                let uu____5261 =
                  FStar_Syntax_Syntax.iarg x.FStar_Syntax_Syntax.sort in
                let uu____5262 =
                  let uu____5265 =
                    let uu____5266 =
                      let uu____5267 =
                        let uu____5268 = FStar_Syntax_Syntax.mk_binder x in
                        [uu____5268] in
                      abs uu____5267 body
                        (FStar_Pervasives_Native.Some (residual_tot ktype0)) in
                    FStar_Syntax_Syntax.as_arg uu____5266 in
                  [uu____5265] in
                uu____5261 :: uu____5262 in
              (fa, uu____5258) in
            FStar_Syntax_Syntax.Tm_app uu____5243 in
          FStar_Syntax_Syntax.mk uu____5242 in
        uu____5239 FStar_Pervasives_Native.None FStar_Range.dummyRange
let mk_forall_no_univ:
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ
  = fun x  -> fun body  -> mk_forall_aux tforall x body
let mk_forall:
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.bv ->
      FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ
  =
  fun u  ->
    fun x  ->
      fun body  ->
        let tforall1 = FStar_Syntax_Syntax.mk_Tm_uinst tforall [u] in
        mk_forall_aux tforall1 x body
let close_forall_no_univs:
  FStar_Syntax_Syntax.binder Prims.list ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ
  =
  fun bs  ->
    fun f  ->
      FStar_List.fold_right
        (fun b  ->
           fun f1  ->
             let uu____5314 = FStar_Syntax_Syntax.is_null_binder b in
             if uu____5314
             then f1
             else mk_forall_no_univ (FStar_Pervasives_Native.fst b) f1) bs f
let rec is_wild_pat:
  FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t -> Prims.bool =
  fun p  ->
    match p.FStar_Syntax_Syntax.v with
    | FStar_Syntax_Syntax.Pat_wild uu____5324 -> true
    | uu____5325 -> false
let if_then_else:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun b  ->
    fun t1  ->
      fun t2  ->
        let then_branch =
          let uu____5367 =
            FStar_Syntax_Syntax.withinfo
              (FStar_Syntax_Syntax.Pat_constant (FStar_Const.Const_bool true))
              t1.FStar_Syntax_Syntax.pos in
          (uu____5367, FStar_Pervasives_Native.None, t1) in
        let else_branch =
          let uu____5395 =
            FStar_Syntax_Syntax.withinfo
              (FStar_Syntax_Syntax.Pat_constant
                 (FStar_Const.Const_bool false)) t2.FStar_Syntax_Syntax.pos in
          (uu____5395, FStar_Pervasives_Native.None, t2) in
        let uu____5408 =
          let uu____5409 =
            FStar_Range.union_ranges t1.FStar_Syntax_Syntax.pos
              t2.FStar_Syntax_Syntax.pos in
          FStar_Range.union_ranges b.FStar_Syntax_Syntax.pos uu____5409 in
        FStar_Syntax_Syntax.mk
          (FStar_Syntax_Syntax.Tm_match (b, [then_branch; else_branch]))
          FStar_Pervasives_Native.None uu____5408
let mk_squash:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun p  ->
    let sq =
      FStar_Syntax_Syntax.fvar FStar_Parser_Const.squash_lid
        (FStar_Syntax_Syntax.Delta_defined_at_level (Prims.parse_int "1"))
        FStar_Pervasives_Native.None in
    let uu____5477 =
      FStar_Syntax_Syntax.mk_Tm_uinst sq [FStar_Syntax_Syntax.U_zero] in
    let uu____5480 =
      let uu____5489 = FStar_Syntax_Syntax.as_arg p in [uu____5489] in
    mk_app uu____5477 uu____5480
let un_squash:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
      FStar_Pervasives_Native.option
  =
  fun t  ->
    let uu____5498 = head_and_args t in
    match uu____5498 with
    | (head1,args) ->
        let uu____5539 =
          let uu____5552 =
            let uu____5553 = un_uinst head1 in
            uu____5553.FStar_Syntax_Syntax.n in
          (uu____5552, args) in
        (match uu____5539 with
         | (FStar_Syntax_Syntax.Tm_fvar fv,(p,uu____5570)::[]) when
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.squash_lid
             -> FStar_Pervasives_Native.Some p
         | (FStar_Syntax_Syntax.Tm_refine (b,p),[]) ->
             (match (b.FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.n with
              | FStar_Syntax_Syntax.Tm_fvar fv when
                  FStar_Syntax_Syntax.fv_eq_lid fv
                    FStar_Parser_Const.unit_lid
                  ->
                  let uu____5622 =
                    let uu____5627 =
                      let uu____5628 = FStar_Syntax_Syntax.mk_binder b in
                      [uu____5628] in
                    FStar_Syntax_Subst.open_term uu____5627 p in
                  (match uu____5622 with
                   | (bs,p1) ->
                       let b1 =
                         match bs with
                         | b1::[] -> b1
                         | uu____5657 -> failwith "impossible" in
                       let uu____5662 =
                         let uu____5663 = FStar_Syntax_Free.names p1 in
                         FStar_Util.set_mem (FStar_Pervasives_Native.fst b1)
                           uu____5663 in
                       if uu____5662
                       then FStar_Pervasives_Native.None
                       else FStar_Pervasives_Native.Some p1)
              | uu____5673 -> FStar_Pervasives_Native.None)
         | uu____5676 -> FStar_Pervasives_Native.None)
let arrow_one:
  FStar_Syntax_Syntax.typ ->
    (FStar_Syntax_Syntax.binder,FStar_Syntax_Syntax.comp)
      FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option
  =
  fun t  ->
    let uu____5707 =
      let uu____5720 =
        let uu____5721 = FStar_Syntax_Subst.compress t in
        uu____5721.FStar_Syntax_Syntax.n in
      match uu____5720 with
      | FStar_Syntax_Syntax.Tm_arrow ([],c) ->
          failwith "fatal: empty binders on arrow?"
      | FStar_Syntax_Syntax.Tm_arrow (b::[],c) ->
          FStar_Pervasives_Native.Some (b, c)
      | FStar_Syntax_Syntax.Tm_arrow (b::bs,c) ->
          let uu____5830 =
            let uu____5839 =
              let uu____5840 = arrow bs c in
              FStar_Syntax_Syntax.mk_Total uu____5840 in
            (b, uu____5839) in
          FStar_Pervasives_Native.Some uu____5830
      | uu____5853 -> FStar_Pervasives_Native.None in
    FStar_Util.bind_opt uu____5707
      (fun uu____5889  ->
         match uu____5889 with
         | (b,c) ->
             let uu____5924 = FStar_Syntax_Subst.open_comp [b] c in
             (match uu____5924 with
              | (bs,c1) ->
                  let b1 =
                    match bs with
                    | b1::[] -> b1
                    | uu____5971 ->
                        failwith
                          "impossible: open_comp returned different amount of binders" in
                  FStar_Pervasives_Native.Some (b1, c1)))
let is_free_in:
  FStar_Syntax_Syntax.bv -> FStar_Syntax_Syntax.term -> Prims.bool =
  fun bv  ->
    fun t  ->
      let uu____5996 = FStar_Syntax_Free.names t in
      FStar_Util.set_mem bv uu____5996
type qpats = FStar_Syntax_Syntax.args Prims.list[@@deriving show]
type connective =
  | QAll of (FStar_Syntax_Syntax.binders,qpats,FStar_Syntax_Syntax.typ)
  FStar_Pervasives_Native.tuple3
  | QEx of (FStar_Syntax_Syntax.binders,qpats,FStar_Syntax_Syntax.typ)
  FStar_Pervasives_Native.tuple3
  | BaseConn of (FStar_Ident.lident,FStar_Syntax_Syntax.args)
  FStar_Pervasives_Native.tuple2[@@deriving show]
let uu___is_QAll: connective -> Prims.bool =
  fun projectee  ->
    match projectee with | QAll _0 -> true | uu____6040 -> false
let __proj__QAll__item___0:
  connective ->
    (FStar_Syntax_Syntax.binders,qpats,FStar_Syntax_Syntax.typ)
      FStar_Pervasives_Native.tuple3
  = fun projectee  -> match projectee with | QAll _0 -> _0
let uu___is_QEx: connective -> Prims.bool =
  fun projectee  ->
    match projectee with | QEx _0 -> true | uu____6078 -> false
let __proj__QEx__item___0:
  connective ->
    (FStar_Syntax_Syntax.binders,qpats,FStar_Syntax_Syntax.typ)
      FStar_Pervasives_Native.tuple3
  = fun projectee  -> match projectee with | QEx _0 -> _0
let uu___is_BaseConn: connective -> Prims.bool =
  fun projectee  ->
    match projectee with | BaseConn _0 -> true | uu____6114 -> false
let __proj__BaseConn__item___0:
  connective ->
    (FStar_Ident.lident,FStar_Syntax_Syntax.args)
      FStar_Pervasives_Native.tuple2
  = fun projectee  -> match projectee with | BaseConn _0 -> _0
let destruct_typ_as_formula:
  FStar_Syntax_Syntax.term -> connective FStar_Pervasives_Native.option =
  fun f  ->
    let rec unmeta_monadic f1 =
      let f2 = FStar_Syntax_Subst.compress f1 in
      match f2.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_meta
          (t,FStar_Syntax_Syntax.Meta_monadic uu____6149) -> unmeta_monadic t
      | FStar_Syntax_Syntax.Tm_meta
          (t,FStar_Syntax_Syntax.Meta_monadic_lift uu____6161) ->
          unmeta_monadic t
      | uu____6174 -> f2 in
    let destruct_base_conn f1 =
      let connectives =
        [(FStar_Parser_Const.true_lid, (Prims.parse_int "0"));
        (FStar_Parser_Const.false_lid, (Prims.parse_int "0"));
        (FStar_Parser_Const.and_lid, (Prims.parse_int "2"));
        (FStar_Parser_Const.or_lid, (Prims.parse_int "2"));
        (FStar_Parser_Const.imp_lid, (Prims.parse_int "2"));
        (FStar_Parser_Const.iff_lid, (Prims.parse_int "2"));
        (FStar_Parser_Const.ite_lid, (Prims.parse_int "3"));
        (FStar_Parser_Const.not_lid, (Prims.parse_int "1"));
        (FStar_Parser_Const.eq2_lid, (Prims.parse_int "3"));
        (FStar_Parser_Const.eq2_lid, (Prims.parse_int "2"));
        (FStar_Parser_Const.eq3_lid, (Prims.parse_int "4"));
        (FStar_Parser_Const.eq3_lid, (Prims.parse_int "2"))] in
      let aux f2 uu____6252 =
        match uu____6252 with
        | (lid,arity) ->
            let uu____6261 =
              let uu____6276 = unmeta_monadic f2 in head_and_args uu____6276 in
            (match uu____6261 with
             | (t,args) ->
                 let t1 = un_uinst t in
                 let uu____6302 =
                   (is_constructor t1 lid) &&
                     ((FStar_List.length args) = arity) in
                 if uu____6302
                 then FStar_Pervasives_Native.Some (BaseConn (lid, args))
                 else FStar_Pervasives_Native.None) in
      FStar_Util.find_map connectives (aux f1) in
    let patterns t =
      let t1 = FStar_Syntax_Subst.compress t in
      match t1.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_meta
          (t2,FStar_Syntax_Syntax.Meta_pattern pats) ->
          let uu____6377 = FStar_Syntax_Subst.compress t2 in
          (pats, uu____6377)
      | uu____6388 ->
          let uu____6389 = FStar_Syntax_Subst.compress t1 in ([], uu____6389) in
    let destruct_q_conn t =
      let is_q fa fv =
        if fa
        then is_forall (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
        else is_exists (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
      let flat t1 =
        let uu____6436 = head_and_args t1 in
        match uu____6436 with
        | (t2,args) ->
            let uu____6483 = un_uinst t2 in
            let uu____6484 =
              FStar_All.pipe_right args
                (FStar_List.map
                   (fun uu____6517  ->
                      match uu____6517 with
                      | (t3,imp) ->
                          let uu____6528 = unascribe t3 in (uu____6528, imp))) in
            (uu____6483, uu____6484) in
      let rec aux qopt out t1 =
        let uu____6563 = let uu____6580 = flat t1 in (qopt, uu____6580) in
        match uu____6563 with
        | (FStar_Pervasives_Native.Some
           fa,({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar tc;
                 FStar_Syntax_Syntax.pos = uu____6607;
                 FStar_Syntax_Syntax.vars = uu____6608;_},({
                                                             FStar_Syntax_Syntax.n
                                                               =
                                                               FStar_Syntax_Syntax.Tm_abs
                                                               (b::[],t2,uu____6611);
                                                             FStar_Syntax_Syntax.pos
                                                               = uu____6612;
                                                             FStar_Syntax_Syntax.vars
                                                               = uu____6613;_},uu____6614)::[]))
            when is_q fa tc -> aux qopt (b :: out) t2
        | (FStar_Pervasives_Native.Some
           fa,({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar tc;
                 FStar_Syntax_Syntax.pos = uu____6691;
                 FStar_Syntax_Syntax.vars = uu____6692;_},uu____6693::
               ({
                  FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_abs
                    (b::[],t2,uu____6696);
                  FStar_Syntax_Syntax.pos = uu____6697;
                  FStar_Syntax_Syntax.vars = uu____6698;_},uu____6699)::[]))
            when is_q fa tc -> aux qopt (b :: out) t2
        | (FStar_Pervasives_Native.None
           ,({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar tc;
               FStar_Syntax_Syntax.pos = uu____6787;
               FStar_Syntax_Syntax.vars = uu____6788;_},({
                                                           FStar_Syntax_Syntax.n
                                                             =
                                                             FStar_Syntax_Syntax.Tm_abs
                                                             (b::[],t2,uu____6791);
                                                           FStar_Syntax_Syntax.pos
                                                             = uu____6792;
                                                           FStar_Syntax_Syntax.vars
                                                             = uu____6793;_},uu____6794)::[]))
            when
            is_qlid (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v ->
            aux
              (FStar_Pervasives_Native.Some
                 (is_forall
                    (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v))
              (b :: out) t2
        | (FStar_Pervasives_Native.None
           ,({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar tc;
               FStar_Syntax_Syntax.pos = uu____6870;
               FStar_Syntax_Syntax.vars = uu____6871;_},uu____6872::({
                                                                    FStar_Syntax_Syntax.n
                                                                    =
                                                                    FStar_Syntax_Syntax.Tm_abs
                                                                    (b::[],t2,uu____6875);
                                                                    FStar_Syntax_Syntax.pos
                                                                    =
                                                                    uu____6876;
                                                                    FStar_Syntax_Syntax.vars
                                                                    =
                                                                    uu____6877;_},uu____6878)::[]))
            when
            is_qlid (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v ->
            aux
              (FStar_Pervasives_Native.Some
                 (is_forall
                    (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v))
              (b :: out) t2
        | (FStar_Pervasives_Native.Some b,uu____6966) ->
            let bs = FStar_List.rev out in
            let uu____7000 = FStar_Syntax_Subst.open_term bs t1 in
            (match uu____7000 with
             | (bs1,t2) ->
                 let uu____7009 = patterns t2 in
                 (match uu____7009 with
                  | (pats,body) ->
                      if b
                      then
                        FStar_Pervasives_Native.Some (QAll (bs1, pats, body))
                      else
                        FStar_Pervasives_Native.Some (QEx (bs1, pats, body))))
        | uu____7071 -> FStar_Pervasives_Native.None in
      aux FStar_Pervasives_Native.None [] t in
    let u_connectives =
      [(FStar_Parser_Const.true_lid, FStar_Parser_Const.c_true_lid,
         (Prims.parse_int "0"));
      (FStar_Parser_Const.false_lid, FStar_Parser_Const.c_false_lid,
        (Prims.parse_int "0"));
      (FStar_Parser_Const.and_lid, FStar_Parser_Const.c_and_lid,
        (Prims.parse_int "2"));
      (FStar_Parser_Const.or_lid, FStar_Parser_Const.c_or_lid,
        (Prims.parse_int "2"))] in
    let destruct_sq_base_conn t =
      let uu____7137 = un_squash t in
      FStar_Util.bind_opt uu____7137
        (fun t1  ->
           let uu____7153 = head_and_args' t1 in
           match uu____7153 with
           | (hd1,args) ->
               let uu____7186 =
                 let uu____7191 =
                   let uu____7192 = un_uinst hd1 in
                   uu____7192.FStar_Syntax_Syntax.n in
                 (uu____7191, (FStar_List.length args)) in
               (match uu____7186 with
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_30) when
                    (_0_30 = (Prims.parse_int "2")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_and_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.and_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_31) when
                    (_0_31 = (Prims.parse_int "2")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_or_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.or_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_32) when
                    (_0_32 = (Prims.parse_int "2")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_eq2_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.eq2_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_33) when
                    (_0_33 = (Prims.parse_int "3")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_eq2_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.eq2_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_34) when
                    (_0_34 = (Prims.parse_int "2")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_eq3_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.eq3_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_35) when
                    (_0_35 = (Prims.parse_int "4")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_eq3_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.eq3_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_36) when
                    (_0_36 = (Prims.parse_int "0")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_true_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.true_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_37) when
                    (_0_37 = (Prims.parse_int "0")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_false_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.false_lid, args))
                | uu____7275 -> FStar_Pervasives_Native.None)) in
    let rec destruct_sq_forall t =
      let uu____7298 = un_squash t in
      FStar_Util.bind_opt uu____7298
        (fun t1  ->
           let uu____7313 = arrow_one t1 in
           match uu____7313 with
           | FStar_Pervasives_Native.Some (b,c) ->
               let uu____7328 =
                 let uu____7329 = is_tot_or_gtot_comp c in
                 Prims.op_Negation uu____7329 in
               if uu____7328
               then FStar_Pervasives_Native.None
               else
                 (let q =
                    let uu____7336 = comp_to_comp_typ c in
                    uu____7336.FStar_Syntax_Syntax.result_typ in
                  let uu____7337 = FStar_Syntax_Subst.open_term [b] q in
                  match uu____7337 with
                  | (bs,q1) ->
                      let b1 =
                        match bs with
                        | b1::[] -> b1
                        | uu____7368 -> failwith "impossible" in
                      let uu____7373 =
                        is_free_in (FStar_Pervasives_Native.fst b1) q1 in
                      if uu____7373
                      then
                        let uu____7376 = patterns q1 in
                        (match uu____7376 with
                         | (pats,q2) ->
                             FStar_All.pipe_left maybe_collect
                               (FStar_Pervasives_Native.Some
                                  (QAll ([b1], pats, q2))))
                      else
                        (let uu____7444 =
                           let uu____7445 =
                             let uu____7450 =
                               let uu____7453 =
                                 FStar_Syntax_Syntax.as_arg
                                   (FStar_Pervasives_Native.fst b1).FStar_Syntax_Syntax.sort in
                               let uu____7454 =
                                 let uu____7457 =
                                   FStar_Syntax_Syntax.as_arg q1 in
                                 [uu____7457] in
                               uu____7453 :: uu____7454 in
                             (FStar_Parser_Const.imp_lid, uu____7450) in
                           BaseConn uu____7445 in
                         FStar_Pervasives_Native.Some uu____7444))
           | uu____7460 -> FStar_Pervasives_Native.None)
    and destruct_sq_exists t =
      let uu____7468 = un_squash t in
      FStar_Util.bind_opt uu____7468
        (fun t1  ->
           let uu____7499 = head_and_args' t1 in
           match uu____7499 with
           | (hd1,args) ->
               let uu____7532 =
                 let uu____7545 =
                   let uu____7546 = un_uinst hd1 in
                   uu____7546.FStar_Syntax_Syntax.n in
                 (uu____7545, args) in
               (match uu____7532 with
                | (FStar_Syntax_Syntax.Tm_fvar
                   fv,(a1,uu____7561)::(a2,uu____7563)::[]) when
                    FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Parser_Const.dtuple2_lid
                    ->
                    let uu____7598 =
                      let uu____7599 = FStar_Syntax_Subst.compress a2 in
                      uu____7599.FStar_Syntax_Syntax.n in
                    (match uu____7598 with
                     | FStar_Syntax_Syntax.Tm_abs (b::[],q,uu____7606) ->
                         let uu____7633 = FStar_Syntax_Subst.open_term [b] q in
                         (match uu____7633 with
                          | (bs,q1) ->
                              let b1 =
                                match bs with
                                | b1::[] -> b1
                                | uu____7672 -> failwith "impossible" in
                              let uu____7677 = patterns q1 in
                              (match uu____7677 with
                               | (pats,q2) ->
                                   FStar_All.pipe_left maybe_collect
                                     (FStar_Pervasives_Native.Some
                                        (QEx ([b1], pats, q2)))))
                     | uu____7744 -> FStar_Pervasives_Native.None)
                | uu____7745 -> FStar_Pervasives_Native.None))
    and maybe_collect f1 =
      match f1 with
      | FStar_Pervasives_Native.Some (QAll (bs,pats,phi)) ->
          let uu____7766 = destruct_sq_forall phi in
          (match uu____7766 with
           | FStar_Pervasives_Native.Some (QAll (bs',pats',psi)) ->
               FStar_All.pipe_left
                 (fun _0_38  -> FStar_Pervasives_Native.Some _0_38)
                 (QAll
                    ((FStar_List.append bs bs'),
                      (FStar_List.append pats pats'), psi))
           | uu____7788 -> f1)
      | FStar_Pervasives_Native.Some (QEx (bs,pats,phi)) ->
          let uu____7794 = destruct_sq_exists phi in
          (match uu____7794 with
           | FStar_Pervasives_Native.Some (QEx (bs',pats',psi)) ->
               FStar_All.pipe_left
                 (fun _0_39  -> FStar_Pervasives_Native.Some _0_39)
                 (QEx
                    ((FStar_List.append bs bs'),
                      (FStar_List.append pats pats'), psi))
           | uu____7816 -> f1)
      | uu____7819 -> f1 in
    let phi = unmeta_monadic f in
    let uu____7823 = destruct_base_conn phi in
    FStar_Util.catch_opt uu____7823
      (fun uu____7828  ->
         let uu____7829 = destruct_q_conn phi in
         FStar_Util.catch_opt uu____7829
           (fun uu____7834  ->
              let uu____7835 = destruct_sq_base_conn phi in
              FStar_Util.catch_opt uu____7835
                (fun uu____7840  ->
                   let uu____7841 = destruct_sq_forall phi in
                   FStar_Util.catch_opt uu____7841
                     (fun uu____7846  ->
                        let uu____7847 = destruct_sq_exists phi in
                        FStar_Util.catch_opt uu____7847
                          (fun uu____7851  -> FStar_Pervasives_Native.None)))))
let action_as_lb:
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.action -> FStar_Syntax_Syntax.sigelt
  =
  fun eff_lid  ->
    fun a  ->
      let lb =
        let uu____7861 =
          let uu____7866 =
            FStar_Syntax_Syntax.lid_as_fv a.FStar_Syntax_Syntax.action_name
              FStar_Syntax_Syntax.Delta_equational
              FStar_Pervasives_Native.None in
          FStar_Util.Inr uu____7866 in
        let uu____7867 =
          let uu____7868 =
            FStar_Syntax_Syntax.mk_Total a.FStar_Syntax_Syntax.action_typ in
          arrow a.FStar_Syntax_Syntax.action_params uu____7868 in
        let uu____7871 =
          abs a.FStar_Syntax_Syntax.action_params
            a.FStar_Syntax_Syntax.action_defn FStar_Pervasives_Native.None in
        close_univs_and_mk_letbinding FStar_Pervasives_Native.None uu____7861
          a.FStar_Syntax_Syntax.action_univs uu____7867
          FStar_Parser_Const.effect_Tot_lid uu____7871 in
      {
        FStar_Syntax_Syntax.sigel =
          (FStar_Syntax_Syntax.Sig_let
             ((false, [lb]), [a.FStar_Syntax_Syntax.action_name]));
        FStar_Syntax_Syntax.sigrng =
          ((a.FStar_Syntax_Syntax.action_defn).FStar_Syntax_Syntax.pos);
        FStar_Syntax_Syntax.sigquals =
          [FStar_Syntax_Syntax.Visible_default;
          FStar_Syntax_Syntax.Action eff_lid];
        FStar_Syntax_Syntax.sigmeta = FStar_Syntax_Syntax.default_sigmeta;
        FStar_Syntax_Syntax.sigattrs = []
      }
let mk_reify:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun t  ->
    let reify_ =
      FStar_Syntax_Syntax.mk
        (FStar_Syntax_Syntax.Tm_constant FStar_Const.Const_reify)
        FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos in
    let uu____7897 =
      let uu____7900 =
        let uu____7901 =
          let uu____7916 =
            let uu____7919 = FStar_Syntax_Syntax.as_arg t in [uu____7919] in
          (reify_, uu____7916) in
        FStar_Syntax_Syntax.Tm_app uu____7901 in
      FStar_Syntax_Syntax.mk uu____7900 in
    uu____7897 FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
let rec delta_qualifier:
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.delta_depth =
  fun t  ->
    let t1 = FStar_Syntax_Subst.compress t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_delayed uu____7932 -> failwith "Impossible"
    | FStar_Syntax_Syntax.Tm_fvar fv -> fv.FStar_Syntax_Syntax.fv_delta
    | FStar_Syntax_Syntax.Tm_bvar uu____7958 ->
        FStar_Syntax_Syntax.Delta_equational
    | FStar_Syntax_Syntax.Tm_name uu____7959 ->
        FStar_Syntax_Syntax.Delta_equational
    | FStar_Syntax_Syntax.Tm_match uu____7960 ->
        FStar_Syntax_Syntax.Delta_equational
    | FStar_Syntax_Syntax.Tm_uvar uu____7983 ->
        FStar_Syntax_Syntax.Delta_equational
    | FStar_Syntax_Syntax.Tm_unknown  -> FStar_Syntax_Syntax.Delta_equational
    | FStar_Syntax_Syntax.Tm_type uu____8000 ->
        FStar_Syntax_Syntax.Delta_constant
    | FStar_Syntax_Syntax.Tm_constant uu____8001 ->
        FStar_Syntax_Syntax.Delta_constant
    | FStar_Syntax_Syntax.Tm_arrow uu____8002 ->
        FStar_Syntax_Syntax.Delta_constant
    | FStar_Syntax_Syntax.Tm_uinst (t2,uu____8016) -> delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_refine
        ({ FStar_Syntax_Syntax.ppname = uu____8021;
           FStar_Syntax_Syntax.index = uu____8022;
           FStar_Syntax_Syntax.sort = t2;_},uu____8024)
        -> delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_meta (t2,uu____8032) -> delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_ascribed (t2,uu____8038,uu____8039) ->
        delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_app (t2,uu____8081) -> delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_abs (uu____8102,t2,uu____8104) ->
        delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_let (uu____8125,t2) -> delta_qualifier t2
let rec incr_delta_depth:
  FStar_Syntax_Syntax.delta_depth -> FStar_Syntax_Syntax.delta_depth =
  fun d  ->
    match d with
    | FStar_Syntax_Syntax.Delta_equational  -> d
    | FStar_Syntax_Syntax.Delta_constant  ->
        FStar_Syntax_Syntax.Delta_defined_at_level (Prims.parse_int "1")
    | FStar_Syntax_Syntax.Delta_defined_at_level i ->
        FStar_Syntax_Syntax.Delta_defined_at_level
          (i + (Prims.parse_int "1"))
    | FStar_Syntax_Syntax.Delta_abstract d1 -> incr_delta_depth d1
let incr_delta_qualifier:
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.delta_depth =
  fun t  -> let uu____8153 = delta_qualifier t in incr_delta_depth uu____8153
let is_unknown: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____8158 =
      let uu____8159 = FStar_Syntax_Subst.compress t in
      uu____8159.FStar_Syntax_Syntax.n in
    match uu____8158 with
    | FStar_Syntax_Syntax.Tm_unknown  -> true
    | uu____8162 -> false
let rec list_elements:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term Prims.list FStar_Pervasives_Native.option
  =
  fun e  ->
    let uu____8175 = let uu____8190 = unmeta e in head_and_args uu____8190 in
    match uu____8175 with
    | (head1,args) ->
        let uu____8217 =
          let uu____8230 =
            let uu____8231 = un_uinst head1 in
            uu____8231.FStar_Syntax_Syntax.n in
          (uu____8230, args) in
        (match uu____8217 with
         | (FStar_Syntax_Syntax.Tm_fvar fv,uu____8247) when
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.nil_lid ->
             FStar_Pervasives_Native.Some []
         | (FStar_Syntax_Syntax.Tm_fvar
            fv,uu____8267::(hd1,uu____8269)::(tl1,uu____8271)::[]) when
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.cons_lid ->
             let uu____8318 =
               let uu____8323 =
                 let uu____8328 = list_elements tl1 in
                 FStar_Util.must uu____8328 in
               hd1 :: uu____8323 in
             FStar_Pervasives_Native.Some uu____8318
         | uu____8341 -> FStar_Pervasives_Native.None)
let rec apply_last:
  'Auu____8362 .
    ('Auu____8362 -> 'Auu____8362) ->
      'Auu____8362 Prims.list -> 'Auu____8362 Prims.list
  =
  fun f  ->
    fun l  ->
      match l with
      | [] -> failwith "apply_last: got empty list"
      | a::[] -> let uu____8385 = f a in [uu____8385]
      | x::xs -> let uu____8390 = apply_last f xs in x :: uu____8390
let dm4f_lid:
  FStar_Syntax_Syntax.eff_decl -> Prims.string -> FStar_Ident.lident =
  fun ed  ->
    fun name  ->
      let p = FStar_Ident.path_of_lid ed.FStar_Syntax_Syntax.mname in
      let p' =
        apply_last
          (fun s  ->
             Prims.strcat "_dm4f_" (Prims.strcat s (Prims.strcat "_" name)))
          p in
      FStar_Ident.lid_of_path p' FStar_Range.dummyRange
let rec mk_list:
  FStar_Syntax_Syntax.term ->
    FStar_Range.range ->
      FStar_Syntax_Syntax.term Prims.list -> FStar_Syntax_Syntax.term
  =
  fun typ  ->
    fun rng  ->
      fun l  ->
        let ctor l1 =
          let uu____8431 =
            let uu____8434 =
              let uu____8435 =
                FStar_Syntax_Syntax.lid_as_fv l1
                  FStar_Syntax_Syntax.Delta_constant
                  (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor) in
              FStar_Syntax_Syntax.Tm_fvar uu____8435 in
            FStar_Syntax_Syntax.mk uu____8434 in
          uu____8431 FStar_Pervasives_Native.None rng in
        let cons1 args pos =
          let uu____8448 =
            let uu____8449 =
              let uu____8450 = ctor FStar_Parser_Const.cons_lid in
              FStar_Syntax_Syntax.mk_Tm_uinst uu____8450
                [FStar_Syntax_Syntax.U_zero] in
            FStar_Syntax_Syntax.mk_Tm_app uu____8449 args in
          uu____8448 FStar_Pervasives_Native.None pos in
        let nil args pos =
          let uu____8462 =
            let uu____8463 =
              let uu____8464 = ctor FStar_Parser_Const.nil_lid in
              FStar_Syntax_Syntax.mk_Tm_uinst uu____8464
                [FStar_Syntax_Syntax.U_zero] in
            FStar_Syntax_Syntax.mk_Tm_app uu____8463 args in
          uu____8462 FStar_Pervasives_Native.None pos in
        let uu____8467 =
          let uu____8468 =
            let uu____8469 = FStar_Syntax_Syntax.iarg typ in [uu____8469] in
          nil uu____8468 rng in
        FStar_List.fold_right
          (fun t  ->
             fun a  ->
               let uu____8475 =
                 let uu____8476 = FStar_Syntax_Syntax.iarg typ in
                 let uu____8477 =
                   let uu____8480 = FStar_Syntax_Syntax.as_arg t in
                   let uu____8481 =
                     let uu____8484 = FStar_Syntax_Syntax.as_arg a in
                     [uu____8484] in
                   uu____8480 :: uu____8481 in
                 uu____8476 :: uu____8477 in
               cons1 uu____8475 t.FStar_Syntax_Syntax.pos) l uu____8467
let uvar_from_id:
  Prims.int ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
  =
  fun id  ->
    fun t  ->
      let uu____8495 =
        let uu____8498 =
          let uu____8499 =
            let uu____8516 = FStar_Syntax_Unionfind.from_id id in
            (uu____8516, t) in
          FStar_Syntax_Syntax.Tm_uvar uu____8499 in
        FStar_Syntax_Syntax.mk uu____8498 in
      uu____8495 FStar_Pervasives_Native.None FStar_Range.dummyRange
let rec eqlist:
  'a .
    ('a -> 'a -> Prims.bool) -> 'a Prims.list -> 'a Prims.list -> Prims.bool
  =
  fun eq1  ->
    fun xs  ->
      fun ys  ->
        match (xs, ys) with
        | ([],[]) -> true
        | (x::xs1,y::ys1) -> (eq1 x y) && (eqlist eq1 xs1 ys1)
        | uu____8579 -> false
let eqsum:
  'a 'b .
    ('a -> 'a -> Prims.bool) ->
      ('b -> 'b -> Prims.bool) ->
        ('a,'b) FStar_Util.either -> ('a,'b) FStar_Util.either -> Prims.bool
  =
  fun e1  ->
    fun e2  ->
      fun x  ->
        fun y  ->
          match (x, y) with
          | (FStar_Util.Inl x1,FStar_Util.Inl y1) -> e1 x1 y1
          | (FStar_Util.Inr x1,FStar_Util.Inr y1) -> e2 x1 y1
          | uu____8682 -> false
let eqprod:
  'a 'b .
    ('a -> 'a -> Prims.bool) ->
      ('b -> 'b -> Prims.bool) ->
        ('a,'b) FStar_Pervasives_Native.tuple2 ->
          ('a,'b) FStar_Pervasives_Native.tuple2 -> Prims.bool
  =
  fun e1  ->
    fun e2  ->
      fun x  ->
        fun y  ->
          match (x, y) with | ((x1,x2),(y1,y2)) -> (e1 x1 y1) && (e2 x2 y2)
let eqopt:
  'a .
    ('a -> 'a -> Prims.bool) ->
      'a FStar_Pervasives_Native.option ->
        'a FStar_Pervasives_Native.option -> Prims.bool
  =
  fun e  ->
    fun x  ->
      fun y  ->
        match (x, y) with
        | (FStar_Pervasives_Native.Some x1,FStar_Pervasives_Native.Some y1)
            -> e x1 y1
        | uu____8830 -> false
let rec term_eq:
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> Prims.bool =
  fun t1  ->
    fun t2  ->
      let canon_app t =
        match t.FStar_Syntax_Syntax.n with
        | FStar_Syntax_Syntax.Tm_app uu____8941 ->
            let uu____8956 = head_and_args' t in
            (match uu____8956 with
             | (hd1,args) ->
                 let uu___175_8989 = t in
                 {
                   FStar_Syntax_Syntax.n =
                     (FStar_Syntax_Syntax.Tm_app (hd1, args));
                   FStar_Syntax_Syntax.pos =
                     (uu___175_8989.FStar_Syntax_Syntax.pos);
                   FStar_Syntax_Syntax.vars =
                     (uu___175_8989.FStar_Syntax_Syntax.vars)
                 })
        | uu____9000 -> t in
      let t11 = let uu____9004 = unmeta_safe t1 in canon_app uu____9004 in
      let t21 = let uu____9010 = unmeta_safe t2 in canon_app uu____9010 in
      match ((t11.FStar_Syntax_Syntax.n), (t21.FStar_Syntax_Syntax.n)) with
      | (FStar_Syntax_Syntax.Tm_bvar x,FStar_Syntax_Syntax.Tm_bvar y) ->
          x.FStar_Syntax_Syntax.index = y.FStar_Syntax_Syntax.index
      | (FStar_Syntax_Syntax.Tm_name x,FStar_Syntax_Syntax.Tm_name y) ->
          FStar_Syntax_Syntax.bv_eq x y
      | (FStar_Syntax_Syntax.Tm_fvar x,FStar_Syntax_Syntax.Tm_fvar y) ->
          FStar_Syntax_Syntax.fv_eq x y
      | (FStar_Syntax_Syntax.Tm_uinst (t12,us1),FStar_Syntax_Syntax.Tm_uinst
         (t22,us2)) -> (eqlist eq_univs us1 us2) && (term_eq t12 t22)
      | (FStar_Syntax_Syntax.Tm_constant c1,FStar_Syntax_Syntax.Tm_constant
         c2) -> FStar_Const.eq_const c1 c2
      | (FStar_Syntax_Syntax.Tm_type x,FStar_Syntax_Syntax.Tm_type y) ->
          x = y
      | (FStar_Syntax_Syntax.Tm_abs (b1,t12,k1),FStar_Syntax_Syntax.Tm_abs
         (b2,t22,k2)) -> (eqlist binder_eq b1 b2) && (term_eq t12 t22)
      | (FStar_Syntax_Syntax.Tm_app (f1,a1),FStar_Syntax_Syntax.Tm_app
         (f2,a2)) -> (term_eq f1 f2) && (eqlist arg_eq a1 a2)
      | (FStar_Syntax_Syntax.Tm_arrow (b1,c1),FStar_Syntax_Syntax.Tm_arrow
         (b2,c2)) -> (eqlist binder_eq b1 b2) && (comp_eq c1 c2)
      | (FStar_Syntax_Syntax.Tm_refine (b1,t12),FStar_Syntax_Syntax.Tm_refine
         (b2,t22)) -> (FStar_Syntax_Syntax.bv_eq b1 b2) && (term_eq t12 t22)
      | (FStar_Syntax_Syntax.Tm_match (t12,bs1),FStar_Syntax_Syntax.Tm_match
         (t22,bs2)) -> (term_eq t12 t22) && (eqlist branch_eq bs1 bs2)
      | (uu____9277,uu____9278) -> false
and arg_eq:
  (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.aqual)
    FStar_Pervasives_Native.tuple2 ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.aqual)
      FStar_Pervasives_Native.tuple2 -> Prims.bool
  =
  fun a1  -> fun a2  -> eqprod term_eq (fun q1  -> fun q2  -> q1 = q2) a1 a2
and binder_eq:
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
    FStar_Pervasives_Native.tuple2 ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
      FStar_Pervasives_Native.tuple2 -> Prims.bool
  =
  fun b1  ->
    fun b2  ->
      eqprod
        (fun b11  ->
           fun b21  ->
             term_eq b11.FStar_Syntax_Syntax.sort
               b21.FStar_Syntax_Syntax.sort) (fun q1  -> fun q2  -> q1 = q2)
        b1 b2
and lcomp_eq:
  FStar_Syntax_Syntax.lcomp -> FStar_Syntax_Syntax.lcomp -> Prims.bool =
  fun c1  -> fun c2  -> false
and residual_eq:
  FStar_Syntax_Syntax.residual_comp ->
    FStar_Syntax_Syntax.residual_comp -> Prims.bool
  = fun r1  -> fun r2  -> false
and comp_eq:
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool
  =
  fun c1  ->
    fun c2  ->
      match ((c1.FStar_Syntax_Syntax.n), (c2.FStar_Syntax_Syntax.n)) with
      | (FStar_Syntax_Syntax.Total (t1,u1),FStar_Syntax_Syntax.Total (t2,u2))
          -> term_eq t1 t2
      | (FStar_Syntax_Syntax.GTotal (t1,u1),FStar_Syntax_Syntax.GTotal
         (t2,u2)) -> term_eq t1 t2
      | (FStar_Syntax_Syntax.Comp c11,FStar_Syntax_Syntax.Comp c21) ->
          ((((c11.FStar_Syntax_Syntax.comp_univs =
                c21.FStar_Syntax_Syntax.comp_univs)
               &&
               (c11.FStar_Syntax_Syntax.effect_name =
                  c21.FStar_Syntax_Syntax.effect_name))
              &&
              (term_eq c11.FStar_Syntax_Syntax.result_typ
                 c21.FStar_Syntax_Syntax.result_typ))
             &&
             (eqlist arg_eq c11.FStar_Syntax_Syntax.effect_args
                c21.FStar_Syntax_Syntax.effect_args))
            &&
            (eq_flags c11.FStar_Syntax_Syntax.flags
               c21.FStar_Syntax_Syntax.flags)
      | (uu____9373,uu____9374) -> false
and eq_flags:
  FStar_Syntax_Syntax.cflags Prims.list ->
    FStar_Syntax_Syntax.cflags Prims.list -> Prims.bool
  = fun f1  -> fun f2  -> false
and branch_eq:
  (FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t,FStar_Syntax_Syntax.term'
                                                             FStar_Syntax_Syntax.syntax
                                                             FStar_Pervasives_Native.option,
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
    FStar_Pervasives_Native.tuple3 ->
    (FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t,FStar_Syntax_Syntax.term'
                                                               FStar_Syntax_Syntax.syntax
                                                               FStar_Pervasives_Native.option,
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
      FStar_Pervasives_Native.tuple3 -> Prims.bool
  =
  fun uu____9381  ->
    fun uu____9382  ->
      match (uu____9381, uu____9382) with | ((p1,w1,t1),(p2,w2,t2)) -> false
let rec bottom_fold:
  (FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  =
  fun f  ->
    fun t  ->
      let ff = bottom_fold f in
      let tn =
        let uu____9522 = FStar_Syntax_Subst.compress t in
        uu____9522.FStar_Syntax_Syntax.n in
      let tn1 =
        match tn with
        | FStar_Syntax_Syntax.Tm_app (f1,args) ->
            let uu____9548 =
              let uu____9563 = ff f1 in
              let uu____9564 =
                FStar_List.map
                  (fun uu____9583  ->
                     match uu____9583 with
                     | (a,q) -> let uu____9594 = ff a in (uu____9594, q))
                  args in
              (uu____9563, uu____9564) in
            FStar_Syntax_Syntax.Tm_app uu____9548
        | FStar_Syntax_Syntax.Tm_abs (bs,t1,k) ->
            let uu____9624 = FStar_Syntax_Subst.open_term bs t1 in
            (match uu____9624 with
             | (bs1,t') ->
                 let t'' = ff t' in
                 let uu____9632 =
                   let uu____9649 = FStar_Syntax_Subst.close bs1 t'' in
                   (bs1, uu____9649, k) in
                 FStar_Syntax_Syntax.Tm_abs uu____9632)
        | FStar_Syntax_Syntax.Tm_arrow (bs,k) -> tn
        | FStar_Syntax_Syntax.Tm_uinst (t1,us) ->
            let uu____9676 = let uu____9683 = ff t1 in (uu____9683, us) in
            FStar_Syntax_Syntax.Tm_uinst uu____9676
        | uu____9684 -> tn in
      f
        (let uu___176_9687 = t in
         {
           FStar_Syntax_Syntax.n = tn1;
           FStar_Syntax_Syntax.pos = (uu___176_9687.FStar_Syntax_Syntax.pos);
           FStar_Syntax_Syntax.vars =
             (uu___176_9687.FStar_Syntax_Syntax.vars)
         })
let rec sizeof: FStar_Syntax_Syntax.term -> Prims.int =
  fun t  ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_delayed uu____9692 ->
        let uu____9717 =
          let uu____9718 = FStar_Syntax_Subst.compress t in sizeof uu____9718 in
        (Prims.parse_int "1") + uu____9717
    | FStar_Syntax_Syntax.Tm_bvar bv ->
        let uu____9720 = sizeof bv.FStar_Syntax_Syntax.sort in
        (Prims.parse_int "1") + uu____9720
    | FStar_Syntax_Syntax.Tm_name bv ->
        let uu____9722 = sizeof bv.FStar_Syntax_Syntax.sort in
        (Prims.parse_int "1") + uu____9722
    | FStar_Syntax_Syntax.Tm_uinst (t1,us) ->
        let uu____9729 = sizeof t1 in (FStar_List.length us) + uu____9729
    | FStar_Syntax_Syntax.Tm_abs (bs,t1,uu____9732) ->
        let uu____9753 = sizeof t1 in
        let uu____9754 =
          FStar_List.fold_left
            (fun acc  ->
               fun uu____9765  ->
                 match uu____9765 with
                 | (bv,uu____9771) ->
                     let uu____9772 = sizeof bv.FStar_Syntax_Syntax.sort in
                     acc + uu____9772) (Prims.parse_int "0") bs in
        uu____9753 + uu____9754
    | FStar_Syntax_Syntax.Tm_app (hd1,args) ->
        let uu____9795 = sizeof hd1 in
        let uu____9796 =
          FStar_List.fold_left
            (fun acc  ->
               fun uu____9807  ->
                 match uu____9807 with
                 | (arg,uu____9813) ->
                     let uu____9814 = sizeof arg in acc + uu____9814)
            (Prims.parse_int "0") args in
        uu____9795 + uu____9796
    | uu____9815 -> Prims.parse_int "1"
let is_synth_by_tactic: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____9820 =
      let uu____9821 = un_uinst t in uu____9821.FStar_Syntax_Syntax.n in
    match uu____9820 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.synth_lid
    | uu____9825 -> false
let mk_alien:
  'a .
    'a ->
      Prims.string ->
        FStar_Range.range FStar_Pervasives_Native.option ->
          FStar_Syntax_Syntax.term
  =
  fun b  ->
    fun s  ->
      fun r  ->
        let uu____9851 =
          let uu____9854 =
            let uu____9855 =
              let uu____9862 =
                let uu____9863 =
                  let uu____9868 = FStar_Dyn.mkdyn b in (uu____9868, s) in
                FStar_Syntax_Syntax.Meta_alien uu____9863 in
              (FStar_Syntax_Syntax.tun, uu____9862) in
            FStar_Syntax_Syntax.Tm_meta uu____9855 in
          FStar_Syntax_Syntax.mk uu____9854 in
        uu____9851 FStar_Pervasives_Native.None
          (match r with
           | FStar_Pervasives_Native.Some r1 -> r1
           | FStar_Pervasives_Native.None  -> FStar_Range.dummyRange)
let un_alien: FStar_Syntax_Syntax.term -> FStar_Dyn.dyn =
  fun t  ->
    match (FStar_Syntax_Subst.compress t).FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_meta
        (uu____9880,FStar_Syntax_Syntax.Meta_alien (blob,uu____9882)) -> blob
    | uu____9887 -> failwith "unexpected: term was not an alien embedding"
