using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Table("SWP_VACCINE_DATES", Schema = "SELFSERVICE")]
    public partial class SwpVaccineDate
    {
        [Key]
        [Column("EMPNO")]
        [StringLength(5)]
        public string Empno { get; set; }

        [Column("JAB1_DATE", TypeName = "DATE")]
        public DateTime Jab1Date { get; set; }
        
        [Column("JAB2_DATE", TypeName = "DATE")]
        public DateTime? Jab2Date { get; set; }
        
        [Column("MODIFIED_ON", TypeName = "DATE")]
        public DateTime? ModifiedOn { get; set; }
        
        [Column("VACCINE_TYPE")]
        [StringLength(20)]
        public string VaccineType { get; set; }

        [Column("IS_JAB1_BY_OFFICE")]
        [StringLength(2)]
        public string IsJab1ByOffice { get; set; }

        [Column("IS_JAB2_BY_OFFICE")]
        [StringLength(2)]
        public string IsJab2ByOffice { get; set; }

        [Column("BOOSTER_JAB_DATE", TypeName ="DATE")]
        public DateTime? BoosterJabDate { get; set; }



        [ForeignKey(nameof(VaccineType))]
        [InverseProperty(nameof(SwpVaccineMaster.SwpVaccineDates))]
        public virtual SwpVaccineMaster VaccineTypeNavigation { get; set; }
    }
}
