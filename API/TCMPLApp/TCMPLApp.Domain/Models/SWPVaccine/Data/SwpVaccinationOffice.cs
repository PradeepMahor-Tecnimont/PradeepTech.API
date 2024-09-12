using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Table("SWP_VACCINATION_OFFICE", Schema = "SELFSERVICE")]
    public partial class SwpVaccinationOffice
    {
        [Key]
        [Column("EMPNO")]
        [StringLength(5)]
        public string Empno { get; set; }
        [Required]
        [Column("COWIN_REGTRD")]
        [StringLength(2)]
        public string CowinRegtrd { get; set; }
        [Column("MOBILE")]
        [StringLength(10)]
        public string Mobile { get; set; }
        [Required]
        [Column("OFFICE_BUS")]
        [StringLength(2)]
        public string OfficeBus { get; set; }
        [Column("OFFICE_BUS_ROUTE")]
        [StringLength(10)]
        public string OfficeBusRoute { get; set; }
        [Required]
        [Column("ATTENDING_VACCINATION")]
        [StringLength(2)]
        public string AttendingVaccination { get; set; }
        [Column("NOT_ATTENDING_REASON")]
        [StringLength(200)]
        public string NotAttendingReason { get; set; }

        [Column("JAB_NUMBER")]
        [StringLength(20)]
        public string JabNumber { get; set; }
    }
}
