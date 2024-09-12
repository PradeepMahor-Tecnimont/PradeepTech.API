using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Table("SWP_TPL_VACCINE_BATCH_EMP", Schema ="SELFSERVICE")]
    public partial class SwpTplVaccineBatchEmp
    {
        [Key]
        [Column("EMPNO")]
        [StringLength(5)]
        public string Empno { get; set; }
        [Column("BATCH_KEY_ID")]
        [StringLength(8)]
        public string BatchKeyId { get; set; }
        [Column("TIME_SLOT")]
        [StringLength(20)]
        public string TimeSlot { get; set; }
        [Column("TRANSPORT")]
        [StringLength(50)]
        public string Transport { get; set; }
        [Column("JAB_FOR_THIS_SLOT")]
        [StringLength(20)]
        public string JabForThisSlot { get; set; }

        [Column("INOCULATED")]
        [StringLength(2)]
        public string Inoculated { get; set; }

        [ForeignKey(nameof(BatchKeyId))]
        [InverseProperty(nameof(SwpTplVaccineBatch.SwpTplVaccineBatchEmps))]
        public virtual SwpTplVaccineBatch BatchKey { get; set; }
    }
}
