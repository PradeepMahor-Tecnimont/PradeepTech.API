using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Keyless]
    public partial class SwpVuVaccineOffBatch2Regn
    {
        [Required]
        [Column("EMPNO")]
        [StringLength(5)]
        public string Empno { get; set; }
        [Required]
        [Column("EMPLOYEE_NAME")]
        [StringLength(35)]
        public string EmployeeName { get; set; }
        [Required]
        [Column("FAMILY_MEMBER_NAME")]
        [StringLength(100)]
        public string FamilyMemberName { get; set; }
        [Column("RELATION")]
        [StringLength(20)]
        public string Relation { get; set; }
        [Column("YEAR_OF_BIRTH", TypeName = "NUMBER")]
        public decimal? YearOfBirth { get; set; }
        [Column("PREFERRED_DATE", TypeName = "DATE")]
        public DateTime PreferredDate { get; set; }
        [Column("JAB_NUM")]
        [StringLength(20)]
        public string JabNum { get; set; }
    }
}
