using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    [Table("SWP_RELATION_MAST", Schema ="SELFSERVICE")]
    public partial class SwpRelationMast
    {
        [Key]
        [Column("RELATION_CODE")]
        [StringLength(20)]
        public string RelationCode { get; set; }
        [Column("RELATION_DESC")]
        [StringLength(100)]
        public string RelationDesc { get; set; }
        [Column("SORT_ORDER", TypeName = "NUMBER")]
        public decimal? SortOrder { get; set; }
    }
}
