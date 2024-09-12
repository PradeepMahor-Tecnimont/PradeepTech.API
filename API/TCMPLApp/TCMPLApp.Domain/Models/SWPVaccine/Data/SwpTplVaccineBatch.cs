using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Table("SWP_TPL_VACCINE_BATCH", Schema = "SELFSERVICE")]
    [Index(nameof(VaccineDate), Name = "SWP_TPL_VACINE_BATCH_UK1", IsUnique = true)]
    public partial class SwpTplVaccineBatch
    {
        public SwpTplVaccineBatch()
        {
            SwpTplVaccineBatchEmps = new HashSet<SwpTplVaccineBatchEmp>();
        }

        [Key]
        [Column("BATCH_KEY_ID")]
        [StringLength(8)]
        public string BatchKeyId { get; set; }
        [Column("VACCINE_DATE", TypeName = "DATE")]
        public DateTime? VaccineDate { get; set; }
        [Column("EMP_ASSIGN_END_DATE", TypeName = "DATE")]
        public DateTime? EmpAssignEndDate { get; set; }
        [Column("IS_OPEN")]
        [StringLength(2)]
        public string IsOpen { get; set; }
        [Column("MODIFIED_ON", TypeName = "DATE")]
        public DateTime? ModifiedOn { get; set; }
        [Column("MODIFIED_BY")]
        [StringLength(5)]
        public string ModifiedBy { get; set; }

        [InverseProperty(nameof(SwpTplVaccineBatchEmp.BatchKey))]
        public virtual ICollection<SwpTplVaccineBatchEmp> SwpTplVaccineBatchEmps { get; set; }
    }
}
