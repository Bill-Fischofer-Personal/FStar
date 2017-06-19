open Prims
let subst_to_string s =
  let uu____16 =
    FStar_All.pipe_right s
      (FStar_List.map
         (fun uu____24  ->
            match uu____24 with
            | (b,uu____28) ->
                (b.FStar_Syntax_Syntax.ppname).FStar_Ident.idText)) in
  FStar_All.pipe_right uu____16 (FStar_String.concat ", ")
let rec apply_until_some f s =
  match s with
  | [] -> None
  | s0::rest ->
      let uu____67 = f s0 in
      (match uu____67 with
       | None  -> apply_until_some f rest
       | Some st -> Some (rest, st))
let map_some_curry f x uu___110_113 =
  match uu___110_113 with | None  -> x | Some (a,b) -> f a b
let apply_until_some_then_map f s g t =
  let uu____181 = apply_until_some f s in
  FStar_All.pipe_right uu____181 (map_some_curry g t)
let compose_subst s1 s2 =
  let s = FStar_List.append (fst s1) (fst s2) in
  let ropt =
    match snd s2 with | Some uu____240 -> snd s2 | uu____243 -> snd s1 in
  (s, ropt)
let delay:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax ->
    (FStar_Syntax_Syntax.subst_elt Prims.list Prims.list* FStar_Range.range
      option) -> FStar_Syntax_Syntax.term
  =
  fun t  ->
    fun s  ->
      match t.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_delayed (FStar_Util.Inl (t',s'),m) ->
          FStar_Syntax_Syntax.mk_Tm_delayed
            (FStar_Util.Inl (t', (compose_subst s' s)))
            t.FStar_Syntax_Syntax.pos
      | uu____341 ->
          FStar_Syntax_Syntax.mk_Tm_delayed (FStar_Util.Inl (t, s))
            t.FStar_Syntax_Syntax.pos
let rec force_uvar':
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax
  =
  fun t  ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_uvar (uv,uu____373) ->
        let uu____386 = FStar_Syntax_Unionfind.find uv in
        (match uu____386 with | Some t' -> force_uvar' t' | uu____391 -> t)
    | uu____393 -> t
let force_uvar:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax
  =
  fun t  ->
    let t' = force_uvar' t in
    let uu____407 = FStar_Util.physical_equality t t' in
    if uu____407
    then t
    else delay t' ([], (Some (t.FStar_Syntax_Syntax.pos)))
let rec force_delayed_thunk:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax
  =
  fun t  ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_delayed (f,m) ->
        let uu____467 = FStar_ST.read m in
        (match uu____467 with
         | None  ->
             (match f with
              | FStar_Util.Inr c ->
                  let t' =
                    let uu____503 = c () in force_delayed_thunk uu____503 in
                  (FStar_ST.write m (Some t'); t')
              | uu____514 -> t)
         | Some t' ->
             let t'1 = force_delayed_thunk t' in
             (FStar_ST.write m (Some t'1); t'1))
    | uu____546 -> t
let rec compress_univ:
  FStar_Syntax_Syntax.universe -> FStar_Syntax_Syntax.universe =
  fun u  ->
    match u with
    | FStar_Syntax_Syntax.U_unif u' ->
        let uu____554 = FStar_Syntax_Unionfind.univ_find u' in
        (match uu____554 with | Some u1 -> compress_univ u1 | uu____557 -> u)
    | uu____559 -> u
let subst_bv:
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.subst_elt Prims.list ->
      FStar_Syntax_Syntax.term option
  =
  fun a  ->
    fun s  ->
      FStar_Util.find_map s
        (fun uu___111_571  ->
           match uu___111_571 with
           | FStar_Syntax_Syntax.DB (i,x) when
               i = a.FStar_Syntax_Syntax.index ->
               let uu____575 =
                 let uu____576 =
                   let uu____577 = FStar_Syntax_Syntax.range_of_bv a in
                   FStar_Syntax_Syntax.set_range_of_bv x uu____577 in
                 FStar_Syntax_Syntax.bv_to_name uu____576 in
               Some uu____575
           | uu____578 -> None)
let subst_nm:
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.subst_elt Prims.list ->
      FStar_Syntax_Syntax.term option
  =
  fun a  ->
    fun s  ->
      FStar_Util.find_map s
        (fun uu___112_590  ->
           match uu___112_590 with
           | FStar_Syntax_Syntax.NM (x,i) when FStar_Syntax_Syntax.bv_eq a x
               ->
               let uu____594 =
                 FStar_Syntax_Syntax.bv_to_tm
                   (let uu___116_595 = a in
                    {
                      FStar_Syntax_Syntax.ppname =
                        (uu___116_595.FStar_Syntax_Syntax.ppname);
                      FStar_Syntax_Syntax.index = i;
                      FStar_Syntax_Syntax.sort =
                        (uu___116_595.FStar_Syntax_Syntax.sort)
                    }) in
               Some uu____594
           | FStar_Syntax_Syntax.NT (x,t) when FStar_Syntax_Syntax.bv_eq a x
               -> Some t
           | uu____604 -> None)
let subst_univ_bv:
  Prims.int ->
    FStar_Syntax_Syntax.subst_elt Prims.list ->
      FStar_Syntax_Syntax.universe option
  =
  fun x  ->
    fun s  ->
      FStar_Util.find_map s
        (fun uu___113_616  ->
           match uu___113_616 with
           | FStar_Syntax_Syntax.UN (y,t) when x = y -> Some t
           | uu____620 -> None)
let subst_univ_nm:
  FStar_Syntax_Syntax.univ_name ->
    FStar_Syntax_Syntax.subst_elt Prims.list ->
      FStar_Syntax_Syntax.universe option
  =
  fun x  ->
    fun s  ->
      FStar_Util.find_map s
        (fun uu___114_632  ->
           match uu___114_632 with
           | FStar_Syntax_Syntax.UD (y,i) when
               x.FStar_Ident.idText = y.FStar_Ident.idText ->
               Some (FStar_Syntax_Syntax.U_bvar i)
           | uu____636 -> None)
let rec subst_univ:
  FStar_Syntax_Syntax.subst_elt Prims.list Prims.list ->
    FStar_Syntax_Syntax.universe -> FStar_Syntax_Syntax.universe
  =
  fun s  ->
    fun u  ->
      let u1 = compress_univ u in
      match u1 with
      | FStar_Syntax_Syntax.U_bvar x ->
          apply_until_some_then_map (subst_univ_bv x) s subst_univ u1
      | FStar_Syntax_Syntax.U_name x ->
          apply_until_some_then_map (subst_univ_nm x) s subst_univ u1
      | FStar_Syntax_Syntax.U_zero  -> u1
      | FStar_Syntax_Syntax.U_unknown  -> u1
      | FStar_Syntax_Syntax.U_unif uu____654 -> u1
      | FStar_Syntax_Syntax.U_succ u2 ->
          let uu____658 = subst_univ s u2 in
          FStar_Syntax_Syntax.U_succ uu____658
      | FStar_Syntax_Syntax.U_max us ->
          let uu____661 = FStar_List.map (subst_univ s) us in
          FStar_Syntax_Syntax.U_max uu____661
let tag_with_range t s =
  match snd s with
  | None  -> t
  | Some r ->
      let r1 = FStar_Range.set_use_range t.FStar_Syntax_Syntax.pos r in
      let t' =
        match t.FStar_Syntax_Syntax.n with
        | FStar_Syntax_Syntax.Tm_bvar bv ->
            let uu____698 = FStar_Syntax_Syntax.set_range_of_bv bv r1 in
            FStar_Syntax_Syntax.Tm_bvar uu____698
        | FStar_Syntax_Syntax.Tm_name bv ->
            let uu____700 = FStar_Syntax_Syntax.set_range_of_bv bv r1 in
            FStar_Syntax_Syntax.Tm_name uu____700
        | FStar_Syntax_Syntax.Tm_fvar fv ->
            let l = FStar_Syntax_Syntax.lid_of_fv fv in
            let v1 =
              let uu___117_708 = fv.FStar_Syntax_Syntax.fv_name in
              {
                FStar_Syntax_Syntax.v = (FStar_Ident.set_lid_range l r1);
                FStar_Syntax_Syntax.ty =
                  (uu___117_708.FStar_Syntax_Syntax.ty);
                FStar_Syntax_Syntax.p = (uu___117_708.FStar_Syntax_Syntax.p)
              } in
            let fv1 =
              let uu___118_724 = fv in
              {
                FStar_Syntax_Syntax.fv_name = v1;
                FStar_Syntax_Syntax.fv_delta =
                  (uu___118_724.FStar_Syntax_Syntax.fv_delta);
                FStar_Syntax_Syntax.fv_qual =
                  (uu___118_724.FStar_Syntax_Syntax.fv_qual)
              } in
            FStar_Syntax_Syntax.Tm_fvar fv1
        | t' -> t' in
      let uu___119_726 = t in
      {
        FStar_Syntax_Syntax.n = t';
        FStar_Syntax_Syntax.tk = (uu___119_726.FStar_Syntax_Syntax.tk);
        FStar_Syntax_Syntax.pos = r1;
        FStar_Syntax_Syntax.vars = (uu___119_726.FStar_Syntax_Syntax.vars)
      }
let tag_lid_with_range l s =
  match snd s with
  | None  -> l
  | Some r ->
      let uu____756 =
        FStar_Range.set_use_range (FStar_Ident.range_of_lid l) r in
      FStar_Ident.set_lid_range l uu____756
let mk_range:
  FStar_Range.range -> FStar_Syntax_Syntax.subst_ts -> FStar_Range.range =
  fun r  ->
    fun s  ->
      match snd s with
      | None  -> r
      | Some r' -> FStar_Range.set_use_range r r'
let rec subst':
  FStar_Syntax_Syntax.subst_ts ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax ->
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax
  =
  fun s  ->
    fun t  ->
      let subst_tail tl1 = subst' (tl1, (snd s)) in
      match s with
      | ([],None ) -> t
      | ([]::[],None ) -> t
      | uu____840 ->
          let t0 = force_delayed_thunk t in
          (match t0.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Tm_unknown  -> tag_with_range t0 s
           | FStar_Syntax_Syntax.Tm_constant uu____848 -> tag_with_range t0 s
           | FStar_Syntax_Syntax.Tm_fvar uu____851 -> tag_with_range t0 s
           | FStar_Syntax_Syntax.Tm_uvar uu____854 -> tag_with_range t0 s
           | FStar_Syntax_Syntax.Tm_delayed (FStar_Util.Inl (t',s'),m) ->
               FStar_Syntax_Syntax.mk_Tm_delayed
                 (FStar_Util.Inl (t', (compose_subst s' s)))
                 t.FStar_Syntax_Syntax.pos
           | FStar_Syntax_Syntax.Tm_delayed
               (FStar_Util.Inr uu____935,uu____936) ->
               failwith
                 "Impossible: force_delayed_thunk removes lazy delayed nodes"
           | FStar_Syntax_Syntax.Tm_bvar a ->
               apply_until_some_then_map (subst_bv a) (fst s) subst_tail t0
           | FStar_Syntax_Syntax.Tm_name a ->
               apply_until_some_then_map (subst_nm a) (fst s) subst_tail t0
           | FStar_Syntax_Syntax.Tm_type u ->
               let uu____992 = mk_range t0.FStar_Syntax_Syntax.pos s in
               let uu____993 =
                 let uu____996 =
                   let uu____997 = subst_univ (fst s) u in
                   FStar_Syntax_Syntax.Tm_type uu____997 in
                 FStar_Syntax_Syntax.mk uu____996 in
               uu____993 None uu____992
           | uu____1009 ->
               let uu____1010 = mk_range t.FStar_Syntax_Syntax.pos s in
               FStar_Syntax_Syntax.mk_Tm_delayed (FStar_Util.Inl (t0, s))
                 uu____1010)
and subst_flags':
  FStar_Syntax_Syntax.subst_ts ->
    FStar_Syntax_Syntax.cflags Prims.list ->
      FStar_Syntax_Syntax.cflags Prims.list
  =
  fun s  ->
    fun flags  ->
      FStar_All.pipe_right flags
        (FStar_List.map
           (fun uu___115_1024  ->
              match uu___115_1024 with
              | FStar_Syntax_Syntax.DECREASES a ->
                  let uu____1028 = subst' s a in
                  FStar_Syntax_Syntax.DECREASES uu____1028
              | f -> f))
and subst_comp_typ':
  (FStar_Syntax_Syntax.subst_elt Prims.list Prims.list* FStar_Range.range
    option) -> FStar_Syntax_Syntax.comp_typ -> FStar_Syntax_Syntax.comp_typ
  =
  fun s  ->
    fun t  ->
      match s with
      | ([],None ) -> t
      | ([]::[],None ) -> t
      | uu____1048 ->
          let uu___120_1054 = t in
          let uu____1055 =
            FStar_List.map (subst_univ (fst s))
              t.FStar_Syntax_Syntax.comp_univs in
          let uu____1059 =
            tag_lid_with_range t.FStar_Syntax_Syntax.effect_name s in
          let uu____1062 = subst' s t.FStar_Syntax_Syntax.result_typ in
          let uu____1065 =
            FStar_List.map
              (fun uu____1079  ->
                 match uu____1079 with
                 | (t1,imp) ->
                     let uu____1094 = subst' s t1 in (uu____1094, imp))
              t.FStar_Syntax_Syntax.effect_args in
          let uu____1099 = subst_flags' s t.FStar_Syntax_Syntax.flags in
          {
            FStar_Syntax_Syntax.comp_univs = uu____1055;
            FStar_Syntax_Syntax.effect_name = uu____1059;
            FStar_Syntax_Syntax.result_typ = uu____1062;
            FStar_Syntax_Syntax.effect_args = uu____1065;
            FStar_Syntax_Syntax.flags = uu____1099
          }
and subst_comp':
  (FStar_Syntax_Syntax.subst_elt Prims.list Prims.list* FStar_Range.range
    option) ->
    (FStar_Syntax_Syntax.comp',Prims.unit) FStar_Syntax_Syntax.syntax ->
      (FStar_Syntax_Syntax.comp',Prims.unit) FStar_Syntax_Syntax.syntax
  =
  fun s  ->
    fun t  ->
      match s with
      | ([],None ) -> t
      | ([]::[],None ) -> t
      | uu____1121 ->
          (match t.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Total (t1,uopt) ->
               let uu____1137 = subst' s t1 in
               let uu____1138 = FStar_Option.map (subst_univ (fst s)) uopt in
               FStar_Syntax_Syntax.mk_Total' uu____1137 uu____1138
           | FStar_Syntax_Syntax.GTotal (t1,uopt) ->
               let uu____1151 = subst' s t1 in
               let uu____1152 = FStar_Option.map (subst_univ (fst s)) uopt in
               FStar_Syntax_Syntax.mk_GTotal' uu____1151 uu____1152
           | FStar_Syntax_Syntax.Comp ct ->
               let uu____1158 = subst_comp_typ' s ct in
               FStar_Syntax_Syntax.mk_Comp uu____1158)
let shift:
  Prims.int -> FStar_Syntax_Syntax.subst_elt -> FStar_Syntax_Syntax.subst_elt
  =
  fun n1  ->
    fun s  ->
      match s with
      | FStar_Syntax_Syntax.DB (i,t) -> FStar_Syntax_Syntax.DB ((i + n1), t)
      | FStar_Syntax_Syntax.UN (i,t) -> FStar_Syntax_Syntax.UN ((i + n1), t)
      | FStar_Syntax_Syntax.NM (x,i) -> FStar_Syntax_Syntax.NM (x, (i + n1))
      | FStar_Syntax_Syntax.UD (x,i) -> FStar_Syntax_Syntax.UD (x, (i + n1))
      | FStar_Syntax_Syntax.NT uu____1175 -> s
let shift_subst:
  Prims.int ->
    FStar_Syntax_Syntax.subst_t -> FStar_Syntax_Syntax.subst_elt Prims.list
  = fun n1  -> fun s  -> FStar_List.map (shift n1) s
let shift_subst' n1 s =
  let uu____1212 =
    FStar_All.pipe_right (fst s) (FStar_List.map (shift_subst n1)) in
  (uu____1212, (snd s))
let subst_binder' s uu____1237 =
  match uu____1237 with
  | (x,imp) ->
      let uu____1242 =
        let uu___121_1243 = x in
        let uu____1244 = subst' s x.FStar_Syntax_Syntax.sort in
        {
          FStar_Syntax_Syntax.ppname =
            (uu___121_1243.FStar_Syntax_Syntax.ppname);
          FStar_Syntax_Syntax.index =
            (uu___121_1243.FStar_Syntax_Syntax.index);
          FStar_Syntax_Syntax.sort = uu____1244
        } in
      (uu____1242, imp)
let subst_binders' s bs =
  FStar_All.pipe_right bs
    (FStar_List.mapi
       (fun i  ->
          fun b  ->
            if i = (Prims.parse_int "0")
            then subst_binder' s b
            else
              (let uu____1288 = shift_subst' i s in
               subst_binder' uu____1288 b)))
let subst_binders:
  FStar_Syntax_Syntax.subst_elt Prims.list ->
    FStar_Syntax_Syntax.binders ->
      (FStar_Syntax_Syntax.bv* FStar_Syntax_Syntax.aqual) Prims.list
  = fun s  -> fun bs  -> subst_binders' ([s], None) bs
let subst_arg' s uu____1327 =
  match uu____1327 with
  | (t,imp) -> let uu____1338 = subst' s t in (uu____1338, imp)
let subst_args' s = FStar_List.map (subst_arg' s)
let subst_pat':
  (FStar_Syntax_Syntax.subst_t Prims.list* FStar_Range.range option) ->
    (FStar_Syntax_Syntax.pat',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.withinfo_t -> (FStar_Syntax_Syntax.pat* Prims.int)
  =
  fun s  ->
    fun p  ->
      let rec aux n1 p1 =
        match p1.FStar_Syntax_Syntax.v with
        | FStar_Syntax_Syntax.Pat_constant uu____1414 -> (p1, n1)
        | FStar_Syntax_Syntax.Pat_cons (fv,pats) ->
            let uu____1429 =
              FStar_All.pipe_right pats
                (FStar_List.fold_left
                   (fun uu____1454  ->
                      fun uu____1455  ->
                        match (uu____1454, uu____1455) with
                        | ((pats1,n2),(p2,imp)) ->
                            let uu____1502 = aux n2 p2 in
                            (match uu____1502 with
                             | (p3,m) -> (((p3, imp) :: pats1), m))) 
                   ([], n1)) in
            (match uu____1429 with
             | (pats1,n2) ->
                 ((let uu___122_1534 = p1 in
                   {
                     FStar_Syntax_Syntax.v =
                       (FStar_Syntax_Syntax.Pat_cons
                          (fv, (FStar_List.rev pats1)));
                     FStar_Syntax_Syntax.ty =
                       (uu___122_1534.FStar_Syntax_Syntax.ty);
                     FStar_Syntax_Syntax.p =
                       (uu___122_1534.FStar_Syntax_Syntax.p)
                   }), n2))
        | FStar_Syntax_Syntax.Pat_var x ->
            let s1 = shift_subst' n1 s in
            let x1 =
              let uu___123_1550 = x in
              let uu____1551 = subst' s1 x.FStar_Syntax_Syntax.sort in
              {
                FStar_Syntax_Syntax.ppname =
                  (uu___123_1550.FStar_Syntax_Syntax.ppname);
                FStar_Syntax_Syntax.index =
                  (uu___123_1550.FStar_Syntax_Syntax.index);
                FStar_Syntax_Syntax.sort = uu____1551
              } in
            ((let uu___124_1556 = p1 in
              {
                FStar_Syntax_Syntax.v = (FStar_Syntax_Syntax.Pat_var x1);
                FStar_Syntax_Syntax.ty =
                  (uu___124_1556.FStar_Syntax_Syntax.ty);
                FStar_Syntax_Syntax.p = (uu___124_1556.FStar_Syntax_Syntax.p)
              }), (n1 + (Prims.parse_int "1")))
        | FStar_Syntax_Syntax.Pat_wild x ->
            let s1 = shift_subst' n1 s in
            let x1 =
              let uu___125_1567 = x in
              let uu____1568 = subst' s1 x.FStar_Syntax_Syntax.sort in
              {
                FStar_Syntax_Syntax.ppname =
                  (uu___125_1567.FStar_Syntax_Syntax.ppname);
                FStar_Syntax_Syntax.index =
                  (uu___125_1567.FStar_Syntax_Syntax.index);
                FStar_Syntax_Syntax.sort = uu____1568
              } in
            ((let uu___126_1573 = p1 in
              {
                FStar_Syntax_Syntax.v = (FStar_Syntax_Syntax.Pat_wild x1);
                FStar_Syntax_Syntax.ty =
                  (uu___126_1573.FStar_Syntax_Syntax.ty);
                FStar_Syntax_Syntax.p = (uu___126_1573.FStar_Syntax_Syntax.p)
              }), (n1 + (Prims.parse_int "1")))
        | FStar_Syntax_Syntax.Pat_dot_term (x,t0) ->
            let s1 = shift_subst' n1 s in
            let x1 =
              let uu___127_1589 = x in
              let uu____1590 = subst' s1 x.FStar_Syntax_Syntax.sort in
              {
                FStar_Syntax_Syntax.ppname =
                  (uu___127_1589.FStar_Syntax_Syntax.ppname);
                FStar_Syntax_Syntax.index =
                  (uu___127_1589.FStar_Syntax_Syntax.index);
                FStar_Syntax_Syntax.sort = uu____1590
              } in
            let t01 = subst' s1 t0 in
            ((let uu___128_1598 = p1 in
              {
                FStar_Syntax_Syntax.v =
                  (FStar_Syntax_Syntax.Pat_dot_term (x1, t01));
                FStar_Syntax_Syntax.ty =
                  (uu___128_1598.FStar_Syntax_Syntax.ty);
                FStar_Syntax_Syntax.p = (uu___128_1598.FStar_Syntax_Syntax.p)
              }), n1) in
      aux (Prims.parse_int "0") p
let push_subst_lcomp s lopt =
  match lopt with
  | None  -> lopt
  | Some (FStar_Util.Inr uu____1629) -> lopt
  | Some (FStar_Util.Inl l) ->
      let uu____1635 =
        let uu____1638 =
          let uu___129_1639 = l in
          let uu____1640 = subst' s l.FStar_Syntax_Syntax.res_typ in
          {
            FStar_Syntax_Syntax.eff_name =
              (uu___129_1639.FStar_Syntax_Syntax.eff_name);
            FStar_Syntax_Syntax.res_typ = uu____1640;
            FStar_Syntax_Syntax.cflags =
              (uu___129_1639.FStar_Syntax_Syntax.cflags);
            FStar_Syntax_Syntax.comp =
              (fun uu____1643  ->
                 let uu____1644 = l.FStar_Syntax_Syntax.comp () in
                 subst_comp' s uu____1644)
          } in
        FStar_Util.Inl uu____1638 in
      Some uu____1635
let push_subst:
  FStar_Syntax_Syntax.subst_ts ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax ->
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax
  =
  fun s  ->
    fun t  ->
      let mk1 t' =
        let uu____1669 = mk_range t.FStar_Syntax_Syntax.pos s in
        FStar_Syntax_Syntax.mk t' None uu____1669 in
      match t.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_delayed uu____1676 -> failwith "Impossible"
      | FStar_Syntax_Syntax.Tm_constant uu____1699 -> tag_with_range t s
      | FStar_Syntax_Syntax.Tm_fvar uu____1702 -> tag_with_range t s
      | FStar_Syntax_Syntax.Tm_unknown  -> tag_with_range t s
      | FStar_Syntax_Syntax.Tm_uvar uu____1707 -> tag_with_range t s
      | FStar_Syntax_Syntax.Tm_type uu____1718 -> subst' s t
      | FStar_Syntax_Syntax.Tm_bvar uu____1719 -> subst' s t
      | FStar_Syntax_Syntax.Tm_name uu____1720 -> subst' s t
      | FStar_Syntax_Syntax.Tm_uinst (t',us) ->
          let us1 = FStar_List.map (subst_univ (fst s)) us in
          let uu____1732 = FStar_Syntax_Syntax.mk_Tm_uinst t' us1 in
          tag_with_range uu____1732 s
      | FStar_Syntax_Syntax.Tm_app (t0,args) ->
          let uu____1753 =
            let uu____1754 =
              let uu____1764 = subst' s t0 in
              let uu____1767 = subst_args' s args in (uu____1764, uu____1767) in
            FStar_Syntax_Syntax.Tm_app uu____1754 in
          mk1 uu____1753
      | FStar_Syntax_Syntax.Tm_ascribed (t0,(annot,topt),lopt) ->
          let annot1 =
            match annot with
            | FStar_Util.Inl t1 ->
                let uu____1839 = subst' s t1 in FStar_Util.Inl uu____1839
            | FStar_Util.Inr c ->
                let uu____1853 = subst_comp' s c in FStar_Util.Inr uu____1853 in
          let uu____1860 =
            let uu____1861 =
              let uu____1879 = subst' s t0 in
              let uu____1882 =
                let uu____1894 = FStar_Util.map_opt topt (subst' s) in
                (annot1, uu____1894) in
              (uu____1879, uu____1882, lopt) in
            FStar_Syntax_Syntax.Tm_ascribed uu____1861 in
          mk1 uu____1860
      | FStar_Syntax_Syntax.Tm_abs (bs,body,lopt) ->
          let n1 = FStar_List.length bs in
          let s' = shift_subst' n1 s in
          let uu____1965 =
            let uu____1966 =
              let uu____1981 = subst_binders' s bs in
              let uu____1985 = subst' s' body in
              let uu____1988 = push_subst_lcomp s' lopt in
              (uu____1981, uu____1985, uu____1988) in
            FStar_Syntax_Syntax.Tm_abs uu____1966 in
          mk1 uu____1965
      | FStar_Syntax_Syntax.Tm_arrow (bs,comp) ->
          let n1 = FStar_List.length bs in
          let uu____2026 =
            let uu____2027 =
              let uu____2035 = subst_binders' s bs in
              let uu____2039 =
                let uu____2042 = shift_subst' n1 s in
                subst_comp' uu____2042 comp in
              (uu____2035, uu____2039) in
            FStar_Syntax_Syntax.Tm_arrow uu____2027 in
          mk1 uu____2026
      | FStar_Syntax_Syntax.Tm_refine (x,phi) ->
          let x1 =
            let uu___130_2065 = x in
            let uu____2066 = subst' s x.FStar_Syntax_Syntax.sort in
            {
              FStar_Syntax_Syntax.ppname =
                (uu___130_2065.FStar_Syntax_Syntax.ppname);
              FStar_Syntax_Syntax.index =
                (uu___130_2065.FStar_Syntax_Syntax.index);
              FStar_Syntax_Syntax.sort = uu____2066
            } in
          let phi1 =
            let uu____2072 = shift_subst' (Prims.parse_int "1") s in
            subst' uu____2072 phi in
          mk1 (FStar_Syntax_Syntax.Tm_refine (x1, phi1))
      | FStar_Syntax_Syntax.Tm_match (t0,pats) ->
          let t01 = subst' s t0 in
          let pats1 =
            FStar_All.pipe_right pats
              (FStar_List.map
                 (fun uu____2155  ->
                    match uu____2155 with
                    | (pat,wopt,branch) ->
                        let uu____2191 = subst_pat' s pat in
                        (match uu____2191 with
                         | (pat1,n1) ->
                             let s1 = shift_subst' n1 s in
                             let wopt1 =
                               match wopt with
                               | None  -> None
                               | Some w ->
                                   let uu____2226 = subst' s1 w in
                                   Some uu____2226 in
                             let branch1 = subst' s1 branch in
                             (pat1, wopt1, branch1)))) in
          mk1 (FStar_Syntax_Syntax.Tm_match (t01, pats1))
      | FStar_Syntax_Syntax.Tm_let ((is_rec,lbs),body) ->
          let n1 = FStar_List.length lbs in
          let sn = shift_subst' n1 s in
          let body1 = subst' sn body in
          let lbs1 =
            FStar_All.pipe_right lbs
              (FStar_List.map
                 (fun lb  ->
                    let lbt = subst' s lb.FStar_Syntax_Syntax.lbtyp in
                    let lbd =
                      let uu____2289 =
                        is_rec &&
                          (FStar_Util.is_left lb.FStar_Syntax_Syntax.lbname) in
                      if uu____2289
                      then subst' sn lb.FStar_Syntax_Syntax.lbdef
                      else subst' s lb.FStar_Syntax_Syntax.lbdef in
                    let lbname =
                      match lb.FStar_Syntax_Syntax.lbname with
                      | FStar_Util.Inl x ->
                          FStar_Util.Inl
                            (let uu___131_2299 = x in
                             {
                               FStar_Syntax_Syntax.ppname =
                                 (uu___131_2299.FStar_Syntax_Syntax.ppname);
                               FStar_Syntax_Syntax.index =
                                 (uu___131_2299.FStar_Syntax_Syntax.index);
                               FStar_Syntax_Syntax.sort = lbt
                             })
                      | FStar_Util.Inr fv ->
                          FStar_Util.Inr
                            (let uu___132_2301 = fv in
                             {
                               FStar_Syntax_Syntax.fv_name =
                                 (let uu___133_2302 =
                                    fv.FStar_Syntax_Syntax.fv_name in
                                  {
                                    FStar_Syntax_Syntax.v =
                                      (uu___133_2302.FStar_Syntax_Syntax.v);
                                    FStar_Syntax_Syntax.ty = lbt;
                                    FStar_Syntax_Syntax.p =
                                      (uu___133_2302.FStar_Syntax_Syntax.p)
                                  });
                               FStar_Syntax_Syntax.fv_delta =
                                 (uu___132_2301.FStar_Syntax_Syntax.fv_delta);
                               FStar_Syntax_Syntax.fv_qual =
                                 (uu___132_2301.FStar_Syntax_Syntax.fv_qual)
                             }) in
                    let uu___134_2317 = lb in
                    {
                      FStar_Syntax_Syntax.lbname = lbname;
                      FStar_Syntax_Syntax.lbunivs =
                        (uu___134_2317.FStar_Syntax_Syntax.lbunivs);
                      FStar_Syntax_Syntax.lbtyp = lbt;
                      FStar_Syntax_Syntax.lbeff =
                        (uu___134_2317.FStar_Syntax_Syntax.lbeff);
                      FStar_Syntax_Syntax.lbdef = lbd
                    })) in
          mk1 (FStar_Syntax_Syntax.Tm_let ((is_rec, lbs1), body1))
      | FStar_Syntax_Syntax.Tm_meta (t0,FStar_Syntax_Syntax.Meta_pattern ps)
          ->
          let uu____2336 =
            let uu____2337 =
              let uu____2342 = subst' s t0 in
              let uu____2345 =
                let uu____2346 =
                  FStar_All.pipe_right ps (FStar_List.map (subst_args' s)) in
                FStar_Syntax_Syntax.Meta_pattern uu____2346 in
              (uu____2342, uu____2345) in
            FStar_Syntax_Syntax.Tm_meta uu____2337 in
          mk1 uu____2336
      | FStar_Syntax_Syntax.Tm_meta
          (t0,FStar_Syntax_Syntax.Meta_monadic (m,t1)) ->
          let uu____2388 =
            let uu____2389 =
              let uu____2394 = subst' s t0 in
              let uu____2397 =
                let uu____2398 =
                  let uu____2403 = subst' s t1 in (m, uu____2403) in
                FStar_Syntax_Syntax.Meta_monadic uu____2398 in
              (uu____2394, uu____2397) in
            FStar_Syntax_Syntax.Tm_meta uu____2389 in
          mk1 uu____2388
      | FStar_Syntax_Syntax.Tm_meta
          (t0,FStar_Syntax_Syntax.Meta_monadic_lift (m1,m2,t1)) ->
          let uu____2422 =
            let uu____2423 =
              let uu____2428 = subst' s t0 in
              let uu____2431 =
                let uu____2432 =
                  let uu____2438 = subst' s t1 in (m1, m2, uu____2438) in
                FStar_Syntax_Syntax.Meta_monadic_lift uu____2432 in
              (uu____2428, uu____2431) in
            FStar_Syntax_Syntax.Tm_meta uu____2423 in
          mk1 uu____2422
      | FStar_Syntax_Syntax.Tm_meta (t1,m) ->
          let uu____2451 =
            let uu____2452 = let uu____2457 = subst' s t1 in (uu____2457, m) in
            FStar_Syntax_Syntax.Tm_meta uu____2452 in
          mk1 uu____2451
let rec compress: FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term =
  fun t  ->
    let t1 = force_delayed_thunk t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_delayed (FStar_Util.Inl (t2,s),memo) ->
        let t' = let uu____2521 = push_subst s t2 in compress uu____2521 in
        (FStar_Syntax_Unionfind.update_in_tx memo (Some t'); t')
    | uu____2528 ->
        let t' = force_uvar t1 in
        (match t'.FStar_Syntax_Syntax.n with
         | FStar_Syntax_Syntax.Tm_delayed uu____2532 -> compress t'
         | uu____2553 -> t')
let subst:
  FStar_Syntax_Syntax.subst_elt Prims.list ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax
  = fun s  -> fun t  -> subst' ([s], None) t
let set_use_range:
  FStar_Range.range ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax
  =
  fun r  ->
    fun t  ->
      subst'
        ([],
          (Some
             (let uu___135_2581 = r in
              {
                FStar_Range.def_range = (r.FStar_Range.use_range);
                FStar_Range.use_range = (uu___135_2581.FStar_Range.use_range)
              }))) t
let subst_comp:
  FStar_Syntax_Syntax.subst_elt Prims.list ->
    FStar_Syntax_Syntax.comp ->
      (FStar_Syntax_Syntax.comp',Prims.unit) FStar_Syntax_Syntax.syntax
  = fun s  -> fun t  -> subst_comp' ([s], None) t
let closing_subst bs =
  let uu____2613 =
    FStar_List.fold_right
      (fun uu____2622  ->
         fun uu____2623  ->
           match (uu____2622, uu____2623) with
           | ((x,uu____2638),(subst1,n1)) ->
               (((FStar_Syntax_Syntax.NM (x, n1)) :: subst1),
                 (n1 + (Prims.parse_int "1")))) bs
      ([], (Prims.parse_int "0")) in
  FStar_All.pipe_right uu____2613 FStar_Pervasives.fst
let open_binders' bs =
  let rec aux bs1 o =
    match bs1 with
    | [] -> ([], o)
    | (x,imp)::bs' ->
        let x' =
          let uu___136_2720 = FStar_Syntax_Syntax.freshen_bv x in
          let uu____2721 = subst o x.FStar_Syntax_Syntax.sort in
          {
            FStar_Syntax_Syntax.ppname =
              (uu___136_2720.FStar_Syntax_Syntax.ppname);
            FStar_Syntax_Syntax.index =
              (uu___136_2720.FStar_Syntax_Syntax.index);
            FStar_Syntax_Syntax.sort = uu____2721
          } in
        let o1 =
          let uu____2726 = shift_subst (Prims.parse_int "1") o in
          (FStar_Syntax_Syntax.DB ((Prims.parse_int "0"), x')) :: uu____2726 in
        let uu____2728 = aux bs' o1 in
        (match uu____2728 with | (bs'1,o2) -> (((x', imp) :: bs'1), o2)) in
  aux bs []
let open_binders:
  FStar_Syntax_Syntax.binders ->
    (FStar_Syntax_Syntax.bv* FStar_Syntax_Syntax.aqual) Prims.list
  = fun bs  -> let uu____2761 = open_binders' bs in fst uu____2761
let open_term':
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.binders* FStar_Syntax_Syntax.term*
        FStar_Syntax_Syntax.subst_t)
  =
  fun bs  ->
    fun t  ->
      let uu____2783 = open_binders' bs in
      match uu____2783 with
      | (bs',opening) ->
          let uu____2803 = subst opening t in (bs', uu____2803, opening)
let open_term:
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.binders* FStar_Syntax_Syntax.term)
  =
  fun bs  ->
    fun t  ->
      let uu____2818 = open_term' bs t in
      match uu____2818 with | (b,t1,uu____2826) -> (b, t1)
let open_comp:
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.comp ->
      (FStar_Syntax_Syntax.binders* FStar_Syntax_Syntax.comp)
  =
  fun bs  ->
    fun t  ->
      let uu____2837 = open_binders' bs in
      match uu____2837 with
      | (bs',opening) ->
          let uu____2856 = subst_comp opening t in (bs', uu____2856)
let open_pat:
  FStar_Syntax_Syntax.pat ->
    (FStar_Syntax_Syntax.pat* FStar_Syntax_Syntax.subst_t)
  =
  fun p  ->
    let rec open_pat_aux sub1 renaming p1 =
      match p1.FStar_Syntax_Syntax.v with
      | FStar_Syntax_Syntax.Pat_constant uu____2908 -> (p1, sub1, renaming)
      | FStar_Syntax_Syntax.Pat_cons (fv,pats) ->
          let uu____2927 =
            FStar_All.pipe_right pats
              (FStar_List.fold_left
                 (fun uu____2973  ->
                    fun uu____2974  ->
                      match (uu____2973, uu____2974) with
                      | ((pats1,sub2,renaming1),(p2,imp)) ->
                          let uu____3062 = open_pat_aux sub2 renaming1 p2 in
                          (match uu____3062 with
                           | (p3,sub3,renaming2) ->
                               (((p3, imp) :: pats1), sub3, renaming2)))
                 ([], sub1, renaming)) in
          (match uu____2927 with
           | (pats1,sub2,renaming1) ->
               ((let uu___137_3163 = p1 in
                 {
                   FStar_Syntax_Syntax.v =
                     (FStar_Syntax_Syntax.Pat_cons
                        (fv, (FStar_List.rev pats1)));
                   FStar_Syntax_Syntax.ty =
                     (uu___137_3163.FStar_Syntax_Syntax.ty);
                   FStar_Syntax_Syntax.p =
                     (uu___137_3163.FStar_Syntax_Syntax.p)
                 }), sub2, renaming1))
      | FStar_Syntax_Syntax.Pat_var x ->
          let x' =
            let uu___138_3177 = FStar_Syntax_Syntax.freshen_bv x in
            let uu____3178 = subst sub1 x.FStar_Syntax_Syntax.sort in
            {
              FStar_Syntax_Syntax.ppname =
                (uu___138_3177.FStar_Syntax_Syntax.ppname);
              FStar_Syntax_Syntax.index =
                (uu___138_3177.FStar_Syntax_Syntax.index);
              FStar_Syntax_Syntax.sort = uu____3178
            } in
          let sub2 =
            let uu____3183 = shift_subst (Prims.parse_int "1") sub1 in
            (FStar_Syntax_Syntax.DB ((Prims.parse_int "0"), x')) ::
              uu____3183 in
          ((let uu___139_3191 = p1 in
            {
              FStar_Syntax_Syntax.v = (FStar_Syntax_Syntax.Pat_var x');
              FStar_Syntax_Syntax.ty = (uu___139_3191.FStar_Syntax_Syntax.ty);
              FStar_Syntax_Syntax.p = (uu___139_3191.FStar_Syntax_Syntax.p)
            }), sub2, ((x, x') :: renaming))
      | FStar_Syntax_Syntax.Pat_wild x ->
          let x' =
            let uu___140_3198 = FStar_Syntax_Syntax.freshen_bv x in
            let uu____3199 = subst sub1 x.FStar_Syntax_Syntax.sort in
            {
              FStar_Syntax_Syntax.ppname =
                (uu___140_3198.FStar_Syntax_Syntax.ppname);
              FStar_Syntax_Syntax.index =
                (uu___140_3198.FStar_Syntax_Syntax.index);
              FStar_Syntax_Syntax.sort = uu____3199
            } in
          let sub2 =
            let uu____3204 = shift_subst (Prims.parse_int "1") sub1 in
            (FStar_Syntax_Syntax.DB ((Prims.parse_int "0"), x')) ::
              uu____3204 in
          ((let uu___141_3212 = p1 in
            {
              FStar_Syntax_Syntax.v = (FStar_Syntax_Syntax.Pat_wild x');
              FStar_Syntax_Syntax.ty = (uu___141_3212.FStar_Syntax_Syntax.ty);
              FStar_Syntax_Syntax.p = (uu___141_3212.FStar_Syntax_Syntax.p)
            }), sub2, ((x, x') :: renaming))
      | FStar_Syntax_Syntax.Pat_dot_term (x,t0) ->
          let x1 =
            let uu___142_3224 = x in
            let uu____3225 = subst sub1 x.FStar_Syntax_Syntax.sort in
            {
              FStar_Syntax_Syntax.ppname =
                (uu___142_3224.FStar_Syntax_Syntax.ppname);
              FStar_Syntax_Syntax.index =
                (uu___142_3224.FStar_Syntax_Syntax.index);
              FStar_Syntax_Syntax.sort = uu____3225
            } in
          let t01 = subst sub1 t0 in
          ((let uu___143_3235 = p1 in
            {
              FStar_Syntax_Syntax.v =
                (FStar_Syntax_Syntax.Pat_dot_term (x1, t01));
              FStar_Syntax_Syntax.ty = (uu___143_3235.FStar_Syntax_Syntax.ty);
              FStar_Syntax_Syntax.p = (uu___143_3235.FStar_Syntax_Syntax.p)
            }), sub1, renaming) in
    let uu____3238 = open_pat_aux [] [] p in
    match uu____3238 with | (p1,sub1,uu____3254) -> (p1, sub1)
let open_branch: FStar_Syntax_Syntax.branch -> FStar_Syntax_Syntax.branch =
  fun uu____3273  ->
    match uu____3273 with
    | (p,wopt,e) ->
        let uu____3291 = open_pat p in
        (match uu____3291 with
         | (p1,opening) ->
             let wopt1 =
               match wopt with
               | None  -> None
               | Some w ->
                   let uu____3306 = subst opening w in Some uu____3306 in
             let e1 = subst opening e in (p1, wopt1, e1))
let close:
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  =
  fun bs  ->
    fun t  -> let uu____3317 = closing_subst bs in subst uu____3317 t
let close_comp:
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.comp
  =
  fun bs  ->
    fun c  -> let uu____3327 = closing_subst bs in subst_comp uu____3327 c
let close_binders:
  FStar_Syntax_Syntax.binders ->
    (FStar_Syntax_Syntax.bv* FStar_Syntax_Syntax.aqual) Prims.list
  =
  fun bs  ->
    let rec aux s bs1 =
      match bs1 with
      | [] -> []
      | (x,imp)::tl1 ->
          let x1 =
            let uu___144_3361 = x in
            let uu____3362 = subst s x.FStar_Syntax_Syntax.sort in
            {
              FStar_Syntax_Syntax.ppname =
                (uu___144_3361.FStar_Syntax_Syntax.ppname);
              FStar_Syntax_Syntax.index =
                (uu___144_3361.FStar_Syntax_Syntax.index);
              FStar_Syntax_Syntax.sort = uu____3362
            } in
          let s' =
            let uu____3367 = shift_subst (Prims.parse_int "1") s in
            (FStar_Syntax_Syntax.NM (x1, (Prims.parse_int "0"))) ::
              uu____3367 in
          let uu____3369 = aux s' tl1 in (x1, imp) :: uu____3369 in
    aux [] bs
let close_lcomp:
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.lcomp -> FStar_Syntax_Syntax.lcomp
  =
  fun bs  ->
    fun lc  ->
      let s = closing_subst bs in
      let uu___145_3385 = lc in
      let uu____3386 = subst s lc.FStar_Syntax_Syntax.res_typ in
      {
        FStar_Syntax_Syntax.eff_name =
          (uu___145_3385.FStar_Syntax_Syntax.eff_name);
        FStar_Syntax_Syntax.res_typ = uu____3386;
        FStar_Syntax_Syntax.cflags =
          (uu___145_3385.FStar_Syntax_Syntax.cflags);
        FStar_Syntax_Syntax.comp =
          (fun uu____3389  ->
             let uu____3390 = lc.FStar_Syntax_Syntax.comp () in
             subst_comp s uu____3390)
      }
let close_pat:
  (FStar_Syntax_Syntax.pat',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.withinfo_t ->
    ((FStar_Syntax_Syntax.pat',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.withinfo_t* FStar_Syntax_Syntax.subst_elt
      Prims.list)
  =
  fun p  ->
    let rec aux sub1 p1 =
      match p1.FStar_Syntax_Syntax.v with
      | FStar_Syntax_Syntax.Pat_constant uu____3427 -> (p1, sub1)
      | FStar_Syntax_Syntax.Pat_cons (fv,pats) ->
          let uu____3443 =
            FStar_All.pipe_right pats
              (FStar_List.fold_left
                 (fun uu____3477  ->
                    fun uu____3478  ->
                      match (uu____3477, uu____3478) with
                      | ((pats1,sub2),(p2,imp)) ->
                          let uu____3543 = aux sub2 p2 in
                          (match uu____3543 with
                           | (p3,sub3) -> (((p3, imp) :: pats1), sub3)))
                 ([], sub1)) in
          (match uu____3443 with
           | (pats1,sub2) ->
               ((let uu___146_3609 = p1 in
                 {
                   FStar_Syntax_Syntax.v =
                     (FStar_Syntax_Syntax.Pat_cons
                        (fv, (FStar_List.rev pats1)));
                   FStar_Syntax_Syntax.ty =
                     (uu___146_3609.FStar_Syntax_Syntax.ty);
                   FStar_Syntax_Syntax.p =
                     (uu___146_3609.FStar_Syntax_Syntax.p)
                 }), sub2))
      | FStar_Syntax_Syntax.Pat_var x ->
          let x1 =
            let uu___147_3623 = x in
            let uu____3624 = subst sub1 x.FStar_Syntax_Syntax.sort in
            {
              FStar_Syntax_Syntax.ppname =
                (uu___147_3623.FStar_Syntax_Syntax.ppname);
              FStar_Syntax_Syntax.index =
                (uu___147_3623.FStar_Syntax_Syntax.index);
              FStar_Syntax_Syntax.sort = uu____3624
            } in
          let sub2 =
            let uu____3629 = shift_subst (Prims.parse_int "1") sub1 in
            (FStar_Syntax_Syntax.NM (x1, (Prims.parse_int "0"))) ::
              uu____3629 in
          ((let uu___148_3634 = p1 in
            {
              FStar_Syntax_Syntax.v = (FStar_Syntax_Syntax.Pat_var x1);
              FStar_Syntax_Syntax.ty = (uu___148_3634.FStar_Syntax_Syntax.ty);
              FStar_Syntax_Syntax.p = (uu___148_3634.FStar_Syntax_Syntax.p)
            }), sub2)
      | FStar_Syntax_Syntax.Pat_wild x ->
          let x1 =
            let uu___149_3639 = x in
            let uu____3640 = subst sub1 x.FStar_Syntax_Syntax.sort in
            {
              FStar_Syntax_Syntax.ppname =
                (uu___149_3639.FStar_Syntax_Syntax.ppname);
              FStar_Syntax_Syntax.index =
                (uu___149_3639.FStar_Syntax_Syntax.index);
              FStar_Syntax_Syntax.sort = uu____3640
            } in
          let sub2 =
            let uu____3645 = shift_subst (Prims.parse_int "1") sub1 in
            (FStar_Syntax_Syntax.NM (x1, (Prims.parse_int "0"))) ::
              uu____3645 in
          ((let uu___150_3650 = p1 in
            {
              FStar_Syntax_Syntax.v = (FStar_Syntax_Syntax.Pat_wild x1);
              FStar_Syntax_Syntax.ty = (uu___150_3650.FStar_Syntax_Syntax.ty);
              FStar_Syntax_Syntax.p = (uu___150_3650.FStar_Syntax_Syntax.p)
            }), sub2)
      | FStar_Syntax_Syntax.Pat_dot_term (x,t0) ->
          let x1 =
            let uu___151_3660 = x in
            let uu____3661 = subst sub1 x.FStar_Syntax_Syntax.sort in
            {
              FStar_Syntax_Syntax.ppname =
                (uu___151_3660.FStar_Syntax_Syntax.ppname);
              FStar_Syntax_Syntax.index =
                (uu___151_3660.FStar_Syntax_Syntax.index);
              FStar_Syntax_Syntax.sort = uu____3661
            } in
          let t01 = subst sub1 t0 in
          ((let uu___152_3668 = p1 in
            {
              FStar_Syntax_Syntax.v =
                (FStar_Syntax_Syntax.Pat_dot_term (x1, t01));
              FStar_Syntax_Syntax.ty = (uu___152_3668.FStar_Syntax_Syntax.ty);
              FStar_Syntax_Syntax.p = (uu___152_3668.FStar_Syntax_Syntax.p)
            }), sub1) in
    aux [] p
let close_branch: FStar_Syntax_Syntax.branch -> FStar_Syntax_Syntax.branch =
  fun uu____3674  ->
    match uu____3674 with
    | (p,wopt,e) ->
        let uu____3692 = close_pat p in
        (match uu____3692 with
         | (p1,closing) ->
             let wopt1 =
               match wopt with
               | None  -> None
               | Some w ->
                   let uu____3716 = subst closing w in Some uu____3716 in
             let e1 = subst closing e in (p1, wopt1, e1))
let univ_var_opening:
  FStar_Syntax_Syntax.univ_names ->
    (FStar_Syntax_Syntax.subst_elt Prims.list* FStar_Syntax_Syntax.univ_name
      Prims.list)
  =
  fun us  ->
    let n1 = (FStar_List.length us) - (Prims.parse_int "1") in
    let uu____3736 =
      let uu____3741 =
        FStar_All.pipe_right us
          (FStar_List.mapi
             (fun i  ->
                fun u  ->
                  let u' =
                    FStar_Syntax_Syntax.new_univ_name
                      (Some (u.FStar_Ident.idRange)) in
                  ((FStar_Syntax_Syntax.UN
                      ((n1 - i), (FStar_Syntax_Syntax.U_name u'))), u'))) in
      FStar_All.pipe_right uu____3741 FStar_List.unzip in
    match uu____3736 with | (s,us') -> (s, us')
let open_univ_vars:
  FStar_Syntax_Syntax.univ_names ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.univ_names* FStar_Syntax_Syntax.term)
  =
  fun us  ->
    fun t  ->
      let uu____3784 = univ_var_opening us in
      match uu____3784 with | (s,us') -> let t1 = subst s t in (us', t1)
let open_univ_vars_comp:
  FStar_Syntax_Syntax.univ_names ->
    FStar_Syntax_Syntax.comp ->
      (FStar_Syntax_Syntax.univ_names* FStar_Syntax_Syntax.comp)
  =
  fun us  ->
    fun c  ->
      let uu____3811 = univ_var_opening us in
      match uu____3811 with
      | (s,us') -> let uu____3824 = subst_comp s c in (us', uu____3824)
let close_univ_vars:
  FStar_Syntax_Syntax.univ_names ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  =
  fun us  ->
    fun t  ->
      let n1 = (FStar_List.length us) - (Prims.parse_int "1") in
      let s =
        FStar_All.pipe_right us
          (FStar_List.mapi
             (fun i  -> fun u  -> FStar_Syntax_Syntax.UD (u, (n1 - i)))) in
      subst s t
let close_univ_vars_comp:
  FStar_Syntax_Syntax.univ_names ->
    FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.comp
  =
  fun us  ->
    fun c  ->
      let n1 = (FStar_List.length us) - (Prims.parse_int "1") in
      let s =
        FStar_All.pipe_right us
          (FStar_List.mapi
             (fun i  -> fun u  -> FStar_Syntax_Syntax.UD (u, (n1 - i)))) in
      subst_comp s c
let open_let_rec:
  FStar_Syntax_Syntax.letbinding Prims.list ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.letbinding Prims.list* FStar_Syntax_Syntax.term)
  =
  fun lbs  ->
    fun t  ->
      let uu____3879 = FStar_Syntax_Syntax.is_top_level lbs in
      if uu____3879
      then (lbs, t)
      else
        (let uu____3885 =
           FStar_List.fold_right
             (fun lb  ->
                fun uu____3897  ->
                  match uu____3897 with
                  | (i,lbs1,out) ->
                      let x =
                        let uu____3916 =
                          FStar_Util.left lb.FStar_Syntax_Syntax.lbname in
                        FStar_Syntax_Syntax.freshen_bv uu____3916 in
                      ((i + (Prims.parse_int "1")),
                        ((let uu___153_3919 = lb in
                          {
                            FStar_Syntax_Syntax.lbname = (FStar_Util.Inl x);
                            FStar_Syntax_Syntax.lbunivs =
                              (uu___153_3919.FStar_Syntax_Syntax.lbunivs);
                            FStar_Syntax_Syntax.lbtyp =
                              (uu___153_3919.FStar_Syntax_Syntax.lbtyp);
                            FStar_Syntax_Syntax.lbeff =
                              (uu___153_3919.FStar_Syntax_Syntax.lbeff);
                            FStar_Syntax_Syntax.lbdef =
                              (uu___153_3919.FStar_Syntax_Syntax.lbdef)
                          }) :: lbs1), ((FStar_Syntax_Syntax.DB (i, x)) ::
                        out))) lbs ((Prims.parse_int "0"), [], []) in
         match uu____3885 with
         | (n_let_recs,lbs1,let_rec_opening) ->
             let lbs2 =
               FStar_All.pipe_right lbs1
                 (FStar_List.map
                    (fun lb  ->
                       let uu____3937 =
                         FStar_List.fold_right
                           (fun u  ->
                              fun uu____3949  ->
                                match uu____3949 with
                                | (i,us,out) ->
                                    let u1 =
                                      FStar_Syntax_Syntax.new_univ_name None in
                                    ((i + (Prims.parse_int "1")), (u1 :: us),
                                      ((FStar_Syntax_Syntax.UN
                                          (i,
                                            (FStar_Syntax_Syntax.U_name u1)))
                                      :: out)))
                           lb.FStar_Syntax_Syntax.lbunivs
                           (n_let_recs, [], let_rec_opening) in
                       match uu____3937 with
                       | (uu____3972,us,u_let_rec_opening) ->
                           let uu___154_3979 = lb in
                           let uu____3980 =
                             subst u_let_rec_opening
                               lb.FStar_Syntax_Syntax.lbdef in
                           {
                             FStar_Syntax_Syntax.lbname =
                               (uu___154_3979.FStar_Syntax_Syntax.lbname);
                             FStar_Syntax_Syntax.lbunivs = us;
                             FStar_Syntax_Syntax.lbtyp =
                               (uu___154_3979.FStar_Syntax_Syntax.lbtyp);
                             FStar_Syntax_Syntax.lbeff =
                               (uu___154_3979.FStar_Syntax_Syntax.lbeff);
                             FStar_Syntax_Syntax.lbdef = uu____3980
                           })) in
             let t1 = subst let_rec_opening t in (lbs2, t1))
let close_let_rec:
  FStar_Syntax_Syntax.letbinding Prims.list ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.letbinding Prims.list* FStar_Syntax_Syntax.term)
  =
  fun lbs  ->
    fun t  ->
      let uu____3998 = FStar_Syntax_Syntax.is_top_level lbs in
      if uu____3998
      then (lbs, t)
      else
        (let uu____4004 =
           FStar_List.fold_right
             (fun lb  ->
                fun uu____4012  ->
                  match uu____4012 with
                  | (i,out) ->
                      let uu____4023 =
                        let uu____4025 =
                          let uu____4026 =
                            let uu____4029 =
                              FStar_Util.left lb.FStar_Syntax_Syntax.lbname in
                            (uu____4029, i) in
                          FStar_Syntax_Syntax.NM uu____4026 in
                        uu____4025 :: out in
                      ((i + (Prims.parse_int "1")), uu____4023)) lbs
             ((Prims.parse_int "0"), []) in
         match uu____4004 with
         | (n_let_recs,let_rec_closing) ->
             let lbs1 =
               FStar_All.pipe_right lbs
                 (FStar_List.map
                    (fun lb  ->
                       let uu____4044 =
                         FStar_List.fold_right
                           (fun u  ->
                              fun uu____4052  ->
                                match uu____4052 with
                                | (i,out) ->
                                    ((i + (Prims.parse_int "1")),
                                      ((FStar_Syntax_Syntax.UD (u, i)) ::
                                      out))) lb.FStar_Syntax_Syntax.lbunivs
                           (n_let_recs, let_rec_closing) in
                       match uu____4044 with
                       | (uu____4065,u_let_rec_closing) ->
                           let uu___155_4069 = lb in
                           let uu____4070 =
                             subst u_let_rec_closing
                               lb.FStar_Syntax_Syntax.lbdef in
                           {
                             FStar_Syntax_Syntax.lbname =
                               (uu___155_4069.FStar_Syntax_Syntax.lbname);
                             FStar_Syntax_Syntax.lbunivs =
                               (uu___155_4069.FStar_Syntax_Syntax.lbunivs);
                             FStar_Syntax_Syntax.lbtyp =
                               (uu___155_4069.FStar_Syntax_Syntax.lbtyp);
                             FStar_Syntax_Syntax.lbeff =
                               (uu___155_4069.FStar_Syntax_Syntax.lbeff);
                             FStar_Syntax_Syntax.lbdef = uu____4070
                           })) in
             let t1 = subst let_rec_closing t in (lbs1, t1))
let close_tscheme:
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.tscheme ->
      (FStar_Syntax_Syntax.univ_name Prims.list* FStar_Syntax_Syntax.term)
  =
  fun binders  ->
    fun uu____4082  ->
      match uu____4082 with
      | (us,t) ->
          let n1 = (FStar_List.length binders) - (Prims.parse_int "1") in
          let k = FStar_List.length us in
          let s =
            FStar_List.mapi
              (fun i  ->
                 fun uu____4104  ->
                   match uu____4104 with
                   | (x,uu____4108) ->
                       FStar_Syntax_Syntax.NM (x, (k + (n1 - i)))) binders in
          let t1 = subst s t in (us, t1)
let close_univ_vars_tscheme:
  FStar_Syntax_Syntax.univ_names ->
    FStar_Syntax_Syntax.tscheme ->
      (FStar_Syntax_Syntax.univ_name Prims.list* FStar_Syntax_Syntax.term)
  =
  fun us  ->
    fun uu____4124  ->
      match uu____4124 with
      | (us',t) ->
          let n1 = (FStar_List.length us) - (Prims.parse_int "1") in
          let k = FStar_List.length us' in
          let s =
            FStar_List.mapi
              (fun i  -> fun x  -> FStar_Syntax_Syntax.UD (x, (k + (n1 - i))))
              us in
          let uu____4149 = subst s t in (us', uu____4149)
let opening_of_binders:
  FStar_Syntax_Syntax.binders -> FStar_Syntax_Syntax.subst_elt Prims.list =
  fun bs  ->
    let n1 = (FStar_List.length bs) - (Prims.parse_int "1") in
    FStar_All.pipe_right bs
      (FStar_List.mapi
         (fun i  ->
            fun uu____4168  ->
              match uu____4168 with
              | (x,uu____4172) -> FStar_Syntax_Syntax.DB ((n1 - i), x)))