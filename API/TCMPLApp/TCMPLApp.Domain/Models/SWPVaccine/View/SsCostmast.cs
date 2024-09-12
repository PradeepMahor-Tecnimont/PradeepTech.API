using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Keyless]
    public partial class SsCostmast
    {
        [Required]
        [Column("COSTCODE")]
        [StringLength(4)]
        public string Costcode { get; set; }
        [Required]
        [Column("NAME")]
        [StringLength(50)]
        public string Name { get; set; }
        [Required]
        [Column("ABBR")]
        [StringLength(11)]
        public string Abbr { get; set; }
        [Required]
        [Column("HOD")]
        [StringLength(5)]
        public string Hod { get; set; }
        [Required]
        [Column("HOD_ABBR")]
        [StringLength(7)]
        public string HodAbbr { get; set; }
        [Column("DY_HOD")]
        [StringLength(5)]
        public string DyHod { get; set; }
        [Column("NOOFEMPS")]
        public short Noofemps { get; set; }
        [Required]
        [Column("COSTGROUP")]
        [StringLength(4)]
        public string Costgroup { get; set; }
        [Required]
        [Column("GROUPS")]
        [StringLength(4)]
        public string Groups { get; set; }
        [Required]
        [Column("TM01_GRP")]
        [StringLength(1)]
        public string Tm01Grp { get; set; }
        [Required]
        [Column("TMA_GRP")]
        [StringLength(1)]
        public string TmaGrp { get; set; }
        [Required]
        [Column("COST_TYPE")]
        [StringLength(1)]
        public string CostType { get; set; }
        [Column("ACTIVITY")]
        public bool Activity { get; set; }
        [Column("GROUP_CHART")]
        public bool GroupChart { get; set; }
        [Column("COSTGRP")]
        [StringLength(1)]
        public string Costgrp { get; set; }
        [Column("ITALIAN_NAME")]
        [StringLength(20)]
        public string ItalianName { get; set; }
        [Column("BU")]
        [StringLength(12)]
        public string Bu { get; set; }
        [Column("CHANGED_NEMPS")]
        public byte? ChangedNemps { get; set; }
        [Column("INOFFICE")]
        public bool? Inoffice { get; set; }
        [Column("SECRETARY")]
        [StringLength(5)]
        public string Secretary { get; set; }
        [Column("COMP")]
        [StringLength(1)]
        public string Comp { get; set; }
        [Column("ACTIVE")]
        public bool? Active { get; set; }
        [Column("SDATE", TypeName = "DATE")]
        public DateTime? Sdate { get; set; }
        [Column("EDATE", TypeName = "DATE")]
        public DateTime? Edate { get; set; }
        [Column("PHASE")]
        [StringLength(2)]
        public string Phase { get; set; }
        [Column("SAPCC")]
        [StringLength(6)]
        public string Sapcc { get; set; }
        [Column("CLOSED")]
        public bool? Closed { get; set; }
        [Column("PARENT_COSTCODE")]
        [StringLength(4)]
        public string ParentCostcode { get; set; }
    }
}
