using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Keyless]
    public partial class SwpVuEmpVaccineDate
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
        [Column("GRADE")]
        [StringLength(2)]
        public string Grade { get; set; }
        [Column("VACCINE_TYPE")]
        [StringLength(20)]
        public string VaccineType { get; set; }
        [Column("JAB1_DATE", TypeName = "DATE")]
        public DateTime Jab1Date { get; set; }
        [Column("FIRST_JAB_SPONSOR")]
        [StringLength(6)]
        public string FirstJabSponsor { get; set; }
        [Column("JAB2_DATE", TypeName = "DATE")]
        public DateTime? Jab2Date { get; set; }
        [Column("SECOND_JAB_SPONSOR")]
        [StringLength(6)]
        public string SecondJabSponsor { get; set; }

        [Column("BOOSTER_JAB_DATE")]
        public DateTime? BoosterJabDate { get; set; }

        [Column("CAN_EDIT")]
        [StringLength(2)]
        public string CanEdit{ get; set; }
        [Column("MODIFIED_ON", TypeName = "DATE")]
        public DateTime? ModifiedOn { get; set; }
    }
}
