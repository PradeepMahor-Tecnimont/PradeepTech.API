using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Table("SWP_EMP_TRAINING", Schema = "SELFSERVICE")]
    public partial class SwpEmpTraining
    {
        [Key]
        [Column("EMPNO")]
        [StringLength(5)]
        public string Empno { get; set; }
        [Column("SECURITY")]
        public bool? Security { get; set; }
        [Column("SHAREPOINT16")]
        public bool? Sharepoint16 { get; set; }
        [Column("ONEDRIVE365")]
        public bool? Onedrive365 { get; set; }
        [Column("TEAMS")]
        public bool? Teams { get; set; }
        [Column("PLANNER")]
        public bool? Planner { get; set; }
    }
}
