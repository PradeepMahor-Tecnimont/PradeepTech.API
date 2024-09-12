using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Keyless]
    public partial class SsEmplmast
    {
        [Required]
        [Column("EMPNO")]
        [StringLength(5)]
        public string Empno { get; set; }
        [Required]
        [Column("NAME")]
        [StringLength(35)]
        public string Name { get; set; }
        [Column("ABBR")]
        [StringLength(5)]
        public string Abbr { get; set; }
        [Required]
        [Column("EMPTYPE")]
        [StringLength(1)]
        public string Emptype { get; set; }
        [Column("EMAIL")]
        [StringLength(100)]
        public string Email { get; set; }
        [Required]
        [Column("ASSIGN")]
        [StringLength(4)]
        public string Assign { get; set; }
        [Required]
        [Column("PARENT")]
        [StringLength(4)]
        public string Parent { get; set; }
        [Required]
        [Column("DESGCODE")]
        [StringLength(6)]
        public string Desgcode { get; set; }
        [Column("PASSWORD")]
        [StringLength(10)]
        public string Password { get; set; }
        [Column("DOB", TypeName = "DATE")]
        public DateTime? Dob { get; set; }
        [Column("DOJ", TypeName = "DATE")]
        public DateTime? Doj { get; set; }
        [Column("DOL", TypeName = "DATE")]
        public DateTime? Dol { get; set; }
        [Column("DOR", TypeName = "DATE")]
        public DateTime? Dor { get; set; }
        [Column("COSTHEAD")]
        public bool Costhead { get; set; }
        [Column("COSTDY")]
        public bool Costdy { get; set; }
        [Column("PROJMNGR")]
        public bool Projmngr { get; set; }
        [Column("PROJDY")]
        public bool Projdy { get; set; }
        [Column("DBA")]
        public bool Dba { get; set; }
        [Column("DIRECTOR")]
        public bool Director { get; set; }
        [Column("STATUS")]
        public bool Status { get; set; }
        [Column("SUBMIT")]
        public bool Submit { get; set; }
        [Required]
        [Column("OFFICE")]
        [StringLength(2)]
        public string Office { get; set; }
        [Column("PROJNO")]
        [StringLength(7)]
        public string Projno { get; set; }
        [Column("DIROP")]
        public bool Dirop { get; set; }
        [Column("AMFI_USER")]
        public bool AmfiUser { get; set; }
        [Column("AMFI_AUTH")]
        public bool AmfiAuth { get; set; }
        [Column("SECRETARY")]
        public bool Secretary { get; set; }
        [Column("DO")]
        [StringLength(5)]
        public string Do { get; set; }
        [Column("INV_AUTH")]
        public bool? InvAuth { get; set; }
        [Column("JOB_INCHARGE")]
        public bool JobIncharge { get; set; }
        [Column("COSTOPR")]
        public bool Costopr { get; set; }
        [Column("MNGR")]
        [StringLength(5)]
        public string Mngr { get; set; }
        [Column("IPADD")]
        [StringLength(15)]
        public string Ipadd { get; set; }
        [Column("PWD_CHGD")]
        public bool? PwdChgd { get; set; }
        [Column("DOC", TypeName = "DATE")]
        public DateTime? Doc { get; set; }
        [Column("GRADE")]
        [StringLength(2)]
        public string Grade { get; set; }
        [Column("PROC_OPR")]
        public bool ProcOpr { get; set; }
        [Column("REPORTO")]
        [StringLength(5)]
        public string Reporto { get; set; }
        [Column("COMPANY")]
        [StringLength(4)]
        public string Company { get; set; }
        [Column("TRANS_OUT", TypeName = "DATE")]
        public DateTime? TransOut { get; set; }
        [Column("TRANS_IN", TypeName = "DATE")]
        public DateTime? TransIn { get; set; }
        [Column("HR_OPR")]
        public bool HrOpr { get; set; }
        [Column("SEX")]
        [StringLength(1)]
        public string Sex { get; set; }
        [Column("USER_DOMAIN")]
        [StringLength(30)]
        public string UserDomain { get; set; }
        [Column("WEB_ITDECL")]
        public bool? WebItdecl { get; set; }
        [Column("CATEGORY")]
        [StringLength(1)]
        public string Category { get; set; }
        [Column("ESI_COVER")]
        public bool? EsiCover { get; set; }
        [Column("EMP_HOD")]
        [StringLength(5)]
        public string EmpHod { get; set; }
        [Column("SEATREQ")]
        public bool? Seatreq { get; set; }
        [Column("NEWEMP")]
        public bool? Newemp { get; set; }
        [Column("ONDEPUTATION")]
        public bool? Ondeputation { get; set; }
        [Column("OLDCO")]
        [StringLength(4)]
        public string Oldco { get; set; }
        [Column("MARRIED")]
        [StringLength(1)]
        public string Married { get; set; }
        [Column("JOBTITLE")]
        [StringLength(115)]
        public string Jobtitle { get; set; }
        [Column("EOW")]
        [StringLength(1)]
        public string Eow { get; set; }
        [Column("EOW_DATE", TypeName = "DATE")]
        public DateTime? EowDate { get; set; }
        [Column("EOW_WEEK")]
        public bool? EowWeek { get; set; }
        [Column("LASTNAME")]
        [StringLength(50)]
        public string Lastname { get; set; }
        [Column("FIRSTNAME")]
        [StringLength(50)]
        public string Firstname { get; set; }
        [Column("MIDDLENAME")]
        [StringLength(50)]
        public string Middlename { get; set; }
        [Column("PFSLNO")]
        [StringLength(5)]
        public string Pfslno { get; set; }
        [Column("PAYROLL")]
        public bool? Payroll { get; set; }
        [Column("EXPATRIATE")]
        public bool? Expatriate { get; set; }
        [Column("PERSONID")]
        [StringLength(8)]
        public string Personid { get; set; }
    }
}
