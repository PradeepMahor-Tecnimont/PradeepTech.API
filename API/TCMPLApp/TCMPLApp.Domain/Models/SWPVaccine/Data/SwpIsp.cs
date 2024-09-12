using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Table("SWP_ISP", Schema = "SELFSERVICE")]
    public partial class SwpIsp
    {
        [Key]
        [Column("ISP_NAME")]
        [StringLength(30)]
        public string IspName { get; set; }
        [Column("IS_ELIGIBLE")]
        [StringLength(2)]
        public string IsEligible { get; set; }
    }
}
