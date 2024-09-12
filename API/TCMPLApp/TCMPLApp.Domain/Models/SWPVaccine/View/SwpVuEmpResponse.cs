using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Keyless]
    public partial class SwpVuEmpResponse
    {
        [Required]
        [Column("EMPNO")]
        [StringLength(5)]
        public string Empno { get; set; }
        [Required]
        [Column("NAME")]
        [StringLength(35)]
        public string Name { get; set; }
        [Required]
        [Column("PARENT")]
        [StringLength(4)]
        public string Parent { get; set; }
        [Required]
        [Column("ABBR")]
        [StringLength(11)]
        public string Abbr { get; set; }
        [Required]
        [Column("PARENT_NAME")]
        [StringLength(50)]
        public string ParentName { get; set; }
        [Column("GRADE")]
        [StringLength(2)]
        public string Grade { get; set; }
        [Required]
        [Column("EMPTYPE")]
        [StringLength(1)]
        public string Emptype { get; set; }
        [Column("IS_POLICY_ACCEPTED")]
        [StringLength(3)]
        public string IsPolicyAccepted { get; set; }
        [Column("IS_HOD_APPROVED")]
        [StringLength(8)]
        public string IsHodApproved { get; set; }
        [Column("IS_HR_APPROVED")]
        [StringLength(8)]
        public string IsHrApproved { get; set; }
        [Column("HOD_APPROVE_VISIBLE")]
        [StringLength(3)]
        public string HodApproveVisible { get; set; }
        [Column("HR_APPROVE_VISIBLE")]
        [StringLength(3)]
        public string HrApproveVisible { get; set; }
        [Column("HOD_REJECT_VISIBLE")]
        [StringLength(3)]
        public string HodRejectVisible { get; set; }
        [Column("HR_REJECT_VISIBLE")]
        [StringLength(3)]
        public string HrRejectVisible { get; set; }
        [Required]
        [Column("IS_ACCEPTED")]
        [StringLength(2)]
        public string IsAccepted { get; set; }
        [Column("HOD_APPRL")]
        [StringLength(2)]
        public string HodApprl { get; set; }
        [Column("HR_APPRL")]
        [StringLength(2)]
        public string HrApprl { get; set; }
    }
}
