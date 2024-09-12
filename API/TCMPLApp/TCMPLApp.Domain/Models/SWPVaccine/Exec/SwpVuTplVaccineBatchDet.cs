using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Keyless]
    public partial class SwpVuTplVaccineBatchDet
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
        [Column("PARENT")]
        [StringLength(4)]
        public string Parent { get; set; }
        [Required]
        [Column("DEPARTMENT_NAME")]
        [StringLength(50)]
        public string DepartmentName { get; set; }
        [Column("GRADE")]
        [StringLength(2)]
        public string Grade { get; set; }
        [Required]
        [Column("EMPTYPE")]
        [StringLength(1)]
        public string Emptype { get; set; }
        [Column("EMAIL")]
        [StringLength(100)]
        public string Email { get; set; }
        [Column("JAB_FOR_THIS_SLOT")]
        [StringLength(20)]
        public string JabForThisSlot { get; set; }
        [Column("TIME_SLOT")]
        [StringLength(20)]
        public string TimeSlot { get; set; }

        [Column("TRANSPORT")]
        [StringLength(50)]
        public string Transport { get; set; }

        [Column("INOCULATED")]
        [StringLength(50)]
        public string Inoculated { get; set; }


        [Column("BATCH_KEY_ID")]
        [StringLength(8)]
        public string BatchKeyId { get; set; }
    }
}
