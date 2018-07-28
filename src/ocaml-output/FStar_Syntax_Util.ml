open Prims
let (tts_f :
  (FStar_Syntax_Syntax.term -> Prims.string) FStar_Pervasives_Native.option
    FStar_ST.ref)
  = FStar_Util.mk_ref FStar_Pervasives_Native.None 
let (tts : FStar_Syntax_Syntax.term -> Prims.string) =
  fun t  ->
    let uu____32 = FStar_ST.op_Bang tts_f  in
    match uu____32 with
    | FStar_Pervasives_Native.None  -> "<<hook unset>>"
    | FStar_Pervasives_Native.Some f -> f t
  
let (qual_id : FStar_Ident.lident -> FStar_Ident.ident -> FStar_Ident.lident)
  =
  fun lid  ->
    fun id1  ->
      let uu____87 =
        FStar_Ident.lid_of_ids
          (FStar_List.append lid.FStar_Ident.ns [lid.FStar_Ident.ident; id1])
         in
      FStar_Ident.set_lid_range uu____87 id1.FStar_Ident.idRange
  
let (mk_discriminator : FStar_Ident.lident -> FStar_Ident.lident) =
  fun lid  ->
    let uu____93 =
      let uu____96 =
        let uu____99 =
          FStar_Ident.mk_ident
            ((Prims.strcat FStar_Ident.reserved_prefix
                (Prims.strcat "is_"
                   (lid.FStar_Ident.ident).FStar_Ident.idText)),
              ((lid.FStar_Ident.ident).FStar_Ident.idRange))
           in
        [uu____99]  in
      FStar_List.append lid.FStar_Ident.ns uu____96  in
    FStar_Ident.lid_of_ids uu____93
  
let (is_name : FStar_Ident.lident -> Prims.bool) =
  fun lid  ->
    let c =
      FStar_Util.char_at (lid.FStar_Ident.ident).FStar_Ident.idText
        (Prims.parse_int "0")
       in
    FStar_Util.is_upper c
  
let arg_of_non_null_binder :
  'Auu____111 .
    (FStar_Syntax_Syntax.bv,'Auu____111) FStar_Pervasives_Native.tuple2 ->
      (FStar_Syntax_Syntax.term,'Auu____111) FStar_Pervasives_Native.tuple2
  =
  fun uu____124  ->
    match uu____124 with
    | (b,imp) ->
        let uu____131 = FStar_Syntax_Syntax.bv_to_name b  in (uu____131, imp)
  
let (args_of_non_null_binders :
  FStar_Syntax_Syntax.binders ->
    (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.arg_qualifier
                                FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2 Prims.list)
  =
  fun binders  ->
    FStar_All.pipe_right binders
      (FStar_List.collect
         (fun b  ->
            let uu____182 = FStar_Syntax_Syntax.is_null_binder b  in
            if uu____182
            then []
            else (let uu____198 = arg_of_non_null_binder b  in [uu____198])))
  
let (args_of_binders :
  FStar_Syntax_Syntax.binders ->
    (FStar_Syntax_Syntax.binders,FStar_Syntax_Syntax.args)
      FStar_Pervasives_Native.tuple2)
  =
  fun binders  ->
    let uu____232 =
      FStar_All.pipe_right binders
        (FStar_List.map
           (fun b  ->
              let uu____314 = FStar_Syntax_Syntax.is_null_binder b  in
              if uu____314
              then
                let b1 =
                  let uu____338 =
                    FStar_Syntax_Syntax.new_bv FStar_Pervasives_Native.None
                      (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                     in
                  (uu____338, (FStar_Pervasives_Native.snd b))  in
                let uu____345 = arg_of_non_null_binder b1  in (b1, uu____345)
              else
                (let uu____367 = arg_of_non_null_binder b  in (b, uu____367))))
       in
    FStar_All.pipe_right uu____232 FStar_List.unzip
  
let (name_binders :
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                            FStar_Pervasives_Native.option)
    FStar_Pervasives_Native.tuple2 Prims.list ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                              FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2 Prims.list)
  =
  fun binders  ->
    FStar_All.pipe_right binders
      (FStar_List.mapi
         (fun i  ->
            fun b  ->
              let uu____499 = FStar_Syntax_Syntax.is_null_binder b  in
              if uu____499
              then
                let uu____506 = b  in
                match uu____506 with
                | (a,imp) ->
                    let b1 =
                      let uu____526 =
                        let uu____527 = FStar_Util.string_of_int i  in
                        Prims.strcat "_" uu____527  in
                      FStar_Ident.id_of_text uu____526  in
                    let b2 =
                      {
                        FStar_Syntax_Syntax.ppname = b1;
                        FStar_Syntax_Syntax.index = (Prims.parse_int "0");
                        FStar_Syntax_Syntax.sort =
                          (a.FStar_Syntax_Syntax.sort)
                      }  in
                    (b2, imp)
              else b))
  
let (name_function_binders :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t  ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_arrow (binders,comp) ->
        let uu____567 =
          let uu____574 =
            let uu____575 =
              let uu____590 = name_binders binders  in (uu____590, comp)  in
            FStar_Syntax_Syntax.Tm_arrow uu____575  in
          FStar_Syntax_Syntax.mk uu____574  in
        uu____567 FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
    | uu____612 -> t
  
let (null_binders_of_tks :
  (FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.aqual)
    FStar_Pervasives_Native.tuple2 Prims.list -> FStar_Syntax_Syntax.binders)
  =
  fun tks  ->
    FStar_All.pipe_right tks
      (FStar_List.map
         (fun uu____648  ->
            match uu____648 with
            | (t,imp) ->
                let uu____659 =
                  let uu____660 = FStar_Syntax_Syntax.null_binder t  in
                  FStar_All.pipe_left FStar_Pervasives_Native.fst uu____660
                   in
                (uu____659, imp)))
  
let (binders_of_tks :
  (FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.aqual)
    FStar_Pervasives_Native.tuple2 Prims.list -> FStar_Syntax_Syntax.binders)
  =
  fun tks  ->
    FStar_All.pipe_right tks
      (FStar_List.map
         (fun uu____714  ->
            match uu____714 with
            | (t,imp) ->
                let uu____731 =
                  FStar_Syntax_Syntax.new_bv
                    (FStar_Pervasives_Native.Some (t.FStar_Syntax_Syntax.pos))
                    t
                   in
                (uu____731, imp)))
  
let (binders_of_freevars :
  FStar_Syntax_Syntax.bv FStar_Util.set ->
    FStar_Syntax_Syntax.binder Prims.list)
  =
  fun fvs  ->
    let uu____743 = FStar_Util.set_elements fvs  in
    FStar_All.pipe_right uu____743
      (FStar_List.map FStar_Syntax_Syntax.mk_binder)
  
let mk_subst : 'Auu____754 . 'Auu____754 -> 'Auu____754 Prims.list =
  fun s  -> [s] 
let (subst_of_list :
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.args -> FStar_Syntax_Syntax.subst_t)
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
  
let (rename_binders :
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.binders -> FStar_Syntax_Syntax.subst_t)
  =
  fun replace_xs  ->
    fun with_ys  ->
      if (FStar_List.length replace_xs) = (FStar_List.length with_ys)
      then
        FStar_List.map2
          (fun uu____874  ->
             fun uu____875  ->
               match (uu____874, uu____875) with
               | ((x,uu____901),(y,uu____903)) ->
                   let uu____924 =
                     let uu____931 = FStar_Syntax_Syntax.bv_to_name y  in
                     (x, uu____931)  in
                   FStar_Syntax_Syntax.NT uu____924) replace_xs with_ys
      else failwith "Ill-formed substitution"
  
let rec (unmeta : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun e  ->
    let e1 = FStar_Syntax_Subst.compress e  in
    match e1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_meta (e2,uu____944) -> unmeta e2
    | FStar_Syntax_Syntax.Tm_ascribed (e2,uu____950,uu____951) -> unmeta e2
    | uu____992 -> e1
  
let rec (unmeta_safe : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun e  ->
    let e1 = FStar_Syntax_Subst.compress e  in
    match e1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_meta (e',m) ->
        (match m with
         | FStar_Syntax_Syntax.Meta_monadic uu____1005 -> e1
         | FStar_Syntax_Syntax.Meta_monadic_lift uu____1012 -> e1
         | uu____1021 -> unmeta_safe e')
    | FStar_Syntax_Syntax.Tm_ascribed (e2,uu____1023,uu____1024) ->
        unmeta_safe e2
    | uu____1065 -> e1
  
let rec (univ_kernel :
  FStar_Syntax_Syntax.universe ->
    (FStar_Syntax_Syntax.universe,Prims.int) FStar_Pervasives_Native.tuple2)
  =
  fun u  ->
    match u with
    | FStar_Syntax_Syntax.U_unknown  -> (u, (Prims.parse_int "0"))
    | FStar_Syntax_Syntax.U_name uu____1079 -> (u, (Prims.parse_int "0"))
    | FStar_Syntax_Syntax.U_unif uu____1080 -> (u, (Prims.parse_int "0"))
    | FStar_Syntax_Syntax.U_zero  -> (u, (Prims.parse_int "0"))
    | FStar_Syntax_Syntax.U_succ u1 ->
        let uu____1090 = univ_kernel u1  in
        (match uu____1090 with | (k,n1) -> (k, (n1 + (Prims.parse_int "1"))))
    | FStar_Syntax_Syntax.U_max uu____1101 ->
        failwith "Imposible: univ_kernel (U_max _)"
    | FStar_Syntax_Syntax.U_bvar uu____1108 ->
        failwith "Imposible: univ_kernel (U_bvar _)"
  
let (constant_univ_as_nat : FStar_Syntax_Syntax.universe -> Prims.int) =
  fun u  ->
    let uu____1118 = univ_kernel u  in FStar_Pervasives_Native.snd uu____1118
  
let rec (compare_univs :
  FStar_Syntax_Syntax.universe -> FStar_Syntax_Syntax.universe -> Prims.int)
  =
  fun u1  ->
    fun u2  ->
      match (u1, u2) with
      | (FStar_Syntax_Syntax.U_bvar uu____1133,uu____1134) ->
          failwith "Impossible: compare_univs"
      | (uu____1135,FStar_Syntax_Syntax.U_bvar uu____1136) ->
          failwith "Impossible: compare_univs"
      | (FStar_Syntax_Syntax.U_unknown ,FStar_Syntax_Syntax.U_unknown ) ->
          (Prims.parse_int "0")
      | (FStar_Syntax_Syntax.U_unknown ,uu____1137) ->
          ~- (Prims.parse_int "1")
      | (uu____1138,FStar_Syntax_Syntax.U_unknown ) -> (Prims.parse_int "1")
      | (FStar_Syntax_Syntax.U_zero ,FStar_Syntax_Syntax.U_zero ) ->
          (Prims.parse_int "0")
      | (FStar_Syntax_Syntax.U_zero ,uu____1139) -> ~- (Prims.parse_int "1")
      | (uu____1140,FStar_Syntax_Syntax.U_zero ) -> (Prims.parse_int "1")
      | (FStar_Syntax_Syntax.U_name u11,FStar_Syntax_Syntax.U_name u21) ->
          FStar_String.compare u11.FStar_Ident.idText u21.FStar_Ident.idText
      | (FStar_Syntax_Syntax.U_name uu____1143,FStar_Syntax_Syntax.U_unif
         uu____1144) -> ~- (Prims.parse_int "1")
      | (FStar_Syntax_Syntax.U_unif uu____1153,FStar_Syntax_Syntax.U_name
         uu____1154) -> (Prims.parse_int "1")
      | (FStar_Syntax_Syntax.U_unif u11,FStar_Syntax_Syntax.U_unif u21) ->
          let uu____1181 = FStar_Syntax_Unionfind.univ_uvar_id u11  in
          let uu____1182 = FStar_Syntax_Unionfind.univ_uvar_id u21  in
          uu____1181 - uu____1182
      | (FStar_Syntax_Syntax.U_max us1,FStar_Syntax_Syntax.U_max us2) ->
          let n1 = FStar_List.length us1  in
          let n2 = FStar_List.length us2  in
          if n1 <> n2
          then n1 - n2
          else
            (let copt =
               let uu____1213 = FStar_List.zip us1 us2  in
               FStar_Util.find_map uu____1213
                 (fun uu____1228  ->
                    match uu____1228 with
                    | (u11,u21) ->
                        let c = compare_univs u11 u21  in
                        if c <> (Prims.parse_int "0")
                        then FStar_Pervasives_Native.Some c
                        else FStar_Pervasives_Native.None)
                in
             match copt with
             | FStar_Pervasives_Native.None  -> (Prims.parse_int "0")
             | FStar_Pervasives_Native.Some c -> c)
      | (FStar_Syntax_Syntax.U_max uu____1242,uu____1243) ->
          ~- (Prims.parse_int "1")
      | (uu____1246,FStar_Syntax_Syntax.U_max uu____1247) ->
          (Prims.parse_int "1")
      | uu____1250 ->
          let uu____1255 = univ_kernel u1  in
          (match uu____1255 with
           | (k1,n1) ->
               let uu____1262 = univ_kernel u2  in
               (match uu____1262 with
                | (k2,n2) ->
                    let r = compare_univs k1 k2  in
                    if r = (Prims.parse_int "0") then n1 - n2 else r))
  
let (eq_univs :
  FStar_Syntax_Syntax.universe -> FStar_Syntax_Syntax.universe -> Prims.bool)
  =
  fun u1  ->
    fun u2  ->
      let uu____1281 = compare_univs u1 u2  in
      uu____1281 = (Prims.parse_int "0")
  
let (ml_comp :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Range.range -> FStar_Syntax_Syntax.comp)
  =
  fun t  ->
    fun r  ->
      let uu____1296 =
        let uu____1297 =
          FStar_Ident.set_lid_range FStar_Parser_Const.effect_ML_lid r  in
        {
          FStar_Syntax_Syntax.comp_univs = [FStar_Syntax_Syntax.U_zero];
          FStar_Syntax_Syntax.effect_name = uu____1297;
          FStar_Syntax_Syntax.result_typ = t;
          FStar_Syntax_Syntax.effect_args = [];
          FStar_Syntax_Syntax.flags = [FStar_Syntax_Syntax.MLEFFECT]
        }  in
      FStar_Syntax_Syntax.mk_Comp uu____1296
  
let (comp_effect_name :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> FStar_Ident.lident)
  =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 -> c1.FStar_Syntax_Syntax.effect_name
    | FStar_Syntax_Syntax.Total uu____1316 ->
        FStar_Parser_Const.effect_Tot_lid
    | FStar_Syntax_Syntax.GTotal uu____1325 ->
        FStar_Parser_Const.effect_GTot_lid
  
let (comp_flags :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.cflags Prims.list)
  =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total uu____1347 -> [FStar_Syntax_Syntax.TOTAL]
    | FStar_Syntax_Syntax.GTotal uu____1356 ->
        [FStar_Syntax_Syntax.SOMETRIVIAL]
    | FStar_Syntax_Syntax.Comp ct -> ct.FStar_Syntax_Syntax.flags
  
let (comp_to_comp_typ_nouniv :
  FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.comp_typ) =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 -> c1
    | FStar_Syntax_Syntax.Total (t,u_opt) ->
        let uu____1382 =
          let uu____1383 = FStar_Util.map_opt u_opt (fun x  -> [x])  in
          FStar_Util.dflt [] uu____1383  in
        {
          FStar_Syntax_Syntax.comp_univs = uu____1382;
          FStar_Syntax_Syntax.effect_name = (comp_effect_name c);
          FStar_Syntax_Syntax.result_typ = t;
          FStar_Syntax_Syntax.effect_args = [];
          FStar_Syntax_Syntax.flags = (comp_flags c)
        }
    | FStar_Syntax_Syntax.GTotal (t,u_opt) ->
        let uu____1412 =
          let uu____1413 = FStar_Util.map_opt u_opt (fun x  -> [x])  in
          FStar_Util.dflt [] uu____1413  in
        {
          FStar_Syntax_Syntax.comp_univs = uu____1412;
          FStar_Syntax_Syntax.effect_name = (comp_effect_name c);
          FStar_Syntax_Syntax.result_typ = t;
          FStar_Syntax_Syntax.effect_args = [];
          FStar_Syntax_Syntax.flags = (comp_flags c)
        }
  
let (comp_set_flags :
  FStar_Syntax_Syntax.comp ->
    FStar_Syntax_Syntax.cflags Prims.list ->
      FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax)
  =
  fun c  ->
    fun f  ->
      let uu___121_1448 = c  in
      let uu____1449 =
        let uu____1450 =
          let uu___122_1451 = comp_to_comp_typ_nouniv c  in
          {
            FStar_Syntax_Syntax.comp_univs =
              (uu___122_1451.FStar_Syntax_Syntax.comp_univs);
            FStar_Syntax_Syntax.effect_name =
              (uu___122_1451.FStar_Syntax_Syntax.effect_name);
            FStar_Syntax_Syntax.result_typ =
              (uu___122_1451.FStar_Syntax_Syntax.result_typ);
            FStar_Syntax_Syntax.effect_args =
              (uu___122_1451.FStar_Syntax_Syntax.effect_args);
            FStar_Syntax_Syntax.flags = f
          }  in
        FStar_Syntax_Syntax.Comp uu____1450  in
      {
        FStar_Syntax_Syntax.n = uu____1449;
        FStar_Syntax_Syntax.pos = (uu___121_1448.FStar_Syntax_Syntax.pos);
        FStar_Syntax_Syntax.vars = (uu___121_1448.FStar_Syntax_Syntax.vars)
      }
  
let (lcomp_set_flags :
  FStar_Syntax_Syntax.lcomp ->
    FStar_Syntax_Syntax.cflags Prims.list -> FStar_Syntax_Syntax.lcomp)
  =
  fun lc  ->
    fun fs  ->
      let comp_typ_set_flags c =
        match c.FStar_Syntax_Syntax.n with
        | FStar_Syntax_Syntax.Total uu____1476 -> c
        | FStar_Syntax_Syntax.GTotal uu____1485 -> c
        | FStar_Syntax_Syntax.Comp ct ->
            let ct1 =
              let uu___123_1496 = ct  in
              {
                FStar_Syntax_Syntax.comp_univs =
                  (uu___123_1496.FStar_Syntax_Syntax.comp_univs);
                FStar_Syntax_Syntax.effect_name =
                  (uu___123_1496.FStar_Syntax_Syntax.effect_name);
                FStar_Syntax_Syntax.result_typ =
                  (uu___123_1496.FStar_Syntax_Syntax.result_typ);
                FStar_Syntax_Syntax.effect_args =
                  (uu___123_1496.FStar_Syntax_Syntax.effect_args);
                FStar_Syntax_Syntax.flags = fs
              }  in
            let uu___124_1497 = c  in
            {
              FStar_Syntax_Syntax.n = (FStar_Syntax_Syntax.Comp ct1);
              FStar_Syntax_Syntax.pos =
                (uu___124_1497.FStar_Syntax_Syntax.pos);
              FStar_Syntax_Syntax.vars =
                (uu___124_1497.FStar_Syntax_Syntax.vars)
            }
         in
      FStar_Syntax_Syntax.mk_lcomp lc.FStar_Syntax_Syntax.eff_name
        lc.FStar_Syntax_Syntax.res_typ fs
        (fun uu____1500  ->
           let uu____1501 = FStar_Syntax_Syntax.lcomp_comp lc  in
           comp_typ_set_flags uu____1501)
  
let (comp_to_comp_typ :
  FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.comp_typ) =
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
    | uu____1540 ->
        failwith "Assertion failed: Computation type without universe"
  
let (is_named_tot :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 ->
        FStar_Ident.lid_equals c1.FStar_Syntax_Syntax.effect_name
          FStar_Parser_Const.effect_Tot_lid
    | FStar_Syntax_Syntax.Total uu____1551 -> true
    | FStar_Syntax_Syntax.GTotal uu____1560 -> false
  
let (is_total_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c  ->
    (FStar_Ident.lid_equals (comp_effect_name c)
       FStar_Parser_Const.effect_Tot_lid)
      ||
      (FStar_All.pipe_right (comp_flags c)
         (FStar_Util.for_some
            (fun uu___108_1581  ->
               match uu___108_1581 with
               | FStar_Syntax_Syntax.TOTAL  -> true
               | FStar_Syntax_Syntax.RETURN  -> true
               | uu____1582 -> false)))
  
let (is_total_lcomp : FStar_Syntax_Syntax.lcomp -> Prims.bool) =
  fun c  ->
    (FStar_Ident.lid_equals c.FStar_Syntax_Syntax.eff_name
       FStar_Parser_Const.effect_Tot_lid)
      ||
      (FStar_All.pipe_right c.FStar_Syntax_Syntax.cflags
         (FStar_Util.for_some
            (fun uu___109_1591  ->
               match uu___109_1591 with
               | FStar_Syntax_Syntax.TOTAL  -> true
               | FStar_Syntax_Syntax.RETURN  -> true
               | uu____1592 -> false)))
  
let (is_tot_or_gtot_lcomp : FStar_Syntax_Syntax.lcomp -> Prims.bool) =
  fun c  ->
    ((FStar_Ident.lid_equals c.FStar_Syntax_Syntax.eff_name
        FStar_Parser_Const.effect_Tot_lid)
       ||
       (FStar_Ident.lid_equals c.FStar_Syntax_Syntax.eff_name
          FStar_Parser_Const.effect_GTot_lid))
      ||
      (FStar_All.pipe_right c.FStar_Syntax_Syntax.cflags
         (FStar_Util.for_some
            (fun uu___110_1601  ->
               match uu___110_1601 with
               | FStar_Syntax_Syntax.TOTAL  -> true
               | FStar_Syntax_Syntax.RETURN  -> true
               | uu____1602 -> false)))
  
let (is_partial_return :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c  ->
    FStar_All.pipe_right (comp_flags c)
      (FStar_Util.for_some
         (fun uu___111_1615  ->
            match uu___111_1615 with
            | FStar_Syntax_Syntax.RETURN  -> true
            | FStar_Syntax_Syntax.PARTIAL_RETURN  -> true
            | uu____1616 -> false))
  
let (is_lcomp_partial_return : FStar_Syntax_Syntax.lcomp -> Prims.bool) =
  fun c  ->
    FStar_All.pipe_right c.FStar_Syntax_Syntax.cflags
      (FStar_Util.for_some
         (fun uu___112_1625  ->
            match uu___112_1625 with
            | FStar_Syntax_Syntax.RETURN  -> true
            | FStar_Syntax_Syntax.PARTIAL_RETURN  -> true
            | uu____1626 -> false))
  
let (is_tot_or_gtot_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c  ->
    (is_total_comp c) ||
      (FStar_Ident.lid_equals FStar_Parser_Const.effect_GTot_lid
         (comp_effect_name c))
  
let (is_pure_effect : FStar_Ident.lident -> Prims.bool) =
  fun l  ->
    ((FStar_Ident.lid_equals l FStar_Parser_Const.effect_Tot_lid) ||
       (FStar_Ident.lid_equals l FStar_Parser_Const.effect_PURE_lid))
      || (FStar_Ident.lid_equals l FStar_Parser_Const.effect_Pure_lid)
  
let (is_pure_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total uu____1650 -> true
    | FStar_Syntax_Syntax.GTotal uu____1659 -> false
    | FStar_Syntax_Syntax.Comp ct ->
        ((is_total_comp c) ||
           (is_pure_effect ct.FStar_Syntax_Syntax.effect_name))
          ||
          (FStar_All.pipe_right ct.FStar_Syntax_Syntax.flags
             (FStar_Util.for_some
                (fun uu___113_1672  ->
                   match uu___113_1672 with
                   | FStar_Syntax_Syntax.LEMMA  -> true
                   | uu____1673 -> false)))
  
let (is_ghost_effect : FStar_Ident.lident -> Prims.bool) =
  fun l  ->
    ((FStar_Ident.lid_equals FStar_Parser_Const.effect_GTot_lid l) ||
       (FStar_Ident.lid_equals FStar_Parser_Const.effect_GHOST_lid l))
      || (FStar_Ident.lid_equals FStar_Parser_Const.effect_Ghost_lid l)
  
let (is_div_effect : FStar_Ident.lident -> Prims.bool) =
  fun l  ->
    ((FStar_Ident.lid_equals l FStar_Parser_Const.effect_DIV_lid) ||
       (FStar_Ident.lid_equals l FStar_Parser_Const.effect_Div_lid))
      || (FStar_Ident.lid_equals l FStar_Parser_Const.effect_Dv_lid)
  
let (is_pure_or_ghost_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c  -> (is_pure_comp c) || (is_ghost_effect (comp_effect_name c)) 
let (is_pure_or_ghost_effect : FStar_Ident.lident -> Prims.bool) =
  fun l  -> (is_pure_effect l) || (is_ghost_effect l) 
let (is_pure_lcomp : FStar_Syntax_Syntax.lcomp -> Prims.bool) =
  fun lc  ->
    ((is_total_lcomp lc) || (is_pure_effect lc.FStar_Syntax_Syntax.eff_name))
      ||
      (FStar_All.pipe_right lc.FStar_Syntax_Syntax.cflags
         (FStar_Util.for_some
            (fun uu___114_1706  ->
               match uu___114_1706 with
               | FStar_Syntax_Syntax.LEMMA  -> true
               | uu____1707 -> false)))
  
let (is_pure_or_ghost_lcomp : FStar_Syntax_Syntax.lcomp -> Prims.bool) =
  fun lc  ->
    (is_pure_lcomp lc) || (is_ghost_effect lc.FStar_Syntax_Syntax.eff_name)
  
let (is_pure_or_ghost_function : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  ->
    let uu____1718 =
      let uu____1719 = FStar_Syntax_Subst.compress t  in
      uu____1719.FStar_Syntax_Syntax.n  in
    match uu____1718 with
    | FStar_Syntax_Syntax.Tm_arrow (uu____1722,c) -> is_pure_or_ghost_comp c
    | uu____1744 -> true
  
let (is_lemma_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp ct ->
        FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name
          FStar_Parser_Const.effect_Lemma_lid
    | uu____1755 -> false
  
let (is_lemma : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  ->
    let uu____1761 =
      let uu____1762 = FStar_Syntax_Subst.compress t  in
      uu____1762.FStar_Syntax_Syntax.n  in
    match uu____1761 with
    | FStar_Syntax_Syntax.Tm_arrow (uu____1765,c) -> is_lemma_comp c
    | uu____1787 -> false
  
let rec (head_of : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t  ->
    let uu____1793 =
      let uu____1794 = FStar_Syntax_Subst.compress t  in
      uu____1794.FStar_Syntax_Syntax.n  in
    match uu____1793 with
    | FStar_Syntax_Syntax.Tm_app (t1,uu____1798) -> head_of t1
    | FStar_Syntax_Syntax.Tm_match (t1,uu____1824) -> head_of t1
    | FStar_Syntax_Syntax.Tm_abs (uu____1861,t1,uu____1863) -> head_of t1
    | FStar_Syntax_Syntax.Tm_ascribed (t1,uu____1889,uu____1890) ->
        head_of t1
    | FStar_Syntax_Syntax.Tm_meta (t1,uu____1932) -> head_of t1
    | uu____1937 -> t
  
let (head_and_args :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,(FStar_Syntax_Syntax.term'
                                                             FStar_Syntax_Syntax.syntax,
                                                            FStar_Syntax_Syntax.arg_qualifier
                                                              FStar_Pervasives_Native.option)
                                                            FStar_Pervasives_Native.tuple2
                                                            Prims.list)
      FStar_Pervasives_Native.tuple2)
  =
  fun t  ->
    let t1 = FStar_Syntax_Subst.compress t  in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_app (head1,args) -> (head1, args)
    | uu____2014 -> (t1, [])
  
let rec (head_and_args' :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.term,(FStar_Syntax_Syntax.term'
                                 FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.arg_qualifier
                                                              FStar_Pervasives_Native.option)
                                FStar_Pervasives_Native.tuple2 Prims.list)
      FStar_Pervasives_Native.tuple2)
  =
  fun t  ->
    let t1 = FStar_Syntax_Subst.compress t  in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_app (head1,args) ->
        let uu____2095 = head_and_args' head1  in
        (match uu____2095 with
         | (head2,args') -> (head2, (FStar_List.append args' args)))
    | uu____2164 -> (t1, [])
  
let (un_uinst : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t  ->
    let t1 = FStar_Syntax_Subst.compress t  in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_uinst (t2,uu____2190) ->
        FStar_Syntax_Subst.compress t2
    | uu____2195 -> t1
  
let (is_smt_lemma : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  ->
    let uu____2201 =
      let uu____2202 = FStar_Syntax_Subst.compress t  in
      uu____2202.FStar_Syntax_Syntax.n  in
    match uu____2201 with
    | FStar_Syntax_Syntax.Tm_arrow (uu____2205,c) ->
        (match c.FStar_Syntax_Syntax.n with
         | FStar_Syntax_Syntax.Comp ct when
             FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name
               FStar_Parser_Const.effect_Lemma_lid
             ->
             (match ct.FStar_Syntax_Syntax.effect_args with
              | _req::_ens::(pats,uu____2231)::uu____2232 ->
                  let pats' = unmeta pats  in
                  let uu____2292 = head_and_args pats'  in
                  (match uu____2292 with
                   | (head1,uu____2310) ->
                       let uu____2335 =
                         let uu____2336 = un_uinst head1  in
                         uu____2336.FStar_Syntax_Syntax.n  in
                       (match uu____2335 with
                        | FStar_Syntax_Syntax.Tm_fvar fv ->
                            FStar_Syntax_Syntax.fv_eq_lid fv
                              FStar_Parser_Const.cons_lid
                        | uu____2340 -> false))
              | uu____2341 -> false)
         | uu____2352 -> false)
    | uu____2353 -> false
  
let (is_ml_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 ->
        (FStar_Ident.lid_equals c1.FStar_Syntax_Syntax.effect_name
           FStar_Parser_Const.effect_ML_lid)
          ||
          (FStar_All.pipe_right c1.FStar_Syntax_Syntax.flags
             (FStar_Util.for_some
                (fun uu___115_2367  ->
                   match uu___115_2367 with
                   | FStar_Syntax_Syntax.MLEFFECT  -> true
                   | uu____2368 -> false)))
    | uu____2369 -> false
  
let (comp_result :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total (t,uu____2384) -> t
    | FStar_Syntax_Syntax.GTotal (t,uu____2394) -> t
    | FStar_Syntax_Syntax.Comp ct -> ct.FStar_Syntax_Syntax.result_typ
  
let (set_result_typ :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.comp)
  =
  fun c  ->
    fun t  ->
      match c.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Total uu____2422 ->
          FStar_Syntax_Syntax.mk_Total t
      | FStar_Syntax_Syntax.GTotal uu____2431 ->
          FStar_Syntax_Syntax.mk_GTotal t
      | FStar_Syntax_Syntax.Comp ct ->
          FStar_Syntax_Syntax.mk_Comp
            (let uu___125_2443 = ct  in
             {
               FStar_Syntax_Syntax.comp_univs =
                 (uu___125_2443.FStar_Syntax_Syntax.comp_univs);
               FStar_Syntax_Syntax.effect_name =
                 (uu___125_2443.FStar_Syntax_Syntax.effect_name);
               FStar_Syntax_Syntax.result_typ = t;
               FStar_Syntax_Syntax.effect_args =
                 (uu___125_2443.FStar_Syntax_Syntax.effect_args);
               FStar_Syntax_Syntax.flags =
                 (uu___125_2443.FStar_Syntax_Syntax.flags)
             })
  
let (set_result_typ_lc :
  FStar_Syntax_Syntax.lcomp ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.lcomp)
  =
  fun lc  ->
    fun t  ->
      FStar_Syntax_Syntax.mk_lcomp lc.FStar_Syntax_Syntax.eff_name t
        lc.FStar_Syntax_Syntax.cflags
        (fun uu____2456  ->
           let uu____2457 = FStar_Syntax_Syntax.lcomp_comp lc  in
           set_result_typ uu____2457 t)
  
let (is_trivial_wp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c  ->
    FStar_All.pipe_right (comp_flags c)
      (FStar_Util.for_some
         (fun uu___116_2472  ->
            match uu___116_2472 with
            | FStar_Syntax_Syntax.TOTAL  -> true
            | FStar_Syntax_Syntax.RETURN  -> true
            | uu____2473 -> false))
  
let (comp_effect_args : FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.args)
  =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total uu____2479 -> []
    | FStar_Syntax_Syntax.GTotal uu____2496 -> []
    | FStar_Syntax_Syntax.Comp ct -> ct.FStar_Syntax_Syntax.effect_args
  
let (primops : FStar_Ident.lident Prims.list) =
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
let (is_primop_lid : FStar_Ident.lident -> Prims.bool) =
  fun l  ->
    FStar_All.pipe_right primops
      (FStar_Util.for_some (FStar_Ident.lid_equals l))
  
let (is_primop :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun f  ->
    match f.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        is_primop_lid (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
    | uu____2533 -> false
  
let rec (unascribe : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun e  ->
    let e1 = FStar_Syntax_Subst.compress e  in
    match e1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_ascribed (e2,uu____2541,uu____2542) ->
        unascribe e2
    | uu____2583 -> e1
  
let rec (ascribe :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    ((FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.comp'
                                                             FStar_Syntax_Syntax.syntax)
       FStar_Util.either,FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
                           FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2 ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t  ->
    fun k  ->
      match t.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_ascribed (t',uu____2635,uu____2636) ->
          ascribe t' k
      | uu____2677 ->
          FStar_Syntax_Syntax.mk
            (FStar_Syntax_Syntax.Tm_ascribed
               (t, k, FStar_Pervasives_Native.None))
            FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
  
let (unfold_lazy : FStar_Syntax_Syntax.lazyinfo -> FStar_Syntax_Syntax.term)
  =
  fun i  ->
    let uu____2703 =
      let uu____2712 = FStar_ST.op_Bang FStar_Syntax_Syntax.lazy_chooser  in
      FStar_Util.must uu____2712  in
    uu____2703 i.FStar_Syntax_Syntax.lkind i
  
let rec (unlazy : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t  ->
    let uu____2767 =
      let uu____2768 = FStar_Syntax_Subst.compress t  in
      uu____2768.FStar_Syntax_Syntax.n  in
    match uu____2767 with
    | FStar_Syntax_Syntax.Tm_lazy i ->
        let uu____2772 = unfold_lazy i  in
        FStar_All.pipe_left unlazy uu____2772
    | uu____2773 -> t
  
let rec (unlazy_emb : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t  ->
    let uu____2779 =
      let uu____2780 = FStar_Syntax_Subst.compress t  in
      uu____2780.FStar_Syntax_Syntax.n  in
    match uu____2779 with
    | FStar_Syntax_Syntax.Tm_lazy i ->
        (match i.FStar_Syntax_Syntax.lkind with
         | FStar_Syntax_Syntax.Lazy_embedding uu____2784 ->
             let uu____2793 = unfold_lazy i  in
             FStar_All.pipe_left unlazy uu____2793
         | uu____2794 -> t)
    | uu____2795 -> t
  
let (eq_lazy_kind :
  FStar_Syntax_Syntax.lazy_kind ->
    FStar_Syntax_Syntax.lazy_kind -> Prims.bool)
  =
  fun k  ->
    fun k'  ->
      match (k, k') with
      | (FStar_Syntax_Syntax.BadLazy ,FStar_Syntax_Syntax.BadLazy ) -> true
      | (FStar_Syntax_Syntax.Lazy_bv ,FStar_Syntax_Syntax.Lazy_bv ) -> true
      | (FStar_Syntax_Syntax.Lazy_binder ,FStar_Syntax_Syntax.Lazy_binder )
          -> true
      | (FStar_Syntax_Syntax.Lazy_fvar ,FStar_Syntax_Syntax.Lazy_fvar ) ->
          true
      | (FStar_Syntax_Syntax.Lazy_comp ,FStar_Syntax_Syntax.Lazy_comp ) ->
          true
      | (FStar_Syntax_Syntax.Lazy_env ,FStar_Syntax_Syntax.Lazy_env ) -> true
      | (FStar_Syntax_Syntax.Lazy_proofstate
         ,FStar_Syntax_Syntax.Lazy_proofstate ) -> true
      | (FStar_Syntax_Syntax.Lazy_goal ,FStar_Syntax_Syntax.Lazy_goal ) ->
          true
      | (FStar_Syntax_Syntax.Lazy_sigelt ,FStar_Syntax_Syntax.Lazy_sigelt )
          -> true
      | (FStar_Syntax_Syntax.Lazy_uvar ,FStar_Syntax_Syntax.Lazy_uvar ) ->
          true
      | uu____2806 -> false
  
let rec unlazy_as_t :
  'Auu____2817 .
    FStar_Syntax_Syntax.lazy_kind -> FStar_Syntax_Syntax.term -> 'Auu____2817
  =
  fun k  ->
    fun t  ->
      let uu____2828 =
        let uu____2829 = FStar_Syntax_Subst.compress t  in
        uu____2829.FStar_Syntax_Syntax.n  in
      match uu____2828 with
      | FStar_Syntax_Syntax.Tm_lazy
          { FStar_Syntax_Syntax.blob = v1; FStar_Syntax_Syntax.lkind = k';
            FStar_Syntax_Syntax.ltyp = uu____2834;
            FStar_Syntax_Syntax.rng = uu____2835;_}
          when eq_lazy_kind k k' -> FStar_Dyn.undyn v1
      | uu____2838 -> failwith "Not a Tm_lazy of the expected kind"
  
let mk_lazy :
  'a .
    'a ->
      FStar_Syntax_Syntax.typ ->
        FStar_Syntax_Syntax.lazy_kind ->
          FStar_Range.range FStar_Pervasives_Native.option ->
            FStar_Syntax_Syntax.term
  =
  fun t  ->
    fun typ  ->
      fun k  ->
        fun r  ->
          let rng =
            match r with
            | FStar_Pervasives_Native.Some r1 -> r1
            | FStar_Pervasives_Native.None  -> FStar_Range.dummyRange  in
          let i =
            let uu____2877 = FStar_Dyn.mkdyn t  in
            {
              FStar_Syntax_Syntax.blob = uu____2877;
              FStar_Syntax_Syntax.lkind = k;
              FStar_Syntax_Syntax.ltyp = typ;
              FStar_Syntax_Syntax.rng = rng
            }  in
          FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_lazy i)
            FStar_Pervasives_Native.None rng
  
let (canon_app :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t  ->
    let uu____2889 =
      let uu____2904 = unascribe t  in head_and_args' uu____2904  in
    match uu____2889 with
    | (hd1,args) ->
        FStar_Syntax_Syntax.mk_Tm_app hd1 args FStar_Pervasives_Native.None
          t.FStar_Syntax_Syntax.pos
  
type eq_result =
  | Equal 
  | NotEqual 
  | Unknown 
let (uu___is_Equal : eq_result -> Prims.bool) =
  fun projectee  ->
    match projectee with | Equal  -> true | uu____2934 -> false
  
let (uu___is_NotEqual : eq_result -> Prims.bool) =
  fun projectee  ->
    match projectee with | NotEqual  -> true | uu____2940 -> false
  
let (uu___is_Unknown : eq_result -> Prims.bool) =
  fun projectee  ->
    match projectee with | Unknown  -> true | uu____2946 -> false
  
let (injectives : Prims.string Prims.list) =
  ["FStar.Int8.int_to_t";
  "FStar.Int16.int_to_t";
  "FStar.Int32.int_to_t";
  "FStar.Int64.int_to_t";
  "FStar.UInt8.uint_to_t";
  "FStar.UInt16.uint_to_t";
  "FStar.UInt32.uint_to_t";
  "FStar.UInt64.uint_to_t";
  "FStar.Int8.__int_to_t";
  "FStar.Int16.__int_to_t";
  "FStar.Int32.__int_to_t";
  "FStar.Int64.__int_to_t";
  "FStar.UInt8.__uint_to_t";
  "FStar.UInt16.__uint_to_t";
  "FStar.UInt32.__uint_to_t";
  "FStar.UInt64.__uint_to_t"] 
let rec (eq_tm :
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> eq_result) =
  fun t1  ->
    fun t2  ->
      let t11 = canon_app t1  in
      let t21 = canon_app t2  in
      let equal_if uu___117_3066 = if uu___117_3066 then Equal else Unknown
         in
      let equal_iff uu___118_3073 = if uu___118_3073 then Equal else NotEqual
         in
      let eq_and f g = match f with | Equal  -> g () | uu____3091 -> Unknown
         in
      let eq_inj f g =
        match (f, g) with
        | (Equal ,Equal ) -> Equal
        | (NotEqual ,uu____3103) -> NotEqual
        | (uu____3104,NotEqual ) -> NotEqual
        | (Unknown ,uu____3105) -> Unknown
        | (uu____3106,Unknown ) -> Unknown  in
      let equal_data f1 args1 f2 args2 =
        let uu____3128 = FStar_Syntax_Syntax.fv_eq f1 f2  in
        if uu____3128
        then
          let uu____3130 = FStar_List.zip args1 args2  in
          FStar_All.pipe_left
            (FStar_List.fold_left
               (fun acc  ->
                  fun uu____3207  ->
                    match uu____3207 with
                    | ((a1,q1),(a2,q2)) ->
                        let uu____3248 = eq_tm a1 a2  in
                        eq_inj acc uu____3248) Equal) uu____3130
        else NotEqual  in
      let uu____3250 =
        let uu____3255 =
          let uu____3256 = unmeta t11  in uu____3256.FStar_Syntax_Syntax.n
           in
        let uu____3259 =
          let uu____3260 = unmeta t21  in uu____3260.FStar_Syntax_Syntax.n
           in
        (uu____3255, uu____3259)  in
      match uu____3250 with
      | (FStar_Syntax_Syntax.Tm_bvar bv1,FStar_Syntax_Syntax.Tm_bvar bv2) ->
          equal_if
            (bv1.FStar_Syntax_Syntax.index = bv2.FStar_Syntax_Syntax.index)
      | (FStar_Syntax_Syntax.Tm_lazy uu____3265,uu____3266) ->
          let uu____3267 = unlazy t11  in eq_tm uu____3267 t21
      | (uu____3268,FStar_Syntax_Syntax.Tm_lazy uu____3269) ->
          let uu____3270 = unlazy t21  in eq_tm t11 uu____3270
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
            (let uu____3296 = FStar_Syntax_Syntax.fv_eq f g  in
             equal_if uu____3296)
      | (FStar_Syntax_Syntax.Tm_uinst (f,us),FStar_Syntax_Syntax.Tm_uinst
         (g,vs)) ->
          let uu____3309 = eq_tm f g  in
          eq_and uu____3309
            (fun uu____3312  ->
               let uu____3313 = eq_univs_list us vs  in equal_if uu____3313)
      | (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_range
         uu____3314),uu____3315) -> Unknown
      | (uu____3316,FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_range
         uu____3317)) -> Unknown
      | (FStar_Syntax_Syntax.Tm_constant c,FStar_Syntax_Syntax.Tm_constant d)
          ->
          let uu____3320 = FStar_Const.eq_const c d  in equal_iff uu____3320
      | (FStar_Syntax_Syntax.Tm_uvar
         (u1,([],uu____3322)),FStar_Syntax_Syntax.Tm_uvar
         (u2,([],uu____3324))) ->
          let uu____3353 =
            FStar_Syntax_Unionfind.equiv u1.FStar_Syntax_Syntax.ctx_uvar_head
              u2.FStar_Syntax_Syntax.ctx_uvar_head
             in
          equal_if uu____3353
      | (FStar_Syntax_Syntax.Tm_app (h1,args1),FStar_Syntax_Syntax.Tm_app
         (h2,args2)) ->
          let uu____3406 =
            let uu____3411 =
              let uu____3412 = un_uinst h1  in
              uu____3412.FStar_Syntax_Syntax.n  in
            let uu____3415 =
              let uu____3416 = un_uinst h2  in
              uu____3416.FStar_Syntax_Syntax.n  in
            (uu____3411, uu____3415)  in
          (match uu____3406 with
           | (FStar_Syntax_Syntax.Tm_fvar f1,FStar_Syntax_Syntax.Tm_fvar f2)
               when
               (f1.FStar_Syntax_Syntax.fv_qual =
                  (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor))
                 &&
                 (f2.FStar_Syntax_Syntax.fv_qual =
                    (FStar_Pervasives_Native.Some
                       FStar_Syntax_Syntax.Data_ctor))
               -> equal_data f1 args1 f2 args2
           | (FStar_Syntax_Syntax.Tm_fvar f1,FStar_Syntax_Syntax.Tm_fvar f2)
               when
               (FStar_Syntax_Syntax.fv_eq f1 f2) &&
                 (let uu____3428 =
                    let uu____3429 = FStar_Syntax_Syntax.lid_of_fv f1  in
                    FStar_Ident.string_of_lid uu____3429  in
                  FStar_List.mem uu____3428 injectives)
               -> equal_data f1 args1 f2 args2
           | uu____3430 ->
               let uu____3435 = eq_tm h1 h2  in
               eq_and uu____3435 (fun uu____3437  -> eq_args args1 args2))
      | (FStar_Syntax_Syntax.Tm_match (t12,bs1),FStar_Syntax_Syntax.Tm_match
         (t22,bs2)) ->
          if (FStar_List.length bs1) = (FStar_List.length bs2)
          then
            let uu____3542 = FStar_List.zip bs1 bs2  in
            let uu____3605 = eq_tm t12 t22  in
            FStar_List.fold_right
              (fun uu____3642  ->
                 fun a  ->
                   match uu____3642 with
                   | (b1,b2) ->
                       eq_and a (fun uu____3735  -> branch_matches b1 b2))
              uu____3542 uu____3605
          else Unknown
      | (FStar_Syntax_Syntax.Tm_type u,FStar_Syntax_Syntax.Tm_type v1) ->
          let uu____3739 = eq_univs u v1  in equal_if uu____3739
      | (FStar_Syntax_Syntax.Tm_quoted (t12,q1),FStar_Syntax_Syntax.Tm_quoted
         (t22,q2)) ->
          let uu____3752 = eq_quoteinfo q1 q2  in
          eq_and uu____3752 (fun uu____3754  -> eq_tm t12 t22)
      | (FStar_Syntax_Syntax.Tm_refine
         (t12,phi1),FStar_Syntax_Syntax.Tm_refine (t22,phi2)) ->
          let uu____3767 =
            eq_tm t12.FStar_Syntax_Syntax.sort t22.FStar_Syntax_Syntax.sort
             in
          eq_and uu____3767 (fun uu____3769  -> eq_tm phi1 phi2)
      | uu____3770 -> Unknown

and (eq_quoteinfo :
  FStar_Syntax_Syntax.quoteinfo -> FStar_Syntax_Syntax.quoteinfo -> eq_result)
  =
  fun q1  ->
    fun q2  ->
      if q1.FStar_Syntax_Syntax.qkind <> q2.FStar_Syntax_Syntax.qkind
      then NotEqual
      else
        eq_antiquotes q1.FStar_Syntax_Syntax.antiquotes
          q2.FStar_Syntax_Syntax.antiquotes

and (eq_antiquotes :
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.term'
                            FStar_Syntax_Syntax.syntax)
    FStar_Pervasives_Native.tuple2 Prims.list ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.term'
                              FStar_Syntax_Syntax.syntax)
      FStar_Pervasives_Native.tuple2 Prims.list -> eq_result)
  =
  fun a1  ->
    fun a2  ->
      match (a1, a2) with
      | ([],[]) -> Equal
      | ([],uu____3840) -> NotEqual
      | (uu____3871,[]) -> NotEqual
      | ((x1,t1)::a11,(x2,t2)::a21) ->
          if Prims.op_Negation (FStar_Syntax_Syntax.bv_eq x1 x2)
          then NotEqual
          else
            (let uu____3961 = eq_tm t1 t2  in
             match uu____3961 with
             | NotEqual  -> NotEqual
             | Unknown  ->
                 let uu____3962 = eq_antiquotes a11 a21  in
                 (match uu____3962 with
                  | NotEqual  -> NotEqual
                  | uu____3963 -> Unknown)
             | Equal  -> eq_antiquotes a11 a21)

and (eq_aqual :
  FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option ->
      eq_result)
  =
  fun a1  ->
    fun a2  ->
      match (a1, a2) with
      | (FStar_Pervasives_Native.None ,FStar_Pervasives_Native.None ) ->
          Equal
      | (FStar_Pervasives_Native.None ,uu____3978) -> NotEqual
      | (uu____3985,FStar_Pervasives_Native.None ) -> NotEqual
      | (FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Implicit
         b1),FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Implicit b2))
          when b1 = b2 -> Equal
      | (FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Meta
         t1),FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Meta t2)) ->
          eq_tm t1 t2
      | uu____4008 -> NotEqual

and (branch_matches :
  (FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t,FStar_Syntax_Syntax.term'
                                                             FStar_Syntax_Syntax.syntax
                                                             FStar_Pervasives_Native.option,
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
    FStar_Pervasives_Native.tuple3 ->
    (FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t,FStar_Syntax_Syntax.term'
                                                               FStar_Syntax_Syntax.syntax
                                                               FStar_Pervasives_Native.option,
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
      FStar_Pervasives_Native.tuple3 -> eq_result)
  =
  fun b1  ->
    fun b2  ->
      let related_by f o1 o2 =
        match (o1, o2) with
        | (FStar_Pervasives_Native.None ,FStar_Pervasives_Native.None ) ->
            true
        | (FStar_Pervasives_Native.Some x,FStar_Pervasives_Native.Some y) ->
            f x y
        | (uu____4095,uu____4096) -> false  in
      let uu____4105 = b1  in
      match uu____4105 with
      | (p1,w1,t1) ->
          let uu____4139 = b2  in
          (match uu____4139 with
           | (p2,w2,t2) ->
               let uu____4173 = FStar_Syntax_Syntax.eq_pat p1 p2  in
               if uu____4173
               then
                 let uu____4174 =
                   (let uu____4177 = eq_tm t1 t2  in uu____4177 = Equal) &&
                     (related_by
                        (fun t11  ->
                           fun t21  ->
                             let uu____4186 = eq_tm t11 t21  in
                             uu____4186 = Equal) w1 w2)
                    in
                 (if uu____4174 then Equal else Unknown)
               else Unknown)

and (eq_args :
  FStar_Syntax_Syntax.args -> FStar_Syntax_Syntax.args -> eq_result) =
  fun a1  ->
    fun a2  ->
      match (a1, a2) with
      | ([],[]) -> Equal
      | ((a,uu____4248)::a11,(b,uu____4251)::b1) ->
          let uu____4325 = eq_tm a b  in
          (match uu____4325 with
           | Equal  -> eq_args a11 b1
           | uu____4326 -> Unknown)
      | uu____4327 -> Unknown

and (eq_univs_list :
  FStar_Syntax_Syntax.universes ->
    FStar_Syntax_Syntax.universes -> Prims.bool)
  =
  fun us  ->
    fun vs  ->
      ((FStar_List.length us) = (FStar_List.length vs)) &&
        (FStar_List.forall2 eq_univs us vs)

let rec (unrefine : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t  ->
    let t1 = FStar_Syntax_Subst.compress t  in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_refine (x,uu____4361) ->
        unrefine x.FStar_Syntax_Syntax.sort
    | FStar_Syntax_Syntax.Tm_ascribed (t2,uu____4367,uu____4368) ->
        unrefine t2
    | uu____4409 -> t1
  
let rec (is_uvar : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  ->
    let uu____4415 =
      let uu____4416 = FStar_Syntax_Subst.compress t  in
      uu____4416.FStar_Syntax_Syntax.n  in
    match uu____4415 with
    | FStar_Syntax_Syntax.Tm_uvar uu____4419 -> true
    | FStar_Syntax_Syntax.Tm_uinst (t1,uu____4433) -> is_uvar t1
    | FStar_Syntax_Syntax.Tm_app uu____4438 ->
        let uu____4455 =
          let uu____4456 = FStar_All.pipe_right t head_and_args  in
          FStar_All.pipe_right uu____4456 FStar_Pervasives_Native.fst  in
        FStar_All.pipe_right uu____4455 is_uvar
    | FStar_Syntax_Syntax.Tm_ascribed (t1,uu____4518,uu____4519) ->
        is_uvar t1
    | uu____4560 -> false
  
let rec (is_unit : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  ->
    let uu____4566 =
      let uu____4567 = unrefine t  in uu____4567.FStar_Syntax_Syntax.n  in
    match uu____4566 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        ((FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.unit_lid) ||
           (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.squash_lid))
          ||
          (FStar_Syntax_Syntax.fv_eq_lid fv
             FStar_Parser_Const.auto_squash_lid)
    | FStar_Syntax_Syntax.Tm_uinst (t1,uu____4572) -> is_unit t1
    | uu____4577 -> false
  
let rec (non_informative : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  ->
    let uu____4583 =
      let uu____4584 = unrefine t  in uu____4584.FStar_Syntax_Syntax.n  in
    match uu____4583 with
    | FStar_Syntax_Syntax.Tm_type uu____4587 -> true
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        ((FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.unit_lid) ||
           (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.squash_lid))
          || (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.erased_lid)
    | FStar_Syntax_Syntax.Tm_app (head1,uu____4590) -> non_informative head1
    | FStar_Syntax_Syntax.Tm_uinst (t1,uu____4616) -> non_informative t1
    | FStar_Syntax_Syntax.Tm_arrow (uu____4621,c) ->
        (is_tot_or_gtot_comp c) && (non_informative (comp_result c))
    | uu____4643 -> false
  
let (is_fun : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun e  ->
    let uu____4649 =
      let uu____4650 = FStar_Syntax_Subst.compress e  in
      uu____4650.FStar_Syntax_Syntax.n  in
    match uu____4649 with
    | FStar_Syntax_Syntax.Tm_abs uu____4653 -> true
    | uu____4672 -> false
  
let (is_function_typ : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  ->
    let uu____4678 =
      let uu____4679 = FStar_Syntax_Subst.compress t  in
      uu____4679.FStar_Syntax_Syntax.n  in
    match uu____4678 with
    | FStar_Syntax_Syntax.Tm_arrow uu____4682 -> true
    | uu____4697 -> false
  
let rec (pre_typ : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t  ->
    let t1 = FStar_Syntax_Subst.compress t  in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_refine (x,uu____4705) ->
        pre_typ x.FStar_Syntax_Syntax.sort
    | FStar_Syntax_Syntax.Tm_ascribed (t2,uu____4711,uu____4712) ->
        pre_typ t2
    | uu____4753 -> t1
  
let (destruct :
  FStar_Syntax_Syntax.term ->
    FStar_Ident.lident ->
      (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.arg_qualifier
                                                              FStar_Pervasives_Native.option)
        FStar_Pervasives_Native.tuple2 Prims.list
        FStar_Pervasives_Native.option)
  =
  fun typ  ->
    fun lid  ->
      let typ1 = FStar_Syntax_Subst.compress typ  in
      let uu____4777 =
        let uu____4778 = un_uinst typ1  in uu____4778.FStar_Syntax_Syntax.n
         in
      match uu____4777 with
      | FStar_Syntax_Syntax.Tm_app (head1,args) ->
          let head2 = un_uinst head1  in
          (match head2.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Tm_fvar tc when
               FStar_Syntax_Syntax.fv_eq_lid tc lid ->
               FStar_Pervasives_Native.Some args
           | uu____4843 -> FStar_Pervasives_Native.None)
      | FStar_Syntax_Syntax.Tm_fvar tc when
          FStar_Syntax_Syntax.fv_eq_lid tc lid ->
          FStar_Pervasives_Native.Some []
      | uu____4873 -> FStar_Pervasives_Native.None
  
let (lids_of_sigelt :
  FStar_Syntax_Syntax.sigelt -> FStar_Ident.lident Prims.list) =
  fun se  ->
    match se.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_let (uu____4893,lids) -> lids
    | FStar_Syntax_Syntax.Sig_splice (lids,uu____4900) -> lids
    | FStar_Syntax_Syntax.Sig_bundle (uu____4905,lids) -> lids
    | FStar_Syntax_Syntax.Sig_inductive_typ
        (lid,uu____4916,uu____4917,uu____4918,uu____4919,uu____4920) -> 
        [lid]
    | FStar_Syntax_Syntax.Sig_effect_abbrev
        (lid,uu____4930,uu____4931,uu____4932,uu____4933) -> [lid]
    | FStar_Syntax_Syntax.Sig_datacon
        (lid,uu____4939,uu____4940,uu____4941,uu____4942,uu____4943) -> 
        [lid]
    | FStar_Syntax_Syntax.Sig_declare_typ (lid,uu____4949,uu____4950) ->
        [lid]
    | FStar_Syntax_Syntax.Sig_assume (lid,uu____4952,uu____4953) -> [lid]
    | FStar_Syntax_Syntax.Sig_new_effect_for_free n1 ->
        [n1.FStar_Syntax_Syntax.mname]
    | FStar_Syntax_Syntax.Sig_new_effect n1 -> [n1.FStar_Syntax_Syntax.mname]
    | FStar_Syntax_Syntax.Sig_sub_effect uu____4956 -> []
    | FStar_Syntax_Syntax.Sig_pragma uu____4957 -> []
    | FStar_Syntax_Syntax.Sig_main uu____4958 -> []
  
let (lid_of_sigelt :
  FStar_Syntax_Syntax.sigelt ->
    FStar_Ident.lident FStar_Pervasives_Native.option)
  =
  fun se  ->
    match lids_of_sigelt se with
    | l::[] -> FStar_Pervasives_Native.Some l
    | uu____4971 -> FStar_Pervasives_Native.None
  
let (quals_of_sigelt :
  FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.qualifier Prims.list) =
  fun x  -> x.FStar_Syntax_Syntax.sigquals 
let (range_of_sigelt : FStar_Syntax_Syntax.sigelt -> FStar_Range.range) =
  fun x  -> x.FStar_Syntax_Syntax.sigrng 
let (range_of_lbname :
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.fv) FStar_Util.either ->
    FStar_Range.range)
  =
  fun uu___119_4994  ->
    match uu___119_4994 with
    | FStar_Util.Inl x -> FStar_Syntax_Syntax.range_of_bv x
    | FStar_Util.Inr fv ->
        FStar_Ident.range_of_lid
          (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
  
let range_of_arg :
  'Auu____5007 'Auu____5008 .
    ('Auu____5007 FStar_Syntax_Syntax.syntax,'Auu____5008)
      FStar_Pervasives_Native.tuple2 -> FStar_Range.range
  =
  fun uu____5019  ->
    match uu____5019 with | (hd1,uu____5027) -> hd1.FStar_Syntax_Syntax.pos
  
let range_of_args :
  'Auu____5040 'Auu____5041 .
    ('Auu____5040 FStar_Syntax_Syntax.syntax,'Auu____5041)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      FStar_Range.range -> FStar_Range.range
  =
  fun args  ->
    fun r  ->
      FStar_All.pipe_right args
        (FStar_List.fold_left
           (fun r1  -> fun a  -> FStar_Range.union_ranges r1 (range_of_arg a))
           r)
  
let (mk_app :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.arg_qualifier
                                                            FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun f  ->
    fun args  ->
      match args with
      | [] -> f
      | uu____5138 ->
          let r = range_of_args args f.FStar_Syntax_Syntax.pos  in
          FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_app (f, args))
            FStar_Pervasives_Native.None r
  
let (mk_app_binders :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                              FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun f  ->
    fun bs  ->
      let uu____5196 =
        FStar_List.map
          (fun uu____5223  ->
             match uu____5223 with
             | (bv,aq) ->
                 let uu____5242 = FStar_Syntax_Syntax.bv_to_name bv  in
                 (uu____5242, aq)) bs
         in
      mk_app f uu____5196
  
let (mk_data :
  FStar_Ident.lident ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.arg_qualifier
                                                            FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
        FStar_Syntax_Syntax.syntax)
  =
  fun l  ->
    fun args  ->
      match args with
      | [] ->
          let uu____5291 = FStar_Ident.range_of_lid l  in
          let uu____5292 =
            let uu____5301 =
              FStar_Syntax_Syntax.fvar l FStar_Syntax_Syntax.delta_constant
                (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor)
               in
            FStar_Syntax_Syntax.mk uu____5301  in
          uu____5292 FStar_Pervasives_Native.None uu____5291
      | uu____5309 ->
          let e =
            let uu____5323 =
              FStar_Syntax_Syntax.fvar l FStar_Syntax_Syntax.delta_constant
                (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor)
               in
            mk_app uu____5323 args  in
          FStar_Syntax_Syntax.mk e FStar_Pervasives_Native.None
            e.FStar_Syntax_Syntax.pos
  
let (mangle_field_name : FStar_Ident.ident -> FStar_Ident.ident) =
  fun x  ->
    FStar_Ident.mk_ident
      ((Prims.strcat "__fname__" x.FStar_Ident.idText),
        (x.FStar_Ident.idRange))
  
let (unmangle_field_name : FStar_Ident.ident -> FStar_Ident.ident) =
  fun x  ->
    if FStar_Util.starts_with x.FStar_Ident.idText "__fname__"
    then
      let uu____5338 =
        let uu____5343 =
          FStar_Util.substring_from x.FStar_Ident.idText
            (Prims.parse_int "9")
           in
        (uu____5343, (x.FStar_Ident.idRange))  in
      FStar_Ident.mk_ident uu____5338
    else x
  
let (field_projector_prefix : Prims.string) = "__proj__" 
let (field_projector_sep : Prims.string) = "__item__" 
let (field_projector_contains_constructor : Prims.string -> Prims.bool) =
  fun s  -> FStar_Util.starts_with s field_projector_prefix 
let (mk_field_projector_name_from_string :
  Prims.string -> Prims.string -> Prims.string) =
  fun constr  ->
    fun field  ->
      Prims.strcat field_projector_prefix
        (Prims.strcat constr (Prims.strcat field_projector_sep field))
  
let (mk_field_projector_name_from_ident :
  FStar_Ident.lident -> FStar_Ident.ident -> FStar_Ident.lident) =
  fun lid  ->
    fun i  ->
      let j = unmangle_field_name i  in
      let jtext = j.FStar_Ident.idText  in
      let newi =
        if field_projector_contains_constructor jtext
        then j
        else
          FStar_Ident.mk_ident
            ((mk_field_projector_name_from_string
                (lid.FStar_Ident.ident).FStar_Ident.idText jtext),
              (i.FStar_Ident.idRange))
         in
      FStar_Ident.lid_of_ids (FStar_List.append lid.FStar_Ident.ns [newi])
  
let (mk_field_projector_name :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.bv ->
      Prims.int ->
        (FStar_Ident.lident,FStar_Syntax_Syntax.bv)
          FStar_Pervasives_Native.tuple2)
  =
  fun lid  ->
    fun x  ->
      fun i  ->
        let nm =
          let uu____5394 = FStar_Syntax_Syntax.is_null_bv x  in
          if uu____5394
          then
            let uu____5395 =
              let uu____5400 =
                let uu____5401 = FStar_Util.string_of_int i  in
                Prims.strcat "_" uu____5401  in
              let uu____5402 = FStar_Syntax_Syntax.range_of_bv x  in
              (uu____5400, uu____5402)  in
            FStar_Ident.mk_ident uu____5395
          else x.FStar_Syntax_Syntax.ppname  in
        let y =
          let uu___126_5405 = x  in
          {
            FStar_Syntax_Syntax.ppname = nm;
            FStar_Syntax_Syntax.index =
              (uu___126_5405.FStar_Syntax_Syntax.index);
            FStar_Syntax_Syntax.sort =
              (uu___126_5405.FStar_Syntax_Syntax.sort)
          }  in
        let uu____5406 = mk_field_projector_name_from_ident lid nm  in
        (uu____5406, y)
  
let (ses_of_sigbundle :
  FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.sigelt Prims.list) =
  fun se  ->
    match se.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_bundle (ses,uu____5417) -> ses
    | uu____5426 -> failwith "ses_of_sigbundle: not a Sig_bundle"
  
let (eff_decl_of_new_effect :
  FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.eff_decl) =
  fun se  ->
    match se.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_new_effect ne -> ne
    | uu____5435 -> failwith "eff_decl_of_new_effect: not a Sig_new_effect"
  
let (set_uvar : FStar_Syntax_Syntax.uvar -> FStar_Syntax_Syntax.term -> unit)
  =
  fun uv  ->
    fun t  ->
      let uu____5446 = FStar_Syntax_Unionfind.find uv  in
      match uu____5446 with
      | FStar_Pervasives_Native.Some uu____5449 ->
          let uu____5450 =
            let uu____5451 =
              let uu____5452 = FStar_Syntax_Unionfind.uvar_id uv  in
              FStar_All.pipe_left FStar_Util.string_of_int uu____5452  in
            FStar_Util.format1 "Changing a fixed uvar! ?%s\n" uu____5451  in
          failwith uu____5450
      | uu____5453 -> FStar_Syntax_Unionfind.change uv t
  
let (qualifier_equal :
  FStar_Syntax_Syntax.qualifier ->
    FStar_Syntax_Syntax.qualifier -> Prims.bool)
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
      | uu____5528 -> q1 = q2
  
let (abs :
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.residual_comp FStar_Pervasives_Native.option ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun bs  ->
    fun t  ->
      fun lopt  ->
        let close_lopt lopt1 =
          match lopt1 with
          | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
          | FStar_Pervasives_Native.Some rc ->
              let uu____5573 =
                let uu___127_5574 = rc  in
                let uu____5575 =
                  FStar_Util.map_opt rc.FStar_Syntax_Syntax.residual_typ
                    (FStar_Syntax_Subst.close bs)
                   in
                {
                  FStar_Syntax_Syntax.residual_effect =
                    (uu___127_5574.FStar_Syntax_Syntax.residual_effect);
                  FStar_Syntax_Syntax.residual_typ = uu____5575;
                  FStar_Syntax_Syntax.residual_flags =
                    (uu___127_5574.FStar_Syntax_Syntax.residual_flags)
                }  in
              FStar_Pervasives_Native.Some uu____5573
           in
        match bs with
        | [] -> t
        | uu____5592 ->
            let body =
              let uu____5594 = FStar_Syntax_Subst.close bs t  in
              FStar_Syntax_Subst.compress uu____5594  in
            (match body.FStar_Syntax_Syntax.n with
             | FStar_Syntax_Syntax.Tm_abs (bs',t1,lopt') ->
                 let uu____5624 =
                   let uu____5631 =
                     let uu____5632 =
                       let uu____5651 =
                         let uu____5660 = FStar_Syntax_Subst.close_binders bs
                            in
                         FStar_List.append uu____5660 bs'  in
                       let uu____5675 = close_lopt lopt'  in
                       (uu____5651, t1, uu____5675)  in
                     FStar_Syntax_Syntax.Tm_abs uu____5632  in
                   FStar_Syntax_Syntax.mk uu____5631  in
                 uu____5624 FStar_Pervasives_Native.None
                   t1.FStar_Syntax_Syntax.pos
             | uu____5693 ->
                 let uu____5694 =
                   let uu____5701 =
                     let uu____5702 =
                       let uu____5721 = FStar_Syntax_Subst.close_binders bs
                          in
                       let uu____5730 = close_lopt lopt  in
                       (uu____5721, body, uu____5730)  in
                     FStar_Syntax_Syntax.Tm_abs uu____5702  in
                   FStar_Syntax_Syntax.mk uu____5701  in
                 uu____5694 FStar_Pervasives_Native.None
                   t.FStar_Syntax_Syntax.pos)
  
let (arrow :
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                            FStar_Pervasives_Native.option)
    FStar_Pervasives_Native.tuple2 Prims.list ->
    FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun bs  ->
    fun c  ->
      match bs with
      | [] -> comp_result c
      | uu____5788 ->
          let uu____5797 =
            let uu____5804 =
              let uu____5805 =
                let uu____5820 = FStar_Syntax_Subst.close_binders bs  in
                let uu____5829 = FStar_Syntax_Subst.close_comp bs c  in
                (uu____5820, uu____5829)  in
              FStar_Syntax_Syntax.Tm_arrow uu____5805  in
            FStar_Syntax_Syntax.mk uu____5804  in
          uu____5797 FStar_Pervasives_Native.None c.FStar_Syntax_Syntax.pos
  
let (flat_arrow :
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                            FStar_Pervasives_Native.option)
    FStar_Pervasives_Native.tuple2 Prims.list ->
    FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun bs  ->
    fun c  ->
      let t = arrow bs c  in
      let uu____5880 =
        let uu____5881 = FStar_Syntax_Subst.compress t  in
        uu____5881.FStar_Syntax_Syntax.n  in
      match uu____5880 with
      | FStar_Syntax_Syntax.Tm_arrow (bs1,c1) ->
          (match c1.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Total (tres,uu____5911) ->
               let uu____5920 =
                 let uu____5921 = FStar_Syntax_Subst.compress tres  in
                 uu____5921.FStar_Syntax_Syntax.n  in
               (match uu____5920 with
                | FStar_Syntax_Syntax.Tm_arrow (bs',c') ->
                    FStar_Syntax_Syntax.mk
                      (FStar_Syntax_Syntax.Tm_arrow
                         ((FStar_List.append bs1 bs'), c'))
                      FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
                | uu____5964 -> t)
           | uu____5965 -> t)
      | uu____5966 -> t
  
let (refine :
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun b  ->
    fun t  ->
      let uu____5983 =
        let uu____5984 = FStar_Syntax_Syntax.range_of_bv b  in
        FStar_Range.union_ranges uu____5984 t.FStar_Syntax_Syntax.pos  in
      let uu____5985 =
        let uu____5992 =
          let uu____5993 =
            let uu____6000 =
              let uu____6003 =
                let uu____6004 = FStar_Syntax_Syntax.mk_binder b  in
                [uu____6004]  in
              FStar_Syntax_Subst.close uu____6003 t  in
            (b, uu____6000)  in
          FStar_Syntax_Syntax.Tm_refine uu____5993  in
        FStar_Syntax_Syntax.mk uu____5992  in
      uu____5985 FStar_Pervasives_Native.None uu____5983
  
let (branch : FStar_Syntax_Syntax.branch -> FStar_Syntax_Syntax.branch) =
  fun b  -> FStar_Syntax_Subst.close_branch b 
let rec (arrow_formals_comp :
  FStar_Syntax_Syntax.term ->
    ((FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                               FStar_Pervasives_Native.option)
       FStar_Pervasives_Native.tuple2 Prims.list,FStar_Syntax_Syntax.comp)
      FStar_Pervasives_Native.tuple2)
  =
  fun k  ->
    let k1 = FStar_Syntax_Subst.compress k  in
    match k1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
        let uu____6085 = FStar_Syntax_Subst.open_comp bs c  in
        (match uu____6085 with
         | (bs1,c1) ->
             let uu____6104 = is_total_comp c1  in
             if uu____6104
             then
               let uu____6117 = arrow_formals_comp (comp_result c1)  in
               (match uu____6117 with
                | (bs',k2) -> ((FStar_List.append bs1 bs'), k2))
             else (bs1, c1))
    | FStar_Syntax_Syntax.Tm_refine
        ({ FStar_Syntax_Syntax.ppname = uu____6183;
           FStar_Syntax_Syntax.index = uu____6184;
           FStar_Syntax_Syntax.sort = k2;_},uu____6186)
        -> arrow_formals_comp k2
    | uu____6193 ->
        let uu____6194 = FStar_Syntax_Syntax.mk_Total k1  in ([], uu____6194)
  
let rec (arrow_formals :
  FStar_Syntax_Syntax.term ->
    ((FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                               FStar_Pervasives_Native.option)
       FStar_Pervasives_Native.tuple2 Prims.list,FStar_Syntax_Syntax.term'
                                                   FStar_Syntax_Syntax.syntax)
      FStar_Pervasives_Native.tuple2)
  =
  fun k  ->
    let uu____6228 = arrow_formals_comp k  in
    match uu____6228 with | (bs,c) -> (bs, (comp_result c))
  
let (let_rec_arity :
  FStar_Syntax_Syntax.letbinding ->
    (Prims.int,Prims.bool Prims.list FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2)
  =
  fun lb  ->
    let rec arrow_until_decreases k =
      let k1 = FStar_Syntax_Subst.compress k  in
      match k1.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
          let uu____6365 = FStar_Syntax_Subst.open_comp bs c  in
          (match uu____6365 with
           | (bs1,c1) ->
               let ct = comp_to_comp_typ c1  in
               let uu____6389 =
                 FStar_All.pipe_right ct.FStar_Syntax_Syntax.flags
                   (FStar_Util.find_opt
                      (fun uu___120_6398  ->
                         match uu___120_6398 with
                         | FStar_Syntax_Syntax.DECREASES uu____6399 -> true
                         | uu____6402 -> false))
                  in
               (match uu____6389 with
                | FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.DECREASES
                    d) -> (bs1, (FStar_Pervasives_Native.Some d))
                | uu____6436 ->
                    let uu____6439 = is_total_comp c1  in
                    if uu____6439
                    then
                      let uu____6456 = arrow_until_decreases (comp_result c1)
                         in
                      (match uu____6456 with
                       | (bs',d) -> ((FStar_List.append bs1 bs'), d))
                    else (bs1, FStar_Pervasives_Native.None)))
      | FStar_Syntax_Syntax.Tm_refine
          ({ FStar_Syntax_Syntax.ppname = uu____6548;
             FStar_Syntax_Syntax.index = uu____6549;
             FStar_Syntax_Syntax.sort = k2;_},uu____6551)
          -> arrow_until_decreases k2
      | uu____6558 -> ([], FStar_Pervasives_Native.None)  in
    let uu____6579 = arrow_until_decreases lb.FStar_Syntax_Syntax.lbtyp  in
    match uu____6579 with
    | (bs,dopt) ->
        let n_univs = FStar_List.length lb.FStar_Syntax_Syntax.lbunivs  in
        let uu____6631 =
          FStar_Util.map_opt dopt
            (fun d  ->
               let d_bvs = FStar_Syntax_Free.names d  in
               let uu____6650 =
                 FStar_Common.tabulate n_univs (fun uu____6658  -> false)  in
               let uu____6659 =
                 FStar_All.pipe_right bs
                   (FStar_List.map
                      (fun uu____6681  ->
                         match uu____6681 with
                         | (x,uu____6689) -> FStar_Util.set_mem x d_bvs))
                  in
               FStar_List.append uu____6650 uu____6659)
           in
        ((n_univs + (FStar_List.length bs)), uu____6631)
  
let (abs_formals :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.binders,FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.residual_comp
                                                            FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple3)
  =
  fun t  ->
    let subst_lcomp_opt s l =
      match l with
      | FStar_Pervasives_Native.Some rc ->
          let uu____6747 =
            let uu___128_6748 = rc  in
            let uu____6749 =
              FStar_Util.map_opt rc.FStar_Syntax_Syntax.residual_typ
                (FStar_Syntax_Subst.subst s)
               in
            {
              FStar_Syntax_Syntax.residual_effect =
                (uu___128_6748.FStar_Syntax_Syntax.residual_effect);
              FStar_Syntax_Syntax.residual_typ = uu____6749;
              FStar_Syntax_Syntax.residual_flags =
                (uu___128_6748.FStar_Syntax_Syntax.residual_flags)
            }  in
          FStar_Pervasives_Native.Some uu____6747
      | uu____6758 -> l  in
    let rec aux t1 abs_body_lcomp =
      let uu____6792 =
        let uu____6793 =
          let uu____6796 = FStar_Syntax_Subst.compress t1  in
          FStar_All.pipe_left unascribe uu____6796  in
        uu____6793.FStar_Syntax_Syntax.n  in
      match uu____6792 with
      | FStar_Syntax_Syntax.Tm_abs (bs,t2,what) ->
          let uu____6842 = aux t2 what  in
          (match uu____6842 with
           | (bs',t3,what1) -> ((FStar_List.append bs bs'), t3, what1))
      | uu____6914 -> ([], t1, abs_body_lcomp)  in
    let uu____6931 = aux t FStar_Pervasives_Native.None  in
    match uu____6931 with
    | (bs,t1,abs_body_lcomp) ->
        let uu____6979 = FStar_Syntax_Subst.open_term' bs t1  in
        (match uu____6979 with
         | (bs1,t2,opening) ->
             let abs_body_lcomp1 = subst_lcomp_opt opening abs_body_lcomp  in
             (bs1, t2, abs_body_lcomp1))
  
let (mk_letbinding :
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.fv) FStar_Util.either ->
    FStar_Syntax_Syntax.univ_name Prims.list ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Ident.lident ->
          FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
            FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax Prims.list
              -> FStar_Range.range -> FStar_Syntax_Syntax.letbinding)
  =
  fun lbname  ->
    fun univ_vars  ->
      fun typ  ->
        fun eff  ->
          fun def  ->
            fun lbattrs  ->
              fun pos  ->
                {
                  FStar_Syntax_Syntax.lbname = lbname;
                  FStar_Syntax_Syntax.lbunivs = univ_vars;
                  FStar_Syntax_Syntax.lbtyp = typ;
                  FStar_Syntax_Syntax.lbeff = eff;
                  FStar_Syntax_Syntax.lbdef = def;
                  FStar_Syntax_Syntax.lbattrs = lbattrs;
                  FStar_Syntax_Syntax.lbpos = pos
                }
  
let (close_univs_and_mk_letbinding :
  FStar_Syntax_Syntax.fv Prims.list FStar_Pervasives_Native.option ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.fv) FStar_Util.either ->
      FStar_Syntax_Syntax.univ_name Prims.list ->
        FStar_Syntax_Syntax.term ->
          FStar_Ident.lident ->
            FStar_Syntax_Syntax.term ->
              FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax Prims.list
                -> FStar_Range.range -> FStar_Syntax_Syntax.letbinding)
  =
  fun recs  ->
    fun lbname  ->
      fun univ_vars  ->
        fun typ  ->
          fun eff  ->
            fun def  ->
              fun attrs  ->
                fun pos  ->
                  let def1 =
                    match (recs, univ_vars) with
                    | (FStar_Pervasives_Native.None ,uu____7140) -> def
                    | (uu____7151,[]) -> def
                    | (FStar_Pervasives_Native.Some fvs,uu____7163) ->
                        let universes =
                          FStar_All.pipe_right univ_vars
                            (FStar_List.map
                               (fun _0_4  -> FStar_Syntax_Syntax.U_name _0_4))
                           in
                        let inst1 =
                          FStar_All.pipe_right fvs
                            (FStar_List.map
                               (fun fv  ->
                                  (((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v),
                                    universes)))
                           in
                        FStar_Syntax_InstFV.instantiate inst1 def
                     in
                  let typ1 = FStar_Syntax_Subst.close_univ_vars univ_vars typ
                     in
                  let def2 =
                    FStar_Syntax_Subst.close_univ_vars univ_vars def1  in
                  mk_letbinding lbname univ_vars typ1 eff def2 attrs pos
  
let (open_univ_vars_binders_and_comp :
  FStar_Syntax_Syntax.univ_names ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                              FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
        (FStar_Syntax_Syntax.univ_names,(FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                                                                  FStar_Pervasives_Native.option)
                                          FStar_Pervasives_Native.tuple2
                                          Prims.list,FStar_Syntax_Syntax.comp)
          FStar_Pervasives_Native.tuple3)
  =
  fun uvs  ->
    fun binders  ->
      fun c  ->
        match binders with
        | [] ->
            let uu____7259 = FStar_Syntax_Subst.open_univ_vars_comp uvs c  in
            (match uu____7259 with | (uvs1,c1) -> (uvs1, [], c1))
        | uu____7294 ->
            let t' = arrow binders c  in
            let uu____7306 = FStar_Syntax_Subst.open_univ_vars uvs t'  in
            (match uu____7306 with
             | (uvs1,t'1) ->
                 let uu____7327 =
                   let uu____7328 = FStar_Syntax_Subst.compress t'1  in
                   uu____7328.FStar_Syntax_Syntax.n  in
                 (match uu____7327 with
                  | FStar_Syntax_Syntax.Tm_arrow (binders1,c1) ->
                      (uvs1, binders1, c1)
                  | uu____7377 -> failwith "Impossible"))
  
let (is_tuple_constructor : FStar_Syntax_Syntax.typ -> Prims.bool) =
  fun t  ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Parser_Const.is_tuple_constructor_string
          ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str
    | uu____7398 -> false
  
let (is_dtuple_constructor : FStar_Syntax_Syntax.typ -> Prims.bool) =
  fun t  ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Parser_Const.is_dtuple_constructor_lid
          (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
    | uu____7405 -> false
  
let (is_lid_equality : FStar_Ident.lident -> Prims.bool) =
  fun x  -> FStar_Ident.lid_equals x FStar_Parser_Const.eq2_lid 
let (is_forall : FStar_Ident.lident -> Prims.bool) =
  fun lid  -> FStar_Ident.lid_equals lid FStar_Parser_Const.forall_lid 
let (is_exists : FStar_Ident.lident -> Prims.bool) =
  fun lid  -> FStar_Ident.lid_equals lid FStar_Parser_Const.exists_lid 
let (is_qlid : FStar_Ident.lident -> Prims.bool) =
  fun lid  -> (is_forall lid) || (is_exists lid) 
let (is_equality :
  FStar_Ident.lident FStar_Syntax_Syntax.withinfo_t -> Prims.bool) =
  fun x  -> is_lid_equality x.FStar_Syntax_Syntax.v 
let (lid_is_connective : FStar_Ident.lident -> Prims.bool) =
  let lst =
    [FStar_Parser_Const.and_lid;
    FStar_Parser_Const.or_lid;
    FStar_Parser_Const.not_lid;
    FStar_Parser_Const.iff_lid;
    FStar_Parser_Const.imp_lid]  in
  fun lid  -> FStar_Util.for_some (FStar_Ident.lid_equals lid) lst 
let (is_constructor :
  FStar_Syntax_Syntax.term -> FStar_Ident.lident -> Prims.bool) =
  fun t  ->
    fun lid  ->
      let uu____7453 =
        let uu____7454 = pre_typ t  in uu____7454.FStar_Syntax_Syntax.n  in
      match uu____7453 with
      | FStar_Syntax_Syntax.Tm_fvar tc ->
          FStar_Ident.lid_equals
            (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v lid
      | uu____7458 -> false
  
let rec (is_constructed_typ :
  FStar_Syntax_Syntax.term -> FStar_Ident.lident -> Prims.bool) =
  fun t  ->
    fun lid  ->
      let uu____7469 =
        let uu____7470 = pre_typ t  in uu____7470.FStar_Syntax_Syntax.n  in
      match uu____7469 with
      | FStar_Syntax_Syntax.Tm_fvar uu____7473 -> is_constructor t lid
      | FStar_Syntax_Syntax.Tm_app (t1,uu____7475) ->
          is_constructed_typ t1 lid
      | FStar_Syntax_Syntax.Tm_uinst (t1,uu____7501) ->
          is_constructed_typ t1 lid
      | uu____7506 -> false
  
let rec (get_tycon :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term FStar_Pervasives_Native.option)
  =
  fun t  ->
    let t1 = pre_typ t  in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_bvar uu____7517 ->
        FStar_Pervasives_Native.Some t1
    | FStar_Syntax_Syntax.Tm_name uu____7518 ->
        FStar_Pervasives_Native.Some t1
    | FStar_Syntax_Syntax.Tm_fvar uu____7519 ->
        FStar_Pervasives_Native.Some t1
    | FStar_Syntax_Syntax.Tm_app (t2,uu____7521) -> get_tycon t2
    | uu____7546 -> FStar_Pervasives_Native.None
  
let (is_fstar_tactics_by_tactic : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  ->
    let uu____7552 =
      let uu____7553 = un_uinst t  in uu____7553.FStar_Syntax_Syntax.n  in
    match uu____7552 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.by_tactic_lid
    | uu____7557 -> false
  
let (is_builtin_tactic : FStar_Ident.lident -> Prims.bool) =
  fun md  ->
    let path = FStar_Ident.path_of_lid md  in
    if (FStar_List.length path) > (Prims.parse_int "2")
    then
      let uu____7564 =
        let uu____7567 = FStar_List.splitAt (Prims.parse_int "2") path  in
        FStar_Pervasives_Native.fst uu____7567  in
      match uu____7564 with
      | "FStar"::"Tactics"::[] -> true
      | "FStar"::"Reflection"::[] -> true
      | uu____7580 -> false
    else false
  
let (ktype : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_type FStar_Syntax_Syntax.U_unknown)
    FStar_Pervasives_Native.None FStar_Range.dummyRange
  
let (ktype0 : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_type FStar_Syntax_Syntax.U_zero)
    FStar_Pervasives_Native.None FStar_Range.dummyRange
  
let (type_u :
  unit ->
    (FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.universe)
      FStar_Pervasives_Native.tuple2)
  =
  fun uu____7592  ->
    let u =
      let uu____7598 = FStar_Syntax_Unionfind.univ_fresh ()  in
      FStar_All.pipe_left (fun _0_5  -> FStar_Syntax_Syntax.U_unif _0_5)
        uu____7598
       in
    let uu____7615 =
      FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_type u)
        FStar_Pervasives_Native.None FStar_Range.dummyRange
       in
    (uu____7615, u)
  
let (attr_eq :
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> Prims.bool) =
  fun a  ->
    fun a'  ->
      let uu____7626 = eq_tm a a'  in
      match uu____7626 with | Equal  -> true | uu____7627 -> false
  
let (attr_substitute : FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  let uu____7630 =
    let uu____7637 =
      let uu____7638 =
        let uu____7639 =
          FStar_Ident.lid_of_path ["FStar"; "Pervasives"; "Substitute"]
            FStar_Range.dummyRange
           in
        FStar_Syntax_Syntax.lid_as_fv uu____7639
          FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None
         in
      FStar_Syntax_Syntax.Tm_fvar uu____7638  in
    FStar_Syntax_Syntax.mk uu____7637  in
  uu____7630 FStar_Pervasives_Native.None FStar_Range.dummyRange 
let (exp_true_bool : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_bool true))
    FStar_Pervasives_Native.None FStar_Range.dummyRange
  
let (exp_false_bool : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_bool false))
    FStar_Pervasives_Native.None FStar_Range.dummyRange
  
let (exp_unit : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_constant FStar_Const.Const_unit)
    FStar_Pervasives_Native.None FStar_Range.dummyRange
  
let (exp_int : Prims.string -> FStar_Syntax_Syntax.term) =
  fun s  ->
    FStar_Syntax_Syntax.mk
      (FStar_Syntax_Syntax.Tm_constant
         (FStar_Const.Const_int (s, FStar_Pervasives_Native.None)))
      FStar_Pervasives_Native.None FStar_Range.dummyRange
  
let (exp_char : FStar_BaseTypes.char -> FStar_Syntax_Syntax.term) =
  fun c  ->
    FStar_Syntax_Syntax.mk
      (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_char c))
      FStar_Pervasives_Native.None FStar_Range.dummyRange
  
let (exp_string : Prims.string -> FStar_Syntax_Syntax.term) =
  fun s  ->
    FStar_Syntax_Syntax.mk
      (FStar_Syntax_Syntax.Tm_constant
         (FStar_Const.Const_string (s, FStar_Range.dummyRange)))
      FStar_Pervasives_Native.None FStar_Range.dummyRange
  
let (fvar_const : FStar_Ident.lident -> FStar_Syntax_Syntax.term) =
  fun l  ->
    FStar_Syntax_Syntax.fvar l FStar_Syntax_Syntax.delta_constant
      FStar_Pervasives_Native.None
  
let (tand : FStar_Syntax_Syntax.term) = fvar_const FStar_Parser_Const.and_lid 
let (tor : FStar_Syntax_Syntax.term) = fvar_const FStar_Parser_Const.or_lid 
let (timp : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.imp_lid
    (FStar_Syntax_Syntax.Delta_constant_at_level (Prims.parse_int "1"))
    FStar_Pervasives_Native.None
  
let (tiff : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.iff_lid
    (FStar_Syntax_Syntax.Delta_constant_at_level (Prims.parse_int "2"))
    FStar_Pervasives_Native.None
  
let (t_bool : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.bool_lid 
let (b2t_v : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.b2t_lid 
let (t_not : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.not_lid 
let (t_false : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.false_lid 
let (t_true : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.true_lid 
let (tac_opaque_attr : FStar_Syntax_Syntax.term) = exp_string "tac_opaque" 
let (dm4f_bind_range_attr : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.dm4f_bind_range_attr 
let (tcdecltime_attr : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.tcdecltime_attr 
let (t_ctx_uvar_and_sust : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.ctx_uvar_and_subst_lid 
let (mk_conj_opt :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
    FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
        FStar_Pervasives_Native.option)
  =
  fun phi1  ->
    fun phi2  ->
      match phi1 with
      | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.Some phi2
      | FStar_Pervasives_Native.Some phi11 ->
          let uu____7714 =
            let uu____7717 =
              FStar_Range.union_ranges phi11.FStar_Syntax_Syntax.pos
                phi2.FStar_Syntax_Syntax.pos
               in
            let uu____7718 =
              let uu____7725 =
                let uu____7726 =
                  let uu____7743 =
                    let uu____7754 = FStar_Syntax_Syntax.as_arg phi11  in
                    let uu____7763 =
                      let uu____7774 = FStar_Syntax_Syntax.as_arg phi2  in
                      [uu____7774]  in
                    uu____7754 :: uu____7763  in
                  (tand, uu____7743)  in
                FStar_Syntax_Syntax.Tm_app uu____7726  in
              FStar_Syntax_Syntax.mk uu____7725  in
            uu____7718 FStar_Pervasives_Native.None uu____7717  in
          FStar_Pervasives_Native.Some uu____7714
  
let (mk_binop :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun op_t  ->
    fun phi1  ->
      fun phi2  ->
        let uu____7853 =
          FStar_Range.union_ranges phi1.FStar_Syntax_Syntax.pos
            phi2.FStar_Syntax_Syntax.pos
           in
        let uu____7854 =
          let uu____7861 =
            let uu____7862 =
              let uu____7879 =
                let uu____7890 = FStar_Syntax_Syntax.as_arg phi1  in
                let uu____7899 =
                  let uu____7910 = FStar_Syntax_Syntax.as_arg phi2  in
                  [uu____7910]  in
                uu____7890 :: uu____7899  in
              (op_t, uu____7879)  in
            FStar_Syntax_Syntax.Tm_app uu____7862  in
          FStar_Syntax_Syntax.mk uu____7861  in
        uu____7854 FStar_Pervasives_Native.None uu____7853
  
let (mk_neg :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun phi  ->
    let uu____7969 =
      let uu____7976 =
        let uu____7977 =
          let uu____7994 =
            let uu____8005 = FStar_Syntax_Syntax.as_arg phi  in [uu____8005]
             in
          (t_not, uu____7994)  in
        FStar_Syntax_Syntax.Tm_app uu____7977  in
      FStar_Syntax_Syntax.mk uu____7976  in
    uu____7969 FStar_Pervasives_Native.None phi.FStar_Syntax_Syntax.pos
  
let (mk_conj :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  = fun phi1  -> fun phi2  -> mk_binop tand phi1 phi2 
let (mk_conj_l :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax Prims.list ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun phi  ->
    match phi with
    | [] ->
        FStar_Syntax_Syntax.fvar FStar_Parser_Const.true_lid
          FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None
    | hd1::tl1 -> FStar_List.fold_right mk_conj tl1 hd1
  
let (mk_disj :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  = fun phi1  -> fun phi2  -> mk_binop tor phi1 phi2 
let (mk_disj_l :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax Prims.list ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun phi  ->
    match phi with
    | [] -> t_false
    | hd1::tl1 -> FStar_List.fold_right mk_disj tl1 hd1
  
let (mk_imp :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term)
  = fun phi1  -> fun phi2  -> mk_binop timp phi1 phi2 
let (mk_iff :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term)
  = fun phi1  -> fun phi2  -> mk_binop tiff phi1 phi2 
let (b2t :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun e  ->
    let uu____8198 =
      let uu____8205 =
        let uu____8206 =
          let uu____8223 =
            let uu____8234 = FStar_Syntax_Syntax.as_arg e  in [uu____8234]
             in
          (b2t_v, uu____8223)  in
        FStar_Syntax_Syntax.Tm_app uu____8206  in
      FStar_Syntax_Syntax.mk uu____8205  in
    uu____8198 FStar_Pervasives_Native.None e.FStar_Syntax_Syntax.pos
  
let (is_t_true : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  ->
    let uu____8279 =
      let uu____8280 = unmeta t  in uu____8280.FStar_Syntax_Syntax.n  in
    match uu____8279 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.true_lid
    | uu____8284 -> false
  
let (mk_conj_simp :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t1  ->
    fun t2  ->
      let uu____8305 = is_t_true t1  in
      if uu____8305
      then t2
      else
        (let uu____8309 = is_t_true t2  in
         if uu____8309 then t1 else mk_conj t1 t2)
  
let (mk_disj_simp :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t1  ->
    fun t2  ->
      let uu____8333 = is_t_true t1  in
      if uu____8333
      then t_true
      else
        (let uu____8337 = is_t_true t2  in
         if uu____8337 then t_true else mk_disj t1 t2)
  
let (teq : FStar_Syntax_Syntax.term) = fvar_const FStar_Parser_Const.eq2_lid 
let (mk_untyped_eq2 :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun e1  ->
    fun e2  ->
      let uu____8361 =
        FStar_Range.union_ranges e1.FStar_Syntax_Syntax.pos
          e2.FStar_Syntax_Syntax.pos
         in
      let uu____8362 =
        let uu____8369 =
          let uu____8370 =
            let uu____8387 =
              let uu____8398 = FStar_Syntax_Syntax.as_arg e1  in
              let uu____8407 =
                let uu____8418 = FStar_Syntax_Syntax.as_arg e2  in
                [uu____8418]  in
              uu____8398 :: uu____8407  in
            (teq, uu____8387)  in
          FStar_Syntax_Syntax.Tm_app uu____8370  in
        FStar_Syntax_Syntax.mk uu____8369  in
      uu____8362 FStar_Pervasives_Native.None uu____8361
  
let (mk_eq2 :
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun u  ->
    fun t  ->
      fun e1  ->
        fun e2  ->
          let eq_inst = FStar_Syntax_Syntax.mk_Tm_uinst teq [u]  in
          let uu____8487 =
            FStar_Range.union_ranges e1.FStar_Syntax_Syntax.pos
              e2.FStar_Syntax_Syntax.pos
             in
          let uu____8488 =
            let uu____8495 =
              let uu____8496 =
                let uu____8513 =
                  let uu____8524 = FStar_Syntax_Syntax.iarg t  in
                  let uu____8533 =
                    let uu____8544 = FStar_Syntax_Syntax.as_arg e1  in
                    let uu____8553 =
                      let uu____8564 = FStar_Syntax_Syntax.as_arg e2  in
                      [uu____8564]  in
                    uu____8544 :: uu____8553  in
                  uu____8524 :: uu____8533  in
                (eq_inst, uu____8513)  in
              FStar_Syntax_Syntax.Tm_app uu____8496  in
            FStar_Syntax_Syntax.mk uu____8495  in
          uu____8488 FStar_Pervasives_Native.None uu____8487
  
let (mk_has_type :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t  ->
    fun x  ->
      fun t'  ->
        let t_has_type = fvar_const FStar_Parser_Const.has_type_lid  in
        let t_has_type1 =
          FStar_Syntax_Syntax.mk
            (FStar_Syntax_Syntax.Tm_uinst
               (t_has_type,
                 [FStar_Syntax_Syntax.U_zero; FStar_Syntax_Syntax.U_zero]))
            FStar_Pervasives_Native.None FStar_Range.dummyRange
           in
        let uu____8643 =
          let uu____8650 =
            let uu____8651 =
              let uu____8668 =
                let uu____8679 = FStar_Syntax_Syntax.iarg t  in
                let uu____8688 =
                  let uu____8699 = FStar_Syntax_Syntax.as_arg x  in
                  let uu____8708 =
                    let uu____8719 = FStar_Syntax_Syntax.as_arg t'  in
                    [uu____8719]  in
                  uu____8699 :: uu____8708  in
                uu____8679 :: uu____8688  in
              (t_has_type1, uu____8668)  in
            FStar_Syntax_Syntax.Tm_app uu____8651  in
          FStar_Syntax_Syntax.mk uu____8650  in
        uu____8643 FStar_Pervasives_Native.None FStar_Range.dummyRange
  
let (mk_with_type :
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun u  ->
    fun t  ->
      fun e  ->
        let t_with_type =
          FStar_Syntax_Syntax.fvar FStar_Parser_Const.with_type_lid
            FStar_Syntax_Syntax.delta_equational FStar_Pervasives_Native.None
           in
        let t_with_type1 =
          FStar_Syntax_Syntax.mk
            (FStar_Syntax_Syntax.Tm_uinst (t_with_type, [u]))
            FStar_Pervasives_Native.None FStar_Range.dummyRange
           in
        let uu____8798 =
          let uu____8805 =
            let uu____8806 =
              let uu____8823 =
                let uu____8834 = FStar_Syntax_Syntax.iarg t  in
                let uu____8843 =
                  let uu____8854 = FStar_Syntax_Syntax.as_arg e  in
                  [uu____8854]  in
                uu____8834 :: uu____8843  in
              (t_with_type1, uu____8823)  in
            FStar_Syntax_Syntax.Tm_app uu____8806  in
          FStar_Syntax_Syntax.mk uu____8805  in
        uu____8798 FStar_Pervasives_Native.None FStar_Range.dummyRange
  
let (lex_t : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.lex_t_lid 
let (lex_top : FStar_Syntax_Syntax.term) =
  let uu____8902 =
    let uu____8909 =
      let uu____8910 =
        let uu____8917 =
          FStar_Syntax_Syntax.fvar FStar_Parser_Const.lextop_lid
            FStar_Syntax_Syntax.delta_constant
            (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor)
           in
        (uu____8917, [FStar_Syntax_Syntax.U_zero])  in
      FStar_Syntax_Syntax.Tm_uinst uu____8910  in
    FStar_Syntax_Syntax.mk uu____8909  in
  uu____8902 FStar_Pervasives_Native.None FStar_Range.dummyRange 
let (lex_pair : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.lexcons_lid
    FStar_Syntax_Syntax.delta_constant
    (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor)
  
let (tforall : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.forall_lid
    (FStar_Syntax_Syntax.Delta_constant_at_level (Prims.parse_int "1"))
    FStar_Pervasives_Native.None
  
let (t_haseq : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.haseq_lid
    FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None
  
let (lcomp_of_comp : FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.lcomp) =
  fun c0  ->
    let uu____8930 =
      match c0.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Total uu____8943 ->
          (FStar_Parser_Const.effect_Tot_lid, [FStar_Syntax_Syntax.TOTAL])
      | FStar_Syntax_Syntax.GTotal uu____8954 ->
          (FStar_Parser_Const.effect_GTot_lid,
            [FStar_Syntax_Syntax.SOMETRIVIAL])
      | FStar_Syntax_Syntax.Comp c ->
          ((c.FStar_Syntax_Syntax.effect_name),
            (c.FStar_Syntax_Syntax.flags))
       in
    match uu____8930 with
    | (eff_name,flags1) ->
        FStar_Syntax_Syntax.mk_lcomp eff_name (comp_result c0) flags1
          (fun uu____8975  -> c0)
  
let (mk_residual_comp :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
      FStar_Pervasives_Native.option ->
      FStar_Syntax_Syntax.cflags Prims.list ->
        FStar_Syntax_Syntax.residual_comp)
  =
  fun l  ->
    fun t  ->
      fun f  ->
        {
          FStar_Syntax_Syntax.residual_effect = l;
          FStar_Syntax_Syntax.residual_typ = t;
          FStar_Syntax_Syntax.residual_flags = f
        }
  
let (residual_tot :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.residual_comp)
  =
  fun t  ->
    {
      FStar_Syntax_Syntax.residual_effect = FStar_Parser_Const.effect_Tot_lid;
      FStar_Syntax_Syntax.residual_typ = (FStar_Pervasives_Native.Some t);
      FStar_Syntax_Syntax.residual_flags = [FStar_Syntax_Syntax.TOTAL]
    }
  
let (residual_comp_of_comp :
  FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.residual_comp) =
  fun c  ->
    {
      FStar_Syntax_Syntax.residual_effect = (comp_effect_name c);
      FStar_Syntax_Syntax.residual_typ =
        (FStar_Pervasives_Native.Some (comp_result c));
      FStar_Syntax_Syntax.residual_flags = (comp_flags c)
    }
  
let (residual_comp_of_lcomp :
  FStar_Syntax_Syntax.lcomp -> FStar_Syntax_Syntax.residual_comp) =
  fun lc  ->
    {
      FStar_Syntax_Syntax.residual_effect = (lc.FStar_Syntax_Syntax.eff_name);
      FStar_Syntax_Syntax.residual_typ =
        (FStar_Pervasives_Native.Some (lc.FStar_Syntax_Syntax.res_typ));
      FStar_Syntax_Syntax.residual_flags = (lc.FStar_Syntax_Syntax.cflags)
    }
  
let (mk_forall_aux :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.bv ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun fa  ->
    fun x  ->
      fun body  ->
        let uu____9053 =
          let uu____9060 =
            let uu____9061 =
              let uu____9078 =
                let uu____9089 =
                  FStar_Syntax_Syntax.iarg x.FStar_Syntax_Syntax.sort  in
                let uu____9098 =
                  let uu____9109 =
                    let uu____9118 =
                      let uu____9119 =
                        let uu____9120 = FStar_Syntax_Syntax.mk_binder x  in
                        [uu____9120]  in
                      abs uu____9119 body
                        (FStar_Pervasives_Native.Some (residual_tot ktype0))
                       in
                    FStar_Syntax_Syntax.as_arg uu____9118  in
                  [uu____9109]  in
                uu____9089 :: uu____9098  in
              (fa, uu____9078)  in
            FStar_Syntax_Syntax.Tm_app uu____9061  in
          FStar_Syntax_Syntax.mk uu____9060  in
        uu____9053 FStar_Pervasives_Native.None FStar_Range.dummyRange
  
let (mk_forall_no_univ :
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ)
  = fun x  -> fun body  -> mk_forall_aux tforall x body 
let (mk_forall :
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.bv ->
      FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ)
  =
  fun u  ->
    fun x  ->
      fun body  ->
        let tforall1 = FStar_Syntax_Syntax.mk_Tm_uinst tforall [u]  in
        mk_forall_aux tforall1 x body
  
let (close_forall_no_univs :
  (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                            FStar_Pervasives_Native.option)
    FStar_Pervasives_Native.tuple2 Prims.list ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ)
  =
  fun bs  ->
    fun f  ->
      FStar_List.fold_right
        (fun b  ->
           fun f1  ->
             let uu____9247 = FStar_Syntax_Syntax.is_null_binder b  in
             if uu____9247
             then f1
             else mk_forall_no_univ (FStar_Pervasives_Native.fst b) f1) bs f
  
let rec (is_wild_pat :
  FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t -> Prims.bool) =
  fun p  ->
    match p.FStar_Syntax_Syntax.v with
    | FStar_Syntax_Syntax.Pat_wild uu____9260 -> true
    | uu____9261 -> false
  
let (if_then_else :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun b  ->
    fun t1  ->
      fun t2  ->
        let then_branch =
          let uu____9306 =
            FStar_Syntax_Syntax.withinfo
              (FStar_Syntax_Syntax.Pat_constant (FStar_Const.Const_bool true))
              t1.FStar_Syntax_Syntax.pos
             in
          (uu____9306, FStar_Pervasives_Native.None, t1)  in
        let else_branch =
          let uu____9334 =
            FStar_Syntax_Syntax.withinfo
              (FStar_Syntax_Syntax.Pat_constant
                 (FStar_Const.Const_bool false)) t2.FStar_Syntax_Syntax.pos
             in
          (uu____9334, FStar_Pervasives_Native.None, t2)  in
        let uu____9347 =
          let uu____9348 =
            FStar_Range.union_ranges t1.FStar_Syntax_Syntax.pos
              t2.FStar_Syntax_Syntax.pos
             in
          FStar_Range.union_ranges b.FStar_Syntax_Syntax.pos uu____9348  in
        FStar_Syntax_Syntax.mk
          (FStar_Syntax_Syntax.Tm_match (b, [then_branch; else_branch]))
          FStar_Pervasives_Native.None uu____9347
  
let (mk_squash :
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun u  ->
    fun p  ->
      let sq =
        FStar_Syntax_Syntax.fvar FStar_Parser_Const.squash_lid
          (FStar_Syntax_Syntax.Delta_constant_at_level (Prims.parse_int "1"))
          FStar_Pervasives_Native.None
         in
      let uu____9422 = FStar_Syntax_Syntax.mk_Tm_uinst sq [u]  in
      let uu____9425 =
        let uu____9436 = FStar_Syntax_Syntax.as_arg p  in [uu____9436]  in
      mk_app uu____9422 uu____9425
  
let (mk_auto_squash :
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun u  ->
    fun p  ->
      let sq =
        FStar_Syntax_Syntax.fvar FStar_Parser_Const.auto_squash_lid
          (FStar_Syntax_Syntax.Delta_constant_at_level (Prims.parse_int "2"))
          FStar_Pervasives_Native.None
         in
      let uu____9474 = FStar_Syntax_Syntax.mk_Tm_uinst sq [u]  in
      let uu____9477 =
        let uu____9488 = FStar_Syntax_Syntax.as_arg p  in [uu____9488]  in
      mk_app uu____9474 uu____9477
  
let (un_squash :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
      FStar_Pervasives_Native.option)
  =
  fun t  ->
    let uu____9522 = head_and_args t  in
    match uu____9522 with
    | (head1,args) ->
        let uu____9569 =
          let uu____9584 =
            let uu____9585 = un_uinst head1  in
            uu____9585.FStar_Syntax_Syntax.n  in
          (uu____9584, args)  in
        (match uu____9569 with
         | (FStar_Syntax_Syntax.Tm_fvar fv,(p,uu____9604)::[]) when
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.squash_lid
             -> FStar_Pervasives_Native.Some p
         | (FStar_Syntax_Syntax.Tm_refine (b,p),[]) ->
             (match (b.FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.n with
              | FStar_Syntax_Syntax.Tm_fvar fv when
                  FStar_Syntax_Syntax.fv_eq_lid fv
                    FStar_Parser_Const.unit_lid
                  ->
                  let uu____9670 =
                    let uu____9675 =
                      let uu____9676 = FStar_Syntax_Syntax.mk_binder b  in
                      [uu____9676]  in
                    FStar_Syntax_Subst.open_term uu____9675 p  in
                  (match uu____9670 with
                   | (bs,p1) ->
                       let b1 =
                         match bs with
                         | b1::[] -> b1
                         | uu____9733 -> failwith "impossible"  in
                       let uu____9740 =
                         let uu____9741 = FStar_Syntax_Free.names p1  in
                         FStar_Util.set_mem (FStar_Pervasives_Native.fst b1)
                           uu____9741
                          in
                       if uu____9740
                       then FStar_Pervasives_Native.None
                       else FStar_Pervasives_Native.Some p1)
              | uu____9755 -> FStar_Pervasives_Native.None)
         | uu____9758 -> FStar_Pervasives_Native.None)
  
let (is_squash :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.universe,FStar_Syntax_Syntax.term'
                                    FStar_Syntax_Syntax.syntax)
      FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option)
  =
  fun t  ->
    let uu____9788 = head_and_args t  in
    match uu____9788 with
    | (head1,args) ->
        let uu____9839 =
          let uu____9854 =
            let uu____9855 = FStar_Syntax_Subst.compress head1  in
            uu____9855.FStar_Syntax_Syntax.n  in
          (uu____9854, args)  in
        (match uu____9839 with
         | (FStar_Syntax_Syntax.Tm_uinst
            ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv;
               FStar_Syntax_Syntax.pos = uu____9877;
               FStar_Syntax_Syntax.vars = uu____9878;_},u::[]),(t1,uu____9881)::[])
             when
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.squash_lid
             -> FStar_Pervasives_Native.Some (u, t1)
         | uu____9928 -> FStar_Pervasives_Native.None)
  
let (is_auto_squash :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.universe,FStar_Syntax_Syntax.term'
                                    FStar_Syntax_Syntax.syntax)
      FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option)
  =
  fun t  ->
    let uu____9962 = head_and_args t  in
    match uu____9962 with
    | (head1,args) ->
        let uu____10013 =
          let uu____10028 =
            let uu____10029 = FStar_Syntax_Subst.compress head1  in
            uu____10029.FStar_Syntax_Syntax.n  in
          (uu____10028, args)  in
        (match uu____10013 with
         | (FStar_Syntax_Syntax.Tm_uinst
            ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv;
               FStar_Syntax_Syntax.pos = uu____10051;
               FStar_Syntax_Syntax.vars = uu____10052;_},u::[]),(t1,uu____10055)::[])
             when
             FStar_Syntax_Syntax.fv_eq_lid fv
               FStar_Parser_Const.auto_squash_lid
             -> FStar_Pervasives_Native.Some (u, t1)
         | uu____10102 -> FStar_Pervasives_Native.None)
  
let (is_sub_singleton : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  ->
    let uu____10128 =
      let uu____10145 = unmeta t  in head_and_args uu____10145  in
    match uu____10128 with
    | (head1,uu____10147) ->
        let uu____10172 =
          let uu____10173 = un_uinst head1  in
          uu____10173.FStar_Syntax_Syntax.n  in
        (match uu____10172 with
         | FStar_Syntax_Syntax.Tm_fvar fv ->
             (((((((((((((((((FStar_Syntax_Syntax.fv_eq_lid fv
                                FStar_Parser_Const.squash_lid)
                               ||
                               (FStar_Syntax_Syntax.fv_eq_lid fv
                                  FStar_Parser_Const.auto_squash_lid))
                              ||
                              (FStar_Syntax_Syntax.fv_eq_lid fv
                                 FStar_Parser_Const.and_lid))
                             ||
                             (FStar_Syntax_Syntax.fv_eq_lid fv
                                FStar_Parser_Const.or_lid))
                            ||
                            (FStar_Syntax_Syntax.fv_eq_lid fv
                               FStar_Parser_Const.not_lid))
                           ||
                           (FStar_Syntax_Syntax.fv_eq_lid fv
                              FStar_Parser_Const.imp_lid))
                          ||
                          (FStar_Syntax_Syntax.fv_eq_lid fv
                             FStar_Parser_Const.iff_lid))
                         ||
                         (FStar_Syntax_Syntax.fv_eq_lid fv
                            FStar_Parser_Const.ite_lid))
                        ||
                        (FStar_Syntax_Syntax.fv_eq_lid fv
                           FStar_Parser_Const.exists_lid))
                       ||
                       (FStar_Syntax_Syntax.fv_eq_lid fv
                          FStar_Parser_Const.forall_lid))
                      ||
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.true_lid))
                     ||
                     (FStar_Syntax_Syntax.fv_eq_lid fv
                        FStar_Parser_Const.false_lid))
                    ||
                    (FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.eq2_lid))
                   ||
                   (FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Parser_Const.eq3_lid))
                  ||
                  (FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.b2t_lid))
                 ||
                 (FStar_Syntax_Syntax.fv_eq_lid fv
                    FStar_Parser_Const.haseq_lid))
                ||
                (FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.has_type_lid))
               ||
               (FStar_Syntax_Syntax.fv_eq_lid fv
                  FStar_Parser_Const.precedes_lid)
         | uu____10177 -> false)
  
let (arrow_one :
  FStar_Syntax_Syntax.typ ->
    (FStar_Syntax_Syntax.binder,FStar_Syntax_Syntax.comp)
      FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option)
  =
  fun t  ->
    let uu____10195 =
      let uu____10208 =
        let uu____10209 = FStar_Syntax_Subst.compress t  in
        uu____10209.FStar_Syntax_Syntax.n  in
      match uu____10208 with
      | FStar_Syntax_Syntax.Tm_arrow ([],c) ->
          failwith "fatal: empty binders on arrow?"
      | FStar_Syntax_Syntax.Tm_arrow (b::[],c) ->
          FStar_Pervasives_Native.Some (b, c)
      | FStar_Syntax_Syntax.Tm_arrow (b::bs,c) ->
          let uu____10338 =
            let uu____10349 =
              let uu____10350 = arrow bs c  in
              FStar_Syntax_Syntax.mk_Total uu____10350  in
            (b, uu____10349)  in
          FStar_Pervasives_Native.Some uu____10338
      | uu____10367 -> FStar_Pervasives_Native.None  in
    FStar_Util.bind_opt uu____10195
      (fun uu____10405  ->
         match uu____10405 with
         | (b,c) ->
             let uu____10442 = FStar_Syntax_Subst.open_comp [b] c  in
             (match uu____10442 with
              | (bs,c1) ->
                  let b1 =
                    match bs with
                    | b1::[] -> b1
                    | uu____10505 ->
                        failwith
                          "impossible: open_comp returned different amount of binders"
                     in
                  FStar_Pervasives_Native.Some (b1, c1)))
  
let (is_free_in :
  FStar_Syntax_Syntax.bv -> FStar_Syntax_Syntax.term -> Prims.bool) =
  fun bv  ->
    fun t  ->
      let uu____10538 = FStar_Syntax_Free.names t  in
      FStar_Util.set_mem bv uu____10538
  
type qpats = FStar_Syntax_Syntax.args Prims.list
type connective =
  | QAll of (FStar_Syntax_Syntax.binders,qpats,FStar_Syntax_Syntax.typ)
  FStar_Pervasives_Native.tuple3 
  | QEx of (FStar_Syntax_Syntax.binders,qpats,FStar_Syntax_Syntax.typ)
  FStar_Pervasives_Native.tuple3 
  | BaseConn of (FStar_Ident.lident,FStar_Syntax_Syntax.args)
  FStar_Pervasives_Native.tuple2 
let (uu___is_QAll : connective -> Prims.bool) =
  fun projectee  ->
    match projectee with | QAll _0 -> true | uu____10586 -> false
  
let (__proj__QAll__item___0 :
  connective ->
    (FStar_Syntax_Syntax.binders,qpats,FStar_Syntax_Syntax.typ)
      FStar_Pervasives_Native.tuple3)
  = fun projectee  -> match projectee with | QAll _0 -> _0 
let (uu___is_QEx : connective -> Prims.bool) =
  fun projectee  ->
    match projectee with | QEx _0 -> true | uu____10624 -> false
  
let (__proj__QEx__item___0 :
  connective ->
    (FStar_Syntax_Syntax.binders,qpats,FStar_Syntax_Syntax.typ)
      FStar_Pervasives_Native.tuple3)
  = fun projectee  -> match projectee with | QEx _0 -> _0 
let (uu___is_BaseConn : connective -> Prims.bool) =
  fun projectee  ->
    match projectee with | BaseConn _0 -> true | uu____10660 -> false
  
let (__proj__BaseConn__item___0 :
  connective ->
    (FStar_Ident.lident,FStar_Syntax_Syntax.args)
      FStar_Pervasives_Native.tuple2)
  = fun projectee  -> match projectee with | BaseConn _0 -> _0 
let (destruct_typ_as_formula :
  FStar_Syntax_Syntax.term -> connective FStar_Pervasives_Native.option) =
  fun f  ->
    let rec unmeta_monadic f1 =
      let f2 = FStar_Syntax_Subst.compress f1  in
      match f2.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_meta
          (t,FStar_Syntax_Syntax.Meta_monadic uu____10697) ->
          unmeta_monadic t
      | FStar_Syntax_Syntax.Tm_meta
          (t,FStar_Syntax_Syntax.Meta_monadic_lift uu____10709) ->
          unmeta_monadic t
      | uu____10722 -> f2  in
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
        (FStar_Parser_Const.eq3_lid, (Prims.parse_int "2"))]  in
      let aux f2 uu____10806 =
        match uu____10806 with
        | (lid,arity) ->
            let uu____10815 =
              let uu____10832 = unmeta_monadic f2  in
              head_and_args uu____10832  in
            (match uu____10815 with
             | (t,args) ->
                 let t1 = un_uinst t  in
                 let uu____10862 =
                   (is_constructor t1 lid) &&
                     ((FStar_List.length args) = arity)
                    in
                 if uu____10862
                 then FStar_Pervasives_Native.Some (BaseConn (lid, args))
                 else FStar_Pervasives_Native.None)
         in
      FStar_Util.find_map connectives (aux f1)  in
    let patterns t =
      let t1 = FStar_Syntax_Subst.compress t  in
      match t1.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_meta
          (t2,FStar_Syntax_Syntax.Meta_pattern pats) ->
          let uu____10939 = FStar_Syntax_Subst.compress t2  in
          (pats, uu____10939)
      | uu____10952 -> ([], t1)  in
    let destruct_q_conn t =
      let is_q fa fv =
        if fa
        then is_forall (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
        else is_exists (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
         in
      let flat t1 =
        let uu____11013 = head_and_args t1  in
        match uu____11013 with
        | (t2,args) ->
            let uu____11068 = un_uinst t2  in
            let uu____11069 =
              FStar_All.pipe_right args
                (FStar_List.map
                   (fun uu____11110  ->
                      match uu____11110 with
                      | (t3,imp) ->
                          let uu____11129 = unascribe t3  in
                          (uu____11129, imp)))
               in
            (uu____11068, uu____11069)
         in
      let rec aux qopt out t1 =
        let uu____11178 = let uu____11201 = flat t1  in (qopt, uu____11201)
           in
        match uu____11178 with
        | (FStar_Pervasives_Native.Some
           fa,({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar tc;
                 FStar_Syntax_Syntax.pos = uu____11240;
                 FStar_Syntax_Syntax.vars = uu____11241;_},({
                                                              FStar_Syntax_Syntax.n
                                                                =
                                                                FStar_Syntax_Syntax.Tm_abs
                                                                (b::[],t2,uu____11244);
                                                              FStar_Syntax_Syntax.pos
                                                                = uu____11245;
                                                              FStar_Syntax_Syntax.vars
                                                                = uu____11246;_},uu____11247)::[]))
            when is_q fa tc -> aux qopt (b :: out) t2
        | (FStar_Pervasives_Native.Some
           fa,({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar tc;
                 FStar_Syntax_Syntax.pos = uu____11346;
                 FStar_Syntax_Syntax.vars = uu____11347;_},uu____11348::
               ({
                  FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_abs
                    (b::[],t2,uu____11351);
                  FStar_Syntax_Syntax.pos = uu____11352;
                  FStar_Syntax_Syntax.vars = uu____11353;_},uu____11354)::[]))
            when is_q fa tc -> aux qopt (b :: out) t2
        | (FStar_Pervasives_Native.None
           ,({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar tc;
               FStar_Syntax_Syntax.pos = uu____11468;
               FStar_Syntax_Syntax.vars = uu____11469;_},({
                                                            FStar_Syntax_Syntax.n
                                                              =
                                                              FStar_Syntax_Syntax.Tm_abs
                                                              (b::[],t2,uu____11472);
                                                            FStar_Syntax_Syntax.pos
                                                              = uu____11473;
                                                            FStar_Syntax_Syntax.vars
                                                              = uu____11474;_},uu____11475)::[]))
            when
            is_qlid (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v ->
            let uu____11566 =
              let uu____11569 =
                is_forall
                  (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                 in
              FStar_Pervasives_Native.Some uu____11569  in
            aux uu____11566 (b :: out) t2
        | (FStar_Pervasives_Native.None
           ,({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar tc;
               FStar_Syntax_Syntax.pos = uu____11577;
               FStar_Syntax_Syntax.vars = uu____11578;_},uu____11579::
             ({
                FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_abs
                  (b::[],t2,uu____11582);
                FStar_Syntax_Syntax.pos = uu____11583;
                FStar_Syntax_Syntax.vars = uu____11584;_},uu____11585)::[]))
            when
            is_qlid (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v ->
            let uu____11692 =
              let uu____11695 =
                is_forall
                  (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                 in
              FStar_Pervasives_Native.Some uu____11695  in
            aux uu____11692 (b :: out) t2
        | (FStar_Pervasives_Native.Some b,uu____11703) ->
            let bs = FStar_List.rev out  in
            let uu____11753 = FStar_Syntax_Subst.open_term bs t1  in
            (match uu____11753 with
             | (bs1,t2) ->
                 let uu____11762 = patterns t2  in
                 (match uu____11762 with
                  | (pats,body) ->
                      if b
                      then
                        FStar_Pervasives_Native.Some (QAll (bs1, pats, body))
                      else
                        FStar_Pervasives_Native.Some (QEx (bs1, pats, body))))
        | uu____11810 -> FStar_Pervasives_Native.None  in
      aux FStar_Pervasives_Native.None [] t  in
    let u_connectives =
      [(FStar_Parser_Const.true_lid, FStar_Parser_Const.c_true_lid,
         (Prims.parse_int "0"));
      (FStar_Parser_Const.false_lid, FStar_Parser_Const.c_false_lid,
        (Prims.parse_int "0"));
      (FStar_Parser_Const.and_lid, FStar_Parser_Const.c_and_lid,
        (Prims.parse_int "2"));
      (FStar_Parser_Const.or_lid, FStar_Parser_Const.c_or_lid,
        (Prims.parse_int "2"))]
       in
    let destruct_sq_base_conn t =
      let uu____11886 = un_squash t  in
      FStar_Util.bind_opt uu____11886
        (fun t1  ->
           let uu____11902 = head_and_args' t1  in
           match uu____11902 with
           | (hd1,args) ->
               let uu____11941 =
                 let uu____11946 =
                   let uu____11947 = un_uinst hd1  in
                   uu____11947.FStar_Syntax_Syntax.n  in
                 (uu____11946, (FStar_List.length args))  in
               (match uu____11941 with
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_6) when
                    (_0_6 = (Prims.parse_int "2")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_and_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.and_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_7) when
                    (_0_7 = (Prims.parse_int "2")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_or_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.or_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_8) when
                    (_0_8 = (Prims.parse_int "2")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_eq2_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.eq2_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_9) when
                    (_0_9 = (Prims.parse_int "3")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_eq2_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.eq2_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_10) when
                    (_0_10 = (Prims.parse_int "2")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_eq3_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.eq3_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_11) when
                    (_0_11 = (Prims.parse_int "4")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_eq3_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.eq3_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_12) when
                    (_0_12 = (Prims.parse_int "0")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_true_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.true_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv,_0_13) when
                    (_0_13 = (Prims.parse_int "0")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_false_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.false_lid, args))
                | uu____11968 -> FStar_Pervasives_Native.None))
       in
    let rec destruct_sq_forall t =
      let uu____11997 = un_squash t  in
      FStar_Util.bind_opt uu____11997
        (fun t1  ->
           let uu____12012 = arrow_one t1  in
           match uu____12012 with
           | FStar_Pervasives_Native.Some (b,c) ->
               let uu____12027 =
                 let uu____12028 = is_tot_or_gtot_comp c  in
                 Prims.op_Negation uu____12028  in
               if uu____12027
               then FStar_Pervasives_Native.None
               else
                 (let q =
                    let uu____12035 = comp_to_comp_typ_nouniv c  in
                    uu____12035.FStar_Syntax_Syntax.result_typ  in
                  let uu____12036 =
                    is_free_in (FStar_Pervasives_Native.fst b) q  in
                  if uu____12036
                  then
                    let uu____12041 = patterns q  in
                    match uu____12041 with
                    | (pats,q1) ->
                        FStar_All.pipe_left maybe_collect
                          (FStar_Pervasives_Native.Some
                             (QAll ([b], pats, q1)))
                  else
                    (let uu____12103 =
                       let uu____12104 =
                         let uu____12109 =
                           let uu____12110 =
                             FStar_Syntax_Syntax.as_arg
                               (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                              in
                           let uu____12121 =
                             let uu____12132 = FStar_Syntax_Syntax.as_arg q
                                in
                             [uu____12132]  in
                           uu____12110 :: uu____12121  in
                         (FStar_Parser_Const.imp_lid, uu____12109)  in
                       BaseConn uu____12104  in
                     FStar_Pervasives_Native.Some uu____12103))
           | uu____12165 -> FStar_Pervasives_Native.None)
    
    and destruct_sq_exists t =
      let uu____12173 = un_squash t  in
      FStar_Util.bind_opt uu____12173
        (fun t1  ->
           let uu____12204 = head_and_args' t1  in
           match uu____12204 with
           | (hd1,args) ->
               let uu____12243 =
                 let uu____12258 =
                   let uu____12259 = un_uinst hd1  in
                   uu____12259.FStar_Syntax_Syntax.n  in
                 (uu____12258, args)  in
               (match uu____12243 with
                | (FStar_Syntax_Syntax.Tm_fvar
                   fv,(a1,uu____12276)::(a2,uu____12278)::[]) when
                    FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Parser_Const.dtuple2_lid
                    ->
                    let uu____12329 =
                      let uu____12330 = FStar_Syntax_Subst.compress a2  in
                      uu____12330.FStar_Syntax_Syntax.n  in
                    (match uu____12329 with
                     | FStar_Syntax_Syntax.Tm_abs (b::[],q,uu____12337) ->
                         let uu____12372 = FStar_Syntax_Subst.open_term [b] q
                            in
                         (match uu____12372 with
                          | (bs,q1) ->
                              let b1 =
                                match bs with
                                | b1::[] -> b1
                                | uu____12425 -> failwith "impossible"  in
                              let uu____12432 = patterns q1  in
                              (match uu____12432 with
                               | (pats,q2) ->
                                   FStar_All.pipe_left maybe_collect
                                     (FStar_Pervasives_Native.Some
                                        (QEx ([b1], pats, q2)))))
                     | uu____12493 -> FStar_Pervasives_Native.None)
                | uu____12494 -> FStar_Pervasives_Native.None))
    
    and maybe_collect f1 =
      match f1 with
      | FStar_Pervasives_Native.Some (QAll (bs,pats,phi)) ->
          let uu____12517 = destruct_sq_forall phi  in
          (match uu____12517 with
           | FStar_Pervasives_Native.Some (QAll (bs',pats',psi)) ->
               FStar_All.pipe_left
                 (fun _0_14  -> FStar_Pervasives_Native.Some _0_14)
                 (QAll
                    ((FStar_List.append bs bs'),
                      (FStar_List.append pats pats'), psi))
           | uu____12533 -> f1)
      | FStar_Pervasives_Native.Some (QEx (bs,pats,phi)) ->
          let uu____12539 = destruct_sq_exists phi  in
          (match uu____12539 with
           | FStar_Pervasives_Native.Some (QEx (bs',pats',psi)) ->
               FStar_All.pipe_left
                 (fun _0_15  -> FStar_Pervasives_Native.Some _0_15)
                 (QEx
                    ((FStar_List.append bs bs'),
                      (FStar_List.append pats pats'), psi))
           | uu____12555 -> f1)
      | uu____12558 -> f1
     in
    let phi = unmeta_monadic f  in
    let uu____12562 = destruct_base_conn phi  in
    FStar_Util.catch_opt uu____12562
      (fun uu____12567  ->
         let uu____12568 = destruct_q_conn phi  in
         FStar_Util.catch_opt uu____12568
           (fun uu____12573  ->
              let uu____12574 = destruct_sq_base_conn phi  in
              FStar_Util.catch_opt uu____12574
                (fun uu____12579  ->
                   let uu____12580 = destruct_sq_forall phi  in
                   FStar_Util.catch_opt uu____12580
                     (fun uu____12585  ->
                        let uu____12586 = destruct_sq_exists phi  in
                        FStar_Util.catch_opt uu____12586
                          (fun uu____12590  -> FStar_Pervasives_Native.None)))))
  
let (unthunk_lemma_post :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t  ->
    let uu____12602 =
      let uu____12603 = FStar_Syntax_Subst.compress t  in
      uu____12603.FStar_Syntax_Syntax.n  in
    match uu____12602 with
    | FStar_Syntax_Syntax.Tm_abs (b::[],e,uu____12610) ->
        let uu____12645 = FStar_Syntax_Subst.open_term [b] e  in
        (match uu____12645 with
         | (bs,e1) ->
             let b1 = FStar_List.hd bs  in
             let uu____12679 = is_free_in (FStar_Pervasives_Native.fst b1) e1
                in
             if uu____12679
             then
               let uu____12684 =
                 let uu____12695 = FStar_Syntax_Syntax.as_arg exp_unit  in
                 [uu____12695]  in
               mk_app t uu____12684
             else e1)
    | uu____12721 ->
        let uu____12722 =
          let uu____12733 = FStar_Syntax_Syntax.as_arg exp_unit  in
          [uu____12733]  in
        mk_app t uu____12722
  
let (action_as_lb :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.action ->
      FStar_Range.range -> FStar_Syntax_Syntax.sigelt)
  =
  fun eff_lid  ->
    fun a  ->
      fun pos  ->
        let lb =
          let uu____12774 =
            let uu____12779 =
              FStar_Syntax_Syntax.lid_as_fv a.FStar_Syntax_Syntax.action_name
                FStar_Syntax_Syntax.delta_equational
                FStar_Pervasives_Native.None
               in
            FStar_Util.Inr uu____12779  in
          let uu____12780 =
            let uu____12781 =
              FStar_Syntax_Syntax.mk_Total a.FStar_Syntax_Syntax.action_typ
               in
            arrow a.FStar_Syntax_Syntax.action_params uu____12781  in
          let uu____12784 =
            abs a.FStar_Syntax_Syntax.action_params
              a.FStar_Syntax_Syntax.action_defn FStar_Pervasives_Native.None
             in
          close_univs_and_mk_letbinding FStar_Pervasives_Native.None
            uu____12774 a.FStar_Syntax_Syntax.action_univs uu____12780
            FStar_Parser_Const.effect_Tot_lid uu____12784 [] pos
           in
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
  
let (mk_reify :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t  ->
    let reify_1 =
      FStar_Syntax_Syntax.mk
        (FStar_Syntax_Syntax.Tm_constant FStar_Const.Const_reify)
        FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
       in
    let uu____12807 =
      let uu____12814 =
        let uu____12815 =
          let uu____12832 =
            let uu____12843 = FStar_Syntax_Syntax.as_arg t  in [uu____12843]
             in
          (reify_1, uu____12832)  in
        FStar_Syntax_Syntax.Tm_app uu____12815  in
      FStar_Syntax_Syntax.mk uu____12814  in
    uu____12807 FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
  
let (mk_reflect :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t  ->
    let reflect_ =
      let uu____12897 =
        let uu____12904 =
          let uu____12905 =
            let uu____12906 = FStar_Ident.lid_of_str "Bogus.Effect"  in
            FStar_Const.Const_reflect uu____12906  in
          FStar_Syntax_Syntax.Tm_constant uu____12905  in
        FStar_Syntax_Syntax.mk uu____12904  in
      uu____12897 FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos  in
    let uu____12910 =
      let uu____12917 =
        let uu____12918 =
          let uu____12935 =
            let uu____12946 = FStar_Syntax_Syntax.as_arg t  in [uu____12946]
             in
          (reflect_, uu____12935)  in
        FStar_Syntax_Syntax.Tm_app uu____12918  in
      FStar_Syntax_Syntax.mk uu____12917  in
    uu____12910 FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
  
let rec (delta_qualifier :
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.delta_depth) =
  fun t  ->
    let t1 = FStar_Syntax_Subst.compress t  in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_delayed uu____12992 -> failwith "Impossible"
    | FStar_Syntax_Syntax.Tm_lazy i ->
        let uu____13016 = unfold_lazy i  in delta_qualifier uu____13016
    | FStar_Syntax_Syntax.Tm_fvar fv -> fv.FStar_Syntax_Syntax.fv_delta
    | FStar_Syntax_Syntax.Tm_bvar uu____13018 ->
        FStar_Syntax_Syntax.delta_equational
    | FStar_Syntax_Syntax.Tm_name uu____13019 ->
        FStar_Syntax_Syntax.delta_equational
    | FStar_Syntax_Syntax.Tm_match uu____13020 ->
        FStar_Syntax_Syntax.delta_equational
    | FStar_Syntax_Syntax.Tm_uvar uu____13043 ->
        FStar_Syntax_Syntax.delta_equational
    | FStar_Syntax_Syntax.Tm_unknown  -> FStar_Syntax_Syntax.delta_equational
    | FStar_Syntax_Syntax.Tm_type uu____13056 ->
        FStar_Syntax_Syntax.delta_constant
    | FStar_Syntax_Syntax.Tm_quoted uu____13057 ->
        FStar_Syntax_Syntax.delta_constant
    | FStar_Syntax_Syntax.Tm_constant uu____13064 ->
        FStar_Syntax_Syntax.delta_constant
    | FStar_Syntax_Syntax.Tm_arrow uu____13065 ->
        FStar_Syntax_Syntax.delta_constant
    | FStar_Syntax_Syntax.Tm_uinst (t2,uu____13081) -> delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_refine
        ({ FStar_Syntax_Syntax.ppname = uu____13086;
           FStar_Syntax_Syntax.index = uu____13087;
           FStar_Syntax_Syntax.sort = t2;_},uu____13089)
        -> delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_meta (t2,uu____13097) -> delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_ascribed (t2,uu____13103,uu____13104) ->
        delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_app (t2,uu____13146) -> delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_abs (uu____13171,t2,uu____13173) ->
        delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_let (uu____13198,t2) -> delta_qualifier t2
  
let rec (incr_delta_depth :
  FStar_Syntax_Syntax.delta_depth -> FStar_Syntax_Syntax.delta_depth) =
  fun d  ->
    match d with
    | FStar_Syntax_Syntax.Delta_constant_at_level i ->
        FStar_Syntax_Syntax.Delta_constant_at_level
          (i + (Prims.parse_int "1"))
    | FStar_Syntax_Syntax.Delta_equational_at_level i ->
        FStar_Syntax_Syntax.Delta_equational_at_level
          (i + (Prims.parse_int "1"))
    | FStar_Syntax_Syntax.Delta_abstract d1 -> incr_delta_depth d1
  
let (incr_delta_qualifier :
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.delta_depth) =
  fun t  ->
    let uu____13229 = delta_qualifier t  in incr_delta_depth uu____13229
  
let (is_unknown : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  ->
    let uu____13235 =
      let uu____13236 = FStar_Syntax_Subst.compress t  in
      uu____13236.FStar_Syntax_Syntax.n  in
    match uu____13235 with
    | FStar_Syntax_Syntax.Tm_unknown  -> true
    | uu____13239 -> false
  
let rec (list_elements :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term Prims.list FStar_Pervasives_Native.option)
  =
  fun e  ->
    let uu____13253 =
      let uu____13270 = unmeta e  in head_and_args uu____13270  in
    match uu____13253 with
    | (head1,args) ->
        let uu____13301 =
          let uu____13316 =
            let uu____13317 = un_uinst head1  in
            uu____13317.FStar_Syntax_Syntax.n  in
          (uu____13316, args)  in
        (match uu____13301 with
         | (FStar_Syntax_Syntax.Tm_fvar fv,uu____13335) when
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.nil_lid ->
             FStar_Pervasives_Native.Some []
         | (FStar_Syntax_Syntax.Tm_fvar
            fv,uu____13359::(hd1,uu____13361)::(tl1,uu____13363)::[]) when
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.cons_lid ->
             let uu____13430 =
               let uu____13433 =
                 let uu____13436 = list_elements tl1  in
                 FStar_Util.must uu____13436  in
               hd1 :: uu____13433  in
             FStar_Pervasives_Native.Some uu____13430
         | uu____13445 -> FStar_Pervasives_Native.None)
  
let rec apply_last :
  'Auu____13468 .
    ('Auu____13468 -> 'Auu____13468) ->
      'Auu____13468 Prims.list -> 'Auu____13468 Prims.list
  =
  fun f  ->
    fun l  ->
      match l with
      | [] -> failwith "apply_last: got empty list"
      | a::[] -> let uu____13493 = f a  in [uu____13493]
      | x::xs -> let uu____13498 = apply_last f xs  in x :: uu____13498
  
let (dm4f_lid :
  FStar_Syntax_Syntax.eff_decl -> Prims.string -> FStar_Ident.lident) =
  fun ed  ->
    fun name  ->
      let p = FStar_Ident.path_of_lid ed.FStar_Syntax_Syntax.mname  in
      let p' =
        apply_last
          (fun s  ->
             Prims.strcat "_dm4f_" (Prims.strcat s (Prims.strcat "_" name)))
          p
         in
      FStar_Ident.lid_of_path p' FStar_Range.dummyRange
  
let rec (mk_list :
  FStar_Syntax_Syntax.term ->
    FStar_Range.range ->
      FStar_Syntax_Syntax.term Prims.list -> FStar_Syntax_Syntax.term)
  =
  fun typ  ->
    fun rng  ->
      fun l  ->
        let ctor l1 =
          let uu____13544 =
            let uu____13551 =
              let uu____13552 =
                FStar_Syntax_Syntax.lid_as_fv l1
                  FStar_Syntax_Syntax.delta_constant
                  (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor)
                 in
              FStar_Syntax_Syntax.Tm_fvar uu____13552  in
            FStar_Syntax_Syntax.mk uu____13551  in
          uu____13544 FStar_Pervasives_Native.None rng  in
        let cons1 args pos =
          let uu____13569 =
            let uu____13574 =
              let uu____13575 = ctor FStar_Parser_Const.cons_lid  in
              FStar_Syntax_Syntax.mk_Tm_uinst uu____13575
                [FStar_Syntax_Syntax.U_zero]
               in
            FStar_Syntax_Syntax.mk_Tm_app uu____13574 args  in
          uu____13569 FStar_Pervasives_Native.None pos  in
        let nil args pos =
          let uu____13591 =
            let uu____13596 =
              let uu____13597 = ctor FStar_Parser_Const.nil_lid  in
              FStar_Syntax_Syntax.mk_Tm_uinst uu____13597
                [FStar_Syntax_Syntax.U_zero]
               in
            FStar_Syntax_Syntax.mk_Tm_app uu____13596 args  in
          uu____13591 FStar_Pervasives_Native.None pos  in
        let uu____13600 =
          let uu____13601 =
            let uu____13602 = FStar_Syntax_Syntax.iarg typ  in [uu____13602]
             in
          nil uu____13601 rng  in
        FStar_List.fold_right
          (fun t  ->
             fun a  ->
               let uu____13636 =
                 let uu____13637 = FStar_Syntax_Syntax.iarg typ  in
                 let uu____13646 =
                   let uu____13657 = FStar_Syntax_Syntax.as_arg t  in
                   let uu____13666 =
                     let uu____13677 = FStar_Syntax_Syntax.as_arg a  in
                     [uu____13677]  in
                   uu____13657 :: uu____13666  in
                 uu____13637 :: uu____13646  in
               cons1 uu____13636 t.FStar_Syntax_Syntax.pos) l uu____13600
  
let rec eqlist :
  'a .
    ('a -> 'a -> Prims.bool) -> 'a Prims.list -> 'a Prims.list -> Prims.bool
  =
  fun eq1  ->
    fun xs  ->
      fun ys  ->
        match (xs, ys) with
        | ([],[]) -> true
        | (x::xs1,y::ys1) -> (eq1 x y) && (eqlist eq1 xs1 ys1)
        | uu____13781 -> false
  
let eqsum :
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
          | uu____13888 -> false
  
let eqprod :
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
  
let eqopt :
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
        | uu____14043 -> false
  
let (debug_term_eq : Prims.bool FStar_ST.ref) = FStar_Util.mk_ref false 
let (check : Prims.string -> Prims.bool -> Prims.bool) =
  fun msg  ->
    fun cond  ->
      if cond
      then true
      else
        ((let uu____14077 = FStar_ST.op_Bang debug_term_eq  in
          if uu____14077
          then FStar_Util.print1 ">>> term_eq failing: %s\n" msg
          else ());
         false)
  
let (fail : Prims.string -> Prims.bool) = fun msg  -> check msg false 
let rec (term_eq_dbg :
  Prims.bool ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> Prims.bool)
  =
  fun dbg  ->
    fun t1  ->
      fun t2  ->
        let t11 = let uu____14269 = unmeta_safe t1  in canon_app uu____14269
           in
        let t21 = let uu____14275 = unmeta_safe t2  in canon_app uu____14275
           in
        let uu____14278 =
          let uu____14283 =
            let uu____14284 =
              let uu____14287 = un_uinst t11  in
              FStar_Syntax_Subst.compress uu____14287  in
            uu____14284.FStar_Syntax_Syntax.n  in
          let uu____14288 =
            let uu____14289 =
              let uu____14292 = un_uinst t21  in
              FStar_Syntax_Subst.compress uu____14292  in
            uu____14289.FStar_Syntax_Syntax.n  in
          (uu____14283, uu____14288)  in
        match uu____14278 with
        | (FStar_Syntax_Syntax.Tm_uinst uu____14293,uu____14294) ->
            failwith "term_eq: impossible, should have been removed"
        | (uu____14301,FStar_Syntax_Syntax.Tm_uinst uu____14302) ->
            failwith "term_eq: impossible, should have been removed"
        | (FStar_Syntax_Syntax.Tm_delayed uu____14309,uu____14310) ->
            failwith "term_eq: impossible, should have been removed"
        | (uu____14333,FStar_Syntax_Syntax.Tm_delayed uu____14334) ->
            failwith "term_eq: impossible, should have been removed"
        | (FStar_Syntax_Syntax.Tm_ascribed uu____14357,uu____14358) ->
            failwith "term_eq: impossible, should have been removed"
        | (uu____14385,FStar_Syntax_Syntax.Tm_ascribed uu____14386) ->
            failwith "term_eq: impossible, should have been removed"
        | (FStar_Syntax_Syntax.Tm_bvar x,FStar_Syntax_Syntax.Tm_bvar y) ->
            check "bvar"
              (x.FStar_Syntax_Syntax.index = y.FStar_Syntax_Syntax.index)
        | (FStar_Syntax_Syntax.Tm_name x,FStar_Syntax_Syntax.Tm_name y) ->
            check "name"
              (x.FStar_Syntax_Syntax.index = y.FStar_Syntax_Syntax.index)
        | (FStar_Syntax_Syntax.Tm_fvar x,FStar_Syntax_Syntax.Tm_fvar y) ->
            let uu____14419 = FStar_Syntax_Syntax.fv_eq x y  in
            check "fvar" uu____14419
        | (FStar_Syntax_Syntax.Tm_constant c1,FStar_Syntax_Syntax.Tm_constant
           c2) ->
            let uu____14422 = FStar_Const.eq_const c1 c2  in
            check "const" uu____14422
        | (FStar_Syntax_Syntax.Tm_type
           uu____14423,FStar_Syntax_Syntax.Tm_type uu____14424) -> true
        | (FStar_Syntax_Syntax.Tm_abs (b1,t12,k1),FStar_Syntax_Syntax.Tm_abs
           (b2,t22,k2)) ->
            (let uu____14481 = eqlist (binder_eq_dbg dbg) b1 b2  in
             check "abs binders" uu____14481) &&
              (let uu____14489 = term_eq_dbg dbg t12 t22  in
               check "abs bodies" uu____14489)
        | (FStar_Syntax_Syntax.Tm_arrow (b1,c1),FStar_Syntax_Syntax.Tm_arrow
           (b2,c2)) ->
            (let uu____14536 = eqlist (binder_eq_dbg dbg) b1 b2  in
             check "arrow binders" uu____14536) &&
              (let uu____14544 = comp_eq_dbg dbg c1 c2  in
               check "arrow comp" uu____14544)
        | (FStar_Syntax_Syntax.Tm_refine
           (b1,t12),FStar_Syntax_Syntax.Tm_refine (b2,t22)) ->
            (check "refine bv"
               (b1.FStar_Syntax_Syntax.index = b2.FStar_Syntax_Syntax.index))
              &&
              (let uu____14558 = term_eq_dbg dbg t12 t22  in
               check "refine formula" uu____14558)
        | (FStar_Syntax_Syntax.Tm_app (f1,a1),FStar_Syntax_Syntax.Tm_app
           (f2,a2)) ->
            (let uu____14613 = term_eq_dbg dbg f1 f2  in
             check "app head" uu____14613) &&
              (let uu____14615 = eqlist (arg_eq_dbg dbg) a1 a2  in
               check "app args" uu____14615)
        | (FStar_Syntax_Syntax.Tm_match
           (t12,bs1),FStar_Syntax_Syntax.Tm_match (t22,bs2)) ->
            (let uu____14702 = term_eq_dbg dbg t12 t22  in
             check "match head" uu____14702) &&
              (let uu____14704 = eqlist (branch_eq_dbg dbg) bs1 bs2  in
               check "match branches" uu____14704)
        | (FStar_Syntax_Syntax.Tm_lazy uu____14719,uu____14720) ->
            let uu____14721 =
              let uu____14722 = unlazy t11  in
              term_eq_dbg dbg uu____14722 t21  in
            check "lazy_l" uu____14721
        | (uu____14723,FStar_Syntax_Syntax.Tm_lazy uu____14724) ->
            let uu____14725 =
              let uu____14726 = unlazy t21  in
              term_eq_dbg dbg t11 uu____14726  in
            check "lazy_r" uu____14725
        | (FStar_Syntax_Syntax.Tm_let
           ((b1,lbs1),t12),FStar_Syntax_Syntax.Tm_let ((b2,lbs2),t22)) ->
            ((check "let flag" (b1 = b2)) &&
               (let uu____14762 = eqlist (letbinding_eq_dbg dbg) lbs1 lbs2
                   in
                check "let lbs" uu____14762))
              &&
              (let uu____14764 = term_eq_dbg dbg t12 t22  in
               check "let body" uu____14764)
        | (FStar_Syntax_Syntax.Tm_uvar
           (u1,uu____14766),FStar_Syntax_Syntax.Tm_uvar (u2,uu____14768)) ->
            check "uvar"
              (u1.FStar_Syntax_Syntax.ctx_uvar_head =
                 u2.FStar_Syntax_Syntax.ctx_uvar_head)
        | (FStar_Syntax_Syntax.Tm_quoted
           (qt1,qi1),FStar_Syntax_Syntax.Tm_quoted (qt2,qi2)) ->
            (let uu____14825 =
               let uu____14826 = eq_quoteinfo qi1 qi2  in uu____14826 = Equal
                in
             check "tm_quoted qi" uu____14825) &&
              (let uu____14828 = term_eq_dbg dbg qt1 qt2  in
               check "tm_quoted payload" uu____14828)
        | (FStar_Syntax_Syntax.Tm_meta (t12,m1),FStar_Syntax_Syntax.Tm_meta
           (t22,m2)) ->
            (match (m1, m2) with
             | (FStar_Syntax_Syntax.Meta_monadic
                (n1,ty1),FStar_Syntax_Syntax.Meta_monadic (n2,ty2)) ->
                 (let uu____14855 = FStar_Ident.lid_equals n1 n2  in
                  check "meta_monadic lid" uu____14855) &&
                   (let uu____14857 = term_eq_dbg dbg ty1 ty2  in
                    check "meta_monadic type" uu____14857)
             | (FStar_Syntax_Syntax.Meta_monadic_lift
                (s1,t13,ty1),FStar_Syntax_Syntax.Meta_monadic_lift
                (s2,t23,ty2)) ->
                 ((let uu____14874 = FStar_Ident.lid_equals s1 s2  in
                   check "meta_monadic_lift src" uu____14874) &&
                    (let uu____14876 = FStar_Ident.lid_equals t13 t23  in
                     check "meta_monadic_lift tgt" uu____14876))
                   &&
                   (let uu____14878 = term_eq_dbg dbg ty1 ty2  in
                    check "meta_monadic_lift type" uu____14878)
             | uu____14879 -> fail "metas")
        | (FStar_Syntax_Syntax.Tm_unknown ,uu____14884) -> fail "unk"
        | (uu____14885,FStar_Syntax_Syntax.Tm_unknown ) -> fail "unk"
        | (FStar_Syntax_Syntax.Tm_bvar uu____14886,uu____14887) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_name uu____14888,uu____14889) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_fvar uu____14890,uu____14891) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_constant uu____14892,uu____14893) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_type uu____14894,uu____14895) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_abs uu____14896,uu____14897) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_arrow uu____14916,uu____14917) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_refine uu____14932,uu____14933) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_app uu____14940,uu____14941) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_match uu____14958,uu____14959) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_let uu____14982,uu____14983) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_uvar uu____14996,uu____14997) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_meta uu____15010,uu____15011) ->
            fail "bottom"
        | (uu____15018,FStar_Syntax_Syntax.Tm_bvar uu____15019) ->
            fail "bottom"
        | (uu____15020,FStar_Syntax_Syntax.Tm_name uu____15021) ->
            fail "bottom"
        | (uu____15022,FStar_Syntax_Syntax.Tm_fvar uu____15023) ->
            fail "bottom"
        | (uu____15024,FStar_Syntax_Syntax.Tm_constant uu____15025) ->
            fail "bottom"
        | (uu____15026,FStar_Syntax_Syntax.Tm_type uu____15027) ->
            fail "bottom"
        | (uu____15028,FStar_Syntax_Syntax.Tm_abs uu____15029) ->
            fail "bottom"
        | (uu____15048,FStar_Syntax_Syntax.Tm_arrow uu____15049) ->
            fail "bottom"
        | (uu____15064,FStar_Syntax_Syntax.Tm_refine uu____15065) ->
            fail "bottom"
        | (uu____15072,FStar_Syntax_Syntax.Tm_app uu____15073) ->
            fail "bottom"
        | (uu____15090,FStar_Syntax_Syntax.Tm_match uu____15091) ->
            fail "bottom"
        | (uu____15114,FStar_Syntax_Syntax.Tm_let uu____15115) ->
            fail "bottom"
        | (uu____15128,FStar_Syntax_Syntax.Tm_uvar uu____15129) ->
            fail "bottom"
        | (uu____15142,FStar_Syntax_Syntax.Tm_meta uu____15143) ->
            fail "bottom"

and (arg_eq_dbg :
  Prims.bool ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.arg_qualifier
                                                            FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2 ->
      (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.arg_qualifier
                                                              FStar_Pervasives_Native.option)
        FStar_Pervasives_Native.tuple2 -> Prims.bool)
  =
  fun dbg  ->
    fun a1  ->
      fun a2  ->
        eqprod
          (fun t1  ->
             fun t2  ->
               let uu____15176 = term_eq_dbg dbg t1 t2  in
               check "arg tm" uu____15176)
          (fun q1  ->
             fun q2  ->
               let uu____15186 =
                 let uu____15187 = eq_aqual q1 q2  in uu____15187 = Equal  in
               check "arg qual" uu____15186) a1 a2

and (binder_eq_dbg :
  Prims.bool ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                              FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2 ->
      (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                                FStar_Pervasives_Native.option)
        FStar_Pervasives_Native.tuple2 -> Prims.bool)
  =
  fun dbg  ->
    fun b1  ->
      fun b2  ->
        eqprod
          (fun b11  ->
             fun b21  ->
               let uu____15210 =
                 term_eq_dbg dbg b11.FStar_Syntax_Syntax.sort
                   b21.FStar_Syntax_Syntax.sort
                  in
               check "binder sort" uu____15210)
          (fun q1  ->
             fun q2  ->
               let uu____15220 =
                 let uu____15221 = eq_aqual q1 q2  in uu____15221 = Equal  in
               check "binder qual" uu____15220) b1 b2

and (lcomp_eq_dbg :
  FStar_Syntax_Syntax.lcomp -> FStar_Syntax_Syntax.lcomp -> Prims.bool) =
  fun c1  -> fun c2  -> fail "lcomp"

and (residual_eq_dbg :
  FStar_Syntax_Syntax.residual_comp ->
    FStar_Syntax_Syntax.residual_comp -> Prims.bool)
  = fun r1  -> fun r2  -> fail "residual"

and (comp_eq_dbg :
  Prims.bool ->
    FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool)
  =
  fun dbg  ->
    fun c1  ->
      fun c2  ->
        let c11 = comp_to_comp_typ_nouniv c1  in
        let c21 = comp_to_comp_typ_nouniv c2  in
        ((let uu____15237 =
            FStar_Ident.lid_equals c11.FStar_Syntax_Syntax.effect_name
              c21.FStar_Syntax_Syntax.effect_name
             in
          check "comp eff" uu____15237) &&
           (let uu____15239 =
              term_eq_dbg dbg c11.FStar_Syntax_Syntax.result_typ
                c21.FStar_Syntax_Syntax.result_typ
               in
            check "comp result typ" uu____15239))
          && true

and (eq_flags_dbg :
  Prims.bool ->
    FStar_Syntax_Syntax.cflags -> FStar_Syntax_Syntax.cflags -> Prims.bool)
  = fun dbg  -> fun f1  -> fun f2  -> true

and (branch_eq_dbg :
  Prims.bool ->
    (FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t,FStar_Syntax_Syntax.term'
                                                               FStar_Syntax_Syntax.syntax
                                                               FStar_Pervasives_Native.option,
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
      FStar_Pervasives_Native.tuple3 ->
      (FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t,FStar_Syntax_Syntax.term'
                                                                 FStar_Syntax_Syntax.syntax
                                                                 FStar_Pervasives_Native.option,
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
        FStar_Pervasives_Native.tuple3 -> Prims.bool)
  =
  fun dbg  ->
    fun uu____15244  ->
      fun uu____15245  ->
        match (uu____15244, uu____15245) with
        | ((p1,w1,t1),(p2,w2,t2)) ->
            ((let uu____15370 = FStar_Syntax_Syntax.eq_pat p1 p2  in
              check "branch pat" uu____15370) &&
               (let uu____15372 = term_eq_dbg dbg t1 t2  in
                check "branch body" uu____15372))
              &&
              (let uu____15374 =
                 match (w1, w2) with
                 | (FStar_Pervasives_Native.Some
                    x,FStar_Pervasives_Native.Some y) -> term_eq_dbg dbg x y
                 | (FStar_Pervasives_Native.None
                    ,FStar_Pervasives_Native.None ) -> true
                 | uu____15413 -> false  in
               check "branch when" uu____15374)

and (letbinding_eq_dbg :
  Prims.bool ->
    FStar_Syntax_Syntax.letbinding ->
      FStar_Syntax_Syntax.letbinding -> Prims.bool)
  =
  fun dbg  ->
    fun lb1  ->
      fun lb2  ->
        ((let uu____15431 =
            eqsum (fun bv1  -> fun bv2  -> true) FStar_Syntax_Syntax.fv_eq
              lb1.FStar_Syntax_Syntax.lbname lb2.FStar_Syntax_Syntax.lbname
             in
          check "lb bv" uu____15431) &&
           (let uu____15437 =
              term_eq_dbg dbg lb1.FStar_Syntax_Syntax.lbtyp
                lb2.FStar_Syntax_Syntax.lbtyp
               in
            check "lb typ" uu____15437))
          &&
          (let uu____15439 =
             term_eq_dbg dbg lb1.FStar_Syntax_Syntax.lbdef
               lb2.FStar_Syntax_Syntax.lbdef
              in
           check "lb def" uu____15439)

let (term_eq :
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t1  ->
    fun t2  ->
      let r =
        let uu____15451 = FStar_ST.op_Bang debug_term_eq  in
        term_eq_dbg uu____15451 t1 t2  in
      FStar_ST.op_Colon_Equals debug_term_eq false; r
  
let rec (sizeof : FStar_Syntax_Syntax.term -> Prims.int) =
  fun t  ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_delayed uu____15496 ->
        let uu____15519 =
          let uu____15520 = FStar_Syntax_Subst.compress t  in
          sizeof uu____15520  in
        (Prims.parse_int "1") + uu____15519
    | FStar_Syntax_Syntax.Tm_bvar bv ->
        let uu____15522 = sizeof bv.FStar_Syntax_Syntax.sort  in
        (Prims.parse_int "1") + uu____15522
    | FStar_Syntax_Syntax.Tm_name bv ->
        let uu____15524 = sizeof bv.FStar_Syntax_Syntax.sort  in
        (Prims.parse_int "1") + uu____15524
    | FStar_Syntax_Syntax.Tm_uinst (t1,us) ->
        let uu____15531 = sizeof t1  in (FStar_List.length us) + uu____15531
    | FStar_Syntax_Syntax.Tm_abs (bs,t1,uu____15534) ->
        let uu____15559 = sizeof t1  in
        let uu____15560 =
          FStar_List.fold_left
            (fun acc  ->
               fun uu____15573  ->
                 match uu____15573 with
                 | (bv,uu____15581) ->
                     let uu____15586 = sizeof bv.FStar_Syntax_Syntax.sort  in
                     acc + uu____15586) (Prims.parse_int "0") bs
           in
        uu____15559 + uu____15560
    | FStar_Syntax_Syntax.Tm_app (hd1,args) ->
        let uu____15613 = sizeof hd1  in
        let uu____15614 =
          FStar_List.fold_left
            (fun acc  ->
               fun uu____15627  ->
                 match uu____15627 with
                 | (arg,uu____15635) ->
                     let uu____15640 = sizeof arg  in acc + uu____15640)
            (Prims.parse_int "0") args
           in
        uu____15613 + uu____15614
    | uu____15641 -> (Prims.parse_int "1")
  
let (is_fvar : FStar_Ident.lident -> FStar_Syntax_Syntax.term -> Prims.bool)
  =
  fun lid  ->
    fun t  ->
      let uu____15652 =
        let uu____15653 = un_uinst t  in uu____15653.FStar_Syntax_Syntax.n
         in
      match uu____15652 with
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          FStar_Syntax_Syntax.fv_eq_lid fv lid
      | uu____15657 -> false
  
let (is_synth_by_tactic : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  -> is_fvar FStar_Parser_Const.synth_lid t 
let (has_attribute :
  FStar_Syntax_Syntax.attribute Prims.list ->
    FStar_Ident.lident -> Prims.bool)
  = fun attrs  -> fun attr  -> FStar_Util.for_some (is_fvar attr) attrs 
let (process_pragma :
  FStar_Syntax_Syntax.pragma -> FStar_Range.range -> unit) =
  fun p  ->
    fun r  ->
      let set_options1 t s =
        let uu____15698 = FStar_Options.set_options t s  in
        match uu____15698 with
        | FStar_Getopt.Success  -> ()
        | FStar_Getopt.Help  ->
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_FailToProcessPragma,
                "Failed to process pragma: use 'fstar --help' to see which options are available")
              r
        | FStar_Getopt.Error s1 ->
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_FailToProcessPragma,
                (Prims.strcat "Failed to process pragma: " s1)) r
         in
      match p with
      | FStar_Syntax_Syntax.LightOff  ->
          if p = FStar_Syntax_Syntax.LightOff
          then FStar_Options.set_ml_ish ()
          else ()
      | FStar_Syntax_Syntax.SetOptions o -> set_options1 FStar_Options.Set o
      | FStar_Syntax_Syntax.ResetOptions sopt ->
          ((let uu____15706 = FStar_Options.restore_cmd_line_options false
               in
            FStar_All.pipe_right uu____15706 (fun a235  -> ()));
           (match sopt with
            | FStar_Pervasives_Native.None  -> ()
            | FStar_Pervasives_Native.Some s ->
                set_options1 FStar_Options.Reset s))
      | FStar_Syntax_Syntax.PushOptions sopt ->
          (FStar_Options.internal_push ();
           (match sopt with
            | FStar_Pervasives_Native.None  -> ()
            | FStar_Pervasives_Native.Some s ->
                set_options1 FStar_Options.Reset s))
      | FStar_Syntax_Syntax.PopOptions  ->
          let uu____15713 = FStar_Options.internal_pop ()  in
          if uu____15713
          then ()
          else
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_FailToProcessPragma,
                "Cannot #pop-options, stack would become empty") r
  
let rec (unbound_variables :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.bv Prims.list)
  =
  fun tm  ->
    let t = FStar_Syntax_Subst.compress tm  in
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_delayed uu____15739 -> failwith "Impossible"
    | FStar_Syntax_Syntax.Tm_name x -> []
    | FStar_Syntax_Syntax.Tm_uvar uu____15765 -> []
    | FStar_Syntax_Syntax.Tm_type u -> []
    | FStar_Syntax_Syntax.Tm_bvar x -> [x]
    | FStar_Syntax_Syntax.Tm_fvar uu____15780 -> []
    | FStar_Syntax_Syntax.Tm_constant uu____15781 -> []
    | FStar_Syntax_Syntax.Tm_lazy uu____15782 -> []
    | FStar_Syntax_Syntax.Tm_unknown  -> []
    | FStar_Syntax_Syntax.Tm_uinst (t1,us) -> unbound_variables t1
    | FStar_Syntax_Syntax.Tm_abs (bs,t1,uu____15791) ->
        let uu____15816 = FStar_Syntax_Subst.open_term bs t1  in
        (match uu____15816 with
         | (bs1,t2) ->
             let uu____15825 =
               FStar_List.collect
                 (fun uu____15837  ->
                    match uu____15837 with
                    | (b,uu____15847) ->
                        unbound_variables b.FStar_Syntax_Syntax.sort) bs1
                in
             let uu____15852 = unbound_variables t2  in
             FStar_List.append uu____15825 uu____15852)
    | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
        let uu____15877 = FStar_Syntax_Subst.open_comp bs c  in
        (match uu____15877 with
         | (bs1,c1) ->
             let uu____15886 =
               FStar_List.collect
                 (fun uu____15898  ->
                    match uu____15898 with
                    | (b,uu____15908) ->
                        unbound_variables b.FStar_Syntax_Syntax.sort) bs1
                in
             let uu____15913 = unbound_variables_comp c1  in
             FStar_List.append uu____15886 uu____15913)
    | FStar_Syntax_Syntax.Tm_refine (b,t1) ->
        let uu____15922 =
          FStar_Syntax_Subst.open_term [(b, FStar_Pervasives_Native.None)] t1
           in
        (match uu____15922 with
         | (bs,t2) ->
             let uu____15945 =
               FStar_List.collect
                 (fun uu____15957  ->
                    match uu____15957 with
                    | (b1,uu____15967) ->
                        unbound_variables b1.FStar_Syntax_Syntax.sort) bs
                in
             let uu____15972 = unbound_variables t2  in
             FStar_List.append uu____15945 uu____15972)
    | FStar_Syntax_Syntax.Tm_app (t1,args) ->
        let uu____16001 =
          FStar_List.collect
            (fun uu____16015  ->
               match uu____16015 with
               | (x,uu____16027) -> unbound_variables x) args
           in
        let uu____16036 = unbound_variables t1  in
        FStar_List.append uu____16001 uu____16036
    | FStar_Syntax_Syntax.Tm_match (t1,pats) ->
        let uu____16077 = unbound_variables t1  in
        let uu____16080 =
          FStar_All.pipe_right pats
            (FStar_List.collect
               (fun br  ->
                  let uu____16095 = FStar_Syntax_Subst.open_branch br  in
                  match uu____16095 with
                  | (p,wopt,t2) ->
                      let uu____16117 = unbound_variables t2  in
                      let uu____16120 =
                        match wopt with
                        | FStar_Pervasives_Native.None  -> []
                        | FStar_Pervasives_Native.Some t3 ->
                            unbound_variables t3
                         in
                      FStar_List.append uu____16117 uu____16120))
           in
        FStar_List.append uu____16077 uu____16080
    | FStar_Syntax_Syntax.Tm_ascribed (t1,asc,uu____16134) ->
        let uu____16175 = unbound_variables t1  in
        let uu____16178 =
          let uu____16181 =
            match FStar_Pervasives_Native.fst asc with
            | FStar_Util.Inl t2 -> unbound_variables t2
            | FStar_Util.Inr c2 -> unbound_variables_comp c2  in
          let uu____16212 =
            match FStar_Pervasives_Native.snd asc with
            | FStar_Pervasives_Native.None  -> []
            | FStar_Pervasives_Native.Some tac -> unbound_variables tac  in
          FStar_List.append uu____16181 uu____16212  in
        FStar_List.append uu____16175 uu____16178
    | FStar_Syntax_Syntax.Tm_let ((false ,lb::[]),t1) ->
        let uu____16250 = unbound_variables lb.FStar_Syntax_Syntax.lbtyp  in
        let uu____16253 =
          let uu____16256 = unbound_variables lb.FStar_Syntax_Syntax.lbdef
             in
          let uu____16259 =
            match lb.FStar_Syntax_Syntax.lbname with
            | FStar_Util.Inr uu____16264 -> unbound_variables t1
            | FStar_Util.Inl bv ->
                let uu____16266 =
                  FStar_Syntax_Subst.open_term
                    [(bv, FStar_Pervasives_Native.None)] t1
                   in
                (match uu____16266 with
                 | (uu____16287,t2) -> unbound_variables t2)
             in
          FStar_List.append uu____16256 uu____16259  in
        FStar_List.append uu____16250 uu____16253
    | FStar_Syntax_Syntax.Tm_let ((uu____16289,lbs),t1) ->
        let uu____16306 = FStar_Syntax_Subst.open_let_rec lbs t1  in
        (match uu____16306 with
         | (lbs1,t2) ->
             let uu____16321 = unbound_variables t2  in
             let uu____16324 =
               FStar_List.collect
                 (fun lb  ->
                    let uu____16331 =
                      unbound_variables lb.FStar_Syntax_Syntax.lbtyp  in
                    let uu____16334 =
                      unbound_variables lb.FStar_Syntax_Syntax.lbdef  in
                    FStar_List.append uu____16331 uu____16334) lbs1
                in
             FStar_List.append uu____16321 uu____16324)
    | FStar_Syntax_Syntax.Tm_quoted (tm1,qi) ->
        (match qi.FStar_Syntax_Syntax.qkind with
         | FStar_Syntax_Syntax.Quote_static  -> []
         | FStar_Syntax_Syntax.Quote_dynamic  -> unbound_variables tm1)
    | FStar_Syntax_Syntax.Tm_meta (t1,m) ->
        let uu____16351 = unbound_variables t1  in
        let uu____16354 =
          match m with
          | FStar_Syntax_Syntax.Meta_pattern args ->
              FStar_List.collect
                (FStar_List.collect
                   (fun uu____16393  ->
                      match uu____16393 with
                      | (a,uu____16405) -> unbound_variables a)) args
          | FStar_Syntax_Syntax.Meta_monadic_lift
              (uu____16414,uu____16415,t') -> unbound_variables t'
          | FStar_Syntax_Syntax.Meta_monadic (uu____16421,t') ->
              unbound_variables t'
          | FStar_Syntax_Syntax.Meta_labeled uu____16427 -> []
          | FStar_Syntax_Syntax.Meta_desugared uu____16434 -> []
          | FStar_Syntax_Syntax.Meta_named uu____16435 -> []  in
        FStar_List.append uu____16351 uu____16354

and (unbound_variables_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.bv Prims.list)
  =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.GTotal (t,uu____16442) -> unbound_variables t
    | FStar_Syntax_Syntax.Total (t,uu____16452) -> unbound_variables t
    | FStar_Syntax_Syntax.Comp ct ->
        let uu____16462 = unbound_variables ct.FStar_Syntax_Syntax.result_typ
           in
        let uu____16465 =
          FStar_List.collect
            (fun uu____16479  ->
               match uu____16479 with
               | (a,uu____16491) -> unbound_variables a)
            ct.FStar_Syntax_Syntax.effect_args
           in
        FStar_List.append uu____16462 uu____16465
