/*****************************************************************************/
/* zusomaino.p SALES ORDER MAINTENANCE                                       */
/*****************************************************************************/
/* 08-01-2019 INC06942 Strange Message "emt-maint"                            */
/* 04-04-2019 - somanatp INC07755                                             */
/*        to replace  small order  percent for netherland from 6% to  9%      */
/* 17-04-2019 - somanatp UATEIV1                                             */
/*        To restrict the CUP update for sample orders                       */
/* 25-05-2019 - somanatp   8980                                              */
/* 18-04-2019 - MP: MLQ-00060, Remove old checks for status 4 and update the */
/*                             status handling so status 3&4 are equal to 5  */
/*         7.9.14 negative qty entry and const-ld consign order issue        */
/* 29-05-2019 - somanatp   8181                                              */
/*        Delete so_mstr records fix                                         */
/* 08/07/2019    bhujbaln  8494                                               */
/*               Fix to display freight charges on SO confirmation            */
/*        Delete so_mstr records fix                                          */
/* 08/30/2019    bhujbaln  INC09115                                           */
/*               To allow credit notes in 99.7.1.1                            */
/* 04/03/2020    bhujbaln RFC-2038                                            */
/*               Avoid non-relevant order changes                             */
/*                 to re-trigger restriction/editblock                        */
/* 30/03/2020    somanatp RFC2142                                             */
/*               Quota management                                             */
/* 08/06/2020    somanatp 14642                                               */
/*               Allocation should be zero if there is block                  */
/* 15/07/2020    pipadas INC16800                                             */
/*               Removed deletion of xxblck_det at the beginning of every line */
/* 09/09/2020    bindoor INC18061                                             */
/*               Changed contact GMB for costing error                        */
/* 22/10/2020    bhujbaln RFC-2014                                            */
/*               PAO & SPT Items Due date calculation                         */ 
/* 04/01/21  somanatp   RFC2364  Quota By Country                             */
/* 17/02/2021    maryc MEDPLAN                                                */
/*               Modified to bring the Warehouse site as per MEDPLAN          */
/* 17/02/2021    maryc RFC-2495                                               */
/*               To enhance the validation in the Project code                */
/* 17/02/2021    maryc RFC-2295                                               */
/*               To bring "HARDWAR" Project code for the hardware items       */
/* 02/03/2021    maryc RFC-2577                                               */
/*               To bring pricelist value for HARDWAR items                   */
/* 04/07/2021    somanatp RFC1952                                             */
/*               for reprice chaging the chr02 has manual                     */
/* 12/07/2021    somanatp RFC26474                                            */
/*               for restricting grouping customers                           */
/* 27/07/21      pipadas INC20959                                             */
/*               Site retention for dropship ordes                            */
/* 17/08/21      somanatp RFC2556                                             */
/*               Site retention for dropship ordes                            */
/* 15/11/2021    maryc    RFC-2587                                            */
/*               To set PPL no for Zero Price items                           */
/* 15/03/22      pipadas  RFC-2889                                            */
/*               Fixed the auto discount applying logic for consign orders    */
/* 12/04/22      somanatp surcharge                                           */
/*               calculating surcharge from pricesource                       */
/* 27/05/22      maryc   RFC-2868 To send mail when PAO item Order deletes    */ 
/* 13/06/22      maryc    RFC-2524 To close open PO, when corresponding SO    */
/*                       Partially Shipped and deleted                        */
/* 24/06/22     pipadas  RFC-2934                                             */
/*              Added a few warning pop-ups for French domain                 */
/* 12/04/22      somanatp  palletd                                            */
/*               calculating surcharge from pricesource                       */
/* 14/04/22      somanatp  palletd_1                                          */
/*               calculating surcharge from pricesource                       */
/* 18/07/22      bhujbaln PMO2057 3PL changes                                 */
/* 31/08/22      somanatp INC54554 fix on surcharge consign fix               */
/* 05/09/22      somanatp  mulof       multiple of discount                    */
/* 15/09/22      pipadas  RFC-3012                                            */
/*               To display EA's prices                                       */
/* 19/09/22      pipadas RFC-3012_1                                           */
/*               Bug fix for CIG code issue                                   */
/* 22/09/22      maryc    POF2-1    To add transition WH at Country Level       */
/* 03/11/22      dchitham INC56658 Split and allocation bug fix for allocqty  */
/* 04/11/22  bhujbaln   PMO2068N  Added warehouse site for CH                 */
/* 04/11/22      bhujbaln CHN00417                                            */
/*               Don't allow allocation if block allocation flag is set       */
/* 05/12/22      bhujbaln PMO2068N-HP                                         */
/*               Deactivate 3pl wh-site if Correction Sales order             */
/* 12/12/22      pipadas  CEPS-301                                            */
/*               To capture Net price in sod__chr06                           */
/* 14/02/23      bhujbaln OT-22                                               */
/*                 To remove check of available qty on other                       */
/*                 locations when location is selected as "RESERVED"               */
/* 01/03/23      bhujbaln   WMSI-2066                                           */
/*               Due Date calculation for UK orders should not be same date as order date. */
/*               After cut-off time the order places cannot have the due date */
/*               of tomorrow as well, it will be next trip days               */
/* 28/02/23      maryc      RFC-2990                                          */
/*                      To stop creating the SC Block again during Order Qty  */
/*                      decrease and Price change After Release               */ 
/* 17/04/23      sugunak   CEPS-714                                           */
/*               Text change into the orderconformation for NL                */
/* 07/08/23      bhujbaln  PMO0009B_HP 3PL Italy                              */
/*               Remove hardcoding of "IB" orders as SAMPLES and make         */
/*               line project editable                                        */
/* 07/08/23      bhujbaln PMO0009B_HP                                         */
/*               Apply same logic as WMSI-2066 to 3pl Italy                   */
/* 10/08/23      bhujbaln OT-79                                               */
/*               Due date calculation for WMS Scale sites                     */
/* 11/08/23      bhujbaln   OT-82                                             */
/*               Remove ad_mstr record of cutoff time which checks Sales site */
/*                only for WMS Scale sites                                    */
/* 17/08/23    somanatp CEPS-850 changing cm-type to address                  */
/* 11/12/23      CHN00664 vitobap  removing mail alerts to GMB-EU-DEMAND      */
/* 12/12/23      INC72581    Added sc block validation for split line         */
/* 12/21/2023    sugunak QAD_perf_1  To remove whole-index                    */
/* 02/21/2024    vithobp CHN00830 Adding 3 days to due date for PAB1 or PAB2  */
/* 29/02/24      somanatp PCM-112 CMDM replacing with xxcm_mstr               */
/* 04/06/24      somanatp CEPS-1582 Price ID fix                              */
/* 17/06/24      CHN00826 - Make field  consume forecast as NO automatically  */
/*                          when spotorder at SO line level                   */ 
/* 18/06/24      INC90422 - Fix to correct the UM in Blocked Order table      */ 
/* 27/06/24      INC99965 vithobp Fixed lock issue for code master tables     */
/* 17/07/2024    OT-153 naikaak                                               */
/*               Mod for adding Sales UM field and integrating it with HQ SO  */   
/*               which are non EMT 3PL along with other supporting changes    */
/* 17/07/2024    OT-159 naikaak                                               */
/*               Replace hardcoding with code_mstr for WMSI-2066              */
/* 09/08/2024    CEPS-739 - CHN00585 to display surcharge lines in the        */
/*                          invoices when accounted in the net price.         */
/* 21/10/24  somanatp   OT-323                                                */
/*                      Sales Order Duedate calculation                       */
/* 02/12/2024    aakanka CHN00634                                             */
/*               ADD BG/PK AS UOM Conversion IN QAD                           */
/* 26/12/2024    somanatp FT-645                                              */
/*               HD status to be updated for maxdayscredit                    */
/* 02/02/2025    OT-379   Pharma product handling at Sales Order Entry        */
/* 02/02/2025    OT-401   Make HQ order compatible with Transition warehouse  */
/* 03/07/2025    SCQ-1369 ASID BONZ Change - New Menu                         */
/* 05/08/2025    INC115964 Fix for Decimal Order Qty                          */
/******************************************************************************/
{us/mf/mfdtitle.i "AvdV"}
{us/gp/gpuid.i}

DEFINE INPUT  PARAMETER hRunProc# AS HANDLE      NO-UNDO.
DEFINE NEW SHARED VARIABLE global-so-nbr AS CHARACTER   .         
DEFINE NEW SHARED VARIABLE global-mail-addr AS CHARACTER .
DEFINE NEW SHARED VARIABLE global-fax-nbr AS CHARACTER .
DEFINE NEW SHARED VARIABLE global-subject AS CHARACTER .
DEFINE VARIABLE ghQxtendLib# AS HANDLE      NO-UNDO.

DEFINE BUFFER cl_so_mstr FOR so_mstr.
DEFINE BUFFER cl_sod_det FOR sod_det.
DEFINE BUFFER bl_so_mstr FOR so_mstr.
DEFINE BUFFER blu_so_mstr FOR so_mstr.
define buffer pod-det     for pod_det.

DEFINE VARIABLE giLinesPerTransaction# AS INTEGER     NO-UNDO INIT 10.

DEFINE VARIABLE cErroSoPPL# AS CHARACTER   NO-UNDO INIT "".
DEFINE VARIABLE lShowSaveMessage# AS LOGICAL     NO-UNDO INIT FALSE.

DEFINE VARIABLE hLockSo#   AS HANDLE      NO-UNDO.
DEFINE VARIABLE hLockSoHq# AS HANDLE      NO-UNDO.

DEFINE VARIABLE glCIGCodeEnabled# AS LOGICAL     NO-UNDO INIT FALSE.
DEFINE VARIABLE glCUPCodeEnabled# AS LOGICAL     NO-UNDO INIT FALSE.

define variable lvc_commit as character format "x(24)" no-undo.   /*RFC-2550*/
DEFINE BUFFER soc_ctrl FOR soc_ctrl.
define variable l_split as logical init no no-undo. /* INC56658 */
/* CEPS-1582 ADD BEGINS */
define variable lv_oldlpr like sod_list_pr  no-undo.
define variable lv_olddp  like sod_disc_pc  no-undo.
define variable lv_oldpr  like sod_price    no-undo.
define variable lv_chr02  like sod__chr02   no-undo.
/* CEPS-1582 ADD ENDS */
/* OT-323 ADD BEGINS */
define variable lv_itr        as integer     no-undo.
define variable lv_nextdue    as date        no-undo.
define variable lv_ctdate     as date        no-undo.
define variable lv_count      as int         no-undo.
define variable lv_leadtime   as int         no-undo.
/* OT-323 ADD ENDS  */
define variable lv_hdstatus  as character    no-undo. /* FT-645 */
define variable l_ship_pharma like xxpt_pharmacy no-undo. /* OT-379 */

{us/zu/zuqxtmain.i}
{us/zu/zuqxtlib.i &SHARED-TT="NEW SHARED"}

    /*
      RUN SaveMedlineSO IN hProc# (INPUT-OUTPUT DATASET dsmaintainSalesOrder,
                               INPUT-OUTPUT iCallID#,
                               INPUT-OUTPUT iSeqNr#,
                               OUTPUT cErro#).
    */
    
DEFINE VARIABLE hProc# AS HANDLE      NO-UNDO.
define variable hquota as handle      no-undo. /* RFC2142 */
define variable hcrehd as handle      no-undo. /* FT-645 */

release xxqt_det. /*RFC2142 */
RUN us/zu/zumlqxlib.p PERSISTENT SET hProc#.
run us/xx/xxquoord.p persistent set hquota. /* RFC2142 */
run us/xx/xxcredhd.p persistent set hcrehd. /* FT-645 */



SUBSCRIBE TO "GET_maintainSalesOrder" ANYWHERE.
SUBSCRIBE TO "SET_maintainSalesOrder" ANYWHERE.

RUN SetPrintPPLOverRule IN hProc# (INPUT FALSE).


DEFINE VARIABLE rRowid# AS ROWID       NO-UNDO.

DEFINE VARIABLE lAllowBlocked# AS LOGICAL     NO-UNDO INIT FALSE.
DEFINE VARIABLE lNoReply# AS LOGICAL     INIT ? NO-UNDO.

DEFINE VARIABLE cErro# AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lOk#     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lWhseOk# AS LOGICAL     NO-UNDO.

DEFINE VARIABLE lContinueSave# AS LOGICAL     NO-UNDO INIT TRUE.
Define variable lvc_ctry   as char no-undo. /* RFC2364 */

  
DEFINE BUFFER bsod_det FOR sod_det.
DEFINE BUFFER bso_mstr FOR so_mstr.
DEFINE VARIABLE lErro# AS LOGICAL     NO-UNDO INIT FALSE.
DEFINE VARIABLE lSuppresSaveLine# AS LOGICAL     NO-UNDO INIT FALSE.
define variable lv_emt        as logical init false no-undo. /*SCQ-1369*/
define variable lv_temp       as logical init false no-undo. /*OT-379*/
define variable lv_gcm        as logical init false no-undo. /*OT-379*/
define variable lv_avail      as logical init false no-undo. /*OT-379*/
define variable lv_pharma     as logical init false no-undo. /*OT-379*/
define variable lv_mix        as logical init false no-undo. /*OT-379*/
define variable lv_pitem      as logical init false no-undo. /*OT-379*/
define variable lv_sod        as logical init false no-undo. /*OT-379*/

{us/zu/zusetemtdue.i}

/*CEPS-301 ADD BEGINS*/
function fn_getnetprice returns decimal(input lvd_price as decimal,
                                        input lvp_disc  as decimal,
                                        input lvp_surc  as decimal):
   define var lvd_pr1 as decimal no-undo.
   lvd_pr1 = lvd_price - (lvd_price * (lvp_disc / 100)).
   lvd_pr1 = lvd_pr1 + (lvd_pr1 * (lvp_surc / 100)).
   return lvd_pr1.
end.
/*CEPS-301 ADD ENDS*/

/*  PCM-112 ADD BEGINS */
function fn_get_ordconf returns char(input lv_domain as character,
                                     input lv_cust   as character,
                                     input lv_val    as character ):
  
   for first xxcm_mstr no-lock  
      where xxcm_domain = lv_domain
        and xxcm_addr   = lv_cust:
   end. /* FOR FIRST xxcm_mstr */
   if available xxcm_mstr  
      and lv_val = "chn"
   then
      return substr(xxcm_ordrconf,1,1)  .    
   else if available xxcm_mstr 
      and lv_val = "mail"
   then do:
      if xxcm_ordrconf begins "e" 
      then do:
         global-mail-addr = xxcm_mailaddr.
		 return global-mail-addr.
	  end. /* IF xxcm_ordrconf BEGINS "e"*/
      else if xxcm_ordrconf begins "f" 
      then do:
         global-fax-nbr = xxcm_mailaddr.
		 return global-fax-nbr.
	  end. /* ELSE IF xxcm_ordrconf */
   end.  /*  ELSE IF AVAILABLE xxcm_mstr */ 
                                        
end.  /* FUNCTION fn_get_ordconf */
/*  PCM-112 ADD ENDS   */   
 
FUNCTION fGetSodQtyInv RETURNS DECIMAL (INPUT sod_domain# AS CHAR,
                                        INPUT sod_nbr#    AS CHAR,
                                        INPUT sod_line#   AS INT) IN hProc#.  
    
/*INC20959 ADD BEGINS*/
function getsitecorporategroup returns logical (input cdomain as character,
                                                input csite as character,
                                                input cgroup as character): 
define variable itlr       as integer   no-undo.
define variable igroupcode as integer   no-undo. 
define variable cgroupname as character no-undo.
                                                                               
do itlr = 1 to num-entries(cgroup):                                            
   find first corporategroup no-lock where corporategroupdescription = entry(itlr,cgroup) no-error.   
   if available corporategroup then                                              
      assign cgroupname = if cgroupname = "" then string(corporategroup.corporategroup_id,"99999999999")                     
                          else cgroupname + "," + string(corporategroup.corporategroup_id,"99999999999"). 
end.
find first ad_mstr no-lock where ad_domain = cdomain               
                             and ad_addr   = csite  no-error.
   if available ad_mstr 
   then do:   
      find first businessrelation where businessrelation.businessrelationcode = ad_mstr.ad_bus_relation 
                                    and businessrelation.businessrelationisactive = yes no-lock no-error.                   
      if available businessrelation then
         assign igroupcode = businessrelation.corporategroup_id.
      else 
         assign igroupcode = 0.
      return can-do(cgroupname,string(igroupcode,"99999999999")).
   end. /* if available ad_mstr */
   else
      return false. 
end. /*function getsitecorporategroup returns logical*/
/*INC20959 ADD ENDS*/    

def temp-table cons-ld
    field cons-line like sod_det.sod_line
    field cons-part like pt_mstr.pt_part
    field cons-lot like ld_lot
    field cons-ref like ld_ref
    field cons-shipnr as char
    field cons-shipdt as date
    field cons-qty-oh like ld_qty_oh
    field cons-qty-all like ld_qty_all
    field cons-updated as logical
    field cons-sod-line like sod_det.sod_line
    field cons-site like sod_det.sod_site
    index cons-line is primary is unique
    cons-line.

def temp-table suse-list
    field suse-part like pt_mstr.pt_part
    field suse-avl as dec
    field suse-um like sod_det.sod_um
    field suse-conv like um_conv
    field suse-price like pid_amt
    field suse-curr like so_mstr.so_curr
    index suse-part is primary is unique
    suse-part. 

def temp-table price-list
    field price-lst as char
    field price-code as char
    field price-cnt as int
    field price-date as date
    field price-end as date
    field price-curr as char
    field price-um as char
    field price-qty as int
    field price-amt as dec
    index price-key is primary is unique
    price-lst
    price-code
    price-cnt.

def temp-table addr-list
    field id as int
    field name as char
    field addr as char
    field zip as char
    field city as char
    index id is primary is unique
    id
    index name
    name addr.

def buffer cm-bt for cm_mstr.
def buffer somstr for so_mstr.
def buffer emtsom for so_mstr.
def buffer emtsomTmp for so_mstr.
def buffer emtsod for sod_det.
def buffer prl for xxprl_mstr.
def buffer prld for xxprld_det.

def new shared var cmtindx like so_mstr.so_cmtindx.
def new shared var podnbr  like pod_det.pod_nbr.
def new shared var podline like pod_det.pod_line.
def new shared var blanket like mfc_logical.
def new shared var qty_ord like pod_det.pod_qty_ord.
def new shared var del-yn  like mfc_logical.
def new shared var shipctry like ad_mstr.ad_ctry.

/*
DEFINE VARIABLE lKeepPrintPl# AS LOGICAL     INIT  ? NO-UNDO.
DEFINE VARIABLE csonbrOld# AS CHARACTER   NO-UNDO INIT "".
*/

def var emt-maint        as logical init false no-undo.

def var time-out         as int init 600 no-undo.
def var domain           as char no-undo.
def var sonbr          like so_mstr.so_nbr no-undo.
def var tmpsonbr          like so_mstr.so_nbr no-undo.
def var sosite           as char no-undo.
def var so-nbr         like so_mstr.so_nbr no-undo.
def var prom-date        as date no-undo.
def var next-due         as date no-undo.
def var so-curr        like so_mstr.so_curr no-undo.
def var sls-rep          as logical no-undo.
def var cm-type          as char no-undo.
def var cust-restr       as logical no-undo.
def var msg-txt          as char no-undo.
def var pr-txt           as char no-undo.
def var tr-txt           as char no-undo.
def var last-index     like xxprl_list_id no-undo.
def var sodstat          as char no-undo.
def var ordr-line      like sod_det.sod_line no-undo.
def var consi-line     like sod_det.sod_line no-undo.
def var so-cmmts       like soc_hcmmts no-undo.
def var sod-cmmts      like soc_lcmmts no-undo.
def var sod-lcmmts       as logical no-undo.
def var wh-site          as char no-undo.
def var wh-domain        as char no-undo.
def var wh-suppl         as char no-undo.
def var consume        like sod_det.sod_consume no-undo.
def var old-consume    like sod_det.sod_consume no-undo.
def var new-order        as logical initial no no-undo.
def var new-line         as logical no-undo.
def var reprice        like mfc_logical initial no no-undo.
def var ret-err          as logical no-undo.
def var av-test          as logical no-undo.
def var list-id        like xxprl_list_id no-undo.
def var new-ordr-amt     as dec no-undo.
def var err-code         as int no-undo.
def var yr               as int no-undo.
def var wk               as int no-undo.
def var yrwk             as int no-undo.
def var field-acc        as logical extent 27 initial no no-undo.
def var site-ctry        as char no-undo.
def var ship-ctry        as char no-undo.
def var sh2-pst        like ad_mstr.ad_pst_id no-undo.
def var line-amt         as dec no-undo.
def var line-tot       like so_mstr.so_trl1_amt no-undo.
def var vat-amt        like so_mstr.so_trl1_amt no-undo.
def var vat-pct        like tx2_tax_pct no-undo.
def var vat-pcth       like tx2_tax_pct no-undo.
def var vat-pctl       like tx2_tax_pct no-undo.
def var total-amt      like so_mstr.so_trl1_amt no-undo.
def var tax-date         as date no-undo.
def var counter          as int no-undo.
def var txt              as char no-undo.
def var cp-part          as char no-undo.
DEF VAR ynlog            like mfc_logical INIT NO.
def var yn               as char format "X" no-undo.
def var y-n              as logical no-undo.
def var emt-ordr         as logical no-undo.
def var old-domain       as char no-undo.
def var old-soldto       as char no-undo.
def var old-billto       as char no-undo.
def var old-shipto       as char no-undo.
def var old-print-pl     as logical no-undo.
def var old-proj         as char no-undo.
def var old-stat         as char no-undo.
def var old-price        as dec no-undo.
def var old-ord-qty      as dec no-undo.
def var old-qty-ord      as dec no-undo.
def var old-qty-all      as dec no-undo.
def var old-due-date     as date no-undo.
def var old-sod-type     as char no-undo.
def var old-discount     as dec no-undo.
def var qty-ord-cs       as dec no-undo.
def var qty-all          as dec no-undo.
def var qty-avl          as dec no-undo.
def var qty-avl-pl       as dec no-undo.
def var qty-normal       as dec no-undo.
def var qty-sample       as dec no-undo.
def var qty-fcst1        as dec no-undo.
def var qty-fcst2        as dec no-undo.
def var cpl-nbr          as char no-undo.
def var cpl-fail         as char no-undo.
def var sod-um-ok        as logical no-undo.
def var sod-qty-ok       as logical no-undo.
def var um-conv        like um_mstr.um_conv no-undo.
def var save-part        as char no-undo.
def var old-prod-line    as char no-undo.
def var list-pr          as dec no-undo.
def var net-price        as dec no-undo.
def var show-mess        as logical no-undo.
def var usr-groups       as char no-undo.
def var min-pr-grp       as logical init no no-undo.
def var cs-manager       as logical init no no-undo.
def var print-conf       as logical no-undo.
def var conf-prntr       as char initial "page" no-undo.
def var old-conf-pr      as char initial "page" no-undo.
def var descr            as char format "X(32)" extent 3 no-undo.
def var acct-cc          as char no-undo.
def var bom-id           as char no-undo.
def var bom-qty          as int no-undo.
def var bom-price        as dec no-undo.
def var suse-item        as char no-undo.
def var suse-rRowid#       as rowid no-undo.
def var mail-from        as char no-undo.
def var mail-to          as char no-undo.
def var fax-nbr          as char no-undo.
def var fax-attn         as char no-undo.
def var pallets          as dec no-undo.
def var lot-nbr          as char no-undo.
def var lot-yn           as logical no-undo.
def var tax-in           as logical no-undo.
def var i                as int no-undo.
def var server-id        as char no-undo.
def var intf-dir         as char no-undo.
def var l-cust-ctry-consume as log no-undo.
def var old-aims         as char no-undo.
def var new-aims         as char no-undo.
def var ware-houses      as char no-undo.
def var compl-nbr      like xxcpl_nbr no-undo.
def var ct_description   as char no-undo.
def var corr-code        as char no-undo.
def var corr-reason      as char format "x(30)" no-undo.
def var billto-id        as int no-undo.
def var err-stat         as char no-undo.
def var cm-user1       like cm_user1 no-undo.
def var lv_name        like ad_mstr.ad_name no-undo.  /*13848*/
def var send-mail        as logical no-undo.
def var mail-address     as char no-undo.
define variable l_timfe as char no-undo.  /* 1407 */
define variable lv_Address  like ad_mstr.ad_line1 . /* 7934 */
DEFINE VARIABLE dumd1# AS DATE        NO-UNDO.
DEFINE VARIABLE dumd2# AS DATE        NO-UNDO.
/* 7747 ADD BEGINS */
define variable lv_Addr  like ad_mstr.ad_line1  no-undo.
define variable l_bmail  like code_cmmt no-undo.
/* 7747 ADD ENDS */
/* 8680 ADD BEGINS */
define variable l_edblval as logical no-undo.  
define variable l_cnt     as integer no-undo.
define variable l_blty    as character no-undo init "Editblock,Restriction".
DEFINE VARIABLE l_bl_list AS CHARACTER   NO-UNDO.
/* 8680 ADD ENDS */

define variable linectr   as integer no-undo. /*7884*/
define variable bulkalloc as logical no-undo. /*7884*/
/* 2453 ADD BEGINS  */
define variable l_duedt like ds_due_date no-undo.
define variable l_duedt2 like ds_due_date no-undo.
define variable itd       as  integer     no-undo.
/* 2453 ADD ENDS  */
define variable l_vat    like tx2_tax_pct no-undo. /*RFC508*/  
define variable l_flg    as logical no-undo  init no. /*RFC531*/
define variable l_flag    as logical no-undo  init no. /*8181*/    

/* RFC2142 ADD BEGINS */
define variable l_quota     like  sod_qty_ord     no-undo. 
define variable l_qutflg    as    logical         no-undo.
define variable l_qutitm    as    logical         no-undo.
define variable l_bfqty     like  sod_qty_ord     no-undo.
define variable l_qtyall    like  sod_qty_all     no-undo.
define variable l_nqline    as    logical init no no-undo.
define variable l_nbline    as    logical init no no-undo.
define variable l_nqoqty    like  sod_qty_ord     no-undo.
define variable l_qu        like  sod_qty_ord     no-undo.
define variable l_qtblck    as    log  no-undo.
define variable l_nblck     as    log  no-undo.
define variable l_start     as    date extent 2.
define variable l_end       as    date extent 2.
define variable l_itr       as    int             no-undo.
define variable l_duequo    as    date            no-undo.
define variable l_qutblcqty like  xxblck_qty_ord.
define variable l_blckquchk as    log             no-undo.
define variable l_oldblqty  like  sod_qty_ord     no-undo.
define variable l_nquo      as    log             no-undo.
define variable l_due_date  as    date            no-undo.
define variable l_pao       as    date            no-undo.
define variable l_oldper    as    date            no-undo.
define variable l_compare   as    char            no-undo.
define variable l_cmpflg    as    log             no-undo.
/* RFC2142 ADD ENDS */
DEFINE VARIABLE cNetPrice   AS DECIMAL  NO-UNDO. 
DEFINE VARIABLE iPriceID    AS INTEGER  NO-UNDO.
DEFINE VARIABLE iDiscountID AS INTEGER  NO-UNDO.
DEFINE VARIABLE iRebateID   AS INTEGER  NO-UNDO.
Define variable li_surcper  as decimal  No-undo. /* surcharge */         
Define variable li_upr      as decimal  No-undo. /* RFC-3012 */        
DEFINE VARIABLE lRollBack AS LOG NO-UNDO. 
DEFINE VARIABLE lOk       AS LOG NO-UNDO. 
DEFINE VARIABLE cError    AS CHARACTER NO-UNDO.
define variable ll_group  as logical no-undo. /* RFC26474 */
/*INC20959 ADD BEGINS*/
define variable lvl_s1  as logical   no-undo.  
define variable lvc_grp as character no-undo.
define variable lvl_p1  as logical   no-undo.
/*INC20959 ADD ENDS*/
/* RFC2556 ADD BEGINS */
define variable li_linenbr as integer no-undo.
define variable lv_bc      as log no-undo.
/* RFC2556 ADD ENDS */

define  variable ld_oldsur  as decimal  no-undo. /* surcharge */
define variable lvl_pao    as logical no-undo.   /*RFC-2868*/

define variable res_qtyavl  as dec no-undo. /*PMO2057*/
define variable wh-loc like sod_loc no-undo. /*PMO2057*/
define variable lv_loc like sod_loc no-undo. /*PMO2057*/
define variable l-3pl  as   logical no-undo. /*PMO2057*/
define variable l-all as logical no-undo.    /*CHN00417*/
define variable l-cut-off as logical no-undo. /*OT-79*/
define variable lv_mail_to as character no-undo. /*CHN00664*/
define variable lvi_dueDays as integer no-undo. /*CHN00830*/
define variable lvc_prjcodes as character no-undo. /*CHN00826*/
/* OT-153 START ADDITION */
define variable lvi_salesUMQty like sod_det.sod_qty_ord init 0    no-undo.
define variable lvc_salesUM    like sod_det.sod_um      init "CS" no-undo.
define variable lvc_oldSalesUM like sod_det.sod_um                no-undo.

define variable lvl_nonEMT3PL       as logical init no  no-undo. 
define variable lvl_isValidSalesUM  as logical init yes no-undo.
define variable lvc_dispMsg         as character no-undo.
/* OT-153 END ADDITION */
define variable lvc_scale_sites as character no-undo. /* OT-159 */
define variable lvc_umiu        like code_value initial "" no-undo. /* INC115964 */

  lvl_pao = no.     /*RFC-2868*/

lRollBack = NOT CAN-FIND(FIRST code_mstr NO-LOCK WHERE code_domain = "XX" AND code_fldname = "New pricing" AND code_value = "pricing"). 

run "av/avident.p" (output server-id, output intf-dir).

{us/aw/awtrip.i}


{us/wa/waapiprc.i}
function fn_addr_blocked returns log
  (input ip_domain as char,input ip_addr as char,input ip_trans as char):
  find cm_mstr no-lock where cm_domain = ip_domain
                         and cm_addr = ip_addr no-error.
  if not avail cm_mstr then return no.

  for each btrd_det no-lock where btrd_det.oid_btr_mstr = cm_mstr.oid_btr_mstr,
    first lngd_det of btrd_det no-lock:
    if lngd_key2 = ip_trans then return yes.
  end.
  return no. /* no block found */
end.

/* OT-153 START ADDITION */
FUNCTION fn_isSalesOrdNonEmt3PL returns logical
  (input ip_domain as character,
   input ip_emtSOField as character,
   input ip_soSite as character):
   
   define variable lvl_returnValue as logical init false no-undo.
   
   if ip_domain = "HQ"
     and ip_emtSOField = "avsodmnt.p"
   then do:
      run "xx/xx3plchk.p" (ip_soSite,
                           output lvl_returnValue).
   end.
   else
      lvl_returnValue = false.
   
   return lvl_returnValue.
   
END FUNCTION. /* function fn_isSalesOrdNonEmt3PL */

FUNCTION fn_getUMConv returns decimal
  (input ip_domain as character,
   input ip_soPart as character,
   input ip_um as character):
   
   define variable lvd_returnValue as decimal no-undo.
   
   lvd_returnValue = 1.
   
   for first pt_mstr
      where pt_domain = ip_domain
        and pt_part   = ip_soPart
   no-lock:
      
      for first um_mstr
         where um_domain = ip_domain
           and um_um     = pt_um
           and um_alt_um = ip_um
           and um_part   = ip_soPart
      no-lock:
         
         lvd_returnValue = um_conv.
      end.
   end.
   
   return lvd_returnValue. 
END FUNCTION. /* function fn_getUMConv */

FUNCTION fn_getQtyRndByUMConv returns decimal
  (input ip_qty as decimal,
   input ip_um_conv as decimal):
   
   define variable lvd_returnValue as decimal no-undo.
   
   lvd_returnValue = truncate(ip_qty / ip_um_conv, 0).
   lvd_returnValue = max(0, lvd_returnValue) * ip_um_conv.
   
   return lvd_returnValue. 
END FUNCTION. /* function fn_getQtyRndByUMConv */

FUNCTION fn_isValidQtyAllocByUMConv returns logical
  (input ip_domain as character,
   input ip_soPart as character,
   input ip_um as character,
   input ip_qtyAlloc as decimal,
   output op_um_conv as decimal):
   
   define variable lvl_returnValue as logical init true no-undo.
   
   op_um_conv = 1.
   
   for first pt_mstr
      where pt_domain = ip_domain
        and pt_part   = ip_soPart
   no-lock:
      
      for first um_mstr
         where um_domain = ip_domain
           and um_um     = pt_um
           and um_alt_um = ip_um
           and um_part   = ip_soPart
      no-lock:
         
         op_um_conv = um_conv.
         if ip_qtyAlloc / um_conv  <> round(ip_qtyAlloc / um_conv, 0)
         then
            lvl_returnValue = false.
         else
            lvl_returnValue = true.
      end.
   end.
   
   return lvl_returnValue. 
END FUNCTION. /* function fn_isValidQtyAllocByUMConv */
/* OT-153 END ADDITION */


DEFINE TEMP-TABLE scrtmp_so_mstr NO-UNDO
  FIELD dataLinkField AS INT INIT ?
  FIELD dataLinkFieldPar AS INT INIT ?
  FIELD so_nbr LIKE so_mstr.so_nbr INIT ?
  FIELD so_cust LIKE so_mstr.so_cust INIT ""
  FIELD so_ship LIKE so_mstr.so_ship INIT ""
  FIELD so_ord_date LIKE so_mstr.so_ord_date INIT ?
  FIELD so_req_date LIKE so_mstr.so_req_date INIT ?
  FIELD so_due_date LIKE so_mstr.so_due_date INIT ?
  FIELD so_rmks LIKE so_mstr.so_rmks INIT ""
  FIELD so_cr_terms LIKE so_mstr.so_cr_terms INIT ""
  FIELD so_fob LIKE so_mstr.so_fob INIT ?
  FIELD so_po LIKE so_mstr.so_po INIT ""
  FIELD so_shipvia LIKE so_mstr.so_shipvia INIT ?
  FIELD so_partial LIKE so_mstr.so_partial INIT ?
  FIELD so_print_so LIKE so_mstr.so_print_so INIT ?
  FIELD so_inv_nbr LIKE so_mstr.so_inv_nbr INIT ?
  FIELD so_pr_list LIKE so_mstr.so_pr_list INIT ?
  FIELD so_xslspsn LIKE so_mstr.so_xslspsn INIT ?
  FIELD so_source LIKE so_mstr.so_source INIT ?
  FIELD so_xcomm_pct LIKE so_mstr.so_xcomm_pct INIT ?
  FIELD so_cr_card LIKE so_mstr.so_cr_card INIT ?
  FIELD so_print_pl LIKE so_mstr.so_print_pl INIT ?
  FIELD so_cr_init LIKE so_mstr.so_cr_init INIT ?
  FIELD so_stat LIKE so_mstr.so_stat INIT ""
  FIELD so__qad01 LIKE so_mstr.so__qad01 INIT ?
  FIELD so__qad02 LIKE so_mstr.so__qad02 INIT ?
  FIELD so__qad03 LIKE so_mstr.so__qad03 INIT ?
  FIELD so_disc_pct LIKE so_mstr.so_disc_pct INIT ?
  FIELD so_tax_pct LIKE so_mstr.so_tax_pct INIT ?
  FIELD so_prepaid LIKE so_mstr.so_prepaid INIT ?
  FIELD so_to_inv LIKE so_mstr.so_to_inv INIT ?
  FIELD so_invoiced LIKE so_mstr.so_invoiced INIT ?
  FIELD so_ar_acct LIKE so_mstr.so_ar_acct INIT ?
  FIELD so_ar_cc LIKE so_mstr.so_ar_cc INIT ?
  FIELD so_inv_date LIKE so_mstr.so_inv_date INIT ?
  FIELD so_ship_date LIKE so_mstr.so_ship_date INIT ?
  FIELD so_taxable LIKE so_mstr.so_taxable INIT ?
  FIELD so_cmtindx LIKE so_mstr.so_cmtindx INIT ?
  FIELD so__qad04 LIKE so_mstr.so__qad04 INIT ?
  FIELD so_user1 LIKE so_mstr.so_user1 INIT ?
  FIELD so_user2 LIKE so_mstr.so_user2 INIT ?
  FIELD so_curr LIKE so_mstr.so_curr INIT ""
  FIELD so_ex_rate LIKE so_mstr.so_ex_rate INIT 1
  FIELD so_lang LIKE so_mstr.so_lang INIT ""
  FIELD so_type LIKE so_mstr.so_type INIT ?
  FIELD so_conf_date LIKE so_mstr.so_conf_date INIT ?
  FIELD so_rev LIKE so_mstr.so_rev INIT ?
  FIELD so_bol LIKE so_mstr.so_bol INIT ?
  FIELD so__qad05 LIKE so_mstr.so__qad05 INIT ?
  FIELD so_pst LIKE so_mstr.so_pst INIT ?
  FIELD so_fst_id LIKE so_mstr.so_fst_id INIT ?
  FIELD so_trl1_amt LIKE so_mstr.so_trl1_amt INIT 0
  FIELD so_trl1_cd LIKE so_mstr.so_trl1_cd INIT ""
  FIELD so_trl2_amt LIKE so_mstr.so_trl2_amt INIT 0
  FIELD so_trl2_cd LIKE so_mstr.so_trl2_cd INIT ""
  FIELD so_trl3_amt LIKE so_mstr.so_trl3_amt INIT 0
  FIELD so_trl3_cd LIKE so_mstr.so_trl3_cd INIT ""
  FIELD so_weight LIKE so_mstr.so_weight INIT ?
  FIELD so_weight_um LIKE so_mstr.so_weight_um INIT ?
  FIELD so_size LIKE so_mstr.so_size INIT ?
  FIELD so_size_um LIKE so_mstr.so_size_um INIT ?
  FIELD so_cartons LIKE so_mstr.so_cartons INIT ?
  FIELD so_site LIKE so_mstr.so_site INIT ""
  FIELD so_pst_id LIKE so_mstr.so_pst_id INIT ?
  FIELD so_cncl_date LIKE so_mstr.so_cncl_date INIT ?
  FIELD so_quote LIKE so_mstr.so_quote INIT ?
  FIELD so_taxc LIKE so_mstr.so_taxc INIT ""
  FIELD so__chr01 LIKE so_mstr.so__chr01 INIT ?
  FIELD so__chr02 LIKE so_mstr.so__chr02 INIT ?
  FIELD so__chr03 LIKE so_mstr.so__chr03 INIT ?
  FIELD so__chr04 LIKE so_mstr.so__chr04 INIT ?
  FIELD so__chr05 LIKE so_mstr.so__chr05 INIT ""
  FIELD so__chr06 LIKE so_mstr.so__chr06 INIT ?
  FIELD so__chr07 LIKE so_mstr.so__chr07 INIT ?
  FIELD so__chr08 LIKE so_mstr.so__chr08 INIT ""
  FIELD so__chr09 LIKE so_mstr.so__chr09 INIT ?
  FIELD so__chr10 LIKE so_mstr.so__chr10 INIT ""
  FIELD so__dte01 LIKE so_mstr.so__dte01 INIT ?
  FIELD so__dte02 LIKE so_mstr.so__dte02 INIT ?
  FIELD so__dec01 LIKE so_mstr.so__dec01 INIT 0
  FIELD so__dec02 LIKE so_mstr.so__dec02 INIT ?
  FIELD so__log01 LIKE so_mstr.so__log01 INIT ?
  FIELD so_credit LIKE so_mstr.so_credit INIT ?
  FIELD so_inv_cr LIKE so_mstr.so_inv_cr INIT ?
  FIELD so_project LIKE so_mstr.so_project INIT ?
  FIELD so_channel LIKE so_mstr.so_channel INIT ""
  FIELD so_pst_pct LIKE so_mstr.so_pst_pct INIT ?
  FIELD so_fr_list LIKE so_mstr.so_fr_list INIT ?
  FIELD so_fr_terms LIKE so_mstr.so_fr_terms INIT ?
  FIELD so_slspsn LIKE so_mstr.so_slspsn INIT ?
  FIELD so_comm_pct LIKE so_mstr.so_comm_pct INIT ?
  FIELD so_inv_mthd LIKE so_mstr.so_inv_mthd INIT ?
  FIELD so_fix_rate LIKE so_mstr.so_fix_rate INIT ?
  FIELD so_ent_ex LIKE so_mstr.so_ent_ex INIT ?
  FIELD so_bill LIKE so_mstr.so_bill INIT ""
  FIELD so_print_bl LIKE so_mstr.so_print_bl INIT ?
  FIELD so_tax_date LIKE so_mstr.so_tax_date INIT ?
  FIELD so_fsm_type LIKE so_mstr.so_fsm_type INIT ?
  FIELD so_userid LIKE so_mstr.so_userid INIT ?
  FIELD so_conrep LIKE so_mstr.so_conrep INIT ?
  FIELD so_bank LIKE so_mstr.so_bank INIT ?
  FIELD so_tax_env LIKE so_mstr.so_tax_env INIT ?
  FIELD so_sched LIKE so_mstr.so_sched INIT ?
  FIELD so_fr_min_wt LIKE so_mstr.so_fr_min_wt INIT ?
  FIELD so_pr_list2 LIKE so_mstr.so_pr_list2 INIT ?
  FIELD so_tax_usage LIKE so_mstr.so_tax_usage INIT ?
  FIELD so_sa_nbr LIKE so_mstr.so_sa_nbr INIT ?
  FIELD so_fix_pr LIKE so_mstr.so_fix_pr INIT ?
  FIELD so_sch_mthd LIKE so_mstr.so_sch_mthd INIT ?
  FIELD so_eng_code LIKE so_mstr.so_eng_code INIT ?
  FIELD so_ship_eng LIKE so_mstr.so_ship_eng INIT ?
  FIELD so_pricing_dt LIKE so_mstr.so_pricing_dt INIT ?
  FIELD so_priced_dt LIKE so_mstr.so_priced_dt INIT ?
  FIELD so_ca_nbr LIKE so_mstr.so_ca_nbr INIT ?
  FIELD so_fcg_code LIKE so_mstr.so_fcg_code INIT ?
  FIELD so_crprlist LIKE so_mstr.so_crprlist INIT ?
  FIELD so__qadc01 LIKE so_mstr.so__qadc01 INIT ?
  FIELD so__qadc02 LIKE so_mstr.so__qadc02 INIT ?
  FIELD so__qadc03 LIKE so_mstr.so__qadc03 INIT ?
  FIELD so__qadc04 LIKE so_mstr.so__qadc04 INIT ?
  FIELD so__qadc05 LIKE so_mstr.so__qadc05 INIT ?
  FIELD so__qadl01 LIKE so_mstr.so__qadl01 INIT ?
  FIELD so__qadl02 LIKE so_mstr.so__qadl02 INIT ?
  FIELD so_incl_iss LIKE so_mstr.so_incl_iss INIT ?
  FIELD so__qadi01 LIKE so_mstr.so__qadi01 INIT ?
  FIELD so__qadi02 LIKE so_mstr.so__qadi02 INIT ?
  FIELD so__qadi03 LIKE so_mstr.so__qadi03 INIT ?
  FIELD so__qadd01 LIKE so_mstr.so__qadd01 INIT ?
  FIELD so__qadd02 LIKE so_mstr.so__qadd02 INIT ?
  FIELD so__qadd03 LIKE so_mstr.so__qadd03 INIT ?
  FIELD so__qadt01 LIKE so_mstr.so__qadt01 INIT ?
  FIELD so__qadt02 LIKE so_mstr.so__qadt02 INIT ?
  FIELD so__qadt03 LIKE so_mstr.so__qadt03 INIT ?
  FIELD so_auth_days LIKE so_mstr.so_auth_days INIT ?
  FIELD so_cum_acct LIKE so_mstr.so_cum_acct INIT ?
  FIELD so_merge_rss LIKE so_mstr.so_merge_rss INIT ?
  FIELD so_ship_cmplt LIKE so_mstr.so_ship_cmplt INIT ?
  FIELD so_bump_all LIKE so_mstr.so_bump_all INIT ?
  FIELD so_primary LIKE so_mstr.so_primary INIT ?
  FIELD so_cust_po LIKE so_mstr.so_cust_po INIT ?
  FIELD so_secondary LIKE so_mstr.so_secondary INIT ?
  FIELD so_ship_po LIKE so_mstr.so_ship_po INIT ?
  FIELD so_ex_rate2 LIKE so_mstr.so_ex_rate2 INIT 1
  FIELD so_ex_ratetype LIKE so_mstr.so_ex_ratetype INIT ?
  FIELD so_div LIKE so_mstr.so_div INIT ?
  FIELD so_exru_seq LIKE so_mstr.so_exru_seq INIT ?
  FIELD so_app_owner LIKE so_mstr.so_app_owner INIT ?
  FIELD so_ar_sub LIKE so_mstr.so_ar_sub INIT ?
  FIELD so_seq_order LIKE so_mstr.so_seq_order INIT ?
  FIELD so_inc_in_rss LIKE so_mstr.so_inc_in_rss INIT ?
  FIELD so_firm_seq_days LIKE so_mstr.so_firm_seq_days INIT ?
  FIELD so_prep_tax LIKE so_mstr.so_prep_tax INIT ?
  FIELD so__qadl04 LIKE so_mstr.so__qadl04 INIT ?
  FIELD so_custref_val LIKE so_mstr.so_custref_val INIT ?
  FIELD so_consignment LIKE so_mstr.so_consignment INIT ?
  FIELD so_max_aging_days LIKE so_mstr.so_max_aging_days INIT ?
  FIELD so_consign_loc LIKE so_mstr.so_consign_loc INIT ?
  FIELD so_intrans_loc LIKE so_mstr.so_intrans_loc INIT ?
  FIELD so_auto_replenish LIKE so_mstr.so_auto_replenish INIT ?
  FIELD so_revenue LIKE so_mstr.so_revenue INIT ?
  FIELD so_fsaccr_acct LIKE so_mstr.so_fsaccr_acct INIT ?
  FIELD so_fsaccr_sub LIKE so_mstr.so_fsaccr_sub INIT ?
  FIELD so_fsaccr_cc LIKE so_mstr.so_fsaccr_cc INIT ?
  FIELD so_fsdef_acct LIKE so_mstr.so_fsdef_acct INIT ?
  FIELD so_fsdef_sub LIKE so_mstr.so_fsdef_sub INIT ?
  FIELD so_fsdef_cc LIKE so_mstr.so_fsdef_cc INIT ?
  FIELD so_manual_fr_terms LIKE so_mstr.so_manual_fr_terms INIT ?
  FIELD so_domain LIKE so_mstr.so_domain INIT ?
  FIELD oid_so_mstr LIKE so_mstr.oid_so_mstr INIT ?
  FIELD so_rss_cal_option LIKE so_mstr.so_rss_cal_option INIT ?
  FIELD so_trade_sale LIKE so_mstr.so_trade_sale INIT ?
  FIELD so_daybookset LIKE so_mstr.so_daybookset INIT ?
  FIELD so_reviewed LIKE so_mstr.so_reviewed INIT ?
  FIELD so_req_time LIKE so_mstr.so_req_time INIT ?
  FIELD so_nrm LIKE so_mstr.so_nrm INIT ?
  FIELD so_compl_stat LIKE so_mstr.so_compl_stat INIT ""
  FIELD so_compl_date LIKE so_mstr.so_compl_date INIT ?
  FIELD so_hold_stat LIKE so_mstr.so_hold_stat INIT ?
  FIELD so_promise_date LIKE so_mstr.so_promise_date INIT ?
  FIELD so_per_date LIKE so_mstr.so_per_date INIT ?
  FIELD so_tax_in LIKE so_mstr.so_tax_in INIT ?
  FIELD so_consume LIKE so_mstr.so_consume INIT ?
  FIELD so_reprice LIKE so_mstr.so_reprice INIT ?
  FIELD so_calc_fr LIKE so_mstr.so_calc_fr INIT ?
  FIELD so_gt_trans_type LIKE so_mstr.so_gt_trans_type INIT ?
  FIELD so_pod LIKE so_mstr.so_pod INIT ?
  FIELD so_cust_self_bill LIKE so_mstr.so_cust_self_bill INIT ?
  FIELD so_asb_ar_accr_acct LIKE so_mstr.so_asb_ar_accr_acct INIT ?
  FIELD so_asb_ar_accr_sub LIKE so_mstr.so_asb_ar_accr_sub INIT ?
  FIELD so_asb_ar_accr_cc LIKE so_mstr.so_asb_ar_accr_cc INIT ?
  FIELD so_asb_ar_accr_project LIKE so_mstr.so_asb_ar_accr_project INIT ?
  FIELD operation AS CHAR INIT "N" 
  .
    

DEFINE TEMP-TABLE emttmp_sod_det LIKE tt_sod_det.
DEFINE TEMP-TABLE emttmp_so_mstr LIKE tt_so_mstr.

DEFINE TEMP-TABLE scrtmp_sod_cmt_det NO-UNDO LIKE tt_sod_cmt_det.

DEFINE TEMP-TABLE scrtmp_sod_det NO-UNDO
  FIELD dataLinkField AS INT INIT ?
  FIELD dataLinkFieldPar AS INT INIT ?
  FIELD sod_nbr LIKE sod_det.sod_nbr INIT ?
  FIELD sod_due_date LIKE sod_det.sod_due_date INIT ?
  FIELD sod_per_date LIKE sod_det.sod_per_date INIT ?
  FIELD sod_req_date LIKE sod_det.sod_req_date INIT ?
  FIELD sod_line LIKE sod_det.sod_line INIT ?
  FIELD sod_part LIKE sod_det.sod_part INIT ""
  FIELD sod_qty_ord LIKE sod_det.sod_qty_ord INIT 0
  FIELD sod_qty_all LIKE sod_det.sod_qty_all INIT 0
  FIELD sod_qty_pick LIKE sod_det.sod_qty_pick INIT 0
  FIELD sod_qty_ship LIKE sod_det.sod_qty_ship INIT 0
  FIELD sod_qty_inv LIKE sod_det.sod_qty_inv INIT 0
  FIELD sod_loc LIKE sod_det.sod_loc INIT ?
  FIELD sod_type LIKE sod_det.sod_type INIT ""
  FIELD sod_price LIKE sod_det.sod_price INIT ?
  FIELD sod_std_cost LIKE sod_det.sod_std_cost INIT ?
  FIELD sod_qty_chg LIKE sod_det.sod_qty_chg INIT ?
  FIELD sod_bo_chg LIKE sod_det.sod_bo_chg INIT ?
  FIELD sod_acct LIKE sod_det.sod_acct INIT ""
  FIELD sod_abnormal LIKE sod_det.sod_abnormal INIT ?
  FIELD sod_taxable LIKE sod_det.sod_taxable INIT ?
  FIELD sod_serial LIKE sod_det.sod_serial INIT ?
  FIELD sod_desc LIKE sod_det.sod_desc INIT ""
  FIELD sod_um LIKE sod_det.sod_um INIT ?
  FIELD sod_cc LIKE sod_det.sod_cc INIT ?
  FIELD sod_comment LIKE sod_det.sod_comment INIT ?
  FIELD sod_lot LIKE sod_det.sod_lot INIT ?
  FIELD sod_um_conv LIKE sod_det.sod_um_conv INIT ?
  FIELD sod_fa_nbr LIKE sod_det.sod_fa_nbr INIT ?
  FIELD sod_disc_pct LIKE sod_det.sod_disc_pct INIT 0
  FIELD sod_project LIKE sod_det.sod_project INIT ?
  FIELD sod_cmtindx LIKE sod_det.sod_cmtindx INIT ?
  FIELD sod_custpart LIKE sod_det.sod_custpart INIT ?
  FIELD sod__qad01 LIKE sod_det.sod__qad01 INIT ?
  FIELD sod_status LIKE sod_det.sod_status INIT ?
  FIELD sod_xslspsn LIKE sod_det.sod_xslspsn INIT ?
  FIELD sod_xcomm_pct LIKE sod_det.sod_xcomm_pct INIT ?
  FIELD sod_dsc_acct LIKE sod_det.sod_dsc_acct INIT ?
  FIELD sod_dsc_cc LIKE sod_det.sod_dsc_cc INIT ?
  FIELD sod_list_pr LIKE sod_det.sod_list_pr INIT ?
  FIELD sod_user1 LIKE sod_det.sod_user1 INIT ?
  FIELD sod_user2 LIKE sod_det.sod_user2 INIT ?
  FIELD sod_sob_rev LIKE sod_det.sod_sob_rev INIT ?
  FIELD sod_sob_std LIKE sod_det.sod_sob_std INIT ?
  FIELD sod_qty_qote LIKE sod_det.sod_qty_qote INIT ?
  FIELD sod_consume LIKE sod_det.sod_consume INIT ?
  FIELD sod_expire LIKE sod_det.sod_expire INIT ?
  FIELD sod__qad02 LIKE sod_det.sod__qad02 INIT ?
  FIELD sod_taxc LIKE sod_det.sod_taxc INIT ?
  FIELD sod_inv_nbr LIKE sod_det.sod_inv_nbr INIT ?
  FIELD sod_partial LIKE sod_det.sod_partial INIT ?
  FIELD sod_site LIKE sod_det.sod_site INIT ?
  FIELD sod_prodline LIKE sod_det.sod_prodline INIT ?
  FIELD sod_tax_in LIKE sod_det.sod_tax_in INIT ?
  FIELD sod_fst_list LIKE sod_det.sod_fst_list INIT ?
  FIELD sod_pst LIKE sod_det.sod_pst INIT ?
  FIELD sod__chr01 LIKE sod_det.sod__chr01 INIT ""
  FIELD sod__chr02 LIKE sod_det.sod__chr02 INIT ?
  FIELD sod__chr03 LIKE sod_det.sod__chr03 INIT ?
  FIELD sod__chr04 LIKE sod_det.sod__chr04 INIT ?
  FIELD sod__chr05 LIKE sod_det.sod__chr05 INIT ?
  FIELD sod__chr06 LIKE sod_det.sod__chr06 INIT ?
  FIELD sod__chr07 LIKE sod_det.sod__chr07 INIT ?
  FIELD sod__chr08 LIKE sod_det.sod__chr08 INIT ?
  FIELD sod__chr09 LIKE sod_det.sod__chr09 INIT ?
  FIELD sod__chr10 LIKE sod_det.sod__chr10 INIT ?
  FIELD sod__dte01 LIKE sod_det.sod__dte01 INIT ?
  FIELD sod__dte02 LIKE sod_det.sod__dte02 INIT ?
  FIELD sod__dec01 LIKE sod_det.sod__dec01 INIT ?
  FIELD sod__dec02 LIKE sod_det.sod__dec02 INIT ?
  FIELD sod__log01 LIKE sod_det.sod__log01 INIT ?
  FIELD sod_calc_isb LIKE sod_det.sod_calc_isb INIT ?
  FIELD sod_owner LIKE sod_det.sod_owner INIT ?
  FIELD sod_rma_type LIKE sod_det.sod_rma_type INIT ?
  FIELD sod_qty_item LIKE sod_det.sod_qty_item INIT ?
  FIELD sod_qty_per LIKE sod_det.sod_qty_per INIT ?
  FIELD sod_ref LIKE sod_det.sod_ref INIT ?
  FIELD sod_for LIKE sod_det.sod_for INIT ?
  FIELD sod_tax_max LIKE sod_det.sod_tax_max INIT ?
  FIELD sod_contr_id LIKE sod_det.sod_contr_id INIT ?
  FIELD sod_pickdate LIKE sod_det.sod_pickdate INIT ?
  FIELD sod_confirm LIKE sod_det.sod_confirm INIT ?
  FIELD sod_cum_qty LIKE sod_det.sod_cum_qty INIT ?
  FIELD sod_cum_date LIKE sod_det.sod_cum_date INIT ?
  FIELD sod_fr_rate LIKE sod_det.sod_fr_rate INIT ?
  FIELD sod_slspsn LIKE sod_det.sod_slspsn INIT ?
  FIELD sod_comm_pct LIKE sod_det.sod_comm_pct INIT ?
  FIELD sod_ord_mult LIKE sod_det.sod_ord_mult INIT ?
  FIELD sod_pkg_code LIKE sod_det.sod_pkg_code INIT ?
  FIELD sod_curr_rlse_id LIKE sod_det.sod_curr_rlse_id INIT ?
  FIELD sod_sched LIKE sod_det.sod_sched INIT ?
  FIELD sod_sch_data LIKE sod_det.sod_sch_data INIT ?
  FIELD sod_sch_mrp LIKE sod_det.sod_sch_mrp INIT ?
  FIELD sod_rlse_nbr LIKE sod_det.sod_rlse_nbr INIT ?
  FIELD sod_translt_days LIKE sod_det.sod_translt_days INIT ?
  FIELD sod_fsm_type LIKE sod_det.sod_fsm_type INIT ?
  FIELD sod_conrep LIKE sod_det.sod_conrep INIT ?
  FIELD sod_start_eff LIKE sod_det.sod_start_eff INIT ?
  FIELD sod_end_eff LIKE sod_det.sod_end_eff INIT ?
  FIELD sod_dock LIKE sod_det.sod_dock INIT ?
  FIELD sod_pr_list LIKE sod_det.sod_pr_list INIT ?
  FIELD sod_translt_hrs LIKE sod_det.sod_translt_hrs INIT ?
  FIELD sod_out_po LIKE sod_det.sod_out_po INIT ?
  FIELD sod_raw_days LIKE sod_det.sod_raw_days INIT ?
  FIELD sod_fab_days LIKE sod_det.sod_fab_days INIT ?
  FIELD sod_tax_usage LIKE sod_det.sod_tax_usage INIT ?
  FIELD sod_rbkt_days LIKE sod_det.sod_rbkt_days INIT ?
  FIELD sod_rbkt_weeks LIKE sod_det.sod_rbkt_weeks INIT ?
  FIELD sod_rbkt_mths LIKE sod_det.sod_rbkt_mths INIT ?
  FIELD sod_sched_chgd LIKE sod_det.sod_sched_chgd INIT ?
  FIELD sod_pastdue LIKE sod_det.sod_pastdue INIT ?
  FIELD sod_fix_pr LIKE sod_det.sod_fix_pr INIT ?
  FIELD sod_fr_wt LIKE sod_det.sod_fr_wt INIT ?
  FIELD sod_fr_wt_um LIKE sod_det.sod_fr_wt_um INIT ?
  FIELD sod_fr_class LIKE sod_det.sod_fr_class INIT ?
  FIELD sod_fr_chg LIKE sod_det.sod_fr_chg INIT ?
  FIELD sod_sa_nbr LIKE sod_det.sod_sa_nbr INIT ?
  FIELD sod_isb_loc LIKE sod_det.sod_isb_loc INIT ?
  FIELD sod_ship LIKE sod_det.sod_ship INIT ?
  FIELD sod_auto_ins LIKE sod_det.sod_auto_ins INIT ?
  FIELD sod_drp_ref LIKE sod_det.sod_drp_ref INIT ?
  FIELD sod_tax_env LIKE sod_det.sod_tax_env INIT ?
  FIELD sod_upd_isb LIKE sod_det.sod_upd_isb INIT ?
  FIELD sod_isb_ref LIKE sod_det.sod_isb_ref INIT ?
  FIELD sod_enduser LIKE sod_det.sod_enduser INIT ?
  FIELD sod_crt_int LIKE sod_det.sod_crt_int INIT ?
  FIELD sod_fr_list LIKE sod_det.sod_fr_list INIT ?
  FIELD sod_pricing_dt LIKE sod_det.sod_pricing_dt INIT ?
  FIELD sod_act_price LIKE sod_det.sod_act_price INIT ?
  FIELD sod_covered_amt LIKE sod_det.sod_covered_amt INIT ?
  FIELD sod_ca_nbr LIKE sod_det.sod_ca_nbr INIT ?
  FIELD sod_fixed_price LIKE sod_det.sod_fixed_price INIT ?
  FIELD sod_inv_cost LIKE sod_det.sod_inv_cost INIT ?
  FIELD sod_car_load LIKE sod_det.sod_car_load INIT ?
  FIELD sod_ca_line LIKE sod_det.sod_ca_line INIT ?
  FIELD sod_qty_cons LIKE sod_det.sod_qty_cons INIT ?
  FIELD sod_qty_ret LIKE sod_det.sod_qty_ret INIT ?
  FIELD sod_qty_pend LIKE sod_det.sod_qty_pend INIT ?
  FIELD sod_to_loc LIKE sod_det.sod_to_loc INIT ?
  FIELD sod_to_site LIKE sod_det.sod_to_site INIT ?
  FIELD sod_to_ref LIKE sod_det.sod_to_ref INIT ?
  FIELD sod_ln_ref LIKE sod_det.sod_ln_ref INIT ?
  FIELD sod_qty_exch LIKE sod_det.sod_qty_exch INIT ?
  FIELD sod_sad_line LIKE sod_det.sod_sad_line INIT ?
  FIELD sod_warr_start LIKE sod_det.sod_warr_start INIT ?
  FIELD sod_mod_userid LIKE sod_det.sod_mod_userid INIT ?
  FIELD sod_mod_date LIKE sod_det.sod_mod_date INIT ?
  FIELD sod_sv_code LIKE sod_det.sod_sv_code INIT ?
  FIELD sod_alt_pkg LIKE sod_det.sod_alt_pkg INIT ?
  FIELD sod_for_serial LIKE sod_det.sod_for_serial INIT ?
  FIELD sod_override_lmt LIKE sod_det.sod_override_lmt INIT ?
  FIELD sod__qadc01 LIKE sod_det.sod__qadc01 INIT ?
  FIELD sod__qadc02 LIKE sod_det.sod__qadc02 INIT ?
  FIELD sod__qadc03 LIKE sod_det.sod__qadc03 INIT ?
  FIELD sod__qadc04 LIKE sod_det.sod__qadc04 INIT ?
  FIELD sod__qadt01 LIKE sod_det.sod__qadt01 INIT ?
  FIELD sod__qadt02 LIKE sod_det.sod__qadt02 INIT ?
  FIELD sod__qadt03 LIKE sod_det.sod__qadt03 INIT ?
  FIELD sod__qadt04 LIKE sod_det.sod__qadt04 INIT ?
  FIELD sod__qadd01 LIKE sod_det.sod__qadd01 INIT ?
  FIELD sod__qadd02 LIKE sod_det.sod__qadd02 INIT ?
  FIELD sod__qadd03 LIKE sod_det.sod__qadd03 INIT ?
  FIELD sod__qadl01 LIKE sod_det.sod__qadl01 INIT ?
  FIELD sod__qadl02 LIKE sod_det.sod__qadl02 INIT ?
  FIELD sod__qadl03 LIKE sod_det.sod__qadl03 INIT ?
  FIELD sod__qadi01 LIKE sod_det.sod__qadi01 INIT ?
  FIELD sod__qadi02 LIKE sod_det.sod__qadi02 INIT ?
  FIELD sod_bonus LIKE sod_det.sod_bonus INIT ?
  FIELD sod_btb_type LIKE sod_det.sod_btb_type INIT ?
  FIELD sod_btb_po LIKE sod_det.sod_btb_po INIT ?
  FIELD sod_btb_pod_line LIKE sod_det.sod_btb_pod_line INIT ?
  FIELD sod_btb_vend LIKE sod_det.sod_btb_vend INIT ?
  FIELD sod_exp_del LIKE sod_det.sod_exp_del INIT ?
  FIELD sod_dir_all LIKE sod_det.sod_dir_all INIT ?
  FIELD sod_cfg_type LIKE sod_det.sod_cfg_type INIT ?
  FIELD sod_div LIKE sod_det.sod_div INIT ?
  FIELD sod_pl_priority LIKE sod_det.sod_pl_priority INIT ?
  FIELD sod_prig1 LIKE sod_det.sod_prig1 INIT ?
  FIELD sod_prig2 LIKE sod_det.sod_prig2 INIT ?
  FIELD sod__qadd04 LIKE sod_det.sod__qadd04 INIT ?
  FIELD sod_sub LIKE sod_det.sod_sub INIT ?
  FIELD sod_dsc_sub LIKE sod_det.sod_dsc_sub INIT ?
  FIELD sod_dsc_project LIKE sod_det.sod_dsc_project INIT ?
  FIELD sod_qty_ivcd LIKE sod_det.sod_qty_ivcd INIT ?
  FIELD sod_cum_time LIKE sod_det.sod_cum_time INIT ?
  FIELD sod_ship_part LIKE sod_det.sod_ship_part INIT ?
  FIELD sod_promise_date LIKE sod_det.sod_promise_date INIT ?
  FIELD sod_charge_type LIKE sod_det.sod_charge_type INIT ?
  FIELD sod_order_category LIKE sod_det.sod_order_category INIT ?
  FIELD sod_modelyr LIKE sod_det.sod_modelyr INIT ?
  FIELD sod_custref LIKE sod_det.sod_custref INIT ?
  FIELD sod_consignment LIKE sod_det.sod_consignment INIT ?
  FIELD sod_max_aging_days LIKE sod_det.sod_max_aging_days INIT ?
  FIELD sod_consign_loc LIKE sod_det.sod_consign_loc INIT ?
  FIELD sod_intrans_loc LIKE sod_det.sod_intrans_loc INIT ?
  FIELD sod_auto_replenish LIKE sod_det.sod_auto_replenish INIT ?
  FIELD sod_manual_fr_list LIKE sod_det.sod_manual_fr_list INIT ?
  FIELD sod_domain LIKE sod_det.sod_domain INIT ?
  FIELD oid_sod_det LIKE sod_det.oid_sod_det INIT ?
  FIELD sod_trade_sale_po LIKE sod_det.sod_trade_sale_po INIT ?
  FIELD sod_trade_sale_po_line LIKE sod_det.sod_trade_sale_po_line INIT ?
  FIELD sod_trade_sale_vend LIKE sod_det.sod_trade_sale_vend INIT ?
  FIELD sod_fsrev_acct LIKE sod_det.sod_fsrev_acct INIT ?
  FIELD sod_fsrev_sub LIKE sod_det.sod_fsrev_sub INIT ?
  FIELD sod_fsrev_cc LIKE sod_det.sod_fsrev_cc INIT ?
  FIELD sod_req_time LIKE sod_det.sod_req_time INIT ?
  FIELD sod_shipvia LIKE sod_det.sod_shipvia INIT ?
  FIELD sod_compl_stat LIKE sod_det.sod_compl_stat INIT ""
  FIELD sod_compl_date LIKE sod_det.sod_compl_date INIT ?
  FIELD sod_hold_stat LIKE sod_det.sod_hold_stat INIT ?
  FIELD sod_unadjust_cum_qty LIKE sod_det.sod_unadjust_cum_qty INIT ?
  FIELD sod_config_id LIKE sod_det.sod_config_id INIT ?
  FIELD operation AS CHAR INIT "N" 
  FIELD sodcmmts  AS CHARACTER  INIT ?
  .
 
 /* RFC2556 ADD BEGINS */
 define temp-table scrtmp1 like scrtmp_sod_det
  field sod_avl like sod_qty_ord. 
 /* RFC2556 ADD ENDS */


DEFINE TEMP-TABLE tt-sod_cosign NO-UNDO
    FIELD xsod_domain        AS CHARACTER
    FIELD xsod_nbr           AS CHARACTER
    FIELD xsod_line          AS INT
    FIELD xsod_qty_all       AS DECIMAL INIT 0
    FIELD xsod_qty_pick      AS DECIMAL INIT 0
    FIELD lLastLine          AS LOGICAL INIT FALSE
        INDEX  tt-sod_cosign AS PRIMARY UNIQUE xsod_domain xsod_nbr xsod_line.


/* RFC2142 ADD BEGINS */

define temp-table tt_quota no-undo                                                       
   field tt_domain  like sod_det.sod_domain                              
   field tt_nbr     like sod_det.sod_nbr                                 
   field tt_line    like sod_det.sod_line                                
   field tt_part    like sod_det.sod_part                                
   field tt_cust    like so_mstr.so_cust  
   field tt_ctry    like ad_mstr.ad_country /* RFC2364 */
   field tt_site    like so_mstr.so_site                                                
   field tt_ordt    like sod_det.sod_due_date 
   field tt_olddt   like sod_det.sod_due_date
   field tt_ord_qty like sod_det.sod_qty_ord
   field tt_old_qty  like sod_det.sod_qty_ord
   field tt_actual_qty like sod_det.sod_qty_ord
   field tt_code    as char 
   field tt_operation as character format "x(1)".
define dataset ttquota serialize-hidden for tt_quota.



define temp-table tt_duedt no-undo
   field tt_cus like so_mstr.so_cust
   field tt_ptnbr like sod_det.sod_part
   field tt_date like sod_det.sod_due_date
   field tt_start as date
   field tt_end   as  date 
   field tt_qtyord like sod_det.sod_qty_ord 
   field tt_umconv   like sod_det.sod_um_conv.
/* RFC2142 ADD ENDS */

/* CEPS-1582 ADD BEGINS */
define temp-table tt_prstat
   field tt_prline like sod_line   
   field tt_prpart like sod_part   
   field tt_prsta  like sod__chr02  .
/* CEPS-1582 ADD ENDS */  
/*CHN00664 - ADD STARTS*/
for each code_mstr no-lock
   where code_mstr.code_domain  = "XX"
     and code_mstr.code_fldname = "PAO_ITEM_EMAIL_ALERTS"
     and code_mstr.code_value begins "PAO":
   if lv_mail_to = "" then
      lv_mail_to = code_mstr.code_cmmt.    
   else
      lv_mail_to = lv_mail_to + "," + code_mstr.code_cmmt.  
end. 
/****************CHN00826 - ADD STARTS *******************/
for first code_mstr no-lock
   where code_mstr.code_domain  = "XX"
     and code_mstr.code_fldname = "NOCONSUMEFORECAST"
     and code_mstr.code_value   = "PROJECTCODES":
   lvc_prjcodes = trim(code_mstr.code_cmmt).
end. /*for first code_mstr no-lock*/
/****************CHN00826 - ADD ENDS *******************/

find first usr_mstr no-lock where usr_mstr.usr_userid = global_userid no-error.
if available usr_mstr and usr_mstr.usr_mail_address <> "" then
do:
   if lv_mail_to = "" then
      lv_mail_to = usr_mstr.usr_mail_address.
   else 
      lv_mail_to = lv_mail_to + "," + usr_mstr.usr_mail_address.
end.
/*CHN00664 - ADD ENDS*/
/*******CHN00830 - ADD STARTS*********************************/
for first code_mstr no-lock 
   where code_mstr.code_domain  = "XX"
     and code_mstr.code_fldname = "SODueDateCalc"
     and code_mstr.code_value   = "DeliveryDays":
   lvi_dueDays = integer(trim(code_mstr.code_cmmt)) no-error.
end. /*for first code_mstr no-lock*/
if lvi_dueDays = 0 
   then lvi_dueDays = 14.
/*******CHN00830 - ADD ENDS*********************************/

hbuf = BUFFER scrtmp_sod_det:HANDLE.
  
PROCEDURE SaveDataFromDSTT:
  DEFINE BUFFER bscrtmp_so_mstr FOR scrtmp_so_mstr.
  DEFINE BUFFER bscrtmp_sod_det FOR scrtmp_sod_det.
  DEFINE BUFFER bscrtmp_sod_cmt_det FOR scrtmp_sod_cmt_det.
  
  FOR EACH tt_so_mstr,
    FIRST bscrtmp_so_mstr WHERE bscrtmp_so_mstr.so_nbr  = tt_so_mstr.so_nbr:
    BUFFER-COPY tt_so_mstr
         EXCEPT so_nbr
             TO bscrtmp_so_mstr.
  END.
  
  FOR EACH tt_sod_det,
    FIRST bscrtmp_sod_det WHERE bscrtmp_sod_det.sod_nbr = tt_sod_det.sod_nbr
                            AND bscrtmp_sod_det.sod_line = tt_sod_det.sod_line:
    BUFFER-COPY tt_sod_det
         EXCEPT sod_nbr sod_line
             TO bscrtmp_sod_det.
  END.
  
  FOR EACH tt_sod_cmt_det,
      EACH bscrtmp_sod_cmt_det WHERE bscrtmp_sod_cmt_det.dataLinkField = tt_sod_cmt_det.dataLinkField:
    BUFFER-COPY tt_sod_cmt_det
             TO bscrtmp_sod_cmt_det.
  END.
  
  ASSIGN line-tot = 0.
  FOR EACH bscrtmp_sod_det:
    line-tot = line-tot + bscrtmp_sod_det.sod_qty_ord * bscrtmp_sod_det.sod_price.
  END.

END PROCEDURE.


PROCEDURE SetSodVat:
 
  DEFINE INPUT  PARAMETER cDomain# AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER cSoNbr#  AS CHARACTER   NO-UNDO.
 
  RUN SaveDataToDSTT.

  run "zu/zusodvat.p" (cDomain#,cSoNbr#) no-error.
  
  RUN SaveDataFromDSTT.
  
END PROCEDURE.

PROCEDURE SetEditBlock:
 
  DEFINE PARAMETER BUFFER bscrtmp_so_mstr FOR scrtmp_so_mstr.
  DEFINE PARAMETER BUFFER bscrtmp_sod_det FOR scrtmp_sod_det.
  DEFINE PARAMETER BUFFER pt_mstr FOR pt_mstr.
  DEFINE INPUT  PARAMETER cBlockType# AS CHARACTER   NO-UNDO.

  /*RFC-2038 Add Begins*/
  define variable lvc_compare as character no-undo.
  DEFINE BUFFER sod_det FOR sod_det.
  /*RFC-2038 Add Ends*/    
  DEFINE BUFFER tt_so_mstr FOR tt_so_mstr.
  DEFINE BUFFER tt_sod_det FOR tt_sod_det.

  /*RFC-2038 Add Begins*/
  find first sod_det no-lock 
     where sod_det.sod_domain = bscrtmp_sod_det.sod_domain 
       and sod_det.sod_nbr    = bscrtmp_sod_det.sod_nbr
       and sod_det.sod_line   = bscrtmp_sod_det.sod_line 
  no-error.
  if available sod_det 
  then 
     /*buffer-compare bscrtmp_sod_det to sod_det save lvc_compare.  INC16800 */
     /*INC16800 ADD BEGINS*/
     buffer-compare bscrtmp_sod_det except
                                    bscrtmp_sod_det.sod_qty_all 
                                    bscrtmp_sod_det.sod_list_pr 
                                    bscrtmp_sod_det.sod_price 
                    bscrtmp_sod_det.sod_disc_pct   /*RFC-2990*/  
                                    bscrtmp_sod_det.sod_pricing_dt 
                                    to sod_det save lvc_compare. 
     /*INC16800 ADD ENDS*/
  else
     lvc_compare = "new-line".
  /*RFC-2038 Add Ends*/
    
  RUN SaveDataToDSTT.

  FIND tt_so_mstr WHERE tt_so_mstr.so_nbr = bscrtmp_so_mstr.so_nbr.
  FIND tt_sod_det WHERE tt_sod_det.sod_nbr = bscrtmp_sod_det.sod_nbr
                    AND tt_sod_det.sod_line = bscrtmp_sod_det.sod_line.

  /*run "zu/zuetbkvn.p" (INPUT BUFFER tt_so_mstr:HANDLE,
                       INPUT BUFFER tt_sod_det:HANDLE,
                       BUFFER pt_mstr,
                       domain,
                       qty-ord-cs,
                       wh-domain,
                       wh-site,
                       emt-ordr,
                       cBlockType#,
                                       "Blocked",
                       output l_edblval ).                         RFC-2038 Delete*/
  /*INC16800 DELETE BEGINS                       
  /*RFC-2038 Add Begins*/
  if lvc_compare <> ""  
  then
     run "zu/zuetbkvn.p" (INPUT BUFFER tt_so_mstr:HANDLE,
                          INPUT BUFFER tt_sod_det:HANDLE,
                          BUFFER pt_mstr,
                          domain,
                          qty-ord-cs,
                          wh-domain,
                          wh-site,
                          emt-ordr,
                          cBlockType#,
                          "Blocked",
                          output l_edblval ). 
  /*RFC-2038 Add Ends*/
  **INC16800 DELETE ENDS*/  
  /*INC16800 ADD BEGINS*/ 
  if lvc_compare <> "" 
  then do:
     /**********INC90422 - ADD STARTS**************************/
     if can-find(first xxblck_det no-lock 
                    where xxblck_domain = scrtmp_sod_det.sod_domain                                             
                      and xxblck_ord    = scrtmp_sod_det.sod_nbr                                                
                      and xxblck_line   = scrtmp_sod_det.sod_line 
                      and xxblck_stat   = "Released") 
     then
     /**********INC90422 - ADD ENDS**************************/
     if lvc_compare <> "new-line" and 
        scrtmp_sod_det.sod_qty_ord <= sod_det.sod_qty_ord then next.      /*RFC-2990*/
     if cBlockType#  = "Editblock" 
     then do:
        for first xxblck_det exclusive-lock                                                            
               where xxblck_domain = scrtmp_sod_det.sod_domain                                             
               and   xxblck_ord      = scrtmp_sod_det.sod_nbr                                                
               and   xxblck_line     = scrtmp_sod_det.sod_line                                               
               and   xxblck_type     = cBlockType#       
               use-index xxblck_time: 
           if available xxblck_det 
           then do:     
                  delete xxblck_det. 
                      release xxblck_det.
           end.  /*if available xxblck_det*/  
        end.  /* for first xxblck_det */   
     end.  /*if cblockType#  = "Editblock"*/
     run "zu/zuetbkvn.p" (input buffer tt_so_mstr:handle,
                          input buffer tt_sod_det:handle,
                          buffer pt_mstr,
                          domain,
                          qty-ord-cs,
                          wh-domain,
                          wh-site,
                          emt-ordr,
                          cBlockType#,
                          "Blocked",
                          output l_edblval ). 
  end.  /*if lvc_compare <> ""*/                        
  /*INC16800 ADD ENDS*/
END PROCEDURE.


FUNCTION CompareOrgScrtmpBuffers RETURNS LOGICAL:
    DEFINE BUFFER so_mstr FOR so_mstr.
    DEFINE BUFFER sod_det FOR sod_det.
    DEFINE BUFFER scrtmp_so_mstr FOR scrtmp_so_mstr.
    DEFINE BUFFER scrtmp_sod_det FOR scrtmp_sod_det.
    DEFINE VARIABLE lEqual# AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE cComp#  AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE lPrintPl# AS LOGICAL     NO-UNDO INIT ?.
    
    FOR EACH scrtmp_so_mstr:
    
       PUBLISH "GetOldDbPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                                  INPUT scrtmp_so_mstr.so_nbr,
                                  OUTPUT lPrintPl#).
                                  
       IF scrtmp_so_mstr.operation = "R"  THEN lEqual# = FALSE.
       ELSE DO:
           FIND FIRST so_mstr NO-LOCK WHERE so_mstr.so_domain = scrtmp_so_mstr.so_domain 
                                        AND so_mstr.so_nbr = scrtmp_so_mstr.so_nbr NO-ERROR.
           IF NOT AVAIL so_mstr THEN lEqual# = FALSE.
           ELSE DO:
                BUFFER-COMPARE scrtmp_so_mstr EXCEPT operation so_print_pl TO so_mstr SAVE cComp#.
                
                IF (cComp# = ? OR
                   cComp# = "") AND
                   (lPrintPl# <> ? AND lPrintPl# <> scrtmp_so_mstr.so_print_pl)
                THEN ASSIGN cComp# = "so_print_pl".
                
                IF cComp# <> ? AND cComp# <> "" THEN DO:
                    /* if difference is only so_tat field and status in scrtmp buffer is equal to status in so_mstr then skip */
                    /* this is done because status is often reset from HI example to "" */
                    IF NOT (cComp# = "so_stat" AND AVAIL so_mstr AND so_mstr.so_stat = scrtmp_so_mstr.so_stat)
                    THEN DO:
                        lEqual# = FALSE.
                        IF scrtmp_so_mstr.operation <> "M" AND scrtmp_so_mstr.operation <> "A" THEN scrtmp_so_mstr.operation = "M".
                    END.
                    ELSE scrtmp_so_mstr.operation = "N".
                END.
                ELSE scrtmp_so_mstr.operation = "N".
                
                IF lPrintPl# <> ? AND 
                   scrtmp_so_mstr.so_print_pl <> lPrintPl# AND
                   scrtmp_so_mstr.operation = "N"
                THEN ASSIGN scrtmp_so_mstr.operation = "M".
                
           END.
           
       END.
    END.
    FOR EACH scrtmp_sod_det:
       IF scrtmp_sod_det.operation = "R"  THEN lEqual# = FALSE.
       ELSE DO:
           FIND FIRST sod_det NO-LOCK WHERE sod_det.sod_domain = scrtmp_sod_det.sod_domain 
                                               AND sod_det.sod_nbr = scrtmp_sod_det.sod_nbr 
                                               AND sod_det.sod_line = scrtmp_sod_det.sod_line 
                                               NO-ERROR.
           IF NOT AVAIL sod_det THEN lEqual# = FALSE.
           ELSE DO:
               BUFFER-COMPARE scrtmp_sod_det EXCEPT operation TO sod_det SAVE cComp#.
               
               IF cComp# <> ? AND cComp# <> "" 
               THEN DO:
                   lEqual# = FALSE.
                   IF scrtmp_sod_det.operation <> "M" AND scrtmp_sod_det.operation <> "A" THEN scrtmp_sod_det.operation = "M".
               END.
               ELSE scrtmp_sod_det.operation = "N".
           END.
       END.
    END.

    RETURN lEqual#.
END FUNCTION.

/* OT-323 ADD BEGINS */
function getholiday returns logical (lv_domain as char,
                                     lv_site   as char,
                                     lv_date as date ) :
   define variable lv_available  as logical no-undo.
   for first hd_mstr no-lock 
      where hd_domain = lv_domain
        and hd_site   = lv_site
        and hd_date   = lv_date:
   end. /* FOR FIRST hd_mstr */
   if available hd_mstr
   then 
      lv_available = yes. 
   return lv_available .
end function.
/* OT-323 ADD ENDS */ 

PROCEDURE SetSodDue:
  DEFINE INPUT  PARAMETER cDomain#  AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER cSoNbr#   AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER iSodLine# AS INTEGER     NO-UNDO.
  DEFINE INPUT  PARAMETER cWhSite#  AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER cWhDom#   AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER lShowMes# AS LOGICAL     NO-UNDO.
  DEFINE OUTPUT PARAMETER oNextDue# AS DATE        NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER ioSodDueDate# AS DATE        NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER ioSodPerDate# AS DATE        NO-UNDO.

  RUN SaveDataToDSTT.
  
  run "zu/zusoddue.p" (cDomain#, cSoNbr#, iSodLine#, cWhSite#, cWhDom#,
                       lShowMes#, output oNextDue#, INPUT-OUTPUT ioSodDueDate#, INPUT-OUTPUT ioSodPerDate#) NO-ERROR.
                       
  RUN SaveDataFromDSTT.

END PROCEDURE.

PROCEDURE SaveDataToDSTT:
  DEFINE BUFFER bscrtmp_so_mstr FOR scrtmp_so_mstr.
  DEFINE BUFFER bscrtmp_sod_det FOR scrtmp_sod_det.
  DEFINE BUFFER bscrtmp_sod_cmt_det FOR scrtmp_sod_cmt_det.

  DATASET dsmaintainSalesOrder:EMPTY-DATASET().
  
  FOR EACH bscrtmp_so_mstr:
    CREATE tt_so_mstr.
    BUFFER-COPY bscrtmp_so_mstr
             TO tt_so_mstr.
  END.
  
  FOR EACH bscrtmp_sod_det:
    CREATE tt_sod_det.
    BUFFER-COPY bscrtmp_sod_det
             TO tt_sod_det.
  END.
  
  FOR EACH bscrtmp_sod_cmt_det:
    CREATE tt_sod_cmt_det.
    BUFFER-COPY bscrtmp_sod_cmt_det
             TO tt_sod_cmt_det.
  END.

END PROCEDURE.

PROCEDURE SavePoData:
  DEFINE OUTPUT PARAMETER lErro# AS LOGICAL     NO-UNDO.
  
  DEFINE VARIABLE cPoDomain# AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cPoEntity# AS CHARACTER   NO-UNDO.
  
  DEFINE VARIABLE iCallID# AS INTEGER     NO-UNDO INIT ?.
  DEFINE VARIABLE iSeqNr#  AS INTEGER     NO-UNDO INIT ?.

  
  IF lShowSaveMessage#
  THEN MESSAGE "Saving EMTPO...".

  
  FOR EACH tt_po_mstr:
    ASSIGN cPoDomain# = tt_po_mstr.po_domain
           cPoEntity# = DYNAMIC-FUNCTION("GetEntityForSite" IN hProc#, INPUT tt_po_mstr.po_domain, tt_po_mstr.po_site)
           .
  
  END.
  
  RUN SaveMedlinePO IN hProc# ( INPUT cPoDomain#,
                                  INPUT cPoEntity#,
                                  INPUT-OUTPUT DATASET dsmaintainPurchaseOrder,
                                  INPUT-OUTPUT iCallID#,
                                  INPUT-OUTPUT iSeqNr#,
                                  OUTPUT cErro#).  
  
  DATASET dsmaintainPurchaseOrder:EMPTY-DATASET().
  
  IF cErro# <> "" AND cErro# <> ? THEN
  DO:
      lErro# = TRUE.
      
      RUN zu/zupxmsg.p (" ERROR: Last PO transaction is not committed. ", cErro#, INPUT-OUTPUT lNoReply#).
  END.
  
  IF lShowSaveMessage#
  THEN MESSAGE "Saving EMTPO done...".
    
END PROCEDURE.


PROCEDURE SaveEmtData:
  DEFINE OUTPUT PARAMETER lErro# AS LOGICAL     NO-UNDO.
  DEFINE BUFFER emttmp_so_mstr  FOR emttmp_so_mstr .
  DEFINE BUFFER emttmp_sod_det FOR emttmp_sod_det.
  
  DEFINE VARIABLE cSoDomain# AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cSoEntity# AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE iCallID# AS INTEGER     NO-UNDO INIT ?.
  DEFINE VARIABLE iSeqNr#  AS INTEGER     NO-UNDO INIT ?.

  
  IF CAN-FIND(FIRST emttmp_so_mstr) = FALSE AND
     CAN-FIND(FIRST emttmp_sod_det) = FALSE
  THEN RETURN.
  
  IF lShowSaveMessage#
  THEN MESSAGE "Saving EMTSO...".

  DATASET dsmaintainSalesOrder:EMPTY-DATASET().
  
  FOR EACH emttmp_so_mstr:
    ASSIGN cSoDomain# = emttmp_so_mstr.so_domain
           cSoEntity# = DYNAMIC-FUNCTION("GetEntityForSite" IN hProc#, INPUT emttmp_so_mstr.so_domain, emttmp_so_mstr.so_site)
           .
  
    CREATE tt_so_mstr.
    BUFFER-COPY emttmp_so_mstr
             TO tt_so_mstr.
  END.
  
  FOR EACH emttmp_sod_det:
    CREATE tt_sod_det.
    BUFFER-COPY emttmp_sod_det
             TO tt_sod_det.
  END.

  RUN SaveMedlineSO IN hProc#
    (INPUT cSoDomain#,
     INPUT cSoEntity#,
     INPUT THIS-PROCEDURE,
     INPUT-OUTPUT DATASET dsmaintainSalesOrder,
     INPUT-OUTPUT iCallID#,
     INPUT-OUTPUT iSeqnr#,
     OUTPUT cErro#).  
  
  RUN SetPrintPPLOverRule IN hProc# (INPUT FALSE).
  
  FOR EACH tt_so_mstr WHERE tt_so_mstr.operation = "A":
    PUBLISH "InitSoPrintPlForce" (INPUT tt_so_mstr.so_domain,
                                  INPUT tt_so_mstr.so_nbr,
                                  INPUT FALSE /* tt_so_mstr.so_print_pl */,
                                  OUTPUT cErroSoPPL#). 
    IF cErroSoPPL# <> ""
    THEN MESSAGE cErroSoPPL# VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END.   
  
  DATASET dsmaintainSalesOrder:EMPTY-DATASET().
  
  IF cErro# <> "" AND cErro# <> ? THEN
  DO:
      lErro# = TRUE.
      
      RUN zu/zupxmsg.p (" ERROR: Last EMT transaction is not committed. ", cErro#, INPUT-OUTPUT lNoReply#).
  END.
  
  FOR EACH emttmp_so_mstr:
    DELETE emttmp_so_mstr.
  END.
  
  FOR EACH emttmp_sod_det:
    DELETE emttmp_sod_det.
  END. 
  
  IF lShowSaveMessage#
  THEN MESSAGE "Saving EMTSO done...".
  
END PROCEDURE.


PROCEDURE SaveSoLocal:

  DEFINE INPUT  PARAMETER lForceSave# AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE cErro# AS CHARACTER   NO-UNDO.
  DEFINE OUTPUT PARAMETER lErro# AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lSave# AS LOGICAL   INIT FALSE NO-UNDO.

  DEFINE BUFFER scrtmp_sod_det FOR scrtmp_sod_det.
  DEFINE BUFFER sod_det FOR sod_det.
  
  DEFINE VARIABLE iCallID# AS INTEGER     NO-UNDO INIT ?.
  DEFINE VARIABLE iSeqNr#  AS INTEGER     NO-UNDO INIT ?.
  DEFINE BUFFER so_mstr FOR so_mstr.
  DEFINE VARIABLE lUndoSo# AS LOGICAL     NO-UNDO INIT TRUE.
  DEFINE VARIABLE dSodQtyInv# AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE lAllClosed# AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lInLastFrame# AS LOGICAL     NO-UNDO INIT FALSE.
  
  
  IF VALID-HANDLE(FOCUS) AND
     CAN-QUERY(FOCUS,"FRAME-NAME") AND
     FOCUS:FRAME-NAME = "e"
  THEN ASSIGN lInLastFrame# = TRUE.
  
  CompareOrgScrtmpBuffers().
  
  IF lForceSave# = TRUE 
  THEN DO:
    FIND FIRST so_mstr NO-LOCK WHERE so_mstr.so_domain = scrtmp_so_mstr.so_domain
                                 AND so_mstr.so_nbr    = scrtmp_so_mstr.so_nbr NO-ERROR.
    IF AVAIL so_mstr
    THEN ASSIGN scrtmp_so_mstr.operation = "M".
    ELSE ASSIGN scrtmp_so_mstr.operation = "A".
  
    RUN SetPrintPPLOverRule IN hProc# (INPUT TRUE).  
  END.
  
  IF lForceSave# = FALSE AND /* CompareOrgScrtmpBuffers() = FALSE AND */ LASTKEY = 404 
  THEN DO:

      IF VALID-HANDLE(FOCUS) AND
         CAN-QUERY(FOCUS,"FRAME-NAME") AND
         FOCUS:FRAME-NAME = "c" /* Line entry frame */
      THEN ASSIGN lUndoSo# = FALSE.
  
      ASSIGN lSave# = FALSE.
      /*
      RUN zu/zupxmsg.p ("Save changes first?", "", INPUT-OUTPUT lSave#).
      */
      
      
      IF lSave# = FALSE 
      THEN DO:
        FOR EACH scrtmp_sod_det:
          FIND FIRST sod_det NO-LOCK WHERE sod_det.sod_domain = scrtmp_sod_det.sod_domain
                                       AND sod_det.sod_nbr    = scrtmp_sod_det.sod_nbr
                                       AND sod_det.sod_line   = scrtmp_sod_det.sod_line NO-ERROR.
          IF NOT AVAIL sod_det
          THEN DELETE scrtmp_sod_det.
        END.
        
        FOR EACH sod_det NO-LOCK WHERE sod_det.sod_domain = scrtmp_so_mstr.so_domain
                                   AND sod_det.sod_nbr    = scrtmp_so_mstr.so_nbr,
           FIRST scrtmp_sod_det WHERE scrtmp_sod_det.sod_domain = sod_det.sod_domain
                                  AND scrtmp_sod_det.sod_nbr    = sod_det.sod_nbr
                                  AND scrtmp_sod_det.sod_line   = sod_det.sod_line:
          BUFFER-COPY sod_det
                   TO scrtmp_sod_det
               ASSIGN scrtmp_sod_det.operation = "N".
        END.                                   

        IF lUndoSo# = TRUE
        THEN DO:
          FIND FIRST so_mstr NO-LOCK WHERE so_mstr.so_domain = scrtmp_so_mstr.so_domain
                                       AND so_mstr.so_nbr    = scrtmp_so_mstr.so_nbr NO-ERROR.
          IF AVAIL so_mstr
          THEN DO:
            BUFFER-COPY so_mstr
                     TO scrtmp_so_mstr
                 ASSIGN scrtmp_sod_det.operation = "N".
          END.                 
        END.
        
        
      END.
      
      IF NOT lSave# THEN RETURN.      
  END.
  
  
  
  ASSIGN lAllClosed# = TRUE.
  CheckCloseOperation:
  FOR EACH scrtmp_sod_det WHERE scrtmp_sod_det.sod_qty_ord <> 0:
    ASSIGN dSodQtyInv# = fGetSodQtyInv(INPUT scrtmp_sod_det.sod_domain,
                                       INPUT scrtmp_sod_det.sod_nbr,
                                       INPUT scrtmp_sod_det.sod_line)
                                      l_flag  = yes . /* 8181 */
    IF (dSodQtyInv# < scrtmp_sod_det.sod_qty_ord 
       /* or (scrtmp_sod_det.sod_qty_ord < 0 and index(dtitle,"7.1.4") > 0)) INC09115 *//* 8980 */
       or scrtmp_sod_det.sod_qty_ord < 0) /* INC09115 */
       
    THEN DO:
      ASSIGN lAllClosed# = FALSE.
      LEAVE CheckCloseOperation.
    END.
  END.
  
  
  IF lAllClosed# = TRUE AND lInLastFrame# = FALSE and l_flag = yes /* 8181 */
  THEN DO:
    MESSAGE "Suppress save of line (order will be closed), save will be done in trailer frame.".
    RETURN.
  END.
  
  
  IF lShowSaveMessage# 
  THEN MESSAGE "Saving SO...".
      
  /* MLQ-00051 FIX */
  FOR EACH scrtmp_sod_det WHERE scrtmp_sod_det.sod_compl_stat <> "":
    /* MESSAGE SUBST("Salesorder line &1 is invoiced, skip Qxtend processing...",scrtmp_sod_det.sod_line).*/
    DELETE scrtmp_sod_det.
  END.
  
      
  RUN SaveDataToDSTT.

  
  RUN SaveMedlineSO IN hProc#
    (INPUT scrtmp_so_mstr.so_domain,
     INPUT DYNAMIC-FUNCTION("GetEntityForSite" IN hProc#, INPUT scrtmp_so_mstr.so_domain, scrtmp_so_mstr.so_site),
     INPUT THIS-PROCEDURE,
     INPUT-OUTPUT DATASET dsmaintainSalesOrder,
     INPUT-OUTPUT iCallID#,
     INPUT-OUTPUT iSeqnr#,
     OUTPUT cErro#).


  RUN SaveDataFromDSTT.  
  
  
  RUN SetPrintPPLOverRule IN hProc# (INPUT FALSE).
  
  /* MLQ-00051 FIX  -->  NOT REQUIRED ANYMORE, SOLVED IN zumlqxlib.p
  FOR EACH tt_so_mstr,
     EACH sod_det NO-LOCK WHERE sod_det.sod_domain = scrtmp_so_mstr.so_domain
                            AND sod_det.sod_nbr    = scrtmp_so_mstr.so_nbr:
                            
    FIND FIRST scrtmp_sod_det WHERE scrtmp_sod_det.sod_domain = sod_det.sod_domain
                                AND scrtmp_sod_det.sod_nbr    = sod_det.sod_nbr
                                AND scrtmp_sod_det.sod_line   = sod_det.sod_line NO-ERROR.    
    IF NOT AVAIL scrtmp_sod_det
    THEN DO:
      BUFFER-COPY sod_det
               TO scrtmp_sod_det
          ASSIGN scrtmp_sod_det.operation = "N".                                
    END.          
  END.
  */
  
  FOR EACH tt_so_mstr WHERE tt_so_mstr.operation = "A":
    PUBLISH "InitSoPrintPlForce" (INPUT tt_so_mstr.so_domain,
                                  INPUT tt_so_mstr.so_nbr,
                                  INPUT FALSE /* tt_so_mstr.so_print_pl */,
                                  OUTPUT cErroSoPPL#). 
    IF cErroSoPPL# <> ""
    THEN MESSAGE cErroSoPPL# VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END.   
  
  IF cErro# <> "" AND cErro# <> ? THEN
  DO:
      lErro# = TRUE.
      
      RUN zu/zupxmsg.p (" ERROR: Last transaction is not committed. ", cErro#, INPUT-OUTPUT lNoReply#).
  END.

  RUN SaveEmtData(OUTPUT lErro#).
  
  IF lShowSaveMessage#
  THEN MESSAGE "Saving SO done...".

END PROCEDURE.

PROCEDURE SavePartChangedComments:   

  DEFINE BUFFER cmt_det FOR cmt_det.

  DO ON ERROR UNDO, LEAVE:
    /*
    /* create comments to be printed on documents */
    cmtindx = next-value(cmt_sq01).
    find cmt_det no-lock where cmt_domain = domain
                           and cmt_indx   = cmtindx no-error.
    do while avail cmt_det:
      cmtindx = next-value(cmt_sq01).
      find cmt_det no-lock where cmt_domain = domain
                             and cmt_indx   = cmtindx no-error.
    end.
    */
    
    create scrtmp_sod_cmt_det.
    ASSIGN scrtmp_sod_cmt_det.dataLinkFieldPar = scrtmp_sod_det.dataLinkField
           scrtmp_sod_cmt_det.dataLinkField    = fgetNextDataLinkFieldID()
           scrtmp_sod_cmt_det.operation        = "A"
           scrtmp_sod_cmt_det.cmt_domain       = domain
           /* scrtmp_sod_cmt_det.cmt_indx   = cmtindx */
           scrtmp_sod_cmt_det.cd_ref          = scrtmp_sod_det.sod_nbr + "-" + string(scrtmp_sod_det.sod_line)
           scrtmp_sod_cmt_det.cmt_seq          = 1
           scrtmp_sod_cmt_det.cd_lang   = scrtmp_so_mstr.so_lang
           scrtmp_sod_cmt_det.cd_type   = ""
           scrtmp_sod_cmt_det.cmt_user1  = global_userid
           
           /* scrtmp_sod_cmt_det.cmt_print  = "SO,IN,PA" */
           scrtmp_sod_cmt_det.prt_on_so = TRUE
           scrtmp_sod_cmt_det.prt_on_invoice = TRUE
           scrtmp_sod_cmt_det.prt_on_packlist = TRUE
           .

    if can-do("DU,NL",scrtmp_so_mstr.so_lang) then scrtmp_sod_cmt_det.cmt_cmmt[1] =
     /* "Code '" + caps(scrtmp_sod_det.sod_part) + "' is gewijzigd. " +
      "Gelieve de CODE/VE aan te passen in uw systeem". CEPS-714 */
      /*** CEPS-714 ADD BEGINS ********************/
      "Art.'" + caps(scrtmp_sod_det.sod_part) + "' is gewijzigd. " +
      "Graag de data aanpassen in uw inkoopsysteem".
      /*** CEPS-714 ADD ENDS ********************/
    else if scrtmp_so_mstr.so_lang = "FR" then scrtmp_sod_cmt_det.cmt_cmmt[1] =
      "Cette réfèrence remplace la réfèrence '" + caps(scrtmp_sod_det.sod_part) + "'".
    else if can-do("DE,GE",scrtmp_so_mstr.so_lang) then scrtmp_sod_cmt_det.cmt_cmmt[1] =
      "Artikelcode '" + caps(scrtmp_sod_det.sod_part) + "' hat sich geändert. " +
      "Bitte in Ihrem System anpassen.".
    else if scrtmp_so_mstr.so_lang = "CZ" then scrtmp_sod_cmt_det.cmt_cmmt[1] =
      "Polozka '" + caps(scrtmp_sod_det.sod_part) + "' je nahrazna '" +
       caps(suse-item) + "', prosim aktualizujte si svuj system.".
    else scrtmp_sod_cmt_det.cmt_cmmt[1] = "Item '" + caps(scrtmp_sod_det.sod_part) + "' replaced by '" +
                      caps(suse-item) + "', please update your System".
    assign /* scrtmp_sod_det.sod_cmtindx = cmtindx */
           scrtmp_sod_det.sod_part = caps(suse-item)
            scrtmp_sod_det.sodcmmts    = "true".
           
    VALIDATE scrtmp_sod_cmt_det.
    VALIDATE scrtmp_sod_det.
  END.

END PROCEDURE.

form sonbr label " Order"
     scrtmp_so_mstr.so_cust  label " Customer"
     scrtmp_so_mstr.so_bill  label " Bill-To"
     scrtmp_so_mstr.so_ship  label " Ship-To"
     with frame a side-labels width 80 attr-space.

form scrtmp_so_mstr.so_ord_date    colon 16
     scrtmp_so_mstr.so_curr        colon 40 "   Entered by"
     scrtmp_so_mstr.so_lang        colon 69 skip
     scrtmp_so_mstr.so_req_date    colon 16
     scrtmp_so_mstr.so_site        colon 40
     scrtmp_so_mstr.so_userid               no-label
     reprice        colon 69 label "Reprice" skip
     /* prom-date      colon 16 label "Promise Date" RFC2142 */
     prom-date  colon 16   label "Perform Date" /* RFC2142 */ 
     scrtmp_so_mstr.so__chr10      colon 40 label "SA/CO/IN/RU"
     consume        colon 69 skip
     scrtmp_so_mstr.so_due_date    colon 16
     so-cmmts       colon 40 label "Comments"
     scrtmp_so_mstr.so_inv_nbr     colon 69 format "X(8)"
     scrtmp_so_mstr.so_po          colon 16
     scrtmp_so_mstr.so__chr08      colon 69 label "Time Service" skip
     scrtmp_so_mstr.so_rmks        colon 16 format "X(25)"
     cm-user1       colon 69 label "Group-Info" skip
     scrtmp_so_mstr.so_cr_terms    colon 16
     ct_description colon 40 format "X(35)" label "Description" skip
     scrtmp_so_mstr.so_daybookset  colon 16
     scrtmp_so_mstr.so_tax_env     colon 40 label "Tax-Env."
     scrtmp_so_mstr.so_tax_usage   colon 69 label "Tax-Usage" skip
     scrtmp_so_mstr.so_taxable     colon 16
     tax-in         colon 40 label "Including Tax"
     scrtmp_so_mstr.so_taxc        colon 69
     with frame b side-labels width 80.

form so-nbr               label " Order"
     scrtmp_so_mstr.so_cust              label "  Customer"
     scrtmp_so_mstr.so_bill              label " Bill-To"
     scrtmp_so_mstr.so_ship              label "  Ship-To" skip
     prom-date   colon 15 label "Promise-Date"
     scrtmp_so_mstr.so_site     colon 40
     reprice     colon 67 label "Reprice" skip
     scrtmp_so_mstr.so_due_date colon 15
     pr-txt      colon 40 label "Project"
     scrtmp_so_mstr.so_inv_nbr  colon 67 format "X(8)" skip
     scrtmp_so_mstr.so_rmks     colon 15
     scrtmp_so_mstr.so_userid   colon 67
     with frame ab side-labels width 80.

form ordr-line
     scrtmp_sod_det.sod_part     format "X(18)"
     scrtmp_sod_det.sod_qty_ord  format "->>>,>>9" column-label " Qty Ord."
     scrtmp_sod_det.sod_um
     scrtmp_sod_det.sod_um_conv  format ">>>,>>9" column-label "Contents"
     scrtmp_sod_det.sod_type
     scrtmp_sod_det.sod_list_pr  format "->>>,>>9.99<<<"
     scrtmp_sod_det.sod_disc_pct format "->>9.99"
     scrtmp_sod_det.sod_price    format "->>>,>>9.99<<<"
     with frame c.

form scrtmp_sod_det.sod_desc       colon 12
     scrtmp_sod_det.sod_lot                 label "Status" format "X(18)"
     line-amt             no-label format "-z,zzz,zz9.99"
     scrtmp_sod_det.sod_loc        colon 12
     scrtmp_sod_det.sod_pricing_dt colon 42 label "Pricing Date"
     scrtmp_sod_det.sod_consume    colon 68 label "Cons. Forecast"
     scrtmp_sod_det.sod_serial     colon 12 label "Batch-code"
     scrtmp_sod_det.sod_req_date   colon 42 label "Req Date"
     sod-cmmts      colon 68 label "Comments"
     scrtmp_sod_det.sod_qty_all    colon 12 label "Qty Alloc." format "->>,>>9"
     wh-loc                        colon 68 label "WMS Location" /*PMO2057*/
     /* scrtmp_sod_det.sod_per_date   colon 42 label "Promise Date" RFC2142*/
     /* OT-153 START ADDITION */
     scrtmp_sod_det.sod__qadc01    colon 12 label "Sales UoM" format "X(2)"
     /* OT-153 END ADDITION */
     scrtmp_sod_det.sod_per_date   colon 42 label "Perform Date" /* RFC2142 */ 
     scrtmp_sod_det.sod__chr10     colon 12 label "Project"
     scrtmp_sod_det.sod_due_date   colon 42 label "Due Date"
                    validate(scrtmp_sod_det.sod_due_date <> ? ,"Due-date is required")
     scrtmp_sod_det.sod_qty_pick   colon 68 label "Qty picked" format "->>,>>9"
     scrtmp_sod_det.sod_slspsn[1]  colon 12 label "Salesperson"
     acct-cc        colon 42 label "Sales Acct." format "X(12)"
     scrtmp_sod_det.sod_qty_ship   colon 68 label "Qty Shipped" format "->>,>>9"
     scrtmp_sod_det.sod_tax_usage  colon 12
     scrtmp_sod_det.sod_taxc       colon 42
     scrtmp_sod_det.sod_qty_inv    colon 68 label "To Invoice" format "->>,>>9"
     with frame d side-labels width 80.

/*8674 begin*/
form scrtmp_sod_det.sod__chr06     label "Unit Price" format "X(10)"
     with frame upr side-labels overlay col 29 row 10.
/*8674 end*/
/* RFC3012 ADD BEGINS */
form scrtmp_sod_det.sod__chr01     label "CIG Code" format "X(10)"
     with frame cig-fr side-labels overlay col 29 row 10.
/*8674 end*/

form scrtmp_so_mstr.so__chr05     label "CUP" format "X(15)"
     with frame cup-fr side-labels overlay col 29 row 10.
/*RFC-2550 START OF ADDITION *************************************************/
form 
   lvc_commit    label "Commitment Number" 
with frame f_commit side-labels overlay col 29 row 10.  
/*RFC-2550 END OF ADDITION ***************************************************/

/* OT-153 START ADDITION */
form 
   lvi_salesUMQty  label "Sales Qty Ord" format "->>>,>>9"
   lvc_salesUM     label "Sales UoM"      format "X(2)"  
with frame fr_salesUM side-labels overlay col 29 row 10.
/* OT-153 END ADDITION */

form consi-line
     cons-part format "X(14)"
     cons-lot
     cons-shipnr column-label "Ship-nbr"
     cons-shipdt column-label "Shipdate"
     cons-qty-oh column-label "Qty O.H." format "->,>>>,>>9"
     cons-qty-all column-label "Qty Alloca" format "->,>>>,>>9"
     with 10 down frame cons-fr.

form line-tot   colon 21 label "Line Total" format "-zzz,zzz,zzz,zz9.99" skip
     scrtmp_so_mstr.so_trl1_cd colon 16 label "Cost-Code 1"
     scrtmp_so_mstr.so_trl1_amt         label "" format "      -z,zzz,zz9.99"
     descr[1]          no-label skip
     scrtmp_so_mstr.so_trl2_cd colon 16 label "Cost-Code 2"
     scrtmp_so_mstr.so_trl2_amt         label "" format "      -z,zzz,zz9.99"
     descr[2]          no-label skip
     scrtmp_so_mstr.so_trl3_cd colon 16 label "Cost-Code 3"
     scrtmp_so_mstr.so_trl3_amt         label "" format "      -z,zzz,zz9.99"
     descr[3]          no-label skip
     vat-amt colon 21 label "Total VAT" format "-zzz,zzz,zzz,zz9.99" skip
     "===================" to 41 skip
     total-amt colon 21 label "Total" format "-zzz,zzz,zzz,zz9.99 CR"
     scrtmp_so_mstr.so_curr no-label skip(1)
     scrtmp_so_mstr.so_stat colon 21
             validate(scrtmp_so_mstr.so_stat = old-stat
                      or can-do(",HI,HD", scrtmp_so_mstr.so_stat)
          ,"Change from '" + old-stat + "' only allowed to blank, HI or HD")
     skip
     scrtmp_so_mstr.so__chr06 colon 21 format "X(8)" label "Invoice Printer" skip
     scrtmp_so_mstr.so_print_pl colon 21 skip
     print-conf colon 21 label "Print Confirmation"
     conf-prntr label " on Printer"
     with frame e side-labels width 80.

form fax-attn label "  Attendee" format "X(24)" skip
     fax-nbr  label "Fax-Number" format "X(24)"
     with frame faxnbr side-labels overlay col 10 row 10.

form scrtmp_sod_det.sod_line scrtmp_sod_det.sod_part scrtmp_sod_det.sod_qty_all scrtmp_sod_det.sod_um scrtmp_sod_det.sod_serial
     scrtmp_sod_det.sod_lot column-label "Reference" format "X(18)"
     with 10 down frame upd-bomd-line width 80
     title "< Please assign the right Lot/Serial and Reference Code >".

def query suse-qry-1 for suse-list.
def browse suse-brwse-1 query suse-qry-1
    display suse-part format "X(14)" column-label "Item"
            suse-avl column-label "avail" suse-um
            suse-price format "->>,>>9.99" column-label "CS-price"
            so-curr
            suse-conv format ">>>,>>9" column-label "Contents"
            with size-chars 55 by 10 no-box.
form suse-brwse-1
     with frame suse-a1 side-labels width 60
     title "Supersession-Items" overlay row 7 column 20.

def query price-qry-1 for price-list.
def browse price-brwse-1 query price-qry-1
    display price-lst format "X(8)" column-label "Source"
            price-code format "X(14)" column-label "List/Invoice"
            price-date column-label "Start-date"
            price-end column-label "Exp-date"
            price-curr format "X(4)" column-label "Curr"
            price-um format "X(2)" column-label "UM"
            price-amt column-label "Amount" format ">>>,>>9.99"
            with size-chars 64 by 10 no-box.
form price-brwse-1
     with frame price-a1 side-labels width 66 centered
     title "Pricing Details" overlay row 5.

def query addr-qry-1 for addr-list.
def browse addr-brwse-1 query addr-qry-1
  display addr-list.name format "X(26)" column-label "Name"
          addr-list.addr format "X(52)" column-label "Address"
          addr-list.city format "X(22)" column-label "City"
  with size-chars 100 by 10 no-box. /*7747*/
form addr-brwse-1
  with frame addr-a1 side-labels width 102 centered
  title "Address Bill-To" overlay row 5.
/*7747 end*/

form space ad_mstr.ad_name format "X(37)" skip
     space ad_mstr.ad_line1 format "X(37)" skip
     space ad_mstr.ad_line2 format "X(37)" skip
     space ad_mstr.ad_line3 format "X(37)" skip
     space ad_mstr.ad_city format "X(37)"
     with frame sold_to no-labels title " Customer ".

form space ad_mstr.ad_name format "X(37)" skip
     space ad_mstr.ad_line1 format "X(37)" skip
     space ad_mstr.ad_line2 format "X(37)" skip
     space ad_mstr.ad_line3 format "X(37)" skip
     space ad_mstr.ad_city format "X(37)"
     with frame ship_to no-labels title " Ship-To " col 41.

form space ad_mstr.ad_name format "X(37)" skip
     space ad_mstr.ad_line1 format "X(37)" skip
     space ad_mstr.ad_line2 format "X(37)" skip
     space ad_mstr.ad_line3 format "X(37)" skip
     space ad_mstr.ad_city format "X(37)"
     with frame bill_to no-labels title " Bill-To " col 41.

form compl-nbr colon 22 label "Complaint-Number"
with frame proj-cmmt side-labels centered overlay row 4
title "Enter complaint number".

form corr-code label "Correction reason code" skip
   corr-reason label "Description"
   with frame es-corr-reason side-labels centered overlay row 4
   title "Correction Reason".

def query corr-qry-1 for code_mstr.
def browse corr-brwse-1 query corr-qry-1
    display code_mstr.code_value code_mstr.code_cmmt no-label
            with size-chars 52 by 7 no-box.
form corr-brwse-1
     with frame corr-a1 centered title " Select the Correction Reason "
     overlay row 5.

if index(dtitle,"7.1.4") = 0 
then ASSIGN emt-maint      = yes.
            
if index(dtitle,"7.1.4") > 0 
then ASSIGN lAllowBlocked# = TRUE.            
/*SCQ-1369 STARTS*/
if index(dtitle,"99.7.1.14") > 0 
then ASSIGN 
    lv_emt = TRUE.
if lv_emt = yes 
then assign
     emt-maint = no
     lAllowBlocked# = TRUE.
/*SCQ-1369 ends*/ 
        for first code_mstr 
           where code_domain = global_domain
           and   code_fldname = "ASID_BONZ" no-lock:
        end.
        if avail code_mstr
        then do:
             assign lv_avail = yes.
             if code_value = "Temp1"
             then lv_temp = no.
             else lv_temp = yes.
        end.      
            
if can-do("veena,weija",global_userid) then do:
  update emt-maint label "7.1.1" time-out with frame xxx.
  hide frame xxx.
end.

assign old-domain = global_domain
       domain = global_domain.

if search (intf-dir + server-id + "/old-aims") <> ? then do:
  input from value(intf-dir + server-id + "/old-aims").
  import unformatted old-aims.
  input close.
end.
if search (intf-dir + server-id + "/new-aims") <> ? then do:
  input from value(intf-dir + server-id + "/new-aims").
  import unformatted new-aims.
  input close.
end.

ware-houses = old-aims.
if old-aims <> "" then ware-houses = ware-houses + "," + new-aims.
else ware-houses = new-aims.

find usr_mstr no-lock where usr_userid = global_userid.
mail-from = usr_mail_address.

find udd_det no-lock where udd_userid = global_userid
                       and udd_domain = domain no-error.
if avail udd_det then do:
  usr-groups = udd_groups.
  if can-do(udd_groups,"MinPrice") then min-pr-grp = yes.
  if can-do(udd_groups,"ManagerCS") then cs-manager = yes.
end.

find first soc_ctrl no-lock where soc_domain = domain.
sod-lcmmts = soc_lcmmts.

function test-field-access returns log (input field-name as char):
  if can-find(flpw_mstr where flpw_domain = domain
                          and flpw_field = field-name
                          and flpw_userid = global_userid) then return yes.
  if not can-find(first flpw_mstr where flpw_domain = domain
                              and flpw_field = field-name) then return yes.
  return no.
end function.

assign field-acc[01] = test-field-access("so_curr")
       field-acc[02] = test-field-access("sod_site")
       field-acc[03] = test-field-access("so__chr10")
       field-acc[04] = test-field-access("so-cmmts")
       field-acc[05] = test-field-access("so_lang")
       field-acc[06] = test-field-access("so_cr_terms")
       field-acc[07] = test-field-access("sod_consume")
       field-acc[08] = test-field-access("sod_list_pr")
       field-acc[09] = test-field-access("discount")
       field-acc[10] = test-field-access("sod_price")
       field-acc[11] = test-field-access("sod_acct")
       field-acc[12] = test-field-access("sod_cc")
       field-acc[13] = test-field-access("sod_dsc_acct")
       field-acc[14] = test-field-access("sod_dsc_cc")
       field-acc[15] = test-field-access("sod_type")
       field-acc[16] = test-field-access("sod_um_conv")
       field-acc[17] = test-field-access("sod_taxable")
       field-acc[18] = test-field-access("sod_taxc")
       field-acc[19] = test-field-access("sod_tax_usage")
       field-acc[20] = test-field-access("sod_tax_env")
       field-acc[21] = test-field-access("sod_tax_in")
       field-acc[22] = test-field-access("sod__chr10")
       field-acc[23] = test-field-access("so_taxable")
       field-acc[24] = test-field-access("so_tax_usage")
       field-acc[25] = test-field-access("so_taxc")
       field-acc[26] = test-field-access("so_tax_env")
       field-acc[27] = test-field-access("so_daybookset").

sonbr = global-so-nbr.

hide frame dtitle no-pause.


ON END-ERROR OF FRAME e DO:
  DEFINE BUFFER so_mstr FOR so_mstr.

  /*
  DEFINE VARIABLE lPrintPl# AS LOGICAL     NO-UNDO INIT ?.

  RUN SetPrintPPLOverRule IN hProc# (INPUT FALSE).
  
  IF AVAIL scrtmp_so_mstr AND
     VALID-HANDLE(SELF) AND
     (SELF:NAME = "e" OR (VALID-HANDLE(SELF:FRAME) AND SELF:FRAME:NAME = "e")) /* Trailer frame */
  THEN DO:

        
    PUBLISH "GetOldDbPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                               INPUT scrtmp_so_mstr.so_nbr,
                               OUTPUT lPrintPl#).
                               
    ASSIGN scrtmp_so_mstr.so_print_pl = lPrintPl#.
    DISPLAY scrtmp_so_mstr.so_print_pl WITH FRAME e.
  END.    
  */
  
  IF NOT 
     (AVAIL scrtmp_so_mstr AND
      CAN-FIND(FIRST so_mstr NO-LOCK WHERE so_mstr.so_domain = scrtmp_so_mstr.so_domain AND so_mstr.so_nbr = scrtmp_so_mstr.so_nbr) = FALSE AND
      CAN-FIND(FIRST scrtmp_sod_det) = FALSE
     )
  THEN DO:
    MESSAGE "".
    MESSAGE "".
    MESSAGE "Sales order changes will not be saved on F4 , use F1 to continue.".
    RETURN NO-APPLY.
  END.
  
END.

ON GO OF FRAME e DO:
  RUN SetPrintPPLOverRule IN hProc# (INPUT TRUE).
END.

PROCEDURE CheckSodUm:
  DEFINE BUFFER csod_det FOR sod_det.
  DEFINE VARIABLE net-price AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE list-pr   AS DECIMAL     NO-UNDO.
  
  IF AVAIL scrtmp_so_mstr AND
     AVAIL scrtmp_sod_det 
  THEN DO WITH FRAME c:
    
    FIND FIRST csod_det NO-LOCK WHERE csod_det.sod_domain = scrtmp_sod_det.sod_domain
                                  AND csod_det.sod_nbr    = scrtmp_sod_det.sod_nbr
                                  AND csod_det.sod_line   = scrtmp_sod_det.sod_line NO-ERROR.
    IF AVAIL csod_det AND
       scrtmp_sod_det.sod_um:SCREEN-VALUE IN FRAME c  <> csod_det.sod_um
    THEN DO:
      ASSIGN scrtmp_sod_det.sod_um
             scrtmp_sod_det.sod_qty_ord
             scrtmp_sod_det.sod_part.
      
      IF lRollBack THEN   
        run "zu/zuprice.p" (no,
                            domain,
                            scrtmp_so_mstr.so_site,
                            scrtmp_so_mstr.so_cust,
                            scrtmp_so_mstr.so_curr,
                            scrtmp_sod_det.sod_part,
                            scrtmp_sod_det.sod_qty_ord,
                            scrtmp_sod_det.sod_um:SCREEN-VALUE IN FRAME c,
                            scrtmp_sod_det.sod_pricing_dt,
                            output list-pr,
                            output net-price).    
      ELSE DO: 
        net-price = 0.      
        FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                                AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                                AND ttApiPrice.ttpart = scrtmp_sod_det.sod_part
                                EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE ttApiPrice THEN DO:
          ./ MESSAGE "Get API price 1" VIEW-AS ALERT-BOX.
      li_surcacc = 0 . /* mulof */
          /* cError = GetItemPrice(scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_curr,scrtmp_sod_det.sod_part,STRING(scrtmp_sod_det.sod_qty_ord),scrtmp_sod_det.sod_pricing_dt). palletd*/
      cError = GetItemPrice(scrtmp_so_mstr.so_cust,
                            scrtmp_so_mstr.so_curr,
                scrtmp_sod_det.sod_part,
                STRING(scrtmp_sod_det.sod_qty_ord),
                STRING(scrtmp_sod_det.sod_um_conv), 
                scrtmp_sod_det.sod_pricing_dt). /* palletd */
          IF cError = "" THEN 
            FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                                AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                                AND ttApiPrice.ttpart = scrtmp_sod_det.sod_part                                
                                EXCLUSIVE-LOCK NO-ERROR.                   
          ELSE 
            ASSIGN scrtmp_sod_det.sod__chr02 = cError.  
        END.
        ./ MESSAGE ttApiPrice.ttPriceId " priceID 1" VIEW-AS ALERT-BOX.
        IF AVAILABLE ttApiPrice 
    THEN do: /* surcharge */
          ASSIGN net-price = ttApiPrice.ttprice * GetUomConv(scrtmp_sod_det.sod_part,scrtmp_sod_det.sod_um:SCREEN-VALUE IN FRAME c)
                 /* scrtmp_sod_det.sod__chr07 = IF ttApiPrice.ttPriceId NE 0 THEN STRING(ttApiPrice.ttPriceID) ELSE "0"
                 scrtmp_sod_det.sod__chr08 = IF ttApiPrice.ttDiscId NE 0 THEN STRING(ttApiPrice.ttDiscID) ELSE "0" */ 
                 scrtmp_sod_det.sod__chr02 = "OK"
         /*scrtmp_sod_det.sod__chr06 = string(ttApiPrice.ttprice) /* RFC-3012 */  CEPS-301*/
                 . 
           
          /* surcharge ADD BEGINS */
          if ttapiprice.ttsurchargeperc ne 0                           
         and  not can-find(first xxsurc_det                     
      where xxsurc_domain = scrtmp_sod_det.sod_domain         
        and xxsurc_cust   = scrtmp_so_mstr.so_cust            
        and xxsurc_part   = scrtmp_sod_det.sod_part           
        and xxsurc_nbr    = scrtmp_sod_det.sod_nbr            
        and xxsurc_line   = scrtmp_sod_det.sod_line)          
      then                                                       
         cError = GetItemPrice(scrtmp_so_mstr.so_cust,            
                               scrtmp_so_mstr.so_curr,            
                          scrtmp_sod_det.sod_part,           
                         STRING(scrtmp_sod_det.sod_qty_ord),
                   STRING(scrtmp_sod_det.sod_um_conv), /* palletd */
                        scrtmp_sod_det.sod_pricing_dt).    
            
    end.     
    /* surcharge ADD ENDS */

        ELSE DO:       
          IF cError NE "" THEN 
            ASSIGN scrtmp_sod_det.sod__chr02 = cError.          
        END.
        
      END.

      ASSIGN scrtmp_sod_det.sod_list_pr    = net-price
             scrtmp_sod_det.sod_price      = net-price
             scrtmp_sod_det.sod_pricing_dt = TODAY             
             scrtmp_sod_det.sod__chr07     = IF ttApiPrice.ttPriceId NE 0 THEN STRING(ttApiPrice.ttPriceID) ELSE "0"
             scrtmp_sod_det.sod__chr08     = IF ttApiPrice.ttDiscId NE 0 THEN STRING(ttApiPrice.ttDiscID) ELSE "0"
         scrtmp_sod_det.sod__chr04 = if ttapiprice.ttsurchargeperc ne 0
                                     then string(ttapiprice.ttsurchargeperc) else "0" /* surcharge */
             scrtmp_so_mstr.so_reprice     = TRUE.                              
             
             
      DISPLAY scrtmp_sod_det.sod_list_pr scrtmp_sod_det.sod_price  WITH FRAME c.
      DISPLAY scrtmp_sod_det.sod_pricing_dt  WITH FRAME d.
    END.
  END.  
  
END PROCEDURE.  

/*
ON GO, LEAVE, RETURN OF THIS-PROCEDURE DO:
  
  DEFINE BUFFER csod_det FOR sod_det.
  DEFINE VARIABLE net-price AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE list-pr   AS DECIMAL     NO-UNDO.

  IF AVAIL scrtmp_so_mstr AND
     AVAIL scrtmp_sod_det AND
     VALID-HANDLE(SELF) AND
     VALID-HANDLE(SELF:FRAME) AND
     SELF:FRAME:NAME = "c" /* Frame LINE / UM */
  THEN DO WITH FRAME c:
    FIND FIRST csod_det NO-LOCK WHERE csod_det.sod_domain = scrtmp_sod_det.sod_domain
                                  AND csod_det.sod_nbr    = scrtmp_sod_det.sod_nbr
                                  AND csod_det.sod_line   = scrtmp_sod_det.sod_line NO-ERROR.
    IF AVAIL csod_det AND
       scrtmp_sod_det.sod_um:SCREEN-VALUE IN FRAME c  <> csod_det.sod_um
    THEN DO:
      ASSIGN scrtmp_sod_det.sod_um
             scrtmp_sod_det.sod_qty_ord
             scrtmp_sod_det.sod_part.
      
      run "zu/zuprice.p" (no,
                          domain,
                          scrtmp_so_mstr.so_site,
                          scrtmp_so_mstr.so_cust,
                          scrtmp_so_mstr.so_curr,
                          scrtmp_sod_det.sod_part,
                          scrtmp_sod_det.sod_qty_ord,
                          scrtmp_sod_det.sod_um:SCREEN-VALUE IN FRAME c,
                          scrtmp_sod_det.sod_pricing_dt,
                          output list-pr,
                          output net-price).    
    
      assign scrtmp_sod_det.sod_list_pr    = net-price
             scrtmp_sod_det.sod_price      = net-price
             scrtmp_sod_det.sod_pricing_dt = today
             scrtmp_so_mstr.so_reprice     = TRUE
             .
             
      DISPLAY scrtmp_sod_det.sod_list_pr scrtmp_sod_det.sod_price  WITH FRAME c.
      DISPLAY scrtmp_sod_det.sod_pricing_dt  WITH FRAME d.
    END.
  END.
  RETURN.
END.
*/


ON CLOSE OF THIS-PROCEDURE DO:

  RUN SetLocalSoLock (INPUT ?,
                      INPUT ?,
                      OUTPUT cErro#).

  RUN ClearLocks IN hProc# (INPUT THIS-PROCEDURE).
    tmpsonbr = ?.
    run "zu/zuordnum.p" ("ClearNumLock",domain,input-output tmpsonbr,INPUT SessionUniqueID,
                            output sosite,
                            output ret-err).
END.


RUN InitSoPPL IN hRunProc# (INPUT THIS-PROCEDURE) NO-ERROR.

order-entry:
repeat:

  DO on error undo, retry
     ON STOP UNDO order-entry, LEAVE order-entry:


            
     
    hide frame b.
    hide frame ship_to.
    hide frame bill_to.
    view frame a.
    clear frame a all no-pause.
    view frame sold_to.
    clear frame sold_to all no-pause.
    view frame ship_to.
    clear frame ship_to all no-pause.
    view frame b.
    clear frame b all no-pause.

    assign new-order = no
           print-conf = no
           tax-in = no
           sls-rep = no
           cm-type = "".

    for each cons-ld:
      delete cons-ld.
    end.

    RUN ClearLocks IN hProc# (INPUT THIS-PROCEDURE).
    tmpsonbr = ?.
    run "zu/zuordnum.p" ("ClearNumLock",domain,input-output tmpsonbr,INPUT SessionUniqueID,
                            output sosite,
                            output ret-err).

    find first soc_ctrl no-lock where soc_domain = domain.
    
    
    ASSIGN glCIGCodeEnabled# = FALSE
           glCUPCodeEnabled# = FALSE.    
    FOR EACH code_mstr NO-LOCK WHERE code_mstr.code_domain  = "XX"
                                 AND code_mstr.code_fldname = "XX-EINVOICE-ENABLE-CIG"
                                 AND code_mstr.code_value   = domain
                                 AND code_mstr.code_cmmt    = domain:
      ASSIGN glCIGCodeEnabled# = TRUE.                                 
    END.
    
    FOR EACH code_mstr NO-LOCK WHERE code_mstr.code_domain  = "XX"
                                 AND code_mstr.code_fldname = "XX-EINVOICE-ENABLE-CUP"
                                 AND code_mstr.code_value   = domain
                                 AND code_mstr.code_cmmt    = domain:
      ASSIGN glCUPCodeEnabled# = TRUE.                                 
    END.    
    
    ASSIGN rRowid# = ?.
    
    FOR EACH tt-sod_cosign:
      DELETE tt-sod_cosign.
    END.
    
    RUN SetLocalSoLock (INPUT ?,
                        INPUT ?,
                        OUTPUT cErro#).
                        
    /* Set wh-domain, emt-order Default, when required these flages will be overruled below in the process */
    ASSIGN emt-ordr = TRUE.
    IF domain <> "HQ" 
    THEN ASSIGN wh-domain = "HQ".
        
    UPDATE sonbr with FRAME a
    editing:
       
       ASSIGN cErroSoPPL# = "".
       PUBLISH "ResetSoPrintPl" (OUTPUT cErroSoPPL#) .
       IF cErroSoPPL# <> ""
       THEN DO:
         MESSAGE cErroSoPPL#
              VIEW-AS ALERT-BOX WARNING BUTTONS OK.
       END.  
       
 /*******************************
      IF RETRY THEN
      DO:
          MESSAGE 'retry!'
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      END.
                     
      IF LASTKEY = 404 AND lKeepPrintPl# = TRUE AND cSoNbrOld# <> "" THEN
      DO TRANSACTION
        ON ERROR UNDO, RETURN ERROR:
        
       
        
       RUN RestorePrintPl.
       /*
       find blu_so_mstr where blu_so_mstr.so_domain = domain
                     and blu_so_mstr.so_nbr = cSoNbrOld# no-error.
       if avail blu_so_mstr then DO:
            blu_so_mstr.so_print_pl = lKeepPrintPl#. 
            RELEASE blu_so_mstr.
       END.
       
       if emt-ordr = yes 
       then DO:
         find blu_so_mstr where blu_so_mstr.so_domain = wh-domain
                       and blu_so_mstr.so_nbr = cSoNbrOld# no-error.
         if avail blu_so_mstr 
         then DO:
            blu_so_mstr.so_print_pl = lKeepPrintPl#. 
            RELEASE blu_so_mstr.
         END.
       end.
       */
      END.

      ASSIGN lKeepPrintPl# = ?
             cSoNbrOld# = "".      
*******************************/
             
      
            /* ALLOW LAST SO NUMBER REFRESH 
      if keyfunction(lastkey) = "RECALL" or lastkey = 307
      then
         display
            sonbr @ scrtmp_so_mstr.so_nbr
         with frame a.                      */
         
      FIND FIRST so_mstr NO-LOCK WHERE so_mstr.so_domain = domain AND so_mstr.so_nbr = sonbr:SCREEN-VALUE NO-ERROR.
      IF AVAIL so_mstr THEN rRowid# = ROWID(so_mstr).
      
      {us/zu/zubrsowinc.i so_mstr so_nbr "so_mstr.so_domain = domain and
                            ((so_mstr.so__chr04 = 'avsodmnt.p' and emt-maint = true) or
                          (so_mstr.so__chr04 = 'avsodmnt.m' and emt-maint = false) OR can-do('mfg,harinkp,petersm',global_userid) ) and
                                     (so_mstr.so_userid = global_userid or
                             can-do('veena,weija,derkseng,mfg,harinkp,petersm',global_userid))"
                              so_mstr.so_nbr "input sonbr" "Index"}
      
      IF rRowid# = ? THEN DO:
          FIND FIRST so_mstr NO-LOCK WHERE so_mstr.so_domain = domain AND so_mstr.so_nbr = sonbr:SCREEN-VALUE NO-ERROR.
          IF AVAIL so_mstr THEN rRowid# = ROWID(so_mstr).
      END.

      if keyfunction(lastkey) = "END-ERROR" THEN LEAVE order-entry.
      
      else if rRowid# <>  ? AND AVAIL so_mstr then do:
        FOR EACH scrtmp_so_mstr:
            DELETE scrtmp_so_mstr.
        END.
        for EACH scrtmp_sod_det:
            DELETE scrtmp_sod_det.
        END.
        FOR EACH scrtmp_sod_cmt_det:
          DELETE scrtmp_sod_cmt_det.
        END.
        CREATE scrtmp_so_mstr.
        BUFFER-COPY so_mstr TO scrtmp_so_mstr
              ASSIGN scrtmp_so_mstr.dataLinkField = fgetNextDataLinkFieldID()
                     scrtmp_so_mstr.operation     = "N".
        FOR EACH sod_det NO-LOCK WHERE sod_det.sod_domain = so_mstr.so_domain AND sod_det.sod_nbr = so_mstr.so_nbr BY sod_det.sod_line:
            CREATE scrtmp_sod_det.
            BUFFER-COPY sod_det TO scrtmp_sod_det
            ASSIGN scrtmp_sod_det.dataLinkFieldPar = scrtmp_so_mstr.dataLinkField
                   scrtmp_sod_det.operation        = "N"
                   scrtmp_sod_det.dataLinkField    = fgetNextDataLinkFieldID()
                   .
        END.
        

        display scrtmp_so_mstr.so_nbr @ sonbr scrtmp_so_mstr.so_cust scrtmp_so_mstr.so_bill scrtmp_so_mstr.so_ship with frame a.
        find ad_mstr no-lock where ad_mstr.ad_domain = domain
                               and ad_mstr.ad_addr   = scrtmp_so_mstr.so_cust no-error.
        if avail ad_mstr then do:
          display ad_mstr.ad_name ad_mstr.ad_line1 ad_mstr.ad_line2 ad_mstr.ad_line3
                          ad_mstr.ad_zip + "  " + ad_mstr.ad_city @ ad_mstr.ad_city
                          with frame sold_to.
          find cm_mstr no-lock where cm_mstr.cm_domain = domain
                                 and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust no-error.
          if avail cm_mstr then display cm_mstr.cm_user1 @ cm-user1 with frame b. 
        end.

        find ad_mstr no-lock where ad_mstr.ad_domain = domain
                               and ad_mstr.ad_addr = scrtmp_so_mstr.so_ship no-error.
        if avail ad_mstr then do: 
            disp ad_mstr.ad_name ad_mstr.ad_line1 ad_mstr.ad_line2 ad_mstr.ad_line3
                 ad_mstr.ad_zip + "  " + ad_mstr.Ad_city @ ad_mstr.ad_city
                 with frame ship_to.
            shipctry = trim(caps(ad_mstr.ad_ctry)).
        end.

        if (scrtmp_so_mstr.so_cmtindx = ? or scrtmp_so_mstr.so_cmtindx = 0) then so-cmmts = no.
        else so-cmmts = yes.

        find first ct_mstr where ct_domain = domain
                             and ct_code = scrtmp_so_mstr.so_cr_terms
        no-lock no-error.
        if avail ct_mstr then
           ct_description = ct_desc.
         
        display scrtmp_so_mstr.so_ord_date scrtmp_so_mstr.so_req_date scrtmp_so_mstr.so_due_date scrtmp_so_mstr.so__chr10 scrtmp_so_mstr.so_curr
                scrtmp_so_mstr.so_lang scrtmp_so_mstr.so_site scrtmp_so_mstr.so_cr_terms scrtmp_so_mstr.so_po scrtmp_so_mstr.so__chr08 so-cmmts
                scrtmp_so_mstr.so_rmks scrtmp_so_mstr.so_inv_nbr scrtmp_so_mstr.so_taxable scrtmp_so_mstr.so_tax_usage scrtmp_so_mstr.so_taxc
                scrtmp_so_mstr.so_tax_env scrtmp_so_mstr.so_userid ct_description
                scrtmp_so_mstr.so_daybookset with frame b.

        find last scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                                    and scrtmp_sod_det.sod_nbr = sonbr no-error.
        if avail scrtmp_sod_det then display scrtmp_sod_det.sod_per_date @ prom-date with frame b.
        else display ? @ prom-date with frame b.

        find first scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                                     and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr no-error.
        if avail scrtmp_sod_det then display scrtmp_sod_det.sod_tax_in @ tax-in with frame b.
        else display no @ tax-in with frame b.
      end. /* IF rRowid# <> ? */

    end. /* update sonbr editing */

    
    
    if lastkey = -1 or keyfunction(lastkey) = "END-ERROR" then LEAVE order-entry.

    run "zu/zuordnum.p" ("FindNum",domain,input-output sonbr,INPUT SessionUniqueID,
                                output sosite,
                                output ret-err).

    if ret-err then sonbr = "".
    if sonbr = "" then next order-entry.
    
    sonbr = caps(sonbr).
    display sonbr with frame a.

    
    
    RUN SetLocalSoLock (INPUT domain,
                        INPUT sonbr:SCREEN-VALUE IN FRAME a,
                        OUTPUT cErroSoPPL#).
    IF cErroSoPPL# <> ""
    THEN DO:
      MESSAGE cErroSoPPL#
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      UNDO order-entry, RETRY order-entry.            
    END.                        
                        
    
    
    tax-date = today.

    FIND FIRST so_mstr NO-LOCK WHERE so_mstr.so_domain = domain AND so_mstr.so_nbr = sonbr NO-ERROR.

    if not avail so_mstr then do:

      FOR EACH scrtmp_so_mstr:
        DELETE scrtmp_so_mstr.
      END.
      for EACH scrtmp_sod_det:
        DELETE scrtmp_sod_det.
      END.    
      FOR EACH scrtmp_sod_cmt_det:
        DELETE scrtmp_sod_cmt_det.
      END.
    
      clear frame sold_to.
      clear frame ship_to.
      clear frame b.
      message "Adding new Record".
     
      create scrtmp_so_mstr.
      assign new-order = true
             scrtmp_so_mstr.dataLinkField = fgetNextDataLinkFieldID()
             scrtmp_so_mstr.so_domain = domain
             scrtmp_so_mstr.operation = "A"
             scrtmp_so_mstr.so_nbr = sonbr
             scrtmp_so_mstr.so_ord_date = today
             scrtmp_so_mstr.so_userid = global_userid
             scrtmp_so_mstr.so_print_pl = no
             scrtmp_so_mstr.so_print_so = yes
             scrtmp_so_mstr.so_partial = yes
             scrtmp_so_mstr.so_fix_pr = yes
             scrtmp_so_mstr.so_fix_rate = no
             scrtmp_so_mstr.so_conf_date = today
             /* scrtmp_so_mstr.so_inv_mthd = "p n" */
             scrtmp_so_mstr.so_conrep = " 000,00"
             scrtmp_so_mstr.so_daybookset = "SLS"
             old-due-date = ?
             l_oldper   = ? /* RFC2142 */           
             old-print-pl = yes
             prom-date = ?
             consume = yes
             scrtmp_so_mstr.so__chr04 = "avsodmnt.p"
             so-cmmts = soc_hcmmts
             scrtmp_so_mstr.so_due_date = today + soc_shp_lead
             scrtmp_so_mstr.so_priced_dt = today
             scrtmp_so_mstr.so_pricing_dt = today
             scrtmp_so_mstr.so_inv_nbr = ""
             scrtmp_so_mstr.so_invoiced = no
             scrtmp_so_mstr.so_taxable = yes
             scrtmp_so_mstr.so_tax_env = ""
             scrtmp_so_mstr.so_tax_usage = ""
             scrtmp_so_mstr.so_cmtindx = 0
             wh-domain = scrtmp_so_mstr.so_domain
          .
         
      if emt-maint = no then scrtmp_so_mstr.so__chr04 = "avsodmnt.m".
      
      /*
      run "av/avwhsite2.p" (domain,
                            scrtmp_so_mstr.so_site,
                            scrtmp_so_mstr.so__chr10,
                            output wh-site,
                            output wh-domain,
                            output emt-ordr) .   
      */    
      RUN GetWhseSite (INPUT domain,
                       INPUT BUFFER scrtmp_so_mstr:HANDLE,
                       INPUT ?,
                       INPUT ?,
                       INPUT FALSE,
                       INPUT-OUTPUT wh-site,
                       INPUT-OUTPUT wh-domain,
                       INPUT-OUTPUT emt-ordr,
                       OUTPUT lWhseOk#) .
      IF lWhseOk# = FALSE
      THEN UNDO order-entry, RETRY order-entry.         
                        
                            
      ASSIGN cErroSoPPL# = "".
      PUBLISH "InitSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                               INPUT scrtmp_so_mstr.so_nbr,
                               INPUT old-print-pl /* scrtmp_so_mstr.so_print_pl */,
                               OUTPUT cErroSoPPL#).
      IF cErroSoPPL# <> ""
      THEN DO:
        MESSAGE cErroSoPPL#
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        ASSIGN sonbr = "".
        UNDO order-entry, RETRY order-entry.         
      END.
      
      
    end. /* IF NOT avail SO_MSTR */
    else do: /* IF avail SO_MSTR */

      
      ASSIGN old-print-pl = scrtmp_so_mstr.so_print_pl.
      
      ASSIGN cErroSoPPL# = "".
      PUBLISH "InitSoPrintPl" (INPUT domain,
                               INPUT sonbr,
                               INPUT FALSE,
                               OUTPUT cErroSoPPL#).
                               
      IF cErroSoPPL# <> ""
      THEN DO:
        MESSAGE cErroSoPPL#
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        ASSIGN sonbr = "".
        UNDO order-entry, RETRY order-entry.         
      END.                               

      /*                               
      IF  emt-ordr 
      THEN PUBLISH "InitSoPrintPl" (INPUT wh-domain,
                                    INPUT sonbr,
                                    INPUT FALSE).
      */
        
      /*****************
      DO TRANSACTION
        ON ERROR UNDO, RETURN ERROR:

        
       find bl_so_mstr where bl_so_mstr.so_domain = domain
                     and bl_so_mstr.so_nbr = sonbr no-error.
       if avail bl_so_mstr then DO:
           lKeepPrintPl# = bl_so_mstr.so_print_pl.
           csonbrOld# = bl_so_mstr.so_nbr.
            bl_so_mstr.so_print_pl = no.       
            RELEASE bl_so_mstr.
       END.
       
       if emt-ordr = yes 
       then DO:
         find bl_so_mstr where bl_so_mstr.so_domain = wh-domain
                       and bl_so_mstr.so_nbr = sonbr no-error.
         if avail bl_so_mstr 
         then DO:
            bl_so_mstr.so_print_pl = no. 
            RELEASE bl_so_mstr.
         END.
       end.
      END. 
      *****************/
      

      if scrtmp_so_mstr.so_compl_stat <> ""
      then do:
        MESSAGE "This salesorder has completion status: " scrtmp_so_mstr.so_compl_stat SKIP(1)
                "Update of this salesorder is not allowed."
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.
                /*
        display "This salesorder has completion status: " scrtmp_so_mstr.so_compl_stat NO-LABEL  skip
                "Update is not allowed." skip(1)
                 with frame ynsoComp SIDE-LABELS OVERLAY CENTERED /* ROW 10 COL 7 */.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame ynsoComp.
        hide frame ynsoComp no-pause.
        */
        UNDO order-entry, RETRY order-entry.
      end.      

    
       RUN SetSoLocks IN hProc# (INPUT domain, INPUT sonbr, INPUT THIS-PROCEDURE, OUTPUT cErro#).
      /* {us/bbi/gprun.i ""zusosetblk.p"" "(INPUT domain, INPUT sonbr, OUTPUT cErro#, OUTPUT lOk#)"} */

      if emt-maint and scrtmp_so_mstr.so__chr04 = "avsodmnt.m" then do:
        display "This Order has NOT been created by this program !!!" skip
                "It was created by program '7.1.4'" format "X(50)"
           skip "Please use that program for this Order ..." skip(1)
                 with frame yn0011 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn0011.
        hide frame yn0011 no-pause.
      end.
      else if not emt-maint and scrtmp_so_mstr.so__chr04 = "avsodmnt.p" then do:
        display "This Order has NOT been created by this program !!!" skip
                "It was created by program '7.1.1'" format "X(50)"
           skip "Please use that program for this Order ..." skip(1)
                 with frame yn0012 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn0012.
        hide frame yn0012 no-pause.
      end.
      else if not scrtmp_so_mstr.so__chr04 begins "avsodmnt" then do:
        display "This Order was (probably) created with program 7.13.14,"
           skip "it must (probably) only be invoiced (properly) ..." skip
                "or maybe only deleted !!!..." skip(1)
                 with frame yn0013 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn0013.
        hide frame yn0013 no-pause.
      end.
      ELSE IF scrtmp_so_mstr.so__chr10 = "DROPSHIP" THEN DO:
          display "This Order was has ordertype DROPSHIP,"
             skip "This type cannot be maintaintd in this program !!!..." skip(1)
                   with frame yn0014 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn0014.
          hide frame yn0014 no-pause.
      END.
      else yn = "Yes".
      if not yn begins "Y" then undo order-entry, retry order-entry.

      message "Editing existing Record.".

      assign tax-in = no
             prom-date = ?
             consume = yes
             old-due-date = scrtmp_so_mstr.so_due_date
             l_oldper     = scrtmp_so_mstr.so_per_date /* RFC2142 */
             scrtmp_so_mstr.so_print_pl = no
             wh-domain = scrtmp_so_mstr.so_domain
             wh-site = scrtmp_so_mstr.so_site.
/*
MESSAGE "emt-maint: " emt-maint
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
*/             
             /*
      PUBLISH "OverRuleSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                                   INPUT scrtmp_so_mstr.so_nbr,
                                   INPUT scrtmp_so_mstr.so_print_pl).
         
               */
         
      if emt-maint = true and scrtmp_so_mstr.so__chr10 <> "INVOICE" and
                              domain <> "HQ" then do:
        DO for emtsom:
          find emtsom no-lock where emtsom.so_domain = "HQ"
                                and emtsom.so_nbr = scrtmp_so_mstr.so_nbr no-error.
          if avail emtsom then ASSIGN wh-site = emtsom.so_site
                                      wh-domain = emtsom.so_domain
                                      emt-ordr = TRUE.
         /* else if field-acc[02] then repeat:  INC20959 */
            else if field-acc[02] and not lvl_p1 then repeat:
            update wh-site format "XXX" label " Ware-House" go-on("END-ERROR")
                   with frame whsite2 side-labels width 19 overlay col 29 row 9.
            hide frame whsite2 no-pause.
            if keyfunction(lastkey) = "END-ERROR" then
               undo order-entry, retry order-entry.
/*INC20959 ADD BEGINS*/
            find code_mstr no-lock where code_domain  = "XX"
                                     and code_fldname = "wh-groups"
                                     and code_value   = "ship-type1" no-error. 
            if available code_mstr then
               lvc_grp = code_cmmt.   
            if not available code_mstr then
               lvc_grp = "".
            lvl_s1 = getsitecorporategroup(global_domain,wh-site,lvc_grp).
/*INC20959 ADD ENDS*/   
            if can-do(ware-houses,wh-site) then leave.
            message "Please select an existing ware-house code ...".
          end.
          else lvl_s1 = no.     /*INC20959*/
          
          /*                              
          run "av/avwhsite2.p" (domain,scrtmp_so_mstr.so_site,scrtmp_so_mstr.so__chr10,output wh-site,
                                output wh-domain,output emt-ordr).
          */  
          IF NOT AVAIL emtsom
          THEN DO:
            ASSIGN new-order = TRUE.
            RUN GetWhseSite (INPUT domain,
                             INPUT BUFFER scrtmp_so_mstr:HANDLE,
                             INPUT ?,
                             INPUT ?,
                             INPUT FALSE,
                             INPUT-OUTPUT wh-site,
                             INPUT-OUTPUT wh-domain,
                             INPUT-OUTPUT emt-ordr,
                             OUTPUT lWhseOk#) .
            ASSIGN new-order = FALSE.
            IF lWhseOk# = FALSE
           THEN undo order-entry, retry order-entry.
         END.
        END.                          

      end.
      else emt-ordr = false.

       /* for existing order set emt-ordr to NO when project = INVOICE */
      if scrtmp_so_mstr.so__chr10 = "INVOICE" then assign wh-site = scrtmp_so_mstr.so_site
                                           wh-domain = scrtmp_so_mstr.so_domain
                                           emt-ordr = false.
           


      /* Determine default consume setting when modifying an order */
      if avail ad_mstr and not can-do("AU,MY,TH,HK,PH,CN,JP,MU,SG", ad_mstr.ad_ctry)
      then l-cust-ctry-consume = yes.
      else l-cust-ctry-consume = no.
        assign consume =
        not can-do("INVOICE,SAMPLES,CENTRAL,SURPLUS,SPOTORDR"
                       ,scrtmp_so_mstr.so__chr10)
                       and l-cust-ctry-consume
             old-consume = consume.

      find last scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                                  and scrtmp_sod_det.sod_nbr = sonbr no-error.
      if avail scrtmp_sod_det then 
      assign prom-date = scrtmp_sod_det.sod_per_date
                                   tax-in = scrtmp_sod_det.sod_tax_in.

      /* RFC2142 ADD BEGINS */
      if not new-line 
      then 
         prom-date =    scrtmp_sod_det.sod_per_date.
      else
         prom-date = scrtmp_sod_det.sod_due_date.
     /* RFC 2142 ADD ENDS */
      find ad_mstr no-lock where ad_mstr.ad_domain = domain
                             and ad_mstr.ad_addr = scrtmp_so_mstr.so_cust no-error.
      if avail ad_mstr then display ad_mstr.ad_name ad_mstr.ad_line1 ad_mstr.ad_line2 ad_mstr.ad_line3
                                    ad_mstr.ad_zip + "  " + ad_mstr.ad_city @ ad_mstr.ad_city
                                    with frame sold_to.
      else do:
        hide message no-pause.
        {us/bbi/mfmsg.i 3 2} /* CUSTOMER DOES NOT EXIST */
      end. /* IF NOT avail AD_MSTR */

      find ad_mstr no-lock where ad_mstr.ad_domain = domain
                             and ad_mstr.ad_addr = scrtmp_so_mstr.so_ship no-error.
      if avail ad_mstr then do: 
        display ad_mstr.ad_name ad_mstr.ad_line1 ad_mstr.ad_line2 ad_mstr.ad_line3
                ad_mstr.ad_zip + "  " + ad_mstr.ad_city @ ad_mstr.ad_city
                with frame ship_to.
        shipctry = trim(caps(ad_mstr.ad_ctry)).
      end.
      /* determine total order amount */
      if scrtmp_so_mstr.so_tax_date <> ? then tax-date = scrtmp_so_mstr.so_tax_date.
      else if scrtmp_so_mstr.so_ship_date <> ? then tax-date = scrtmp_so_mstr.so_ship_date.
      else tax-date = scrtmp_so_mstr.so_due_date.

    end. /* else do */

    if (scrtmp_so_mstr.so_cmtindx = ? or scrtmp_so_mstr.so_cmtindx = 0) then so-cmmts = no.
    else so-cmmts = yes.
    display sonbr scrtmp_so_mstr.so_cust scrtmp_so_mstr.so_bill scrtmp_so_mstr.so_ship with frame a.

    find cm_mstr no-lock where cm_mstr.cm_domain = domain
                           and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust no-error.
    if avail cm_mstr then cm-user1 = cm_mstr.cm_user1.
    else cm-user1 = "". 

    find first ct_mstr no-lock where ct_domain = domain
                                 and ct_code = scrtmp_so_mstr.so_cr_terms no-error.
    if avail ct_mstr then
       ct_description = ct_desc.

    display scrtmp_so_mstr.so_ord_date scrtmp_so_mstr.so_req_date prom-date scrtmp_so_mstr.so_due_date scrtmp_so_mstr.so_curr scrtmp_so_mstr.so_lang
            scrtmp_so_mstr.so_site scrtmp_so_mstr.so__chr10 scrtmp_so_mstr.so_cr_terms scrtmp_so_mstr.so_po scrtmp_so_mstr.so__chr08 scrtmp_so_mstr.so_rmks so-cmmts
            reprice scrtmp_so_mstr.so_userid scrtmp_so_mstr.so_inv_nbr scrtmp_so_mstr.so_taxable scrtmp_so_mstr.so_tax_usage cm-user1
            scrtmp_so_mstr.so_tax_env ct_description scrtmp_so_mstr.so_daybookset tax-in scrtmp_so_mstr.so_taxc
            with frame b.

    billto-id = scrtmp_so_mstr.so__dec01.

    order-header:
    repeat:

      run input-addresses(scrtmp_so_mstr.so_domain) no-error.

      if error-status:error or keyfunction(lastkey) = "END-ERROR" then do:
        clear frame b no-pause.
        clear frame bill_to no-pause.
        clear frame sold_to no-pause.
        clear frame ship_to no-pause.
        clear frame a no-pause.
        sonbr = "".
        undo order-entry, retry order-entry.
      end.

      find cm_mstr no-lock where cm_mstr.cm_domain = domain
                             and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust.
      find cm-bt no-lock where cm-bt.cm_domain = domain
                             and cm-bt.cm_addr = scrtmp_so_mstr.so_bill.

      if new-order then scrtmp_so_mstr.so_daybookset = cm_mstr.cm_daybookset.

      cm-type = cm_mstr.cm_type.

      if cm-type = "1120" then sls-rep = yes.

      if new-order or (old-soldto <> scrtmp_so_mstr.so_cust or old-billto <> scrtmp_so_mstr.so_bill) then do:
        find first soc_ctrl no-lock where soc_domain = domain.
        find ad_mstr no-lock where ad_mstr.ad_domain = domain
                               and ad_mstr.ad_addr = scrtmp_so_mstr.so_bill no-error.
        if (avail ad_mstr and ad_mstr.ad_inv_mthd = "") or (not avail ad_mstr) then do:
          find ad_mstr no-lock where ad_mstr.ad_domain = domain
                                 and ad_mstr.ad_addr = scrtmp_so_mstr.so_ship no-error.
          if (avail ad_mstr and ad_mstr.ad_inv_mthd = "") or (not avail ad_mstr) then
            find ad_mstr no-lock where ad_mstr.ad_domain = domain
                                   and ad_mstr.ad_addr = scrtmp_so_mstr.so_cust.
          if avail ad_mstr then scrtmp_so_mstr.so_pst_id = ad_mstr.ad_pst_id.
        end.

        find cm_mstr no-lock where cm_mstr.cm_domain = domain
                               and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust.
        cm-user1 = cm_mstr.cm_user1.
        find cm-bt no-lock where cm-bt.cm_domain = domain
                               and cm-bt.cm_addr = scrtmp_so_mstr.so_bill.
        assign scrtmp_so_mstr.so_ar_acct = cm-bt.cm_ar_acct
               scrtmp_so_mstr.so_ar_cc = cm-bt.cm_ar_cc.
               /* scrtmp_so_mstr.so__chr06 = cm-bt.cm__chr06. PCM-112 */
       /*    PCM-112 ADD BEGINS */
        for first xxcm_mstr no-lock 
           where xxcm_domain = domain
             and xxcm_addr   = scrtmp_so_mstr.so_bill :
        end. /* FOR FIRST xxcm_mstr */
        if available xxcm_mstr
        then
           scrtmp_so_mstr.so__chr06 = xxcm_invprinter.
       /*  PCM-112 ADD ENDS */       

       
        if scrtmp_so_mstr.so_cust <> scrtmp_so_mstr.so_ship and
           can-find(cm_mstr where cm_mstr.cm_domain = domain
                              and cm_mstr.cm_addr = scrtmp_so_mstr.so_ship) then do:
          find cm_mstr no-lock where cm_mstr.cm_domain = domain
                                 and cm_mstr.cm_addr = scrtmp_so_mstr.so_ship no-error.
          if avail cm_mstr then scrtmp_so_mstr.so_lang = cm_mstr.cm_lang.
          else do:
            find ad_mstr no-lock where ad_mstr.ad_domain = domain
                                   and ad_mstr.ad_addr = scrtmp_so_mstr.so_ship no-error.
            if avail ad_mstr then do:
                scrtmp_so_mstr.so_lang = ad_mstr.ad_lang.
                shipctry = trim(caps(ad_mstr.ad_ctry)).
            end.
          end. /* ELSE DO */
        end. /* IF scrtmp_so_mstr.so_cust <> scrtmp_so_mstr.so_ship */
        else scrtmp_so_mstr.so_lang = cm_mstr.cm_lang.

        assign scrtmp_so_mstr.so_cr_terms = cm-bt.cm_cr_terms
               scrtmp_so_mstr.so_fr_terms = cm-bt.cm_fr_terms
               scrtmp_so_mstr.so_curr = cm-bt.cm_curr
               scrtmp_so_mstr.so_rmks = cm_mstr.cm_rmks 
               scrtmp_so_mstr.so_site = cm_mstr.cm_site
               scrtmp_so_mstr.so_shipvia = cm_mstr.cm_shipvia
               scrtmp_so_mstr.so_taxable = cm_mstr.cm_taxable
               scrtmp_so_mstr.so_taxc = cm_mstr.cm_taxc.

        /* OT-153 START ADDITION */
        lvl_nonEMT3PL = fn_isSalesOrdNonEmt3PL
                         (domain,
                          scrtmp_so_mstr.so__chr04,
                          wh-site).
        if lvl_nonEMT3PL
        then 
           scrtmp_so_mstr.so_site = wh-site.
        /* OT-153 END ADDITION */

        /*if can-do("FB,IB,IR,IS",substr(sonbr,1,2)) then scrtmp_so_mstr.so__chr10 = "SAMPLES". PMO0009B_HP*/
        if can-do("FB,IR,IS",substr(sonbr,1,2)) then scrtmp_so_mstr.so__chr10 = "SAMPLES". /*PMO0009B_HP*/
        else if sonbr begins "IC" then scrtmp_so_mstr.so__chr10 = "CONSIGN".
        else if cm_mstr.cm_type = "1121" then scrtmp_so_mstr.so__chr10 = "DISCOUN".

        find cm_mstr no-lock where cm_mstr.cm_domain = domain
                               and cm_mstr.cm_addr = scrtmp_so_mstr.so_ship no-error.
        find ad_mstr no-lock where ad_mstr.ad_domain = domain
                               and ad_mstr.ad_addr = scrtmp_so_mstr.so_ship.
        if avail cm_mstr
        then assign scrtmp_so_mstr.so_taxable = cm_mstr.cm_taxable
                    scrtmp_so_mstr.so_tax_usage = cm_mstr.cm_tax_usage
                    scrtmp_so_mstr.so_taxc = cm_mstr.cm_taxc
                    tax-in = cm_mstr.cm_tax_in.
        else assign scrtmp_so_mstr.so_taxable = ad_mstr.ad_taxable
                    scrtmp_so_mstr.so_tax_usage = ad_mstr.ad_tax_usage
                    scrtmp_so_mstr.so_taxc = ad_mstr.ad_taxc
                    tax-in = ad_mstr.ad_tax_in.

        RUN SetSodVat (scrtmp_so_mstr.so_domain,sonbr).
                

        if error-status:error then do:
          display "Exchange Rate can NOT be found," skip
                  "Please contact the Responsible" skip
                  "person from the Finance Department." skip(1)
                   with frame yn21e side-labels overlay centered.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn21e.
          undo order-header, retry order-header.
        end.

        if sls-rep 
        then do:
          /*if can-do("ES,FR",domain) then scrtmp_so_mstr.so__chr10 = "CENTRAL". PMO2068N*/
          if can-do("ES,FR,CH",domain) then scrtmp_so_mstr.so__chr10 = "CENTRAL". /*PMO2068N*/
          else scrtmp_so_mstr.so__chr10 = "SAMPLES".
        end.
        
        if emt-maint = true and scrtmp_so_mstr.so__chr10 <> "INVOICE" and
                                domain <> "HQ" then do:
          /*                                
          run "av/avwhsite2.p" (domain,scrtmp_so_mstr.so_site,scrtmp_so_mstr.so__chr10,output wh-site,
                                output wh-domain,output emt-ordr).
          */                                
          RUN GetWhseSite (INPUT domain,
                           INPUT BUFFER scrtmp_so_mstr:HANDLE,
                           INPUT ?,
                           INPUT ?,
                           INPUT FALSE,
                           INPUT-OUTPUT wh-site,
                           INPUT-OUTPUT wh-domain,
                           INPUT-OUTPUT emt-ordr,
                           OUTPUT lWhseOk#) .
          IF lWhseOk# = FALSE
          THEN undo order-entry, retry order-entry.
                                
        end.
        else assign wh-site = scrtmp_so_mstr.so_site
                    wh-domain = scrtmp_so_mstr.so_domain
                    emt-ordr = false.
                    
        RUN SetSodDue(scrtmp_so_mstr.so_domain,scrtmp_so_mstr.so_nbr,0,wh-site,wh-domain,
                      show-mess,output next-due, INPUT-OUTPUT dumd1#, INPUT-OUTPUT dumd2#).

        scrtmp_so_mstr.so_due_date = next-due.
        
        display scrtmp_so_mstr.so_due_date scrtmp_so_mstr.so__chr10 scrtmp_so_mstr.so_taxable tax-in scrtmp_so_mstr.so_tax_usage cm-user1
                scrtmp_so_mstr.so_daybookset scrtmp_so_mstr.so_tax_env scrtmp_so_mstr.so_taxc so-cmmts with frame b.

        find ad_mstr no-lock where ad_mstr.ad_domain = domain
                               and ad_mstr.ad_addr = scrtmp_so_mstr.so_ship no-error.
        if avail ad_mstr then shipctry = trim(caps(ad_mstr.ad_ctry)).         
        find xxtrip_mstr no-lock where xxtrip_domain = domain
                                   and xxtrip_site = scrtmp_so_mstr.so_site
                                   and xxtrip_nbr = ad_mstr.ad__chr02 no-error.
        if avail xxtrip_mstr then do:
          display "Tripnumber '" + ad_mstr.ad__chr02 + "' will be used !!!"
                   format "X(35)" skip(1)
                   with frame yn002 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn002.
          hide frame yn002 no-pause.
          
          run ip_get_trip_dates(scrtmp_so_mstr.so_site, xxtrip_nbr, next-due,
                                 output prom-date, output scrtmp_so_mstr.so_due_date).
          run set-trip-days(string(xxtrip_day)).
          
          /******OT-79 STARTS*****/
          l-cut-off = no.
          if can-find(ad_mstr where ad_domain = wh-domain
                       and ad_addr = "~~~~due" + wh-site)
                       /*or can-find(ad_mstr where ad_domain = wh-domain
                       and ad_addr = "~~~~due" + tt_so_mstr.so_site) OT-82*/
          then
            l-cut-off = yes.     
          /* OT-323 ADD BEGINS */
          for first code_mstr no-lock 
             where code_domain  = "HQ"
               and code_fldname = "CUTOFFTIME"
               and code_value   = wh-site:
          end. /* for first code_mstr */
          if available code_mstr 
          then do:
             if int(code_cmmt) >= time
             then 
                 l-cut-off = no.
             else 
                l-cut-off  = yes.
          end. /* IF AVAILABLE CODE_MSTR */
          /* OT-323 ADD ENDS */
          next-due = scrtmp_so_mstr.so_due_date.
          find code_mstr no-lock where code_domain = "XX"
                         and code_fldname = "Due-date-after-cut-off"
                         and code_value = "not-today+1" 
                         and can-do(code_cmmt,scrtmp_so_mstr.so_site) no-error.
          if available code_mstr then do:
             i= 2.
             do while next-due = today 
                    or (next-due = today + 1 and l-cut-off) :
             
                next-due = today + i.
                run ip_get_trip_dates(scrtmp_so_mstr.so_site, xxtrip_nbr, next-due,
                                 output prom-date, output next-due).
                i = i + 1.
             end. /*do while*/
             
             scrtmp_so_mstr.so_due_date = next-due.
             
          end. /*code_mstr*/
         /*OT-79 ENDS***********/
          if num-entries(tr-txt) > 1 then do:
            display "Trip-days can be: " + tr-txt format "X(58)" skip(1)
                     with frame yn003 side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn003.
            hide frame yn003 no-pause.
          end.
          
        end.
        /* OT-323 ADD BEGINS  */
        else do:
           assign
              lv_ctdate = today
              lv_count  = 0.
           for first code_mstr no-lock 
              where code_domain  = "HQ"
                and code_fldname = "CUTOFFTIME"
                and code_value   = wh-site:
           end. /* for first code_mstr */
           if available code_mstr 
           then do:
              
              if int(code_cmmt) >= time
              then 
                 lv_leadtime = 1.
              else 
                 lv_leadtime = 2.
              
              do while lv_count < lv_leadtime:
                 lv_ctdate = lv_ctdate + 1.
                 if not (weekday(lv_ctdate) = 1 
                    or  weekday(lv_ctdate) = 7) 
                    and not getholiday(wh-domain,
                                       wh-site,
                                       lv_ctdate) 
                 then do:
                    assign
                       scrtmp_so_mstr.so_due_date = lv_ctdate 
                       lv_count                   = lv_count  + 1.
                 end. /*  if not (weekday(lv_ctdate) */    
              end. /*  DO WHILE lv_count <= lv_leadtime */
           end.  /* IF AVAILABLE code_mstr  */
        end.  /* ELSE DO: */
        /* OT-323 ADD ENDS   */
      end. /* if new-order */

     /* for existing order set emt-ordr to NO when project = INVOICE */
      if scrtmp_so_mstr.so__chr10 = "INVOICE" then assign wh-site = scrtmp_so_mstr.so_site
                                           wh-domain = scrtmp_so_mstr.so_domain
                                           emt-ordr = false.

      if not new-order and scrtmp_so_mstr.so_invoiced = yes then do:
        {us/bbi/mfmsg.i 603 2}
        /* INVOICE PRINTED BUT NOT POSTED, PRESS ENTER TO CONTINUE */
        pause.
      end.
      lv_hdstatus = "". /* FT-645 */
      find ad_mstr no-lock where ad_mstr.ad_domain = scrtmp_so_mstr.so_domain 
                             and ad_mstr.ad_addr = scrtmp_so_mstr.so_bill.
      find BusinessRelation no-lock where
                            BusinessRelation.BusinessRelationCode = ad_mstr.ad_bus_relation.
                            
      find FIRST Debtor no-lock where DebtorCode = scrtmp_so_mstr.so_bill
                            and Debtor.BusinessRelation_ID =
                                BusinessRelation.BusinessRelation_ID.
       
      run getCreditData in hcrehd (input scrtmp_so_mstr.so_bill,
                                   input scrtmp_so_mstr.so_curr,   
                                   output lv_hdstatus). /* FT-645 */   
         
      /* if new-order and DebtorIsLockedCredLim then do: FT-645 */
      if new-order 
         and (DebtorIsLockedCredLim
          or lv_hdstatus = "HD" )
      then do: /* FT-645 */
        /* CHECK CREDIT HOLD */
        {us/bbi/mfmsg.i 614 2}
        display "Sales Order placed on status 'HD'." skip(1)
                with frame yn008 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn008.
        hide frame yn008 no-pause.
        scrtmp_so_mstr.so_stat = "HD".
      end.

      ststatus = stline[2].
      status input ststatus.

      assign del-yn = no
             reprice = no
             old-proj = scrtmp_so_mstr.so__chr10.


      find first ct_mstr where ct_domain = domain
                           and ct_code = scrtmp_so_mstr.so_cr_terms
      no-lock no-error.
      if avail ct_mstr then
      do:      
         ct_description = ct_desc.
         display ct_description with frame b.
/*RFC-2934 ADD BEGINS*/         
         if scrtmp_so_mstr.so_domain = "fr" 
         and scrtmp_so_mstr.so_cr_terms = "R21" then do:        
            display "Credit term is R21" skip(1) 
            with frame yn7878 side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR") 
            with frame yn7878.
            hide frame yn7878 no-pause.
         end.    
/*RFC-2934 ADD ENDS*/            
      END.
      /* RFC2142 ADD BEGINS */
      if scrtmp_so_mstr.so_due_date <> prom-date and new-order
      then
         prom-date = scrtmp_so_mstr.so_due_date.
      /* RFC2142 ADD ENDS */

      display scrtmp_so_mstr.so_ord_date scrtmp_so_mstr.so_req_date prom-date scrtmp_so_mstr.so_due_date scrtmp_so_mstr.so_po scrtmp_so_mstr.so__chr08
              scrtmp_so_mstr.so_rmks scrtmp_so_mstr.so_curr scrtmp_so_mstr.so_site scrtmp_so_mstr.so__chr10 so-cmmts scrtmp_so_mstr.so_lang
              scrtmp_so_mstr.so_cr_terms consume scrtmp_so_mstr.so_daybookset scrtmp_so_mstr.so_taxable tax-in
              scrtmp_so_mstr.so_tax_usage scrtmp_so_mstr.so_tax_env scrtmp_so_mstr.so_taxc ct_description
              with frame b.

      frame-b-entry:
      repeat with frame b:

        y-n = field-acc[03].
        if not new-order and
           can-find(first scrtmp_sod_det where scrtmp_sod_det.sod_domain = scrtmp_so_mstr.so_domain
                                    and scrtmp_sod_det.sod_nbr = sonbr) then y-n = no.
        /*else if can-do("FP,FB,IB,IC,IR,IS",substr(sonbr,1,2)) then y-n = no. PMO0009B_HP*/
        else if can-do("FP,FB,IC,IR,IS",substr(sonbr,1,2)) then y-n = no. /*PMO0009B_HP*/

        update reprice when (not new-order and scrtmp_so_mstr.so_inv_nbr = "")
               scrtmp_so_mstr.so_req_date
              /* prom-date RFC2142 */
               scrtmp_so_mstr.so_due_date
               scrtmp_so_mstr.so_po
               scrtmp_so_mstr.so__chr08
               scrtmp_so_mstr.so_rmks
               cm-user1
               scrtmp_so_mstr.so_cr_terms when field-acc[06]
               scrtmp_so_mstr.so_curr when (new-order and scrtmp_so_mstr.so_inv_nbr = "" and field-acc[01])
               scrtmp_so_mstr.so_site when (scrtmp_so_mstr.so_inv_nbr = "" and field-acc[02])
               scrtmp_so_mstr.so__chr10 when y-n
               so-cmmts when field-acc[04]
               scrtmp_so_mstr.so_lang when field-acc[05]
/*             consume when field-acc[07]   */
               go-on("END-ERROR","F5","CTRL-D") with frame b editing:

               
          readkey pause time-out.
          if lastkey = -1 or keyfunction(lastkey) = "END-ERROR" then leave.
          if frame-field = "cm-user1" then do:
            if keyfunction(lastkey) = "HELP" then do:
              txt = "Group-Info: " + fill(" ",39) + chr(10) + chr(10).
              for each xxbrl_det no-lock where xxbrl_child = "C-" + scrtmp_so_mstr.so_cust,
                  each ad_mstr no-lock where ad_mstr.ad_bus_rel = xxbrl_parent:
                txt = txt + xxbrl_parent + " " + ad_mstr.ad_name
                    + fill(" ",40 - length(ad_mstr.ad_name)) + chr(10).
              end.
              RUN zu/zupxmsg.p (txt, "", INPUT-OUTPUT lNoReply#).

            end.
            else if can-do("GO,RETURN,TAB,BACK-TAB",keyfunction(lastkey)) or
                    can-do("CURSOR-UP,CURSOR-DOWN",keyfunction(lastkey)) or
                    keyfunction(lastkey) = "END-ERROR" then apply lastkey.
          end.
          else apply lastkey.
          if frame-field = "so__chr10" then do:
            if input scrtmp_so_mstr.so__chr10 begins "CO" then pr-txt = "CONSIGN".
            else if input scrtmp_so_mstr.so__chr10 begins "CE" then pr-txt = "CENTRAL".
            else if input scrtmp_so_mstr.so__chr10 begins "I" then pr-txt = "INVOICE".
            else if input scrtmp_so_mstr.so__chr10 begins "R" then pr-txt = "RUSH".
            else if input scrtmp_so_mstr.so__chr10 begins "H" then pr-txt = "HARDWAR".
            else if input scrtmp_so_mstr.so__chr10 begins "DI" then pr-txt = "DISCOUN".
            else if input scrtmp_so_mstr.so__chr10 begins "SA" then pr-txt = "SAMPLES".
            else if input scrtmp_so_mstr.so__chr10 begins "SU" then pr-txt = "SURPLUS".
            else if input scrtmp_so_mstr.so__chr10 begins "SP" then pr-txt = "SPOTORDR".
            else pr-txt = input scrtmp_so_mstr.so__chr10.
            display pr-txt @ scrtmp_so_mstr.so__chr10 with frame b.
          end.
          if frame-field = "so_cr_terms" then
          do:
            find first ct_mstr where ct_domain = domain
                                 and ct_code = input scrtmp_so_mstr.so_cr_terms
                                 no-lock no-error.
            if avail ct_mstr then
            do:
                ct_description = ct_desc.
                display ct_description with frame b.
            end.
          end.
        end. /* frame b editing */
        /* RFC2142 ADD BEGINS */
        if index(dtitle,"99.7.1.4") > 0
        then
           scrtmp_so_mstr.so_rmks = substring(dtitle,index(dtitle,"99.7.1.4"),8)  .

        if not new-order
        then do:
           for first xxblck_det no-lock
              where xxblck_domain = scrtmp_so_mstr.so_domain
                and xxblck_ord    = scrtmp_so_mstr.so_nbr
                and xxblck_stat =  "blocked":
           end.
           if available xxblck_det
           then do:
              l_qtblck = yes.
           end.
        end. /* if not new-order */
        /* RFC2142 ADD ENDS */

        IF (not new-order and scrtmp_so_mstr.so_inv_nbr = "")
        THEN ASSIGN scrtmp_so_mstr.so_reprice = reprice.
        
        if lastkey = -1 or keyfunction(lastkey) = "END-ERROR" then
          next order-header.

        if lastkey <> keycode("F5") and lastkey <> keycode("CTRL-D") then do:

          IF field-acc[06] AND (scrtmp_so_mstr.so_cr_terms = "" OR scrtmp_so_mstr.so_cr_terms = ?)
          THEN DO:
            MESSAGE "ERROR: Credit Terms is mandatory, please re-enter.".
            UNDO frame-b-entry, RETRY frame-b-entry.
          END.
        
          if scrtmp_so_mstr.so__chr10 = "SURPLUS" then do:
            assign scrtmp_so_mstr.so_stat = "HD".
            message "Order Status set to 'HD' ...".
          end.

          if old-proj = "INVOICE" and scrtmp_so_mstr.so__chr10 <> "INVOICE" and
          not new-order then do:
            display "You are NOT allowed to change the Project-Code which " +
                    "was 'INVOICE' ..." format "X(60)" skip(1)
                    with frame yn0093 side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn0093.
            hide frame yn0093 no-pause.
            next-prompt scrtmp_so_mstr.so__chr10 with frame b.
            scrtmp_so_mstr.so__chr10 = old-proj.
            next frame-b-entry.
          end.

          if not(emt-maint = true and scrtmp_so_mstr.so__chr10 <> "INVOICE" and domain <> "HQ") then
          /*8098 end*/
          assign wh-site = scrtmp_so_mstr.so_site
                 wh-domain = scrtmp_so_mstr.so_domain
                 emt-ordr = false.
          /*5023 end*/

          if scrtmp_so_mstr.so_cr_terms <> "" then do:
            find first ct_mstr no-lock where ct_domain = domain
                                         and ct_code = scrtmp_so_mstr.so_cr_terms no-error.
            if not avail ct_mstr then do:
              /* CREDIT TERM CODE MUST EXIST OR BE BLANK */
              {us/bbi/mfmsg.i 840 3}
              next-prompt scrtmp_so_mstr.so_cr_terms with frame b.
              next frame-b-entry.
            end.
            else do:
                ct_description = ct_desc.
                display ct_description with frame b.
            end.
          end.

          if scrtmp_so_mstr.so_po = "" then do: /* scrtmp_so_mstr.so_po was left blank */
            find cm_mstr no-lock where cm_mstr.cm_domain = domain
                                   and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust no-error.
            if avail cm_mstr then if cm_mstr.cm_po_reqd then do:
              {us/bbi/mfmsg.i 631 3}
              /* PURCHASE ORDER IS REQUIRED FOR THIS CUSTOMER */
              next-prompt scrtmp_so_mstr.so_po with frame b.
              next frame-b-entry.
            end.
          end.
          assign scrtmp_so_mstr.so_cust_po = scrtmp_so_mstr.so_po
                 scrtmp_so_mstr.so_ship_po = scrtmp_so_mstr.so_po.
          /* CHECK FOR DUPLICATE P.O. NUMBER */
          if scrtmp_so_mstr.so_po <> "" then do for somstr:
            txt = "".
            for each somstr no-lock where somstr.so_domain = scrtmp_so_mstr.so_domain
                                      and somstr.so_po = scrtmp_so_mstr.so_po
                                      and somstr.so_cust = scrtmp_so_mstr.so_cust
                                      and somstr.so_nbr <> sonbr:
              if txt <> "" then txt = txt + ",".
              txt = txt + somstr.so_nbr.
            end.
            for each ih_hist no-lock where ih_domain = scrtmp_so_mstr.so_domain
                                       and ih_po = scrtmp_so_mstr.so_po
                                       and ih_cust = scrtmp_so_mstr.so_cust
                                       and ih_nbr <> sonbr:
              if txt <> "" then txt = txt + ",".
              txt = txt + ih_inv_nbr.
            end.

            if txt <> "" then do:
              {us/bbi/mfmsg.i 624 2}
              message "Order(s):" txt.
              pause.
            end.
          end. /* if so_po <> "" */

          /* CHECK FOR VALID TIME SERVICE */
          if scrtmp_so_mstr.so__chr08 <> "" then do:
            find ad_mstr where ad_mstr.ad_domain = domain
                           and ad_mstr.ad_addr = scrtmp_so_mstr.so_ship
                           no-lock no-error.
            if avail ad_mstr then do:
              find code_mstr where code_mstr.code_domain = "XX"
                               and code_mstr.code_fldname = "SERVTIME" + shipctry
                               and code_mstr.code_value = scrtmp_so_mstr.so__chr08
                               no-lock no-error.
              if not avail code_mstr then do:
                RUN zu/zupxmsg.p ("Service Time not valid for " + shipctry, "", INPUT-OUTPUT lNoReply#).

                next-prompt scrtmp_so_mstr.so__chr08 with frame b.
                next frame-b-entry.
              end.
            end.
          end.

          find first scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                                       and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr no-error.
          if avail scrtmp_sod_det and can-do(ware-houses,scrtmp_sod_det.sod_site) and
             scrtmp_so_mstr.so_rmks matches "*RUSH*" and scrtmp_so_mstr.so__chr10 = "" then do:
           display "You have entered RUSH in the remarks !!!" skip
                   "For this purpose you should use the Project Field ..." skip
                   "Do you want to update this," skip
                   "so that the Warehouse will get the right message ?" skip(1)
                    with frame yn010 side-labels overlay row 8 col 10.
            update y-n label "Yes or No" go-on("END-ERROR") with frame yn010.
            hide frame yn010 no-pause.
            if y-n then do:
              next-prompt scrtmp_so_mstr.so__chr10 with frame b.
              next frame-b-entry.
            end.
          end.

          find si_mstr no-lock where si_domain = domain
                                 and si_site = scrtmp_so_mstr.so_site
                                 and si_db = domain
                                 and si_type = yes no-error.
          if not avail si_mstr then do:
            display "The entered Site is NOT correct !!!" skip(1)
                    with frame yn011 side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn011.
            hide frame yn011 no-pause.
            next-prompt scrtmp_so_mstr.so_site with frame b.
            next frame-b-entry.
          end.
        end. /* if not F5 */

        /* Set consume setting after possible update customer/header project */
        consume = not can-do("INVOICE,SAMPLES,CENTRAL,SURPLUS,SPOTORDR"
                            ,scrtmp_so_mstr.so__chr10)
                  and l-cust-ctry-consume.
        disp consume with frame b.
        /* In case the consume setting changed then all existing lines **
        ** will have to be adjusted accordingly                        */
        if not new-order
          and consume <> old-consume
          and can-find(first scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain 
                                              and scrtmp_sod_det.sod_nbr    = sonbr)
        then do:
          /* In the future also the fcs_sum should be adjusted... */
          for each scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                    and scrtmp_sod_det.sod_nbr    = sonbr:
            scrtmp_sod_det.sod_consume = consume.
          end.
          if wh-domain <> domain
          then for each scrtmp_sod_det where scrtmp_sod_det.sod_domain = wh-domain
                             and scrtmp_sod_det.sod_nbr = sonbr:
            IF (scrtmp_sod_det.sod_consume <> consume)
            THEN DO:
                IF scrtmp_sod_det.operation   = "N" THEN scrtmp_sod_det.operation   = "M".
                scrtmp_sod_det.sod_consume = consume.
            END.
          end.
          old-consume = consume.
        end.
         /*********** OT-379 STARTS ************/
         if  emt-ordr  = no 
            and domain = "HQ" 
            and new-order     
            and scrtmp_so_mstr.so__chr10 <> "INVOICE"
         then do:
            RUN GetWhseSite (INPUT domain,
                             INPUT BUFFER scrtmp_so_mstr:HANDLE,
                             INPUT ?,
                             INPUT scrtmp_so_mstr.so_due_date,
                             INPUT FALSE,
                             INPUT-OUTPUT wh-site,
                             INPUT-OUTPUT wh-domain,
                             INPUT-OUTPUT emt-ordr,
                             OUTPUT lWhseOk#) .
            assign 
               emt-ordr = false.
               scrtmp_so_mstr.so_site =  wh-site.
                             
            if lWhseOk# = FALSE
            then
               undo order-entry, retry order-entry. 
        end. /* IF  emt-ordr  = no... */
        /*********** OT-379 ENDS ************/
        if new-order and emt-ordr = yes then do:
          if scrtmp_so_mstr.so__chr10 <> "INVOICE"  and
             domain <> "HQ" then do:
            /*
            run "av/avwhsite2.p" (domain,scrtmp_so_mstr.so_site,scrtmp_so_mstr.so__chr10,output wh-site,
                                  output wh-domain,output emt-ordr).
            */                          
            RUN GetWhseSite (INPUT domain,
                             INPUT BUFFER scrtmp_so_mstr:HANDLE,
                             INPUT ?,
                             INPUT scrtmp_so_mstr.so_due_date,
                             INPUT FALSE,
                             INPUT-OUTPUT wh-site,
                             INPUT-OUTPUT wh-domain,
                             INPUT-OUTPUT emt-ordr,
                             OUTPUT lWhseOk#) .
                             
            IF lWhseOk# = FALSE
            THEN UNDO order-entry, RETRY order-entry.         
            
          end.
          else if scrtmp_so_mstr.so__chr10 = "INVOICE" then assign wh-site = scrtmp_so_mstr.so_site
                                                    wh-domain = scrtmp_so_mstr.so_domain
                                                    emt-ordr = false.
          /*if field-acc[02] then do for emtsom:  INC20959*/
            if field-acc[02] and not lvl_p1 then do for emtsom:
            find emtsom no-lock where emtsom.so_domain = "HQ"
                                  and emtsom.so_nbr = scrtmp_so_mstr.so_nbr no-error.
            if not avail emtsom then repeat:
              update wh-site format "XXX" label " Ware-House" go-on("END-ERROR")
                  with frame whsite1 side-labels width 19 overlay col 29 row 9.
              hide frame whsite1 no-pause.
/*INC20959 ADD BEGINS*/
              find code_mstr no-lock where code_domain  = "XX"
                                       and code_fldname = "wh-groups"
                                       and code_value   = "ship-type1" no-error. 
              if available code_mstr then
                 lvc_grp = code_cmmt.   
              if not available code_mstr then
                 lvc_grp = "".
              lvl_s1 = getsitecorporategroup(global_domain,wh-site,lvc_grp).
/*INC20959 ADD BEGINS*/ 
              if keyfunction(lastkey) = "END-ERROR" then
                 undo order-entry, retry order-entry.
              if can-do(ware-houses,wh-site) then leave.
              message "Please select an existing ware-house code ...".
            end.
         /*   else wh-site = emtsom.so_site.  INC20959*/
/*INC20959 ADD BEGINS*/         
              else do:
                 wh-site = emtsom.so_site.
                 lvl_s1 = no.
              end.  /*else do*/
/*INC20959 ADD ENDS*/              
          end.
/*RFC-2495 START OF ADDITION**************************************************/
          if scrtmp_so_mstr.so__chr10 <> "" 
          then  do:
             find first Project where ProjectCode = scrtmp_so_mstr.so__chr10
               no-lock no-error.
             if not available Project 
             then do:
                {pxmsg.i &msgnum = 8674 &errorlevel = 3}
                undo,retry.
             end.
             else do:
                find first ProjectStatus no-lock 
                  where ProjectStatus.ProjectStatus_ID = Project.ProjectStatus_ID 
                    and ProjectStatusCode              = "Closed" no-error.
                if available ProjectStatus 
                then do:
                   {pxmsg.i &msgnum = 8674 &errorlevel = 3}
                   undo,retry.
                end.  /*if available ProjectStatus */
             end. /*else do:*/ 
          end. /*if scrtmp_so_mstr.so__chr10 <> "" */
/*RFC-2495 END OF ADDITION ***************************************************/
          if emt-ordr then do:
            find vd_mstr no-lock where vd_domain = domain
                                   and vd_addr = wh-site no-error.
            if not avail vd_mstr then do:
         display "Because this Order needs to be supplied from another Domain,"
            skip "a Supplier with the Warehouse-code needs to be available ..."
                skip(1) with frame yn0040 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn0040.
              hide frame yn0040 no-pause.
              undo order-entry, retry order-entry.
            end.
            find first gl_ctrl no-lock where gl_domain = domain.
            if vd_curr <> gl_base_curr then do:
              find exr_rate no-lock where exr_domain = domain
                                      and exr_curr1 = gl_base_curr
                                      and exr_curr2 = vd_curr
                                      and exr_start <= today
                                      and exr_end >= today no-error.
              if not avail exr_rate then
              find exr_rate no-lock where exr_domain = domain
                                      and exr_curr1 = vd_curr
                                      and exr_curr2 = gl_base_curr
                                      and exr_start <= today
                                      and exr_end >= today no-error.
              if not avail exr_rate then do:
              display "There is no exchange-rate available for this date," skip
                      "please consult with your Finance Department ..." skip(1)
                       with frame yn005 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn005.
                hide frame yn005 no-pause.
                undo order-entry, retry order-entry.
              end.
            end.
          end.
        end.

        del-yn = no.

        if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
          counter = 0.
          for EACH cl_sod_det no-lock where cl_sod_det.sod_domain = wh-domain              
                                     and cl_sod_det.sod_nbr = sonbr
                                     and cl_sod_det.sod_type = ""
                                     and cl_sod_det.sod_status <> ""
                                     and cl_sod_det.sod_status <> "C":
            counter = counter + 1.
          end.
          if counter > 0 then do:
            if counter = 1 then do:
              display "You may not delete this Order because there is a line"
                 skip "which has not been cancelled (yet) by the Warehouse ..."
                 skip(1) with frame yn012 side-labels overlay row 8 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn012.
              hide frame yn012 no-pause.
            end.
            else do:
              display "You may not delete this Order because there are lines"
                 skip "which are not cancelled (yet) by the Warehouse ..."
                 skip(1) with frame yn013 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn013.
              hide frame yn013 no-pause.
            end.
            next order-header.
          end.
          counter = 0.
          for each cl_so_mstr no-lock where cl_so_mstr.so_domain = wh-domain              
                                     and cl_so_mstr.so_nbr = sonbr
                                     and cl_so_mstr.so_compl_stat <> ""
                                     and cl_so_mstr.so_compl_stat <> ?
                                     :
            counter = counter + 1.
          end.
          for each cl_so_mstr no-lock where cl_so_mstr.so_domain = scrtmp_so_mstr.so_domain             
                                     and cl_so_mstr.so_nbr = sonbr
                                     and cl_so_mstr.so_compl_stat <> ""
                                     and cl_so_mstr.so_compl_stat <> ?
                                     :
            counter = counter + 1.
          end.
          if counter > 0 then do:
            display "You may not delete this Order because it has"
               skip "so_compl_stat not equal empty ..."
               skip(1) with frame yn14012 side-labels overlay row 8 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn14012.
            hide frame yn14012 no-pause.
            next order-header.
          end.
          counter = 0.
          for each cl_sod_det no-lock where cl_sod_det.sod_domain = wh-domain              
                                     and cl_sod_det.sod_nbr = sonbr
                                     and cl_sod_det.sod_type = ""
                                     and cl_sod_det.sod_compl_stat <> ""
                                     and cl_sod_det.sod_compl_stat <> ?
                                     :
            counter = counter + 1.
          end.
          for each cl_sod_det no-lock where cl_sod_det.sod_domain = scrtmp_so_mstr.so_domain             
                                     and cl_sod_det.sod_nbr = sonbr
                                     and cl_sod_det.sod_type = ""
                                     and cl_sod_det.sod_compl_stat <> ""
                                     and cl_sod_det.sod_compl_stat <> ?
                                     :
            counter = counter + 1.
          end.
          if counter > 0 then do:
            if counter = 1 then do:
              display "You may not delete this Order because there is a line"
                 skip "which has sod_compl_stat not equal empty ..."
                 skip(1) with frame yn1012 side-labels overlay row 8 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn1012.
              hide frame yn1012 no-pause.
            end.
            else do:
              display "You may not delete this Order because there are lines"
                 skip "which have sod_compl_stat not equal empty ..."
                 skip(1) with frame yn1013 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn1013.
              hide frame yn1013 no-pause.
            end.
            next order-header.
          end.
          counter = 0.
          for each cl_sod_det no-lock where cl_sod_det.sod_domain = wh-domain
                                     and cl_sod_det.sod_nbr = sonbr
                                     and cl_sod_det.sod_qty_inv <> 0
                                     and cl_sod_det.sod_type = "":
            counter = counter + 1.
          end.
          for each cl_sod_det no-lock where cl_sod_det.sod_domain = scrtmp_so_mstr.so_domain
                                     and cl_sod_det.sod_nbr = sonbr
                                     and cl_sod_det.sod_qty_inv <> 0
                                     and cl_sod_det.sod_type = "":
            counter = counter + 1.
          end.
          if counter > 0 then do:
            if counter = 1 then do:
              display "You may not delete this Order now because there is" skip
                      "an orderline which has not been invoiced (yet) ..."
                 skip(1) with frame yn014 side-labels overlay row 8 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn014.
              hide frame yn014 no-pause.
            end.
            else do:
              display "You may not delete this Order now because there are"
                 skip "orderlines which have not been invoiced (yet) ..."
                 skip(1) with frame yn015 side-labels overlay row 8 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn015.
              hide frame yn015 no-pause.
            end.
            next order-header.
          end.
          del-yn = no.
          display "Are you Sure that you want to Totally delete this Order ???"
                 skip(1) with frame yn016 side-labels overlay row 8 col 10.
          update del-yn label "Yes or No" go-on("END-ERROR") with frame yn016.
          hide frame yn16 no-pause.
          if not del-yn then next frame-b-entry.
        end. /* if F5 */

        if del-yn = no then do:

          if emt-ordr = yes then do:
            find vd_mstr no-lock where vd_domain = domain
                                   and vd_addr = wh-site no-error.
            if not avail vd_mstr then do:
         display "Because this Order needs to be supplied from another Domain,"
            skip "a Supplier with the Warehouse-code needs to be available ..."
                skip(1) with frame yn004 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn004.
              hide frame yn004 no-pause.
              undo order-entry, retry order-entry.
            end.
            find first gl_ctrl no-lock where gl_domain = domain.
            if vd_curr <> gl_base_curr then do:
              find exr_rate no-lock where exr_domain = domain
                                      and exr_curr1 = gl_base_curr
                                      and exr_curr2 = vd_curr
                                      and exr_start <= today
                                      and exr_end >= today no-error.
              if not avail exr_rate then
              find exr_rate no-lock where exr_domain = domain
                                      and exr_curr1 = vd_curr
                                      and exr_curr2 = gl_base_curr
                                      and exr_start <= today
                                      and exr_end >= today no-error.
              if not avail exr_rate then do:
              display "There is no exchange-rate available for this date," skip
                      "please consult with your Finance Department ..." skip(1)
                       with frame yn0050 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn0050.
                hide frame yn0050 no-pause.
                undo order-entry, retry order-entry.
              end.
            end.
          end.


          if new-order then do:
            run SetSodDue (scrtmp_so_mstr.so_domain,scrtmp_so_mstr.so_nbr,0,wh-site,wh-domain,
                                    show-mess,output next-due, INPUT-OUTPUT dumd1#, INPUT-OUTPUT dumd2#).

            find cu_mstr no-lock where cu_curr = scrtmp_so_mstr.so_curr no-error.
            if not avail cu_mstr then do:
              display "The entered currency does NOT exist (yet) !!!" skip(1)
                       with frame yn017 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn017.
              hide frame yn017 no-pause.
              next-prompt scrtmp_so_mstr.so_curr with frame b.
              next frame-b-entry.
            end.

            if scrtmp_so_mstr.so_due_date < next-due then do:
              if scrtmp_so_mstr.so_due_date < today then do:
                display "Due-Date may not be smaller than today !!!" skip(1)
                         with frame yn018 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn018.
                hide frame yn018 no-pause.
                next-prompt scrtmp_so_mstr.so_due_date with frame b.
                next frame-b-entry.
              end.
              else do:
                display "Due-Date should not be smaller than " +
                        string(next-due) + " !!!" format "X(55)" skip(1)
                        with frame yn019 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn019.
                hide frame yn019 no-pause.
              end.
            end.

            if scrtmp_so_mstr.so_req_date < next-due then do:
              if scrtmp_so_mstr.so_req_date < today then do:
                display "Req-Date may not be smaller than today !!!" skip(1)
                         with frame yn020 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn020.
                hide frame yn020 no-pause.
                next-prompt scrtmp_so_mstr.so_req_date with frame b.
                next frame-b-entry.
              end.
              else do:
                display "Req-Date should not be smaller than" next-due "!!!"
                    skip(1) with frame yn021 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn021.
                hide frame yn021 no-pause.
              end.
            end.

            
            /* if prom-date = ? then prom-date = scrtmp_so_mstr.so_req_date. RFC2142 ****** ****/
            /* RFC2142 ADD BEGINS */
            if not new-order
            then
               prom-date = scrtmp_so_mstr.so_per_date.
            else
              prom-date =  scrtmp_so_mstr.so_due_date.
            /* RFC2142 ADD ENDS */
            if scrtmp_so_mstr.so_req_date = ? then scrtmp_so_mstr.so_req_date = scrtmp_so_mstr.so_due_date.
            /*WMSI-2066 START OF ADDITION ************************************************************************************/
            /*if scrtmp_so_mstr.so_site = "550" then do: PMO0009B_HP*/
            /* OT-159 START DELETION 
            if can-do("550,600",scrtmp_so_mstr.so_site) then do:  /*PMO0009B_HP*/
            OT-159 END DELETION */
            /* OT-159 START ADDITION */
            for first code_mstr 
               where code_domain  = "XX" 
                 and code_fldname = "Due-date-after-cut-off"
                 and code_value   = "not-today+1" 
            no-lock:
               lvc_scale_sites = code_cmmt.
            end.
            if can-do(lvc_scale_sites,scrtmp_so_mstr.so_site) 
            then do:
            /* OT-159 END ADDITION */
                scrtmp_so_mstr.so_req_date = scrtmp_so_mstr.so_due_date + 1.
                if weekday(scrtmp_so_mstr.so_req_date) = 1 then scrtmp_so_mstr.so_req_date = scrtmp_so_mstr.so_req_date + 1.
                if weekday(scrtmp_so_mstr.so_req_date) = 7 then scrtmp_so_mstr.so_req_date = scrtmp_so_mstr.so_req_date + 2.

                find hd_mstr no-lock where hd_domain = wh-domain
                         and hd_site = wh-site
                         and hd_date = next-due no-error.
                do while available hd_mstr:
                    scrtmp_so_mstr.so_req_date = scrtmp_so_mstr.so_req_date + 1.
                    if weekday(scrtmp_so_mstr.so_req_date) = 1 then scrtmp_so_mstr.so_req_date = scrtmp_so_mstr.so_req_date + 1.
                    if weekday(scrtmp_so_mstr.so_req_date) = 7 then scrtmp_so_mstr.so_req_date = scrtmp_so_mstr.so_req_date + 2.
                    find hd_mstr no-lock where hd_domain = wh-domain
                            and hd_site = wh-site
                            and hd_date = scrtmp_so_mstr.so_req_date no-error.
                end. /*do while*/
            end. /*site = 550*/
            /*WMSI-2066 END OF ADDITION ******************************************************************************************/
            display prom-date with frame b.

            RUN SetSodVat (scrtmp_so_mstr.so_domain,sonbr).

            if error-status:error then do:
              display "Exchange Rate can NOT be found," skip
                      "Please contact the Responsible" skip
                      "person from the Finance Department." skip(1)
                      with frame yn21e side-labels overlay centered.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn21e.
              undo order-entry, retry order-entry.
            end.

            display scrtmp_so_mstr.so__chr10 scrtmp_so_mstr.so_tax_env scrtmp_so_mstr.so_tax_usage scrtmp_so_mstr.so_taxc scrtmp_so_mstr.so_taxable
                    tax-in with frame b.
          end.  /* if new-order */
          else if old-due-date <> scrtmp_so_mstr.so_due_date and scrtmp_so_mstr.so_due_date < today
          then do:
            display "Due-Date may not be smaller than today !!!" skip(1)
                     with frame yn018a side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn018a.
            hide frame yn018a no-pause.
            next-prompt scrtmp_so_mstr.so_due_date with frame b.
            next frame-b-entry.
          end. /* not new-order */
          if not new-order and old-due-date <> scrtmp_so_mstr.so_due_date then
            {pxmsg.i &msgtext = '"Due Date modified. Ware house site may vary due to this modification"' &errorlevel = 2}    /*MEDPLAN*/
          RUN GetWhseSite (INPUT domain,
                           INPUT BUFFER scrtmp_so_mstr:HANDLE,
                           INPUT ?,
                           INPUT scrtmp_so_mstr.so_due_date,
                           
                           INPUT TRUE,
                           
                           INPUT-OUTPUT wh-site,
                           INPUT-OUTPUT wh-domain,
                           INPUT-OUTPUT emt-ordr,
                           OUTPUT lWhseOk#) .
                             
          IF lWhseOk# = FALSE
          THEN DO:     
            next-prompt scrtmp_so_mstr.so_due_date with frame b.
            next frame-b-entry.
          END.
          
          if (domain = "ES" or domain = "PT") and
            can-do("CENTRAL,CONSIGN,SAMPLES,HARDWAR,DISCOUN",scrtmp_so_mstr.so__chr10) then
            scrtmp_so_mstr.so_daybookset = "ZERO-SLS".
          else if not can-find(FIRST scrtmp_sod_det where scrtmp_sod_det.sod_domain = scrtmp_so_mstr.so_domain
                                               and scrtmp_sod_det.sod_nbr = sonbr) then do:
            find cm_mstr no-lock where cm_mstr.cm_domain = domain
                                   and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust.
            scrtmp_so_mstr.so_daybookset = cm_mstr.cm_daybookset.
          end.

          display scrtmp_so_mstr.so_daybookset with frame b.

          if can-do("600,800,810,880",scrtmp_so_mstr.so_site) then tax-entry:
          repeat:
            update scrtmp_so_mstr.so_daybookset scrtmp_so_mstr.so_tax_env scrtmp_so_mstr.so_tax_usage scrtmp_so_mstr.so_taxable tax-in
                   scrtmp_so_mstr.so_taxc go-on("END-ERROR") with frame b.

            if keyfunction(lastkey) = "END-ERROR" then next frame-b-entry.

            find FIRST dybs_mstr no-lock where dybs_domain = domain
                                     and dybs_code = scrtmp_so_mstr.so_daybookset
                                     and (dybs_site = scrtmp_so_mstr.so_site or
                                          dybs_site = "") no-error.
            if not avail dybs_mstr then do:
              message "The entered Daybook-Set does NOT exist (yet) !!!".
              next-prompt scrtmp_so_mstr.so_daybookset with frame b.
              if field-acc[27] then next tax-entry.
              else next frame-b-entry.
            end.

            if scrtmp_so_mstr.so_tax_usage <> "" then do:
              find code_mstr no-lock where code_mstr.code_domain = domain
                                       and code_mstr.code_fldname = "tx2_tax_usage"
                                       and code_mstr.code_value = scrtmp_so_mstr.so_tax_usage no-error.
              if not avail code_mstr then do:
                display "This Tax-Usage does NOT exist (yet) !!!" skip(1)
                        with frame yn022 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn022.
                hide frame yn022 no-pause.
                next-prompt scrtmp_so_mstr.so_tax_usage with frame b.
                if field-acc[24] then next tax-entry.
                else next frame-b-entry.
              end.
            end.

            find first txe_mstr no-lock where txe_desc = scrtmp_so_mstr.so_tax_env no-error.
            if not avail txe_mstr then do:
              display "This Tax-Environment does NOT exist (yet) !!!" skip(1)
                       with frame yn023 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn023.
              hide frame yn023 no-pause.
              next-prompt scrtmp_so_mstr.so_tax_env with frame b.
              if field-acc[26] then next tax-entry.
              else next frame-b-entry.
            end.

            if scrtmp_so_mstr.so_taxc <> "" then do:
              find code_mstr no-lock where code_mstr.code_domain = domain
                                       and code_mstr.code_fldname = "taxc_taxc"
                                       and code_mstr.code_value = scrtmp_so_mstr.so_taxc no-error.
              if not avail code_mstr then do:
                display "This Tax-Class does NOT exist (yet) !!!" skip(1)
                         with frame yn024 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn024.
                hide frame yn024 no-pause.
                next-prompt scrtmp_so_mstr.so_taxc with frame b.
                if field-acc[25] then next tax-entry.
                else next frame-b-entry.
              end.
            end.
            leave tax-entry.
          end.
          hide frame b no-pause.

          if not new-order then do:

            
            for each scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                      and scrtmp_sod_det.sod_nbr    = sonbr:
              assign scrtmp_sod_det.sod_tax_env = scrtmp_so_mstr.so_tax_env
                     scrtmp_sod_det.sod_tax_usage = scrtmp_so_mstr.so_tax_usage
                     .
              /* CEPS-1582 ADD BEGINS */
              create tt_prstat.
              assign
                 tt_prline = scrtmp_sod_det.sod_line
                 tt_prpart = scrtmp_sod_det.sod_part
                 tt_prsta  = scrtmp_sod_det.sod__chr02.
              /* CEPS-1582 ADD ENDS */
              IF scrtmp_sod_det.operation   = "N" THEN scrtmp_sod_det.operation   = "M".
              if (scrtmp_sod_det.sod_taxc begins "N" and scrtmp_so_mstr.so_site = "110") or
         (scrtmp_sod_det.sod_taxc begins "B" and scrtmp_so_mstr.so_site = "200" and scrtmp_sod_det.sod_tax_env begins "BE")
                then scrtmp_sod_det.sod_tax_env = scrtmp_so_mstr.so_tax_env + "-" + scrtmp_sod_det.sod_taxc.

            end.
          end.

          if not emt-maint then do:
           /*SCQ-1369 lv_emt CHANGE*/
            if lv_emt = no
            then do:
            /*SCQ-1369 lv_emt CHANGE ENDS*/
            compl-nbr = "".
            message "Patience please, retrieving Complaint Data ...".
            if scrtmp_so_mstr.so_inv_nbr ne "" then
            for last xxcpl_mstr no-lock where xxcpl__chr04 = scrtmp_so_mstr.so_inv_nbr by xxcpl_nbr:
                    compl-nbr = xxcpl_nbr.
            end.
            if compl-nbr = "" then
            for last xxcpl_mstr no-lock where xxcpl__chr01 = scrtmp_so_mstr.so_nbr by xxcpl_nbr:
              compl-nbr = xxcpl_nbr.
            end.
            if compl-nbr = "" then compl-nbr = scrtmp_so_mstr.so_user1.

            hide message no-pause.

            if compl-nbr = "" then do:
              RUN zu/zupxmsg.p ("No Complaint (10.1) has been found for this Order !!!", "Do you wish to continue and enter the Complaint-Number manually???", INPUT-OUTPUT y-n).
              if y-n <> yes then undo order-entry, retry order-entry.
            end.

            proj-cmmtloop:
            do on error undo, retry:
              update compl-nbr
              go-on("END-ERROR") with frame proj-cmmt.

              if lastkey = -1 or keyfunction(lastkey) = "END-ERROR" then do:
                pause 0 before-hide.
                hide frame proj-cmmt.
              end.
 
              if compl-nbr = "" then do:
                message "You must enter the Complaint-Number !!!"
                        view-as alert-box.
                undo, retry.
              end.

              if compl-nbr <> "" then do:
                find xxcpl_mstr no-lock where xxcpl_nbr = compl-nbr no-error.
                if not avail xxcpl_mstr then do:
                message "The entered Complaint-Number does NOT exist (yet) !!!"
                        view-as alert-box.
                  undo, retry.
                end.
                else if xxcpl__chr01 <> "" and xxcpl__chr01 <> scrtmp_so_mstr.so_nbr then do:
                        message "The entered Complaint does NOT contain the selected Order !!!"
                        skip "It is '" + xxcpl__chr01 + "', do you still want to use this Complaint ?"
                          view-as alert-box buttons yes-no update y-n.
                  if y-n <> yes then undo, retry.
                end.
              end. /*if compl-nbr <> ""*/
            end. /*proj-cmmtloop*/

            scrtmp_so_mstr.so_user1 = compl-nbr.

            corr-code = scrtmp_so_mstr.so__chr03.
            corr-reason = "".
            if global_domain = "ES" then es-corr-reason-loop:
            do on endkey undo, retry:
              update corr-code with frame es-corr-reason editing:

                if frame-field = "corr-code" then do:
                  {us/zu/zumfnp05.i code_mstr code_fldval "code_mstr.code_domain = 'ES' and
                                                    code_mstr.code_fldname = 'so__chr03'"
                                                   code_mstr.code_cmmt "input corr-code"}
                  if lastkey = -1 or keyfunction(lastkey) = "END-ERROR" then do:
                    pause 0 before-hide.
                    hide frame corr-a1.
                    hide frame es-corr-reason.
                    pause before-hide.
                    undo, retry.
                  end.
                  else if rRowid# <> ? then display code_mstr.code_value @ corr-code
                                                  code_mstr.code_cmmt @ corr-reason
                                                 with frame es-corr-reason.
                  else if keyfunction(lastkey) = "HELP" then do:
                    on default-action of corr-brwse-1 in frame corr-a1 do:
                      display code_mstr.code_cmmt @ corr-reason
                              with frame es-corr-reason.
                      apply "WINDOW-CLOSE" to corr-brwse-1.
                    end.
                    open query corr-qry-1
                      for each code_mstr no-lock where code_mstr.code_domain = "ES"
                                                and code_mstr.code_fldname = "so__chr03".
                    enable corr-brwse-1 with frame corr-a1.
                    wait-for window-close,"END-ERROR" of current-window
                                                            focus corr-brwse-1.
                    hide frame corr-a1 no-pause.
                    if keyfunction(lastkey) <> "END-ERROR" then apply "RETURN".
                  end.
                  else if keyfunction(lastkey) = "RETURN" then
                  do:
                    find code_mstr no-lock where code_mstr.code_domain = "ES"
                                             and code_mstr.code_fldname = "so__chr03"
                                     and code_mstr.code_value = input corr-code no-error.
                    if not avail code_mstr then do:
                        message "ERROR: The entered Correction-Code does NOT exist (yet) !!!"
                                  view-as alert-box.
                      pause 0 before-hide.
                      hide frame corr-a1.
                      hide frame es-corr-reason.
                      pause before-hide.
                      undo es-corr-reason-loop, retry es-corr-reason-loop.
                    end.

                    pause 0 before-hide.
                    hide frame corr-a1.
                    hide frame es-corr-reason.
                    apply "RETURN".
                  end.
                  find code_mstr where code_mstr.code_domain = "ES"
                                   and code_mstr.code_fldname = "so__chr03"
                                   and code_mstr.code_value = input corr-code
                  no-lock no-error.
                  if avail code_mstr then display code_mstr.code_cmmt @ corr-reason
                                                    with frame es-corr-reason.
                end. /*if frame-field = "corr-code" then do:*/
              end. /*es-corr-reason-loop*/
              pause 0 before-hide.
              hide frame corr-a1.
              hide frame es-corr-reason.
            end. /* if global-domain = "ES" */
            scrtmp_so_mstr.so__chr03 = corr-code.
            end. /*lv_emt = no SCQ-1369*/
          end. /* if not emt-maint */

          if keyfunction(lastkey) = "END-ERROR" then do:
            pause 0 before-hide.
            hide frame proj-cmmt.
          end.


          assign global_lang = scrtmp_so_mstr.so_lang
                 global_type = "".

          if so-cmmts = yes then run upd-header-cmmts (scrtmp_so_mstr.so_domain).
          else scrtmp_so_mstr.so_cmtindx = 0.

          display so-cmmts with frame b.

          /* 
          find so_mstr where so_domain = domain
                         and so_nbr = sonbr exclusive-lock.
          */
          
          /* MP: MLQ-00059 */
          IF glCUPCodeEnabled# and scrtmp_so_mstr.so__chr10 <> "SAMPLES" /*UATEIV1 */
          THEN DO:
            update scrtmp_so_mstr.so__chr05 go-on("END-ERROR") with frame cup-fr.
            HIDE FRAME cup-fr.
          END.          
/*RFC-2550 START OF ADDITION *************************************************/
          if global_domain = "PT" 
      then do :
         find first sod_det no-lock where sod_domain = global_domain 
                                      and sod_nbr    = scrtmp_so_mstr.so_nbr no-error.
             if available sod_det 
         then lvc_commit = sod__chr03.
         else 
              lvc_commit = "" .
         update 
            lvc_commit go-on("END-ERROR") 
         with frame f_commit.
             if lvc_commit = ""  
         then do :
            find first Debtor no-lock 
           where DebtorCode = scrtmp_so_mstr.so_cust no-error.  
                if available Debtor then                                                                                                                         
                   find first Profile no-lock 
              where Debtor.DivisionProfile_ID = Profile.Profile_ID 
                        and ProfileCode               = "PUBLIC" no-error. 
        if available Profile 
        then do :
                   {pxmsg.i &msgtext = '"Commitment Number should not be blank for Public customer "' &errorlevel = 3}
                   undo,retry. 
        end.          
         end.
             for each scrtmp_sod_det exclusive-lock 
            where scrtmp_sod_det.sod_nbr    = scrtmp_so_mstr.so_nbr :
            scrtmp_sod_det.sod__chr03 = lvc_commit.
         end.
         release scrtmp_sod_det. 
         if wh-domain <> "" 
         then do:
            for each sod_det exclusive-lock 
           where sod_domain = wh-domain 
                 and sod_nbr    = scrtmp_so_mstr.so_nbr :
               sod__chr03 = lvc_commit .
        end.
        release sod_det.
         end. 
             HIDE FRAME f_commit.
      end.
/*RFC-2550 END OF ADDITION ***************************************************/
          pause 0 before-hide.
          hide frame proj-cmmt.
          hide frame b.
          hide frame ship_to.
          hide frame sold_to.
          hide frame a.
      

          view frame ab.

          display sonbr @ so-nbr scrtmp_so_mstr.so_cust scrtmp_so_mstr.so_bill scrtmp_so_mstr.so_ship prom-date
                  scrtmp_so_mstr.so_due_date scrtmp_so_mstr.so__chr10 @ pr-txt scrtmp_so_mstr.so_site reprice scrtmp_so_mstr.so_rmks
                  scrtmp_so_mstr.so_userid scrtmp_so_mstr.so_inv_nbr with frame ab.

          if scrtmp_so_mstr.so__chr10 = "INVOICE" and
              (can-find(first ld_det where ld_domain = domain
                                       and ld_loc = "CONSIGN"
                                       and ld_ref begins scrtmp_so_mstr.so_ship
                                       and ld_qty_oh - ld_qty_all > 0) or
               can-find(FIRST scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                        and scrtmp_sod_det.sod_nbr = sonbr
                                        and scrtmp_sod_det.sod_loc = "CONSIGN")) then do:
            show-mess = no.

            bulkalloc = no. /*7884*/
            if can-find(first code_mstr where code_mstr.code_domain = "XX" /*7884*/
                                          and code_mstr.code_fldname = "CONS-BULK-ALLOC-DOMAIN"
                                          and code_mstr.code_value = domain) then
              message "Consigned stock available," skip
                      "Proceed to Bulk allocation?"
                      view-as alert-box question buttons yes-no update bulkalloc.

            run consign-invoice(domain).
            
            IF CAN-FIND(FIRST tt-sod_cosign) = TRUE
            THEN DO:
              RUN StoreCosign(OUTPUT lErro#).
              IF lErro# 
              THEN DO:
                MESSAGE 'Fout met opslaan!'
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                UNDO, RETRY.
              END.
            END.
            
            bulkalloc = no. /*7884*/
          end.

          clear frame c no-pause.
          view frame c.
          clear frame d no-pause.
          VIEW frame ship_to.
          VIEW frame bill_to.
          view frame d.

          if not new-order and old-due-date <> scrtmp_so_mstr.so_due_date and
            can-find(FIRST scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                     and scrtmp_sod_det.sod_nbr = sonbr
                                     and scrtmp_sod_det.sod_due_date <> scrtmp_so_mstr.so_due_date) then do:
                                     
                                     
            RUN GetWhseSite (INPUT domain,
                             INPUT BUFFER scrtmp_so_mstr:HANDLE,
                             INPUT ?,
                             INPUT scrtmp_so_mstr.so_due_date,
                             INPUT TRUE,
                             INPUT-OUTPUT wh-site,
                             INPUT-OUTPUT wh-domain,
                             INPUT-OUTPUT emt-ordr,
                             OUTPUT lWhseOk#) .
            IF lWhseOk# = FALSE
            THEN undo order-entry, retry order-entry.                                     
                                     
                                     
            display "Do you want to update all Order-lines with" skip
                    "the new Due-Date that you entered ?" skip(1)
                     with frame yn025 side-labels overlay row 8 col 10.
            update y-n label "Yes or No" go-on("END-ERROR") with frame yn025.
            hide frame yn025 no-pause.
            if y-n = yes then do:
/*RFC-2742 START OF ADDITION *************************************************/
                for each pod_det exclusive-lock where pod_domain = domain
                                          and pod_nbr    = sonbr:
                   pod_due_date = scrtmp_so_mstr.so_due_date .
        end.  /*FOR EACH pod_det */
        release pod_det.  
        for each mrp_det exclusive-lock where mrp_domain  = domain
                                          and mrp_dataset = "pod_det"
                                          and mrp_nbr     = sonbr :
           mrp_due_date = scrtmp_so_mstr.so_due_date .
        end.
        release mrp_det.
/*RFC-2742 END OF ADDITION ***************************************************/
              for each scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                 and scrtmp_sod_det.sod_nbr = sonbr:
                scrtmp_sod_det.sod_due_date = scrtmp_so_mstr.so_due_date.

                if emt-ordr then do for emtsod:
                  find emtsod NO-LOCK where emtsod.sod_domain = wh-domain
                                and emtsod.sod_nbr = scrtmp_sod_det.sod_nbr
                               and emtsod.sod_line = scrtmp_sod_det.sod_line no-error.
                               
                   FIND emtsomTmp NO-LOCK WHERE emtsomTmp.so_domain = emtsod.sod_domain
                                            AND emtsomTmp.so_nbr    = emtsod.sod_nbr NO-ERROR.
                                                              
                  if avail emtsod AND AVAIL emtsomTmp then do:
                  
                    FIND FIRST emttmp_so_mstr WHERE emttmp_so_mstr.so_domain = emtsomTmp.so_domain AND emttmp_so_mstr.so_nbr = emtsomTmp.so_nbr NO-ERROR.
                    IF NOT AVAIL emttmp_so_mstr
                    THEN DO:
                      CREATE emttmp_so_mstr.
                      BUFFER-COPY emtsomTmp
                               TO emttmp_so_mstr
                           ASSIGN emttmp_so_mstr.dataLinkField = fgetNextDataLinkFieldID()
                                  emttmp_so_mstr.operation     = "N".
                    END.   
                                      
                    CREATE emttmp_sod_det.
                    BUFFER-COPY emtsod TO emttmp_sod_det.
                    ASSIGN emttmp_sod_det.sod_due_date     = scrtmp_so_mstr.so_due_date
                           emttmp_sod_det.dataLinkFieldPar = emttmp_so_mstr.dataLinkField
                           emttmp_sod_det.operation        = "M"
                           emttmp_sod_det.dataLinkField    = fgetNextDataLinkFieldID()
                           .
                  end.
                end.
              end.
              
               IF CAN-FIND(FIRST emttmp_so_mstr)
               THEN  DO:
                 RUN SaveEmtData (OUTPUT lErro#).
                 IF lErro# THEN UNDO, RETRY.
               END.
            end.
          end. /* update due date for existing order */

          if scrtmp_so_mstr.so_site = "900" and reprice then do:
            for each scrtmp_sod_det where scrtmp_sod_det.sod_domain   = domain
                                      and scrtmp_sod_det.sod_nbr      = sonbr
                                      and scrtmp_sod_det.sod_qty_ship = 0:

              if can-find(emtsod where emtsod.sod_domain = "HQ"
                                   and emtsod.sod_nbr    = scrtmp_sod_det.sod_nbr
                                   and emtsod.sod_line   = scrtmp_sod_det.sod_line
                                   and emtsod.sod_qty_ship <> 0) or
              not can-find(emtsod where emtsod.sod_domain  = "HQ"
                                    and emtsod.sod_nbr     = scrtmp_sod_det.sod_nbr
                                    and emtsod.sod_line    = scrtmp_sod_det.sod_line)
              then next.

              scrtmp_sod_det.sod_pricing_dt = today.
                                                       
              IF lRollBack THEN   
                run "zu/zuprice.p" (no,domain,scrtmp_so_mstr.so_site,scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_curr,
                                 scrtmp_sod_det.sod_part,scrtmp_sod_det.sod_qty_ord,scrtmp_sod_det.sod_um,scrtmp_sod_det.sod_pricing_dt,
                                          output list-pr,output net-price). 
              ELSE DO:
                list-pr = 0.
                net-price = 0.
                FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                                        AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                                        AND ttApiPrice.ttpart = scrtmp_sod_det.sod_part
                                        EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE ttApiPrice THEN DO:
                  ./ MESSAGE "Get API price 2" VIEW-AS ALERT-BOX.
                  /* cError = GetItemPrice(scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_curr,scrtmp_sod_det.sod_part,STRING(scrtmp_sod_det.sod_qty_ord),scrtmp_sod_det.sod_pricing_dt). palletd */
          li_surcacc = 0. /* mulof */
                  cError = GetItemPrice(scrtmp_so_mstr.so_cust,
                                scrtmp_so_mstr.so_curr,
                    scrtmp_sod_det.sod_part,
                    STRING(scrtmp_sod_det.sod_qty_ord),
                    string(scrtmp_sod_det.sod_um_conv),
                    scrtmp_sod_det.sod_pricing_dt). /* palletd */
          IF cError = "" THEN 
                    FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                                        AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                                        AND ttApiPrice.ttpart = scrtmp_sod_det.sod_part 
                                        EXCLUSIVE-LOCK NO-ERROR.                   
                  ELSE
                    ASSIGN scrtmp_sod_det.sod__chr02 = cError. 
                END.  

                IF AVAILABLE ttApiPrice 
        THEN do: /* surcharge */
                  ASSIGN list-pr = ttApiPrice.ttprice * GetUomConv(scrtmp_sod_det.sod_part, scrtmp_sod_det.sod_um)
                         net-price = ttApiPrice.ttprice * GetUomConv(scrtmp_sod_det.sod_part, scrtmp_sod_det.sod_um)
                         scrtmp_sod_det.sod__chr07 = IF ttApiPrice.ttPriceId NE 0 THEN STRING(ttApiPrice.ttPriceID) ELSE "0"
                         scrtmp_sod_det.sod__chr08 = IF ttApiPrice.ttDiscId NE 0 THEN STRING(ttApiPrice.ttDiscID) ELSE "0"
             scrtmp_sod_det.sod__chr04 = if ttapiprice.ttsurchargeperc ne 0 
                                             then string(ttapiprice.ttsurchargeperc) else "0" /* surcharge */
                        /* scrtmp_sod_det.sod__chr06 = string(ttApiPrice.ttprice) /* RFC-3012 */  CEPS-301*/
             scrtmp_sod_det.sod__chr02 = "OK".
/*CEPS-301 ADD BEGINS*/
             scrtmp_sod_det.sod__chr06 = string(fn_getnetprice(ttApiPrice.ttprice,
                                              (ttApiPrice.ttDiscPerc + ttApiPrice.ttlidiscperc),
                                              decimal(scrtmp_sod_det.sod__chr04))).
/*CEPS-301 ADD ENDS*/

                  /* surcharge ADD BEGINS */                                  
          if ttapiprice.ttsurchargeperc ne 0                          
             and  not can-find(first xxsurc_det                     
           where xxsurc_domain = scrtmp_sod_det.sod_domain             
                    and xxsurc_cust   = scrtmp_so_mstr.so_cust                
            and xxsurc_part   = scrtmp_sod_det.sod_part               
            and xxsurc_nbr    = scrtmp_sod_det.sod_nbr                
            and xxsurc_line   = scrtmp_sod_det.sod_line)
           then
             assign
                li_surcacc = 0 /*mulof */
                cError = GetItemPrice(scrtmp_so_mstr.so_cust,            
                                 scrtmp_so_mstr.so_curr,            
                                 scrtmp_sod_det.sod_part,           
                                STRING(scrtmp_sod_det.sod_qty_ord),
                     STRING(scrtmp_sod_det.sod_um_conv), /* palletd */
                               scrtmp_sod_det.sod_pricing_dt).    
                    /* surcharge ADD BEGINS */                                  

                end. /* IF AVAILABLE ttApiPrice  */

                ELSE DO:       
                  IF cError NE "" THEN 
                    ASSIGN scrtmp_sod_det.sod__chr02 = cError.
                END.
              END.
                                                                  
              if net-price <> 0 then do:
                
                  RUN ClearLocks IN hProc# (INPUT THIS-PROCEDURE).
                
                  assign scrtmp_sod_det.sod_list_pr = net-price
                         scrtmp_sod_det.sod_price = net-price
                         scrtmp_sod_det.sod_pricing_dt = today.

                  RUN SaveDataToDSTT.
                  IF wh-domain <> domain
                  THEN DO:
                      run "zu/zusodwrp.p" (INPUT BUFFER scrtmp_so_mstr:handle, 
                                            INPUT BUFFER scrtmp_sod_det:handle, 
                                            domain,emt-ordr,wh-domain,wh-site,sonbr,
                                            scrtmp_sod_det.sod_line,?,scrtmp_sod_det.sod_qty_ord,
                                            scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv,
                                            (scrtmp_sod_det.sod_qty_all + scrtmp_sod_det.sod_qty_pick) * scrtmp_sod_det.sod_um_conv,
                                             scrtmp_sod_det.sod_due_date, OUTPUT cErro#).
                   END.                                             
                   ELSE ASSIGN cErro# = "".
                   
                   RUN SaveDataFromDSTT.
                   IF cErro# <> ""
                   THEN MESSAGE cErro# .
                
                   RUN SetSoLocks IN hProc# (INPUT domain, INPUT sonbr, INPUT THIS-PROCEDURE, OUTPUT cErro#).
                
              end.
            end.
          end. /* if site = "900" and reprice */

        end. /* del-yn = no (not F5 pressed) */

        else do:
          run delete-order(scrtmp_so_mstr.so_domain,output err-stat).
          if err-stat <> "" then do:
            display "Deletion did not go okay !!!..." skip(1)
                     with frame yn0251 side-labels overlay row 8 col 10.
            update y-n blank label "Press Enter to Continue" go-on("END-ERROR")
                   with frame yn0251.
            hide frame yn0251 no-pause.
          end.
          sonbr = "".
          next order-entry.
        end.

        leave frame-b-entry.
      end. /* frame-b-entry */
      leave order-header.
    end. /* order-header */

  end. /* do */


  if not new-order and scrtmp_so_mstr.so__chr10 = "INVOICE" then
    for each scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                       and scrtmp_sod_det.sod_nbr = sonbr:
      assign scrtmp_sod_det.sod_site = scrtmp_so_mstr.so_site
             scrtmp_sod_det.sod_loc = "CONSIGN".
  end.


  assign domain = scrtmp_so_mstr.so_domain.
         ordr-line = 1.

  find LAST scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                              and scrtmp_sod_det.sod_nbr = sonbr no-error.
  if avail scrtmp_sod_det then ordr-line = scrtmp_sod_det.sod_line + 1.
  if ordr-line > 999 then ordr-line = 999.

  FIND scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                         and scrtmp_sod_det.sod_nbr = sonbr
                         and scrtmp_sod_det.sod_line = ordr-line no-error.
  if avail scrtmp_sod_det then run disp-line-detail(domain).
  else do:
    clear frame c no-pause.
    clear frame d no-pause.
  end.

  if not cs-manager then assign field-acc[08] = no
                                field-acc[09] = no
                                field-acc[10] = no.
  ststatus = stline[2].
  status input ststatus.
  ASSIGN rRowid# = ?.

  order-lines:
  repeat:
    l_split = no. /* INC56658 */
    /*
    MESSAGE 'can-find ' CAN-FIND(FIRST  scrtmp_sod_det)  SKIP
        'domain: ' domain SKIP
        'sonbr' sonbr
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  
    FOR EACH scrtmp_sod_det:
      MESSAGE "SOD" scrtmp_sod_det.sod_domain " / "  scrtmp_sod_det.sod_nbr " / "  scrtmp_sod_det.sod_line SKIP
      ordr-line
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
    */
    update ordr-line go-on("END-ERROR") with frame c editing:
      ASSIGN ordr-line = int(ordr-line:SCREEN-VALUE) NO-ERROR.
      FIND FIRST scrtmp_sod_det NO-LOCK WHERE scrtmp_sod_det.sod_domain = domain 
                                          AND scrtmp_sod_det.sod_nbr    = sonbr
                                          AND scrtmp_sod_det.sod_line   = ordr-line NO-ERROR.
        
      IF AVAIL scrtmp_sod_det THEN rRowid# = ROWID(scrtmp_sod_det).
      /*
      MESSAGE "Line: " ordr-line " - <" + ordr-line:SCREEN-VALUE + ">" 
      SKIP "avail" AVAIL scrtmp_sod_det
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      */
      {us/zu/zumfnpsod.i scrtmp_sod_det sod_nbrln "scrtmp_sod_det.sod_domain = domain and
                                         scrtmp_sod_det.sod_nbr = sonbr"
                              scrtmp_sod_det.sod_line ordr-line}
      if rRowid# <> ? then do:
        FIND FIRST scrtmp_sod_det NO-LOCK WHERE rowid(scrtmp_sod_det) = rRowid# NO-ERROR.
        display scrtmp_sod_det.sod_line @ ordr-line with frame c.
        ordr-line = input ordr-line.
        run disp-line-detail(domain).
      end.
      
      else if keyfunction(lastkey) = "HELP" then do:
        global_addr = sonbr.
        /* run "zu/zusodwgh.p". */
        run "av/avsodwgh.p".
        global_addr = scrtmp_so_mstr.so_cust.
      end.
      
    end. /* update ordr-line editing */
    ASSIGN global_addr = scrtmp_so_mstr.so_cust.
    
    if keyfunction(lastkey) = "END-ERROR" then do:
      y-n = false.
      if scrtmp_so_mstr.so_cust = "18A0395" then do:
        line-tot = 0.
        for each scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                                   and scrtmp_sod_det.sod_nbr = sonbr:
          line-tot = line-tot + scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_price.
        end.
        find cm_mstr no-lock where cm_mstr.cm_domain = domain
                               and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust.
        if line-tot >= dec(cm_mstr.cm_cr_rating) then do:
          display "Total Order Amount = " + string(line-tot,"->,>>>,>>9.99")
                   format "X(36)" skip(1)
                   with frame yn026 side-labels overlay row 8 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn026.
          hide frame yn026 no-pause.
          y-n = true.
        end.
      end.
      if y-n = true then next order-lines.

      leave order-lines.
    end.    
   
                
    IF AVAIL scrtmp_sod_det AND
       scrtmp_sod_det.sod_compl_stat <> ""
    THEN DO:
      MESSAGE "This salesorderline has completion status: " scrtmp_so_mstr.so_compl_stat SKIP(1)
              "Update of this salesorderline is not allowed."
              VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      UNDO order-lines, RETRY order-lines.    
    END.
   
    empty temp-table tt_quota. /* RFC2142 */
    empty temp-table scrtmp1. /* RFC2556 */
    ASSIGN lSuppresSaveLine# = FALSE.
    if ordr-line > 0 then
    run line-entry (domain, OUTPUT lSuppresSaveLine#).
    
    
    if scrtmp_so_mstr.so_cust = "18A0395" then do:
      line-tot = 0.
      for each scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                                 and scrtmp_sod_det.sod_nbr = sonbr:
        line-tot = line-tot + scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_price.
      end.
      find cm_mstr no-lock where cm_mstr.cm_domain = domain
                             and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust.
      if line-tot >= dec(cm_cr_rating) then do:
        display "Total Order Amount = " + string(line-tot,"->,>>>,>>9.99")
                 format "X(36)" skip(1)
                 with frame yn028 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn028.
        hide frame yn028 no-pause.
      end.
    end.
    
    FIND scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                           and scrtmp_sod_det.sod_nbr = sonbr
                           and scrtmp_sod_det.sod_line = ordr-line no-error.
    /* if F4 and no valid part and/or qty entered then delete record  */                           
    if LASTKEY = 404 AND avail scrtmp_sod_det AND (scrtmp_sod_det.sod_part = "" OR NOT can-find(FIRST pt_mstr NO-LOCK WHERE pt_mstr.pt_domain = domain AND pt_mstr.pt_part = scrtmp_sod_det.sod_part))  /* (AND scrtmp_sod_det.sod_qty_ord = 0) */
    THEN DELETE scrtmp_sod_det.
    ELSE DO:
        if avail scrtmp_sod_det then run disp-line-detail(domain).
        else do:
          clear frame c no-pause.
          clear frame d no-pause.
        end.

        
        IF NOT AVAIL scrtmp_sod_det AND
           CAN-FIND(FIRST scrtmp_sod_det) = FALSE
        THEN ASSIGN lSuppresSaveLine# = TRUE.
        
        IF lSuppresSaveLine# = FALSE
        THEN  DO:
      /* RFC2556 ADD BEGINS */
          for first scrtmp1 no-lock :
          end.
          if available scrtmp1 
          then do:
         create scrtmp_sod_det.
             buffer-copy scrtmp1 
             to scrtmp_sod_det.
          end.
      /* RFC2556 ADD ENDS */
          RUN SaveSoLocal(INPUT FALSE, OUTPUT lErro#).
                
          IF lErro# THEN UNDO, RETRY.
          /* RFC2142 ADD BEGINS */
          else do:
             for first tt_quota no-lock :
             end.
             if available tt_quota 
             then do:
                if l_nblck = yes and l_qtblck = yes
                then do:
                   assign
                      tt_actual_Qty = 0
                      tt_old_qty    = old-qty-ord
                      tt_ord_qty    = old-qty-ord
                      l_qtblck      = no.
                end.
                if ((l_blckquchk and l_qutblcqty <> 0))
                then do:
                   if l_qtblck 
                   then 
                      assign
                         tt_actual_qty = 0
                         tt_old_qty     =  l_qutblcqty  
                         tt_ord_qty     =  l_qutblcqty.
                      
                end. /* if ((l_blckquchk and */
                if not l_qtblck or l_blckquchk = yes  or l_nquo = yes
                then
                   run quota in hquota (input-output table tt_quota, 
                                     input old-qty-ord).
                else
                   empty temp-table tt_quota.
                release xxqt_det.        
             end. /* if available tt_quota  */
          end. /* else do */
          /* RFC2142 ADD ENDS */
        END.
    END.

  end. /* order-lines */
  

  run order-wrap-up(domain).

  hide frame d.
  hide frame c.

  if sls-rep then do:
    assign old-soldto = scrtmp_so_mstr.so_cust
           line-tot = 0.
    find glc_cal no-lock where glc_domain = domain
                           and glc_start <= scrtmp_so_mstr.so_ord_date
                           and glc_end   >= scrtmp_so_mstr.so_ord_date.
    find cm_mstr no-lock where cm_mstr.cm_domain = domain
                           and cm_mstr.cm_addr   = scrtmp_so_mstr.so_cust.
    for each bso_mstr no-lock where bso_mstr.so_domain  = domain
                               and bso_mstr.so_cust     = old-soldto
                               and bso_mstr.so_ord_date >= glc_start:
      for each bsod_det no-lock where bsod_det.sod_domain = bso_mstr.so_domain
                                  and bsod_det.sod_nbr    = bso_mstr.so_nbr:
        line-tot = line-tot + bsod_det.sod_qty_ord * bsod_det.sod_std_cost.
      end.
    end.
    for each ih_hist no-lock where ih_domain = domain
                               and ih_cust = old-soldto
                               and ih_inv_date >= glc_start:
      for each idh_hist no-lock where idh_domain = ih_domain
                                  and idh_inv_nbr = ih_inv_nbr
                                  and idh_nbr = ih_nbr:
        line-tot = line-tot + idh_hist.idh_qty_inv * idh_hist.idh_std_cost.
      end.
    end.
    lv_hdstatus = "". /* FT-645 */
    find Debtor no-lock where DebtorCode = scrtmp_so_mstr.so_cust.
    run getCreditData in hcrehd (input scrtmp_so_mstr.so_cust,
                                 input scrtmp_so_mstr.so_curr,   
                                 output lv_hdstatus). /* FT-645 */   
    /* if line-tot > DebtorFixedCredLimTC then DO : FT-645  */
     if (line-tot > DebtorFixedCredLimTC
        or lv_hdstatus = "HD")
     then do: /* FT-645 */ 
      hide message no-pause.
      scrtmp_so_mstr.so_stat = "HD".
      message "Status put on 'HD',"
              "due to total of orders is over the credit-limit ...".
    end.
  end.

  run update-trailer(domain).

  hide frame e no-pause.
  hide frame ab no-pause.

  /* 8494 Delete Begins
  find FIRST scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                               and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr no-error.
  if avail scrtmp_sod_det and can-do(ware-houses,wh-site) then do:

    assign pallets = 0
           i = 0
           next-due = hi_date.
    for each scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                               and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr
                               and (scrtmp_sod_det.sod_loc = "AIMS" or scrtmp_sod_det.sod_loc = "SAMPLES")
                               and (scrtmp_sod_det.sod_stat = "" or server-id = "test")
                               and scrtmp_sod_det.sod_type = ""
                               and scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship >= 1:
      i = i + 1.

      if scrtmp_sod_det.sod_due_date < next-due then next-due = scrtmp_sod_det.sod_due_date.
      /* calculate pallets */
      find xxpt_mstr no-lock where xxpt_part = scrtmp_sod_det.sod_part no-error.
      if scrtmp_sod_det.sod_um = "CS" and avail xxpt_mstr then do:
        if xxpt_mstr.xxpt_int[1] <> 0 and xxpt_mstr.xxpt_int[2] <> 0 then
          pallets = pallets + ((scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship) * scrtmp_sod_det.sod_um_conv)
                                                 / (xxpt_int[1] * xxpt_int[2]).
        else pallets = pallets + (((scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship) * (xxpt_height
                                            * xxpt_width * xxpt_depth)) / 1000)                           / ((xxpt_int[4] * xxpt_int[5] * xxpt_int[6]) / 1000).
      end.
      else if avail xxpt_mstr then do:
        if xxpt_int[1] <> 0 and xxpt_int[2] <> 0 then
          pallets = pallets + ((scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship) * scrtmp_sod_det.sod_um_conv)
                                                 / (xxpt_int[1] * xxpt_int[2]).
        else pallets = pallets + (((scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship) * ((xxpt_height
                             * xxpt_width * xxpt_depth) / 1000)) / scrtmp_sod_det.sod_um_conv)
                          / ((xxpt_int[4] * xxpt_int[5] * xxpt_int[6]) / 1000).
      end.
    end.
    if pallets >= 6 or i >= 30 then do:
      message "Patience please, alert message(s) being sent to Warehouse ...".
      /* 7747 ADD BEGINS */
      find ad_mstr no-lock
         where ad_mstr.ad_domain = scrtmp_so_mstr.so_domain
           and ad_mstr.ad_addr = scrtmp_so_mstr.so_ship no-error. /* 7934 */
      if available ad_mstr
      then do:
         assign
            lv_name = ad_mstr.ad_name.
            lv_addr =   ad_mstr.ad_line1 + " "
                        + ad_mstr.ad_line2 + " "
                        + ad_mstr.ad_line3 + " "
                        + ad_mstr.ad_city  + " "
                        + ad_mstr.ad_ctry  + " "
                        + ad_mstr.ad_zip.
      end. /* if available ad_mstr */
      output to value("/tmp/" + scrtmp_so_mstr.so_nbr + "-wh.txt").
      if server-id = "test"
      then
         put unformatted
          "This is a TEST, please discard this message ..." chr(10) chr(10).
        put unformatted "MAIL FROM :" mail-from chr(10). /*VM2*/

        put unformatted "Please be aware that Ordernumber '" scrtmp_so_mstr.so_nbr "'" chr(10)
                       "for the customer  '" scrtmp_so_mstr.so_ship "'"  chr(10)
                       "'" lv_addr "'" chr(10)
                      "with a first due-date of " next-due chr(10)
                      "has " i " lines and a total volume for "
                       round(pallets,2) " pallets !!!" chr(10). /* 7934 */
      output close.
      if mail-from = "" then
         mail-from = (if server-id = "test" then "test-" else "")
                   + "mfgpro@medline.com".


      for each code_mstr no-lock where code_mstr.code_domain = "XX"
                                   and code_mstr.code_fldname = "usr-mail"
                                   and code_mstr.code_value begins "wh" + wh-site
                                   and code_mstr.code_cmmt <> "":
        /* 7747 ADD BEGINS */
        if server-id = "test"
        then
          l_bmail = code_mstr.code_cmmt + ",psomanathan@medline.com".
        else
          l_bmail = code_mstr.code_cmmt.
        /* 7747 ADD ENDS */

         run us/av/avmail.p(l_bmail,                 /* Mail Address */
                   "Attention, BIG Order entered" ,  /* Subject      */
                    "/tmp/" + scrtmp_so_mstr.so_nbr + "-wh.txt",    /* Body         */
                    "",                              /* Attachment   */
                    no).                             /* Zip yes/no   */
                    

      end.
      os-delete value("/tmp/" + scrtmp_so_mstr.so_nbr + "-wh.txt").
      hide message no-pause.
    end.
  end.
  

  ASSIGN lContinueSave# = TRUE.
  IF CAN-FIND(FIRST scrtmp_sod_det) = FALSE
  THEN DO:
    ASSIGN lOk# = FALSE.
    MESSAGE 'This salesorder does not have any orderlines, processing is slow.' SKIP
            'Do you wish save the salesorder header?'
        VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO UPDATE lContinueSave#.
  END.
  
  IF lContinueSave#
  THEN RUN SaveSoLocal(INPUT TRUE, OUTPUT lErro#).
  IF lErro# THEN UNDO, RETRY.
  8494 Delete Ends */

  /* MLQ-00041 When required, CIM .7.9.15. Now disabled, first test MLQ-00047 + MLQ-00048 */
  /*   - MLQ-00047 + MLQ-00048 have been deployed, now enable the CIM's */
  RUN Cim_7_9_15.
  
  /* Obsolete: done via "zusodwrp.p" / "zusodemtsom.p"
  if emt-ordr = yes and can-find(FIRST scrtmp_sod_det where scrtmp_sod_det.sod_domain = wh-domain
                                                 and scrtmp_sod_det.sod_nbr = sonbr
                                                 and scrtmp_sod_det.sod_site = wh-site
                                                 and scrtmp_sod_det.sod_type = "") then do:
    run "zu/zuemtsom.p" (INPUT BUFFER scrtmp_so_mstr:HANDLE, wh-domain,wh-site).
  end.
  */
  
  pause 0 before-hide.

  clear frame a no-pause.
  clear frame sold_to no-pause.
  clear frame bill_to no-pause.
  clear frame ship_to no-pause.
  clear frame b no-pause.
  clear frame ab no-pause.
  clear frame proj-cmmt no-pause.
  clear frame upd-bomd-line all no-pause.

  assign global-so-nbr = sonbr
         global_ref = sonbr
         sonbr = "".

  release sod_det.
  release so_mstr.
  
  do for emtsom:
    release emtsom.
  end.
  do for emtsod.
    release emtsod.
  end.

end. /* repeat order-entry */

RUN SetLocalSoLock (INPUT ?,
                    INPUT ?,
                    OUTPUT cErro#).

RUN ClearLocks IN hProc# (INPUT THIS-PROCEDURE).

APPLY "CLOSE" TO hProc#.
DELETE OBJECT hProc# NO-ERROR.

PUBLISH "CloseSoPrintPl".



/*************** INTERNAL procedureS ************************/
/* 8494 Add Begins */
procedure SaveBeforeConf:
 
  find FIRST scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                               and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr no-error.
  if avail scrtmp_sod_det and can-do(ware-houses,wh-site) then do:

    assign pallets = 0
           i = 0
           next-due = hi_date.
    for each scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                               and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr
                               and (scrtmp_sod_det.sod_loc = "AIMS" or scrtmp_sod_det.sod_loc = "SAMPLES")
                               and (scrtmp_sod_det.sod_stat = "" or server-id = "test")
                               and scrtmp_sod_det.sod_type = ""
                               and scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship >= 1:
      i = i + 1.

      if scrtmp_sod_det.sod_due_date < next-due then next-due = scrtmp_sod_det.sod_due_date.
      /* calculate pallets */
      find xxpt_mstr no-lock where xxpt_part = scrtmp_sod_det.sod_part no-error.
      if scrtmp_sod_det.sod_um = "CS" and avail xxpt_mstr then do:
        if xxpt_mstr.xxpt_int[1] <> 0 and xxpt_mstr.xxpt_int[2] <> 0 then
          pallets = pallets + ((scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship) * scrtmp_sod_det.sod_um_conv)
                                                 / (xxpt_int[1] * xxpt_int[2]).
        else pallets = pallets + (((scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship) * (xxpt_height
                                            * xxpt_width * xxpt_depth)) / 1000)                           / ((xxpt_int[4] * xxpt_int[5] * xxpt_int[6]) / 1000).
      end.
      else if avail xxpt_mstr then do:
        if xxpt_int[1] <> 0 and xxpt_int[2] <> 0 then
          pallets = pallets + ((scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship) * scrtmp_sod_det.sod_um_conv)
                                                 / (xxpt_int[1] * xxpt_int[2]).
        else pallets = pallets + (((scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship) * ((xxpt_height
                             * xxpt_width * xxpt_depth) / 1000)) / scrtmp_sod_det.sod_um_conv)
                          / ((xxpt_int[4] * xxpt_int[5] * xxpt_int[6]) / 1000).
      end.
    end.
    if pallets >= 6 or i >= 30 then do:
      message "Patience please, alert message(s) being sent to Warehouse ...".
      /* 7747 ADD BEGINS */
      find ad_mstr no-lock
         where ad_mstr.ad_domain = scrtmp_so_mstr.so_domain
           and ad_mstr.ad_addr = scrtmp_so_mstr.so_ship no-error. /* 7934 */
      if available ad_mstr
      then do:
         assign
            lv_name = ad_mstr.ad_name.
            lv_addr =   ad_mstr.ad_line1 + " "
                        + ad_mstr.ad_line2 + " "
                        + ad_mstr.ad_line3 + " "
                        + ad_mstr.ad_city  + " "
                        + ad_mstr.ad_ctry  + " "
                        + ad_mstr.ad_zip.
      end. /* if available ad_mstr */
      output to value("/tmp/" + scrtmp_so_mstr.so_nbr + "-wh.txt").
      if server-id = "test"
      then
         put unformatted
          "This is a TEST, please discard this message ..." chr(10) chr(10).
        put unformatted "MAIL FROM :" mail-from chr(10). /*VM2*/

        put unformatted "Please be aware that Ordernumber '" scrtmp_so_mstr.so_nbr "'" chr(10)
                       "for the customer  '" scrtmp_so_mstr.so_ship "'"  chr(10)
                       "'" lv_addr "'" chr(10)
                      "with a first due-date of " next-due chr(10)
                      "has " i " lines and a total volume for "
                       round(pallets,2) " pallets !!!" chr(10). /* 7934 */
      output close.
      if mail-from = "" then
         mail-from = (if server-id = "test" then "test-" else "")
                   + "mfgpro@medline.com".


      for each code_mstr no-lock where code_mstr.code_domain = "XX"
                                   and code_mstr.code_fldname = "usr-mail"
                                   and code_mstr.code_value begins "wh" + wh-site
                                   and code_mstr.code_cmmt <> "":
        /* 7747 ADD BEGINS */
        if server-id = "test"
        then
          l_bmail = code_mstr.code_cmmt + ",psomanathan@medline.com".
        else
          l_bmail = code_mstr.code_cmmt.
        /* 7747 ADD ENDS */

         run us/av/avmail.p(l_bmail,                 /* Mail Address */
                   "Attention, BIG Order entered" ,  /* Subject      */
                    "/tmp/" + scrtmp_so_mstr.so_nbr + "-wh.txt",    /* Body         */
                    "",                              /* Attachment   */
                    no).                             /* Zip yes/no   */
                    

      end.
      os-delete value("/tmp/" + scrtmp_so_mstr.so_nbr + "-wh.txt").
      hide message no-pause.
    end.
  end.
  

  ASSIGN lContinueSave# = TRUE.
  IF CAN-FIND(FIRST scrtmp_sod_det) = FALSE
  THEN DO:
    ASSIGN lOk# = FALSE.
    MESSAGE 'This salesorder does not have any orderlines, processing is slow.' SKIP
            'Do you wish save the salesorder header?'
        VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO UPDATE lContinueSave#.
  END.
  
  IF lContinueSave#
  THEN RUN SaveSoLocal(INPUT TRUE, OUTPUT lErro#).
  IF lErro# THEN UNDO, RETRY.

end procedure. /* SaveBeforeConf */
/* 8494 Add Ends */
/************************************************************/
procedure update-trailer:
  def input parameter domain as char.

  run disp-amounts(domain).

  /* old-print-pl = scrtmp_so_mstr.so_print_pl. */
  ASSIGN scrtmp_so_mstr.so_print_pl = old-print-pl.
  
  upd-trailer:
  repeat:
    assign global_addr = scrtmp_so_mstr.so_cust
           global-mail-addr = ""
           global-fax-nbr = ""
           global-subject = ""
           conf-prntr = old-conf-pr
           print-conf = no.
    if scrtmp_so_mstr.so_cust = "HQO0001" then DO:
       ASSIGN scrtmp_so_mstr.so_print_pl = NO
              old-print-pl               = NO.
       
       PUBLISH "OverRuleSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                                    INPUT scrtmp_so_mstr.so_nbr,
                                    INPUT scrtmp_so_mstr.so_print_pl).
                                           
    END.
    find cm_mstr no-lock where cm_domain = domain
                           and cm_addr = scrtmp_so_mstr.so_cust no-error.
    /* PCM-112 DELETE BEGINS  
    if avail cm_mstr and cm__chr08 <> "" and entry(1,cm__chr10) <> "" then do:
      print-conf = yes.
      if cm__chr08 begins "e" then global-mail-addr = entry(1,cm__chr10).
      else if cm__chr08 begins "f" then global-fax-nbr = entry(1,cm__chr10).
      hide message no-pause.
      message "'Print Confirmation' flag has been automatically set to yes".
    end.
    *******PCM-112 DELETE ENDS */
    /* PCM-112 ADD BEGINS */
    if can-find(first xxcm_mstr   
       where xxcm_domain   = domain
         and xxcm_addr     = scrtmp_so_mstr.so_cust
         and xxcm_ordrconf <> ""
         and xxcm_mailaddr <> "")
    then do:
       print-conf = yes.
       global-mail-addr = fn_get_ordconf(domain,
                                         scrtmp_so_mstr.so_cust,
                                         "mail"). 
       hide message no-pause.
       message "'Print Confirmation' flag has been automatically set to yes".                                         
    end. /* IF CAN-FIND(first xxcm_mstr */                                         
   /* PCM-112 ADD ENDS */                                           
    

    old-stat = scrtmp_so_mstr.so_stat.
    
    ASSIGN old-print-pl = scrtmp_so_mstr.so_print_pl.
    
    RUN SetPrintPPLOverRule IN hProc# (INPUT TRUE).
    
    update scrtmp_so_mstr.so_trl1_cd scrtmp_so_mstr.so_trl1_amt
           scrtmp_so_mstr.so_trl2_cd scrtmp_so_mstr.so_trl2_amt
           scrtmp_so_mstr.so_trl3_cd scrtmp_so_mstr.so_trl3_amt
           scrtmp_so_mstr.so_stat when (index(scrtmp_so_mstr.so_stat, "I") = 0 and index(scrtmp_so_mstr.so_stat, "D") = 0)
           scrtmp_so_mstr.so__chr06
           scrtmp_so_mstr.so_print_pl
           print-conf
           go-on("END-ERROR") with frame e editing:
      readkey.
      apply lastkey.
      if frame-field = "so_trl1_cd" then do:
        find trl_mstr no-lock where trl_domain = domain
                                and trl_code = input scrtmp_so_mstr.so_trl1_cd no-error.
        if avail trl_mstr then display trl_desc @ descr[1] with frame e.
        else if input scrtmp_so_mstr.so_trl1_cd <> "" then
             display "??" @ descr[1] with frame e.
        else display "" @ descr[1] with frame e.
      end.
      else if frame-field = "so_trl2_cd" then do:
        find trl_mstr no-lock where trl_domain = domain
                                and trl_code = input scrtmp_so_mstr.so_trl2_cd no-error.
        if avail trl_mstr then display trl_desc @ descr[2] with frame e.
        else if input scrtmp_so_mstr.so_trl2_cd <> "" then
             display "???" @ descr[2] with frame e.
        else display "" @ descr[2] with frame e.
      end.
      else if frame-field = "so_trl3_cd" then do:
        find trl_mstr no-lock where trl_domain = domain
                                and trl_code = input scrtmp_so_mstr.so_trl3_cd no-error.
        if avail trl_mstr then display trl_desc @ descr[3] with frame e.
        else if input scrtmp_so_mstr.so_trl3_cd <> "" then
             display "????" @ descr[3] with frame e.
        else display "" @ descr[3] with frame e.
      end.
      else if frame-field = "so_trl1_amt" then do:
        if input scrtmp_so_mstr.so_trl1_cd = "" then display 0 @ scrtmp_so_mstr.so_trl1_amt with frame e.
        if scrtmp_so_mstr.so_trl1_cd <> input scrtmp_so_mstr.so_trl1_cd or scrtmp_so_mstr.so_trl1_amt <> input scrtmp_so_mstr.so_trl1_amt
        or scrtmp_so_mstr.so_trl2_cd <> input scrtmp_so_mstr.so_trl2_cd or scrtmp_so_mstr.so_trl2_amt <> input scrtmp_so_mstr.so_trl2_amt
        or scrtmp_so_mstr.so_trl3_cd <> input scrtmp_so_mstr.so_trl3_cd or scrtmp_so_mstr.so_trl3_amt <> input scrtmp_so_mstr.so_trl3_amt
        then do:
          assign scrtmp_so_mstr.so_trl1_cd = input scrtmp_so_mstr.so_trl1_cd scrtmp_so_mstr.so_trl1_amt = input scrtmp_so_mstr.so_trl1_amt
                 scrtmp_so_mstr.so_trl2_cd = input scrtmp_so_mstr.so_trl2_cd scrtmp_so_mstr.so_trl2_amt = input scrtmp_so_mstr.so_trl2_amt
                 scrtmp_so_mstr.so_trl3_cd = input scrtmp_so_mstr.so_trl3_cd scrtmp_so_mstr.so_trl3_amt = input scrtmp_so_mstr.so_trl3_amt.
          run disp-amounts(domain).
        end.
        if input scrtmp_so_mstr.so_trl1_cd = "" then apply lastkey.
      end.
      else if frame-field = "so_trl2_amt" then do:
        if input scrtmp_so_mstr.so_trl2_cd = "" then display 0 @ scrtmp_so_mstr.so_trl2_amt with frame e.
        if scrtmp_so_mstr.so_trl1_cd <> input scrtmp_so_mstr.so_trl1_cd or scrtmp_so_mstr.so_trl1_amt <> input scrtmp_so_mstr.so_trl1_amt
        or scrtmp_so_mstr.so_trl2_cd <> input scrtmp_so_mstr.so_trl2_cd or scrtmp_so_mstr.so_trl2_amt <> input scrtmp_so_mstr.so_trl2_amt
        or scrtmp_so_mstr.so_trl3_cd <> input scrtmp_so_mstr.so_trl3_cd or scrtmp_so_mstr.so_trl3_amt <> input scrtmp_so_mstr.so_trl3_amt
        then do:
          assign scrtmp_so_mstr.so_trl1_cd = input scrtmp_so_mstr.so_trl1_cd scrtmp_so_mstr.so_trl1_amt = input scrtmp_so_mstr.so_trl1_amt
                 scrtmp_so_mstr.so_trl2_cd = input scrtmp_so_mstr.so_trl2_cd scrtmp_so_mstr.so_trl2_amt = input scrtmp_so_mstr.so_trl2_amt
                 scrtmp_so_mstr.so_trl3_cd = input scrtmp_so_mstr.so_trl3_cd scrtmp_so_mstr.so_trl3_amt = input scrtmp_so_mstr.so_trl3_amt.
          run disp-amounts(domain).
        end.
        if input scrtmp_so_mstr.so_trl2_cd = "" then apply lastkey.
      end.
      else if frame-field = "so_trl3_amt" then do:
        if input scrtmp_so_mstr.so_trl3_cd = "" then display 0 @ scrtmp_so_mstr.so_trl3_amt with frame e.
        if scrtmp_so_mstr.so_trl1_cd <> input scrtmp_so_mstr.so_trl1_cd or scrtmp_so_mstr.so_trl1_amt <> input scrtmp_so_mstr.so_trl1_amt
        or scrtmp_so_mstr.so_trl2_cd <> input scrtmp_so_mstr.so_trl2_cd or scrtmp_so_mstr.so_trl2_amt <> input scrtmp_so_mstr.so_trl2_amt
        or scrtmp_so_mstr.so_trl3_cd <> input scrtmp_so_mstr.so_trl3_cd or scrtmp_so_mstr.so_trl3_amt <> input scrtmp_so_mstr.so_trl3_amt
        then do:
          assign scrtmp_so_mstr.so_trl1_cd = input scrtmp_so_mstr.so_trl1_cd scrtmp_so_mstr.so_trl1_amt = input scrtmp_so_mstr.so_trl1_amt
                 scrtmp_so_mstr.so_trl2_cd = input scrtmp_so_mstr.so_trl2_cd scrtmp_so_mstr.so_trl2_amt = input scrtmp_so_mstr.so_trl2_amt
                 scrtmp_so_mstr.so_trl3_cd = input scrtmp_so_mstr.so_trl3_cd scrtmp_so_mstr.so_trl3_amt = input scrtmp_so_mstr.so_trl3_amt.
          run disp-amounts(domain).
        end.
        if input scrtmp_so_mstr.so_trl3_cd = "" then apply lastkey.
      end.
    end. /* frame e editing: */

    /*
    PUBLISH "OverRuleSoPrintPl" (INPUT domain,
                                 INPUT scrtmp_so_mstr.so_nbr,
                                 INPUT  scrtmp_so_mstr.so_print_pl).
    */
    
    find FIRST scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                                 and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr no-error.
    if avail scrtmp_sod_det and can-do(ware-houses,scrtmp_sod_det.sod_site) then do:

      if scrtmp_so_mstr.so_print_pl = no /*and old-print-pl = yes*/ then do:
        y-n = yes.
        display "Print Pack-list flag is on 'no', this will prevent" skip
                "downloading this Sales-Order to the Warehouse !!!!" skip
                "Is this what you really want ??" skip(1)
                 with frame yn030 side-labels overlay row 10 col 10.
        update y-n label "Yes or No" go-on("END-ERROR") with frame yn030.
        hide frame yn030 no-pause.
        if y-n <> yes then do:
          next-prompt scrtmp_so_mstr.so_print_pl.
          next upd-trailer.
        end.
      end.
    end.

    /*
    PUBLISH "OverRuleSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                                 INPUT scrtmp_so_mstr.so_nbr,
                                 INPUT  scrtmp_so_mstr.so_print_pl).
    */
    
    if scrtmp_so_mstr.so_trl1_amt = 0 then scrtmp_so_mstr.so_trl1_cd = "".
    if scrtmp_so_mstr.so_trl2_amt = 0 then scrtmp_so_mstr.so_trl2_cd = "".
    if scrtmp_so_mstr.so_trl3_amt = 0 then scrtmp_so_mstr.so_trl3_cd = "".

    if scrtmp_so_mstr.so_trl1_cd <> "" then do:
      find trl_mstr no-lock where trl_domain = domain
                              and trl_code = scrtmp_so_mstr.so_trl1_cd no-error.
      if avail trl_mstr then display trl_desc @ descr[1] with frame e.
      else do:
        display "Cost-code 1 is not defined (yet) !!!" skip(1)
                 with frame yn031 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn031.
        hide frame yn031 no-pause.
        next-prompt scrtmp_so_mstr.so_trl1_cd with frame e.
        next upd-trailer.
      end.

      if can-do("E,Z",scrtmp_so_mstr.so_taxc) and not trl_taxable then .
      else if scrtmp_so_mstr.so_taxable <> trl_taxable then do:
        display "Cost-code '" + scrtmp_so_mstr.so_trl1_cd +
                "' does NOT have the right taxable" format "X(50)" skip
                "setting, please select the right coding ..." skip(1)
                 with frame yn032 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn032.
        hide frame yn032 no-pause.
        next-prompt scrtmp_so_mstr.so_trl1_cd with frame e.
        next upd-trailer.
      end.
    end.
    else scrtmp_so_mstr.so_trl1_amt = 0.

    if scrtmp_so_mstr.so_trl2_cd <> "" then do:
      find trl_mstr no-lock where trl_domain = domain
                              and trl_code = scrtmp_so_mstr.so_trl2_cd no-error.
      if avail trl_mstr then display trl_desc @ descr[2] with frame e.
      else do:
        display "Cost-code 2 is not defined (yet) !!!" skip(1)
                 with frame yn033 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn033.
        hide frame yn033 no-pause.
        next-prompt scrtmp_so_mstr.so_trl2_cd with frame e.
        next upd-trailer.
      end.
      if can-do("E,Z",scrtmp_so_mstr.so_taxc) and not trl_taxable then .
      else if scrtmp_so_mstr.so_taxable <> trl_taxable then do:
        display "Cost-code '" + scrtmp_so_mstr.so_trl2_cd +
                "' does NOT have the right taxable" format "X(50)" skip
                "setting, please select the right coding ..." skip(1)
                 with frame yn034 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn034.
        hide frame yn034 no-pause.
        next-prompt scrtmp_so_mstr.so_trl2_cd with frame e.
        next upd-trailer.
      end.
    end.
    else scrtmp_so_mstr.so_trl2_amt = 0.

    if scrtmp_so_mstr.so_trl3_cd <> "" then do:
      find trl_mstr no-lock where trl_domain = domain
                              and trl_code = scrtmp_so_mstr.so_trl3_cd no-error.
      if avail trl_mstr then display trl_desc @ descr[3] with frame e.
      else do:
        display "Cost-code 3 is not defined (yet) !!!" skip(1)
                 with frame yn035 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn035.
        hide frame yn035 no-pause.
        next-prompt scrtmp_so_mstr.so_trl3_cd with frame e.
        next upd-trailer.
      end.
      if can-do("E,Z",scrtmp_so_mstr.so_taxc) and not trl_taxable then .
      else if scrtmp_so_mstr.so_taxable <> trl_taxable then do:
        display "Cost-code '" + scrtmp_so_mstr.so_trl3_cd +
                "' does NOT have the right taxable" format "X(50)" skip
                "setting, please select the right coding ..." skip(1)
                 with frame yn036 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn036.
        hide frame yn036 no-pause.
        next-prompt scrtmp_so_mstr.so_trl3_cd with frame e.
        next upd-trailer.
      end.
    end.
    else scrtmp_so_mstr.so_trl3_amt = 0.

    if scrtmp_so_mstr.so__chr06 <> "" and scrtmp_so_mstr.so__chr06 <> "EDI" then do:
      find prd_det no-lock where prd_dev = scrtmp_so_mstr.so__chr06 no-error.
      if not avail prd_det then do:
        display "The entered Invoice-Printer does not exist (yet) !!!" skip(1)
                 with frame yn037 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn037.
        hide frame yn037 no-pause.
        next-prompt scrtmp_so_mstr.so__chr06 with frame e.
        next upd-trailer.
      end.
      else if not prd_type begins "INV" then do:
        display "The selected printer is not suitable for invoice-printing !!!"
                 skip(1) with frame yn038 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn038.
        hide frame yn038 no-pause.
        next-prompt scrtmp_so_mstr.so__chr06 with frame e.
        next upd-trailer.
      end.
    end.
    leave upd-trailer.
  end. /* upd-trailer */

  if print-conf = no then assign global-mail-addr = ""          
                                 global-fax-nbr = ""
                                 global-subject = "".

  pause before-hide.
  run "zu/zusohold.p" (INPUT scrtmp_so_mstr.so_nbr, INPUT scrtmp_so_mstr.so_bill, INPUT-OUTPUT scrtmp_so_mstr.so_stat).

  display scrtmp_so_mstr.so_stat with frame e.

  run disp-amounts(domain).

  pause 0 before-hide.

  run SaveBeforeConf. /* 8494 */

  if print-conf then do:
    find cm_mstr no-lock where cm_domain = domain
                           and cm_addr = scrtmp_so_mstr.so_cust no-error.
    /* PCM-112 DELETE BEGINS                         
    if avail cm_mstr and cm__chr08 <> "" and entry(1,cm__chr10) <> "" then
      conf-prntr = "ediocr-" + substr(cm__chr08,1,1). 
    *****PCM-112 DELETE ENDS */
    /* PCM-112 ADD BEGINS */
    if can-find(first xxcm_mstr   
       where xxcm_domain   = domain
         and xxcm_addr     = scrtmp_so_mstr.so_cust
         and xxcm_ordrconf <> ""
         and xxcm_mailaddr <> "")
    then
       conf-prntr = "ediocr-" 
                    + fn_get_ordconf(domain,
                                     scrtmp_so_mstr.so_cust,
                                     "chn").   
    /* PCM-112 ADD ENDS  */
   

    else conf-printer:
    do on error undo, retry:
      update conf-prntr go-on("END-ERROR") with frame e editing:
        {us/zu/zumfnp05.i prd_det prd_dev "prd_dev <> ''"
                             prd_dev "input conf-prntr"}
        if lastkey = -1 or keyfunction(lastkey) = "END-ERROR" then
          leave conf-printer.
        else if rRowid# <> ? then display prd_dev @ conf-prntr with frame e.
      end.
      if keyfunction(lastkey) = "END-ERROR" then leave conf-printer.
      if conf-prntr = "" then leave.
      find prd_det no-lock where prd_dev = conf-prntr no-error.
      if not avail prd_det then do:
        display "The entered Printer does not exist (yet) !!!" skip(1)
                 with frame yn039 side-labels overlay row 10 col 10.
       update yn blank label "Press Enter" go-on("END-ERROR") with frame yn039.
        hide frame yn039 no-pause.
        undo conf-printer, retry conf-printer.
      end.
      else if conf-prntr = "terminal" then do:
        display "Printer 'Terminal' is not allowed !!!!!!!" skip(1)
                 with frame yn040 side-labels overlay row 10 col 10.
       update yn blank label "Press Enter" go-on("END-ERROR") with frame yn040.
        hide frame yn040 no-pause.
        undo conf-printer, retry conf-printer.
      end.
      else if conf-prntr = "email" then do:
        display "Printer 'email' is not allowed !!!!!!!" skip(1)
                 with frame yn0401 side-labels overlay row 10 col 10.
      update yn blank label "Press Enter" go-on("END-ERROR") with frame yn0401.
        hide frame yn0401 no-pause.
        undo conf-printer, retry conf-printer.
      end.

      if conf-prntr begins "fax" then do:
        find ad_mstr no-lock where ad_mstr.ad_domain = domain
                               and ad_mstr.ad_addr = scrtmp_so_mstr.so_cust no-error.
        if conf-prntr = "fax2" then do:
          assign fax-attn = ad_mstr.ad_attn2
                 fax-nbr = ad_mstr.ad_fax2.
          if fax-nbr = "" then fax-nbr = ad_mstr.ad_fax.
          if fax-attn = "" then fax-attn = ad_mstr.ad_attn.
        end.
        else assign fax-nbr = ad_mstr.ad_fax
                    fax-attn = ad_mstr.ad_attn.
        display fax-attn with frame faxnbr.
        update fax-nbr go-on("END-ERROR") with frame faxnbr.
        hide frame faxnbr.
        if fax-nbr = "" then do:
          display "Nothing will be faxed !!!" skip(1)
                   with frame yn041 side-labels overlay row 10 col 10.
       update yn blank label "Press Enter" go-on("END-ERROR") with frame yn041.
          hide frame yn041 no-pause.
          undo conf-printer, retry conf-printer.
        end.
      end.
      old-conf-pr = conf-prntr.
    end.

   /* run SaveBeforeConf. /* 8494 */ */

    output to value(mfguser + "-" + sonbr + ".cim").
    put unformatted '"' scrtmp_so_mstr.so_site '" "' sonbr '" "' sonbr '" yes' chr(10).
    if conf-prntr begins "page" then put unformatted '"spool"' chr(10).
    else put unformatted '"' conf-prntr '"' chr(10).
    if conf-prntr begins "fax" then put unformatted '"' fax-nbr '"' chr(10).
    output close.

    input from value(mfguser + "-" + sonbr + ".cim").
    output to value(mfguser + "-" + sonbr + ".log").
    batchrun = yes.

    run "av/avmpssls.p".

    batchrun = no.
    output close.
    input close.

    os-delete value(mfguser + "-" + sonbr + ".cim").
    os-delete value(mfguser + "-" + sonbr + ".log").

    if conf-prntr begins "page" then do:
      hide frame e no-pause.
      hide frame ab no-pause.

      run "gp/gppage.p" (mfguser + ".out").

      view frame ab.
      view frame e.
      conf-prntr = "".
    end.
  end. /* conf-printer */

end procedure. /* update-trailer */
/***********************************************************************/
procedure disp-amounts:
  def input parameter domain as char.

  if scrtmp_so_mstr.so_domain <> domain THEN MESSAGE "disp-amounts alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
  assign line-tot = 0
         vat-amt = 0.

  for each scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                             and scrtmp_sod_det.sod_nbr = sonbr:
    line-tot = line-tot + (scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship) * scrtmp_sod_det.sod_price.
    if sod_taxable then do:
      run "av/avgettax.p" (domain,scrtmp_sod_det.sod_tax_env,scrtmp_sod_det.sod_taxc,scrtmp_sod_det.sod_tax_usage,
                      tax-date,output vat-pct,output vat-pcth,output vat-pctl).
      if sod_tax_in then assign
        line-tot = line-tot
                 - (((scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship) * scrtmp_sod_det.sod_price) /
                                                  (100 + vat-pct)) * vat-pct
        vat-amt = vat-amt
                + (((scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship) * scrtmp_sod_det.sod_price) /
                                                  (100 + vat-pct)) * vat-pct.
      else vat-amt = vat-amt
                   + ((scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship) * scrtmp_sod_det.sod_price) *
                                                             (vat-pct / 100).
    end.
  end.

  if scrtmp_so_mstr.so_tax_date <> ? then tax-date = scrtmp_so_mstr.so_tax_date.
  else if scrtmp_so_mstr.so_ship_date <> ? then tax-date = scrtmp_so_mstr.so_ship_date.
  else tax-date = scrtmp_so_mstr.so_due_date.

  if scrtmp_so_mstr.so_trl1_amt <> 0 then do:
    find first trl_mstr where trl_domain = domain
                          and trl_code = scrtmp_so_mstr.so_trl1_cd no-error.
    if avail trl_mstr and trl_taxable then do:
      run "av/avgettax.p" (domain,scrtmp_so_mstr.so_tax_env,trl_taxc,scrtmp_so_mstr.so_tax_usage,
                      tax-date,output vat-pct,output vat-pcth,output vat-pctl).
      vat-amt = vat-amt + scrtmp_so_mstr.so_trl1_amt * (vat-pct / 100).
    end.
  end.
  if scrtmp_so_mstr.so_trl2_amt <> 0 then do:
    find first trl_mstr where trl_domain = domain
                          and trl_code = scrtmp_so_mstr.so_trl2_cd no-error.
    if avail trl_mstr and trl_taxable then do:
      run "av/avgettax.p" (domain,scrtmp_so_mstr.so_tax_env,trl_taxc,scrtmp_so_mstr.so_tax_usage,
                      tax-date,output vat-pct,output vat-pcth,output vat-pctl).
      vat-amt = vat-amt + scrtmp_so_mstr.so_trl2_amt * (vat-pct / 100).
    end.
  end.
  if scrtmp_so_mstr.so_trl3_amt <> 0 then do:
    find first trl_mstr where trl_domain = domain
                          and trl_code = scrtmp_so_mstr.so_trl3_cd no-error.
    if avail trl_mstr and trl_taxable then do:
      run "av/avgettax.p" (domain,scrtmp_so_mstr.so_tax_env,trl_taxc,scrtmp_so_mstr.so_tax_usage,
                      tax-date,output vat-pct,output vat-pcth,output vat-pctl).
      vat-amt = vat-amt + scrtmp_so_mstr.so_trl3_amt * (vat-pct / 100).
    end.
  end.

  display line-tot
          scrtmp_so_mstr.so_trl1_cd scrtmp_so_mstr.so_trl1_amt
          scrtmp_so_mstr.so_trl2_cd scrtmp_so_mstr.so_trl2_amt
          scrtmp_so_mstr.so_trl3_cd scrtmp_so_mstr.so_trl3_amt
          vat-amt
          line-tot + vat-amt
                   + scrtmp_so_mstr.so_trl1_amt + scrtmp_so_mstr.so_trl2_amt + scrtmp_so_mstr.so_trl3_amt @ total-amt
          scrtmp_so_mstr.so_curr scrtmp_so_mstr.so_stat scrtmp_so_mstr.so__chr06 scrtmp_so_mstr.so_print_pl
          with frame e.

  if scrtmp_so_mstr.so_trl1_cd <> "" then do:
    find trl_mstr no-lock where trl_domain = domain
                            and trl_code = scrtmp_so_mstr.so_trl1_cd no-error.
    if avail trl_mstr then display trl_desc @ descr[1] with frame e.
    else display "??" @ descr[1] with frame e.
  end.
  if scrtmp_so_mstr.so_trl2_cd <> "" then do:
    find trl_mstr no-lock where trl_domain = domain
                            and trl_code = scrtmp_so_mstr.so_trl2_cd no-error.
    if avail trl_mstr then display trl_desc @ descr[2] with frame e.
    else display "???" @ descr[2] with frame e.
  end.
  if scrtmp_so_mstr.so_trl3_cd <> "" then do:
    find trl_mstr no-lock where trl_domain = domain
                            and trl_code = scrtmp_so_mstr.so_trl3_cd no-error.
    if avail trl_mstr then display trl_desc @ descr[3] with frame e.
    else display "????" @ descr[3] with frame e.
  end.

end procedure. /* disp-amounts */
/***********************************************************************/
procedure input-addresses:
  def input parameter domain as char.

  DEFINE VARIABLE cOldShipTo# AS CHARACTER   NO-UNDO.
  
  if scrtmp_so_mstr.so_domain <> domain THEN MESSAGE "input-addresses alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.

  old-soldto = scrtmp_so_mstr.so_cust.
  cOldShipTo# = scrtmp_so_mstr.so_ship.

  pause 0 before-hide.

  customer-entry:
  repeat:
    if new-order then do:
      find first soc_ctrl no-lock where soc_domain = domain.
      so-cmmts = soc_hcmmts.
      display so-cmmts with frame b.
    end.

    if not can-find(first ih_hist where ih_domain = domain
                                    and ih_nbr = sonbr) and
       scrtmp_so_mstr.so_inv_nbr = "" then
    update scrtmp_so_mstr.so_cust go-on("END-ERROR") with frame a editing:
      {us/av/avbrwinc.i cm_mstr cm_addr "cm_domain = domain and
                                       length(cm_addr) = 7 and
                                       can-do(sosite,cm_site)
                                       and cm_active = yes"
                              cm_addr "input scrtmp_so_mstr.so_cust" "Index"}
      if lastkey = -1 or keyfunction(lastkey) = "END-ERROR" then leave.
      else if recno <> ? then do:
        scrtmp_so_mstr.so_cust = cm_addr.
        display scrtmp_so_mstr.so_cust with frame a.

        find ad_mstr no-lock where ad_mstr.ad_domain = domain
                               and ad_mstr.ad_addr = scrtmp_so_mstr.so_cust no-error.
        if avail ad_mstr then display ad_mstr.ad_name
                                      ad_mstr.ad_line1
                                      ad_mstr.ad_line2
                                      ad_mstr.ad_line3
                                      ad_mstr.ad_zip + "  " + ad_mstr.ad_city @ ad_mstr.ad_city
                                      with frame sold_to.
      end.
    end.

    if lastkey = -1 or keyfunction(lastkey) = "END-ERROR" then return error.

    if length(scrtmp_so_mstr.so_cust) <> 7 then do:
      display "You may only enter Customer-address codes of 7 characters..."
               skip(1)  with frame yn042 side-labels overlay row 10 col 10.
      update yn blank label "Press Enter" go-on("END-ERROR") with frame yn042.
      hide frame yn042 no-pause.
      next customer-entry.
    end.

    find cm_mstr no-lock where cm_mstr.cm_domain = domain
                           and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust no-error.
    if not avail cm_mstr then do:
      {us/bbi/mfmsg.i 3 3}
      next customer-entry.
    end.

    if not cm_mstr.cm_active and (new-order or old-soldto <> scrtmp_so_mstr.so_cust) then do:
      display "This is an Inactive Customer !!!" skip
              "If you need to use this address then have it re-Activated."
              skip(1)  with frame yn043 side-labels overlay row 10 col 10.
      update yn blank label "Press Enter" go-on("END-ERROR") with frame yn043.
      hide frame yn043 no-pause.
      undo, retry.
    end.
    if not cm_mstr.cm_datacomplete then do:
      {us/bbi/mfmsg.i 7039 3}
      next customer-entry.
    end.

    if fn_addr_blocked(domain,scrtmp_so_mstr.so_cust,"SO001") then do:
      display "This Customer is Blocked for use !!!..." skip(1)
              with frame yn0431 side-labels overlay row 10 col 10.
      update yn blank label "Press Enter" go-on("END-ERROR") with frame yn0431.
      hide frame yn0431 no-pause.
      undo, retry.
    end.
    /* RFC26474 ADD BEGINS */
    ll_group = no.
    run groupingcheck(input scrtmp_so_mstr.so_cust,
                        output ll_group). 
     if ll_group = yes
     then do:
       {pxmsg.i &msgnum = 77788 &errorlevel = 3}
       undo customer-entry,retry customer-entry.  
     end. /* if ll_group = yes */
     /* RFC26474 ADD ENDS */

    /* Check for existing shipments */
    if new-order = no and scrtmp_so_mstr.so_cust <> old-soldto then do:
      find first tr_hist no-lock where tr_domain = domain
                                   and tr_nbr = sonbr
                                   and tr_type = "ISS-SO" no-error.
      if avail tr_hist then do:
        {us/bbi/mfmsg.i 3040 3} /*cannot modify -- tr_hist exists*/
        next customer-entry.
      end.
    end.

    find ad_mstr no-lock where ad_mstr.ad_domain = domain
                           and ad_mstr.ad_addr = scrtmp_so_mstr.so_cust no-error.
    if avail ad_mstr then display ad_mstr.ad_name
                                  ad_mstr.ad_line1
                                  ad_mstr.ad_line2
                                  ad_mstr.ad_line3
                                  ad_mstr.ad_zip + "  " + ad_mstr.ad_city @ ad_mstr.ad_city
                                  with frame sold_to.

    find cm_mstr no-lock where cm_mstr.cm_domain = domain
                           and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust no-error.
    if not avail ad_mstr or not avail cm_mstr then do:
      {us/bbi/mfmsg.i 3 3}
      next customer-entry.
    end.

    /* After customer update check if customers country should consume FC */
    if not can-do("AU,MY,TH,HK,PH,CN,JP,MU,SG", ad_mstr.ad_ctry)
    then l-cust-ctry-consume = yes.
    else l-cust-ctry-consume = no.

    if new-order then do:
      find ad_mstr no-lock where ad_mstr.ad_domain = domain
                             and ad_mstr.ad_addr = cm_mstr.cm_site no-error.
      if not avail ad_mstr then do:
        display "This Customer has an invalid Sales-Office-Site-code !!!"
                skip(1)  with frame yn044 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn044.
        hide frame yn044 no-pause.
        next customer-entry.
      end.
    end.
    global_addr = scrtmp_so_mstr.so_cust.

    if new-order then do:
      if sonbr begins "IB" then scrtmp_so_mstr.so_bill = "67000010".
      else if cm_mstr.cm_bill <> "" and
              CAN-FIND(cm-bt where cm-bt.cm_domain = domain
                         and cm-bt.cm_addr = cm_mstr.cm_bill
                         and cm-bt.cm_active = yes)
           then scrtmp_so_mstr.so_bill = cm_mstr.cm_bill.
           else scrtmp_so_mstr.so_bill = scrtmp_so_mstr.so_cust.

      find first ad_mstr no-lock where ad_mstr.ad_domain = domain
                                   and ad_mstr.ad_ref = scrtmp_so_mstr.so_cust
                                   and ad_mstr.ad_type = "Ship-To"
                                   and ad_mstr.ad_temp = no no-error.
      if not avail ad_mstr then
        find first ad_mstr no-lock where ad_mstr.ad_domain = domain
                                     and ad_mstr.ad_ref = scrtmp_so_mstr.so_bill
                                     and ad_mstr.ad_type = "Ship-To"
                                     and ad_mstr.ad_temp = no no-error.
      if avail ad_mstr then scrtmp_so_mstr.so_ship = ad_mstr.ad_addr.
      else scrtmp_so_mstr.so_ship = scrtmp_so_mstr.so_cust.

      display scrtmp_so_mstr.so_bill scrtmp_so_mstr.so_ship with frame a.
    end.

    old-billto = scrtmp_so_mstr.so_bill.

    if not can-find(FIRST scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                    and scrtmp_sod_det.sod_nbr = sonbr
                                    and (scrtmp_sod_det.sod_stat <> "" or scrtmp_sod_det.sod_qty_ship <> 0))
      and not can-find(first ih_hist where ih_domain = domain
                                       and ih_nbr = sonbr)
      and scrtmp_so_mstr.so_inv_nbr = "" then if cm_mstr.cm_site <> "900" then do:
      if so-cmmts = yes then do:
        hide frame b no-pause.
        hide frame ship_to no-pause.
        hide frame sold_to no-pause.
        hide frame a no-pause.
        run upd-header-cmmts(domain).
      end. /* IF so-cmmts = YES */
      else scrtmp_so_mstr.so_cmtindx = 0.
    end.
    display so-cmmts with frame b.

    hide all no-pause.
/*    if c-application-mode = "" then view frame dtitle.*/
    view frame a.
    view frame sold_to.

    display so-cmmts with frame b.

    billto-entry:
    do on error undo, retry:
      hide frame ship_to.
      view frame bill_to.


      find cm-bt no-lock where cm-bt.cm_domain = domain
                             and cm-bt.cm_addr = scrtmp_so_mstr.so_bill no-error.

      /*multiple bill-to addresses*/
      if billto-id ne 0 then
      do:
        scrtmp_so_mstr.so__dec01 = billto-id.
        find first address where
                   address.Address_ID = int(scrtmp_so_mstr.so__dec01)
        no-lock no-error.

        if available address then
        do:
          display AddressName @ ad_mstr.ad_name
                  AddressStreet1 @ ad_mstr.ad_line1
                  AddressStreet2 @ ad_mstr.ad_line2
                  AddressStreet3 @ ad_mstr.ad_line3
                  AddressZip + "  " + AddressCity @ ad_mstr.ad_city
                  with frame bill_to .
        end.
      end.
      else do:
        find ad_mstr no-lock where ad_mstr.ad_domain = domain
                               and ad_mstr.ad_addr = scrtmp_so_mstr.so_bill no-error.

        if avail ad_mstr then display ad_mstr.ad_name
                                      ad_mstr.ad_line1
                                      ad_mstr.ad_line2
                                      ad_mstr.ad_line3
                                      ad_mstr.ad_zip + "  " + ad_mstr.ad_city @ ad_mstr.ad_city
                                      with frame bill_to.
      end.

      if not can-find(first ih_hist where ih_domain = domain
                                      and ih_nbr = sonbr)
        and scrtmp_so_mstr.so_inv_nbr = "" then
      update scrtmp_so_mstr.so_bill go-on("END-ERROR") with frame a editing:
        {us/av/avbrwinc.i cm-bt cm_addr "cm-bt.cm_domain = domain and
                                       length(cm-bt.cm_addr) >= 7 and
                                       can-do(sosite,cm-bt.cm_site) and
                                       cm-bt.cm_active = yes"
                              cm-bt.cm_addr "input scrtmp_so_mstr.so_bill" "Index"}
        if lastkey = -1 or keyfunction(lastkey) = "END-ERROR" then leave.
        else if recno <> ? then do:
          display cm-bt.cm_addr @ scrtmp_so_mstr.so_bill with frame a.
          find ad_mstr no-lock where ad_mstr.ad_domain = domain
                                 and ad_mstr.ad_addr = input scrtmp_so_mstr.so_bill no-error.
          if avail ad_mstr then display ad_mstr.ad_name
                                        ad_mstr.ad_line1
                                        ad_mstr.ad_line2
                                        ad_mstr.ad_line3
                                        ad_mstr.ad_zip + "  " + ad_mstr.ad_city @ ad_mstr.ad_city
                                        with frame bill_to.
        end.
      end. /* update scrtmp_so_mstr.so_bill editing */

      if lastkey = -1 or keyfunction(lastkey) = "END-ERROR" then
        next customer-entry.

      for each addr-list:
        delete addr-list.
      end.

      find first Debtor where Debtor.DebtorCode = scrtmp_so_mstr.so_bill
      no-lock no-error.

      if avail Debtor
        and not can-find(first ih_hist where ih_domain = domain
                                         and ih_nbr = sonbr)
        and scrtmp_so_mstr.so_inv_nbr = ""
      then do:
        find first BusinessRelation where
              BusinessRelation.BusinessRelation_ID = Debtor.BusinessRelation_ID
                                    no-lock no-error.
        if avail BusinessRelation then
        do:
          find first AddressType where AddressType.AddressTypeCode = "Bill-To"
          no-lock no-error.

          for each address no-lock where
             address.BusinessRelation_ID = BusinessRelation.BusinessRelation_ID
               and address.addressType_ID = AddressType.AddressType_ID:
            create addr-list.
            assign addr-list.id = Address_ID
                   addr-list.name = AddressName
                   addr-list.addr = AddressStreet1 + " "
                                  + AddressStreet2 + " "
                                  + AddressStreet3
                   addr-list.city = AddressZip + " " + AddressCity.
          end.
        end.
      end.

      if can-find(first addr-list) then do:
        if avail BusinessRelation then do:
        find first AddressType where AddressType.AddressTypeCode = "HEADOFFICE"
                  no-lock no-error.

          find first address where
            address.BusinessRelation_ID = BusinessRelation.BusinessRelation_ID
                 and address.addressType_ID = AddressType.AddressType_ID
                  no-lock no-error.
          if avail address then do:
            create addr-list.
            assign
              addr-list.id = Address_ID
              addr-list.name = AddressName
              addr-list.addr = AddressStreet1 + " "
                             + AddressStreet2 + " "
                             + AddressStreet3
              addr-list.city = AddressZip + " " + AddressCity.
          end.
        end.

        on default-action of addr-brwse-1 in frame addr-a1 do:
          billto-id = addr-list.id.
          scrtmp_so_mstr.so__dec01 = dec(addr-list.id).
          apply "WINDOW-CLOSE" to addr-brwse-1.
          find first address where
                     address.Address_ID = int(scrtmp_so_mstr.so__dec01)
          no-lock no-error.

          if available address then
          do:
            display AddressName @ ad_mstr.ad_name
                    AddressStreet1 @ ad_mstr.ad_line1
                    AddressStreet2 @ ad_mstr.ad_line2
                    AddressStreet3 @ ad_mstr.ad_line3
                    AddressZip + "  " + AddressCity @ ad_mstr.ad_city
                    with frame bill_to .
          end.
        end.

        open query addr-qry-1 for each addr-list by name.
        enable addr-brwse-1 with frame addr-a1.
        wait-for window-close,"END-ERROR" of current-window focus addr-brwse-1.
        hide frame addr-a1.
      end.

      if old-billto <> scrtmp_so_mstr.so_bill then do:
        find cm-bt no-lock where cm-bt.cm_domain = domain
                             and cm-bt.cm_addr = scrtmp_so_mstr.so_bill no-error.
        if not avail cm-bt then do:
          display "The entered Bill-To does NOT exist (yet) !!!" skip(1)
                   with frame yn045 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn045.
          undo billto-entry, retry billto-entry.
        end.
        if not cm-bt.cm_active then do:
          display "This is an Inactive Customer-Code !!!" skip
                  "If you need to use this address then have it re-Activated."
              skip(1)  with frame yn046 side-labels overlay row 10 col 15.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn046.
          hide frame yn046 no-pause.
          undo billto-entry, retry billto-entry.
        end.
        if not cm-bt.cm_datacomplete then do:
          display "ERROR: Customer data is not complete.  Please re-enter."
              skip(1)  with frame yn0461 side-labels overlay row 10 col 15.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn0461.
          hide frame yn0461 no-pause.
          undo billto-entry, retry billto-entry.
        end.
      end.
      if fn_addr_blocked(domain,scrtmp_so_mstr.so_bill,"SO001") then do:
        display "This Bill-To is Blocked for use !!!..." skip(1)
              with frame yn0432 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn0432.
        hide frame yn0432 no-pause.
        undo, retry.
      end.

      if sonbr begins "IS" and cm-bt.cm_type <> "1100" then do:
        display "This Bill-To does not have Customer-Type '1100' !!!" skip(1)
                 with frame yn047 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn047.
        hide frame yn047 no-pause.
      end.
      if sonbr begins "IB" and cm-bt.cm_type <> "1120" then do:
        display "This Bill-To does not have Customer-Type '1120' !!!" skip(1)
                 with frame yn048 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn048.
        hide frame yn048 no-pause.
      end.

      /* DON'T CHANGE Bill-to IF Bill-to'S DEFAULT CURR <> scrtmp_so_mstr.so_CURR */
      if new-order = no and old-billto <> scrtmp_so_mstr.so_bill and
        cm-bt.cm_curr <> scrtmp_so_mstr.so_curr then do:
        {us/bbi/mfmsg.i 2018 2}
      end.

      /* DO NOT CHANGE Bill-to IF ALREADY (PART HAS) BEEN INVOICED */
      if old-billto <> scrtmp_so_mstr.so_bill and
         can-find(first ih_hist where ih_domain = domain
                                  and ih_nbr = sonbr) then do:
        display "Change of Bill-To not allowed !!!" skip
                "Invoice has already been issued for this Order ..." skip(1)
                 with frame yn049 side-labels overlay row 10 col 15.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn049.
        hide frame yn049 no-pause.
        scrtmp_so_mstr.so_bill = old-billto.
        display scrtmp_so_mstr.so_bill with frame a.
        undo billto-entry, retry billto-entry.
      end.

      old-shipto = scrtmp_so_mstr.so_ship.

      shipto-entry:
      do on error undo, retry: 
        global_addr = scrtmp_so_mstr.so_cust.

        hide frame bill_to no-pause.
        view frame ship_to.

        find ad_mstr no-lock where ad_mstr.ad_domain = domain
                               and ad_mstr.ad_addr = scrtmp_so_mstr.so_ship no-error.
          if avail ad_mstr then display ad_mstr.ad_name
                                      ad_mstr.ad_line1
                                      ad_mstr.ad_line2
                                      ad_mstr.ad_line3
                                      ad_mstr.ad_zip + "  " + ad_mstr.ad_city @ ad_mstr.ad_city
                                      with frame ship_to.                               
                                      
        if not can-find(FIRST scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                        and scrtmp_sod_det.sod_nbr = sonbr
                                     and (scrtmp_sod_det.sod_stat <> "" or scrtmp_sod_det.sod_qty_ship <> 0))
          and not can-find(first ih_hist where ih_domain = domain
                                           and ih_nbr = sonbr)
          and scrtmp_so_mstr.so_inv_nbr = "" then
        update scrtmp_so_mstr.so_ship go-on("END-ERROR") with frame a editing:
          {us/av/avbrwinc.i ad_mstr ad_addr "ad_mstr.ad_domain = domain and
                                     (ad_mstr.ad_ref = scrtmp_so_mstr.so_cust or ad_mstr.ad_ref = scrtmp_so_mstr.so_bill) and
                                         ad_mstr.ad_type = 'Ship-To' and ad_mstr.ad_temp = no"
                                  ad_mstr.ad_addr "input scrtmp_so_mstr.so_ship" "Index"}
          if lastkey = -1 or keyfunction(lastkey) = "END-ERROR" then leave.
          else IF  recno <> ? then do:
            display ad_mstr.ad_addr @ scrtmp_so_mstr.so_ship with frame a.
            display ad_mstr.ad_name ad_mstr.ad_line1 ad_mstr.ad_line2 ad_mstr.ad_line3
                    ad_mstr.ad_zip + "  " + ad_mstr.ad_city @ ad_mstr.ad_city
                    with frame ship_to.
          end.
        end.

        /* Lastkey -1 cannot be used:                    **
        ** is returned after popup for invoice addresses */
        if /* lastkey = -1 or */ keyfunction(lastkey) = "END-ERROR" then do:
          hide frame ship_to.
          undo billto-entry, retry billto-entry.
        end.
        if scrtmp_so_mstr.so_ship = "" then do:
          display "Please fill in an address-code, <blank> not allowed !!!"
                skip(1)  with frame yn050 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn050.
          hide frame yn050 no-pause.
          undo shipto-entry, retry shipto-entry.
        end.
        
/*RFC-2934 ADD BEGINS */      
         if domain = "fr" 
         then do:
            if asc(substring(scrtmp_so_mstr.so_ship,
            length(scrtmp_so_mstr.so_ship))) < 65 
            or (asc(substring(scrtmp_so_mstr.so_ship,
            length(scrtmp_so_mstr.so_ship))) > 90 
            and asc(substring(scrtmp_so_mstr.so_ship,
            length(scrtmp_so_mstr.so_ship))) < 97)
            or (asc(substring(scrtmp_so_mstr.so_ship,
            length(scrtmp_so_mstr.so_ship))) > 97 
            and asc(substring(scrtmp_so_mstr.so_ship,
            length(scrtmp_so_mstr.so_ship))) > 122)
            then do:
               display "Ship-to should contain at least 1 alphabet: " skip(1)
               with frame yn6767 side-labels overlay row 10 col 10.
               update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn6767.
               hide frame yn6767 no-pause.
               scrtmp_so_mstr.so_ship = "".
               undo shipto-entry, retry shipto-entry. 
            end.                 
            if substring(ad_mstr.ad_zip, 1,2) = "97" 
            or substring(ad_mstr.ad_zip, 1,2) = "98"
            then do:
               display "Warning: You are entering order for postal codes " 
                     + "starting with 97/98" skip(1)
               with frame yn6868 side-labels overlay row 10 col 10. 
               update yn blank label "Press Enter" go-on("END-ERROR") 
               with frame yn6868.
               hide frame yn6868 no-pause. 
            end.   
         end.  /*if domain = "fr" */              
/*RFC-2934 ADD ENDS*/ 

        if not scrtmp_so_mstr.so_cust begins substr(scrtmp_so_mstr.so_ship,1,2) then do:
          display "Ship-To Adress Codes should start with the" skip
                  "same numbers as the Customer Address-code !!!" skip
                  "Do you really want to use this address ??" skip(1)
                   with frame yn051 side-labels overlay row 10 col 10.
          update y-n label "Yes or No" go-on("END-ERROR") with frame yn051.
          hide frame yn051 no-pause.
          if y-n <> yes then undo shipto-entry, retry shipto-entry.
        end.

        IF cOldShipTo# <> scrtmp_so_mstr.so_ship
        THEN DO:
          RUN GetWhseSite (INPUT domain,
                           INPUT BUFFER scrtmp_so_mstr:HANDLE,
                           INPUT scrtmp_so_mstr.so_ship,
                           INPUT ?,
                           INPUT TRUE,
                           INPUT-OUTPUT wh-site,
                           INPUT-OUTPUT wh-domain,
                           INPUT-OUTPUT emt-ordr,
                           OUTPUT lWhseOk#) .
                         
          IF lWhseOk# = FALSE
          THEN undo shipto-entry, retry shipto-entry.
        END.
        
        find ad_mstr no-lock where ad_mstr.ad_domain = domain
                               and ad_mstr.ad_addr = scrtmp_so_mstr.so_ship no-error.
        if (ad_mstr.ad_type = "Ship-To" and ad_mstr.ad_temp = yes) or
            can-find(cm_mstr where cm_domain = domain
                               and cm_addr = scrtmp_so_mstr.so_ship
                               and cm_active = no) then do:
          display "This Ship-To has been DE-Activated," skip
                  "so you can't use it (anymore) !!!" skip(1)
                   with frame yn052 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                    with frame yn052.
          hide frame yn052 no-pause.
          if not can-find(FIRST scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                        and scrtmp_sod_det.sod_nbr = sonbr
                                     and (scrtmp_sod_det.sod_stat <> "" or scrtmp_sod_det.sod_qty_ship <> 0))
          and not can-find(first ih_hist where ih_domain = domain
                                           and ih_nbr = sonbr)
          and scrtmp_so_mstr.so_inv_nbr = "" then undo shipto-entry, retry shipto-entry.
          else undo billto-entry, retry billto-entry.
        end.

        if fn_addr_blocked(domain,scrtmp_so_mstr.so_ship,"SO001") then do:
          display "This Ship-To is Blocked for use !!!..." skip(1)
                   with frame yn0433 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn0433.
          hide frame yn0433 no-pause.
          undo, retry.
        end.

        if avail ad_mstr then do:
          display ad_mstr.ad_name ad_mstr.ad_line1 ad_mstr.ad_line2 ad_mstr.ad_line3
                  ad_mstr.ad_zip + "  " + ad_mstr.ad_city @ ad_mstr.ad_city with frame ship_to.

          if scrtmp_so_mstr.so_ship <> scrtmp_so_mstr.so_cust and
             ad_mstr.ad_ref <> scrtmp_so_mstr.so_cust and ad_mstr.ad_ref <> scrtmp_so_mstr.so_bill and
            new-order then {us/bbi/mfmsg.i 606 2}
                           /* Ship-To not for this customer */
        end.

        else do:
          display "Ship-To does not exist (yet) !!!" skip(1)
                   with frame yn053 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn053.
          hide frame yn053 no-pause.
          undo, retry shipto-entry.
        end.

        /* Ship-To CANNOT BE CHANGED; QUANTITY TO INVOICE EXISTS */
        if old-shipto <> "" and old-shipto <> scrtmp_so_mstr.so_ship then do:
          if can-find(FIRST scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                      and scrtmp_sod_det.sod_nbr = sonbr
                                      and scrtmp_sod_det.sod_qty_inv <> 0 ) then do:
         /* OUTSTANDING QUANTITY TO INVOICE; SHIP-TO TAXES CANNOT BE UPDATED */
            {us/bbi/mfmsg.i 2363 4}
            display old-shipto @ scrtmp_so_mstr.so_ship with frame a.
            undo shipto-entry, retry shipto-entry.
          end. /* IF CAN-FIND FIRST scrtmp_sod_det */
      if not new-order then
      {pxmsg.i &msgtext = '"Ship-To value modified. Ware house site may vary due to this modification"' &errorlevel = 2}  /*MEDPLAN*/
        end. /* IF SHIP-TO IS CHANGED IN GTM */

        if new-order then do:
          find cm_mstr no-lock where cm_mstr.cm_domain = domain
                                 and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust no-error.
          find ad_mstr no-lock where ad_mstr.ad_domain = domain
                                 and ad_mstr.ad_addr = cm_mstr.cm_site no-error.
          site-ctry = ad_mstr.ad_ctry.
          find ad_mstr no-lock where ad_mstr.ad_domain = domain
                                 and ad_mstr.ad_addr = scrtmp_so_mstr.so_ship no-error.
          assign ship-ctry = ad_mstr.ad_ctry
                 sh2-pst = ad_mstr.ad_pst_id.
          find ctry_mstr no-lock where ctry_ctry_code = ad_mstr.ad_ctry no-error.
          av-test = ctry_ec_flag.
          if can-do("IE,BE", global_domain) then av-test = no.

          if ad_mstr.ad_pst_id = "" or scrtmp_so_mstr.so_site = "600" then do:
            find ad_mstr no-lock where ad_mstr.ad_domain = domain
                                   and ad_mstr.ad_addr = scrtmp_so_mstr.so_bill no-error.
            sh2-pst = ad_mstr.ad_pst_id.
          end.
          if sh2-pst = "" then do:
            find ad_mstr no-lock where ad_mstr.ad_domain = domain
                                   and ad_mstr.ad_addr = scrtmp_so_mstr.so_cust no-error.
            sh2-pst = ad_mstr.ad_pst_id.
            if sh2-pst = "" then do:
              find cm_mstr no-lock where cm_mst.cm_domain = domain
                                     and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust.
              sh2-pst = cm_mstr.cm_resale.
            end.
          end.
          if av-test and sh2-pst = "" and ship-ctry <> site-ctry then do:
            display "There is no 'VAT-number' linked to this Ship-To Address."
               skip "You are not allowed to continue entering this Order"
               skip "before this situation is corrected ......." skip(1)
                     with frame yn054 side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn054.
            hide frame yn054 no-pause.
            return error.
          end.
        end.
      end. /* shipto-entry */
    end. /* billto-entry */
    leave customer-entry.
  end. /* customer-entry */
end procedure. /* input-addresses */
/**************************************************************************/
procedure upd-header-cmmts:
  def input parameter domain as char.

  if scrtmp_so_mstr.so_domain <> domain THEN MESSAGE "upd-header-cmmt alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.

  find cm_mstr no-lock where cm_domain = domain
                         and cm_addr = scrtmp_so_mstr.so_cust.
  txt = "Customer: " + scrtmp_so_mstr.so_cust.
  if scrtmp_so_mstr.so_bill <> "" then txt = txt + ", Bill-to: " + scrtmp_so_mstr.so_bill.
  if scrtmp_so_mstr.so_ship <> "" then txt = txt + ", Ship-to: " + scrtmp_so_mstr.so_ship.
  put screen txt row 23 col 1.
  pause 0 before-hide.

  if new-order then global_lang = cm_mstr.cm_lang.
  else global_lang = scrtmp_so_mstr.so_lang.
  assign global_type = ""
         global_ref = scrtmp_so_mstr.so_cust
         save-part = global_part
         global_part = "".
  if scrtmp_so_mstr.so_cmtindx <> ? then cmtindx = scrtmp_so_mstr.so_cmtindx.
  else cmtindx = 0.

  run "gp/gpcmmt01.p" ('so_mstr').

  assign global_part = save-part.
         scrtmp_so_mstr.so_cmtindx = cmtindx.
  if scrtmp_so_mstr.so_cmtindx = ? then scrtmp_so_mstr.so_cmtindx = 0.
  if scrtmp_so_mstr.so_cmtindx = 0 then so-cmmts = no.

  /* find first cmt_det no-lock no-error. QAD_perf_1 */
  put screen fill(" ",70) row 23 col 1.
end procedure. /* upd-header-cmmts */
/**************************************************************************/
procedure line-entry:

  def input parameter domain as char.
  DEFINE OUTPUT PARAMETER lSuppressSaveLine# AS LOGICAL     NO-UNDO INIT FALSE.

  DEFINE VARIABLE lLinePriceUpdateAllow#  AS LOGICAL     INIT TRUE NO-UNDO.

  def var cp-part     as char.
  def var DesignGroup as char.
  def var mailMsg     as char.
  def var err-stat    as char.

  define variable lvd_umConvValue as decimal no-undo. /* OT-153 */

  def buffer emtsod for scrtmp_sod_det.
  def buffer bemtsod FOR sod_det.
  DEFINE BUFFER csod_det FOR sod_det.

  find first soc_ctrl no-lock where soc_domain = domain.

  if scrtmp_so_mstr.so_domain <> domain THEN MESSAGE "line-entry alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
  frame-c-entry:
  do on error undo, retry:
    ASSIGN old-price = 0
           old-ord-qty = 0
           old-qty-ord = 0
           old-qty-all = 0
           old-due-date = ?
       li_linenbr   = 0 /* RFC2556 */
           l_oldper   = ? /* RFC2142 */.

    FOR EACH scrtmp_sod_det WHERE scrtmp_sod_det.sod_domain = domain
                              and scrtmp_sod_det.sod_nbr    = sonbr
                              and scrtmp_sod_det.sod_line   <> ordr-line
                              AND scrtmp_sod_det.operation = "A":
                              
      IF CAN-FIND(FIRST csod_det NO-LOCK WHERE csod_det.sod_domain = scrtmp_sod_det.sod_domain
                                           AND csod_det.sod_nbr    = scrtmp_sod_det.sod_nbr
                                           AND csod_det.sod_line   = scrtmp_sod_det.sod_line) = FALSE
      THEN DELETE scrtmp_sod_det.            
    END.
    
           
    FIND scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                          and scrtmp_sod_det.sod_nbr    = sonbr
                          and scrtmp_sod_det.sod_line   = ordr-line no-error.
    if not avail scrtmp_sod_det then do:

      for each ih_hist no-lock where ih_domain = domain
                                 and ih_nbr = sonbr use-index ih_nbr:
        find idh_hist no-lock where idh_domain = domain
                                and idh_inv_nbr = ih_inv_nbr
                                and idh_nbr = sonbr
                                and idh_line = ordr-line no-error.
        if avail idh_hist then do:
          display "This line-number has already been used on this Order"
             skip "and has been totally invoiced. Please choose another"
             skip "line-number that has not been used within this Order."
             skip(1)  with frame yn055 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn055.
          hide frame yn055 no-pause.
          ASSIGN lSuppressSaveLine# = TRUE.
          return.
        end.
      end.

      FIND scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = "HQ"
                             and scrtmp_sod_det.sod_nbr = sonbr
                             and scrtmp_sod_det.sod_line = ordr-line no-error.
      if not avail scrtmp_sod_det then do:

        for each ih_hist no-lock where ih_domain = "HQ"
                                   and ih_nbr = sonbr use-index ih_nbr:
          find idh_hist no-lock where idh_domain = "HQ"
                                  and idh_inv_nbr = ih_inv_nbr
                                  and idh_nbr = sonbr
                                  and idh_line = ordr-line no-error.
          if avail idh_hist then do:
            display "This line-number has already been used on this Order."
               skip "Please choose another line-number that has not been"
               skip "used within this Order."
               skip(1)  with frame yn0550 side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn0550.
            hide frame yn0550 no-pause.
            ASSIGN lSuppressSaveLine# = TRUE.
            return.
          end.
        end.
      end.

      else do:
        display "This line-number has already been used on this Order."
           skip "Please choose another line-number that has not been"
           skip "used within this Order."
           skip(1)  with frame yn0551 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn0551.
        hide frame yn0551 no-pause.
        ASSIGN lSuppressSaveLine# = TRUE.
        return.
      end.

      /* In case the so_mstr was already fully processed in HQ then **
      ** do not allow adding new lines since so_mstr would be       **
      ** re-created with no information on historical AIMS suffix   */         
      if not can-find(so_mstr where so_mstr.so_domain = "HQ" and so_mstr.so_nbr = sonbr)
        and can-find(first ih_hist where ih_domain = "HQ" and ih_nbr = sonbr)
      then do:
        display "This order has been fully invoiced for the warehouse."
           skip "You cannot add new lines to this order anymore."
           skip "Please create a new order for any addition lines."
           skip(1) with frame yn0552 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn0552.
        hide frame yn0552 no-pause.
        ASSIGN lSuppressSaveLine# = TRUE.
        return.
      end.
      
      /* OT-153 START ADDITION */
      lvl_nonEMT3PL = fn_isSalesOrdNonEmt3PL
                         (domain,
                          scrtmp_so_mstr.so__chr04,
                          wh-site).
      /* OT-153 END ADDITION */
      
      run create-sod(domain).

      FIND scrtmp_sod_det WHERE scrtmp_sod_det.sod_domain = domain
                            and scrtmp_sod_det.sod_nbr = sonbr
                            and scrtmp_sod_det.sod_line = ordr-line.
      assign sod-cmmts = sod-lcmmts
             new-line = true.

      if can-do("INVOICE,SAMPLES,CENTRAL",scrtmp_so_mstr.so__chr10) then
           scrtmp_sod_det.sod_um = "EA".
      /* OT-153 START ADDITION */
      else if lvl_nonEMT3PL          
      then
         scrtmp_sod_det.sod_um = "EA".
      /* OT-153 END ADDITION */
      else scrtmp_sod_det.sod_um = "CS".
      
      /* at beginnning of line entry all block types are cleaned */
      do l_cnt = 1 to num-entries(l_blty):
         for first xxblck_det EXCLUSIVE-LOCK
                     where xxblck_domain = scrtmp_sod_det.sod_domain
                       and xxblck_ord    = scrtmp_sod_det.sod_nbr
                       and xxblck_line   = scrtmp_sod_det.sod_line
                       and xxblck_type   = entry(l_cnt,l_blty):
             delete xxblck_det.
           
         end. /* for first xxblck_det */
      end.  /* l_cnt = 1 to num-entries(l_blty) */

    end.
    else do:
      if emt-ordr <> no then run check-emt-sod.

      assign new-line = false
             old-price = scrtmp_sod_det.sod_price
             old-due-date = scrtmp_sod_det.sod_due_date
             l_oldper = scrtmp_sod_det.sod_per_date /* RFC2142 */
             old-ord-qty = scrtmp_sod_det.sod_qty_ord
             old-qty-ord = scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv
             old-qty-all =  (scrtmp_sod_det.sod_qty_all + scrtmp_sod_det.sod_qty_pick) * scrtmp_sod_det.sod_um_conv.
      if scrtmp_sod_det.sod_cmtindx = ? or scrtmp_sod_det.sod_cmtindx = 0 then sod-cmmts = no.
      else sod-cmmts = yes.
    end.

    run disp-line-detail(domain).

    old-sod-type = scrtmp_sod_det.sod_type.

    if scrtmp_sod_det.sod_status = "M" OR can-find(FIRST cl_sod_det NO-LOCK WHERE cl_sod_det.sod_domain = wh-domain  
                                                                              AND cl_sod_det.sod_nbr    = scrtmp_sod_det.sod_nbr 
                                                                              AND cl_sod_det.sod_line   = scrtmp_sod_det.sod_line
                                                                              AND cl_sod_det.sod_status = "M"
                                                                              )
    then do:
      display "This line has status 'M', which means that it has been sent"
         skip "to AIMS, and therefor it is NOT allowed to change anything."
         skip "To be able to do this, please contact the WareHouse first."
         skip(1) with frame yn0551 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn0551.
        hide frame yn0551 no-pause.
      ASSIGN lSuppressSaveLine# = TRUE.
      return.
    end.
    if (scrtmp_sod_det.sod_compl_stat <> "" AND scrtmp_sod_det.sod_compl_stat <> ? )   OR can-find(FIRST cl_sod_det NO-LOCK WHERE cl_sod_det.sod_domain = wh-domain  
                                                                                                                              AND cl_sod_det.sod_nbr    = scrtmp_sod_det.sod_nbr 
                                                                                                                              AND cl_sod_det.sod_line   = scrtmp_sod_det.sod_line
                                                                                                                              AND cl_sod_det.sod_compl_stat <> "" 
                                                                                                                              AND cl_sod_det.sod_compl_stat <> ?
                                                                                                                              )
    then do:
      display "This line has non-empty compl_stat, which means that "
         skip "it has been sent and/or invoiced."
         skip "If this is not correct, please contact IT servicedesk."
         skip(1) with frame yn0571 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn0571.
        hide frame yn0571 no-pause.
       ASSIGN lSuppressSaveLine# = TRUE.
      return.
    end.
    if (scrtmp_sod_det.sod_qty_inv <> 0 AND scrtmp_sod_det.sod_qty_inv <> ? ) OR can-find(FIRST cl_sod_det NO-LOCK WHERE cl_sod_det.sod_domain = wh-domain  
                                                                                                                              AND cl_sod_det.sod_nbr    = scrtmp_sod_det.sod_nbr 
                                                                                                                              AND cl_sod_det.sod_line   = scrtmp_sod_det.sod_line
                                                                                                                              AND cl_sod_det.sod_qty_inv <> 0 
                                                                                                                              AND cl_sod_det.sod_qty_inv <> ?
                                                                                                                              )
    then do:
      lLinePriceUpdateAllow# = FALSE.
      display "This line has invoice qty pending."
         skip "Price update normally not allowed anymore."
         skip "If needed anyhow please contact Finance."
         skip(1) with frame yn0591 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn0591.
        hide frame yn0591 no-pause.
      /*return.*/
    END.
/*MEDPLAN START OF ADDITION***************************************************/
    if domain = "HQ" 
    then do:
       if new-order then do :
       scrtmp_sod_det.sod_site = wh-site.
       end.
       else do:
              find first sod_det no-lock where sod_det.sod_domain = "HQ" 
                                 and sod_det.sod_nbr    = sonbr no-error.
          if available sod_det then
              wh-site = sod_det.sod_site.
       end.         
    end.
    find first sod_det no-lock where sod_det.sod_domain = "HQ" 
                                 and sod_det.sod_nbr    = sonbr
                                     and sod_det.sod_line = ordr-line
                         and sod_det.sod_site <> wh-site no-error.
       if available sod_det and 
          not new-line then do:
           wh-site = sod_det.sod_site.
           end. 
       find first sod_det no-lock where sod_det.sod_domain = "HQ" 
                                            and sod_det.sod_nbr = sonbr
                            and sod_det.sod_line <> ordr-line
                and sod_det.sod_site <> wh-site no-error.
       if available sod_det then do:
          wh-site = sod_det.sod_site.
           end. 
/*MEDPLAN END OF ADDITIION****************************************************/
    part-entry:
    do on error undo, retry:

      assign send-mail = no
             l_qtblck = no /* RFC2142 */
              mail-address = "".

      if new-line then do:
        if old-sod-type = "A" then assign scrtmp_sod_det.sod_part = save-part
                                          scrtmp_sod_det.sod_type = "".

        update scrtmp_sod_det.sod_part go-on("END-ERROR") with frame c editing:
          {us/zu/zumfnp05.i pt_mstr pt_part "pt_domain = domain and
                                           can-do('3,4,5,8',pt_status)" 
                                  pt_part "input scrtmp_sod_det.sod_part"}
                                  /* MLQ00060 can-do('5,8',pt_status)" */
          if rRowid# <> ? then do:
            display pt_part @ scrtmp_sod_det.sod_part with frame c.
            display pt_desc1 @ scrtmp_sod_det.sod_desc pt_taxc @ scrtmp_sod_det.sod_taxc with frame d.
            if scrtmp_so_mstr.so_site <> scrtmp_sod_det.sod_site then display scrtmp_so_mstr.so_site + "/" + scrtmp_sod_det.sod_site
                                                @ scrtmp_so_mstr.so_site with frame ab.
            find xxtransl_det no-lock where xxtransl_file = "pt_mstr"
                                        and xxtransl_key1_field = "pt_part"
                                        and xxtransl_key2_field = ""
                                        and xxtransl_key1_code = pt_part
                                        and xxtransl_key2_code = ""
                                        and xxtransl_desc_field = "pt_desc1"
                                        and xxtransl_lang = scrtmp_so_mstr.so_lang no-error.
            if avail xxtransl_det then display xxtransl_desc @ scrtmp_sod_det.sod_desc
                                               with frame d.
          end.
        end. /* update sodpart editing */

        if keyfunction(lastkey) = "END-ERROR" then undo frame-c-entry, return.

        if scrtmp_sod_det.sod_part = "" then do:
          display "Please fill-in an Item-number !!!" skip(1)
                   with frame yn056 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn056.
          hide frame yn056 no-pause.
          undo part-entry, retry part-entry.
        end.
        
        /* RFC 1901 - it's not necessary anymore, commented out 
           MP: MLQ-00060: Additional request, item status 3 is only allowed for project "CENTRAL" and "SAMPLES" 
        IF CAN-DO("CENTRAL,SAMPLES",scrtmp_so_mstr.so__chr10) = FALSE AND
           CAN-FIND(FIRST pt_mstr NO-LOCK WHERE pt_mstr.pt_domain = domain
                                            AND pt_mstr.pt_part   = scrtmp_sod_det.sod_part
                                            AND pt_mstr.pt_status = "3") = TRUE
        THEN DO:           
          DISPLAY "Item with status 3 is not allowed for this project !!!" skip(1)
                   with frame yn056st3 side-labels overlay ROW 8 COL 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn056st3.
          hide frame yn056st3 no-pause.
          undo part-entry, retry part-entry.
        END.        
        */


        txt = scrtmp_sod_det.sod_part.

        if not can-find(pt_mstr where pt_domain = wh-domain
                                  and pt_part = scrtmp_sod_det.sod_part) then find-quote:
        do:
          find first xxpt_mstr no-lock where xxpt_prod_cat = scrtmp_sod_det.sod_part no-error.
          if avail xxpt_mstr then do:
          find last xxprl_mstr where xxprl_mstr.xxprl_domain = domain
                                 and xxprl_mstr.xxprl_list = "CUSTOMER"
                                 and xxprl_mstr.xxprl_cs_code = scrtmp_so_mstr.so_cust
                                 and xxprl_mstr.xxprl_part_code = xxpt_part
                                 and xxprl_mstr.xxprl_curr = scrtmp_so_mstr.so_curr
                                 and xxprl_mstr.xxprl_start <= today
                                 and (xxprl_mstr.xxprl_expire >= today or
                                      xxprl_mstr.xxprl_expire = ?)
                               no-lock no-error.
            if avail xxprl_mstr then
              find first xxprld_det no-lock where xxprld_domain = domain
                        and xxprld_list_id = xxprl_mstr.xxprl_list_id no-error.
            if avail xxprl_mstr and avail xxprld_det then do:
              display "This code has been found as Net-Quote Number," skip
                      "it translates to Item-Number '" + xxpt_part + "'."
                       format "X(60)" skip
                      "Also a Customer Price-list entry has been found" skip
                      "that is active since " + string(xxprl_mstr.xxprl_start)
                       format "X(60)" skip
                      "and has a price of " + string(xxprld_amt) + " " +
                       xxprl_mstr.xxprl_curr + " per " +
                       caps(xxprl_mstr.xxprl_um) + " ..." format "X(60)"
               skip(1) with frame yn057 side-labels overlay row 10 col 10.
              update y-n label "Do you want to use the price-list entry ??"
                         go-on("END-ERROR") with frame yn057.
              hide frame yn057 no-pause.
              if y-n = yes then do:
                assign scrtmp_sod_det.sod_part = xxpt_part
                       scrtmp_sod_det.sod_custpart = xxpt_prod_cat.
                display scrtmp_sod_det.sod_part with frame c.
                leave find-quote.
              end.
              else undo, retry part-entry.
            end.
            display "This code has been found as Net-Quote Number," skip
                    "it translates to Item-Number '" + xxpt_part + "'."
                     format "X(45)" skip (1)
                     with frame yn058 side-labels overlay row 10 col 10.
            update y-n label "Is this correct ??" go-on("END-ERROR")
                   with frame yn058.
            hide frame yn058 no-pause.
            if y-n = no then leave find-quote.
            else if y-n = yes then do:
              assign scrtmp_sod_det.sod_custpart = scrtmp_sod_det.sod_part
                     scrtmp_sod_det.sod_part = xxpt_part.
              display scrtmp_sod_det.sod_part with frame c.
              for each xxprl_mstr where xxprl_mstr.xxprl_domain = domain
                                  and xxprl_mstr.xxprl_list = "QUOTE"
                                 and xxprl_mstr.xxprl_cs_code = scrtmp_so_mstr.so_cust
                                and xxprl_mstr.xxprl_part_code = xxpt_prod_cat:
                assign xxprl_mstr.xxprl_list = "CUSTOMER"
                       xxprl_mstr.xxprl_part_code = scrtmp_sod_det.sod_part
                       xxprl_mstr.xxprl_um = "CS"
                       xxprl_mstr.xxprl_desc = "price agreement"
                       xxprl_mstr.xxprl_userid = global_userid
                       xxprl_mstr.xxprl_mod_date = today
                       xxprl_mstr.xxprl_start = today
                       xxprl_mstr.xxprl_expire = (if month(today) < 7 then
                                            date(6,30,year(today) + 1) else
                                           date(12,31,year(today) + 1)).

                find um_mstr no-lock where um_domain = domain
                                       and um_part = scrtmp_sod_det.sod_part
                                       and um_um = "EA"
                                       and um_alt_um = "CS" no-error.
                if avail um_mstr then
                for each xxprld_det where xxprld_domain = domain
                                      and xxprld_list_id = xxprl_list_id:
                  xxprld_amt = xxprld_amt * um_conv.
                end.
                if can-do("110,200",scrtmp_so_mstr.so_site) and xxprl_bidnbr <> "" then do:
                  find pt_mstr where pt_domain = domain
                                 and pt_part = scrtmp_sod_det.sod_part.
                  pt_taxc = xxprl_bidnbr.
                end.
              end.
              find first an_mstr no-lock where an_domain = domain
                                        and an_type = "9"
                                      and an_code = cm_mstr.cm_user1 no-error.
              if avail an_mstr and cm_mstr.cm_user1 <> "" then
              for each xxprl_mstr where xxprl_mstr.xxprl_domain = domain
                                    and xxprl_mstr.xxprl_list = "QUOTE"
                                    and xxprl_mstr.xxprl_cs_code = an_code
                                and xxprl_mstr.xxprl_part_code = xxpt_prod_cat:
                assign xxprl_mstr.xxprl_list = "PURCHASE"
                       xxprl_mstr.xxprl_part_code = scrtmp_sod_det.sod_part
                       xxprl_mstr.xxprl_um = "CS"
                       xxprl_mstr.xxprl_desc = "purchase group price"
                       xxprl_mstr.xxprl_userid = global_userid
                       xxprl_mstr.xxprl_mod_date = today
                       xxprl_mstr.xxprl_start = today
                       xxprl_mstr.xxprl_expire = (if month(today) < 7 then
                                            date(6,30,year(today) + 1) else
                                           date(12,31,year(today) + 1)).

                find um_mstr no-lock where um_domain = domain
                                       and um_part = scrtmp_sod_det.sod_part
                                       and um_um = "EA"
                                       and um_alt_um = "CS" no-error.
                if avail um_mstr then
                for each xxprld_det where xxprld_det.xxprld_domain = domain
                     and xxprld_det.xxprld_list_id = xxprl_mstr.xxprl_list_id:
                  xxprld_det.xxprld_amt = xxprld_det.xxprld_amt * um_conv.
                end.
                if can-do("110,200",scrtmp_so_mstr.so_site) and xxprl_bidnbr <> "" then do:
                  find pt_mstr where pt_domain = domain
                                 and pt_part = scrtmp_sod_det.sod_part.
                  pt_taxc = xxprl_bidnbr.
                end.
              end.
            end.
          end. /* if avail xxpt_mstr */
        end. /* find-quote */        
        
        run "so/sopart.p" (scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_ship,?,input-output scrtmp_sod_det.sod_part,
                              output cp-part,output scrtmp_sod_det.sod_custpart).

        if txt <> scrtmp_sod_det.sod_part and txt = scrtmp_sod_det.sod_custpart then do:
          display "Customer Item number converted to our Item number" skip(1)
                   with frame yn059 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn059.
          hide frame yn059 no-pause.
          display scrtmp_sod_det.sod_part with frame c.
        end.

        txt = scrtmp_sod_det.sod_part.

        if not can-find(pt_mstr where pt_domain = wh-domain
                                  and pt_part = scrtmp_sod_det.sod_part) then do:
          find xxedi_pt_det where xxedi_pt_code = scrtmp_sod_det.sod_part no-lock no-error.
          if avail xxedi_pt_det then do:
            assign scrtmp_sod_det.sod_part = caps(xxedi_pt_part)
                   scrtmp_sod_det.sod_um   = xxedi_pt_um.
            message "GTIN converted to our Item number".
            readkey pause 2.
            display scrtmp_sod_det.sod_part with frame c.

            run "so/sopart.p" (scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_ship,?,input-output scrtmp_sod_det.sod_part,
                                  output cp-part,output scrtmp_sod_det.sod_custpart).

            if txt <> scrtmp_sod_det.sod_part and txt = scrtmp_sod_det.sod_custpart then do:
              display "Customer Item number converted to our Item number"
                    skip(1) with frame yn059 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn059.
              hide frame yn059 no-pause.
              display scrtmp_sod_det.sod_part with frame c.
             end.
           end.
        end.

        txt = scrtmp_sod_det.sod_part.
        if can-find(FIRST scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                    and scrtmp_sod_det.sod_nbr = sonbr
                                    and scrtmp_sod_det.sod_line <> ordr-line
                                    and scrtmp_sod_det.sod_part = txt) then do:
          txt = "".
          for each emtsod no-lock where emtsod.sod_domain = domain
                                    and emtsod.sod_nbr = sonbr
                                    and emtsod.sod_line <> ordr-line
                                    and emtsod.sod_part = scrtmp_sod_det.sod_part:
            if txt <> "" then txt = txt + ",".
            txt = txt + string(emtsod.sod_line).
          end.
          display "This Item is already present on other Order-line(s): " + txt
                  format "X(64)"
             skip "Do you wish to continue ???" skip(1)
                   with frame yn060 side-labels overlay row 10 col 10.
          update y-n label "Yes or No" go-on("END-ERROR") with frame yn060.
          hide frame yn060 no-pause.
          if y-n <> true then do:
            DELETE scrtmp_sod_det. /* Here nog delete qxtend call needed because line is not created yet in qad */
            ASSIGN lSuppressSaveLine# = TRUE.
            return.
          end.
        end.

        assign scrtmp_sod_det.sod_part = caps(scrtmp_sod_det.sod_part)
               global_part = scrtmp_sod_det.sod_part.

        if scrtmp_so_mstr.so_site = "900" then do:
          assign cpl-nbr = ""
                 cpl-fail = "".
          for each xxcpl_mstr no-lock where xxcpl_cust = scrtmp_so_mstr.so_cust
                                        and xxcpl_ent_date >= today - 180
                                        and xxcpl_domain = domain,
              each xxcpld_det no-lock where xxcpld_nbr = xxcpl_nbr
                                        and xxcpld_part = scrtmp_sod_det.sod_part
                                        and xxcpld_failure begins "1":
            if cpl-nbr = "" then assign cpl-nbr = xxcpld_nbr
                                        cpl-fail = xxcpld_failure.
            else assign cpl-nbr = cpl-nbr + "," + xxcpld_nbr
                        cpl-fail = cpl-fail + "," + xxcpld_failure.
          end.
          if cpl-nbr <> "" then do:
            display "This Item has been subject of complaint on," skip
                    "complaint(s) '" + cpl-nbr + "'" format "X(40)" skip
                    "failure-code(s) '" + cpl-fail + "' !!!" format "X(40)"
                skip(1)  with frame yn061 side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn061.
            hide frame yn061 no-pause.
          end.
        end.

        find pt_mstr no-lock where pt_domain = wh-domain
                               and pt_part   = scrtmp_sod_det.sod_part no-error.
        if not avail pt_mstr then do:
            display "This Item does not exist (yet) !!!" skip(1)
                     with frame yn062 side-labels overlay row 10 col 10.
            update yn BLANK label "Press Enter" go-on("END-ERROR")
                   with frame yn062.
            hide frame yn062 no-pause.
            undo, retry part-entry.
        end. /* if not avail pt_mstr */
    /*     /*********   OT-379 STARTS     *********/
         for first debtorshipto
            where  debtorshiptocode = scrtmp_so_mstr.so_ship no-lock:
         end. /* FOR FIRST debtorshipto */
         if available debtorshipto
         then
            l_ship_pharma = if Debtorshipto.CustomInteger0 = 1
                            then
                               true
                            else
                               false.
         else
            l_ship_pharma = false.
                  
         for first xxpt_mstr no-lock 
            where  xxpt_mstr.xxpt_part = scrtmp_sod_det.sod_part: 
         end. /* FOR FIRST bxxpt_mstr */
         if available xxpt_mstr
            and xxpt_mstr.xxpt_pharmacy
            and not l_ship_pharma
         then do:
            /* PHARMA ITEM NOT ALLOWED FOR NON APPROVED PHARMA SHIPTO ADDRESS */
            {pxmsg.i &msgnum = 99069 &errorlevel = 3}
            undo, retry part-entry.
         end. /* IF AVAILABLE xxpt_mstr */
         if available xxpt_mstr
            and not xxpt_mstr.xxpt_pharmacy
            and  l_ship_pharma
         then do:
            /* NON PHARMA ITEM ENTERED FOR PHARMA APPROVED SHIPTO ADDRESS. */
            {us/bbi/pxmsg.i &MSGNUM=99070 &errorlevel = 3}
            undo, retry part-entry.
         end. /* IF AVAILABLE xxpt_mstr */
         /*********   OT-379 ENDS     *********/ */
         /*********   OT-379 STARTS  UPDATED CHANGE   *********/
         for first debtorshipto
            where  debtorshiptocode = scrtmp_so_mstr.so_ship no-lock:
         end. /* FOR FIRST debtorshipto */
         if available debtorshipto
         then
            l_ship_pharma = if Debtorshipto.CustomInteger0 = 1
                            then
                               true
                            else
                               false.
         else
            l_ship_pharma = false.
         /*CHANGE ONLY FOR 99.7.1.1*/     
         if emt-maint = yes
         then do:       
           if lv_avail = yes
           then do:
               if lv_temp = no 
               then do:
                      for first xxpt_mstr no-lock 
                        where  xxpt_mstr.xxpt_part = scrtmp_sod_det.sod_part: 
                      end. /* FOR FIRST bxxpt_mstr */
                      if available xxpt_mstr
                        and xxpt_mstr.xxpt_pharmacy
                        then do:
                            {pxmsg.i &msgnum = 99072 &errorlevel = 3 &msgarg1 = scrtmp_sod_det.sod_part}
                            undo, retry part-entry.
                        end.    
                       if available xxpt_mstr
                          and not xxpt_mstr.xxpt_pharmacy
                          and  l_ship_pharma
                       then do:
                          /*Non-PHARMA ITEM NOT ALLOWED FOR APPROVED PHARMA SHIPTO ADDRESS */
                          {pxmsg.i &msgnum = 99077 &errorlevel = 3 &msgarg1 = scrtmp_sod_det.sod_part 
                                                                   &msgarg2 = scrtmp_so_mstr.so_ship}
                          undo, retry part-entry.
                       end. /* IF AVAILABLE xxpt_mstr */  
               end. /*TEMP1 SOLUTION - (PHASE 1) SET UP IN GCM*/
               if lv_temp 
               then do:
                      assign
                         lv_mix = no
                         lv_pharma = no
                         lv_pitem = no
                         lv_sod   = no.
                       for first xxpt_mstr no-lock 
                          where  xxpt_mstr.xxpt_part = scrtmp_sod_det.sod_part: 
                       end. /* FOR FIRST bxxpt_mstr */
                       if available xxpt_mstr
                          and xxpt_mstr.xxpt_pharmacy
                          and not l_ship_pharma
                       then do:
                          /* PHARMA ITEM NOT ALLOWED FOR NON APPROVED PHARMA SHIPTO ADDRESS */
                          {pxmsg.i &msgnum = 99076 &errorlevel = 3 &msgarg1 = scrtmp_sod_det.sod_part 
                                                                   &msgarg2 = scrtmp_so_mstr.so_ship}
                          undo, retry part-entry.
                       end. /* IF AVAILABLE xxpt_mstr */
                       /*UPDATED CHANGE TO PREVENT NON-PHARMA ITEM ON PHARMA SHIP-TO*/
                       if available xxpt_mstr
                          and not xxpt_mstr.xxpt_pharmacy
                          and  l_ship_pharma
                      /* then lv_mix = yes.*/
                       then do:
                          /* Non-PHARMA ITEM NOT ALLOWED FOR APPROVED PHARMA SHIPTO ADDRESS */
                          {pxmsg.i &msgnum = 99077 &errorlevel = 3 &msgarg1 = scrtmp_sod_det.sod_part 
                                                                   &msgarg2 = scrtmp_so_mstr.so_ship}
                          undo, retry part-entry.
                       end. /* IF AVAILABLE xxpt_mstr */
                       if available xxpt_mstr
                          and xxpt_mstr.xxpt_pharmacy
                          and l_ship_pharma
                       then lv_pharma = yes.  
                      /* for each sod_det
                           where sod_det.sod_domain = domain
                           and   sod_det.sod_nbr    = scrtmp_sod_det.sod_nbr no-lock:
                           lv_sod = yes.
                          find first xxpt_mstr no-lock 
                               where  xxpt_mstr.xxpt_part = sod_det.sod_part no-error.
                          if avail xxpt_mstr
                             and  xxpt_mstr.xxpt_pharmacy
                             then lv_pitem  = yes.
                       end.   /*FOR EACH SOD_DET*/
                       
                       if lv_mix = yes and lv_pitem
                          then do:
                              /* Mixed Sales Orders are not allowed. */
                              {us/bbi/pxmsg.i &MSGNUM=99073 &errorlevel = 3 &msgarg1= scrtmp_so_mstr.so_ship}
                              undo, retry part-entry.
                          end. /*IF NON PHARMA AND CHECK MIXED SALES ORDER*/ 
                       if lv_pharma and lv_sod
                          then do:
                                  if lv_pitem = no 
                                  then do:
                                          /* Mixed Sales Orders are not allowed. */
                                          {us/bbi/pxmsg.i &MSGNUM=99073 &errorlevel = 3 
                                                    &msgarg1 = scrtmp_so_mstr.so_ship}
                                          undo, retry part-entry.
                                  end.  
                          end. /*IF PHARMA AND CHECK MIXED SALES ORDER*/    */
                      /*    /* NON PHARMA ITEM ENTERED FOR PHARMA APPROVED SHIPTO ADDRESS. */
                          {us/bbi/pxmsg.i &MSGNUM=99070 &errorlevel = 3}
                          undo, retry part-entry. */
                     /*  end. /* IF AVAILABLE xxpt_mstr */ */  /*MIXED ORDER LOGIC ENDS   */                   
               end. /*ORIGINAL SOLUTION - TEMP2(PHASE 2)*/
           end.   /*ASID BONZ GCM AVAILABLE IN DOMAIN*/
           if lv_avail = no
           then do:
                   for first xxpt_mstr no-lock 
                      where  xxpt_mstr.xxpt_part = scrtmp_sod_det.sod_part: 
                   end. /* FOR FIRST bxxpt_mstr */
                   if available xxpt_mstr
                      and xxpt_mstr.xxpt_pharmacy
                      and not l_ship_pharma
                   then do:
                      /* PHARMA ITEM # NOT ALLOWED FOR NON APPROVED PHARMA SHIPTO ADDRESS */
                      {pxmsg.i &msgnum = 99076 &errorlevel = 3 &msgarg1 = scrtmp_sod_det.sod_part 
                                                               &msgarg2 = scrtmp_so_mstr.so_ship}
                      undo, retry part-entry.
                   end. /* IF AVAILABLE xxpt_mstr */
           end. /*ASID BONZ GCM NOT AVAILABLE IN DE DOMAIN*/     
        end. /*CHANGE ONLY FOR 99.7.1.1*/   
            /*     if available xxpt_mstr
                    and not xxpt_mstr.xxpt_pharmacy
                    and  l_ship_pharma
                 then do:
                    /* NON PHARMA ITEM ENTERED FOR PHARMA APPROVED SHIPTO ADDRESS. */
                    {us/bbi/pxmsg.i &MSGNUM=99070 &errorlevel = 3}
                    undo, retry part-entry.
                 end. /* IF AVAILABLE xxpt_mstr */
             */
             
         /*********   OT-379 ENDS     *********/
         if domain <> "HQ" then     /*MEDPLAN*/
            scrtmp_sod_det.sod_site = scrtmp_so_mstr.so_site. /* scrtmp_sod_det.sod_site = always so_site with POC */
         else do :
        scrtmp_sod_det.sod_site = wh-site.   /*MEDPLAN*/         
     end.
        if scrtmp_so_mstr.so__chr10 <> "INVOICE"  and old-sod-type <> "A"  then DO:
          suse-item = "".
          run super-session(domain).
          if suse-item = "" then undo, retry part-entry.

          IF suse-item <> scrtmp_sod_det.sod_part then do:
            RUN SavePartChangedComments.
            /* create comments to be printed on documents  
            cmtindx = next-value(cmt_sq01).
            find cmt_det no-lock where cmt_domain = domain
                                   and cmt_indx = cmtindx no-error.
            do while avail cmt_det:
              cmtindx = next-value(cmt_sq01).
              find cmt_det no-lock where cmt_domain = domain
                                     and cmt_indx = cmtindx no-error.
            end.
            create cmt_det.
            assign cmt_domain = domain
                   cmt_indx   = cmtindx
                   cmt_ref    = scrtmp_sod_det.sod_nbr + "-" + string(scrtmp_sod_det.sod_line)
                   cmt_seq    = 0
                   cmt_lang   = scrtmp_so_mstr.so_lang
                   cmt_type   = ""
                   cmt_print  = "SO,IN,PA"
                   cmt_user1  = global_userid.

            if can-do("DU,NL",scrtmp_so_mstr.so_lang) then cmt_cmmt[1] =
              /* "Code '" + caps(scrtmp_sod_det.sod_part) + "' is gewijzigd. " +
              "Gelieve de CODE/VE aan te passen in uw systeem". CEPS-714 */
              /*** CEPS-714 ADD BEGINS ********************/
              "Art.' " + caps(scrtmp_sod_det.sod_part) + "' is gewijzigd. " +
              "Graag de data aanpassen in uw inkoopsysteem".
              /*** CEPS-714 ADD ENDS ********************/
            else if scrtmp_so_mstr.so_lang = "FR" then cmt_cmmt[1] =
              "Cette rfrence remplace la rfrence '" + caps(scrtmp_sod_det.sod_part) + "'".
            else if can-do("DE,GE",scrtmp_so_mstr.so_lang) then cmt_cmmt[1] =
              "Artikelcode '" + caps(scrtmp_sod_det.sod_part) + "' hat sich gendert. " +
              "Bitte in Ihrem System anpassen.".
            else if scrtmp_so_mstr.so_lang = "CZ" then cmt_cmmt[1] =
              "Polozka '" + caps(scrtmp_sod_det.sod_part) + "' je nahrazna '" +
               caps(suse-item) + "', prosim aktualizujte si svuj system.".
            else cmt_cmmt[1] = "Item '" + caps(scrtmp_sod_det.sod_part) + "' replaced by '" +
                              caps(suse-item) + "', please update your System".
            assign scrtmp_sod_det.sod_cmtindx = cmtindx
                   scrtmp_sod_det.sod_part = caps(suse-item).
            */
            run "so/sopart.p" (scrtmp_so_mstr.so_cust,
                               scrtmp_so_mstr.so_ship,
                               ?,
                               input-output scrtmp_sod_det.sod_part,
                               output cp-part,
                               output scrtmp_sod_det.sod_custpart).
            display scrtmp_sod_det.sod_part with frame c.
            display yes @ sod-cmmts with frame d.
            
          end.
        end.

        find pt_mstr no-lock where pt_domain = domain
                               and pt_part = scrtmp_sod_det.sod_part no-error.
        IF can-do("9",pt_status) /* MLQ00060 can-do("4,9",pt_status) */ then do:
          find xxpt_mstr no-lock where xxpt_part = scrtmp_sod_det.sod_part no-error.
          if avail xxpt_mstr and substr(xxpt_source,1,20) <> "" then do:
            display "The status of this Item is '" + pt_status + "' !!!"
                     format "X(34)" skip
                     substr(xxpt_source,1,20) format "X(20)" skip(1)
                     with frame yn0641 side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn0641.
            hide frame yn0641 no-pause.
          end.
          else do:
            display "The status of this Item is '" + pt_status + "' !!!"
                     format "X(34)" skip(1)
                     with frame yn0642 side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn0642.
            hide frame yn0642 no-pause.
          end.
        end.

        if pt_prod_line begins "W" then do:
          find usr_mstr no-lock where usr_userid = global_userid.
          if not can-do(usr-groups,"GiveAway") then do:
            display "You are not allowed to sell this Item," skip
                    "this is restricted to user's which are" skip
                    "part of the marketing-group for give aways ..." skip(1)
                     with frame yn065 side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn065.
            hide frame yn065 no-pause.
            undo, retry part-entry.
          end.
        end.

        assign scrtmp_sod_det.sod_taxc = pt_taxc
               scrtmp_sod_det.sod_tax_env = scrtmp_so_mstr.so_tax_env
               .
        /* For Canary Islands tax class must be blank, not taken from item */
        if scrtmp_sod_det.sod_site = "810" then scrtmp_sod_det.sod_taxc = "".

        if (scrtmp_sod_det.sod_taxc begins "N" and scrtmp_so_mstr.so_site = "110") or
         (scrtmp_sod_det.sod_taxc begins "B" and scrtmp_so_mstr.so_site = "200" and scrtmp_sod_det.sod_tax_env begins "BE")
         then scrtmp_sod_det.sod_tax_env = scrtmp_so_mstr.so_tax_env + "-" + scrtmp_sod_det.sod_taxc.

        else if scrtmp_so_mstr.so_taxc <> "" then scrtmp_sod_det.sod_taxc = scrtmp_so_mstr.so_taxc.

        if scrtmp_so_mstr.so_site <> scrtmp_sod_det.sod_site then display scrtmp_so_mstr.so_site + "/" + scrtmp_sod_det.sod_site @ scrtmp_so_mstr.so_site
                                            with frame ab.

        find pt_mstr no-lock where pt_domain = domain
                               and pt_part = scrtmp_sod_det.sod_part no-error.
        display pt_desc1 @ scrtmp_sod_det.sod_desc with frame d.
        find xxtransl_det no-lock where xxtransl_file = "pt_mstr"
                                  and xxtransl_key1_field = "pt_part"
                                  and xxtransl_key2_field = ""
                                  and xxtransl_key1_code = pt_part
                                  and xxtransl_key2_code = ""
                                  and xxtransl_desc_field = "pt_desc1"
                                  and xxtransl_lang = scrtmp_so_mstr.so_lang no-error.
        if avail xxtransl_det then display xxtransl_desc @ scrtmp_sod_det.sod_desc
                                           with frame d.

          
         /* MLQ00060
         
        /* MP: Disble block of 8+9 */
        IF lAllowBlocked# 
        THEN DO:
          if can-do("4",pt_status) then undo, retry part-entry.
        END.
        ELSE DO:
          if can-do("4,9",pt_status) then undo, retry part-entry.
        END.
        */
        if can-do("9",pt_status) then undo, retry part-entry. /* MLQ00060 */


        if pt_status = "8" then do:
            qty-avl = 0.
            for each ld_det no-lock where ld_domain = "HQ"
                                      and ld_part = scrtmp_sod_det.sod_part
                                      and ld_loc <> "CONSIGN"
                                      and ld_status <> "HOLD"
                                      and ld_status <> "GIT":
              qty-avl = qty-avl + ld_qty_oh.
            end.
            for each in_mstr no-lock where in_domain = "HQ"
                                       and in_part = scrtmp_sod_det.sod_part:
              if in_site matches "*1" then
              qty-avl = qty-avl - in_qty_all + in_qty_ord.
            end.
            
            /* MP: Disble block of 8+9 */
            if qty-avl <= 0 then do:
              IF lAllowBlocked#
              THEN  DO:
                display "This item has statuscode 8 !!!" skip
                      "and there is NO available Stock ..." SKIP
                      "Press 'Y' to continue." skip(1)
                       with frame yn0664 side-labels overlay row 10 col 10.
              END.
              ELSE DO:
                display "This item has statuscode 8 !!!" skip
                      "and there is NO available Stock ..."skip(1)
                       with frame yn0664 side-labels overlay row 10 col 10.
              END.
              ASSIGN yn = ''.
              update yn blank label "Press ENTER" go-on("END-ERROR")
                     with frame yn0664.
              hide frame yn0664 no-pause.
              
              IF lAllowBlocked# = FALSE OR
                 CAPS(yn) <> "Y"
              THEN undo, retry part-entry.
            end.
            ELSE DO:
              display "This item has statuscode 8 !!!" skip
                    "and the available stock is " + string(qty-avl) +
                    " " + caps(pt_um) format "X(40)" skip(1)
                     with frame yn0662 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn0662.
              hide frame yn0662 no-pause.
            END.
        end.

        assign scrtmp_sod_det.sod_fr_wt = pt_ship_wt
               scrtmp_sod_det.sod_fr_wt_um = pt_ship_wt_um
               scrtmp_sod_det.sod_prodline = pt_prod_line
               scrtmp_sod_det.sod_taxc = pt_taxc
               scrtmp_sod_det.sod_tax_env = scrtmp_so_mstr.so_tax_env
               .
        /* For Canary Islands tax class must be blank, not taken from item */
        if scrtmp_sod_det.sod_site = "810" then scrtmp_sod_det.sod_taxc = "".

        if (scrtmp_sod_det.sod_taxc begins "N" and scrtmp_so_mstr.so_site = "110") or
         (scrtmp_sod_det.sod_taxc begins "B" and scrtmp_so_mstr.so_site = "200" and scrtmp_sod_det.sod_tax_env begins "BE")
         then scrtmp_sod_det.sod_tax_env = scrtmp_so_mstr.so_tax_env + "-" + scrtmp_sod_det.sod_taxc.

        else if scrtmp_so_mstr.so_taxc <> "" then scrtmp_sod_det.sod_taxc = scrtmp_so_mstr.so_taxc.
        display scrtmp_sod_det.sod_taxc with frame d.

        run find-um-conv(domain).
        display scrtmp_sod_det.sod_um_conv with frame c.

        run "aw/awgetimv.p" (scrtmp_sod_det.sod_part,scrtmp_so_mstr.so_cust,output scrtmp_sod_det.sod_slspsn[1]).

        display scrtmp_sod_det.sod_loc scrtmp_sod_det.sod_slspsn[1] with frame d.
      end. /* if new-line */

      qty-entry:
      do on error undo, retry:
        if scrtmp_sod_det.sod_status = "" or (scrtmp_sod_det.sod_qty_ord > scrtmp_sod_det.sod_qty_inv and
                               scrtmp_sod_det.sod_qty_ord > scrtmp_sod_det.sod_qty_ship and
                               scrtmp_sod_det.sod_status = "C") then do:

          assign global_site = scrtmp_sod_det.sod_site
                 global_part = scrtmp_sod_det.sod_part.
           
          /* RFC533 ADD BEGINS */     
          if scrtmp_so_mstr.so__chr10 <> "INVOICE" and not scrtmp_sod_det.sod_prodline begins "W" then do:
             
                                                            
             /* 3375 _ 1 ADD BEGINS  */
             output to value(intf-dir + server-id + "/trace/blocks/"  
                         + string(year(today),"9999") +              
                          string(month(today),"99") +                
                          string(day(today),"99")) append.
                          put unformatted  "zusomain "    + " " + scrtmp_so_mstr.so_nbr +
                            " Date " today format "99/99/99"  
                            " Time " string(time,"HH:MM:SS") + " "
                            "Before avsodrst.p " +  "cust-restr: " + string(cust-restr) skip.
                          
            output close.
            assign
               show-mess = yes 
               l_flg = no 
               cust-restr = no. /* 3775_1 */
             RUN SaveDataToDSTT.
             run "zu/zusodrst.p" (domain,
                                  scrtmp_sod_det.sod_nbr,
                                  scrtmp_sod_det.sod_part,
                                  scrtmp_so_mstr.so_site,
                                  show-mess,
                                  output cust-restr,output msg-txt).
                                         
             if cust-restr and global-mail-addr = "" then
                                             undo part-entry, retry part-entry.
          
             if cust-restr and (global-mail-addr <> "" 
                         and  global-mail-addr <> "GMB-EU-Demand@medline.com") /* RFC531 */ 
             then  do:
                assign send-mail = yes
                       mail-address = global-mail-addr
                       l_flg = yes. /* RFC531 */
             end.
          end. /* if scrtmp_so_mstr.so__chr10 <> "INVOICE" and not scrtmp_sod_det.sod_prodline ... */
          /* RFC533 ADD ENDS */ 

          find pt_mstr no-lock where pt_domain = domain
                                 and pt_part = scrtmp_sod_det.sod_part no-error.

          if new-line then do:
            if scrtmp_so_mstr.so__chr10 = "INVOICE" then assign scrtmp_sod_det.sod_site = scrtmp_so_mstr.so_site
                                                 scrtmp_sod_det.sod_loc = "CONSIGN".
            else if can-do("800,810,880",scrtmp_so_mstr.so_site) and
                    scrtmp_so_mstr.so__chr10 = "SAMPLES" then
                 scrtmp_sod_det.sod_loc = "SAMPLES".
            /* OT-153 DELETION
            else scrtmp_sod_det.sod_loc = "AIMS". */
            /* OT-153 START ADDITION */
            else if lvl_nonEMT3PL
            then
               scrtmp_sod_det.sod_loc = "FREE".
            else
               scrtmp_sod_det.sod_loc = "AIMS".
            /* OT-153 END ADDITION */

            display scrtmp_sod_det.sod_loc with frame d.

            hide message no-pause.

            if scrtmp_so_mstr.so__chr10 <> "INVOICE" then run check-all-mstr(domain).

          end. /* if new-line */


          if old-sod-type = "A" then do:

          /***** CEPS-739 ADD BEGINS ****************************/
             if can-find(first xxdsc_det
                where xxdsc_domain = scrtmp_sod_det.sod_domain
                  and xxdsc_cust   = scrtmp_so_mstr.so_cust
                  and xxdsc_part   = save-part
                  and xxdsc_discID <> 0
                  and xxdsc_nbr    = scrtmp_sod_det.sod_nbr
                  and xxdsc_line   = scrtmp_sod_det.sod_line)
             then 
                run createdis(input scrtmp_sod_det.sod_domain,
                              input scrtmp_so_mstr.so_cust,
                              input scrtmp_sod_det.sod_part,
                              input scrtmp_sod_det.sod_nbr,
                              input scrtmp_sod_det.sod_line,
                              input scrtmp_sod_det.sod_qty_ord,
                              input scrtmp_sod_det.sod_line).

             if can-find(first xxsurc_det
                where xxsurc_domain = tt_sod_det.sod_domain
                  and xxsurc_cust   = tt_so_mstr.so_cust
                  and xxsurc_part   = save-part
                  and xxsurc_nbr    = tt_sod_det.sod_nbr
                  and xxsurc_line   = tt_sod_det.sod_line)
             then
                run createsurc(input scrtmp_sod_det.sod_domain,
                               input scrtmp_so_mstr.so_cust,
                               input scrtmp_sod_det.sod_part,
                               input scrtmp_sod_det.sod_nbr,
                               input scrtmp_sod_det.sod_line,
                               input scrtmp_sod_det.sod_qty_ord,
                               input scrtmp_sod_det.sod_line).
          /***** CEPS-739 ADD ENDS ****************************/

            if substr(old-prod-line,1,2) <> substr(scrtmp_sod_det.sod_prodline,1,2) then do:
              display "New Product-line is not equal to " skip
                      "the Product-line of the orginal Item !!!" skip(1)
                       with frame yn067 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn067.
              hide frame yn067 no-pause.
              assign new-line = true
                     old-sod-type = "".
              undo part-entry, retry part-entry.
            end.
          end.

          /* OT-153 START ADDITION */
          if not lvl_nonEMT3PL
          then do:
          /* OT-153 END ADDITION */
             run "aw/awqtyavl.p" (yes,domain,emt-ordr,wh-domain,wh-site,
                                  scrtmp_sod_det.sod_site,scrtmp_sod_det.sod_part,scrtmp_sod_det.sod_um_conv,scrtmp_sod_det.sod_loc,
                                  scrtmp_so_mstr.so_site,scrtmp_so_mstr.so_ship,scrtmp_so_mstr.so__chr10,output qty-avl).
             run "xx/xxresqty.p" (input wh-site, 
                                  input scrtmp_sod_det.sod_part,
                                  input scrtmp_sod_det.sod_um_conv,
                                  output res_qtyavl). /*PMO2057*/
          /* OT-153 START ADDITION */
          end.
          else do:

             assign
                lvi_salesUMQty = 0
                lvc_oldSalesUM = scrtmp_sod_det.sod__qadc01
             .
             
             if scrtmp_sod_det.sod__chr10 <> "SAMPLES"
             then do:
             
                fr_salesUM-entry:
                do on error undo, retry:
                   
                   if new-line
                   then
                      lvc_salesUM = "CS".
                   else do:
                      
                      lvd_umConvValue 
                                = fn_getUMConv
                                     (input domain,
                                      input scrtmp_sod_det.sod_part,
                                      input scrtmp_sod_det.sod__qadc01).
                                        
                      assign
                         lvi_salesUMQty = old-qty-ord / lvd_umConvValue
                         lvc_salesUM = scrtmp_sod_det.sod__qadc01
                      .
                   end.
                
                   update lvi_salesUMQty
                          lvc_salesUM
                          go-on("END-ERROR") with frame fr_salesUM.
                    
                   lvc_salesUM = caps(lvc_salesUM).
                
                   if keyfunction(lastkey) = "END-ERROR"
                   then do:
                   
                      if new-line 
                      then do:
                      
                         scrtmp_sod_det.sod_qty_ord = 0.
                         undo part-entry, retry part-entry.
                      end.    
                      else do:
            
                         if old-qty-ord <> 0
                         then
                            scrtmp_sod_det.sod_qty_ord
                              = old-qty-ord / scrtmp_sod_det.sod_um_conv.
                         else
                            undo part-entry, retry part-entry.
              
                         assign
                            lSuppressSaveLine# = true
                            scrtmp_sod_det.sod__qadc01 = lvc_oldSalesUM
                         .
                      
                         display scrtmp_sod_det.sod__qadc01
                                 with frame d.
                        
                         undo frame-c-entry, return.
                      end.
                   end.
                
                   if lvi_salesUMQty = 0
                   then do:
                   
                      lvc_dispMsg =
                        "Zero NOT allowed, please fill in a quantity !!!".
                      {pxmsg.i &msgtext=lvc_dispMsg &errorlevel=3}

                      undo fr_salesUM-entry, retry fr_salesUM-entry.
                   end.
             
                   lvl_isValidSalesUM = yes.
                   run checkSalesUM(input scrtmp_sod_det.sod_domain,                                            
                                    input lvc_salesUM,
                                    input scrtmp_so_mstr.so_site,
                                    output lvl_isValidSalesUM).
              
                   if not lvl_isValidSalesUM
                   then
                      undo fr_salesUM-entry, retry fr_salesUM-entry.
             
                   lvd_umConvValue = fn_getUMConv
                                       (input domain,
                                        input scrtmp_sod_det.sod_part,
                                        input lvc_salesUM).
                                     
                   assign
                      scrtmp_sod_det.sod_um = "EA"
                      scrtmp_sod_det.sod__qadc01 = lvc_salesUM
                      scrtmp_sod_det.sod_qty_ord
                            = lvi_salesUMQty * lvd_umConvValue
                   .
                
                   display scrtmp_sod_det.sod__qadc01
                           with frame d.
                end.
             end.
             else do:
                lvd_umConvValue = fn_getUMConv
                                    (input domain,
                                     input scrtmp_sod_det.sod_part,
                                     input scrtmp_sod_det.sod__qadc01).
             end.
             
             run "aw/awqtyavl.p" (yes,
                                  domain,
                                  emt-ordr,
                                  wh-domain,
                                  wh-site,
                                  scrtmp_sod_det.sod_site,
                                  scrtmp_sod_det.sod_part,
                                  lvd_umConvValue,
                                  scrtmp_sod_det.sod_loc,
                                  scrtmp_so_mstr.so_site,
                                  scrtmp_so_mstr.so_ship,
                                  scrtmp_so_mstr.so__chr10,
                                  output qty-avl).

             run "xx/xxresqty.p" (input wh-site, 
                                  input scrtmp_sod_det.sod_part,
                                  input lvd_umConvValue,
                                  output res_qtyavl).
          end.
          /* OT-153 END ADDITION */

          ststatus = stline[2].
          status input ststatus.

          if emt-maint = no and scrtmp_sod_det.sod_qty_inv <> 0 then
                 scrtmp_sod_det.sod_qty_ord = scrtmp_sod_det.sod_qty_inv.

          update scrtmp_sod_det.sod_qty_ord
                 scrtmp_sod_det.sod_um when (((avail pt_mstr and pt_pm_code <> "C")
                            or not avail pt_mstr) and scrtmp_sod_det.sod_stat = ""
                            and scrtmp_sod_det.sod_qty_ship = 0)
                 go-on("F5","CTRL-D","END-ERROR") with frame c.
           
          if keyfunction(lastkey) = "END-ERROR" then do:
             if new-line 
             then do:
                scrtmp_sod_det.sod_qty_ord = 0.
                undo part-entry, retry part-entry.
             end.    
             else DO:
                /* OT-153 START ADDITION */
                scrtmp_sod_det.sod__qadc01 = lvc_oldSalesUM.
            
                display scrtmp_sod_det.sod__qadc01
                        with frame d.
                /* OT-153 END ADDITION */
            /* RFC2142 ADD BEGINS */
            if old-qty-ord <> 0
            then
               scrtmp_sod_det.sod_qty_ord = old-qty-ord / scrtmp_sod_det.sod_um_conv.
            else
               undo part-entry, retry part-entry.
              


            /* RFC2142 ADD ENDS */
            ASSIGN lSuppressSaveLine# = TRUE.
            undo frame-c-entry, return.
          END.

          end.

          if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
            if emt-maint and (scrtmp_sod_det.sod_status <> "" or scrtmp_sod_det.sod_qty_inv <> 0) then do:
              display "You may NOT delete this line, because" skip
                      "the quantity to invoice is NOT zero or" skip
                      "the status of the line is not <blank> !!!" skip(1)
                       with frame yn068 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn068.
              hide frame yn068 no-pause.
              undo qty-entry, retry qty-entry.
            end.
            display "Do you want to Delete this Line ??" skip(1)
                     with frame yn069 side-labels overlay row 10 col 10.
            update y-n label "Yes or No" go-on("END-ERROR") with frame yn069.
            hide frame yn069 no-pause.
              if y-n = true then run delete-line(domain,scrtmp_so_mstr.so__chr10,scrtmp_so_mstr.so_site,
                                                 output err-stat).
            ASSIGN lSuppressSaveLine# = TRUE.                                                 
            RETURN.
          end. /* if "F5" */

          if emt-maint and scrtmp_sod_det.sod_qty_ord = 0 then do:
            display "Zero NOT allowed, please fill in a quantity !!!" skip(1)
                     with frame yn070 side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn070.
            hide frame yn070 no-pause.
            undo qty-entry, retry qty-entry.
          end.

          if (emt-maint and scrtmp_sod_det.sod_qty_inv <> 0) or scrtmp_sod_det.sod_qty_ship <> 0 then do:
            if scrtmp_sod_det.sod_qty_ord < scrtmp_sod_det.sod_qty_inv then do:
              display "The quantity Ordered may NOT be less" skip
                      "than the quantity to invoice !!!" skip(1)
                       with frame yn071 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn071.
              hide frame yn071 no-pause.
              undo qty-entry, retry qty-entry.
            end.
            if scrtmp_sod_det.sod_qty_ord < scrtmp_sod_det.sod_qty_ship then do:
              display "The quantity Ordered may NOT be less" skip
                      "than the quantity shipped !!!" skip(1)
                       with frame yn072 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn072.
              hide frame yn072 no-pause.
              undo, retry qty-entry.
            end.
            if scrtmp_sod_det.sod_qty_all > 0 then scrtmp_sod_det.sod_qty_all =
                          max(0,min(scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship,scrtmp_sod_det.sod_qty_all)).
          end.

          run check-sod-um(domain).
          /* OT-153 DELETION
          if sod-um-ok = no then undo qty-entry, retry qty-entry. */
          /* OT-153 START ADDITION */
          if not sod-um-ok
          then do:
             scrtmp_sod_det.sod__qadc01 = lvc_oldSalesUM.
             display scrtmp_sod_det.sod__qadc01
                        with frame d.
             undo qty-entry, retry qty-entry.
          end.
          /* OT-153 END ADDITION */
          display scrtmp_sod_det.sod_um_conv with frame c.

          if scrtmp_sod_det.sod_qty_all <> 0 and scrtmp_sod_det.sod_status = "M" and
             scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv < old-qty-ord then do:
            display "The quantity Ordered may NOT be less" skip
                    "than the old quantity ordered !!!" skip(1)
                     with frame yn073 side-labels overlay row 10 col 10.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn073.
            hide frame yn073 no-pause.
            undo qty-entry, retry qty-entry.
          end.


          find cm_mstr no-lock where cm_domain = domain
                                 and cm_addr = scrtmp_so_mstr.so_cust no-error.
          if cm__chr07 <> "yes" then do: /*lum-allow = no*/
            find pt_mstr no-lock where pt_domain = wh-domain
                                   and pt_part = scrtmp_sod_det.sod_part no-error.
            if avail pt_mstr then do:
              if pt_lot_ser = "S" then scrtmp_sod_det.sod_um = "EA".
              else if emt-maint and
                   can-do("110,200,300,301,400,500,700,710,501",scrtmp_so_mstr.so_site) and /*PMO2068N*/
                   scrtmp_so_mstr.so__chr10 = "" and scrtmp_sod_det.sod_um = "EA" then do:
                find um_mstr no-lock where um_domain = wh-domain
                                       and um_part = scrtmp_sod_det.sod_part
                                       and um_um = pt_um
                                       and um_alt_um = "CS" no-error.
                /* OT-153 START DELETION
                if avail um_mstr then assign scrtmp_sod_det.sod_qty_ord = scrtmp_sod_det.sod_qty_ord / um_conv
                                             scrtmp_sod_det.sod_um_conv = um_conv
                                             scrtmp_sod_det.sod_um = "CS".
                OT-153 END DELETION */
                /* OT-153 START ADDITION */
                if available um_mstr
                then do:
                   if lvl_nonEMT3PL
                   then
                      assign
                         scrtmp_sod_det.sod_um_conv = um_conv
                         scrtmp_sod_det.sod_um = "EA"
                      .
                   else
                      assign
                         scrtmp_sod_det.sod_qty_ord
                              = scrtmp_sod_det.sod_qty_ord / um_conv
                         scrtmp_sod_det.sod_um_conv = um_conv
                         scrtmp_sod_det.sod_um = "CS"
                      .
                end.
                /* OT-153 END ADDITION */
              end.
            end.
            
            RUN CheckSodUm.

            run find-um-conv(domain).

           

            if pt_status = "8" then do:
              if old-qty-ord < scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv then do:
                qty-avl = 0.
                for each ld_det no-lock where ld_domain = "HQ"
                                          and ld_part = scrtmp_sod_det.sod_part
                                          and ld_loc <> "CONSIGN"
                                          and ld_status <> "HOLD"
                                          and ld_status <> "GIT":
                  qty-avl = qty-avl + ld_qty_oh.
                end.
                for each in_mstr no-lock where in_domain = "HQ"
                                           and in_part = scrtmp_sod_det.sod_part:
                  if in_site matches "*1" then
                  qty-avl = qty-avl - in_qty_all + in_qty_ord.
                end.
                if qty-avl < scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv then do:
                  IF lAllowBlocked# = TRUE
                  THEN DO:
                    display "This item has statuscode 8 !!!" skip
                          "and the available stock is only " +
                        trim(string(qty-avl / scrtmp_sod_det.sod_um_conv,"->>,>>>,>>9.9<<<<"))
                          + " " + caps(scrtmp_sod_det.sod_um) format "X(45)" skip(1)
                          "Press 'Y' to continue." SKIP
                          with frame yn0665 side-labels overlay row 10 col 10.
                  END.                          
                  ELSE DO:                          
                    display "This item has statuscode 8 !!!" skip
                          "and the available stock is only " +
                        trim(string(qty-avl / scrtmp_sod_det.sod_um_conv,"->>,>>>,>>9.9<<<<"))
                          + " " + caps(scrtmp_sod_det.sod_um) format "X(45)" SKIP(1)
                          with frame yn0665 side-labels overlay row 10 col 10.
                  END.
                  ASSIGN yn = ''.
                  update yn blank label "Press Enter" go-on("END-ERROR")
                         with frame yn0665.
                  hide frame yn0665 no-pause.
                  
                  IF lAllowBlocked# = FALSE OR 
                     CAPS(yn) <> 'Y'
                  THEN undo, retry qty-entry.
                end.
              end.
            end.

          end.
          else assign scrtmp_sod_det.sod_um = "EA"
                      scrtmp_sod_det.sod_um_conv = 1.

          display scrtmp_sod_det.sod_qty_ord scrtmp_sod_det.sod_um scrtmp_sod_det.sod_um_conv with frame c.

          run "aw/awgetimv.p" (scrtmp_sod_det.sod_part,scrtmp_so_mstr.so_cust,output scrtmp_sod_det.sod_slspsn[1]).

          display scrtmp_sod_det.sod_loc scrtmp_sod_det.sod_slspsn[1] with frame d.

          if scrtmp_sod_det.sod__chr10 = "SAMPLES" then do:
             /* OT-153 START ADDITION */ 
             if lvl_nonEMT3PL
             then
                scrtmp_sod_det.sod__qadc01 = "EA".
             /* OT-153 END ADDITION */
             
            find pt_mstr no-lock where pt_domain = wh-domain
                                   and pt_part = scrtmp_sod_det.sod_part no-error.
            if avail pt_mstr then do:
              find code_mstr no-lock where code_mstr.code_domain = "HQ"
                                       and code_mstr.code_fldname = "MIN-SAMPLE"
                                       and code_mstr.code_value = pt_part no-error.
              if avail code_mstr and scrtmp_sod_det.sod_um <> code_user1 then do:
                find um_mstr no-lock where um_domain = domain
                                       and um_part = scrtmp_sod_det.sod_part
                                       and um_um = pt_um
                                       and um_alt_um = code_user1 no-error.
                if avail um_mstr then um-conv = um_conv.
                else um-conv = 1.
                if (scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv) / um-conv <>
                  int((scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv) / um-conv) then do:
                   /* OT-153 START ADDITION */
                   if not lvl_nonEMT3PL
                   then do:
                   /* OT-153 END ADDITION */
                      display "The minimum SAMPLE quantity is 1 " + code_user1
                              format "X(50)" skip(1)
                             with frame yn074 side-labels overlay row 10 col 10.
                      update yn blank label "Press Enter" go-on("END-ERROR")
                             with frame yn074.
                      hide frame yn074 no-pause.
                   /* OT-153 START ADDITION */
                   end.
                   else do:
                      display 
                         "The minimum SAMPLE quantity is 1 " + code_user1
                         + " i.e " + string(um-conv) + " EA"
                        format "X(50)" skip
                         "Please enter in multiples of "
                         + string(um-conv) + " EA"
                        format "X(50)" skip(1)
                       with frame yn074a side-labels overlay row 10 col 10.
                      update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn074a.
                      hide frame yn074a no-pause.
                   end.
                   /* OT-153 END ADDITION */
                  if can-do("801,811,821,831,880",scrtmp_sod_det.sod_site)
                      then undo, retry qty-entry.
                end.
                if not can-do("801,811,821,831,880",scrtmp_sod_det.sod_site) then do:
                   /* OT-153 START ADDITION */
                   if not lvl_nonEMT3PL
                   then do:
                   /* OT-153 END ADDITION */
                      assign qty-sample = scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv
                             scrtmp_sod_det.sod_um_conv = um-conv
                             scrtmp_sod_det.sod_um = code_user1
                             scrtmp_sod_det.sod_qty_ord = qty-sample / scrtmp_sod_det.sod_um_conv.
                   /* OT-153 START ADDITION */
                   end.
                   else do:
                      assign
                         qty-sample = scrtmp_sod_det.sod_qty_ord
                                      * scrtmp_sod_det.sod_um_conv
                         scrtmp_sod_det.sod_um_conv = 1
                         scrtmp_sod_det.sod_um = "EA"
                         scrtmp_sod_det.sod__qadc01 = code_user1
                      .

                      if qty-sample < um-conv
                      then
                         scrtmp_sod_det.sod_qty_ord = um-conv.
                      else if qty-sample / um-conv <> int(qty-sample / um-conv)
                      then
                         undo qty-entry, retry qty-entry.
                      else
                         scrtmp_sod_det.sod_qty_ord = qty-sample.
                   end.
                   /* OT-153 END ADDITION */
                  if scrtmp_sod_det.sod_qty_ord < 1 then scrtmp_sod_det.sod_qty_ord = 1.
                  if int(scrtmp_sod_det.sod_qty_ord) <> scrtmp_sod_det.sod_qty_ord then
                       scrtmp_sod_det.sod_qty_ord = int(scrtmp_sod_det.sod_qty_ord) + 1.
                  display scrtmp_sod_det.sod_qty_ord scrtmp_sod_det.sod_um scrtmp_sod_det.sod_um_conv with frame c.
                end.
              end.
              else do:
                find code_mstr no-lock where code_mstr.code_domain = wh-domain
                                         and code_mstr.code_fldname = "pt_group"
                                         and code_mstr.code_value = pt_group no-error.
                if avail code_mstr then do:
                  find code_mstr no-lock where code_mstr.code_domain = "HQ"
                                           and code_mstr.code_fldname = "MIN-SAMPLE"
                                           and code_mstr.code_value = pt_group no-error.
                  if avail code_mstr and scrtmp_sod_det.sod_um <> code_user1 then do:
                    find um_mstr no-lock where um_domain = wh-domain
                                           and um_part = scrtmp_sod_det.sod_part
                                           and um_um = pt_um
                                           and um_alt_um = code_user1 no-error.
                    if avail um_mstr then um-conv = um_conv.
                    else um-conv = 1.
                    if (scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv) / um-conv <>
                      int((scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv) / um-conv) then do:
                       /* OT-153 START ADDITION */
                       if not lvl_nonEMT3PL
                       then do:
                       /* OT-153 END ADDITION */
                          display "The minimum SAMPLE quantity is 1 " + code_user1
                                  format "X(50)" skip(1)
                                with frame yn075 side-labels overlay row 10 col 10.
                          update yn blank label "Press Enter" go-on("END-ERROR")
                                 with frame yn075.
                          hide frame yn075 no-pause.
                       /* OT-153 START ADDITION */
                       end.
                       else do:
                          display 
                              "The minimum SAMPLE quantity is 1 " + code_user1
                              + " i.e " + string(um-conv) + " EA"
                             format "X(50)" skip
                              "Please enter in multiples of "
                              + string(um-conv) + " EA"
                             format "X(50)" skip(1)
                            with frame yn075a side-labels overlay row 10
                                                                  col 10.
                           update yn blank label "Press Enter"
                                             go-on("END-ERROR")
                            with frame yn075a.
                           hide frame yn075a no-pause.
                       end.
                       /* OT-153 END ADDITION */
                      if can-do("801,811,821,831,880",scrtmp_sod_det.sod_site) then
                                                         undo, retry qty-entry.
                    end.
                    if not can-do("801,811,821,831,880",scrtmp_sod_det.sod_site) then do:
                       /* OT-153 START ADDITION */
                       if not lvl_nonEMT3PL
                       then do:
                       /* OT-153 END ADDITION */
                          assign qty-sample = scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv
                                 scrtmp_sod_det.sod_um_conv = um-conv
                                 scrtmp_sod_det.sod_um = code_user1
                                 scrtmp_sod_det.sod_qty_ord = qty-sample / scrtmp_sod_det.sod_um_conv.
                       /* OT-153 START ADDITION */
                       end.
                       else do:
                          assign
                             qty-sample = scrtmp_sod_det.sod_qty_ord
                                          * scrtmp_sod_det.sod_um_conv
                             scrtmp_sod_det.sod_um_conv = 1
                             scrtmp_sod_det.sod_um = "EA"
                             scrtmp_sod_det.sod__qadc01 = code_user1
                          .
                     
                          if qty-sample < um-conv
                          then
                             scrtmp_sod_det.sod_qty_ord = um-conv.
                          else if qty-sample / um-conv <> int(qty-sample / um-conv)
                          then
                             undo qty-entry, retry qty-entry.
                          else
                             scrtmp_sod_det.sod_qty_ord = qty-sample.
                       end.
                       /* OT-153 END ADDITION */
                      if scrtmp_sod_det.sod_qty_ord < 1 then scrtmp_sod_det.sod_qty_ord = 1.
                      if int(scrtmp_sod_det.sod_qty_ord) <> scrtmp_sod_det.sod_qty_ord then
                         scrtmp_sod_det.sod_qty_ord = int(scrtmp_sod_det.sod_qty_ord) + 1.
                    end.
                  end.
                  display scrtmp_sod_det.sod_qty_ord scrtmp_sod_det.sod_um scrtmp_sod_det.sod_um_conv with frame c.
                end.
              end.
            end.
            /* OT-153 START ADDITION */
            display scrtmp_sod_det.sod__qadc01
                    with frame d.
            /* OT-153 END ADDITION */
          end.

          hide message no-pause.

          run "aw/awqtyavl.p" (yes,domain,emt-ordr,wh-domain,wh-site,
                                   scrtmp_sod_det.sod_site,scrtmp_sod_det.sod_part,scrtmp_sod_det.sod_um_conv,scrtmp_sod_det.sod_loc,
                                   scrtmp_so_mstr.so_site,scrtmp_so_mstr.so_ship,scrtmp_so_mstr.so__chr10,output qty-avl).
          /*qty-avl = qty-avl + scrtmp_sod_det.sod_qty_all. PMO2057*/
/*PMO2057 START OF ADDITION ***************************************************/
          run "xx/xxresqty.p" (input wh-site, 
                              input scrtmp_sod_det.sod_part,
                              input scrtmp_sod_det.sod_um_conv,
                              output res_qtyavl). 

          /* OT-153 START ADDITION */
          if lvl_nonEMT3PL
          then do:
             
             lvd_umConvValue = fn_getUMConv
                                  (input domain,
                                   input scrtmp_sod_det.sod_part,
                                   input scrtmp_sod_det.sod__qadc01).
             
             qty-avl = fn_getQtyRndByUMConv
                             (input qty-avl,
                              input lvd_umConvValue).
                           
             res_qtyavl = fn_getQtyRndByUMConv
                             (input res_qtyavl,
                              input lvd_umConvValue).
                           
          end.
          /* OT-153 END ADDITION */

            if l-3pl then do:
                if wh-loc = "RESERVED" then
                   res_qtyavl = res_qtyavl + scrtmp_sod_det.sod_qty_all.
                else
                   qty-avl = qty-avl + scrtmp_sod_det.sod_qty_all.
            end. /*if l-3pl*/
            else
                 qty-avl = qty-avl + scrtmp_sod_det.sod_qty_all.
/*PMO2057 END OF ADDITION *****************************************************/
/*CHN00417 START OF ADDITION *************************************************/
            l-all = no.
            find first pt_mstr no-lock where pt_domain = wh-domain
                                            and pt_part   = scrtmp_sod_det.sod_part no-error.
            find first si_mstr no-lock where si_domain = wh-domain
                                            and si_site   = wh-site 
                                            and si_type   = yes      no-error.
            find first pti_det no-lock where pti_det.oid_pt_mstr = pt_mstr.oid_pt_mstr
                                            and pti_det.oid_si_mstr = si_mstr.oid_si_mstr 
                                            and pti_det.pti_userl01 = yes no-error.
            if available pti_det then 
               l-all = yes.
/*CHN00417 END OF ADDITION *************************************************/

          if scrtmp_so_mstr.so__chr10 = "INVOICE" and scrtmp_sod_det.sod_qty_ord > scrtmp_sod_det.sod_qty_inv then
            assign scrtmp_sod_det.sod_qty_all = max(0,scrtmp_sod_det.sod_qty_ord)
                   scrtmp_sod_det.sod_qty_pick = 0.
          else if scrtmp_so_mstr.so__chr10 <> "INVOICE" and
            /*(new-line or scrtmp_sod_det.sod_qty_ord <> scrtmp_sod_det.sod_qty_all) then
            scrtmp_sod_det.sod_qty_all = max(0,min(scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship,
                                qty-avl)). CHN00417*/
           (new-line or scrtmp_sod_det.sod_qty_ord <> scrtmp_sod_det.sod_qty_all) and l-all = no then 
            scrtmp_sod_det.sod_qty_all = max(0,min(scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship,
                                qty-avl)). /*CHN00417*/    
          if scrtmp_sod_det.sod_qty_all = ? then scrtmp_sod_det.sod_qty_all = 0.
          if  cust-restr 
          then
             scrtmp_sod_det.sod_qty_all = 0 . /* 14642 */  
          display scrtmp_sod_det.sod_qty_all with frame d.
        end. /* if status = "" */

        
        if emt-maint = yes then do:
          find pt_mstr no-lock where pt_domain = wh-domain
                                 and pt_part = scrtmp_sod_det.sod_part no-error.
          qty-ord-cs = scrtmp_sod_det.sod_qty_ord.
          if scrtmp_sod_det.sod_um <> "CS" then do:
            if avail pt_mstr then do:
              find um_mstr no-lock where um_domain = wh-domain
                                     and um_part = scrtmp_sod_det.sod_part
                                     and um_um = pt_um
                                     and um_alt_um = "CS" no-error.
              if avail um_mstr then
                qty-ord-cs = (qty-ord-cs * scrtmp_sod_det.sod_um_conv) / um_conv.
            end.
          end.
            
           /****** RFC2142 DELETE BEGINS
           /* at beginnning of line entry all block types are cleaned */

              ASSIGN l_bl_list = "Editblock".
              do l_cnt = 1 TO num-entries(l_bl_list) /* num-entries(l_blty) */:
                 for first xxblck_det exclusive-lock
                    where xxblck_domain = scrtmp_sod_det.sod_domain
                              and xxblck_ord    = scrtmp_sod_det.sod_nbr
                              and xxblck_line   = scrtmp_sod_det.sod_line
                              and xxblck_type   = entry(l_cnt,l_bl_list)
                      use-index xxblck_time:
                    delete xxblck_det.
                 end. /* for first xxblck_det */
              end.  /* l_cnt = 1 to num-entries(l_blty) */
             
              RUN SetEditBlock (BUFFER scrtmp_so_mstr,
                                BUFFER scrtmp_sod_det,
                                BUFFER pt_mstr,
                                "Editblock").
                                
            /*                 
                 
              run "xx/xxetbkvn.p" (BUFFER tt_so_mstr,
                                  BUFFER tt_sod_det,
                                  recid(pt_mstr),
                                  domain,
                                  qty-ord-cs,
                                  wh-domain,
                                  wh-site,
                                  emt-ordr,
                                  "Editblock",
                                                  "Blocked",
                                  output l_edblval ).
            */                                  

                                  
            if l_edblval
            then do:
               
               l_edblval = no.
            /* 8680 ADD ENDS */

               DesignGroup = "".
               for first pt_mstr no-lock
                  where pt_domain = "HQ"
                    and pt_part = scrtmp_sod_det.sod_part:
               end.
               display  "EDIT BLOCK FILTER " skip                                              
                        "The order quantities are exceeding the planned, " skip            
                               "inventory to be available for this site." skip                        
                 
               with frame yn0751 side-labels overlay row 12 col 6.                             
               update yn blank label "Press Enter" go-on("END-ERROR")
               with frame yn0751.
               hide frame yn0751 no-pause.

            end. /* if edblvl */
            **************************RFC2142 DELETE ENDS **/

          /* Check ordered quantity against order history */
          run us/zu/zuchkqty.p(scrtmp_sod_det.sod_domain, scrtmp_sod_det.sod_nbr, scrtmp_sod_det.sod_line, output sod-qty-ok).
          if not sod-qty-ok then do:
            display "The entered quantity is much larger than" skip
                    "what was recently ordered by this customer." skip(1)
                    "Please review the ordered quantity before" skip
                    "to continue!" skip(1)
                     with frame yn0752 side-labels overlay row 10 col 15.
            update yn blank label "Press Enter" go-on("END-ERROR")
                   with frame yn0752.
            hide frame yn0752 no-pause.
          end. /* scrtmp_sod_det.sod_qty_ord > qty-fcst2 */
        end. /* if emt-maint = yes  */

        ststatus = stline[1].
        status input ststatus.

        price-entry:
        do on error undo, retry:
          if old-sod-type <> "A" then do:
            av-test = no.

            if new-line or reprice /* or old-um <> scrtmp_sod_det.sod_um  */then do:

              if can-do("CENTRAL,SAMPLES,CONSIGN",scrtmp_so_mstr.so__chr10) and
                 scrtmp_so_mstr.so_site <> "700" then assign scrtmp_sod_det.sod_price   = 0
                                              scrtmp_sod_det.sod_list_pr = 0.
              if scrtmp_sod_det.sod_type = "" then do:
                find in_mstr no-lock where in_domain = domain
                                       and in_site = scrtmp_sod_det.sod_site
                                       and in_part = scrtmp_sod_det.sod_part no-error.
                if avail in_mstr then
                  find sct_det no-lock where sct_domain = domain
                                         and sct_sim = "Standard"
                                         and sct_site = in_gl_cost_site
                                         and sct_part = scrtmp_sod_det.sod_part no-error.
                if not avail sct_det or not avail in_mstr then do:
                  display "There is no Costprice record present for this Item."
                /* skip "Please send an email to GMB-EU.Finance ..." skip(1)      INC18061 */
                   skip "Please send an email to GMB-EU-Costing ..." skip(1)   /* INC18061 */ 
                         with frame yn076 side-labels overlay row 10 col 15.
                  update yn blank label "Press Enter" go-on("END-ERROR")
                         with frame yn076.
                  hide frame yn076 no-pause.
                  if new-line then DO:
                    DELETE scrtmp_sod_det. /* Here no qxtend call needed because the line is not in qad yet */
                    ASSIGN lSuppressSaveLine# = TRUE.
                    return.
                  END.
                end.
              end.

              if new-line then do:
                /* RUN SaveDataToDSTT. */
                /* run "zu/zusodsls.p" (domain,scrtmp_sod_det.sod_nbr,scrtmp_sod_det.sod_line). */
                run "zu/zusodsls.p" (INPUT BUFFER scrtmp_so_mstr:HANDLE, INPUT BUFFER scrtmp_sod_det:HANDLE). 
                /* RUN SaveDataFromDSTT. */
                acct-cc = scrtmp_sod_det.sod_acct.
                if scrtmp_sod_det.sod_cc <> "" then acct-cc = acct-cc + "-" + scrtmp_sod_det.sod_cc.
                if show-mess then display acct-cc with frame d.
              end.
              if scrtmp_sod_det.sod_pricing_dt = ? or reprice then scrtmp_sod_det.sod_pricing_dt = today.

              txt = "".
              if can-do("CENTRAL,SAMPLES,CONSIGN",scrtmp_so_mstr.so__chr10) and
                 not can-do("700,710",scrtmp_so_mstr.so_site) then assign scrtmp_sod_det.sod_price   = 0
                                                           scrtmp_sod_det.sod_list_pr = 0.
              else do:
                hide message no-pause.
                IF lRollBack THEN 
                DO:                
                   run "zu/zuprice.p" (yes,domain,scrtmp_so_mstr.so_site,scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_curr,
                                         scrtmp_sod_det.sod_part,scrtmp_sod_det.sod_qty_ord,scrtmp_sod_det.sod_um,scrtmp_sod_det.sod_pricing_dt,
                                          output scrtmp_sod_det.sod_list_pr,output scrtmp_sod_det.sod_price).                                      
                END.
                ELSE DO:
                  FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                                AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                                AND ttApiPrice.ttpart = scrtmp_sod_det.sod_part 
                            and ttApiPrice.ttQty  = scrtmp_sod_det.sod_qty_ord /* palletd */
                                EXCLUSIVE-LOCK NO-ERROR.
                  IF NOT AVAILABLE ttApiPrice THEN DO:
                    ./ MESSAGE "Get API price 3" VIEW-AS ALERT-BOX.
                    /* cError = GetItemPrice(scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_curr,scrtmp_sod_det.sod_part,STRING(scrtmp_sod_det.sod_qty_ord),scrtmp_sod_det.sod_pricing_dt). palletd*/
               li_surcacc = 0. /* mulof */ 
               iPriceID = 0. /* CEPS-1582 */
               cError = GetItemPrice(scrtmp_so_mstr.so_cust,
                                  scrtmp_so_mstr.so_curr,
                                  scrtmp_sod_det.sod_part,
                                  STRING(scrtmp_sod_det.sod_qty_ord),
                                  STRING(scrtmp_sod_det.sod_um_conv), /* palletd */
                                  scrtmp_sod_det.sod_pricing_dt).
            IF cError = "" THEN 
                      FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                                AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                                AND ttApiPrice.ttpart = scrtmp_sod_det.sod_part
                                EXCLUSIVE-LOCK NO-ERROR.                   
                    ELSE
                      ASSIGN scrtmp_sod_det.sod__chr02 = cError.
                  END.
                  IF AVAILABLE ttApiPrice 
          THEN do: /* surcharge */
                    ASSIGN scrtmp_sod_det.sod_list_pr = ttApiPrice.ttprice * GetUomConv(scrtmp_sod_det.sod_part,scrtmp_sod_det.sod_um)
                           scrtmp_sod_det.sod_price = ttApiPrice.ttprice * GetUomConv(scrtmp_sod_det.sod_part, scrtmp_sod_det.sod_um)
                           /* scrtmp_sod_det.sod__chr07 = IF ttApiPrice.ttPriceId NE 0 THEN STRING(ttApiPrice.ttPriceID) ELSE "0"
                           scrtmp_sod_det.sod__chr08 = IF ttApiPrice.ttDiscId NE 0 THEN STRING(ttApiPrice.ttDiscID) ELSE "0"  */
                           iPriceID = IF ttApiPrice.ttPriceId NE 0 THEN ttApiPrice.ttPriceID ELSE 0
                           iDiscountID = IF ttApiPrice.ttDiscId NE 0 THEN ttApiPrice.ttDiscId ELSE 0
               li_surcper = if ttapiprice.ttsurchargeperc ne 0 
                                then 
                                  ttapiprice.ttsurchargeperc else 0 /* surcharge */
                           scrtmp_sod_det.sod__chr02 = "OK"
               /*scrtmp_sod_det.sod__chr06 = string(ttapiprice.ttprice)  CEPS-301*/
               scrtmp_sod_det.sod__chr04 = if ttapiprice.ttsurchargeperc ne 0 
                                               then 
                                                  string(ttapiprice.ttsurchargeperc) else "0". /* surcharge */
/*CEPS-301 ADD BEGINS*/
               scrtmp_sod_det.sod__chr06 = string(fn_getnetprice(ttApiPrice.ttprice,
                                          (ttApiPrice.ttDiscPerc + ttApiPrice.ttlidiscperc),
                                           ttapiprice.ttsurchargeperc)).
/*CEPS-301 ADD ENDS*/                                                  

                    /* surcharge ADD BEGINS */                          
            if ttapiprice.ttsurchargeperc ne 0                  
               and  not can-find(first xxsurc_det                 
            where xxsurc_domain  = scrtmp_sod_det.sod_domain     
              and xxsurc_cust    = scrtmp_so_mstr.so_cust        
                      and xxsurc_part    = scrtmp_sod_det.sod_part       
              and xxsurc_nbr     = scrtmp_sod_det.sod_nbr        
              and xxsurc_line    = scrtmp_sod_det.sod_line
                  and xxsurc_ID      > 0
              and xxsurc_qty_ord = scrtmp_sod_det.sod_qty_ord)      
              then
                 assign
                li_surcacc = 0 /* mulof */
                    cError = GetItemPrice(scrtmp_so_mstr.so_cust,    
                                          scrtmp_so_mstr.so_curr,    
                                      scrtmp_sod_det.sod_part,           
                                             STRING(scrtmp_sod_det.sod_qty_ord),
                              STRING(scrtmp_sod_det.sod_um_conv), /* palletd */
                                            scrtmp_sod_det.sod_pricing_dt).  
           /* surcharge ADD ENDS */                          
                end. /* IF AVAILABLE ttApiPrice  */    

                ELSE DO:       
                    IF cError NE "" THEN 
                      ASSIGN scrtmp_sod_det.sod__chr02 = cError.
                  END.
                END.
                 
                                         
                /* MP: Modification for MLQ-00059 */
                /*
                if domain = "IT" and can-find(cm_mstr where cm_domain = "IT"
                                                        and cm_addr = scrtmp_so_mstr.so_cust
                                       and cm_daybookset = "SLS-PUBL") then do:
                */
                
               /* Alexander - CIG code  */
               IF lRollBack THEN 
               DO:               
                if glCIGCodeEnabled# and can-find(cm_mstr where cm_domain = domain
                                                            and cm_addr = scrtmp_so_mstr.so_cust /*
                                       and cm_daybookset = "SLS-PUBL" */ ) 
                then do:                                       
                  assign txt = entry(1,return-value)
                         scrtmp_sod_det.sod__chr01 = entry(2,return-value). /*CIG*/

                  /*8674 begin*/
                  if txt <> "" then /*valid customer pricelist found*/
                    /*update CIG code for Italy*/
                    update scrtmp_sod_det.sod__chr01 go-on("END-ERROR") with frame cig-fr.

                  if scrtmp_sod_det.sod__chr01 <> "" then do:
                    find last xxprl_mstr
                      where xxprl_mstr.xxprl_domain = domain
                        and xxprl_mstr.xxprl_list = "CUSTOMER"
                        and xxprl_mstr.xxprl_cs_code = scrtmp_so_mstr.so_cust
                        and xxprl_mstr.xxprl_part_code = scrtmp_sod_det.sod_part
                        and xxprl_mstr.xxprl_curr = scrtmp_so_mstr.so_curr
                        and xxprl_mstr.xxprl_start <= today
                        and (xxprl_mstr.xxprl_expire >= today or
                             xxprl_mstr.xxprl_expire = ?)
                    no-lock no-error.
                    if avail xxprl_mstr then do:
                      if not can-find(first code_mstr
                                      where code_mstr.code_domain = domain
                                        and code_mstr.code_fldname = "cig-code"
                                        and code_mstr.code_value = xxprl_list_id)
                      then do:
                        create code_mstr.
                        assign code_mstr.code_domain = domain
                               code_mstr.code_fldname = "cig-code"
                               code_mstr.code_value = xxprl_list_id.
                      end.
                      for first code_mstr exclusive-lock
                          where code_mstr.code_domain = domain
                            and code_mstr.code_fldname = "cig-code"
                            and code_mstr.code_value = xxprl_list_id:
                        code_mstr.code_cmmt = scrtmp_sod_det.sod__chr01.
                      end.
                      /********INC99965-ADD STARTS************/
                      if available code_mstr 
                      then 
                         release code_mstr.
                      /********INC99965-ADD ENDS************/
                    end. /*if avail xxprl_mstr*/
                  end. /*if scrtmp_sod_det.sod__chr01 <> ""*/
                  /*8674 end*/

                  if scrtmp_sod_det.sod__chr01 = "" AND
                      can-find(cm_mstr where cm_domain = domain
                                         and cm_addr = scrtmp_so_mstr.so_cust 
                                         and cm_daybookset = "SLS-PUBL"  )
                  
                  then do:
                    message "C.I.G.-code is missing !!!..." skip
                            "Mail will be sent to the pricing/tender team."
                            view-as alert-box.

                    output to value("/tmp/" + scrtmp_so_mstr.so_nbr + "-cig.txt").
                    if intf-dir + server-id <> "/ext1/prod" then
                    put unformatted "This is a TEST, please discard ..." chr(10) chr(10).
                    put unformatted "MAIL FROM :" mail-from chr(10). /*VM2*/

                    put unformatted "Please be advised that on Order " scrtmp_so_mstr.so_nbr
                                    " the C.I.G.-code is missing, this is for"
                                    " customer " scrtmp_so_mstr.so_cust " and item " scrtmp_sod_det.sod_part.
                    if entry(1,return-value) <> "" then put unformatted
                                ", Pricelist found was " entry(1,return-value).
                    else put unformatted ", NO pricelist was found ...".
                    output close.

                    find usr_mstr no-lock where usr_userid = global_userid.
                    mail-from = usr_mail_address.

                    mail-to = "it.pricing@medline.com Teresa.graziano@medline.com g-it-cs@medline.com".                  

                    run us/av/avmail.p(mail-to ,                /* Mail Address */
                                 "Attention, CIG code missing", /* Subject      */
                                 "/tmp/" + scrtmp_so_mstr.so_nbr + "-cig.txt", /* Body         */
                                 "",                            /* Attachment   */
                                 no).                           /* Zip yes/no   */
        
                    mail-to = "".
                    os-delete value("/tmp/" + scrtmp_so_mstr.so_nbr + "-cig.txt").
                  end.
                  else message "C.I.G.-code confirmed was:" scrtmp_sod_det.sod__chr01.
                end.
                else txt = return-value.
                
               END.
               ELSE DO:
                 
                /* ASSIGN scrtmp_sod_det.sod__chr06 = string(li_upr) /* RFC-3012 */  CEPS-301*/
                ASSIGN scrtmp_sod_det.sod__chr07 = string(iPriceID) 
                        scrtmp_sod_det.sod__chr08 = string(iDiscountID)
            scrtmp_sod_det.sod__chr04 = string(li_surcper). /* surcharge */
                                          
                 IF glCIGCodeEnabled# AND can-find(cm_mstr where cm_domain = domain
                                                            and cm_addr = scrtmp_so_mstr.so_cust)
                                                            /* AVAILABLE ttApiPrice THEN    */
                 THEN DO:                 
                   if available ttApiPrice
           then 
                    ASSIGN scrtmp_sod_det.sod__chr01 = ttApiPrice.ttCIG. /*CIG*/ 
                    
                   /*8674 begin*/
                   if scrtmp_sod_det.sod__chr07 <> "" then /*valid customer pricelist found*/
                    /*update CIG code for Italy*/
                     update scrtmp_sod_det.sod__chr01 go-on("END-ERROR") with frame cig-fr.

                   if scrtmp_sod_det.sod__chr01 <> "" then do:
                    if avail ttApiPrice then do:
                      if not can-find(first code_mstr
                                      where code_mstr.code_domain = domain
                                        and code_mstr.code_fldname = "cig-code"
                                        and code_mstr.code_value = STRING(ttApiPrice.ttPriceID))
                      then do:
                        create code_mstr.
                        assign code_mstr.code_domain = domain
                               code_mstr.code_fldname = "cig-code"
                               code_mstr.code_value = STRING(ttApiPrice.ttPriceID).
                      end.
                      for first code_mstr exclusive-lock
                          where code_mstr.code_domain = domain
                            and code_mstr.code_fldname = "cig-code"
                            and code_mstr.code_value = STRING(ttApiPrice.ttPriceID):
                        code_mstr.code_cmmt = scrtmp_sod_det.sod__chr01.
                      end.
                      /********INC99965-ADD STARTS************/
                      if available code_mstr 
                      then 
                         release code_mstr.
                      /********INC99965-ADD ENDS************/
                    end. /*if avail xxprl_mstr*/
                   end. /*if scrtmp_sod_det.sod__chr01 <> ""*/
                   /*8674 end*/
                                    
                   IF scrtmp_sod_det.sod__chr01 = "" AND 
                     CAN-FIND(cm_mstr WHERE cm_domain = domain
                                        AND cm_addr = scrtmp_so_mstr.so_cust 
                                        AND cm_daybookset = "SLS-PUBL"  ) 
                   THEN DO:
                     message "C.I.G.-code is missing !!!..." skip
                             "Mail will be sent to the pricing/tender team."
                             view-as alert-box.

                     output to value("/tmp/" + scrtmp_so_mstr.so_nbr + "-cig.txt").
                     if intf-dir + server-id <> "/ext1/prod" then
                     put unformatted "This is a TEST, please discard ..." chr(10) chr(10).
                     put unformatted "MAIL FROM :" mail-from chr(10). /*VM2*/

                     put unformatted "Please be advised that on Order " scrtmp_so_mstr.so_nbr
                                     " the C.I.G.-code is missing, this is for"
                                     " customer " scrtmp_so_mstr.so_cust " and item " scrtmp_sod_det.sod_part.
                     /* if entry(1,return-value) <> "" then put unformatted
                                   ", Pricelist found was " entry(1,return-value). 
                     else put unformatted ", NO pricelist was found ...".   */                  
                     output close.
                    
                     find usr_mstr no-lock where usr_userid = global_userid.
                     mail-from = usr_mail_address.

                     mail-to = "it.pricing@medline.com Teresa.graziano@medline.com g-it-cs@medline.com".                  
                    

                     run us/av/avmail.p(mail-to ,                /* Mail Address */
                                 "Attention, CIG code missing", /* Subject      */
                                 "/tmp/" + string(scrtmp_so_mstr.so_nbr) + "-cig.txt", ~ /* Body         */
                                 "",                            /* Attachment   */
                                 no).                           /* Zip yes/no   */
            
                     mail-to = "".
                     os-delete value("/tmp/" + scrtmp_so_mstr.so_nbr + "-cig.txt").                  
                   END. 
                   ELSE 
                    IF AVAILABLE ttApiPrice THEN txt = ttApiPrice.ttCIG .
                  END.
                  ELSE 
                    assign scrtmp_sod_det.sod__chr01 = "".                  
               END. /* IF lRollBack - CGI */
              end.                                               
              
              IF lRollBack THEN DO:
                if scrtmp_sod_det.sod_price = 0 and txt = "" and not
                  can-do("CENTRAL,SAMPLES,CONSIGN",scrtmp_so_mstr.so__chr10) then do:
                  run find-prices(domain).
                  if scrtmp_sod_det.sod_price <> 0 then av-test = yes.
                end.
              END.
              
              IF lRollBack THEN 
              DO:
                if scrtmp_sod_det.sod_list_pr <> 0 then
                     scrtmp_sod_det.sod_disc_pct = (1 - (scrtmp_sod_det.sod_price / scrtmp_sod_det.sod_list_pr)) * 100.
                else scrtmp_sod_det.sod_disc_pct = 0.
              END.              
              ELSE DO:
                if scrtmp_sod_det.sod_list_pr <> 0 
        then do: /* mulof */
           /* IF AVAILABLE ttApiPrice THEN ttApiPrice.ttDiscPerc  ELSE 0. mulof*/
           /* mulof ADD BEGINS */
           if available ttapiprice 
              and (ttApiPrice.ttDiscPerc = 0
              and  ttApiPrice.ttlidiscperc > 0)
                   then
                       scrtmp_sod_det.sod_disc_pct = ttApiPrice.ttlidiscperc.
                   else if available ttapiprice 
              and (ttApiPrice.ttDiscPerc > 0
              and  ttApiPrice.ttlidiscperc = 0)
           then 
               scrtmp_sod_det.sod_disc_pct =  ttApiPrice.ttDiscPerc.
                   else if available ttapiprice 
              and (ttApiPrice.ttDiscPerc > 0
                  and  ttApiPrice.ttlidiscperc > 0)
           then 
                  scrtmp_sod_det.sod_disc_pct =  ttApiPrice.ttlidiscperc 
                                             + ttApiPrice.ttDiscPerc. 
                    else scrtmp_sod_det.sod_disc_pc = 0. 
                   /* mulof ADD ENDS */
                end. /* if scrtmp_sod_det.sod_list_pr <> 0 */
                else scrtmp_sod_det.sod_disc_pct = 0.              
               /* scrtmp_sod_det.sod__chr06 = string(ttapiprice.ttprice).  RFC-3012_1*/
/* CEPS-301 DELETE BEGINS              
/*RFC-3012_1 ADD BEGINS*/
           if available   ttapiprice then           
              scrtmp_sod_det.sod__chr06 = string(ttapiprice.ttprice).
CEPS-301 DELETE ENDS*/

/*CEPS-301 ADD BEGINS*/
           if available ttapiprice then           
              scrtmp_sod_det.sod__chr06 = string(fn_getnetprice(ttApiPrice.ttprice,
                                              scrtmp_sod_det.sod_disc_pct,
                                              decimal(scrtmp_sod_det.sod__chr04))).
/*CEPS-301 ADD ENDS*/
           else 
              scrtmp_sod_det.sod__chr06 = "".
/*RFC-3012_1 ADD ENDS*/                      
              END. 
          /*RFC-3012 ADD BEGINS*/
          display scrtmp_sod_det.sod__chr06  label "Unit Price" skip(1) 
                  with frame yn676 side-labels overlay row 6 col 40. 
          update yn blank label "Press Enter" go-on("END-ERROR")
                         with frame yn676.
               hide frame yn676 no-pause.
           /*RFC-3012 ADD BEGINS*/
              display scrtmp_sod_det.sod_list_pr scrtmp_sod_det.sod_disc_pct scrtmp_sod_det.sod_price with frame c.

              if new-line then do:
                update scrtmp_sod_det.sod_type go-on("END-ERROR") with frame c.
                if keyfunction(lastkey) = "END-ERROR" then undo qty-entry,
                                                          retry qty-entry.

                if scrtmp_sod_det.sod_type = "M" and emt-maint = true then do:
                  display "Line-Type 'M' is not allowed in this program,"
                     skip "please use program 7.1.4 ..." skip(1)
                           with frame yn281 side-labels overlay row 10 col 10.
                  update yn blank label "Press Enter" go-on("END-ERROR")
                         with frame yn281.
                  hide frame yn281 no-pause.
                  undo price-entry, retry price-entry.
                end.

                if not can-do(",A,M",scrtmp_sod_det.sod_type) then do:
                  if can-do("110,200,300,400,500",scrtmp_so_mstr.so_site) and emt-maint = true
                  then do:
                    display "Only <blank> or 'A' for Alternative Item allowed"
                            "!!!" skip(1)
                            with frame yn081 side-labels overlay row 10 col 10.
                    update yn blank label "Press Enter" go-on("END-ERROR")
                           with frame yn081.
                    hide frame yn081 no-pause.
                  end.
                  else do:
                   display "Only <blank> or 'M' for Memo Invoicing allowed !!!"
                    skip(1) with frame yn181 side-labels overlay row 10 col 10.
                    update yn blank label "Press Enter" go-on("END-ERROR")
                           with frame yn181.
                    hide frame yn181 no-pause.
                  end.
                  undo price-entry, retry price-entry.
                end.
                else if scrtmp_sod_det.sod_type = "A" then do:
                  assign old-sod-type = "A"
                         old-prod-line = scrtmp_sod_det.sod_prodline
                         save-part = scrtmp_sod_det.sod_part
                         list-pr = scrtmp_sod_det.sod_list_pr / scrtmp_sod_det.sod_um_conv
                         old-discount  = scrtmp_sod_det.sod_disc_pct
             ld_oldsur = decimal(scrtmp_sod_det.sod__chr04) . /* surcharge */
                  undo part-entry, retry part-entry.
                end.
              end.

              display scrtmp_sod_det.sod_um_conv scrtmp_sod_det.sod_type scrtmp_sod_det.sod_price with frame c.

              /* Even when price cannot be changed,  **
              ** show the message of price retrieval */
              if not (field-acc[08] and av-test = no)
              then readkey pause 1.
              /* CEPS-1582 ADD BEGINS */
              assign
                 lv_oldlpr = 0
                 lv_olddp  = 0
                 lv_oldpr  = 0
                 lv_oldlpr = scrtmp_sod_det.sod_list_pr
                 lv_olddp  = scrtmp_sod_det.sod_disc_pct
                 lv_oldpr  = scrtmp_sod_det.sod_price. 
              /* CEPS-1582 ADD ENDS */  
              update scrtmp_sod_det.sod_list_pr when (field-acc[08] and av-test = NO AND lLinePriceUpdateAllow# = YES)
                     scrtmp_sod_det.sod_disc_pct when (field-acc[09] and av-test = NO AND lLinePriceUpdateAllow# = YES)
                     go-on("END-ERROR") with frame c.

              if keyfunction(lastkey) = "END-ERROR" then do:
                put screen fill(" ",78) row 22 col 1.
                put screen fill(" ",78) row 23 col 1.
                if scrtmp_sod_det.sod_status = "" or scrtmp_sod_det.sod_status = "M" or
                  (scrtmp_sod_det.sod_qty_ord > scrtmp_sod_det.sod_qty_inv and scrtmp_sod_det.sod_qty_ord > scrtmp_sod_det.sod_qty_ship and
                   scrtmp_sod_det.sod_status = "C") then undo qty-entry, retry qty-entry.
                else DO:
                  ASSIGN lSuppressSaveLine# = TRUE.
                  return.
                END.
              end.

              if scrtmp_sod_det.sod_disc_pct <> 0 then
                   scrtmp_sod_det.sod_price = (scrtmp_sod_det.sod_list_pr * (100 - scrtmp_sod_det.sod_disc_pct)) / 100.
              else scrtmp_sod_det.sod_price = scrtmp_sod_det.sod_list_pr.

              if scrtmp_sod_det.sod_disc_pct > 100 then do:
                display "More than 100 % NOT allowed ..." skip(1)
                         with frame yn082 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn082.
                hide frame yn082 no-pause.
                undo, retry price-entry.
              end.
               
              update scrtmp_sod_det.sod_price when (field-acc[10] and av-test = NO AND lLinePriceUpdateAllow# = YES)
                     go-on("END-ERROR") with frame c.

              if keyfunction(lastkey) = "END-ERROR" then
                undo price-entry, retry price-entry.
              
              if scrtmp_sod_det.sod_list_pr = 0 then scrtmp_sod_det.sod_list_pr = scrtmp_sod_det.sod_price.
              if scrtmp_sod_det.sod_list_pr <> scrtmp_sod_det.sod_price and scrtmp_sod_det.sod_list_pr <> 0 
          and decimal(scrtmp_sod_det.sod__chr04) =  0  /* surcharge */
          then
                   scrtmp_sod_det.sod_disc_pct = (1 - (scrtmp_sod_det.sod_price / scrtmp_sod_det.sod_list_pr)) * 100.
              else scrtmp_sod_det.sod_disc_pct = 0.
          /* surcharge ADD BEGINS */
           find first ttapiprice where ttapiprice.ttdomain = global_domain 
                                and ttapiprice.ttcscode = scrtmp_so_mstr.so_cust 
                                and ttapiprice.ttpart = scrtmp_sod_det.sod_part                                
                                and ttapiprice.ttsurchargeperc > 0
                exclusive-lock no-error.
              if available ttapiprice
          then do:
             display "surcharge amt of " trim(string(ttapiprice.ttsurchargeperc)) "% will be added to the netprice" skip(1)
                with frame yn777 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR") with frame yn777.
                hide frame yn777 no-pause.
        
         /* scrtmp_sod_det.sod_price = scrtmp_sod_det.sod_price 
                                   + (scrtmp_sod_det.sod_list_pr * (ttapiprice.ttsurchargeperc / 100)). mulof*/
                 scrtmp_sod_det.sod_price = scrtmp_sod_det.sod_price 
                                   + (scrtmp_sod_det.sod_price * (ttapiprice.ttsurchargeperc / 100)). /* mulof */
          end. /* if available ttapiprice */
              /* surcharge ADD ENDS */
              /* RFC1952 ADD BEGINS */
          /* if reprice CEPS-1582 */
               
          if reprice 
             and (field-acc[08]
             and  field-acc[09]
             and  field-acc[10]) /* CEPS-1582 */ 
          then do:
            /* CEPS-1582 DELETE BEGINS 
            assign
           scrtmp_sod_det.sod__chr02 = "Manual"
           scrtmp_sod_det.sod__chr07 = ""
           scrtmp_sod_det.sod__chr04  = "" /* surcharge */
           scrtmp_sod_det.sod__chr06 = "" /* RFC-3012 */.
           ***CEPS-1582 DELETE ENDS */
              
           /* CEPS-1582 ADD BEGINS */
           if cError <> ""             
           then do:
              for first tt_prstat no-lock
                 where tt_prline = scrtmp_sod_det.sod_line
                   and tt_prpart = scrtmp_sod_det.sod_part:
              end. /* FOR FIRST tt_prstat */      
              if available tt_prstat 
                 and cError <> tt_prsta
              then
                 scrtmp_sod_det.sod__chr02  = tt_prsta.
           end. /* IF cError <> "" */
           if (scrtmp_sod_det.sod_list_pr      <> lv_oldlpr
               or scrtmp_sod_det.sod_disc_pct  <> lv_olddp
               or scrtmp_sod_det.sod_price     <> lv_oldpr)
           then
              assign
                 scrtmp_sod_det.sod__chr02  = "Manual"
                 scrtmp_sod_det.sod__chr07  = "0"
                 scrtmp_sod_det.sod__chr04  = "" 
                 scrtmp_sod_det.sod__chr06  = "" .
           /* CEPS-1582 ADD ENDS */
           
          end.
          /* CEPS-1582 ADD BEGINS */
          else if reprice
             and (field-acc[08] = no
             and  field-acc[09] = no
             and  field-acc[10] = no)
          then do:
             if cError       <> "" 
                and lv_oldpr <> 0   
             then do:
                for first tt_prstat no-lock
                   where tt_prline = scrtmp_sod_det.sod_line
                     and tt_prpart = scrtmp_sod_det.sod_part:
                end. /* FOR FIRST tt_prstat */      
                if available tt_prstat 
                   and cError <> tt_prsta
                then
                   scrtmp_sod_det.sod__chr02  = tt_prsta.
             end. /* IF cError <> "" */  
          end. /* ELSE IF reprice */
          /* CEPS-1582 ADD ENDS */
          /* RFC1952 ADD ENDS */
              display scrtmp_sod_det.sod_list_pr scrtmp_sod_det.sod_disc_pct scrtmp_sod_det.sod_price with frame c.

              put screen fill(" ",78) row 22 col 1.
              put screen fill(" ",78) row 23 col 1.

            end. /* if reprice */
/*            else display sod_std_cost with frame d.*/
          end. /* old-sod-type <> "A" */
          else do:
            assign scrtmp_sod_det.sod_list_pr = list-pr * scrtmp_sod_det.sod_um_conv
                   scrtmp_sod_det.sod_disc_pct = old-discount
           scrtmp_sod_det.sod__chr04  = string(ld_oldsur) /* surcharge */
                   old-sod-type = "".
            if scrtmp_sod_det.sod_disc_pct <> 0 then
                 scrtmp_sod_det.sod_price = (scrtmp_sod_det.sod_list_pr * (100 - scrtmp_sod_det.sod_disc_pct)) / 100.
            else scrtmp_sod_det.sod_price = scrtmp_sod_det.sod_list_pr.
        /* surcharge ADD BEGINS */
        if dec(scrtmp_sod_det.sod__chr04) > 0
        then
           scrtmp_sod_det.sod_price = scrtmp_sod_det.sod_price 
                                 +  (scrtmp_sod_det.sod_price * dec(scrtmp_sod_det.sod__chr04) / 100).   
             /* surcharge ADD ENDS */                     
            find in_mstr no-lock where in_domain = domain
                                   and in_site = scrtmp_sod_det.sod_site
                                   and in_part = scrtmp_sod_det.sod_part no-error.
            if avail in_mstr then
              find sct_det no-lock where sct_domain = domain
                                     and sct_sim = "Standard"         
                                     and sct_site = in_gl_cost_site
                                     and sct_part = scrtmp_sod_det.sod_part no-error.
            if not avail sct_det or not avail in_mstr then do:
              display "There is no Costprice record present for this Item."
                 skip "Please contact the Database Administrator ..." skip(1)
                             with frame yn085 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn085.
              hide frame yn085 no-pause.
              if new-line then delete scrtmp_sod_det.
              ASSIGN lSuppressSaveLine# = TRUE.
              return.
            end.
            scrtmp_sod_det.sod_std_cost = sct_cst_tot * scrtmp_sod_det.sod_um_conv.
            /*
            run "av/avsodsls.p" (domain,sod_nbr,sod_line).
            */
            /* run "zu/zusodsls.p" (domain,scrtmp_sod_det.sod_nbr,scrtmp_sod_det.sod_line). */
            run "zu/zusodsls.p" (INPUT BUFFER scrtmp_so_mstr:HANDLE, INPUT BUFFER scrtmp_sod_det:HANDLE). 
            
            acct-cc = scrtmp_sod_det.sod_acct.
            if scrtmp_sod_det.sod_cc <> "" THEN acct-cc = acct-cc + "-" + scrtmp_sod_det.sod_cc.

            if scrtmp_sod_det.sod_pricing_dt = ? then scrtmp_sod_det.sod_pricing_dt = today.

            display scrtmp_sod_det.sod_type scrtmp_sod_det.sod_list_pr scrtmp_sod_det.sod_disc_pct scrtmp_sod_det.sod_price with frame c.
            display /*sod_std_cost*/ scrtmp_sod_det.sod_pricing_dt acct-cc with frame d.
            
          end. /* old-sod-type was "A" */
          ASSIGN sodstat = ""
                 scrtmp_sod_det.sod_lot:LABEL in FRAME d = "Status"
                 
              .
          if scrtmp_sod_det.sod_status = "M" then sodstat = "M='To Warehouse'".
          else if scrtmp_sod_det.sod_status = "A" then sodstat = "A='Allocated'".
          else if scrtmp_sod_det.sod_status = "C" then sodstat = "C='Fully Shipped'".
          if scrtmp_sod_det.sod_loc = "CONSIGN" then do:
                 scrtmp_sod_det.sod_lot:LABEL in FRAME d = "Ref.".
                 
            display scrtmp_sod_det.sod_lot with frame d.
          end.
          else display sodstat @ scrtmp_sod_det.sod_lot with frame d.

          if abs(scrtmp_sod_det.sod_qty_ord) <> 1 and scrtmp_sod_det.sod_price <> 0 then
            display scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_price @ line-amt with frame d.
          else display "" @ line-amt with frame d.

          /* RFC 2142 ADD BEGINS*/
          if new-line 
          then 
            scrtmp_sod_det.sod_per_date = scrtmp_sod_det.sod_due_date.
          else 
            scrtmp_sod_det.sod_per_date = scrtmp_sod_det.sod_per_date.
          /* RFC2142 ADD ENDS */

/**RFC-2014**START OF REPLACEMENT***********************************************          
          if new-line
            and scrtmp_sod_det.sod_qty_all < scrtmp_sod_det.sod_qty_ord
            and can-find(pt_mstr where pt_dom = scrtmp_sod_det.sod_dom
                                   and pt_part = scrtmp_sod_det.sod_part
                                   and pt_part_type = "PAO")
          then do:

            /* Set the duedate to today + purchase leadtime */
            /* RFC324: duedate = today + timefence if not Chateaubriant*/
            find ptp_det where ptp_domain = wh-domain
                          and ptp_site = wh-site
                          and ptp_part = scrtmp_sod_det.sod_part
            no-lock no-error.
                /* 2453 ADD BEGINS */
            run due-date(input wh-domain,
                         input scrtmp_sod_det.sod_part,
                         input scrtmp_sod_det.sod_qty_ord,
                         input qty-avl,
                         output l_duedt).
            if l_duedt <> ?
            then 
               scrtmp_sod_det.sod_due_date = l_duedt .
            else do:
               /* 2453 ADD ENDS */
               if can-find(xxpt_mstr where xxpt_part = scrtmp_sod_det.sod_part
                                    and xxpt_char[2] = "PAB1") 
               then
                  assign scrtmp_sod_det.sod_due_date = today + ptp_det.ptp_pur_lead
                                         when avail ptp_det.
                else
                   assign scrtmp_sod_det.sod_due_date = today + ptp_det.ptp_timefnce
                                            when avail ptp_det.
            end. /* else do */
                 
            if avail ptp_det and ptp_pm_code = "D"
            then do:
               find si_mstr where si_domain = si_db
                              and si_site = substr(ptp_network,3,3)
                              and si_type = yes
               no-lock no-error.
               find ptp_det where ptp_domain = si_domain
                              and ptp_site = si_site
                              and ptp_part = scrtmp_sod_det.sod_part
               no-lock no-error.  
               /* 2453 ADD BEGINS */
               for each in_mstr
                  where in_dom = wh-domain
                    and in_part = scrtmp_sod_det.sod_part
                    and in_site = si_site
               no-lock:
                  qty-avl = qty-avl + (in_qty_oh - in_qty_req).
               end.
               if qty-avl < (scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv)
               then do:
                  run due-date(input wh-domain,
                               input scrtmp_sod_det.sod_part,
                               input scrtmp_sod_det.sod_qty_ord,
                               input qty-avl,
                               output l_duedt2).                  
                  if l_duedt2 <> ?
                          THEN DO:
                     scrtmp_sod_det.sod_due_date = l_duedt2 + 14. 
                  END.
                  ELSE DO:
                    IF AVAIL ptp_det
                    THEN DO:
                      ASSIGN  scrtmp_sod_det.sod_due_date = today + ptp_det.ptp_timefnce + 14 when avail ptp_det.
                    END.
                  END.
                  if can-find(xxpt_mstr where xxpt_part = scrtmp_sod_det.sod_part
                                         and xxpt_char[2] = "PAB1") 
                  THEN DO:
                    assign scrtmp_sod_det.sod_due_date = today + ptp_det.ptp_pur_lead + 14 when avail ptp_det.
                  END.                    

                          
                end.
                /* 2453 ADD ENDS */
                else do:        
                        if can-find(xxpt_mstr where xxpt_part = scrtmp_sod_det.sod_part
                                          and xxpt_char[2] = "PAB1") 
                  THEN DO: 
                    assign scrtmp_sod_det.sod_due_date = today + ptp_det.ptp_pur_lead + 14 when avail ptp_det.
                  END.
                  ELSE DO: 
                    ASSIGN scrtmp_sod_det.sod_due_date = today  + 14.
                  END.
                  /* RFC2142 ADD BEGINS */
                  
                  assign
                     scrtmp_sod_det.sod_per_date = scrtmp_sod_det.sod_due_date
                     l_pao  = scrtmp_sod_det.sod_per_date.
                 /* RFC2142 ADD ENDS */

                     
                      /* 1407 DELETE BEGINS
                      else
                         assign scrtmp_sod_det.sod_due_date = today + ptp_det.ptp_timefnce + 14
                                           when avail ptp_det.
                      *1407 DELETE ENDS */
                end . /* else do: */ 
            end.
            display "Code in PAO possible due-date:" string(scrtmp_sod_det.sod_due_date)
                    skip(1) with frame yn086 side-labels overlay row 10 col 10.
             /* 1407 ADD BEGINS
              display "Code in PAO possible due-date:" string(scrtmp_sod_det.sod_due_date) skip
                      "which will be today(" string(today)") + Time-fence("string(ptp_det.ptp_timefnce) ")"
                    skip(1) with frame yn086 side-labels  overlay row 10 col 10. */
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn086.
              hide frame yn086 no-pause.
            /* end. *1407 */
          end.
          /* END of RFC 209 */
**RFC-2014**WITH***************************************************************/
          if new-line
            and scrtmp_sod_det.sod_qty_all < scrtmp_sod_det.sod_qty_ord
            and (can-find(pt_mstr where pt_dom = scrtmp_sod_det.sod_dom
                                   and pt_part = scrtmp_sod_det.sod_part
                                   and pt_part_type = "PAO")
            or can-find(xxpt_mstr where xxpt_part  = scrtmp_sod_det.sod_part
                                 and (xxpt_char[2] = "PAB1" 
                                 or   xxpt_char[2] = "PAB2")))
          then do:
             run pao-due-date(input wh-domain,
                              input wh-site,
                              input scrtmp_sod_det.sod_part,
                              input scrtmp_sod_det.sod_qty_ord,
                              input scrtmp_sod_det.sod_um_conv,
                              input qty-avl,
                              output l_duedt). 
             if l_duedt <> ?
             then 
               scrtmp_sod_det.sod_due_date = l_duedt .
             assign
                          scrtmp_sod_det.sod_per_date = scrtmp_sod_det.sod_due_date
                l_pao                       = scrtmp_sod_det.sod_per_date. 

             if can-find(pt_mstr where pt_dom = scrtmp_sod_det.sod_dom
                                   and pt_part = scrtmp_sod_det.sod_part
                                   and pt_part_type = "PAO")
             then do:
               display "Code in PAO possible due-date:" 
                        string(scrtmp_sod_det.sod_due_date)
                    skip(1) with frame yn086 side-labels overlay row 10 col 10.
                 update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn086.
                 hide frame yn086 no-pause.
             end. /*if can-find*/
          end. /*if new-line*/
/**RFC-2014 END OF REPLACEMENT ************************************************/
/* CHN00417 START OF ADDITION *************************************************/
          if new-line or (old-qty-all / scrtmp_sod_det.sod_um_conv <> scrtmp_sod_det.sod_qty_ord) then do:
               /*Block Allocation flag check*/
               if  l-all = yes then do:
                  
                  if new-line then 
                     scrtmp_sod_det.sod_qty_all = 0.
                  else 
                    scrtmp_sod_det.sod_qty_all = old-qty-all / scrtmp_sod_det.sod_um_conv. 
                    
                  display  "BLOCKED ALLOCATION: " skip                                              
                           "block allocation flag is set to yes," skip 
                           "so allocation quantity cannot be updated. " skip            
                           with frame yn0754 side-labels overlay row 12 col 6.                             
                       update yn blank label "Press Enter" go-on("END-ERROR")
                        with frame yn0754.
                        hide frame yn0754 no-pause. 
                        
               end. /*l-all = yes*/
          end. /*if new-line*/
/* CHN00417 END OF ADDITION ***************************************************/
          frame-d-entry:
          do on error undo, retry with frame d:

            assign global_domain = domain
                   global_site = scrtmp_sod_det.sod_site
                   global_loc = scrtmp_sod_det.sod_loc
                   global_part = scrtmp_sod_det.sod_part.

            if scrtmp_sod_det.sod_qty_ord > scrtmp_sod_det.sod_qty_inv /*+ dec(scrtmp_sod_det.sod_qty_invcd)*/
            then av-test = yes.
            else av-test = no.
            
/*PMO2057 START OF ADDITION ***************************************************/
            /*CHN00417 DELETE BEGINS*****************************************
            if new-line or (old-qty-all / scrtmp_sod_det.sod_um_conv <> scrtmp_sod_det.sod_qty_ord) then do:
               find first pt_mstr no-lock where pt_domain = wh-domain
                                            and pt_part   = scrtmp_sod_det.sod_part no-error.
               find first si_mstr no-lock where si_domain = wh-domain
                                            and si_site   = wh-site 
                                            and si_type   = yes      no-error.
               find first pti_det no-lock where pti_det.oid_pt_mstr = pt_mstr.oid_pt_mstr
                                            and pti_det.oid_si_mstr = si_mstr.oid_si_mstr 
                                            and pti_det.pti_userl01 = yes no-error.
               if available pti_det then do:
                  if new-line then do:
                     scrtmp_sod_det.sod_qty_all = 0.
                     display  "BLOCKED ALLOCATION: " skip                                              
                        "block allocation flag is set to yes, so allocation quantity is set to 0. " skip            
                     with frame yn0753 side-labels overlay row 12 col 6.                             
                     update yn blank label "Press Enter" go-on("END-ERROR")
                        with frame yn0753.
                        hide frame yn0753 no-pause.
                  end.
                  else 
                    scrtmp_sod_det.sod_qty_all = old-qty-all / scrtmp_sod_det.sod_um_conv. 
               end. /*if available pti_det*/
            end. /*if new-line*/
            *******CHN00417 DELETE ENDS***************************************/
            
            l-3pl = no.
            /* OT-153 START DELETION
            run "xx/xx3plchk.p" (wh-site,output l-3pl).
            
            if emt-maint = no then l-3pl = no. /*PMO2068N-HP*/
            OT-153 END DELETION */
            /* OT-153 START ADDITION */
            if not lvl_nonEMT3PL
            then do:
               run "xx/xx3plchk.p" (wh-site,output l-3pl).
               
               if emt-maint = no
               then
                  l-3pl = no.
            end.
            else 
               l-3pl = lvl_nonEMT3PL.
            /* OT-153 END ADDITION */
            
            if l-3pl = yes then do: 
               if new-line then
                  wh-loc = "FREE".
               else do:
                  for first bemtsod no-lock where bemtsod.sod_domain = "HQ"
                                             and bemtsod.sod_nbr    = scrtmp_sod_det.sod_nbr
                                             and bemtsod.sod_line   = scrtmp_sod_det.sod_line:
                  end.
                  if available bemtsod then 
                     wh-loc = bemtsod.sod_loc.
               end. /*else do:*/
            end. /*if l-3pl = yes */
/*PMO2057 END OF ADDITION******************************************************/            

            run "aw/awqtyavl.p" (yes,domain,emt-ordr,wh-domain,wh-site,
                                     scrtmp_sod_det.sod_site,scrtmp_sod_det.sod_part,scrtmp_sod_det.sod_um_conv,scrtmp_sod_det.sod_loc,
                                     scrtmp_so_mstr.so_site,scrtmp_so_mstr.so_ship,scrtmp_so_mstr.so__chr10,output qty-avl).
            /*if not new-line or domain = "HQ" then
                qty-avl = qty-avl + scrtmp_sod_det.sod_qty_all. PMO2057*/
/*PMO2057 START OF ADDITION**************************************************/
            run "xx/xxresqty.p" (input wh-site, 
                              input scrtmp_sod_det.sod_part,
                              input scrtmp_sod_det.sod_um_conv,
                              output res_qtyavl). 
            
            /* OT-153 START ADDITION */
            if lvl_nonEMT3PL
            then do:
             
               lvd_umConvValue = fn_getUMConv
                                  (input domain,
                                   input scrtmp_sod_det.sod_part,
                                   input scrtmp_sod_det.sod__qadc01).
             
               qty-avl = fn_getQtyRndByUMConv
                             (input qty-avl,
                              input lvd_umConvValue).
                           
               res_qtyavl = fn_getQtyRndByUMConv
                             (input res_qtyavl,
                              input lvd_umConvValue).
                           
            end.
            /* OT-153 END ADDITION */
            
            if not new-line or domain = "HQ" then do:
              if l-3pl then do:
                if wh-loc = "RESERVED" then 
                   res_qtyavl = res_qtyavl + scrtmp_sod_det.sod_qty_all.
                else
                   qty-avl = qty-avl + scrtmp_sod_det.sod_qty_all.
              end. /*if l-3pl*/
              else
                 qty-avl = qty-avl + scrtmp_sod_det.sod_qty_all.
            end. /*if not new-line*/
            
/*PMO2057 END OF ADDITION******************************************************/

            if scrtmp_sod_det.sod_status = "" then do:
              hide message no-pause.

              find first soc_ctrl no-lock where soc_domain = domain.
              if scrtmp_sod_det.sod_due_date > today + soc_all_days then scrtmp_sod_det.sod_qty_all = 0.

              lot-yn = yes.
              find pt_mstr no-lock where pt_domain = domain
                                     and pt_part = scrtmp_sod_det.sod_part no-error.
              if pt_lot_ser = "" then lot-yn = no.

              /*message "Available to Allocate: " +
                       string(qty-avl) + ".". PMO2057*/
/*PMO2057 START OF ADDITION*****************************************************/
              if l-3pl then
                 message "Available to Allocate: " 
                         + "Free Loc:" string(qty-avl)
                         + " Resv Loc:" string(res_qtyavl) + ".".
              else
              message "Available to Allocate: " +
                       string(qty-avl) + ".".
/*PMO2057 END OF ADDITION*******************************************************/

              assign global_addr = wh-domain
                     global_site = wh-site
                     global_loc = scrtmp_sod_det.sod_loc
                     global_part = scrtmp_sod_det.sod_part
                     y-n = field-acc[22].
/*RFC-2295 START OF ADDITION *************************************************/
              if new-line then 
                if scrtmp_so_mstr.so__chr10 = ""  then 
                   scrtmp_sod_det.sod__chr10  = "" . 
              find pt_mstr no-lock where pt_domain = "HQ"
                                     and pt_part   = scrtmp_sod_det.sod_part 
              no-error.
              if available pt_mstr and
                 pt__log02 
                 then  
                    assign  
                       scrtmp_sod_det.sod__chr10 = "HARDWAR" .
/*RFC-2295 END OF ADDITION ***************************************************/ 
              if can-do("INVOICE,CENTRAL",scrtmp_so_mstr.so__chr10) or scrtmp_sod_det.sod_qty_inv <> 0 or
                (can-do("HARDWAR,DISCOUN",scrtmp_so_mstr.so__chr10) and scrtmp_so_mstr.so_domain = "ES")
                then y-n = no.

              update scrtmp_sod_det.sod_desc when (not avail pt_mstr)
                     scrtmp_sod_det.sod_loc when (av-test)
                     scrtmp_sod_det.sod_serial when (av-test and lot-yn = yes)
                     /*scrtmp_sod_det.sod_qty_all when (av-test) CHN00417*/
                     scrtmp_sod_det.sod_qty_all when (av-test and l-all = no) /*CHN00417*/
                     scrtmp_sod_det.sod__chr10 when y-n
                     scrtmp_sod_det.sod_tax_usage when field-acc[19]
                     scrtmp_sod_det.sod_pricing_dt when (new-order or new-line)
                     scrtmp_sod_det.sod_req_date
                     /* scrtmp_sod_det.sod_per_date RFC2142 */
                     scrtmp_sod_det.sod_due_date
                     scrtmp_sod_det.sod_taxc when field-acc[18]
                     scrtmp_sod_det.sod_consume when field-acc[07]
                     sod-cmmts 
                     wh-loc when (l-3pl and global_domain <> "HQ") /*PMO2057*/
                     with frame d editing:
                readkey.
                if keyfunction(lastkey) = "END-ERROR"
                then do:
                   /* OT-153 START ADDITION */
                   if not new-line
                   then do:
                      scrtmp_sod_det.sod__qadc01 = lvc_oldSalesUM.
                      display scrtmp_sod_det.sod__qadc01
                              with frame d.
                   end.
                   /* OT-153 END ADDITION */
                   /* RFC2142 ADD BEGINS */
                   if old-qty-ord <> 0
                   then  
                      scrtmp_sod_det.sod_qty_ord = truncate(old-qty-ord / scrtmp_sod_det.sod_um_conv,0).
                   else if old-qty-ord = 0
                   then 
                       scrtmp_sod_det.sod_qty_ord =  0 .
                end. /* if keyfunction(lastkey) = "END-ERROR" */         
                /* RFC2142 ADD ENDS */
                apply lastkey.

              end. /* editing */
/*RFC-2495 START OF ADDITION**************************************************/
          if scrtmp_sod_det.sod__chr10 <> "" and y-n
          then  do:
             find first Project where ProjectCode = scrtmp_sod_det.sod__chr10
               no-lock no-error.
             if not available Project 
             then do:
                {pxmsg.i &msgnum = 8674 &errorlevel = 3}
                undo,retry.
             end.
             else do:
                find first ProjectStatus no-lock 
                  where ProjectStatus.ProjectStatus_ID = Project.ProjectStatus_ID 
                    and ProjectStatusCode              = "Closed" no-error.
                if available ProjectStatus 
                then do:
                  {pxmsg.i &msgnum = 8674 &errorlevel = 3}
                   undo,retry.
                end.  /*if available ProjectStatus */
             end. /*else do:*/ 
          end. /*if scrtmp_sod_det.sod__chr10 <> "" */  
/*RFC-2495 END OF ADDITION ***************************************************/
              /*CHN00826 ADD START*/
		      If lookup(scrtmp_sod_det.sod__chr10,lvc_prjcodes) > 0
		         and scrtmp_sod_det.sod_consume <> no
		      then 
		         scrtmp_sod_det.sod_consume = No.  	   
              /*CHN00826 ADD END*/
              if new-line and scrtmp_sod_det.sod_per_date <> scrtmp_sod_det.sod_due_date 
              then
                 scrtmp_sod_det.sod_per_date =  scrtmp_sod_det.sod_due_date . /* RFC2142 */          
              assign global_domain = domain
                     global_site = scrtmp_sod_det.sod_site
                     global_loc = scrtmp_sod_det.sod_loc
                     global_part = scrtmp_sod_det.sod_part.

              if can-do("110,200,300,400,500,700,710",scrtmp_so_mstr.so_site) and
                scrtmp_so_mstr.so__chr10 <> "" then do:
                find code_mstr no-lock where code_mstr.code_domain = domain
                                         and code_mstr.code_fldname = "so__chr10"
                                         and code_mstr.code_value = scrtmp_sod_det.sod__chr10 no-error.
                if not avail code_mstr or scrtmp_sod_det.sod__chr10 = "" then do:
                  display "Invalid Project Code" skip(1)
                          with frame yn087 side-labels overlay row 10 col 10.
                  update yn blank label "Press Enter" go-on("END-ERROR")
                         with frame yn087.
                  hide frame yn087 no-pause.
                  next-prompt scrtmp_sod_det.sod__chr10 with frame d.
                  undo, retry frame-d-entry.
                end.
              end.

              if scrtmp_sod_det.sod_type = "" and av-test = yes then do:
                find loc_mstr no-lock where loc_domain = scrtmp_sod_det.sod_domain
                                        and loc_site = scrtmp_sod_det.sod_site
                                        and loc_loc = scrtmp_sod_det.sod_loc no-error.
                if scrtmp_sod_det.sod_loc = "" or not avail loc_mstr then do:
                  display "The entered Location does NOT exist !!!" skip(1)
                        with frame yn088 side-labels overlay row 10 col 10.
                  update yn blank label "Press Enter" go-on("END-ERROR")
                         with frame yn088.
                  hide frame yn088 no-pause.
                  next-prompt scrtmp_sod_det.sod_loc with frame d.
                  undo frame-d-entry, retry frame-d-entry.
                end.
              end.

              find code_mstr no-lock where code_mstr.code_domain = domain
                                       and code_mstr.code_fldname = "so__chr10"
                                       and code_mstr.code_value = scrtmp_sod_det.sod__chr10 no-error.
              if not avail code_mstr then do:
                display "Invalid Project-Code Entered !!!" skip(1)
                        with frame yn089 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn089.
                hide frame yn089 no-pause.
                next-prompt scrtmp_sod_det.sod__chr10 with frame d.
                undo frame-d-entry, retry frame-d-entry.
              end.

              /* Set price to 0 when project is DISCOUN or HARDWAR */
              /* RFC-2577if can-do("DISCOUN,HARDWAR,BACKORD,MEDIREP,MEDINEW",scrtmp_sod_det.sod__chr10)
              then do: */
              if can-do("DISCOUN,BACKORD,MEDIREP,MEDINEW",scrtmp_sod_det.sod__chr10)
              then do:              /*RFC-2577*/
                assign scrtmp_sod_det.sod_list_pr  = 0
                       scrtmp_sod_det.sod_price    = 0
                       scrtmp_sod_det.sod_disc_pct = 0
               scrtmp_sod_det.sod__chr04 = "" .
                /*RFC-3012 ADD BEGINS*/
          display scrtmp_sod_det.sod__chr06  label "Unit Price" skip(1) 
                  with frame yn676 side-labels overlay row 6 col 40. 
          update yn blank label "Press Enter" go-on("END-ERROR")
                         with frame yn676.
               hide frame yn676 no-pause.
           /*RFC-3012 ADD BEGINS*/
                display scrtmp_sod_det.sod_list_pr scrtmp_sod_det.sod_price scrtmp_sod_det.sod_disc_pct with frame c.
                display "Due to the project code the price is changed to 0 !!!"
                        with frame yn090 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn090.
                hide frame yn090 no-pause.
              end.

              if scrtmp_sod_det.sod__chr10 = "INVOICE" and
                 scrtmp_sod_det.sod_qty_ord > scrtmp_sod_det.sod_qty_inv then do:
                global_lot = scrtmp_sod_det.sod_serial.

                update scrtmp_sod_det.sod_lot with frame d.
                if scrtmp_sod_det.sod_lot <> "" then scrtmp_sod_det.sod_lot:LABEL in FRAME d = "Ref.".
                else scrtmp_sod_det.sod_lot:LABEL in FRAME d = "Status".
              end.

              if av-test = yes and scrtmp_sod_det.sod_serial <> "" then do:
                if l-3pl then lv_loc = wh-loc. /*PMO2057*/
                else 
                   lv_loc = scrtmp_sod_det.sod_loc. /*PMO2057*/
                   
                find ld_det no-lock where ld_domain = wh-domain
                                      and ld_site = wh-site
                                      and ld_part = scrtmp_sod_det.sod_part
                                      /*and ld_loc = scrtmp_sod_det.sod_loc PMO2057*/
                                      and ld_loc = lv_loc /*PMO2057*/
                                      and ld_lot = scrtmp_sod_det.sod_serial
                                      and ld_ref = scrtmp_sod_det.sod_lot no-error.
                if avail ld_det then do:
                  find isd_det no-lock where isd_domain = wh-domain
                                         and isd_status = ld_status
                                         and isd_tr_type = "ISS-SO" no-error.
                  if not avail isd_det then
                    find isd_det no-lock where isd_domain = wh-domain
                                           and isd_status = ld_status
                                           and isd_tr_type = "ORD-SO" no-error.
                  if avail isd_det then do:
                   display "Restricted Inventory-Status on the selected Batch,"
                     + " '" + ld_status + "' !!!" format "X(60)" skip(1)
                        with frame yn091 side-labels overlay row 10 col 10.
                    update yn blank label "Press Enter" go-on("END-ERROR")
                           with frame yn091.
                    hide frame yn091 no-pause.
                    undo frame-d-entry, retry frame-d-entry.
                  end.
                  else do:
                    qty-all = 0.
                    for each lad_det no-lock where lad_domain = wh-domain
                                               and lad_dataset <> ""
                                               and lad_site = ld_det.ld_site
                                               and lad_part = ld_det.ld_part
                                               and lad_loc = ld_det.ld_loc
                                               and lad_lot = ld_det.ld_lot
                                               and lad_ref = ld_det.ld_ref:
                      qty-all = qty-all + lad_qty_all + lad_qty_pick.
                    end.
                    if ld_qty_oh - qty-all + old-qty-all -
                                      (scrtmp_sod_det.sod_qty_all * scrtmp_sod_det.sod_um_conv) < 0 then do:
                      display "There is NOT enough allocatable stock"
                              "left for the selected Batch-number !!" skip(1)
                        with frame yn092 side-labels overlay row 10 col 10.
                      update yn blank label "Press Enter" go-on("END-ERROR")
                             with frame yn092.
                      hide frame yn092 no-pause.
                      undo frame-d-entry, retry frame-d-entry.
                    end.
                  end.
                end.
                else do:
                  display "The selected Batch-number is NOT available"
                          "anymore, please re-enter !!!" skip(1)
                           with frame yn093 side-labels overlay row 10 col 10.
                  update yn blank label "Press Enter" go-on("END-ERROR")
                         with frame yn093.
                  hide frame yn093 no-pause.
                  undo frame-d-entry, retry frame-d-entry.
                end.
               end.
            end. /* scrtmp_sod_det.sod_status = "" */

            else update sod-cmmts scrtmp_sod_det.sod__chr10 when (field-acc[22] and
                                      scrtmp_sod_det.sod__chr10 <> "INVOICE" and
                                      scrtmp_so_mstr.so__chr10 <> "CENTRAL" and
                                      scrtmp_sod_det.sod_qty_ord > scrtmp_sod_det.sod_qty_inv) with frame d.

                                      
            find code_mstr no-lock where code_domain = domain
                                     and code_fldname = "so__chr10"
                                     and code_value = scrtmp_sod_det.sod__chr10 no-error.
            if not avail code_mstr then do:
              display "Invalid Project-Code Entered !!!" skip(1)
                       with frame yn094 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn094.
              hide frame yn094 no-pause.
              next-prompt scrtmp_sod_det.sod__chr10 with frame d.
              undo frame-d-entry, retry frame-d-entry.
            end.
            /* 63681: Set price to 0 when project is DISCOUN or HARDWAR */
            /*RFC-2577 if can-do("DISCOUN,HARDWAR",scrtmp_sod_det.sod__chr10) then do:*/
            if can-do("DISCOUN",scrtmp_sod_det.sod__chr10) then do:    /*RFC-2577*/
              assign scrtmp_sod_det.sod_list_pr  = 0
                     scrtmp_sod_det.sod_price    = 0
                     scrtmp_sod_det.sod_disc_pct = 0.
              disp scrtmp_sod_det.sod_list_pr scrtmp_sod_det.sod_price scrtmp_sod_det.sod_disc_pct with frame c.
              display "Due to the project code the price is changed to 0!"
                    skip(1) with frame yn095 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn095.
              hide frame yn095 no-pause.
            end.
            if keyfunction(lastkey) = "END-ERROR" then do:
              if reprice then undo price-entry, retry price-entry.
              else undo qty-entry, retry qty-entry.
            end.

            if scrtmp_sod_det.sod_qty_all = ? then scrtmp_sod_det.sod_qty_all = 0.
            if scrtmp_sod_det.sod_due_date entered or scrtmp_sod_det.sod_req_date entered or
               scrtmp_sod_det.sod_per_date entered or scrtmp_sod_det.sod_pricing_dt entered then do:
           
              RUN SetSodDue (domain,scrtmp_so_mstr.so_nbr,0,wh-site,wh-domain,
                                      show-mess,output next-due, INPUT-OUTPUT dumd1#, INPUT-OUTPUT dumd2#).
            END.
            IF TRUE
            THEN DO:
              IF scrtmp_sod_det.sod_due_date < next-due AND
                (NEW-LINE OR CAN-FIND(FIRST sod_det WHERE sod_det.sod_domain = scrtmp_sod_det.sod_domain
                                                      AND sod_det.sod_nbr = scrtmp_sod_det.sod_nbr
                                                      AND sod_det.sod_line = scrtmp_sod_det.sod_line
                                                      AND sod_det.sod_due_date <> scrtmp_sod_det.sod_due_date) )
             then do:
                IF scrtmp_sod_det.sod_due_date < today AND
                  (NEW-LINE OR CAN-FIND(FIRST sod_det WHERE sod_det.sod_domain = scrtmp_sod_det.sod_domain
                                                        AND sod_det.sod_nbr = scrtmp_sod_det.sod_nbr
                                                        AND sod_det.sod_line = scrtmp_sod_det.sod_line
                                                        AND sod_det.sod_due_date <> scrtmp_sod_det.sod_due_date)  )                 
                then do:
                  display "Due-date may not be smaller then today !!!" skip(1)
                           with frame yn096 side-labels overlay row 10 col 10.
                  update yn blank label "Press Enter" go-on("END-ERROR")
                         with frame yn096.
                  hide frame yn096 no-pause.
                  next-prompt scrtmp_sod_det.sod_due_date with frame d.
                  undo frame-d-entry, retry frame-d-entry.
                end.
                else do:
                  display "Due-date should not be smaller than" next-due "!!!"    SKIP(1)
                          "Still continue?"
                           with frame yn097 side-labels overlay row 10 col 10.
                  update ynlog label "Yes or No"  go-on("END-ERROR")
                         with frame yn097.
                  hide frame yn097 no-pause.
                  IF ynlog <> YES THEN DO:
                     next-prompt scrtmp_sod_det.sod_due_date with frame d.
                     undo frame-d-entry, retry frame-d-entry.
                  END.
                end.
              end.
              else IF scrtmp_sod_det.sod_req_date < next-due AND
                      (NEW-LINE OR CAN-FIND(FIRST sod_det WHERE sod_det.sod_domain = scrtmp_sod_det.sod_domain
                                                            AND sod_det.sod_nbr = scrtmp_sod_det.sod_nbr
                                                            AND sod_det.sod_line = scrtmp_sod_det.sod_line
                                                            AND sod_det.sod_req_date <> scrtmp_sod_det.sod_req_date) )                
                    then do:
                if scrtmp_sod_det.sod_req_date < today  AND
                   (NEW-LINE OR CAN-FIND(FIRST sod_det WHERE sod_det.sod_domain = scrtmp_sod_det.sod_domain
                                                         AND sod_det.sod_nbr = scrtmp_sod_det.sod_nbr
                                                         AND sod_det.sod_line = scrtmp_sod_det.sod_line
                                                         AND sod_det.sod_req_date <> scrtmp_sod_det.sod_req_date) )
                then do:
                  display "Required-date may not be smaller than today !!!"
                           skip(1)
                           with frame yn098 side-labels overlay row 10 col 10.
                  update yn blank label "Press Enter" go-on("END-ERROR")
                         with frame yn098.
                  hide frame yn098 no-pause.
                  next-prompt scrtmp_sod_det.sod_req_date with frame d.
                  undo frame-d-entry, retry frame-d-entry.
                end.
                else do:
                  display "Required-date should not be smaller than " +
                           string(next-due) + " !!!" format "X(60)" skip(1)
                           with frame yn099 side-labels overlay row 10 col 10.
                  update yn blank label "Press Enter" go-on("END-ERROR")
                         with frame yn099.
                  hide frame yn099 no-pause.
                  next-prompt scrtmp_sod_det.sod_req_date with frame d.
                  undo frame-d-entry, retry frame-d-entry.
                end.
              end.
             else IF scrtmp_sod_det.sod_pricing_dt < today AND
                    (NEW-LINE OR CAN-FIND(FIRST sod_det WHERE sod_det.sod_domain = scrtmp_sod_det.sod_domain
                                                          AND sod_det.sod_nbr = scrtmp_sod_det.sod_nbr
                                                          AND sod_det.sod_line = scrtmp_sod_det.sod_line
                                                          AND sod_det.sod_pricing_dt <> scrtmp_sod_det.sod_pricing_dt) )
                then do:
                display "Pricing-date may not be smaller than today !!!"
                         skip(1)
                         with frame yn100 side-labels overlay row 10 col 10.
                update yn blank label "Press Enter" go-on("END-ERROR")
                       with frame yn100.
                hide frame yn100 no-pause.
                next-prompt scrtmp_sod_det.sod_pricing_dt with frame d.
                undo         frame-d-entry, retry frame-d-entry.
              end.
            end. /* if entered */

/* PMO2057 START OF ADDITION **************************************************/
              if l-3pl then do:
                 if wh-loc = "" or wh-loc = ? then wh-loc = "FREE". 

                 if (wh-loc = "FREE" or wh-loc <> "RESERVED") and (wh-loc = "RESERVED" or wh-loc <> "FREE") then do:
                          display "Entered WMS Location not allowed!!!" skip(1)
                              with frame yn103 side-labels overlay row 10 col 10.
                       update yn blank label "Press Enter" go-on("END-ERROR")
                              with frame yn103.
                        hide frame yn103 no-pause.
                        next-prompt wh-loc with frame d.
                        undo frame-d-entry, retry frame-d-entry.
                 end.

                 find first loc_mstr no-lock where loc_domain = wh-domain 
                                               and loc_site   = wh-site 
                                               and loc_loc    = wh-loc no-error.
                   if not available loc_mstr then do:
                       display "Entered WMS Location does NOT exist !!!" skip(1)
                           with frame yn104 side-labels overlay row 10 col 10.
                     update yn blank label "Press Enter" go-on("END-ERROR")
                            with frame yn104.
                     hide frame yn104 no-pause.
                     next-prompt wh-loc with frame d.
                     undo frame-d-entry, retry frame-d-entry.
                   end. 

                 find first is_mstr no-lock where is_domain = wh-domain
                                               and is_status = wh-loc 
                                               and is_avail  = yes no-error.
                 if not available is_mstr then do:
                       display "Inventory with entered WMS location cannot be allocated." skip(1)
                           with frame yn105 side-labels overlay row 10 col 10.
                     update yn blank label "Press Enter" go-on("END-ERROR")
                            with frame yn105.
                     hide frame yn105 no-pause.
                     next-prompt wh-loc with frame d.
                     undo frame-d-entry, retry frame-d-entry.
                 end.

                 if wh-loc = "RESERVED" and scrtmp_sod_det.sod_qty_all <> 0 then do:
                    run "xx/xxresqty.p" (input wh-site, 
                              input scrtmp_sod_det.sod_part,
                              input scrtmp_sod_det.sod_um_conv,
                              output res_qtyavl).                    

                    /* OT-153 START ADDITION */
                    if lvl_nonEMT3PL
                    then do:
                       lvd_umConvValue = fn_getUMConv
                                          (input domain,
                                           input scrtmp_sod_det.sod_part,
                                           input scrtmp_sod_det.sod__qadc01).
                                           
                       res_qtyavl = fn_getQtyRndByUMConv
                                       (input res_qtyavl,
                                        input lvd_umConvValue).
                    end.
                    /* OT-153 END ADDITION */
                    
                    if scrtmp_sod_det.sod_qty_all > res_qtyavl then do:
                          display "There is NOT enough allocatable stock on selected WMS location!!!" skip(1)
                              with frame yn107 side-labels overlay row 10 col 10.
                        update yn blank label "Press Enter" go-on("END-ERROR")
                              with frame yn107.
                        hide frame yn107 no-pause.
                        undo frame-d-entry, retry frame-d-entry.
                    end.
                 end. /*if wh-loc = "RESERVED"*/

                 for each code_mstr exclusive-lock where code_domain  = wh-domain
                                                     and code_fldname = "3plemtloc" :
                    delete code_mstr.
                 end.

                 create code_mstr.
                 assign code_domain  = wh-domain
                        code_fldname = "3plemtloc"
                        code_value   = scrtmp_sod_det.sod_nbr
                        code_cmmt    = string(scrtmp_sod_det.sod_line)
                        code_desc    = wh-loc.

                 release code_mstr. /*INC99965*/
              end. /*if l-3pl*/
/* PMO2057 END OF ADDITION ****************************************************/    
/************** INC56658 START OF ADDITION ************************************/
            if new-line and l_split then scrtmp_sod_det.sod_qty_all = 0.
/************** INC56658 END OF ADDITION ************************************/
            /* RFC2142 ADD BEGINS */  
            
          if new-line 
          then 
             scrtmp_sod_det.sod_per_date = scrtmp_sod_det.sod_due_date.
          else if l_pao <> ?
          then
             scrtmp_sod_det.sod_per_date = l_pao.
          else
             scrtmp_sod_det.sod_per_date = l_oldper.  

          assign                                                                                            
             l_nqoqty = 0                                                                                   
             l_qutflg  = no                                                                                
             l_quota = 0                                                                                   
             l_duequo = ?                                                                                  
             l_blckquchk = no                                                                              
             l_due_date = ? 
             l_oldblqty = 0
             l_nblck = no
             l_cmpflg = no
             l_nqline = no.
          release xxqt_det.                                                                                 
                         
          if not new-line                                                                                    
          then                                                                                               
             l_nqoqty = old-qty-ord.                                                                        
          else                                                                                               
             l_nqoqty = 0.                                                                                  
          for first xxblck_det no-lock                                                               
             where xxblck_domain = scrtmp_sod_det.sod_domain                                             
               and xxblck_ord    = scrtmp_sod_det.sod_nbr                                                
               and xxblck_line   = scrtmp_sod_det.sod_line :                                              
          end.
          if available xxblck_det
          then do:
             if  xxblck_stat   = "Blocked"
             then       
                l_nqoqty = 0.
             else  if xxblck_stat = "Released"
             then
                l_oldblqty = xxblck_qty_ord * scrtmp_sod_Det.sod_um_conv. 

          end. /* if available xxblck_det */
          if  not available xxblck_det
          then
             l_nblck = yes.

          
         
          if  not can-do("INVOICE,SAMPLES,CENTRAL",scrtmp_so_mstr.so__chr10)                                 
             and  index(dtitle,"99.7.1.4") = 0  
             and  lv_emt = no /*SCQ-1369*/
          then do:                                                                                           
             run quotaprevblock(input scrtmp_sod_det.sod_domain,                                            
                                  input scrtmp_sod_det.sod_nbr,                                               
                                         input scrtmp_sod_det.sod_line,                                              
                                         output l_blckquchk,                                                         
                                         output l_qutblcqty).                                                        
             if  l_qutblcqty <> 0                                                                           
             then                                                                                           
                l_qutblcqty =  l_qutblcqty * scrtmp_sod_Det.sod_um_conv.  
                

             if old-qty-ord  =  scrtmp_sod_det.sod_qty_ord  * scrtmp_sod_Det.sod_um_conv 
               and not new-line
             then do:
                for first sod_det no-lock 
                   where sod_det.sod_domain = scrtmp_sod_det.sod_domain 
                     and sod_det.sod_nbr    = scrtmp_sod_det.sod_nbr
                     and sod_det.sod_line   = scrtmp_sod_det.sod_line:
                end.
                if available sod_det 
                then 
                   buffer-compare scrtmp_sod_det to sod_det save l_compare.  
                if l_compare <> ""  and   l_oldblqty <> 0
                then
                   l_cmpflg = yes.
                
           
             end.  /* old-qty-ord  =  scrtmp_sod_det.sod_qty_ord  * scrtmp_sod_Det.sod_um_conv */

                                                                                                              
             /* RFC2364 ADD BEGINS */ 
             find ad_mstr no-lock 
                where ad_mstr.ad_domain = domain
                  and ad_mstr.ad_addr = scrtmp_so_mstr.so_cust 
             no-error.                       
             if available ad_mstr 
             then 
                lvc_ctry = ad_country.
             /* RFC2364 ADD BEGINS */ 

             run quotacheck in hquota(input  scrtmp_so_mstr.so_cust, 
                                      input  scrtmp_sod_det.sod_part, 
                                      input  lvc_ctry, /* RFC2364 */
                                      input  scrtmp_sod_det.sod_per_date,                                    
                                       output l_qutflg,                                                      
                                          output l_qutitm,                                                      
                                           output l_quota).                                                      
                                                                            
             if not l_qutflg  and l_qutitm                                                                  
             then do:                                                                                       
                display "Item is  already in quota for another customer" skip                               
                           "Please Re-Enter." skip(1)                                                         
                               with frame quo2 side-labels overlay row 10 col 10.                                 
                               update yn blank label "Enter" go-on("END-ERROR")                                   
                                with frame quo2.                                                                          
                                hide frame quo2 no-pause.                                                          
                  undo part-entry, retry part-entry.                                                          
                                                                                                              
             end. /* if not l_qutflg  and l_qutitm  */                                                                                          
                                                                                                              
             if (( abs((scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv) - l_nqoqty ) > l_quota     
                and (scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv) > l_nqoqty)                      
                and l_qutflg)                                                                                  
             then do:                                                                                       
                assign                                                                                      
                   l_quota = truncate(l_quota / scrtmp_sod_det.sod_um_conv,0)                               
                       l_bfqty  = truncate(l_nqoqty / scrtmp_sod_det.sod_um_conv,0)                             
                       l_nqoqty = truncate(l_nqoqty / scrtmp_sod_det.sod_um_conv,0).                            
                                                                                                                  
                if l_quota > 0 and l_quota > l_nqoqty                                                       
                then                                                                                        
                   scrtmp_sod_det.sod_qty_ord = l_quota.                                                    
                else if  l_quota < l_nqoqty and l_quota <> 0                                                
                then                                                                                        
                   scrtmp_sod_det.sod_qty_ord = l_nqoqty.                                                   
                else if l_quota >= 0 and  (l_nqoqty <> 0 )                                                  
                then                                                                                        
                   scrtmp_sod_det.sod_qty_ord = l_bfqty.                                                    
                else if l_quota <= 0                                                                        
                then                                                                                        
                   scrtmp_sod_det.sod_qty_ord = 0.                                                          
                                                                                                              
                if scrtmp_sod_det.sod_qty_all > 0                                                           
                then                                                                                        
                   scrtmp_sod_det.sod_qty_all =                                                             
                          max(0,min(scrtmp_sod_det.sod_qty_ord -                                              
                                  scrtmp_sod_det.sod_qty_ship,scrtmp_sod_det.sod_qty_all)).                       
                run "aw/awqtyavl.p" (yes,                                                                   
                                     domain,                                                                
                                          emt-ordr,                                                              
                                         wh-domain,                                                             
                                         wh-site,                                                               
                                     scrtmp_sod_det.sod_site,                                               
                                         scrtmp_sod_det.sod_part,                                               
                                         scrtmp_sod_det.sod_um_conv,                                            
                                         scrtmp_sod_det.sod_loc,                                                
                                     scrtmp_so_mstr.so_site,                                                
                                         scrtmp_so_mstr.so_ship,                                                
                                         scrtmp_so_mstr.so__chr10,                                              
                                         output l_qtyall).                                                      
                /* OT-153 START ADDITION */
                if lvl_nonEMT3PL
                then do:
             
                   lvd_umConvValue = fn_getUMConv
                                      (input domain,
                                       input scrtmp_sod_det.sod_part,
                                       input scrtmp_sod_det.sod__qadc01).
             
                   l_qtyall = fn_getQtyRndByUMConv
                                (input l_qtyall,
                                 input lvd_umConvValue).
                           
                end.
                /* OT-153 END ADDITION */
                l_qtyall = l_qtyall + scrtmp_sod_det.sod_qty_all.                                           
                                                                                                              
                if scrtmp_so_mstr.so__chr10 = "INVOICE"                                                     
                       and scrtmp_sod_det.sod_qty_ord > scrtmp_sod_det.sod_qty_inv                              
                then                                                                                        
                   assign                                                                                   
                          scrtmp_sod_det.sod_qty_all = max(0,scrtmp_sod_det.sod_qty_ord)                        
                      scrtmp_sod_det.sod_qty_pick = 0.                                                      
                else if scrtmp_so_mstr.so__chr10 <> "INVOICE" and                                           
                   (new-line or scrtmp_sod_det.sod_qty_ord <> scrtmp_sod_det.sod_qty_all)                 
                then                                                                                        
                   scrtmp_sod_det.sod_qty_all = max(0,min(scrtmp_sod_det.sod_qty_ord                        
                                                               - scrtmp_sod_det.sod_qty_ship,                      
                                                           l_qtyall)).                                        
                if scrtmp_sod_det.sod_qty_all = ?                                                           
                    then                                                                                        
                       scrtmp_sod_det.sod_qty_all = 0.                                                          
                if scrtmp_sod_det.sod_qty_ord > 0                                                           
                then do:                                                                                    
                   display "Order qty exceeds the Quota qty " skip                                          
                             "Please Re-Enter." skip(1)                                                       
                                 with frame quo1 side-labels overlay row 10 col 10.                               
                                 update yn blank label "Press Enter" go-on("END-ERROR")                           
                                  with frame quo1.                                                                  
                                  hide frame quo1 no-pause.                                                        
                                                                                                                  
                end. /* if scrtmp_sod_det.sod_qty_ord > 0 */                                                                                              
                else do:                                                                                    
                       if old-qty-ord <> 0                                                                      
                       then                                                                                     
                          scrtmp_sod_det.sod_qty_ord = truncate(old-qty-ord / scrtmp_sod_det.sod_um_conv,0).  
                                                                                                              
                       scrtmp_sod_det.sod_due_date =  old-due-date.                                          
                   display "Order qty exceeds the Quota qty,there is no further qtyorder allowed," skip     
                               "Please Re-Enter." skip(1)                                                       
                                with frame quo side-labels overlay row 10 col 10.                                
                                update yn blank label "Press Enter" go-on("END-ERROR")                           
                                with frame quo.                                                                    
                                hide frame quo no-pause.                                                         
                                                                                                                  
                end. /* else do:  */                                                                                              
                 undo qty-entry, retry qty-entry.                                                             
                                                                                                              
             end. /* if (abs(scrtmp_sod_det.sod_qty_ord */                                                     
             else if l_qutflg                                                                               
                and (scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv) <> l_nqoqty 
                 or ((scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv)   = l_nqoqty 
                and  l_cmpflg )
             then do:   
                create tt_quota.                                                                            
                assign                                                                                      
                   tt_domain  = scrtmp_sod_det.sod_domain                                                   
                   tt_nbr     = scrtmp_sod_det.sod_nbr                                                      
                   tt_line    = scrtmp_sod_det.sod_line                                                     
                   tt_part    = scrtmp_sod_det.sod_part                                                     
                   tt_cust    = scrtmp_so_mstr.so_cust 
                   tt_ctry    = lvc_ctry /* RFC2364 */
                   tt_site    = wh-site                                                                     
                   tt_ordt    = scrtmp_sod_det.sod_per_date                                                 
                       tt_old_qty    = l_nqoqty                                                                 
                       tt_actual_qty = (scrtmp_sod_det.sod_qty_ord                                              
                                              * scrtmp_sod_Det.sod_um_conv)                                       
                   tt_operation = "A"                                                                             
                       tt_olddt = scrtmp_sod_det.sod_per_date. 
                if l_cmpflg = yes
                then
                   tt_old_qty = 0.   
                
                                                                                                              
                                                                                                                  
                if l_nqoqty < tt_actual_qty                                                                 
                then do:                                                                                      
                   if (tt_actual_qty - l_nqoqty) >= 0                                                       
                       then                                                                                     
                      tt_ord_qty = tt_actual_qty - l_nqoqty.                                                
                   else                                                                                     
                          tt_ord_qty = 0.                                                                       
                end. /* if old-qty-ord < tt_actual_qty */                                                      
                else if l_nqoqty > tt_actual_qty                                                            
                then do:                                                                                    
                   if (l_nqoqty - tt_actual_qty) >= 0                                                       
                       then                                                                                     
                      tt_ord_qty = l_nqoqty - tt_actual_qty.                                                
                       else                                                                                     
                          tt_ord_qty = 0.                                                                       
                                                                                                              
                end. /* if old-qty-ord > tt_actual_qty */                                                   
             end. /* if l_qutflg */                                                                         
          end. /* if not can-do(samples */                                                                  
            /* at beginnning of line entry all block types are cleaned */                                     
    /*INC16800 DELETE BEGINS
    assign                                                                                            
             l_bl_list = "editblock".                                                                       
          do l_cnt = 1 to num-entries(l_bl_list) /* num-entries(l_blty) */:                                 
             for first xxblck_det exclusive-lock                                                            
                where xxblck_domain = scrtmp_sod_det.sod_domain                                             
                  and xxblck_ord    = scrtmp_sod_det.sod_nbr                                                
                  and xxblck_line   = scrtmp_sod_det.sod_line                                               
                  and xxblck_type   = entry(l_cnt,l_bl_list)                                                
             use-index xxblck_time:                                                                         
                delete xxblck_det. 
                release xxblck_det.
             end. /* for first xxblck_det */                                                             
          end.  /* l_cnt = 1 to num-entries(l_blty) */  
    **INC16800 DELETE ENDS*/      
        run seteditblock (buffer scrtmp_so_mstr,                                                          
                            buffer scrtmp_sod_det,                                                          
                            buffer pt_mstr,                                                                 
                              "Editblock").  
    /*INC16800 ADD BEGINS*/                          
      if old-qty-ord <> 0 and l_edblval = no
      then do: 
         for first xxblck_det no-lock 
            where xxblck_domain = scrtmp_sod_det.sod_domain                                             
                and   xxblck_ord    = scrtmp_sod_det.sod_nbr                                                
            and   xxblck_line   = scrtmp_sod_det.sod_line                                               
            and   xxblck_type   = "Editblock" 
            use-index xxblck_time :
         end.  /*for first xxblck_det no-lock 
                 where xxblck_domain = scrtmp_sod_det.sod_domain*/
        if available xxblck_det 
        then do:
           if xxblck_stat = "blocked" 
           then 
              scrtmp_sod_det.sod_qty_all = 0.     
        end.  /*if available xxblck_det then do*/
     end.  /*if  l_edblval = no*/                          
    /*INC16800 ADD ENDS*/                                                                                                              
         if l_edblval                                                                                   
         then do:                                                                                       
            assign                                                                                       
               l_qtblck = l_edblval                                                                      
               l_edblval = no                                                                           
                DesignGroup = ""
               scrtmp_sod_det.sod_qty_all = 0. /* 14642 */ 
               
            for first pt_mstr no-lock                                                                   
               where pt_domain = "HQ"                                                                   
                 and pt_part = scrtmp_sod_det.sod_part:                                                 
            end.                                                                                        
            display  "EDIT BLOCK FILTER " skip                                                          
                     "The order quantities are exceeding the planned, " skip                             
                     "inventory to be available for this site." skip                                     
                                                                                                              
            with frame yn0751 side-labels overlay row 12 col 6.                                         
            update yn blank label "Press Enter" go-on("END-ERROR")                                      
            with frame yn0751.                                                                          
            hide frame yn0751 no-pause.                                                                 
                                                                                                              
         end. /* if edblvl */                                                                            
                                                                                                              
         /* RFC2142 ADD ENDS */                                                                          
        if scrtmp_sod_det.sod_qty_all > 0 and
               scrtmp_sod_det.sod_qty_all > scrtmp_sod_det.sod_qty_ord - (scrtmp_sod_det.sod_qty_pick + scrtmp_sod_det.sod_qty_ship) and
               scrtmp_sod_det.sod_status = "" then do:
              display "You are not allowed to allocate more than needed !!!"
                       skip(1)
                       with frame yn101 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn101.
              hide frame yn101 no-pause.
              next-prompt scrtmp_sod_det.sod_qty_all with frame d.
              undo frame-d-entry, retry frame-d-entry.
            end.

            if wh-loc <> "RESERVED" then do: /*OT-22*/
            if scrtmp_sod_det.sod_qty_all > qty-avl and scrtmp_sod_det.sod_status = "" then do:
              display "You are not allowed to allocate more than available !!!"
                       skip(1)
                       with frame yn102 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn102.
              hide frame yn102 no-pause.
              next-prompt scrtmp_sod_det.sod_qty_all with frame d.
              undo frame-d-entry, retry frame-d-entry.
            end.
            end. /*OT-22*/
            
            /* OT-153 START ADDITION */
            if lvl_nonEMT3PL
              and not fn_isValidQtyAllocByUMConv
                                (domain,
                                 scrtmp_sod_det.sod_part,
                                 scrtmp_sod_det.sod__qadc01,
                                 scrtmp_sod_det.sod_qty_all,
                                 output lvd_umConvValue)
            then do:
               display "Qty allocated should be in multiples of "
                       + string(lvd_umConvValue) + " !!!" 
                       format "X(50)" skip(1)
                       with frame yn111 side-labels overlay row 10 col 10.
               update yn blank label "Press Enter" go-on("END-ERROR")
                      with frame yn111.
               hide frame yn111 no-pause.
               next-prompt scrtmp_sod_det.sod_qty_all with frame d.
               undo frame-d-entry, retry frame-d-entry.
            end.
            /* OT-153 END ADDITION */
          end. /* frame-d-entry */

          if scrtmp_sod_det.sod_per_date < scrtmp_sod_det.sod_due_date then do:
           if new-line 
           then /* RFC2142 */
              scrtmp_sod_det.sod_per_date = scrtmp_sod_det.sod_due_date.
            display scrtmp_sod_det.sod_per_date with frame d.
          end.

          if sod-cmmts = yes 
          THEN DO:
            global_ref = scrtmp_sod_det.sod_part.
            if scrtmp_sod_det.sod_cmtindx <> ? then cmtindx = scrtmp_sod_det.sod_cmtindx.
            else cmtindx = 0.
            
            run "gp/gpcmmt01.p" ('sod_det').
            
            LAST-EVENT:SET-LASTKEY(0, KEYCODE("F4")).
            
            if cmtindx = ? then cmtindx = 0.
            scrtmp_sod_det.sod_cmtindx = cmtindx.
            
            IF AVAIL cmt_det
            THEN release cmt_det.
            
          end. /* if sod-cmmts */
          
        end. /* price-entry */
      end. /* qty-entry */
    end. /* part-entry */
      /* RFC531 ADD BEGINS */
      /*INC16800 DELETE BEGINS       
      ASSIGN l_bl_list = "Restriction".
      do l_cnt = 1 to num-entries(l_bl_list) /* num-entries(l_blty) */:
        for first xxblck_det exclusive-lock
                    where xxblck_domain = scrtmp_sod_det.sod_domain
                      and xxblck_ord    = scrtmp_sod_det.sod_nbr
                      and xxblck_line   = scrtmp_sod_det.sod_line
                      and xxblck_type   = entry(l_cnt,l_bl_list)
                      use-index xxblck_time:
          delete xxblck_det.
        end. /* for first xxblck_det */
      end.  /* l_cnt = 1 to num-entries(l_blty) */
      **INC16800 DELETE ENDS */       
      
      if cust-restr
      then  do: /* 3375 */  
         l_qtblck = yes. /* RFC2142 */
         scrtmp_sod_det.sod_qty_all = 0 . /* 14642 */
         output to value(intf-dir + server-id + "/trace/blocks/" 
                     + string(year(today),"9999") +
                      string(month(today),"99") +
                      string(day(today),"99")) append.
                     put unformatted  "zusomain "    + " " + scrtmp_so_mstr.so_nbr +
                            " Date " today format "99/99/99"  
                            " Time " string(time,"HH:MM:SS") + " "
                            "Restriction"  + " " + string(cust-restr) + " " 
                            "Part"         + " " + scrtmp_sod_det.sod_part + " "
                            "Wh-domain"    + " " + wh-domain + " "
                            "wh-site"      + " " + wh-site + " "
                     skip.
                         
                    RUN SetEditBlock (BUFFER scrtmp_so_mstr,
                                BUFFER scrtmp_sod_det,
                                BUFFER pt_mstr,
                                "Restriction").
          output close.
      end. /* 3375 */
      
     /* RFC531 ADD ENDS */
    if send-mail then do:

      find ad_mstr no-lock where ad_mstr.ad_domain = scrtmp_so_mstr.so_domain
                             and ad_mstr.ad_addr = scrtmp_so_mstr.so_cust no-error.
      if available ad_mstr then lv_name = ad_mstr.ad_name.

      output to value(mfguser + ".txt").
      if intf-dir + server-id <> "/ext1/prod" then
        put unformatted "This is a TEST, please discard !!!..." + chr(10)
                                                                + chr(10).
      mailMsg = "Order "
                + scrtmp_so_mstr.so_nbr
                + ", "
                + scrtmp_so_mstr.so_cust
                + " "
                + lv_name
                + ", line "
                + string(scrtmp_sod_det.sod_line)
                + ", Due "
                + string(scrtmp_sod_det.sod_due_Date)
                + ", Item "
                + scrtmp_sod_det.sod_part
                + ", Qty Ordered "
                + string(scrtmp_sod_det.sod_qty_ord)
                + " " + string(scrtmp_sod_det.sod_um)
                + " PF "
                + " " + string(scrtmp_sod_det.sod_um_conv).


      put unformatted mailMsg.
      output close.

      DesignGroup = "".
      for first pt_mstr no-lock where pt_domain = "HQ"
                                  and pt_part = scrtmp_sod_det.sod_part,
          first usr_mstr where usr_userid = pt_dsgn_grp no-lock:
        DesignGroup = usr_name.
      end.

      find usr_mstr no-lock where usr_userid = global_userid.
      mail-from = usr_mail_address.
      
      if l_flg = yes
      then do: /* RFC531 */
        if server-id = "test"
        then
           mail-address = mail-address + "," + "psomanathan@medline.com". /* 8680 */
        unix silent value(intf-dir + "scripts/qad-send-mail.sh "
                         + mail-from + " " +
                         mail-address + " 'Restriction " +
                         DesignGroup + " " +
                         mailMsg + "' " + mfguser + ".txt no").
      end. /* RFC531 */
      unix silent value("rm -rf " + mfguser + ".txt"). 
    end. /* if send-mail */

  end. /* frame-c-entry */

  if scrtmp_sod_det.sod_price <> old-price then scrtmp_sod_det.sod_pricing_dt = today.
  if scrtmp_sod_det.sod_per_date = ? then scrtmp_sod_det.sod_per_date = scrtmp_sod_det.sod_due_date.
  if scrtmp_sod_det.sod_req_date = ? then scrtmp_sod_det.sod_req_date = scrtmp_sod_det.sod_due_date.
  /* WMSI-2066 START OF ADDITION **************************************************************************************/
  /*if scrtmp_sod_det.sod_site = "550" PMO0009B_HP*/
  /* OT-159 START DELETION
  if can-do("550,600",scrtmp_sod_det.sod_site)  /*PMO0009B_HP*/
  OT-159 END DELETION */
  /* OT-159 START ADDITION */
  for first code_mstr 
     where code_domain  = "XX" 
       and code_fldname = "Due-date-after-cut-off"
       and code_value   = "not-today+1" 
  no-lock:
     lvc_scale_sites = code_cmmt.
  end.
  if can-do(lvc_scale_sites,scrtmp_sod_det.sod_site) 
  /* OT-159 END ADDITION */
  then do:
    scrtmp_sod_det.sod_req_date = scrtmp_sod_det.sod_due_date + 1.
    if weekday(scrtmp_so_mstr.so_req_date) = 1 then scrtmp_so_mstr.so_req_date = scrtmp_so_mstr.so_req_date + 1.
    if weekday(scrtmp_so_mstr.so_req_date) = 7 then scrtmp_so_mstr.so_req_date = scrtmp_so_mstr.so_req_date + 2.

    find hd_mstr no-lock where hd_domain = wh-domain
                         and hd_site = wh-site
                         and hd_date = next-due no-error.
    do while available hd_mstr:
        scrtmp_so_mstr.so_req_date = scrtmp_so_mstr.so_req_date + 1.
        if weekday(scrtmp_so_mstr.so_req_date) = 1 then scrtmp_so_mstr.so_req_date = scrtmp_so_mstr.so_req_date + 1.
        if weekday(scrtmp_so_mstr.so_req_date) = 7 then scrtmp_so_mstr.so_req_date = scrtmp_so_mstr.so_req_date + 2.
        find hd_mstr no-lock where hd_domain = wh-domain
                                and hd_site = wh-site
                                and hd_date = scrtmp_so_mstr.so_req_date no-error.
    end. /*do while*/
  end. /*scrtmp_sod_det.sod_site = "550"*/
  /* WMSI-2066 END OF ADDITION *****************************************************************************************/

  if not new-line and scrtmp_sod_det.sod_status = "" then run un-alloc-det(domain).
  if scrtmp_sod_det.sod_qty_all > 0 and scrtmp_sod_det.sod_serial <> "" and scrtmp_sod_det.sod_status = "" then
    run detail-alloc(domain).

   if can-find(bemtsod where bemtsod.sod_domain = "HQ"
                                        and bemtsod.sod_nbr = scrtmp_sod_det.sod_nbr
                                        and bemtsod.sod_line = scrtmp_sod_det.sod_line)
  or new-line then do:
  
    RUN ClearLocks IN hProc# (INPUT THIS-PROCEDURE).
    
    RUN SaveDataToDSTT.

    IF wh-domain <> domain
    THEN DO: 
      lv_bc = no.
      run create_scrtmpdet(input-output lv_bc).
   
      run "zu/zusodwrp.p" (INPUT BUFFER scrtmp_so_mstr:handle, INPUT BUFFER scrtmp_sod_det:handle, domain,emt-ordr,wh-domain,wh-site,sonbr,scrtmp_sod_det.sod_line,
                            ?,old-ord-qty,old-qty-ord,old-qty-all,old-due-date, OUTPUT cErro#).
    END.                            
    ELSE ASSIGN cErro# = "".  
   
    RUN SaveDataFromDSTT.
    IF cErro# <> ""
    THEN MESSAGE cErro# .
    RUN SetSoLocks IN hProc# (INPUT domain, INPUT sonbr, INPUT THIS-PROCEDURE, OUTPUT cErro#).

  end.

  assign scrtmp_sod_det.sod_mod_userid = global_userid
         scrtmp_sod_det.sod_mod_date = today.
  ordr-line = ordr-line + 1.
  if ordr-line <  li_linenbr 
  then
     ordr-line = li_linenbr. /* RFC2556 */ 
  clear frame c no-pause.
  clear frame d no-pause.
  
end procedure. /* line-entry */
/************************************************************************/

procedure check-emt-sod:                                                         
  /* def buffer emtsod for scrtmp_sod_det. */
  def buffer emtsod FOR sod_det. /* MP: Deze WEL via DB laten lopen, --> check is alleen bij modify --> dan moet deze in DB bestaan (zit mogelijk niet in scrtmp_sod_det */
  find emtsod no-lock where emtsod.sod_domain = wh-domain
                        and emtsod.sod_nbr    = sonbr
                        and emtsod.sod_line   = ordr-line no-error.
  if not avail emtsod then do:
    emt-ordr = ?.
    display "This Order-line has already been fully processed in the Warehouse"
       skip "so, it will not be replicated to the Warehouse Domain anymore ..."
       skip(2) with frame yn1022 side-labels overlay row 10 col 10.
    update yn blank label "Press Enter" go-on("END-ERROR") with frame yn1022.
    hide frame yn1022 no-pause.
  end.
  else emt-ordr = yes.
end procedure. /* check-emt-sod */
/************************************************************************/
procedure create-sod:
  def input parameter domain as char.

  /*2388 comment begin - this call is moved down after create scrtmp_sod_det and
  called with the generated line-number input
  /* Determine the first possible duedate, as line can be added anyday */
  def var min-due as date no-undo.
  run SetSodDue (scrtmp_so_mstr.so_domain,scrtmp_so_mstr.so_nbr,0,wh-site,wh-domain,no,
                          output min-due, INPUT-OUTPUT dumd1#, INPUT-OUTPUT dumd2#).
  2388 end*/
  
  if scrtmp_so_mstr.so_domain <> domain THEN MESSAGE "create-sod alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.

  def buffer soddet for scrtmp_sod_det.
  
  create scrtmp_sod_det.
  assign scrtmp_sod_det.operation       = "A"
         scrtmp_sod_det.sod_domain      = domain
         scrtmp_sod_det.sod_nbr         = sonbr
         scrtmp_sod_det.sod_line        = ordr-line
         scrtmp_sod_det.sod_loc         = (if scrtmp_so_mstr.so__chr10 = "INVOICE" then "CONSIGN" else "AIMS")
         scrtmp_sod_det.sod_serial      = ""
         scrtmp_sod_det.sod_lot         = ""
         scrtmp_sod_det.sod_site        = scrtmp_so_mstr.so_site
         scrtmp_sod_det.sod_um_conv     = 1
         scrtmp_sod_det.sod_status      = ""
         scrtmp_sod_det.sod_confirm     = yes
         scrtmp_sod_det.sod_fix_pr      = scrtmp_so_mstr.so_fix_pr
         scrtmp_sod_det.sod_contr_id    = "" /* scrtmp_so_mstr.so_po */
         scrtmp_sod_det.sod_exp_del     = scrtmp_so_mstr.so_due_date
         /*2388 begin
         scrtmp_sod_det.sod_due_date = if new-order or scrtmp_so_mstr.so_due_date >= min-due
                        then scrtmp_so_mstr.so_due_date else min-due*/
         scrtmp_sod_det.sod_due_date    = scrtmp_so_mstr.so_due_date
         /*2388 end*/
         scrtmp_sod_det.sod_req_date    = scrtmp_so_mstr.so_req_date
         scrtmp_sod_det.sod_per_date    = prom-date
         scrtmp_sod_det.sod_list_pr     = 0
         scrtmp_sod_det.sod_price       = 0
         scrtmp_sod_det.sod_pricing_dt  = today
         scrtmp_sod_det.sod_tax_usage   = scrtmp_so_mstr.so_tax_usage
         scrtmp_sod_det.sod_tax_env     = scrtmp_so_mstr.so_tax_env
         scrtmp_sod_det.sod_taxc        = scrtmp_so_mstr.so_taxc
         scrtmp_sod_det.sod_taxable     = scrtmp_so_mstr.so_taxable /*yes*/
         scrtmp_sod_det.sod_tax_in      = tax-in
         scrtmp_sod_det.sod_consume     = consume
         scrtmp_sod_det.sod__chr10      = scrtmp_so_mstr.so__chr10
         scrtmp_sod_det.sod_cmtindx     = 0
         scrtmp_sod_det.sod_mod_userid  = global_userid
         scrtmp_sod_det.sod_mod_date    = today.
  ASSIGN scrtmp_sod_det.dataLinkFieldPar = scrtmp_so_mstr.dataLinkField
         scrtmp_sod_det.dataLinkField    = fgetNextDataLinkFieldID()
     scrtmp_sod_det.sod__chr03   = lvc_commit 
         .

   /* OT-153 START ADDITION */
   if lvl_nonEMT3PL
   then do:
      if scrtmp_sod_det.sod__chr10 = "SAMPLES"
      then
         scrtmp_sod_det.sod__qadc01 = "EA".
      else if scrtmp_sod_det.sod__qadc01 = ""
         or scrtmp_sod_det.sod__qadc01 = ?
      then
         scrtmp_sod_det.sod__qadc01 = "CS".
   end.
   else
      scrtmp_sod_det.sod__qadc01 = "".
   /* OT-153 END ADDITION */
  
  VALIDATE scrtmp_sod_det.         
         
  /*2388 begin*/
  if not new-order and
     not can-find(first pt_mstr where pt_domain = scrtmp_sod_det.sod_domain
                                  and pt_part   = scrtmp_sod_det.sod_part
                                  and pt_part_type = "PAO")
  then do:
    def var min-due as date no-undo.
    RUN SetSodDue (scrtmp_so_mstr.so_domain,scrtmp_so_mstr.so_nbr,scrtmp_sod_det.sod_line,wh-site,wh-domain,no,
                            output min-due, INPUT-OUTPUT scrtmp_sod_det.sod_due_date, INPUT-OUTPUT scrtmp_sod_det.sod_per_date).
  end.
  /*2388 end*/

  if scrtmp_so_mstr.so__chr10 = "CENTRAL" then scrtmp_sod_det.sod__chr10 = "SAMPLES".

  if ordr-line <> 1 then do:
    find first soddet no-lock where soddet.sod_domain = domain
                                and soddet.sod_nbr = sonbr
                                and soddet.sod_line < ordr-line no-error.
    if avail soddet then scrtmp_sod_det.sod__chr10 = soddet.sod__chr10.
  end.

end procedure. /* create-sod */
/***************************************************************************/
procedure disp-line-detail:
  def input parameter domain as char.
  
  
  FIND scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                and scrtmp_sod_det.sod_nbr = sonbr
                                and scrtmp_sod_det.sod_line = ordr-line.

  display ordr-line scrtmp_sod_det.sod_part scrtmp_sod_det.sod_qty_ord scrtmp_sod_det.sod_um scrtmp_sod_det.sod_um_conv scrtmp_sod_det.sod_type scrtmp_sod_det.sod_price
          scrtmp_sod_det.sod_list_pr scrtmp_sod_det.sod_disc_pct with frame c.

  if scrtmp_so_mstr.so_site <> scrtmp_sod_det.sod_site then display scrtmp_so_mstr.so_site + "/" + scrtmp_sod_det.sod_site
                                              @ scrtmp_so_mstr.so_site with frame ab.

  find pt_mstr no-lock where pt_domain = wh-domain
                         and pt_part = scrtmp_sod_det.sod_part no-error.
  if avail pt_mstr then do:
    display pt_desc1 @ scrtmp_sod_det.sod_desc with frame d.
    find xxtransl_det no-lock where xxtransl_file = "pt_mstr"
                                and xxtransl_key1_field = "pt_part"
                                and xxtransl_key2_field = ""
                                and xxtransl_key1_code = pt_part
                                and xxtransl_key2_code = ""
                                and xxtransl_desc_field = "pt_desc1"
                                and xxtransl_lang = scrtmp_so_mstr.so_lang no-error.
    if avail xxtransl_det then display xxtransl_desc @ scrtmp_sod_det.sod_desc with frame d.
  end.
  else display scrtmp_sod_det.sod_desc with frame d.

  if scrtmp_sod_det.sod_cmtindx <> ? and scrtmp_sod_det.sod_cmtindx <> 0 then sod-cmmts = yes.
  else sod-cmmts = no.

  assign sodstat = ""
         scrtmp_sod_det.sod_lot:LABEL in FRAME d = "Status".
  if scrtmp_sod_det.sod_status = "M" then sodstat = "M='To Warehouse'".
  else if scrtmp_sod_det.sod_status = "A" then sodstat = "A='Allocated'".
  else if scrtmp_sod_det.sod_status = "C" then sodstat = "C='Fully Shipped'".
  if scrtmp_sod_det.sod_loc = "CONSIGN" then do:
    scrtmp_sod_det.sod_lot:LABEL in FRAME d = "Ref.".
    display scrtmp_sod_det.sod_lot with frame d.
  end.
  else display sodstat @ scrtmp_sod_det.sod_lot with frame d.

  if abs(scrtmp_sod_det.sod_qty_ord) <> 1 and scrtmp_sod_det.sod_price <> 0 then
    display scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_price @ line-amt with frame d.
  else display "" @ line-amt with frame d.

  acct-cc = scrtmp_sod_det.sod_acct.
  if scrtmp_sod_det.sod_cc <> "" then acct-cc = acct-cc + "-" + scrtmp_sod_det.sod_cc.

              
  display scrtmp_sod_det.sod_pricing_dt scrtmp_sod_det.sod_req_date scrtmp_sod_det.sod_per_date
          scrtmp_sod_det.sod_due_date scrtmp_sod_det.sod_loc scrtmp_sod_det.sod_serial sod-cmmts scrtmp_sod_det.sod_qty_all
          scrtmp_sod_det.sod__chr10 scrtmp_sod_det.sod_consume scrtmp_sod_det.sod_tax_usage
          scrtmp_sod_det.sod_taxc scrtmp_sod_det.sod_qty_ship scrtmp_sod_det.sod_qty_inv scrtmp_sod_det.sod_slspsn[1] acct-cc
          /* OT-153 DELETION
          scrtmp_sod_det.sod_qty_pick with frame d. */
          /* OT-153 START ADDITION */
          scrtmp_sod_det.sod_qty_pick scrtmp_sod_det.sod__qadc01
          with frame d.
          /* OT-153 END ADDITION */
          
end procedure. /* disp-line-detail */
/************************************************************************/
procedure find-um-conv:
  def input parameter domain as char.



  FIND scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                and scrtmp_sod_det.sod_nbr = sonbr
                                and scrtmp_sod_det.sod_line = ordr-line.
  find pt_mstr no-lock where pt_domain = wh-domain
                         and pt_part = scrtmp_sod_det.sod_part no-error.
  IF scrtmp_sod_det.operation = "N" THEN scrtmp_sod_det.operation = "M".
  scrtmp_sod_det.sod_um_conv = 1.
  if avail pt_mstr then do:
    find um_mstr no-lock where um_domain = wh-domain
                           and um_um = pt_um
                           and um_alt_um = scrtmp_sod_det.sod_um
                           and um_part = scrtmp_sod_det.sod_part no-error.
    if avail um_mstr then scrtmp_sod_det.sod_um_conv = um_conv.
  end.
end procedure. /* find-um-conv */
/*****************************************************************/
procedure check-all-mstr:

  def input parameter domain as char.

  FIND scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                and scrtmp_sod_det.sod_nbr = sonbr
                                and scrtmp_sod_det.sod_line = ordr-line.
  find pt_mstr no-lock where pt_domain = wh-domain
                         and pt_part = scrtmp_sod_det.sod_part no-error.
  if avail pt_mstr then do:
    if pt_pur_lead + pt_insp_lead + pt_mfg_lead > 0 then do:
      display "Cumulative Leadtime: " + string(pt_pur_lead + pt_insp_lead
                                      + pt_mfg_lead) format "X(35)" skip(1)
               with frame yn103 side-labels overlay row 10 col 10.
      update yn blank label "Press Enter" go-on("END-ERROR") with frame yn103.
      hide frame yn103 no-pause.
    end.
    find xxpt_mstr no-lock where xxpt_part = scrtmp_sod_det.sod_part no-error.
    if avail xxpt_mstr then do:
      if xxpt_char[1] <> "" then do:
        display "Alternative for this Item = " + xxpt_char[1] format "X(46)"
                skip(1)  with frame yn104 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn104.
        hide frame yn104 no-pause.
      end.
      /* OT-379 comment start */
      /*  if xxpt_pharmacy = yes then do:
        display "This Item may only be delivered to Pharmacies ...!!" skip(1)
                 with frame yn105 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn105.
        hide frame yn105 no-pause.
      end. */
     /* OT-379 comment end */
      if substr(xxpt_source,1,20) <> "" and (substr(xxpt_source,21) = "" or
        can-do(substr(xxpt_source,21), scrtmp_so_mstr.so_site)) then do:
        display 'Attention, this is a "' + trim(substr(xxpt_source,1,20)) +
                '" Item !!!' format "X(55)" skip(1)
                 with frame yn106 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn106.
        hide frame yn106 no-pause.
      end.
    end.
  end.
end procedure. /* check-all-mstr */
/****************************************************************************/
procedure check-sod-um:

  def input parameter domain as char.



  if scrtmp_so_mstr.so_domain <> domain THEN MESSAGE "ceck-sod-um alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.

  FIND scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                and scrtmp_sod_det.sod_nbr = sonbr
                                and scrtmp_sod_det.sod_line = ordr-line.
  find pt_mstr no-lock where pt_domain = wh-domain
                         and pt_part = scrtmp_sod_det.sod_part no-error.
  sod-um-ok = yes.
  
   /* OT-153 START ADDITION */
   if lvl_nonEMT3PL
     and scrtmp_sod_det.sod_um <> "EA"
   then do:
      display "The only Unit of Measure allowed is EA !!!"
               skip(1)
               with frame yn112 side-labels overlay row 10 col 10.
      update yn blank label "Press Enter" go-on("END-ERROR") with frame yn112.
      hide frame yn112 no-pause.
      sod-um-ok = no.
      return.
   end.
   /* OT-153 END ADDITION */
  
  if avail pt_mstr then do:
    find um_mstr no-lock where um_domain = wh-domain
                           and um_um = pt_um
                           and um_alt_um = scrtmp_sod_det.sod_um
                           and um_part = scrtmp_sod_det.sod_part no-error.
    if avail um_mstr then scrtmp_sod_det.sod_um_conv = um_conv.
    else if scrtmp_sod_det.sod_um <> pt_um then do:
      display "This Unit of Measure is not supported (yet) !!!"
               with frame yn107 side-labels overlay row 10 col 10.
      update yn blank label "Press Enter" go-on("END-ERROR") with frame yn107.
      hide frame yn107 no-pause.
      sod-um-ok = no.
      return.
    end.
  end.

/*** CHN00634 DELETE BEGINS ******************************************************
  if can-do("801,811,821,831",wh-site) and
     not can-do("EA,CS,BX",scrtmp_sod_det.sod_um) then do:
 *** CHN00634 DELETE ENDS ********************************************************/

  /*** CHN00634 ADD BEGINS *******************************************************/
     if can-find(first code_mstr no-lock
        where code_domain  = wh-domain
          and code_fldname = "Spain WH"
          and can-do(code_value, wh-site)
          and not can-do(code_cmmt, scrtmp_sod_det.sod_um))
     then do: 
  /*** CHN00634 ADD ENDS *********************************************************/

    display "This Unit of Measure is not supported by the Spanish Warehouse !!!"
             with frame yn107a side-labels overlay row 10 col 10.
    update yn blank label "Press Enter" go-on("END-ERROR") with frame yn107a.
    hide frame yn107a no-pause.
    sod-um-ok = no.
    return.
  end.

/*** INC115964 ADD BEGINS ****************/
  for first code_mstr no-lock
     where code_domain  = "XX"
       and code_fldname = "UOM_in_use":
     lvc_umiu = code_value.
  end. /* FOR FIRST code_mstr NO-LOCK */
/*** INC115964 ADD ENDS ******************/

 /* if (avail pt_mstr and scrtmp_sod_det.sod_um <> "CS" and scrtmp_sod_det.sod_um <> "BX" and                          INC115964 */

 /*** INC115964 ADD BEGINS *****************************/
  if (avail pt_mstr
     and (lookup(scrtmp_sod_det.sod_um, lvc_umiu) = 0)
     and
 /*** INC115964 ADD ENDS *******************************/

     (scrtmp_so_mstr.so__chr10 = "" or scrtmp_so_mstr.so__chr10 = "CONSIGN" or scrtmp_so_mstr.so__chr10 = "RUSH") and
    not can-find(first ld_det no-lock where ld_domain = wh-domain
                                        and ld_part = scrtmp_sod_det.sod_part
                                        and ld_site = scrtmp_sod_det.sod_site
                                        and ld_loc = "CONSIGN"
                                        and ld_ref begins scrtmp_so_mstr.so_ship)) then do:
    
     /* OT-153 START ADDITION */
     if not lvl_nonEMT3PL
     then do:
     /* OT-153 END ADDITION */

     /*** INC115964 DELETE BEGINS ***********************************************************
        find um_mstr no-lock where um_domain = wh-domain
                               and um_um = pt_um
                              /* and um_alt_um = "CS"                             CHN00634 */
                               and um_alt_um = scrtmp_sod_det.sod_um           /* CHN00634 */
                               and um_part = scrtmp_sod_det.sod_part no-error.
     **** INC115964 DELETE ENDS ************************************************************/

     /*** INC115964 ADD BEGINS ***************************/
        for first um_mstr no-lock 
           where um_domain = wh-domain
             and um_um     = pt_um
             and um_alt_um = "CS"
             and um_part   = scrtmp_sod_det.sod_part:
        end. /* FOR FIRST um_mstr */
     /*** INC115964 ADD ENDS *****************************/

     /* OT-153 START ADDITION */
     end.
     else do:
       for first um_mstr
          where um_domain = wh-domain
            and um_um     = pt_um
            and um_alt_um = scrtmp_sod_det.sod__qadc01
            and um_part   = scrtmp_sod_det.sod_part
        no-lock:
        end.
     end.
     /* OT-153 END ADDITION */

    if avail um_mstr then do:
     /* if scrtmp_sod_det.sod_qty_ord / um_conv <> round(scrtmp_sod_det.sod_qty_ord / um_conv,0) then do: CHN00634 */

    /*** INC115964 DELETE BEGINS ***************************************************************
     /*** CHN00634 ADD BEGINS ****************************************************************/
      if (scrtmp_sod_det.sod_qty_ord * um_conv) / um_conv 
         <> round((scrtmp_sod_det.sod_qty_ord  * um_conv) / um_conv,0)
      then do:
     /*** CHN00634 ADD ENDS ******************************************************************/
    *** INC115964 DELETE ENDS *****************************************************************/

    /*** INC115964 ADD BEGINS ****************************/
      if scrtmp_sod_det.sod_qty_ord / um_conv
         <> round(scrtmp_sod_det.sod_qty_ord / um_conv,0)
      then do:
    /*** INC115964 ADD ENDS ******************************/

        lum-allowed:
        do:
          find cm_mstr no-lock where cm_domain = domain
                                 and cm_addr = scrtmp_so_mstr.so_cust no-error.
          if cm__chr07 = "yes" then do: /*lum-allow*/
            find xxlum_det no-lock where xxlum_part = scrtmp_sod_det.sod_part no-error.
            if avail xxlum_det then do:
              if xxlum_um = scrtmp_sod_det.sod_um then leave lum-allowed.

              display "This Customer is not allowed to have this UoM," skip
                      "the only one allowed is '" + caps(xxlum_um) + "' ..."
                       format "X(45)" skip(1)
                      with frame yn1081 side-labels overlay row 10 col 10.
              update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn1081.
              hide frame yn1081 no-pause.
              sod-um-ok = no.
              return.
            end.
          end.

          display "Quantity entered is not dividable by " + string(um_conv) +
                  " !!!" format "X(50)" skip(1)
                   with frame yn108 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                     with frame yn108.
          hide frame yn108 no-pause.
          if emt-maint and not can-do("600,800,810,880",scrtmp_so_mstr.so_site) then do:
            sod-um-ok = no.
            return.
          end.
        end.
      end.
    end.
  end. /* lum-allowed */

  if not can-do("CENTRAL,SAMPLES",scrtmp_so_mstr.so__chr10) and
    can-find(ld_det no-lock where ld_domain = wh-domain
                              and ld_site = scrtmp_sod_det.sod_site
                              and ld_part = scrtmp_sod_det.sod_part
                              and ld_loc = "SAMPLES") then do:
    assign qty-normal = 0
           qty-sample = 0.
    for each ld_det no-lock where ld_domain = wh-domain
                              and ld_site = scrtmp_sod_det.sod_site
                              and ld_part = scrtmp_sod_det.sod_part:
      if ld_loc = "SAMPLES" then
           qty-sample = qty-sample + ld_qty_oh / scrtmp_sod_det.sod_um_conv.
      else qty-normal = qty-normal + ld_qty_oh / scrtmp_sod_det.sod_um_conv.
    end.
    if qty-normal < scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship and qty-sample > 0 then do:
      display "There is not enough free Inventory which can be allocated." skip
              "There is however" trim(string(qty-sample,"->>>>>9.9<")) scrtmp_sod_det.sod_um
              "SAMPLE material available." format "X(65)" skip(1)
               with frame yn109 side-labels overlay row 10 col 10.
      update yn blank label "Press Enter" go-on("END-ERROR") with frame yn109.
      hide frame yn109 no-pause.
    end.
    else if qty-normal < scrtmp_sod_det.sod_qty_ord - scrtmp_sod_det.sod_qty_ship then do:
      display "There is not enough free Inventory which can be allocated."
              skip(1)  with frame yn110 side-labels overlay row 10 col 10.
      update yn blank label "Press Enter" go-on("END-ERROR") with frame yn110.
      hide frame yn110 no-pause.
    end.
  end.

  find in_mstr no-lock where in_domain = wh-domain
                         and in_site = wh-site
                         and in_part = scrtmp_sod_det.sod_part no-error.
end procedure. /* check-sod-um */
/****************************************************************************/
procedure delete-order:

  def input parameter del-ord-domain as char.
  def output parameter err-stat as char.
  
  if scrtmp_so_mstr.so_domain <> del-ord-domain THEN MESSAGE "delete-sod alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.

  /* header delete will also delete lines 
  counter = 0.
  for each scrtmp_sod_det where scrtmp_sod_det.sod_domain = del-ord-domain
                     and scrtmp_sod_det.sod_nbr = sonbr:
    ordr-line = scrtmp_sod_det.sod_line.
    run delete-line (del-ord-domain,scrtmp_so_mstr.so__chr10,scrtmp_so_mstr.so_site,output err-stat).
    if err-stat <> "" then return.
    counter = counter + 1.
  end.
  */
  empty temp-table tt_quota.
  run delete-header(del-ord-domain).

  if emt-ordr <> no then do:
    run del-emt-header(wh-domain).
    /**********
    IF  not can-find(first prh_hist where prh_domain = del-ord-domain
                                     and prh_nbr = sonbr) /* and
       not can-find(first tr_hist where tr_domain = del-ord-domain
                                    and tr_nbr = sonbr
                                    and tr_type <> "ORD-SO") and
       not can-find(first pod_det where pod_domain = del-ord-domain
                                    and pod_nbr = sonbr) */ then
    ******/                                    
    run del-po-header(del-ord-domain).
  end.
  global_domain = old-domain.

  message "Order + line(s) deleted ...".
  readkey pause 2.
end procedure. /* delete-order */
/****************************************************************************/
procedure delete-header:
  def input parameter domain as char.

  define buffer Debtor for Debtor.
  define variable l_nbline as log no-undo. /* RFC2142 */


  if scrtmp_so_mstr.so_domain <> domain THEN MESSAGE "delete-header alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
  scrtmp_so_mstr.operation = "R".
/*RFC-2868 START OF ADDITION *************************************************/
  lvl_pao = no.
  FOR EACH scrtmp_sod_det 
     WHERE scrtmp_sod_det.sod_domain = scrtmp_so_mstr.so_domain
       AND scrtmp_sod_det.sod_nbr    = scrtmp_so_mstr.so_nbr:
     if can-find(first pt_mstr no-lock where pt_dom = scrtmp_so_mstr.so_domain
                                         and pt_part = scrtmp_sod_det.sod_part
                                         and pt_part_type = "PAO") 
     then 
        lvl_pao = yes.
  end.
  if lvl_pao then do:
     output to value(mfguser + ".txt") .
    if intf-dir + server-id <> "/ext1/prod"
        then
           put unformatted "This is a TEST, please discard ..."
           chr(10) chr(10).
        put unformatted "   Order       Line     Item            UM      Qty    "
         chr(10)        "-------------- ------  -------------- ----- "
         chr(10).
  end.
/*RFC-2868 END OF ADDITION ***************************************************/
  FOR EACH scrtmp_sod_det WHERE scrtmp_sod_det.sod_domain = scrtmp_so_mstr.so_domain
                           AND scrtmp_sod_det.sod_nbr    = scrtmp_so_mstr.so_nbr:

     scrtmp_sod_det.operation = "R".
/*RFC-2868 START OF ADDITION *************************************************/
     if can-find (first pt_mstr no-lock 
        where pt_dom       = scrtmp_so_mstr.so_domain
          and pt_part      = scrtmp_sod_det.sod_part
      and pt_part_type = "PAO" ) 
     then do:
     
              
         find usr_mstr no-lock  where usr_userid = global_userid.
             mail-from = usr_mail_address.
         put unformatted string(scrtmp_sod_det.sod_nbr,"X(9)")
                         string(scrtmp_sod_det.sod_line,">>>9")  + "     "
                         string(scrtmp_sod_det.sod_part,"X(19)")
                         string(scrtmp_sod_det.sod_um,"x(3)")   + " "
                         string(scrtmp_sod_det.sod_qty_ord,"->>>>>9") skip.
     end. /* IF AVAILABLE pt_mstr */
/*RFC-2868 END OF ADDITION****************************************************/
     /* RFC2142 ADD BEGINS */
     if  not can-do("INVOICE,SAMPLES,CENTRAL",scrtmp_so_mstr.so__chr10)                                 
             and  index(dtitle,"99.7.1.4") = 0   
             and  lv_emt =  no /*SCQ-1369*/
     then do:   
        find first tt_quota no-lock                        
           where tt_domain = scrtmp_sod_det.sod_domain     
             and tt_nbr    = scrtmp_sod_det.sod_nbr        
             and tt_line   = scrtmp_sod_det.sod_line       
             and tt_part   = scrtmp_sod_det.sod_part     
        no-error        .                                         
        if not available tt_quota                          
        then do: 
           /* RFC2364 ADD BEGINS */ 
           find ad_mstr no-lock 
              where ad_mstr.ad_domain = domain
                and ad_mstr.ad_addr = scrtmp_so_mstr.so_cust 
           no-error.                       
           if available ad_mstr 
           then 
              lvc_ctry = ad_country.
           /* RFC2364 ADD BEGINS */ 

           create tt_quota.                                       
           assign                                                   
              tt_domain  = scrtmp_sod_det.sod_domain            
              tt_nbr     = scrtmp_sod_det.sod_nbr               
              tt_line    = scrtmp_sod_det.sod_line              
              tt_part    = scrtmp_sod_det.sod_part              
              tt_cust    = scrtmp_so_mstr.so_cust 
              tt_ctry    = lvc_ctry /* RFC2364 */
              tt_site    = wh-site                              
              tt_ordt    = scrtmp_sod_det.sod_per_date           
              tt_actual_qty = (scrtmp_sod_det.sod_qty_ord       
                    * scrtmp_sod_Det.sod_um_conv)   
              tt_code = "Delete"                    
              tt_old_qty = 0                         
              tt_operation = "R".    
       
           if tt_old_qty < tt_actual_qty                    
           then                                                   
              tt_ord_qty = ( tt_actual_qty - tt_old_qty).   
           else if tt_old_qty > tt_actual_qty               
           then                                              
              tt_ord_qty = (tt_old_Qty - tt_actual_qty). 
           else if tt_old_qty = tt_actual_qty
           then 
              tt_ord_qty = tt_actual_qty. 

        end. /* if not available tt_quota */
    end. /* if not can-do() */     
     /* RFC 2142 ADD ENDS */
  END.
/*RFC-2868 START OF ADDITION**************************************************/
if lvl_pao then do :
    output close.
    run us/av/avmail.p(lv_mail_to ,     /*CHN00664*/                        /* Mail Address */
        "S/O PAO order deleted  " + scrtmp_so_mstr.so_nbr  , /* Subject      */
        "",                                                  /* Body         */
        mfguser + ".txt" ,                                   /* Attachment   */
        no).                                                 /* Zip yes/no   */
end.
/*RFC-2868 END OF ADDITION****************************************************/
  RUN SaveSoLocal(INPUT FALSE, OUTPUT lErro#).
  iF lErro# THEN UNDO, RETRY.
  else  do:
     
     for first xxblck_det exclusive-lock
           where xxblck_domain = scrtmp_sod_det.sod_domain
             and xxblck_ord    = scrtmp_sod_det.sod_nbr 
             and xxblck_line   = scrtmp_sod_det.sod_line
     use-index xxblck_time:
            
        if xxblck_stat = "Blocked"
        then do:
           assign
              l_nbline = yes
              l_qtblck = yes.
           delete xxblck_det.
        end.
        else if xxblck_stat = "Released"
        then
           l_qtblck = no.
         release xxblck_det.
     end. /* for first xxblck_det */
     if not available xxblck_det and l_nbline = yes
     then
        l_qtblck = no.
     for first tt_quota no-lock:
     end.
     if  available tt_quota  and l_qtblck = no
     then
        run quota in hquota (input-output table tt_quota, 
                                input old-qty-ord).        /* RFC2142 */        
      release xxqt_det. /* RFC2142 */ 
  end.  /* else  do: */ 
end procedure. /* delete-header */
/********************************************************************/
procedure del-po-header:
  def input parameter del-po-domain as char.

  DEFINE BUFFER po_mstr FOR po_mstr.
  DEFINE BUFFER pod_det FOR pod_det.
  DEFINE BUFFER prh_hist FOR prh_hist.
  
  if scrtmp_so_mstr.so_domain <> domain THEN MESSAGE "del-po-header alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
  
  find FIRST po_mstr where po_domain = del-po-domain
                       and po_nbr = sonbr NO-LOCK no-error.
  if avail po_mstr 
  then do:
    
    DATASET dsmaintainPurchaseOrder:EMPTY-DATASET().
  
    RUN SetPoLocks IN hProc# (INPUT del-po-domain, INPUT sonbr, INPUT THIS-PROCEDURE, OUTPUT cErro#). 
                              
    CREATE tt_po_mstr.
    BUFFER-COPY po_mstr TO tt_po_mstr
        ASSIGN tt_po_mstr.dataLinkField = fgetNextDataLinkFieldID()
               .
    VALIDATE tt_po_mstr.
    
    CREATE tt_po_mstr_head.
    BUFFER-COPY po_mstr TO tt_po_mstr_head
        ASSIGN tt_po_mstr_head.dataLinkField    = fgetNextDataLinkFieldID()
               tt_po_mstr_head.dataLinkFieldPar = tt_po_mstr.dataLinkField
               tt_po_mstr_head.operation = "R".
    VALIDATE tt_po_mstr_head.

    FOR EACH pod_det NO-LOCK WHERE pod_det.pod_domain = po_mstr.po_domain AND pod_det.pod_nbr = po_mstr.po_nbr:
      IF pod_det.pod_qty_rcvd = 0 AND
         CAN-FIND(FIRST prh_hist WHERE prh_hist.prh_domain = pod_det.pod_domain
                                   AND prh_hist.prh_nbr    = pod_det.pod_nbr
                                   AND prh_hist.prh_line   = pod_det.pod_line) = FALSE
      THEN DO:
        CREATE tt_pod_det.
        BUFFER-COPY pod_det TO tt_pod_det.
            ASSIGN tt_pod_det.dataLinkField = fgetNextDataLinkFieldID()
                   tt_pod_det.dataLinkFieldPar = tt_po_mstr.dataLinkField 
                   tt_pod_det.operation = "R".
        VALIDATE tt_pod_det.
      END.
      ELSE DO:
        ASSIGN tt_po_mstr_head.operation = "N".
        VALIDATE tt_po_mstr_head.
/*RFC-2524 START OF ADDITION *************************************************/
        find first pod-det exclusive-lock 
       where recid(pod-det) = recid(pod_det) no-error.
           if available pod-det then do:
       if pod-det.pod_qty_rcvd > 0                    and 
          pod-det.pod_status  <> "c"
           then 
              pod-det.pod_status = "c".
          end.
    release pod-det.
/*RFC-2524 END OF ADDITION****************************************************/
      END.
    END.
    
    IF CAN-FIND(FIRST tt_pod_det)
    THEN RUN SavePoData(OUTPUT lErro#).
    ELSE DATASET dsmaintainPurchaseOrder:EMPTY-DATASET().
  end.
end procedure. /* del-po-header */


/********************************************************************/
procedure delete-line:
  def input parameter del-line-domain as char.
  def input parameter proj-code as char.
  def input parameter del-line-site as char.
  def output parameter err-stat as char.
  define variable l_nbline as log no-undo. /* RFC2142 */

  find scrtmp_sod_det where scrtmp_sod_det.sod_domain = wh-domain
                 and scrtmp_sod_det.sod_nbr = sonbr
                 and scrtmp_sod_det.sod_line = ordr-line no-lock no-error.
  if avail scrtmp_sod_det then do:
    if (emt-maint = yes and scrtmp_sod_det.sod_qty_inv <> 0) or
       (emt-maint = no and scrtmp_sod_det.sod_type = "" and scrtmp_sod_det.sod_qty_ship <> 0) then do:
      display  "You may not delete this orderline now because" skip
               "this orderline in domain" wh-domain no-label   skip
               "has not been invoiced (yet) ..."
        skip(1) with frame yn123 side-labels overlay row 10 col 10.
      update yn blank label "Press Enter" go-on("END-ERROR")
      with frame yn123.
      hide frame yn123 no-pause.
      err-stat = "ERROR".
      return.
    end.

  end.

  find scrtmp_sod_det where scrtmp_sod_det.sod_domain = del-line-domain
                 and scrtmp_sod_det.sod_nbr = sonbr
                 and scrtmp_sod_det.sod_line = ordr-line no-error.
  if not avail scrtmp_sod_det then do:
    err-stat = "ERROR".
    return.
  end.

  ASSIGN scrtmp_sod_det.operation = "R".
  /* RFC2142 ADD BEGINS */   
  if  not can-do("INVOICE,SAMPLES,CENTRAL",scrtmp_so_mstr.so__chr10)                                 
             and  index(dtitle,"99.7.1.4") = 0    
             and  lv_emt = no /*SCQ-1369*/
  then do:   
     find first tt_quota Exclusive-lock                           
        where tt_domain = scrtmp_sod_det.sod_domain                    
          and tt_nbr    = scrtmp_sod_det.sod_nbr                   
          and tt_line   = scrtmp_sod_det.sod_line                  
          and tt_part   = scrtmp_sod_det.sod_part                  
     no-error.                                                         
     if not available tt_quota                                   
     then do:    
        /* RFC2364 ADD BEGINS */ 
        find ad_mstr no-lock 
           where ad_mstr.ad_domain = domain
             and ad_mstr.ad_addr = scrtmp_so_mstr.so_cust 
        no-error.                       
        if available ad_mstr 
        then 
           lvc_ctry = ad_country.
        /* RFC2364 ADD ENDS */ 
        create tt_quota.                                         
        assign                                                   
           tt_domain  = scrtmp_sod_det.sod_domain                
           tt_nbr     = scrtmp_sod_det.sod_nbr                   
           tt_line    = scrtmp_sod_det.sod_line                  
           tt_part    = scrtmp_sod_det.sod_part                  
           tt_cust    = scrtmp_so_mstr.so_cust   
           tt_ctry    =  lvc_ctry /* RFC2364 */
           tt_site    = wh-site                                  
           tt_ordt    = scrtmp_sod_det.sod_per_date               
           tt_actual_qty = (scrtmp_sod_det.sod_qty_ord              
                         * scrtmp_sod_Det.sod_um_conv) 
           tt_old_qty = old-qty-ord
           tt_code  = "Delete"
           tt_operation = "R".

        if tt_old_qty < tt_actual_qty
        then                
           tt_ord_qty = ( tt_actual_qty - tt_old_Qty).
        else if old-qty-ord > tt_actual_qty
        then
           tt_ord_qty = (tt_old_Qty - tt_actual_qty).
        else if tt_old_Qty = tt_actual_qty
        then
           tt_ord_qty = tt_actual_qty. 
            
         
     end. /*  if not available tt_quota  */  
  end. /* if not can-do */
  /* RFC2142 ADD ENDS */                                      
    
  RUN SaveSoLocal(INPUT FALSE, OUTPUT lErro#).
   /* RFC2142 ADD BEGINS */                                      
  IF lErro# THEN UNDO, RETRY.
  else do:
     for first xxblck_det exclusive-lock
           where xxblck_domain = scrtmp_sod_det.sod_domain
             and xxblck_ord    = scrtmp_sod_det.sod_nbr 
             and xxblck_line   = scrtmp_sod_det.sod_line
           use-index xxblck_time:
            
            if xxblck_stat = "Blocked"
            then do:
               assign
                  l_nbline = yes
                  l_qtblck = yes.
               delete xxblck_det.
            end.
            else if xxblck_stat = "Released"
            then
               l_qtblck = no.
         release xxblck_det.
     end. /* for first xxblck_det exclusive-lock */
     if not available xxblck_det and l_nbline = no
     then
        l_qtblck = no.
     find first tt_Quota no-lock no-error.
     if available tt_quota and l_qtblck = no
     then
        run Quota IN hquota (INPUT-OUTPUT table tt_quota, input old-qty-ord).        /* RFC2142 */        
     release xxqt_det. /* RFC2142 */
  end. /*  else do: */
  /* RFC2142 ADD ENDS */                                      
                                                     
   
  if emt-ordr <> no then do:
    run del-emt-line(wh-domain).
    run del-po-line(del-line-domain).
    global_domain = old-domain.
  end.
/*RFC-2868 START OF ADDITION *************************************************/
  if can-find (first pt_mstr no-lock where pt_dom      = scrtmp_sod_det.sod_domain
                                      and pt_part      = scrtmp_sod_det.sod_part
                                      and pt_part_type = "PAO") then do:
      
      output to value(mfguser + ".txt").
         if intf-dir + server-id <> "/ext1/prod"
         then
            put unformatted "This is a TEST, please discard ..."
            chr(10) chr(10).
         put unformatted "   Order       Line     Item            UM      Qty    "
                chr(10)        "-------------- ------  -------------- ----- "
          chr(10).
      find usr_mstr no-lock where usr_userid = global_userid.
      if available usr_mstr then
         mail-from = usr_mail_address.

      for first so_mstr no-lock
         where so_mstr.so_domain = scrtmp_sod_det.sod_domain
           and so_mstr.so_nbr = scrtmp_sod_det.sod_nbr:
         put unformatted string(scrtmp_sod_det.sod_nbr,"X(9)")
                                string(scrtmp_sod_det.sod_line,">>>9")  + "     "
                                string(scrtmp_sod_det.sod_part,"X(19)")
                                string(scrtmp_sod_det.sod_um,"x(3)")   + " "
                                string(scrtmp_sod_det.sod_qty_ord,"->>>>>9").
      end.
      output close.
      run us/av/avmail.p(lv_mail_to ,   /*CHN00664*/                                   /* Mail Address */
         "S/O PAO order deleted  " + scrtmp_sod_det.sod_nbr + "," +  "," + scrtmp_sod_det.sod_part , /* Subject      */
         "",                                          /* Body         */
         mfguser + ".txt" ,                           /* Attachment   */
         no).                                          /* Zip yes/no   */
    end. /* IF AVAILABLE pt_mstr */
/*RFC-2868 END OF ADDITION****************************************************/
  DO TRANSACTION:
/*RFC-2524 START OF ADDITION *************************************************/
     for first pod_det exclusive-lock where pod_det.pod_domain = del-line-domain
                                         and pod_det.pod_nbr    = sonbr
                                         and pod_det.pod_line   = ordr-line .

     if pod_det.pod_qty_rcvd > 0   and
    pod_det.pod_status <> "c" 
     then 
        pod_det.pod_status = "c".
     end.
     release pod_det.
/*RFC-2524 END OF ADDITION ***************************************************/
      find scrtmp_sod_det where scrtmp_sod_det.sod_domain = del-line-domain
                     and scrtmp_sod_det.sod_nbr = sonbr
                     and scrtmp_sod_det.sod_line = ordr-line no-error.
      IF AVAIL scrtmp_sod_det THEN
      DO:
          DELETE scrtmp_sod_det.
      END.
  END.

end procedure. /* delete-line */
/****************************************************************************/
procedure del-emt-header:
  def input parameter del-emt-domain as char.

  DEF BUFFER so_mtst FOR so_mstr.
  
  find emttmp_so_mstr where emttmp_so_mstr.so_domain = del-emt-domain
                 and emttmp_so_mstr.so_nbr = sonbr no-error.
  if not avail emttmp_so_mstr then DO:
      FIND so_mstr NO-LOCK WHERE so_mstr.so_domain = del-emt-domain
                     AND so_mstr.so_nbr = sonbr no-error.
      IF NOT AVAIL so_mstr THEN RETURN.
      ELSE DO:
          CREATE emttmp_so_mstr.
          BUFFER-COPY so_mstr
                   TO emttmp_so_mstr
               ASSIGN emttmp_so_mstr.dataLinkField = fgetNextDataLinkFieldID()
                      emttmp_so_mstr.operation     = "R".
      END. 
  END.
  ELSE ASSIGN emttmp_so_mstr.operation        = "R" .
  
  RUN SaveEmtData (OUTPUT lErro#).
  IF lErro# THEN UNDO, RETRY.

end procedure. /* del-emt-line */
/****************************************************************************/
procedure del-emt-line:
  def input parameter del-emt-domain as char.

  DEF BUFFER sod_det FOR sod_det.
  DEF BUFFER so_mtst FOR so_mstr.
  
  find emttmp_sod_det where emttmp_sod_det.sod_domain = del-emt-domain
                 and emttmp_sod_det.sod_nbr = sonbr
                 and emttmp_sod_det.sod_line = ordr-line no-error.
  if not avail emttmp_sod_det then DO:
      FIND so_mstr NO-LOCK WHERE so_mstr.so_domain = del-emt-domain
                     AND so_mstr.so_nbr = sonbr no-error.
      FIND sod_det NO-LOCK WHERE sod_det.sod_domain = del-emt-domain
                     AND sod_det.sod_nbr = sonbr
                     AND sod_det.sod_line = ordr-line no-error.
      IF NOT AVAIL so_mstr OR NOT AVAIL sod_det THEN RETURN.
      ELSE DO:
          CREATE emttmp_so_mstr.
          BUFFER-COPY so_mstr
                   TO emttmp_so_mstr
               ASSIGN emttmp_so_mstr.dataLinkField = fgetNextDataLinkFieldID()
                      emttmp_so_mstr.operation     = "N".
          
          CREATE emttmp_sod_det.
          BUFFER-COPY sod_det TO emttmp_sod_det.
          ASSIGN emttmp_sod_det.dataLinkFieldPar = emttmp_so_mstr.dataLinkField
                 emttmp_sod_det.operation        = "R"
                 emttmp_sod_det.dataLinkField    = fgetNextDataLinkFieldID()
                 .
      END.
  
  END.
  ELSE ASSIGN emttmp_sod_det.operation        = "R" .
  
  RUN SaveEmtData (OUTPUT lErro#).
  IF lErro# THEN UNDO, RETRY.

end procedure. /* del-emt-line */
/****************************************************************************/
procedure del-po-line:

  def input parameter del-po-domain as char.
  DEF BUFFER pod_det FOR pod_det.
  DEF BUFFER po_mstr FOR po_mstr.
  
  find po_mstr no-lock where po_domain = del-po-domain
                         and po_nbr = sonbr no-error.

  find pod_det NO-LOCK where pod_domain = del-po-domain
                 and pod_nbr = sonbr
                 and pod_line = ordr-line no-error.

  if avail pod_det
    and pod_det.pod_qty_rcvd = 0
    and not can-find(first prh_hist NO-LOCK where prh_domain = pod_det.pod_domain
                                      and prh_nbr = pod_det.pod_nbr
                                      and prh_line = pod_det.pod_line)
  then do:
    
    DATASET dsmaintainPurchaseOrder:EMPTY-DATASET().
  
    RUN SetPoLocks IN hProc# (INPUT del-po-domain, INPUT sonbr, INPUT THIS-PROCEDURE, OUTPUT cErro#). 
               
    CREATE tt_po_mstr.
    BUFFER-COPY po_mstr TO tt_po_mstr
        ASSIGN tt_po_mstr.dataLinkField = fgetNextDataLinkFieldID().
    VALIDATE tt_po_mstr.
    
    CREATE tt_po_mstr_head.
    BUFFER-COPY po_mstr TO tt_po_mstr_head
        ASSIGN tt_po_mstr_head.dataLinkField    = fgetNextDataLinkFieldID()
               tt_po_mstr_head.dataLinkFieldPar = tt_po_mstr.dataLinkField
               tt_po_mstr_head.operation = "N".
    VALIDATE tt_po_mstr_head.

    CREATE tt_pod_det.
    BUFFER-COPY pod_det TO tt_pod_det.
        ASSIGN tt_pod_det.dataLinkField = fgetNextDataLinkFieldID()
               tt_pod_det.dataLinkFieldPar = tt_po_mstr.dataLinkField 
               tt_pod_det.operation = "R".
    VALIDATE tt_pod_det.
        
    RUN SavePoData(OUTPUT lErro#).

  end.
end procedure. /* del-po-line */
/****************************************************************************/
procedure consign-invoice:

  def input parameter domain as char.

  DEFINE BUFFER scrtmp_sod_det FOR scrtmp_sod_det.
  DEFINE BUFFER sod_det FOR sod_det.
  DEFINE BUFFER lad_det FOR lad_det.
  DEFINE BUFFER ld_det FOR ld_det.
  DEFINE BUFFER in_mstr FOR in_mstr.
  
  message "Patience Please, preparing Consignment selection-screen ...".

  IF scrtmp_so_mstr.so_domain <> domain THEN MESSAGE "consign-invoice alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.


  /* in future stock handling ook via QXtend (not part of this project) */
  consi-line = 0.
  empty temp-table cons-ld. /* 8980 */

  for EACH sod_det no-lock WHERE sod_det.sod_domain = domain
                             AND sod_det.sod_nbr = sonbr
                             AND sod_det.sod_loc = "CONSIGN",
      each lad_det no-lock where lad_domain = domain
                             and lad_dataset = "sod_det"
                             and lad_nbr = sod_det.sod_nbr
                             and lad_line = string(sod_det.sod_line)
                             and lad_part = sod_det.sod_part
                             and lad_site = sod_det.sod_site
                             and lad_loc = sod_det.sod_loc
                             and lad_lot = sod_det.sod_serial
                             and lad_ref = sod_det.sod_lot:
    find first cons-ld where cons-part = sod_det.sod_part
                         and cons-lot = lad_lot
                         and cons-ref = lad_ref no-error.
    if not avail cons-ld then do:
      consi-line = consi-line + 1.
      create cons-ld.
      assign cons-line = consi-line
             cons-part = lad_part
             cons-lot = lad_lot
             cons-ref = lad_ref
             cons-site = lad_site
             cons-updated = false.
    end.
    assign cons-qty-all = cons-qty-all + lad_qty_all + lad_qty_pick
           cons-sod-line = sod_det.sod_line.

    if cons-shipnr = "" then do:
      find first ld_det no-lock where ld_domain = domain
                                  and ld_site = sod_det.sod_site
                                  and ld_loc = sod_det.sod_loc
                                  and ld_part = sod_det.sod_part
                                  and ld_lot = lad_lot
                                  and ld_ref = lad_ref no-error.
      if avail ld_det then assign cons-shipnr = ld__chr02
                                  cons-shipdt = ld__dte01.
    end.
  end.

  for each ld_det no-lock where ld_domain = domain
                            and ld_loc = "CONSIGN"
                            and ld_ref begins scrtmp_so_mstr.so_ship
                            and ld_stat = "CONSIGN"
                          by ld_part by ld__dte01:
    find first cons-ld where cons-part = ld_part
                         and cons-lot = ld_lot
                         and cons-ref = ld_ref no-error.
    if not avail cons-ld then do:
      consi-line = consi-line + 1.
      create cons-ld.
      assign cons-line = consi-line
             cons-part = ld_part
             cons-lot = ld_lot
             cons-ref = ld_ref
             cons-shipnr = ld__chr02
             cons-shipdt = ld__dte01
             cons-qty-all = 0
             cons-updated = false
             cons-sod-line = ?
             cons-site = ld_site.
    end.
    if cons-shipnr = "" then if index(ld_ref,"-") > 0 then
       cons-shipnr = substr(ld_ref,index(ld_ref,"-") + 1).
    cons-qty-oh = ld_qty_oh.
  end.

  hide message no-pause.
  clear frame cons-fr all no-pause.

  for each cons-ld where cons-qty-oh = 0 and cons-qty-all = 0:
    delete cons-ld.
  end.

  consi-line = 1.
  if not bulkalloc then /*7884*/
  consloop:
  repeat with frame cons-fr down:
    find cons-ld no-lock where cons-line = consi-line no-error.
    if avail cons-ld then
      display cons-line @ consi-line cons-part cons-lot cons-shipnr cons-shipdt
              cons-qty-oh cons-qty-all with frame cons-fr.
/*** Special Procedure for Spanish Customer **************************/
    if scrtmp_so_mstr.so_cust = "18A0395" then do:
     line-tot = 0.
      for each cons-ld no-lock where cons-qty-all <> 0:        
        
        IF lRollBack THEN
          run "zu/zuprice.p" (no,domain,scrtmp_so_mstr.so_site,scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_curr,cons-part,1,'EA',today,output list-pr, output net-price).
          
        ELSE DO:
          list-pr = 0.
          net-price = 0.
          FIND FIRST ttApiPrice 
               WHERE ttApiPrice.ttDomain = global_domain 
                 AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                 AND ttApiPrice.ttpart = cons-part
                 EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE ttApiPrice THEN DO:
            /* cError = GetItemPrice(scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_curr,cons-part,"1",TODAY). palletd*/
               cError = GetItemPrice(scrtmp_so_mstr.so_cust,
                                 scrtmp_so_mstr.so_curr,
                     cons-part,
                     "1",
                     string(cons-qty-all),
                     TODAY). /* palletd */
        IF cError = "" THEN 
              FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                                      AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                                      AND ttApiPrice.ttpart = cons-part
                                      EXCLUSIVE-LOCK NO-ERROR.                   
          /*  ELSE
              ASSIGN scrtmp_sod_det.sod__chr02 = cError. */
          END.          
          IF AVAILABLE ttApiPrice THEN
            ASSIGN list-pr = ttApiPrice.ttprice * GetUomConv(cons-part, "EA")
                   net-price = ttApiPrice.ttprice * GetUomConv(cons-part, "EA")
                   .
          /*         
          ELSE DO:       
            IF cError NE "" THEN 
               ASSIGN scrtmp_sod_det.sod__chr02 = cError.
          END.
          */          
        END. /* else do lRollback */     
         
        line-tot = line-tot + cons-qty-all * net-price.
      end.
      find cm_mstr no-lock where cm_domain = domain
                             and cm_addr = scrtmp_so_mstr.so_cust.
      if line-tot >= dec(cm_cr_rating) then do:
        display "Total Order Amount = " + string(line-tot,"->,>>>,>>9.99")
                format "X(40)" skip(1)
                with frame yn115 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn115.
        hide frame yn115 no-pause.
      end.
    end.
/*********************************************************************/
    update consi-line go-on("END-ERROR") with frame cons-fr editing:
      {us/zu/zumfnp05.i cons-ld cons-line "cons-line <> 0"
                              cons-line "input consi-line"}
      if rRowid# <> ? then display cons-line @ consi-line cons-part cons-lot
                                 cons-qty-oh cons-shipnr cons-shipdt
                                 cons-qty-all with frame cons-fr.
    end.
    if keyfunction(lastkey) <> "END-ERROR" then do:
      find cons-ld where cons-line = consi-line no-error.
      ASSIGN old-qty-all = 0
             old-qty-all = cons-qty-all NO-ERROR.
      if avail cons-ld then do:
        ASSIGN old-qty-all = cons-qty-all NO-ERROR.        
      
        display cons-line @ consi-line cons-part cons-lot cons-shipnr
                cons-shipdt cons-qty-oh cons-qty-all with frame cons-fr.
        if cons-qty-all = 0 then cons-qty-all = cons-qty-oh.
        update cons-qty-all with frame cons-fr.
        if cons-qty-all > cons-qty-oh then do:
         display "You are not allowed to Enter more than available ..." skip(1)
                   with frame yn116 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" with frame yn116.
          hide frame yn116 no-pause.
          undo, retry.
        end.
        if cons-qty-all entered or cons-qty-all <> old-qty-all then
          cons-updated = true.
        down with frame cons-fr.
        consi-line = consi-line + 1.
      end.
      else do:
        display "This line does not exist !!!!" skip(1)
                with frame yn117 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn117.
        hide frame yn117 no-pause.
      end.
    end.
    else do:
      if scrtmp_so_mstr.so_cust = "18A0395" then do:
        line-tot = 0.
        for each cons-ld no-lock where cons-qty-all <> 0:
                                  
            IF lRollBack THEN
              run "zu/zuprice.p" (no,domain,scrtmp_so_mstr.so_site,scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_curr,cons-part,1,
                                      'EA',today,output list-pr, output net-price).                                  
            ELSE DO:
              list-pr = 0.
              net-price = 0.
              FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                                      AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                                      AND ttApiPrice.ttpart = cons-part
                                      EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE ttApiPrice THEN DO:
                ./ MESSAGE "Get API price 5" VIEW-AS ALERT-BOX.
                /* cError = GetItemPrice(scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_curr,cons-part,"1",TODAY). palletd */
        li_surcacc = 0. /* mulof */
        cError = GetItemPrice(scrtmp_so_mstr.so_cust,
                              scrtmp_so_mstr.so_curr,
                      cons-part,
                      "1",
                      string(cons-qty-all),
                      TODAY). /* palletd */
                IF cError = "" THEN 
                  FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                                          AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                                          AND ttApiPrice.ttpart = cons-part
                                          EXCLUSIVE-LOCK NO-ERROR.                   
               ELSE 
                 MESSAGE cError VIEW-AS ALERT-BOX. 
              END.          
              IF AVAILABLE ttApiPrice 
          THEN do: /* surcharge */
                ASSIGN list-pr = ttApiPrice.ttprice * GetUomConv(cons-part,"EA")
                       net-price = ttApiPrice.ttprice * GetUomConv(cons-part,"EA")
                       .
                /* ELSE 
                   ASSIGN scrtmp_sod_det.sod__chr02 = cError. */
                /* surcharge ADD BEGINS */                                   
        if ttapiprice.ttsurchargeperc ne 0                           
           and  not can-find(first xxsurc_det                    
        where xxsurc_domain  = scrtmp_so_mstr.so_domain              
           and xxsurc_cust   = scrtmp_so_mstr.so_cust                 
           and xxsurc_part   = cons-part                
            and xxsurc_nbr   = scrtmp_so_mstr.so_nbr                 
            and xxsurc_line   = consi-line)               
        then 
           assign
              li_surcacc = 0 /* mulof */
              cError = GetItemPrice(scrtmp_so_mstr.so_cust,             
                                     scrtmp_so_mstr.so_curr,             
                                 cons-part,            
                                        "1",
                             string(cons-qty-all), /* palletd */
                                       Today).     
                                                                           
                                                                            
          end. /* IF AVAILABLE ttApiPrice  */                               
          /* surcharge ADD ENDS */                                           
              
            END.  
        
          line-tot = line-tot + cons-qty-all * net-price.
        end.
        find cm_mstr no-lock where cm_domain = domain
                               and cm_addr = scrtmp_so_mstr.so_cust.
        if line-tot >= dec(cm_cr_rating) then do:
          display "Total Order Amount = " + string(line-tot,"->,>>>,>>9.99")
                   format "X(40)" skip(1)
                   with frame yn118 side-labels overlay row 10 col 10.
          update yn blank label "Press Enter" go-on("END-ERROR")
                 with frame yn118.
          hide frame yn118 no-pause.
          undo, retry.
        end.
      end.
      leave consloop.
    end.
  end.
  /*7884 begin*/
  else do: /*i.e. when bulkalloc*/
    for each cons-ld:
      cons-qty-all = cons-qty-oh.
      cons-updated = true.
    end.
  end.
  /*7884 end*/

  clear frame cons-fr all no-pause.

  linectr = 0. /*7884*/
  for each cons-ld no-lock where cons-updated = true:
    linectr = linectr + 1. /*7884*/
    display cons-line @ consi-line
            cons-part
            cons-lot
            cons-shipnr
            cons-shipdt
            cons-qty-oh
            cons-qty-all
            with down frame cons-fr.
    down with frame cons-fr.
    if (linectr MOD 10) = 0 then pause. /*7884*/
  end.

  if can-find (first cons-ld no-lock where cons-updated = true) then
  do:
    /*7884 begin
    y-n = yes.
    update y-n label
        "Do you want to update the Lines shown into (the existing) Order-lines"
           go-on("END-ERROR") with frame cons-up side-labels no-box row 22.*/
    message "Do you want to update the Lines shown into (the existing) Order-lines?"
            update y-n.
    /*7884 end*/
  end.
  else y-n = no.

  hide frame cons-fr no-pause.
  hide frame cons-up no-pause.

  if y-n = yes then do:
    ordr-line = 0.

    
    find LAST scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = domain
                                and scrtmp_sod_det.sod_nbr = sonbr no-error.
    if avail scrtmp_sod_det then ordr-line = scrtmp_sod_det.sod_line.

    for each cons-ld where cons-updated = true:

      if cons-sod-line = ? then do:

        ordr-line = ordr-line + 1.
        for last ih_hist no-lock where ih_domain = domain
                                   and ih_nbr = sonbr use-index ih_nbr:
          find idh_hist no-lock where idh_domain = domain
                                  and idh_inv_nbr = ih_inv_nbr
                                  and idh_nbr = ih_nbr
                                  and idh_line = ordr-line no-error.
          do while avail idh_hist:
            ordr-line = ordr-line + 1.
            find idh_hist no-lock where idh_domain = domain
                                    and idh_inv_nbr = ih_inv_nbr
                                    and idh_nbr = ih_nbr
                                    and idh_line = ordr-line no-error.
          end.
        end.
        
        run create-sod(domain).
        
        FIND scrtmp_sod_det WHERE scrtmp_sod_det.sod_domain = domain
                                and scrtmp_sod_det.sod_nbr = sonbr
                                and scrtmp_sod_det.sod_line = ordr-line.
        
        assign cons-sod-line = ordr-line
               scrtmp_sod_det.sod_part = cons-part
               scrtmp_sod_det.sod_serial = cons-lot
               scrtmp_sod_det.sod_tax_env = scrtmp_so_mstr.so_tax_env
               scrtmp_sod_det.sod_lot = cons-ref
               scrtmp_sod_det.sod_um = "EA"
               scrtmp_sod_det.sod__chr02 = cError.
        find pt_mstr no-lock where pt_domain = wh-domain
                               and pt_part = scrtmp_sod_det.sod_part no-error.
        if avail pt_mstr then do:
          /* Do not use item tax class for Canary Islands */
          if scrtmp_sod_det.sod_taxc = "" and not can-do("810", scrtmp_sod_det.sod_site)
          then scrtmp_sod_det.sod_taxc = pt_taxc.
          if (scrtmp_sod_det.sod_taxc begins "N" and scrtmp_so_mstr.so_site = "110") or
         (scrtmp_sod_det.sod_taxc begins "B" and scrtmp_so_mstr.so_site = "200" and scrtmp_sod_det.sod_tax_env begins "BE")
            then scrtmp_sod_det.sod_tax_env = scrtmp_so_mstr.so_tax_env + "-" + scrtmp_sod_det.sod_taxc.

          assign scrtmp_sod_det.sod_site = scrtmp_so_mstr.so_site
                 scrtmp_sod_det.sod_um = pt_um
                 scrtmp_sod_det.sod_fr_wt = pt_ship_wt
                 scrtmp_sod_det.sod_fr_wt_um = pt_ship_wt_um
                 scrtmp_sod_det.sod_prodline = pt_prod_line.
        end.
        else assign scrtmp_sod_det.sod_type = "M"
                    scrtmp_sod_det.sod_desc = "Unknow Item".

        run "so/sopart.p" (scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_ship,?,input-output scrtmp_sod_det.sod_part,
                              output cp-part,output scrtmp_sod_det.sod_custpart).

        /* RUN SaveDataToDSTT. */
        /* run "zu/zusodsls.p" (domain,scrtmp_sod_det.sod_nbr,scrtmp_sod_det.sod_line). */
        run "zu/zusodsls.p" (INPUT BUFFER scrtmp_so_mstr:HANDLE, INPUT BUFFER scrtmp_sod_det:HANDLE). 
        /* RUN SaveDataFromDSTT. */

        if scrtmp_so_mstr.so_req_date = ? then scrtmp_sod_det.sod_req_date = scrtmp_sod_det.sod_due_date.
        if prom-date = ? then scrtmp_sod_det.sod_per_date = scrtmp_sod_det.sod_due_date.

        run "aw/awgetimv.p" (scrtmp_sod_det.sod_part,scrtmp_so_mstr.so_cust,output scrtmp_sod_det.sod_slspsn[1]).
                           
        IF lRollBack THEN 
          run "zu/zuprice.p" (no,
                              domain,
                              scrtmp_so_mstr.so_site,
                              scrtmp_so_mstr.so_cust,
                              scrtmp_so_mstr.so_curr,
                              scrtmp_sod_det.sod_part,
                              1,
                              scrtmp_sod_det.sod_um,
                              today,
                              output scrtmp_sod_det.sod_list_pr,
                             output scrtmp_sod_det.sod_price).
        ELSE DO:          
          FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                                  AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                                  AND ttApiPrice.ttpart = scrtmp_sod_det.sod_part
                                  EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE ttApiPrice THEN DO:
            ./ MESSAGE "Get API price 6" VIEW-AS ALERT-BOX.          
            /* cError = GetItemPrice(scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_curr,scrtmp_sod_det.sod_part,"1",TODAY). palletd*/
        li_surcacc = 0.
            cError = GetItemPrice(scrtmp_so_mstr.so_cust,
                              scrtmp_so_mstr.so_curr,
                  scrtmp_sod_det.sod_part,
                  "1",
                  string(cons-qty-all),
                  TODAY). /* palletd */
        IF cError = "" THEN 
              FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                                      AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                                      AND ttApiPrice.ttpart = scrtmp_sod_det.sod_part 
                                      EXCLUSIVE-LOCK NO-ERROR.                   
            ELSE 
              ASSIGN scrtmp_sod_det.sod__chr02 = cError.
          END.      
          IF AVAILABLE ttApiPrice 
      THEN do: /* surcharge */
            ASSIGN scrtmp_sod_det.sod_list_pr = ttApiPrice.ttprice * GetUomConv(scrtmp_sod_det.sod_part,scrtmp_sod_det.sod_um)
                   scrtmp_sod_det.sod_price = ttApiPrice.ttprice * GetUomConv(scrtmp_sod_det.sod_part,scrtmp_sod_det.sod_um)
                   /*scrtmp_sod_det.sod__chr06 = string(ttApiPrice.ttprice) /* RFC-3012 */  CEPS-301*/
           scrtmp_sod_det.sod__chr07 = IF ttApiPrice.ttPriceId NE 0 THEN STRING(ttApiPrice.ttPriceID) ELSE "0"
                   scrtmp_sod_det.sod__chr08 = IF ttApiPrice.ttDiscId NE 0 THEN STRING(ttApiPrice.ttDiscID) ELSE "0" 
           scrtmp_sod_det.sod__chr04 = if ttapiprice.ttsurchargeperc ne 0 
                                       then string(ttapiprice.ttsurchargeperc) else "0" /* surcharge */
                   scrtmp_sod_det.sod__chr02 = "OK".

            if ttapiprice.ttsurchargeperc ne 0                           
               and  not can-find(first xxsurc_det                    
              where xxsurc_domain = scrtmp_sod_det.sod_domain              
            and xxsurc_cust   = scrtmp_so_mstr.so_cust                 
            and xxsurc_part   = scrtmp_sod_det.sod_part                
            and xxsurc_nbr    = scrtmp_sod_det.sod_nbr                 
            and xxsurc_line   = scrtmp_sod_det.sod_line)               
           then       
               assign
              li_surcacc = 0.
                  cError = GetItemPrice(scrtmp_so_mstr.so_cust,             
                                 scrtmp_so_mstr.so_curr,             
                             scrtmp_sod_det.sod_part,            
                                    "1",
                     string(cons-qty-all), /* palletd */
                                   scrtmp_sod_det.sod_pricing_dt).     
                                                                           
                                                                            
      end. /* IF AVAILABLE ttApiPrice  */                               
      /* surcharge ADD ENDS */              

          ELSE DO:
            IF cError NE "" THEN 
              ASSIGN scrtmp_sod_det.sod__chr02 = cError.
          END.
        END. 
                                     
        if scrtmp_sod_det.sod_list_pr <> scrtmp_sod_det.sod_price and
           scrtmp_sod_det.sod_list_pr <> 0  and decimal(scrtmp_sod_det.sod__chr04) =  0 /* surcharge */ 
       then
             scrtmp_sod_det.sod_disc_pct = (1 - (scrtmp_sod_det.sod_price / scrtmp_sod_det.sod_list_pr)) * 100.
      /*  else scrtmp_sod_det.sod_disc_pct = 0.  RFC-2889*/
/*RFC-2889 ADD BEGINS*/
        else if scrtmp_sod_det.sod_list_pr <> 0 
        then do:
           scrtmp_sod_det.sod_disc_pct = if available ttapiprice then ttapiprice.ttdiscperc else 0.
           if scrtmp_sod_det.sod_disc_pct <> 0 
           then
              scrtmp_sod_det.sod_price = (scrtmp_sod_det.sod_list_pr * (100 - scrtmp_sod_det.sod_disc_pct)) / 100.
           else 
              scrtmp_sod_det.sod_price = scrtmp_sod_det.sod_list_pr.
        end.  /*else if scrtmp_sod_det.sod_list_pr <> 0*/ 
/*RFC-2889 ADD ENDS*/      
    /* surcharge ADD BEGINS */
        if dec(scrtmp_sod_det.sod__chr04) > 0 
    then 
     /* scrtmp_sod_det.sod_price   =    scrtmp_sod_det.sod_price 
                                 + (scrtmp_sod_det.sod_list_pr 
                     * (scrtmp_sod_det.sod_list_pr * (dec(scrtmp_sod_det.sod__chr04) / 100))). 
                     INC54554*/
        /* surcharge ADD ENDS */
       scrtmp_sod_det.sod_price = scrtmp_sod_det.sod_price 
                              + (scrtmp_sod_det.sod_price * dec(scrtmp_sod_det.sod__chr04) / 100). /* INC54554 */
            
      end.
/*CEPS-301 ADD BEGINS*/      
      scrtmp_sod_det.sod__chr06 = string(fn_getnetprice(ttApiPrice.ttprice,
                                         scrtmp_sod_det.sod_disc_pct,
                                         decimal(scrtmp_sod_det.sod__chr04))).
/*CEPS-301 ADD BEGINS*/                                        
                                         
      FIND scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                     and scrtmp_sod_det.sod_nbr = sonbr
                     and scrtmp_sod_det.sod_line = cons-sod-line.
      IF AVAIL scrtmp_sod_det THEN
      DO :
      
      
         assign  old-qty-ord = scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_um_conv
                 scrtmp_sod_det.sod_qty_ord = cons-qty-all
                 old-qty-all = (scrtmp_sod_det.sod_qty_all + scrtmp_sod_det.sod_qty_pick) * scrtmp_sod_det.sod_um_conv
                 scrtmp_sod_det.sod_qty_pick = cons-qty-all
                 scrtmp_sod_det.sod_qty_all = 0.        
        
        /*
        DEFINE VARIABLE dSodQtyPickOld# AS DECIMAL     NO-UNDO.
        DEFINE VARIABLE dSodQtyAllOld# AS DECIMAL     NO-UNDO.
        
        DO TRANSACTION
           ON ERROR UNDO, RETURN ERROR:
          FOR EACH sod_det EXCLUSIVE WHERE sod_det.sod_domain = domain
                                     AND sod_det.sod_nbr = sonbr
                                     AND sod_det.sod_line = cons-sod-line:
            ASSIGN dSodQtyPickOld#      = sod_det.sod_qty_pick
                   dSodQtyAllOld#       = sod_det.sod_qty_all
                   sod_det.sod_qty_pick = scrtmp_sod_det.sod_qty_pick
                   sod_det.sod_qty_all  = scrtmp_sod_det.sod_qty_all
                   .
          END.                                     
        END.
        */
        
        FIND FIRST tt-sod_cosign WHERE tt-sod_cosign.xsod_domain = scrtmp_sod_det.sod_domain 
                                   AND tt-sod_cosign.xsod_nbr    = scrtmp_sod_det.sod_nbr
                                   AND tt-sod_cosign.xsod_line   = scrtmp_sod_det.sod_line NO-ERROR.
        IF NOT AVAIL tt-sod_cosign
        THEN DO:
          FIND FIRST sod_det NO-LOCK WHERE sod_det.sod_domain = domain
                                       AND sod_det.sod_nbr = sonbr
                                       AND sod_det.sod_line = cons-sod-line NO-ERROR.
        
          CREATE tt-sod_cosign.
          ASSIGN tt-sod_cosign.xsod_domain = scrtmp_sod_det.sod_domain 
                 tt-sod_cosign.xsod_nbr    = scrtmp_sod_det.sod_nbr
                 tt-sod_cosign.xsod_line   = scrtmp_sod_det.sod_line
                 .
          IF AVAIL sod_det
          THEN ASSIGN tt-sod_cosign.xsod_qty_all  = sod_det.sod_qty_all
                      tt-sod_cosign.xsod_qty_pick = sod_det.sod_qty_pick.
                      
          VALIDATE tt-sod_cosign.   
        END.
                       
        if scrtmp_sod_det.sod_qty_ord = 0 and scrtmp_sod_det.sod_qty_all = 0 and scrtmp_sod_det.sod_qty_pick = 0 then DO:
           scrtmp_sod_det.operation = "R".
         END.   
         
        /*
        RUN SetNextCallForceUpdateFields IN hProc# (INPUT "sod_qty_pick"). 
        RUN SaveSoLocal(INPUT FALSE, OUTPUT lErro#).
        IF lErro# 
        THEN DO:
            DO TRANSACTION
               ON ERROR UNDO, RETURN ERROR:
              FOR EACH sod_det EXCLUSIVE WHERE sod_det.sod_domain = domain
                                         AND sod_det.sod_nbr = sonbr
                                         AND sod_det.sod_line = cons-sod-line:
                ASSIGN sod_det.sod_qty_pick = dSodQtyPickOld#
                       sod_det.sod_qty_all  = dSodQtyAllOld#.
              END.                                     
            END.        
           RETURN.
        END.
        */
        
        FIND scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                              and scrtmp_sod_det.sod_nbr = sonbr
                              and scrtmp_sod_det.sod_line = cons-sod-line.       
      
        DO TRANSACTION 
            ON ERROR UNDO, RETURN ERROR:


          find ld_det where ld_domain = domain
                        and ld_site = scrtmp_sod_det.sod_site
                        and ld_part = scrtmp_sod_det.sod_part
                        and ld_loc = scrtmp_sod_det.sod_loc
                        and ld_lot = scrtmp_sod_det.sod_serial
                        and ld_ref = scrtmp_sod_det.sod_lot no-error.
          if avail ld_det then do:
            find lad_det where lad_domain = domain
                           and lad_dataset = "sod_det"
                           and lad_nbr = scrtmp_sod_det.sod_nbr
                           and lad_line = string(scrtmp_sod_det.sod_line)
                           and lad_part = scrtmp_sod_det.sod_part
                           and lad_site = scrtmp_sod_det.sod_site
                           and lad_loc = scrtmp_sod_det.sod_loc
                           and lad_lot = scrtmp_sod_det.sod_serial
                           and lad_ref = scrtmp_sod_det.sod_lot no-error.
            if not avail lad_det then do:
              create lad_det.
              assign lad_domain = domain
                     lad_dataset = "sod_det"
                     lad_nbr = scrtmp_sod_det.sod_nbr
                     lad_line = string(scrtmp_sod_det.sod_line)
                     lad_part = scrtmp_sod_det.sod_part
                     lad_site = scrtmp_sod_det.sod_site
                     lad_loc = scrtmp_sod_det.sod_loc
                     lad_lot = scrtmp_sod_det.sod_serial
                     lad_ref = scrtmp_sod_det.sod_lot.
            end. /* if not avail ld_det */
            assign lad_qty_pick = scrtmp_sod_det.sod_qty_pick * scrtmp_sod_det.sod_um_conv
                   ld_qty_all = ld_qty_all - lad_qty_all + lad_qty_pick
                   lad_qty_all = 0.
            if lad_qty_all = 0 and lad_qty_pick = 0 then delete lad_det.

            if ld__chr02 <> "" then DO:
              find xxdeliv_mstr where xxdeliv_domain = domain
                                  and xxdeliv_nbr = scrtmp_sod_det.sod_nbr
                                  and xxdeliv_line = scrtmp_sod_det.sod_line
                                  and xxdeliv_ship = ld__chr02 no-error.
              if not avail xxdeliv_mstr then do:
                create xxdeliv_mstr.
                assign xxdeliv_domain = domain
                       xxdeliv_nbr = scrtmp_sod_det.sod_nbr
                       xxdeliv_line = scrtmp_sod_det.sod_line
                       xxdeliv_ship = ld__chr02
                       xxdeliv_part = scrtmp_sod_det.sod_part.
              end.
              assign xxdeliv_date = ld__dte01
                     xxdeliv_qty = xxdeliv_qty + scrtmp_sod_det.sod_qty_ord.
            end. /* if ld__chr02 <> "" */
          end. /* if avail ld_det */

          find in_mstr where in_domain = domain
                         and in_site = scrtmp_sod_det.sod_site
                         and in_part = scrtmp_sod_det.sod_part EXCLUSIVE no-error.
          if avail in_mstr then assign
            in_qty_req = in_qty_req - old-qty-ord + cons-qty-all * scrtmp_sod_det.sod_um_conv
            in_qty_all = in_qty_all - old-qty-all + cons-qty-all * scrtmp_sod_det.sod_um_conv.

          IF AVAIL in_mstr
          THEN RELEASE in_mstr.
          
          IF AVAIL ld_det
          THEN RELEASE ld_det.
          
          IF AVAIL lad_det
          THEN RELEASE lad_det.
          
          IF AVAIL fcs_sum
          THEN RELEASE fcs_sum.
          
          IF AVAIL xxdeliv_mstr
          THEN RELEASE xxdeliv_mstr.
        
        END.
        

        
       END.
    end. /* for each cons-ld */
  end. /* if y-n = yes */

end procedure. /* consign-invoice */
/***************************************************************************/


/**************************************************************************/
procedure super-session:

  def input parameter domain as char.

  if scrtmp_so_mstr.so_domain <> domain THEN MESSAGE "super-session alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
  
  so-curr = scrtmp_so_mstr.so_curr.
  FIND scrtmp_sod_det where scrtmp_sod_det.sod_domain = domain
                                and scrtmp_sod_det.sod_nbr = sonbr
                                and scrtmp_sod_det.sod_line = ordr-line.

  suse-item = scrtmp_sod_det.sod_part.

  find pt_mstr no-lock where pt_domain = domain
                         and pt_part = scrtmp_sod_det.sod_part no-error.
  if not avail pt_mstr then return.

  pause 0 before-hide.

  for each suse-list:
    delete suse-list.
  end.

  if can-do("3,4,5,8,Z",pt_status) /* MLQ00060 can-do("5,8,Z",pt_status) */ then do:
    RUN SaveDataToDSTT.
    run "zu/zusodrst.p" (domain,scrtmp_sod_det.sod_nbr,pt_part,scrtmp_so_mstr.so_site,show-mess,
                                      output cust-restr,output msg-txt).
    if not cust-restr then do:
      create suse-list.
      suse-part = pt_part.
    end.
/*    else return.*/
  end.

  message "Checking supersession ...".

  assign suse-item = pt_article
         show-mess = no.

  /* search backward */
  do while avail pt_mstr:
    find pt_mstr no-lock where pt_domain = domain
                           and pt_part = suse-item no-error.
    if avail pt_mstr then do:
      if can-do("3,4,5,8,Z",pt_status) /* MLQ00060 can-do("5,8,Z",pt_status) */ then do:

        RUN SaveDataToDSTT.
        run "zu/zusodrst.p" (domain,scrtmp_sod_det.sod_nbr,pt_part,scrtmp_so_mstr.so_site,show-mess,
                                          output cust-restr,output msg-txt).

        if not can-find(suse-list where suse-part = pt_part) then do:
          if not cust-restr then do:
            create suse-list.
            suse-part = pt_part.
          end.
        end.
        else leave. /* circular assignment */
      end.
      suse-item = pt_article.
    end.  
  end.

  /* search forward */
  suse-item = scrtmp_sod_det.sod_part.
  repeat:
    find qad_wkfl no-lock where qad_domain = "XX"
                            and qad_key1 = "SUPERSESSION"
                            and qad_key2 = suse-item
                            and qad_key3 = "SUPERSESSION"
                            and qad_key4 = suse-item
                            and qad_key5 = "SUPERSESSION"
                            and qad_key6 = suse-item no-error.
    if not avail qad_wkfl then leave.
    find pt_mstr no-lock where pt_domain = domain
                           and pt_part = qad_charfld[1] no-error.
    if avail pt_mstr then do:
      if can-do("3,4,5,8,Z",pt_status) /* MLQ00060  can-do("5,8,Z",pt_status) */  then do:
        RUN SaveDataToDSTT.
        run "zu/zusodrst.p" (domain,scrtmp_sod_det.sod_nbr,pt_part,scrtmp_so_mstr.so_site,show-mess,
                                          output cust-restr,output msg-txt).
        if cust-restr then do:
          suse-item = pt_part.
          next.
        end.
        if not can-find(suse-list where suse-part = pt_part) then do:
          create suse-list.
          suse-part = pt_part.
        end.
        else leave. /* circular assignment */
      end.
      suse-item = pt_part.
    end.
    else if avail pt_mstr then suse-item = pt_part.
  end.

  /* Display all active supersession items */
  for each suse-list:
    assign suse-um = scrtmp_sod_det.sod_um
           suse-conv = 1.

    find pt_mstr no-lock where pt_domain = domain
                           and pt_part = suse-part no-error.

    find um_mstr no-lock where um_domain = domain
                           and um_part = suse-part
                           and um_um = pt_um
                           and um_alt_um = 'CS' no-error.
    if avail um_mstr then suse-conv = um_conv.
    
                             
    IF lRollBack THEN 
      run "zu/zuprice.p" (no,domain,scrtmp_so_mstr.so_site,scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_curr,suse-part,1,
                             'CS',today,output list-pr,output suse-price).          
    ELSE DO:
      list-pr = 0.
      suse-price = 0. 
      FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                              AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                              AND ttApiPrice.ttpart = scrtmp_sod_det.sod_part
                              EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE ttApiPrice THEN DO:
        ./ MESSAGE "Get API price 7" VIEW-AS ALERT-BOX.      
        /* cError = GetItemPrice(scrtmp_so_mstr.so_cust,scrtmp_so_mstr.so_curr,suse-part,"1",TODAY). palletd*/
    li_surcacc = 0.
     cError = GetItemPrice(scrtmp_so_mstr.so_cust,
                          scrtmp_so_mstr.so_curr,
                  suse-part,
                  string(scrtmp_sod_det.sod_qty_ord),
                  string(scrtmp_sod_det.sod_um_conv),
                  TODAY). /* palletd */
        IF cError = "" THEN 
          FIND FIRST ttApiPrice WHERE ttApiPrice.ttDomain = global_domain 
                                  AND ttApiPrice.ttCsCode = scrtmp_so_mstr.so_cust 
                                  AND ttApiPrice.ttpart = scrtmp_sod_det.sod_part 
                                  EXCLUSIVE-LOCK NO-ERROR.                   
        ELSE 
          ASSIGN scrtmp_sod_det.sod__chr02 = cError.
      END.          
      IF AVAILABLE ttApiPrice 
      THEN do : /* surcharge */
        ASSIGN list-pr = ttApiPrice.ttprice * GetUomConv(suse-part,"CS")
               suse-price = ttApiPrice.ttprice * GetUomConv(suse-part,"CS")
               scrtmp_sod_det.sod__chr07 = STRING(ttApiPrice.ttPriceID) 
               scrtmp_sod_det.sod__chr08 = STRING(ttApiPrice.ttDiscID)
           scrtmp_sod_det.sod__chr04 = if ttapiprice.ttsurchargeperc ne 0 
                                   then 
                                      string(ttapiprice.ttsurchargeperc) 
                       else "0" /* surcharge */
              /* scrtmp_sod_det.sod__chr06 = string(ttApiPrice.ttprice) /* RFC-3012 */  CEPS-301*/           
               scrtmp_sod_det.sod__chr02 = "OK".
          /* surcharge ADD BEGINS */
          if ttapiprice.ttsurchargeperc ne 0                           
                 and  not can-find(first xxsurc_det                    
              where xxsurc_domain = scrtmp_sod_det.sod_domain              
                and xxsurc_cust   = scrtmp_so_mstr.so_cust                 
                and xxsurc_part   = scrtmp_sod_det.sod_part                
                and xxsurc_nbr    = scrtmp_sod_det.sod_nbr                 
                and xxsurc_line   = scrtmp_sod_det.sod_line)               
              then       
                assign
             li_surcacc = 0.
                 cError = GetItemPrice(scrtmp_so_mstr.so_cust,             
                                       scrtmp_so_mstr.so_curr,             
                                   scrtmp_sod_det.sod_part,            
                                          string(scrtmp_sod_det.sod_qty_ord), 
                           string(scrtmp_sod_det.sod_um_conv),
                                         scrtmp_sod_det.sod_pricing_dt).     
                                                                           
                                                                            
       end. /* IF AVAILABLE ttApiPrice  */                               
       /* surcharge ADD ENDS */              

      ELSE DO:
       IF cError NE "" THEN 
          ASSIGN scrtmp_sod_det.sod__chr02 = cError.
      END.
    END. 
                                                          
    suse-conv = 1.
    find um_mstr no-lock where um_domain = domain
                           and um_part = suse-part
                           and um_um = pt_um
                           and um_alt_um = scrtmp_sod_det.sod_um no-error.
    if avail um_mstr then suse-conv = um_conv.

    run "aw/awqtyavl.p" (yes,domain,emt-ordr,wh-domain,wh-site,
                             scrtmp_sod_det.sod_site,suse-part,suse-conv,scrtmp_sod_det.sod_loc,scrtmp_so_mstr.so_site,
                             scrtmp_so_mstr.so_ship,scrtmp_so_mstr.so__chr10,output suse-avl).

    if suse-avl = 0 then delete suse-list.
  end.

  assign counter = 0
         suse-item = scrtmp_sod_det.sod_part.
  for each suse-list no-lock:
    if suse-part <> scrtmp_sod_det.sod_part then counter = counter + 1.
  end.
  hide message no-pause.
  if counter = 0 then return.

  on default-action of suse-brwse-1 in frame suse-a1 do:
    assign suse-item = suse-list.suse-part.
    apply "WINDOW-CLOSE" to suse-brwse-1.
  end.

  open query suse-qry-1
  for each suse-list no-lock /*indexed-reposition*/.
  find first suse-list where suse-avl > 0 no-error.
  if not avail suse-list then
    find first suse-list where suse-part = scrtmp_sod_det.sod_part no-error.
  if avail suse-list then do:
    suse-rRowid# = rowid(suse-list).
    reposition suse-qry-1 to rowid suse-rRowid#.
  end.

  enable suse-brwse-1 with frame suse-a1.
  wait-for window-close,"END-ERROR" of current-window focus suse-brwse-1.
  hide frame suse-a1.

end procedure. /* super-session */
/****************************************************************************/
procedure find-prices:

  def input parameter fp-domain as char.

  message "Patience please, retreiving price-information ...".


  if scrtmp_so_mstr.so_domain <> fp-domain THEN MESSAGE "find=prices alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.

  FIND scrtmp_sod_det where scrtmp_sod_det.sod_domain = fp-domain
                                and scrtmp_sod_det.sod_nbr = sonbr
                                and scrtmp_sod_det.sod_line = ordr-line.

  find cm_mstr no-lock where cm_domain = fp-domain
                         and cm_addr = scrtmp_so_mstr.so_cust.
  find ad_mstr no-lock where ad_mstr.ad_domain = fp-domain
                         and ad_mstr.ad_addr = scrtmp_so_mstr.so_cust.

  for each price-list:
    delete price-list.
  end.


  for each ih_hist no-lock where ih_domain = fp-domain
                             and ih_cust = scrtmp_so_mstr.so_cust,
      each idh_hist no-lock where idh_domain = fp-domain
                              and idh_inv_nbr = ih_inv_nbr
                              and idh_nbr = ih_nbr
                              and idh_part = scrtmp_sod_det.sod_part
                              and idh_price <> 0:

    find last price-list no-lock where price-lst = "Inv-Hist"
                                   and price-code = ih_inv_nbr no-error.
    if avail price-list then counter = price-cnt + 1.
    else counter = 0.

    create price-list.
    assign price-lst = "Inv-Hist"
           price-code = ih_inv_nbr
           price-cnt = counter
           price-date = ?
           price-end = ih_inv_date
           price-curr = ih_curr
           price-um = idh_um
           price-qty = idh_qty_inv
           price-amt = idh_price.
  end.

  hide message no-pause.

  if not can-find(first price-list) then return.

  on default-action of price-brwse-1 in frame price-a1 do:
    apply "WINDOW-CLOSE" to price-brwse-1.
  end.

  open query price-qry-1 for each price-list by price-end descending.
  enable price-brwse-1 with frame price-a1.
  wait-for window-close,"END-ERROR" of current-window focus price-brwse-1.
  hide frame price-a1.

end procedure. /* find-prices */
/****************************************************************************/
procedure un-alloc-det:
  def input parameter ua-domain as char.


  FIND scrtmp_sod_det where scrtmp_sod_det.sod_domain = ua-domain
                                and scrtmp_sod_det.sod_nbr = sonbr
                                and scrtmp_sod_det.sod_line = ordr-line.

  for each lad_det where lad_domain = ua-domain
                     and lad_dataset = "sod_det"
                     and lad_nbr = scrtmp_sod_det.sod_nbr
                     and lad_line = string(scrtmp_sod_det.sod_line)
                     and lad_site = scrtmp_sod_det.sod_site
                     and lad_part = scrtmp_sod_det.sod_part:
    find ld_det where ld_domain = ua-domain
                  and ld_site = lad_site
                  and ld_part = lad_part
                  and ld_loc = lad_loc
                  and ld_lot = lad_lot
                  and ld_ref = lad_ref no-error.
    if avail ld_det then do:
      ld_qty_all = ld_qty_all - lad_qty_all - lad_qty_pick.
      if ld_qty_all < 0 then ld_qty_all = 0.
    end.

    delete lad_det.

  end.
end procedure. /* un-alloc-det */
/***************************************************************************/
procedure detail-alloc:
  def input parameter da-domain as char.
  def buffer lad_det for lad_det.
  def buffer ld_det  for ld_det.


  if scrtmp_so_mstr.so_domain <> da-domain THEN MESSAGE "detail-alloc alert -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.

  FIND scrtmp_sod_det where scrtmp_sod_det.sod_domain = da-domain
                                and scrtmp_sod_det.sod_nbr = sonbr
                                and scrtmp_sod_det.sod_line = ordr-line no-error.
  if avail scrtmp_sod_det then do:

    /* first delete old allocations */
    for each lad_det where lad_domain = wh-domain
                       and lad_dataset = "sod_det"
                       and lad_nbr = scrtmp_sod_det.sod_nbr
                       and lad_line = string(scrtmp_sod_det.sod_line):
      find ld_det where ld_domain = wh-domain
                    and ld_site = wh-site
                    and ld_part = scrtmp_sod_det.sod_part
                    and ld_loc = lad_loc
                    and ld_lot = lad_lot
                    and ld_ref = lad_ref no-error.
      if avail ld_det then ld_qty_all = ld_qty_all - lad_qty_all - lad_qty_pick.
      delete lad_det.
    end.

    find lad_det where lad_domain = wh-domain
                   and lad_dataset = "sod_det"
                   and lad_nbr = scrtmp_sod_det.sod_nbr
                   and lad_line = string(scrtmp_sod_det.sod_line)
                   and lad_site = wh-site
                   and lad_part = scrtmp_sod_det.sod_part
                   and lad_loc = scrtmp_sod_det.sod_loc
                   and lad_lot = scrtmp_sod_det.sod_serial
                   and lad_ref = scrtmp_sod_det.sod_lot no-error.
    if not avail lad_det then do:
      find ld_det no-lock where ld_domain = wh-domain
                            and ld_site = wh-site
                            and ld_part = scrtmp_sod_det.sod_part
                            and ld_loc = scrtmp_sod_det.sod_loc
                            and ld_lot = scrtmp_sod_det.sod_serial
                            and ld_ref = scrtmp_sod_det.sod_lot no-error.
      if avail ld_det then do:
        find first isd_det no-lock where isd_domain = wh-domain
                                     and isd_status = ld_status
                                     and isd_tr_type = "ISS-SO" no-error.
        if not avail isd_det then
        find first isd_det no-lock where isd_domain = wh-domain
                                     and isd_status = ld_status
                                     and isd_tr_type = "ORD-SO" no-error.
        if avail isd_det then next.

        find ld_det where ld_domain = wh-domain
                      and ld_site = wh-site
                      and ld_part = scrtmp_sod_det.sod_part
                      and ld_loc = scrtmp_sod_det.sod_loc
                      and ld_lot = scrtmp_sod_det.sod_serial
                      and ld_ref = scrtmp_sod_det.sod_lot no-error.
        ld_qty_all = ld_qty_all + scrtmp_sod_det.sod_qty_all * scrtmp_sod_det.sod_um_conv.
        create lad_det.
        assign lad_domain = wh-domain
               lad_dataset = "sod_det"
               lad_nbr = scrtmp_sod_det.sod_nbr
               lad_line = string(scrtmp_sod_det.sod_line)
               lad_site = wh-site
               lad_part = scrtmp_sod_det.sod_part
               lad_loc = scrtmp_sod_det.sod_loc
               lad_lot = scrtmp_sod_det.sod_serial
               lad_ref = scrtmp_sod_det.sod_lot
               lad_qty_all = scrtmp_sod_det.sod_qty_all * scrtmp_sod_det.sod_um_conv.
      end.
    end.
  end.
end procedure. /* detail-alloc */
/***************************************************************************/
procedure order-wrap-up:

  def input parameter ow-domain as char.

  def buffer emtsom for so_mstr.
  def buffer emtsod FOR sod_det.

  def buffer scrtmp_sod_det for scrtmp_sod_det.

  find first soc_ctrl no-lock where soc_domain = ow-domain.

  if scrtmp_so_mstr.so_domain <> ow-domain THEN MESSAGE "order-wrap-up -> check code"
                                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.

  scrtmp_so_mstr.so_print_pl = old-print-pl.
  /*
  PUBLISH "OverRuleSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                               INPUT scrtmp_so_mstr.so_nbr,
                               INPUT scrtmp_so_mstr.so_print_pl).
  */
  
  /* Common HI logic, reset status */
  if scrtmp_so_mstr.so_stat <> "HD" and not can-do("700,710",scrtmp_so_mstr.so_site) then scrtmp_so_mstr.so_stat = "".

  /* Common HI logic, zero price check */
  /*  if scrtmp_so_mstr.so_stat <> "HD" then RFC-2587*/
    for each scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = ow-domain
                               and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr
                               and scrtmp_sod_det.sod_type = "":
    if scrtmp_sod_det.sod_price = 0 and can-do(",INVOICE,RUSH",scrtmp_so_mstr.so__chr10) and
      not can-do("SAMPLES,DISCOUN,HARDWAR,MEDIREP,MEDINEW,BACKORD",scrtmp_sod_det.sod__chr10)
    THEN DO: 
       if scrtmp_so_mstr.so_stat <> "HD" 
       then           /*RFC-2587 */
          assign scrtmp_so_mstr.so_stat     = "HI"
                 scrtmp_so_mstr.so_print_pl = no
                 old-print-pl               = NO.
       else 
          assign   
         scrtmp_so_mstr.so_print_pl = no
             old-print-pl               = NO.    /*RFC-2587*/

        PUBLISH "OverRuleSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                                     INPUT scrtmp_so_mstr.so_nbr,
                                     INPUT scrtmp_so_mstr.so_print_pl).
               

    END.
  end.

  /* Hold-Invoice Status */
  if new-order and can-do("700,710",scrtmp_so_mstr.so_site) then DO:
      scrtmp_so_mstr.so_print_pl = NO.
      old-print-pl = NO.
      
      
      PUBLISH "OverRuleSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                                   INPUT scrtmp_so_mstr.so_nbr,
                                   INPUT scrtmp_so_mstr.so_print_pl).      
      
      RUN SetSoLocks IN hProc# (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, INPUT THIS-PROCEDURE, OUTPUT cErro#). 
      /* {us/bbi/gprun.i ""zusosetblk.p"" " (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, OUTPUT cErro#, OUTPUT lOk#)" } */
  END.
  if scrtmp_so_mstr.so_nbr begins "IH" and scrtmp_so_mstr.so_stat = "" then scrtmp_so_mstr.so_stat = "HI".

  if scrtmp_so_mstr.so_stat <> "HD" and can-do("800,810,880,900",scrtmp_so_mstr.so_site) and
     can-do(",INVOICE",scrtmp_so_mstr.so__chr10) then do:

    for each scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = ow-domain
                               and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr
                               and scrtmp_sod_det.sod_type = "":

      if can-do("800,810,880",scrtmp_so_mstr.so_site) then do:
        if scrtmp_sod_det.sod_price = 0 THEN DO:
             assign scrtmp_so_mstr.so_stat = "HI"
                    scrtmp_so_mstr.so_print_pl = no.
             old-print-pl = NO.                                     
             PUBLISH "OverRuleSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                                          INPUT scrtmp_so_mstr.so_nbr,
                                          INPUT scrtmp_so_mstr.so_print_pl).  
                                                       
            RUN SetSoLocks IN hProc# (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, INPUT THIS-PROCEDURE, OUTPUT cErro#).                                      
            /* {us/bbi/gprun.i ""zusosetblk.p"" " (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, OUTPUT cErro#, OUTPUT lOk#)" } */
        END.
        next.
      end.

      IF lRollBack THEN DO:
        find last xxprl_mstr where xxprl_mstr.xxprl_domain = ow-domain
                               and xxprl_mstr.xxprl_list = "GENERAL"
                               and xxprl_mstr.xxprl_cs_code = "PL1"
                               and xxprl_mstr.xxprl_part_code = scrtmp_sod_det.sod_part
                               and xxprl_mstr.xxprl_curr      = scrtmp_so_mstr.so_curr
                               and xxprl_mstr.xxprl_um        = "CS"
                               and (xxprl_mstr.xxprl_start LE scrtmp_sod_det.sod_pricing_dt or
                                    xxprl_mstr.xxprl_start = ?)
                               and (xxprl_mstr.xxprl_expire GE scrtmp_sod_det.sod_pricing_dt or
                                    xxprl_mstr.xxprl_expire = ?)
                               no-lock no-error.
        if avail xxprl_mstr then do:
          find last xxprld_det where xxprld_det.xxprld_domain = ow-domain
                        and xxprld_det.xxprld_list_id = xxprl_mstr.xxprl_list_id
                        and xxprld_det.xxprld_qty <= int(abs(scrtmp_sod_det.sod_qty_ord))
                        no-lock no-error.
          if avail xxprld_det then do:
            if xxprld_det.xxprld_amt <= scrtmp_sod_det.sod_price THEN DO:
              assign scrtmp_so_mstr.so_stat = "HI"
                     scrtmp_so_mstr.so_print_pl = no.
              old-print-pl = NO.
                   
            PUBLISH "OverRuleSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                                         INPUT scrtmp_so_mstr.so_nbr,
                                         INPUT scrtmp_so_mstr.so_print_pl).                   
                                                     
            RUN SetSoLocks IN hProc# (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, INPUT THIS-PROCEDURE, OUTPUT cErro#).                                      
            /* {us/bbi/gprun.i ""zusosetblk.p"" " (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, OUTPUT cErro#, OUTPUT lOk#)" } */
          END.
        end.
        else do:
            assign scrtmp_so_mstr.so_stat = "HI"
                    scrtmp_so_mstr.so_print_pl = no.
            OLD-print-pl = NO.
                    
            PUBLISH "OverRuleSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                                         INPUT scrtmp_so_mstr.so_nbr,
                                         INPUT scrtmp_so_mstr.so_print_pl).                    
                                                     
            RUN SetSoLocks IN hProc# (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, INPUT THIS-PROCEDURE, OUTPUT cErro#).                                              
            /* {us/bbi/gprun.i ""zusosetblk.p"" " (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, OUTPUT cErro#, OUTPUT lOk#)" } */
        END.
      end.
      else DO:
          assign scrtmp_so_mstr.so_stat = "HI"
                  scrtmp_so_mstr.so_print_pl = no.
          old-print-pl = NO.
          
          PUBLISH "OverRuleSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                                       INPUT scrtmp_so_mstr.so_nbr,
                                       INPUT scrtmp_so_mstr.so_print_pl).                  
                                                 
          RUN SetSoLocks IN hProc# (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, INPUT THIS-PROCEDURE, OUTPUT cErro#).       
          /* {us/bbi/gprun.i ""zusosetblk.p"" "(INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, OUTPUT cErro#, OUTPUT lOk#)" } */
        END.
      END. /* if lRollBack */ 
      ELSE DO:
        FIND FIRST ttStdPrice WHERE ttStdPrice.ttDomain = global_domain 
                                AND ttStdPrice.PriceListName = scrtmp_so_mstr.so_domain + "_Standard_Pricelist" 
                                AND ttStdPrice.ItemCode = scrtmp_sod_det.sod_part
                                EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE ttStdPrice THEN DO:
          ./ MESSAGE "Get standart price " VIEW-AS ALERT-BOX.
          cError = GetItemStdPrice(scrtmp_so_mstr.so_domain,scrtmp_sod_det.sod_part,scrtmp_sod_det.sod_pricing_dt).
          IF cError = "" THEN 
            FIND FIRST ttStdPrice WHERE ttStdPrice.ttDomain = global_domain 
                                    AND ttStdPrice.PriceListName = scrtmp_so_mstr.so_domain + "_Standard_Pricelist" 
                                    AND ttStdPrice.ItemCode = scrtmp_sod_det.sod_part
                                    EXCLUSIVE-LOCK NO-ERROR.
          ELSE
            ASSIGN scrtmp_sod_det.sod__chr02 = cError.          
        END.
        
        IF AVAILABLE ttStdPrice THEN
        DO:
          IF (ttStdPrice.UnitPrice * GetUomConv(scrtmp_sod_det.sod_part,scrtmp_sod_det.sod_um)) <= scrtmp_sod_det.sod_price THEN 
          DO:
            assign scrtmp_so_mstr.so_stat = "HI"
                   scrtmp_so_mstr.so_print_pl = no.
            old-print-pl = NO.
                   
            PUBLISH "OverRuleSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                                         INPUT scrtmp_so_mstr.so_nbr,
                                         INPUT scrtmp_so_mstr.so_print_pl).                   
                                                     
            RUN SetSoLocks IN hProc# (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, INPUT THIS-PROCEDURE, OUTPUT cErro#).                                      
            /* {us/bbi/gprun.i ""zusosetblk.p"" " (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, OUTPUT cErro#, OUTPUT lOk#)" } */
          END.                                          
        END.
        ELSE DO:
          assign scrtmp_so_mstr.so_stat = "HI"
                 scrtmp_so_mstr.so_print_pl = NO.
          OLD-print-pl = NO.
                    
          PUBLISH "OverRuleSoPrintPl" (INPUT scrtmp_so_mstr.so_domain,
                                       INPUT scrtmp_so_mstr.so_nbr,
                                       INPUT scrtmp_so_mstr.so_print_pl).                    
                                                      
          RUN SetSoLocks IN hProc# (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, INPUT THIS-PROCEDURE, OUTPUT cErro#).                                              
          /* {us/bbi/gprun.i ""zusosetblk.p"" " (INPUT scrtmp_so_mstr.so_domain, INPUT scrtmp_so_mstr.so_nbr, OUTPUT cErro#, OUTPUT lOk#)" } */            
        END.                     
      END.
    end. /* for each scrtmp_sod_det */
  end. /* can-do("900",scrtmp_so_mstr.so_site) */

  /* Small order-costs */
  find cm_mstr no-lock where cm_mstr.cm_domain = ow-domain
                         and cm_mstr.cm_addr = scrtmp_so_mstr.so_cust no-error.
  if not can-do("INVOICE",scrtmp_so_mstr.so__chr10)
     and not can-find(FIRST scrtmp_sod_det where scrtmp_sod_det.sod_domain = ow-domain
                                      and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr
                                  and (scrtmp_sod_det.sod_qty_ship <> 0 or scrtmp_sod_det.sod_qty_pick <> 0))
     and not can-find(first ih_hist where ih_domain = domain
                                      and ih_nbr = scrtmp_so_mstr.so_nbr) then do:
    /* if cm_mstr.cm__log01 = yes then do: PCM-112 */
      assign  
         l_vat  = 0 /* RFC508 */
         line-tot = 0.
      for each scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = ow-domain
                                 and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr:
        /* RFC508 ADD BEGINS */
        run "av/avgettax.p" (domain,scrtmp_sod_det.sod_tax_env,scrtmp_sod_det.sod_taxc,scrtmp_sod_det.sod_tax_usage,
                            tax-date,output vat-pct,output vat-pcth,output vat-pctl). 
        if vat-pct > l_vat 
        then
           l_vat = vat-pct.
        /* RFC508 ADD ENDS */
        line-tot = line-tot + scrtmp_sod_det.sod_qty_ord * scrtmp_sod_det.sod_price.
      end.
      find ad_mstr no-lock where ad_mstr.ad_domain = ow-domain
                             and ad_mstr.ad_addr = scrtmp_so_mstr.so_cust no-error.
       /**** CEPS-850 DELETE BEGINS                                    
      find xxsocst_det no-lock where xxsocst_ctry = ow-domain
                                 and xxsocst_curr = scrtmp_so_mstr.so_curr
                                 and xxsocst_type = cm_mstr.cm_type no-error.
      *****CEPS-850 DELETE ENDS */    
      /* CEPS-850 ADD BEGINS */                             
      find xxsocst_det no-lock 
         where xxsocst_ctry = ow-domain
           and xxsocst_curr = scrtmp_so_mstr.so_curr
           and xxsocst_addr = scrtmp_so_mstr.so_cust  
       no-error.    
      /* CEPS-850 ADD ENDS */      
      
         /* CEPS-850 DELETE BEGINS     
        find xxsocst_det no-lock where xxsocst_ctry = ow-domain
                                   and xxsocst_curr = scrtmp_so_mstr.so_curr
                                   and xxsocst_type = "" no-error.
       ****CEPS-850 DELETE ENDS */
       /* CEPS-850 ADD BEGINS */
       if not avail xxsocst_det 
       then
           find xxsocst_det no-lock 
              where xxsocst_ctry = ow-domain
                and xxsocst_curr = scrtmp_so_mstr.so_curr
                and xxsocst_addr = "" 
           no-error.
        /* CEPS-850 ADD ENDS */    
         
      if avail xxsocst_det then do:
      /*  if line-tot > 0 and line-tot < xxsocst_amt then do: RFC506 */
      
      if line-tot >= 0 and line-tot < xxsocst_amt 
         and not can-do("samples,HARDWAR,CONSIGN,CENTRAL",scrtmp_so_mstr.so__chr10) /* 3267 */
      then do: /*RFC506*/
        /* RFC508 ADD BEGINS */
        if xxsocst_ctry = "NL"
        then do:
           if l_vat > 9  /* INC07755 */
           then
              scrtmp_so_mstr.so_trl3_cd = "50".
           else
              scrtmp_so_mstr.so_trl3_cd = "52".  
        end.
        else
           scrtmp_so_mstr.so_trl3_cd = "50".
        /* RFC508 ADD ENDS */
       scrtmp_so_mstr.so_trl3_amt = xxsocst_cost.
       if can-do("6400,8300,6510,8410,6520,8420,6530,8430,6540,8440,6550,8450",
                    cm_mstr.cm_type) then scrtmp_so_mstr.so_trl3_cd = "51".
        end.
        else assign scrtmp_so_mstr.so_trl3_cd = ""
                    scrtmp_so_mstr.so_trl3_amt = 0.
      end.
      else assign scrtmp_so_mstr.so_trl3_cd = ""
                  scrtmp_so_mstr.so_trl3_amt = 0.
    /**** PCM-112 DELETE BEGINS 
    end.
    else assign scrtmp_so_mstr.so_trl3_cd = ""
                scrtmp_so_mstr.so_trl3_amt = 0.
    ******PCM-112 DELETE ENDS */
  end. /* Small-order costs */

  put screen row 23 col 1 "                                   ".

  if can-find(FIRST scrtmp_sod_det where scrtmp_sod_det.sod_domain = ow-domain
                              and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr
                              and scrtmp_sod_det.sod_type = ""
                              and scrtmp_sod_det.sod_qty_ord -
                              (scrtmp_sod_det.sod_qty_all + scrtmp_sod_det.sod_qty_pick + scrtmp_sod_det.sod_qty_ship) > 0
                              and scrtmp_sod_det.sod_due_date <= today + soc_all_days)
  then do:
    txt = "".
    for each xxbrl_det no-lock where xxbrl_child = "C-" + scrtmp_so_mstr.so_cust,
        each ad_mstr no-lock where ad_mstr.ad_bus_rel = xxbrl_parent:
      txt = txt + xxbrl_parent + " " + ad_mstr.ad_name
                  + fill(" ",50 - length(ad_mstr.ad_name)) + chr(10).
    end.
    DISPLAY  "There are Orderline's which have not been allocated completely" SKIP
            "at this moment. Maybe it is a good idea to let the Customer" SKIP
            "know this via a Sales Order Confirmation print, which you can" SKIP
            "select at the end of the next screen or by running 7.1.5 ..." SKIP
            "Group-Info: " SKIP
            txt NO-LABEL FORMAT "x(60)"
        with frame yn451 side-labels overlay row 10 col 10.
    update yn blank label "Press Enter" go-on("END-ERROR") with frame yn451.
    hide frame yn451 no-pause.
    
  end.

  if new-order then do:
    find FIRST scrtmp_sod_det no-lock where scrtmp_sod_det.sod_domain = ow-domain
                                 and scrtmp_sod_det.sod_nbr = scrtmp_so_mstr.so_nbr
                                 and scrtmp_sod_det.sod_due_date = today no-error.
    if avail scrtmp_sod_det and can-do(ware-houses,scrtmp_sod_det.sod_site) then do:

      if wh-site <> "301" and wh-site <> "351" then
        find ad_mstr no-lock where ad_mstr.ad_domain = wh-domain
                               and ad_mstr.ad_addr = "~~~~due" + wh-site no-error.
      else find ad_mstr no-lock where ad_mstr.ad_domain = wh-domain
                               and ad_mstr.ad_addr = "~~~~due" + scrtmp_so_mstr.so_site no-error.
      if avail ad_mstr then do:
        display "There are orderline(s) which have a Due-Date of today, but" skip
          "the warehouse people have already done the last order-download" skip
           "of today, because this is a newly entered order these date(s)" skip
                "will now be automatically changed into the next avail" skip
                "delivery-date. If these Due-Date(s) should be something" skip
                "else then you can go into this Order again and change" skip
                "the desired date per Orderline ....." skip(1)
                 with frame yn121 side-labels overlay row 10 col 10.
        update yn blank label "Press Enter" go-on("END-ERROR") with frame yn121.
        hide frame yn121 no-pause.

        FOR EACH tt_sod_upddue:
            DELETE tt_sod_upddue.
        END.
        for each scrtmp_sod_det where scrtmp_sod_det.sod_domain = ow-domain
                           and scrtmp_sod_det.sod_nbr = sonbr
                           and scrtmp_sod_det.sod_due_date = today
                           break by scrtmp_sod_det.sod_nbr:
          if first-of(scrtmp_sod_det.sod_nbr)
          then RUN SetSodDue (ow-domain,scrtmp_so_mstr.so_nbr,scrtmp_sod_det.sod_line,wh-site,wh-domain,
                                  show-mess,output next-due, INPUT-OUTPUT scrtmp_sod_det.sod_due_date, INPUT-OUTPUT scrtmp_sod_det.sod_per_date).

          scrtmp_sod_det.sod_due_date = next-due.
          if emt-ordr = yes then do for emtsod:
            find emtsod where emtsod.sod_domain = wh-domain
                          and emtsod.sod_nbr    = sonbr
                          and emtsod.sod_line   = scrtmp_sod_det.sod_Line no-error.
            if avail emtsod then DO:
                    CREATE tt_sod_upddue.
                    ASSIGN 
                        tt_sod_upddue.sod_domain   =  emtsod.sod_domain
                        tt_sod_upddue.sod_nbr      =  emtsod.sod_nbr
                        tt_sod_upddue.sod_line     =  emtsod.sod_line
                        tt_sod_upddue.sod_due_date =  next-due
                        .
                    /* old emtsod.sod_due_date = next-due*/
            END.
          end.
        end. /* for each scrtmp_sod_det */
        IF CAN-FIND(FIRST tt_sod_upddue) THEN
        DO:
           RUN us/zu/zusetemtdue.p(INPUT TABLE tt_sod_upddue, OUTPUT cErro#).
           IF cErro# <> "" AND cErro# <> ? THEN
           DO:
               MESSAGE cErro#
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
           END.
        END.
      end. /* avail ad_mstr */
    end. /* avail scrtmp_sod_det */
  end. /* new-order */
end procedure. /* order-wrap-up */
/**************************************************************************/
procedure set-trip-days:
  def input parameter trip-days as char.
  def var i as int.
  tr-txt = "".
  if int(trip-days) > 0 then do i = 1 to length(trip-days):
    if tr-txt <> "" then tr-txt = tr-txt + ",".
    tr-txt = tr-txt + entry(int(substr(trip-days,i,1)),
                          "Monday,Tuesday,Wednesday,Thursday,Friday,Saturday").
  end.
end procedure. /* set-trip-days */

procedure due-date:
   define input parameter wh_domain as   char              no-undo.
   define input parameter l_part    as   char              no-undo.
   define input parameter l_ord     like sod_det.sod_qty_ord       no-undo.
   define input parameter l_qtyavl  as   dec               no-undo.
   define output parameter l_duedt1 like dsd_due_date      no-undo.
   define variable l_sites  like dsd_site    no-undo.
   define variable l_qty    as  decimal no-undo.
   l_sites = "301,571,821,831,901,501". /*PMO2068N*/
   l_duedt1 = ?.
 /*  do itd = 1 to num-entries(l_sites): */
      for each dsd_det no-lock
         where dsd_domain  = wh_domain
           and dsd_part    = l_part
           and dsd_site    =  "310"        
           and dsd_due_date <> ?
      break by dsd_due_date: 

          if not  dsd_Qty_ord - dsd_qty_ship > 0
          then 
             next.
          if last(dsd_due_date) 
          then do:
             l_qty = l_qtyavl + l_qty + (dsd_qty_ord - dsd_qty_ship).
             l_duedt1 = dsd_due_Date.
          end.
            
             
      end.  
      for each pod_det use-index pod_partdue no-lock
      where pod_domain   = wh_domain
        and pod_part     =  l_part
        and pod_due_date <>   ?
      break  by pod_due_date:
         if not can-do(l_sites,pod_site)
         then 
            next.
         if not pod_qty_ord - pod_qty_rcvd > 0
         then 
            next.
         l_qty  = l_qty  + (pod_qty_ord - pod_qty_rcvd).
         if last(pod_due_date) 
         then do:
            if l_qty > l_ord  
            then do:
               if l_duedt1 < pod_due_Date
               then
                  l_duedt1 = pod_due_Date.
            end.
            else 
               l_duedt1 = ?.
         end.
      end.  

   /* end.   do itd = 1 to num-entries(l_sites): */
end procedure.
/* RFC-2014 START OF ADDITION *************************************************/
Procedure pao-due-date:
   define input parameter  ipc_wh_domain as   character           no-undo.
   define input parameter  ip_wh_site    like si_site             no-undo.
   define input parameter  ip_l_part     as   character           no-undo.
   define input parameter  ip_l_ord      like sod_det.sod_qty_ord no-undo.
   define input parameter  ip_um_conv    like sod_det.sod_um_conv no-undo.
   define input parameter  ip_qtyavl     as   decimal             no-undo.
   define output parameter op_duedt1     like sod_det.sod_due_date no-undo.

   define variable site-avl-qty as dec no-undo.
   define variable eu-avl-qty as dec no-undo.

   find ptp_det 
      where ptp_domain = ipc_wh_domain
        and ptp_site   = ip_wh_site
        and ptp_part   = ip_l_part
   no-lock no-error.

   for each in_mstr no-lock 
      where in_domain = ipc_wh_domain
        and in_part   = ip_l_part
        and in_site   = ip_wh_site :
           site-avl-qty = (in_qty_avail - in_qty_all).
   end. /*for each*/

   for each in_mstr no-lock 
      where in_domain = ipc_wh_domain
        and in_part   = ip_l_part :
           eu-avl-qty = eu-avl-qty + (in_qty_avail - in_qty_all).
   end. /*for each*/
   
   if avail ptp_det and ptp_pm_code = "P"
   then do:
      if (ip_l_ord * ip_um_conv) > site-avl-qty
      then do:
          /* RFC2556 ADD BEGINS */
         if int(site-avl-qty / ip_um_conv) > 0
     then  do:
           scrtmp_sod_det.sod_qty_ord  = 
       scrtmp_sod_det.sod_qty_ord - truncate(site-avl-qty / ip_um_conv,0).
       create scrtmp1.
       buffer-copy scrtmp_sod_det except
                         scrtmp_sod_det.sod_line 
                     scrtmp_sod_det.sod_qty_ord 
             scrtmp_sod_det.sod_qty_all
             to scrtmp1.
           assign
          scrtmp1.sod_line    = scrtmp_sod_det.sod_line + 1
          scrtmp1.sod_qty_ord = truncate(site-avl-qty / ip_um_conv,0)
          scrtmp1.sod_qty_all = scrtmp1.sod_qty_ord.
          l_split = yes. /* INC56658 */
     end.
         /* RFC2556 ADD ENDS */
         if can-find(xxpt_mstr where xxpt_part     = ip_l_part
                                 and (xxpt_char[2] = "PAB1" 
                                 or   xxpt_char[2] = "PAB2")) 
         then do:
            if (ip_l_ord * ip_um_conv) <= eu-avl-qty
            then
               /* op_duedt1 = today + 14 */ /*CHN00830*/
               op_duedt1 = today + lvi_dueDays. /*CHN00830*/
            else 
               op_duedt1 = today + ptp_det.ptp_pur_lead.
         end. /*xxpt_mstr*/
         else 
            op_duedt1 = today + ptp_det.ptp_timefnce + 28.
      end. /*sod_qty_ord > qty-avl*/
   end. /*ptp_pm_code = "P"*/

   if avail ptp_det and ptp_pm_code = "D"
   then do:
      find si_mstr 
         where si_domain = si_db
           and si_site   = substr(ptp_network,3,3)
           and si_type   = yes
      no-lock no-error.
      find ptp_det 
         where ptp_domain = si_domain
           and ptp_site   = si_site
           and ptp_part   = ip_l_part
      no-lock no-error.
      if (ip_l_ord * ip_um_conv) > site-avl-qty
      then do:
         /* RFC2556 ADD BEGINS */
         if int(site-avl-qty / ip_um_conv) > 0
     then  do:
           scrtmp_sod_det.sod_qty_ord  = 
       scrtmp_sod_det.sod_qty_ord - truncate(site-avl-qty / ip_um_conv,0).
       
       create scrtmp1.
       buffer-copy scrtmp_sod_det except
                     scrtmp_sod_det.sod_line
                     scrtmp_sod_det.sod_qty_ord 
             scrtmp_sod_det.sod_qty_all
             to scrtmp1.
           assign
          scrtmp1.sod_line    = scrtmp_sod_det.sod_line + 1
          scrtmp1.sod_qty_ord = truncate(site-avl-qty / ip_um_conv,0)
          scrtmp1.sod_qty_all = scrtmp1.sod_qty_ord.
          l_split = yes. /* INC56658 */
     end.
         /* RFC2556 ADD ENDS */
         if can-find(xxpt_mstr where xxpt_part     = ip_l_part
                                 and (xxpt_char[2] = "PAB1" 
                                 or   xxpt_char[2] = "PAB2")) 
         then do:
            if (ip_l_ord * ip_um_conv) <= eu-avl-qty
            then 
               /*op_duedt1 = today + 14*/  /*CHN00830*/
               op_duedt1 = today + lvi_dueDays. /*CHN00830*/
            else
               /*op_duedt1 = today + ptp_det.ptp_pur_lead + 14.*/ /*CHN00830*/
               op_duedt1 = today + ptp_det.ptp_pur_lead + lvi_dueDays. /*CHN00830*/
         end. /*xxpt_mstr*/
         else 
            op_duedt1 = today + ptp_det.ptp_timefnce + 14 + 28.
      end. /*l_ord < site-avl-qty*/
   end. /*ptp_pm_code = "D"*/
end procedure.                
/* RFC-2014 END OF ADDITION ***************************************************/

/* OT-153 START ADDITION */
PROCEDURE checkSalesUM:

   define input parameter ip_domain  as character no-undo.
   define input parameter ip_salesUM as character no-undo.
   define input parameter ip_soSite  as character no-undo.
   define output parameter op_validSalesUM as logical no-undo init false.

   define variable lvd_salesUMConv as decimal no-undo.

   for first scrtmp_sod_det
      where scrtmp_sod_det.sod_domain = ip_domain
        and scrtmp_sod_det.sod_nbr    = sonbr
        and scrtmp_sod_det.sod_line   = ordr-line
   no-lock:
   end.
   
   if available scrtmp_sod_det
   then do:
   
      op_validSalesUM = yes.
      
      for first pt_mstr
         where pt_domain = wh-domain
           and pt_part   = scrtmp_sod_det.sod_part
      no-lock:
      end.

      if available pt_mstr
      then do:

         for first um_mstr
            where um_domain = wh-domain
              and um_um     = pt_um
              and um_alt_um = ip_salesUM
              and um_part   = scrtmp_sod_det.sod_part
         no-lock:
         end.
         
         if available um_mstr
         then
            lvd_salesUMConv = um_conv.
         else if ip_salesUM <> pt_um
         then do:
            
            lvc_dispMsg =
              "This Unit of Measure is not supported (yet) !!!".
            {pxmsg.i &msgtext=lvc_dispMsg &errorlevel=3}
            
            op_validSalesUM = no.
            return.
         end.
      end.
   
      if can-do("801,811,821,831",ip_soSite)
        and not can-do("EA,CS,BX",ip_salesUM)
      then do:
      
         display
          "This Unit of Measure is not supported by the Spanish Warehouse !!!"
          with frame yn107a2 side-labels overlay row 10 col 10.
         update yn blank label "Press Enter" go-on("END-ERROR")
          with frame yn107a2.
         hide frame yn107a2 no-pause.
         op_validSalesUM = no.
         return.
      end.

      if (available pt_mstr
           and ip_salesUM <> "CS"
           and ip_salesUM <> "BX"
           and (scrtmp_so_mstr.so__chr10 = ""
                 or scrtmp_so_mstr.so__chr10 = "CONSIGN"
                 or scrtmp_so_mstr.so__chr10 = "RUSH")
           and not can-find(first ld_det no-lock
                            where ld_domain = wh-domain
                              and ld_part   = scrtmp_sod_det.sod_part
                              and ld_site   = scrtmp_sod_det.sod_site
                              and ld_loc    = "CONSIGN"
                              and ld_ref begins scrtmp_so_mstr.so_ship))
      then do:
   
         for first um_mstr
            where um_domain = wh-domain
              and um_um     = pt_um
              and um_alt_um = ip_salesUM
              and um_part   = scrtmp_sod_det.sod_part
         no-lock:
         end.
       
         if available um_mstr
         then do:
          
            if scrtmp_sod_det.sod_qty_ord / um_conv 
               <> round(scrtmp_sod_det.sod_qty_ord / um_conv,0)
            then do:

               lum-allowed:
               do:
                
                  for first cm_mstr
                     where cm_domain = domain
                       and cm_addr = scrtmp_so_mstr.so_cust
                  no-lock:
                  end.
             
                  if available cm_mstr
                  then do:
                
                     if cm__chr07 = "yes"
                     then do: /* lum-allow */
                
                        for first xxlum_det
                           where xxlum_part = scrtmp_sod_det.sod_part
                        no-lock:
                        end.
               
                        if available xxlum_det
                        then do:
                      
                           if xxlum_um = ip_salesUM
                           then
                              leave lum-allowed.

                           display
                            "This Customer is not allowed to have this UoM,"
                            skip
                            "the only one allowed is '" +
                            caps(xxlum_um) +
                            "' ..."
                            format "X(45)" skip(1)
                            with frame yn1081a side-labels
                                 overlay row 10 col 10.
                        
                           update yn blank label "Press Enter"
                                  go-on("END-ERROR")
                           with frame yn1081a.
                           hide frame yn1081a no-pause.
                           op_validSalesUM = no.
                           return.
                        end. /* if available xxlum_det */
                     end. /* if cm__chr07 = "yes" */
                  end. /* if available cm_mstr */
               end. /* lum-allowed do */
            end. /* if scrtmp_sod_det.sod_qty_ord / um_conv ... */
         end. /* if available um_mstr */
      end. /* if (available pt_mstr ... */
   end. /* if available scrtmp_sod_det */

END PROCEDURE. /* checkSalesUM */
/* OT-153 END ADDITION */

procedure quotaprevblock:
   define input parameter l_domain as char no-undo.
   define input parameter l_ord    as char no-undo.
   define input parameter l_line   as int no-undo.
   define output parameter l_blckchk as log init no.
   define output parameter l_orderqty like sod_Det.sod_qty_ord.
   for last xxblck_det no-lock
      where xxblck_domain = l_domain
        and xxblck_ord    = l_ord
        and xxblck_line   = l_line
        and xxblck_stat   = "Released":
    end.
    if available xxblck_det
    then do:
       l_blckchk = yes.
       l_orderqty = xxblck_qty_ord.
    end.
end. /*  quotaprevblock */


PROCEDURE RestorePrintPl:

  DEFINE VARIABLE cErro# AS CHARACTER   NO-UNDO.

  PUBLISH "ResetSoPrintPl" (OUTPUT cErro#).
  
  IF cErro# <> ""
  THEN DO:
    MESSAGE cErro#
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
  END.  

/*****************************
  DEFINE BUFFER blu_so_mstr FOR so_mstr.

  IF lKeepPrintPl# <> ?
  THEN DO TRANSACTION
        ON ERROR UNDO, RETURN ERROR:
    find blu_so_mstr where blu_so_mstr.so_domain = domain
                       and blu_so_mstr.so_nbr = cSoNbrOld# no-error.
    if avail blu_so_mstr then DO:
       blu_so_mstr.so_print_pl = lKeepPrintPl#. 
      RELEASE blu_so_mstr.
    END.
       
    if emt-ordr = yes 
    then DO:
      find blu_so_mstr where blu_so_mstr.so_domain = wh-domain
                        and blu_so_mstr.so_nbr = cSoNbrOld# no-error.
      if avail blu_so_mstr 
      then DO:
         blu_so_mstr.so_print_pl = lKeepPrintPl#. 
         RELEASE blu_so_mstr.
      END.
    end.

  END.
**************************/  

END PROCEDURE.


PROCEDURE StoreCosign:
  DEFINE OUTPUT PARAMETER lErro# AS LOGICAL     NO-UNDO INIT FALSE.
  
  
  DEFINE VARIABLE cErro# AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lSave# AS LOGICAL   INIT FALSE NO-UNDO.
  DEFINE BUFFER scrtmp_sod_det FOR scrtmp_sod_det.
  DEFINE BUFFER scrtmp_so_mstr FOR scrtmp_so_mstr.
  DEFINE BUFFER sod_det FOR sod_det.
  
  
  DEFINE VARIABLE iCallID# AS INTEGER     NO-UNDO INIT ?.
  DEFINE VARIABLE iSeqNr#  AS INTEGER     NO-UNDO INIT ?.
  DEFINE VARIABLE iPareId# AS INTEGER     NO-UNDO INIT 0.
  
  DEFINE VARIABLE iLinesInTrans# AS INTEGER     NO-UNDO INIT 0.
  DEFINE VARIABLE iTotalLines# AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cErroInte# AS CHARACTER   NO-UNDO INIT "".
  DEFINE VARIABLE lLastLine# AS LOGICAL     NO-UNDO INIT TRUE.
  DEFINE VARIABLE iCurrLine# AS INTEGER     NO-UNDO INIT 0.
  DEFINE BUFFER so_mstr FOR so_mstr.  
  DEFINE VARIABLE lFirstCall# AS LOGICAL     NO-UNDO INIT TRUE.
  DEFINE VARIABLE lSetPPL# AS LOGICAL     NO-UNDO INIT FALSE.
  
  DATASET dsmaintainSalesOrder:EMPTY-DATASET().
  
  FOR EACH tt-sod_cosign:
    ASSIGN tt-sod_cosign.lLastLine = FALSE.
  END.
  
  SetLastLine:
  FOR EACH tt-sod_cosign,
      EACH scrtmp_sod_det WHERE scrtmp_sod_det.sod_domain  = tt-sod_cosign.xsod_domain
                            AND scrtmp_sod_det.sod_nbr     = tt-sod_cosign.xsod_nbr
                            AND scrtmp_sod_det.sod_line    = tt-sod_cosign.xsod_line
                            AND (scrtmp_sod_det.sod_qty_ord <> 0 OR scrtmp_sod_det.sod_qty_all <> 0 OR scrtmp_sod_det.sod_qty_pick <> 0),
     FIRST scrtmp_so_mstr WHERE scrtmp_so_mstr.so_domain  = tt-sod_cosign.xsod_domain
                            AND scrtmp_so_mstr.so_nbr     = tt-sod_cosign.xsod_nbr 
        BY tt-sod_cosign.xsod_line DESC 
        BY ROWID(tt-sod_cosign) DESC:
     ASSIGN tt-sod_cosign.lLastLine = lLastLine#
            lLastLine#              = FALSE
            iTotalLines#            = iTotalLines# + 1.
  END.
  
  
  ASSIGN iLinesInTrans# = 0.
  FOR EACH tt-sod_cosign,
      EACH scrtmp_sod_det WHERE scrtmp_sod_det.sod_domain  = tt-sod_cosign.xsod_domain
                            AND scrtmp_sod_det.sod_nbr     = tt-sod_cosign.xsod_nbr
                            AND scrtmp_sod_det.sod_line    = tt-sod_cosign.xsod_line
                            AND (scrtmp_sod_det.sod_qty_ord <> 0 OR scrtmp_sod_det.sod_qty_all <> 0 OR scrtmp_sod_det.sod_qty_pick <> 0),
     FIRST scrtmp_so_mstr WHERE scrtmp_so_mstr.so_domain  = tt-sod_cosign.xsod_domain
                            AND scrtmp_so_mstr.so_nbr     = tt-sod_cosign.xsod_nbr
        BY tt-sod_cosign.xsod_line
        BY ROWID(tt-sod_cosign):
  
    ASSIGN iPareId#       = iPareId# + 1
           iCurrLine#     = iCurrLine# + 1
           iLinesInTrans# = iLinesInTrans# + 1.
    
    CREATE tt_so_mstr.
    BUFFER-COPY scrtmp_so_mstr
             TO tt_so_mstr
         ASSIGN tt_so_mstr.dataLinkField = iPareId#.
    
    VALIDATE tt_so_mstr.
    
    IF lFirstCall# = FALSE AND
       CAN-FIND(FIRST so_mstr NO-LOCK WHERE so_mstr.so_domain = tt_so_mstr.so_domain
                                        AND so_mstr.so_nbr    = tt_so_mstr.so_nbr)
    THEN DO:
      ASSIGN tt_so_mstr.operation = "N".
      VALIDATE tt_so_mstr.
    END.
    ELSE ASSIGN lSetPPL# = TRUE.
    
    ASSIGN lFirstCall# = FALSE.
    
    
    CREATE tt_sod_det.
    BUFFER-COPY scrtmp_sod_det
             TO tt_sod_det
         ASSIGN tt_sod_det.dataLinkFieldPar = iPareId#.
    VALIDATE tt_sod_det.         
            
           
    IF tt-sod_cosign.lLastLine OR 
       iLinesInTrans# >= giLinesPerTransaction# 
    THEN DO: 
    
      MESSAGE "Processing line(s) until line# " iCurrLine# " from " iTotalLines# " line(s) ... ".
    
      ASSIGN iLinesInTrans# = 0
             iCallID#       = ?
             iSeqnr#        = ?.
    
      RUN EnableScopeTrans IN hProc# (INPUT FALSE).
      
      /* Set the client-timeout to 10 minutes */
      RUN SetClientTimeOut IN hProc# (INPUT 600).
      
      RUN SetNextCallForceUpdateFields IN hProc# (INPUT "sod_qty_pick,sod_qty_all"). 
      
      RUN SaveMedlineSO IN hProc#
        (INPUT scrtmp_so_mstr.so_domain,
         INPUT DYNAMIC-FUNCTION("GetEntityForSite" IN hProc#, INPUT scrtmp_so_mstr.so_domain, scrtmp_so_mstr.so_site),
         INPUT THIS-PROCEDURE,
         INPUT-OUTPUT DATASET dsmaintainSalesOrder,
         INPUT-OUTPUT iCallID#,
         INPUT-OUTPUT iSeqnr#,
         OUTPUT cErroInte#).
         
      IF cErroInte# <> "" AND
         cErroInte# <> ?
      THEN DO:
        IF cErro# <> ""
        THEN ASSIGN cErro# = cErro# + CHR(10).
        ASSIGN cErro# = cErro# + cErroInte#.
      END.

      RUN EnableScopeTrans IN hProc# (INPUT TRUE).     

      /* Set the client-timeout back to 2 minutes */
      RUN SetClientTimeOut IN hProc# (INPUT 120).
      
      RUN SaveDataFromDSTT. 
      
      IF tt-sod_cosign.lLastLine = FALSE
      THEN DATASET dsmaintainSalesOrder:EMPTY-DATASET().
    END.

  END.
  
  
  FOR EACH scrtmp_so_mstr:
    ASSIGN scrtmp_so_mstr.dataLinkField    = ?
           scrtmp_so_mstr.dataLinkFieldPar = ?.
  END.
  FOR EACH scrtmp_sod_det:
    ASSIGN scrtmp_sod_det.dataLinkField    = ?
           scrtmp_sod_det.dataLinkFieldPar = ?.
  END.
  
  RUN SetPrintPPLOverRule IN hProc# (INPUT FALSE).
  
  
  FOR FIRST tt_so_mstr:
    PUBLISH "InitSoPrintPlForce" (INPUT tt_so_mstr.so_domain,
                                  INPUT tt_so_mstr.so_nbr,
                                  INPUT FALSE /* tt_so_mstr.so_print_pl */,
                                  OUTPUT cErroSoPPL#). 
    IF cErroSoPPL# <> ""
    THEN MESSAGE cErroSoPPL# VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END.   
  
  IF cErro# <> "" AND cErro# <> ? THEN
  DO:
      lErro# = TRUE.
      
      RUN zu/zupxmsg.p (" ERROR: Last transaction is not (fully) committed. ", cErro#, INPUT-OUTPUT lNoReply#).
  END.

  DATASET dsmaintainSalesOrder:EMPTY-DATASET().
  
  RUN SaveEmtData(OUTPUT lErro#).
  
  IF lShowSaveMessage#
  THEN MESSAGE "Saving SO done...".
  
END PROCEDURE.  

PROCEDURE GetWhseSite:

  DEFINE INPUT  PARAMETER cDomain#       AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER hScrSoMstr#    AS HANDLE      NO-UNDO.
  DEFINE INPUT  PARAMETER cShipRequest#  AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER dSoDueRequest# AS DATE        NO-UNDO.
  
  DEFINE INPUT  PARAMETER lCheckOnly# AS LOGICAL     NO-UNDO.
  
  DEFINE INPUT-OUTPUT PARAMETER wh-site   AS CHARACTER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER wh-domain AS CHARACTER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER emt-ordr  AS LOGICAL     NO-UNDO.
  
  DEFINE OUTPUT PARAMETER lWhseOk#  AS LOGICAL     NO-UNDO INIT TRUE.
  
  DEFINE VARIABLE cShipTo#    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE dtSoDue#    AS DATE        NO-UNDO.
  
  DEFINE VARIABLE cNewWhse#  AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cNewWhDom# AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lEmtNew#   AS LOGICAL     NO-UNDO.
  define variable lvc_project_list as character no-undo.      /*MEDPLAN*/
  define variable lvc_project      as character no-undo.      /*MEDPLAN*/
  define variable lvl_proceed      as logical   no-undo.      /*MEDPLAN*/
  define variable lvc_whSiteList   as character no-undo.      /* OT-153 */

  /* MP: MLQ-00058 -  Disable the ware-house change check/blocking
  IF hScrSoMstr#:AVAIL = FALSE
  THEN DO:
    MESSAGE "SYSTEM ERROR: Salesorder header buffer unavailable for check!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    ASSIGN lWhseOk# = FALSE.
    RETURN.
  END.
  */
  ASSIGN lWhseOk# = TRUE.
  
  ASSIGN cShipTo# = TRIM(cShipRequest#).
  IF cShipTo# = ? OR
     cShipTo# = ""
  THEN ASSIGN cShipTo# = hScrSoMstr#:BUFFER-FIELD("so_ship"):BUFFER-VALUE.
  
  ASSIGN dtSoDue# = dSoDueRequest#.
  IF dtSoDue# = ?
  /* OT-401 comment THEN ASSIGN dtSoDue# = hScrSoMstr#:BUFFER-FIELD("so_due_date"):BUFFER-VALUE.*/
  then                                                                              /* OT-401 */
     assign                                                                         /* OT-401 */
        dtSoDue# = hScrSoMstr#:BUFFER-FIELD("so_due_date"):BUFFER-VALUE.            /* OT-401 */
        dSoDueRequest# = dtSoDue# .                                                 /* OT-401 */

  run "av/avwhsite2.p" (INPUT cDomain# /* domain */ ,
                        INPUT hScrSoMstr#:BUFFER-FIELD("so_site"):BUFFER-VALUE, /* scrtmp_so_mstr.so_site */
                        INPUT hScrSoMstr#:BUFFER-FIELD("so__chr10"):BUFFER-VALUE, /* scrtmp_so_mstr.so__chr10 */
                        
                        INPUT cShipTo#,
                        INPUT dtSoDue#,
                        
                        OUTPUT cNewWhse#,
                        OUTPUT cNewWhDom#,
                        OUTPUT lEmtNew#).
                        
   /* OT-153 START ADDITION */
   assign
      lvl_nonEMT3PL = no
      lvc_whSiteList = "571,551,821,831,901,501,601".

   lvl_nonEMT3PL = fn_isSalesOrdNonEmt3PL
                      (cDomain#,
                       hScrSoMstr#:BUFFER-FIELD("so__chr04"):BUFFER-VALUE,
                       wh-site).

   if lvl_nonEMT3PL
   then do:
      if not lookup(hScrSoMstr#:BUFFER-FIELD("so_site"):BUFFER-VALUE,
                    lvc_whSiteList) = 0
      then do:
         assign
            lEmtNew#    = false
            cNewWhse#   = hScrSoMstr#:BUFFER-FIELD("so_site"):BUFFER-VALUE
         .
      end.
   end.
   /* OT-153 END ADDITION */
  
  /* MP: MLQ-00058 -  Disable the ware-house change check/blocking                       
  IF NOT (wh-domain = cNewWhDom# AND wh-site = cNewWhse#) 
  THEN DO:
    /* Do some checks */                        
    IF new-order = FALSE AND
       (wh-domain <> cNewWhDom# OR wh-site <> cNewWhse#)
    THEN ASSIGN lWhseOk# = FALSE.
  END.
  */
  
                            
/* Debug message:                     
  MESSAGE "Domain:  " cDomain# SKIP
          'Current: ' wh-domain "  /  " wh-site SKIP
          'New:     ' cNewWhDom#   "  /  " cNewWhse# SKIP
          'New ordr:' new-order SKIP
          'Ship-to: ' cShipRequest# SKIP
          'Due dt:  ' dSoDueRequest# SKIP
          'lCheckOnly#: ' lCheckOnly# SKIP(1)
          'OK:      ' lWhseOk#   SKIP(2)
          PROGRAM-NAME(0) SKIP
          PROGRAM-NAME(1) SKIP
          PROGRAM-NAME(2) SKIP
          PROGRAM-NAME(3) SKIP
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
*/     
      
  IF lWhseOk# = FALSE
  THEN DO:
    IF hScrSoMstr#:BUFFER-FIELD("so__chr10"):BUFFER-VALUE <> "INVOICE" 
    THEN MESSAGE "The update result in a warehouse change, this is not allowed." SKIP
                 "The update of due date and/or ship-to date is blocked."  SKIP(1)
                 "If this needs to be changed, the current order needs to be"  SKIP
                 "cancelled and a new order should be created."  VIEW-AS ALERT-BOX WARNING.
  END.            
      
  IF lCheckOnly# = FALSE      
  THEN ASSIGN emt-ordr  = lEmtNew#. 
  IF lWhseOk# = TRUE AND
     lCheckOnly# = FALSE
/* INC20959 DELETE BEGINS
     THEN ASSIGN wh-domain = cNewWhDom#
              wh-site   = cNewWhse#
              emt-ordr  = lEmtNew#. 
INC20959 DELETE ENDS */

/*INC20959 ADD BEGINS*/
  then do:                                  
     assign wh-domain = cnewwhdom#
            emt-ordr  = lemtnew#.
     if not lvl_s1 then
        wh-site = cnewwhse#.
  end.  /*IF lWhseOk# = TRUE AND lCheckOnly# = FALSE*/
/*INC20959 ADD ENDS*/

  /*MEDPLAN***START OF ADDITION*************************************************/
  lvl_proceed = no.
  lvc_project = hScrSoMstr#:BUFFER-FIELD("so__chr10"):BUFFER-VALUE.  
  if lvc_project <> "" then do:
/*INC20959 ADD BEGINS*/
     find first code_mstr no-lock where code_domain = "xx"
                                    and code_fldname = "xx_drp_project_exclude" no-error.
     if available code_mstr and lookup(lvc_project,code_cmmt)  > 0 then 
        lvl_p1 = yes.
/*INC20959 ADD ENDS*/     
     find first code_mstr no-lock where code_domain  = "XX" 
                                    and code_fldname = "XX_PROJECT_EXCLUDE" no-error.
     if available code_mstr 
     then  
        lvc_project_list = code_cmmt. 
     else 
        lvl_proceed = no.
     if lookup(lvc_project,lvc_project_list) > 0  
     then 
        lvl_proceed = yes.       
  end.
 /* if cShipTo# <> "" and not lvl_proceed then do:  INC20959*/
    if cShipTo# <> "" and not lvl_proceed and not lvl_s1 then do:
      find first xxfcstd_det no-lock  
                             where xxfcstd_domain     = "XX"
                               and xxfcstd_custshipto = cShipTo# no-error .
      if available xxfcstd_det 
      then do:
         wh-site  = xxfcstd_site.
         find first code_mstr no-lock where code_domain  = "XX"
                                       and code_fldname = "MED_TRANSIT_SITE"
                                       and code_value   = wh-site no-error.
         if available code_mstr 
         then do:
            find first xxfcstm_map no-lock where xxfcstm_domain = "XX" 
                                             and xxfcstm_fcSite = wh-site no-error.
            if available xxfcstm_map 
            then do:
              if xxfcstm_newsite <> "" and 
                 dSoDueRequest#  >= xxfcstm_due_date 
              then        
                 wh-site = xxfcstm_newsite.
              else
                 wh-site = xxfcstm_site.
            end. /* IF AVAILABLE xxfcstm_map*/
         end. /* IF AVAILABLE code_mstr THEN DO */
      end. /* if available xxfcstd_det */
      else 
      do:
         find ad_mstr no-lock where ad_mstr.ad_domain = cDomain#
                             and ad_mstr.ad_addr = cShipTo#.

         find first xxfcst_mstr no-lock where xxfcst_domain = "XX"
                                    and xxfcst_ship   = ad_mstr.ad_ctry no-error.
         if available xxfcst_mstr 
         then do:
            wh-site = xxfcst_fcsite.
/*POF2-1 START OF ADDITION ***************************************************/
        find first code_mstr no-lock where code_domain  = "XX"
                                           and code_fldname = "MED_TRANSIT_SITE"
                                           and code_value   = wh-site no-error.
            if available code_mstr 
            then do:
               find first xxfcstm_map no-lock where xxfcstm_domain = "XX" 
                                                and xxfcstm_fcSite = wh-site no-error.
               if available xxfcstm_map 
               then do:
                 if xxfcstm_newsite <> "" and 
                    dSoDueRequest#  >= xxfcstm_due_date 
                 then        
                    wh-site = xxfcstm_newsite.
                 else
                    wh-site = xxfcstm_site.
               end. /* IF AVAILABLE xxfcstm_map*/
            end. /* IF AVAILABLE code_mstr THEN DO */
     end.
/*POF2-1 END OF ADDITION******************************************************/
      end.
  end. 
/*MEDPLAN**END OF ADDITION****************************************************/

  
  IF hScrSoMstr#:BUFFER-FIELD("so__chr10"):BUFFER-VALUE = "INVOICE"  AND
     lCheckOnly# = TRUE
  THEN ASSIGN lWhseOk# = TRUE.

END PROCEDURE.


PROCEDURE SetLocalSoLock:
  DEFINE INPUT  PARAMETER cDomain# AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER cSoNbr#  AS CHARACTER   NO-UNDO.
  DEFINE OUTPUT PARAMETER cMess#   AS CHARACTER   NO-UNDO INIT "".

  DEFINE BUFFER so_mstr FOR so_mstr.
  
  IF VALID-HANDLE(hLockSo#)
  THEN DO:
    APPLY "CLOSE" TO hLockSo#.
    DELETE OBJECT hLockSo# NO-ERROR.
    ASSIGN hLockSo# = ?.
  END.
  
  IF VALID-HANDLE(hLockSoHq#)
  THEN DO:
    APPLY "CLOSE" TO hLockSoHq#.
    DELETE OBJECT hLockSoHq# NO-ERROR.
    ASSIGN hLockSoHq# = ?.
  END.  

  IF cDomain# <> ? AND
     cSoNbr# <> ?
  THEN DO:
    RUN us/zu/zusolock.p PERSISTENT SET hLockSo#
                         (INPUT cDomain#,
                          INPUT cSoNbr#,
                          OUTPUT cMess#).
    IF cMess# = "" AND 
       cDomain# <> "HQ" AND
       CAN-FIND(FIRST so_mstr NO-LOCK WHERE so_mstr.so_domain = "HQ"
                                        AND so_mstr.so_nbr    = cSoNbr#) = TRUE
    THEN RUN us/zu/zusolock.p PERSISTENT SET hLockSoHq#
                              (INPUT "HQ",
                               INPUT cSoNbr#,
                               OUTPUT cMess#).
                               
  END.
  
END PROCEDURE.


PROCEDURE Cim_7_9_15:

  DEFINE BUFFER scrtmp_sod_det FOR scrtmp_sod_det.

  IF emt-maint = TRUE
  THEN RETURN.
  /*SCQ-1369 DISABLE SHIPMENT*/
  if lv_emt = yes
  then return.
  /*SCQ-1369 ENDS*/ 
  MESSAGE "Start automatic shipping using .7.9.15 ....".
  
  FOR EACH scrtmp_sod_det:
    RUN Cim_7_9_15_Line (BUFFER scrtmp_sod_det).
  END.
  
  MESSAGE "Finished automatic shipping using .7.9.15.".
  
END PROCEDURE.


PROCEDURE Cim_7_9_15_Line:


  DEFINE PARAMETER BUFFER scrtmp_sod_det FOR scrtmp_sod_det.

  DEFINE VARIABLE dat-file AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE log-file AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lRunOk# AS LOGICAL     NO-UNDO INIT FALSE.
  
  DEFINE VARIABLE lBatchRun# AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE cExecName# AS CHARACTER   NO-UNDO.
  
  DEFINE BUFFER tr_hist FOR tr_hist.
  
  DEFINE VARIABLE dQtyIss# NO-UNDO LIKE sod_det.sod_qty_ord INIT 0.
  
  DEFINE BUFFER pt_mstr FOR pt_mstr.
  DEFINE BUFFER sod_det FOR sod_det.
  DEFINE BUFFER so_mstr FOR so_mstr.
  
  IF emt-maint = TRUE
  THEN RETURN.
  
  FIND FIRST sod_det NO-LOCK WHERE sod_det.sod_domain = scrtmp_sod_det.sod_domain
                               AND sod_det.sod_nbr    = scrtmp_sod_det.sod_nbr
                               AND sod_det.sod_line   = scrtmp_sod_det.sod_line NO-ERROR.
                               
  FIND FIRST so_mstr NO-LOCK WHERE so_mstr.so_domain  = scrtmp_sod_det.sod_domain
                               AND so_mstr.so_nbr     = scrtmp_sod_det.sod_nbr NO-ERROR.
                               
  IF NOT AVAIL sod_det OR
     NOT AVAIL so_mstr OR
     (AVAIL sod_det AND
      sod_det.sod_qty_ord = sod_det.sod_qty_ship)
  THEN RETURN.
    
  ASSIGN cExecName# = execname 
         lBatchRun# = batchrun
         batchrun   = TRUE
         execname   = 'sosois.p' 
         dat-file   = SESSION:TEMP-DIRECTORY + mfguser + "_ship_714_so.cim"
         log-file   = SESSION:TEMP-DIRECTORY + mfguser + "_ship_714_so.log".

         
  OS-DELETE VALUE(dat-file).
  OS-DELETE VALUE(log-file).
  
  
  output to value(dat-file).
  
  put unformatted '"' sod_det.sod_nbr '" - no no "' so_mstr.so_site '"' CHR(10)
                  '""' chr(10) sod_det.sod_line ' no' chr(10)
                  (sod_det.sod_qty_ord - sod_det.sod_qty_ship) ' "' so_mstr.so_site '" "'
                  sod_det.sod_loc '" "' sod_det.sod_serial '" "" no'
                  chr(10) '.' chr(10) 'no' chr(10) 'yes' chr(10)
                  chr(10) chr(10) '.' chr(10) '.' chr(10).
  PUT CONTROL NULL(0). /* Flush cache, force write to disk */
  
  output close.
  
  input from value(dat-file).
  output to value(log-file) unbuffered.
  
  put unformatted "Running program 7.9.15 - sosois.p" chr(10).
  
  RunCim:            
  DO ON ERROR UNDO RunCim, LEAVE RunCim
     ON STOP UNDO RunCim, LEAVE RunCim
     ON ENDKEY UNDO RunCim, LEAVE RunCim  
     ON QUIT UNDO RunCim, LEAVE RunCim:  
    run "us/so/sosois.p".
    ASSIGN lRunOk# = TRUE.
  END.
  
  input close.
  output close.
  
  ASSIGN execname = cExecName#
         batchrun = lBatchRun#.
  
  OS-DELETE VALUE(dat-file).
  OS-DELETE VALUE(log-file).
    
  FIND FIRST sod_det NO-LOCK WHERE sod_det.sod_domain = scrtmp_sod_det.sod_domain
                               AND sod_det.sod_nbr    = scrtmp_sod_det.sod_nbr
                               AND sod_det.sod_line   = scrtmp_sod_det.sod_line NO-ERROR.
   
  IF lRunOk# = FALSE OR
     /* dQtyIss# <> tt_sod_det.sod_qty_ord */
     sod_det.sod_qty_ord <> sod_det.sod_qty_ship
  THEN MESSAGE SUBST("Warning: Automatic shipment of line &1 / part &2 failed. Qty. Ordered: ",sod_det.sod_line,sod_det.sod_part) STRING(sod_det.sod_qty_ord) " / Shipped: " + STRING(sod_det.sod_qty_ship) SKIP
               "Please correct this manually and ship the line using .7.9.15 ." VIEW-AS ALERT-BOX WARNING.
  /* ELSE MESSAGE "OK: " sod_det.sod_line " / Ord: " sod_det.sod_qty_ord "  / Shp: " sod_det.sod_qty_ship VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */
  
  
        
END PROCEDURE.


/* RFC24674 ADD BEGINS*/
procedure groupingcheck:
   define input parameter  lv_addr    as char.
   define output parameter ll_group as log.
   for first debtor no-lock 
      where debtorcode =  lv_addr
        and debtor.customcombo0 = "Grouping":
   end.
   if available debtor
   then 
      ll_group  = yes.



end. 
/* RFC24674 ADD ENDS */

procedure create_scrtmpdet:
   define input-output parameter lv_bc as log.
   
   define buffer bufscrtmp_sod_det for scrtmp_sod_det. /*INC72581*/
   
   for first scrtmp1 no-lock:
   end.
   if available scrtmp1
   then do:
           /*INC72581*/   
       if l_split = yes and cust-restr then 
         assign 
          scrtmp1.sod_qty_all = 0.
       /**********CHN00826 - ADD STARTS ********************/
       if l_split = yes 
          and available scrtmp_sod_det 
       then 
          assign 
             scrtmp1.sod__chr10  = scrtmp_sod_det.sod__chr10
             scrtmp1.sod_consume = scrtmp_sod_det.sod_consume.  
       /**********CHN00826 - ADD ENDS **********************/

   /******* CEPS-739 ADD BEGINS ************************************/
       if l_split
       then do:
          if can-find(first xxdsc_det
             where xxdsc_domain = scrtmp_sod_det.sod_domain
               and xxdsc_cust   = scrtmp_so_mstr.so_cust
               and xxdsc_part   = scrtmp_sod_det.sod_part
               and xxdsc_discID <> 0
               and xxdsc_nbr    = scrtmp_sod_det.sod_nbr
               and xxdsc_line   = scrtmp_sod_det.sod_line)
          then
             run createdis(input scrtmp_sod_det.sod_domain,
                           input scrtmp_so_mstr.so_cust,
                           input scrtmp_sod_det.sod_part,
                           input scrtmp_sod_det.sod_nbr,
                           input scrtmp_sod_det.sod_line,
                           input scrtmp1.sod_qty_ord,
                           input scrtmp1.sod_line).

          if can-find(first xxsurc_det
             where xxsurc_domain = tt_sod_det.sod_domain
               and xxsurc_cust   = tt_so_mstr.so_cust
               and xxsurc_part   = tt_sod_det.sod_part
               and xxsurc_nbr    = tt_sod_det.sod_nbr
               and xxsurc_line   = tt_sod_det.sod_line)
          then
             run createsurc(input scrtmp_sod_det.sod_domain,
                            input scrtmp_so_mstr.so_cust,
                            input scrtmp_sod_det.sod_part,
                            input scrtmp_sod_det.sod_nbr,
                            input scrtmp_sod_det.sod_line,
                            input scrtmp1.sod_qty_ord,
                            input scrtmp1.sod_line).
       end. /* IF l_split */
    /***** CEPS-739 ADD ENDS ************************************/

      run "zu/zusodwrp.p" (INPUT BUFFER scrtmp_so_mstr:handle, 
                              INPUT BUFFER scrtmp1:handle, 
                  domain,emt-ordr,
                  wh-domain,
                  wh-site,
                  sonbr,
                  scrtmp1.sod_line,
                                  ?,
                  old-ord-qty,
                  old-qty-ord,
                  old-qty-all,
                  old-due-date, 
                  OUTPUT cErro#).
     
     /*INC72581 ADD STARTS*/              
     if l_split = yes and cust-restr then do:
        
         find first bufscrtmp_sod_det no-lock 
            where bufscrtmp_sod_det.sod_domain = scrtmp_so_mstr.so_domain
          and bufscrtmp_sod_det.sod_nbr    = scrtmp_so_mstr.so_nbr
          and bufscrtmp_sod_det.sod_line   = scrtmp1.sod_line no-error.
         if not available bufscrtmp_sod_det then 
         do:
            create bufscrtmp_sod_det.
            buffer-copy scrtmp1 to bufscrtmp_sod_det.

        run SetEditBlock(BUFFER scrtmp_so_mstr,
                             BUFFER bufscrtmp_sod_det,
                 BUFFER pt_mstr,
                 "Restriction").
                            
            delete bufscrtmp_sod_det.            
         end. /*if not available scrtmp_sod_det then */
           end.    /*if cust-restr then do:*/
       /*INC72581 ADD ENDS*/          
     assign
        li_linenbr = scrtmp1.sod_line + 1
        lv_bc = yes.
   end. /* if available scrtmp1 */
end. /* procedure create_scrtmpdet */

/***** CEPS-739 ADD BEGINS ******************************************/
PROCEDURE createsurc:
   define input parameter ip_domain like sod_det.sod_domain  no-undo.
   define input parameter ip_cust   like so_mstr.so_cust     no-undo.
   define input parameter ip_part   like sod_det.sod_part    no-undo.
   define input parameter ip_nbr    like sod_det.sod_nbr     no-undo.
   define input parameter ip_olin   like sod_det.sod_line    no-undo.
   define input parameter ip_qtyord like sod_det.sod_qty_ord no-undo.
   define input parameter ip_line   like sod_det.sod_line    no-undo.

   define buffer bfxxsurc for xxsurc_det.

   if old-sod-type = "A"
   then do:
      for each xxsurc_det no-lock 
         where xxsurc_det.xxsurc_domain = ip_domain
           and xxsurc_det.xxsurc_cust   = ip_cust
           and xxsurc_det.xxsurc_part   = save-part
           and xxsurc_det.xxsurc_nbr    = ip_nbr
           and xxsurc_det.xxsurc_line   = ip_olin:
         for first bfxxsurc no-lock 
            where bfxxsurc.xxsurc_domain = xxsurc_det.xxsurc_domain
              and bfxxsurc.xxsurc_cust   = xxsurc_det.xxsurc_cust
              and bfxxsurc.xxsurc_part   = ip_part
              and bfxxsurc.xxsurc_nbr    = xxsurc_det.xxsurc_nbr
              and bfxxsurc.xxsurc_line   = ip_line
              and bfxxsurc.xxsurc_ID     = xxsurc_det.xxsurc_ID:
         end. /* for first bfxxsurc no-lock */

         if not available bfxxsurc
         then do:
            create bfxxsurc.
            buffer-copy xxsurc_det 
            except xxsurc_det.xxsurc_part
            to bfxxsurc.
            bfxxsurc.xxsurc_part = ip_part.
         end. /* IF NOT AVAILABLE bfxxsurc */
      end. /* FOR FIRST xxsurc_det */
   end. /* IF old-sod-type = "A" */
   else if l_split
   then do:
      for each xxsurc_det no-lock 
         where xxsurc_det.xxsurc_domain = ip_domain
           and xxsurc_det.xxsurc_cust   = ip_cust
           and xxsurc_det.xxsurc_part   = ip_part
           and xxsurc_det.xxsurc_nbr    = ip_nbr
           and xxsurc_det.xxsurc_line   = ip_olin:
         for first bfxxsurc no-lock 
            where bfxxsurc.xxsurc_domain = xxsurc_det.xxsurc_domain
              and bfxxsurc.xxsurc_cust   = xxsurc_det.xxsurc_cust
              and bfxxsurc.xxsurc_part   = xxsurc_det.xxsurc_part
              and bfxxsurc.xxsurc_nbr    = xxsurc_det.xxsurc_nbr
              and bfxxsurc.xxsurc_line   = ip_line
              and bfxxsurc.xxsurc_ID     = xxsurc_det.xxsurc_ID:
         end. /* FOR FIRST bfxxsurc NO-LOCK */

         if not available bfxxsurc
         then do:
            create bfxxsurc.
            buffer-copy xxsurc_det
            except xxsurc_det.xxsurc_line
                   xxsurc_det.xxsurc_qty_ord
            to bfxxsurc.
            assign
               bfxxsurc.xxsurc_line    = ip_line
               bfxxsurc.xxsurc_qty_ord = ip_qtyord.
         end. /* IF NOT AVAILABLE bfxxsurc */
      end. /* FOR EACH xxsurc_det */
   end. /* ELSE IF l_split: */
END PROCEDURE. /* PROCEDURE createsurc */

PROCEDURE createdis:
   define input parameter ip_domain like sod_det.sod_domain  no-undo.
   define input parameter ip_cust   like so_mstr.so_cust     no-undo.
   define input parameter ip_part   like sod_det.sod_part    no-undo.
   define input parameter ip_nbr    like sod_det.sod_nbr     no-undo.
   define input parameter ip_olin   like sod_det.sod_line    no-undo.
   define input parameter ip_qtyord like sod_det.sod_qty_ord no-undo.
   define input parameter ip_line   like sod_det.sod_line    no-undo.

   define buffer bfxxdsc for xxdsc_det.

   if old-sod-type = "A" then do:
      for each xxdsc_det no-lock
         where xxdsc_det.xxdsc_domain = ip_domain
           and xxdsc_det.xxdsc_cust   = ip_cust
           and xxdsc_det.xxdsc_part   = save-part
           and xxdsc_det.xxdsc_nbr    = ip_nbr
           and xxdsc_det.xxdsc_line   = ip_olin:
         for first bfxxdsc no-lock
            where bfxxdsc.xxdsc_domain = xxdsc_det.xxdsc_domain
              and bfxxdsc.xxdsc_cust   = xxdsc_det.xxdsc_cust
              and bfxxdsc.xxdsc_part   = ip_part
              and bfxxdsc.xxdsc_discID = xxdsc_det.xxdsc_discID
              and bfxxdsc.xxdsc_nbr    = xxdsc_det.xxdsc_nbr
              and bfxxdsc.xxdsc_line   = xxdsc_det.xxdsc_line:
         end. /* FOR FIRST bfxxdsc no-lock */

         if not available bfxxdsc
         then do:
            create bfxxdsc.
            buffer-copy xxdsc_det 
            except xxdsc_det.xxdsc_part
            to bfxxdsc.
            bfxxdsc.xxdsc_part = ip_part.
         end. /* IF NOT AVAILABLE bfxxdsc */
      end. /* FOR EACH xxdsc_det */
   end. /* IF old-sod-type = "A" */
   else if l_split
   then do:
      for each xxdsc_det no-lock 
         where xxdsc_det.xxdsc_domain = ip_domain
           and xxdsc_det.xxdsc_cust   = ip_cust
           and xxdsc_det.xxdsc_part   = ip_part
           and xxdsc_det.xxdsc_nbr    = ip_nbr
           and xxdsc_det.xxdsc_line   = ip_olin:
         create bfxxdsc.
         buffer-copy xxdsc_det 
         except xxdsc_det.xxdsc_line 
         to bfxxdsc.
         bfxxdsc.xxdsc_line = ip_line.
      end. /* FOR EACH xxdsc_det */
   end. /* ELSE IF l_split */
END PROCEDURE. /* PROCEDURE createdis */
/***** CESP-739 ADD ENDS *********************************************/
