using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Table("SWP_BUS_ROUTES",Schema ="SELFSERVICE")]
    public partial class SwpBusRoute
    {
        [Key]
        [Column("ROUTE_ID")]
        [StringLength(10)]
        public string RouteId { get; set; }
        [Column("PICKUP_POINTS")]
        [StringLength(2000)]
        public string PickupPoints { get; set; }
    }
}
