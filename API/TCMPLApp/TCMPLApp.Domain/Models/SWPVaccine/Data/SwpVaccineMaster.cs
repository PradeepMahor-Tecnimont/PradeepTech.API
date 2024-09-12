using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Table("SWP_VACCINE_MASTER", Schema = "SELFSERVICE")]
    public partial class SwpVaccineMaster
    {
        public SwpVaccineMaster()
        {
            SwpVaccineDates = new HashSet<SwpVaccineDate>();
        }

        [Key]
        [Column("VACCINE_TYPE")]
        [StringLength(20)]
        public string VaccineType{ get; set; }
        [Column("COMPANY_PROVIDING")]
        [StringLength(2)]
        public string CompanyProviding { get; set; }

        [InverseProperty(nameof(SwpVaccineDate.VaccineTypeNavigation))]
        public virtual ICollection<SwpVaccineDate> SwpVaccineDates { get; set; }
    }
}
