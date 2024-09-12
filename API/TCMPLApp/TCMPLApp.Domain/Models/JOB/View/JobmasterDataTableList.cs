using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobmasterDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Mode / Status")]
        public string FormMode { get; set; }

        [Display(Name = "Job No")]
        public string Projno { get; set; }       

        [Display(Name = "Project description")]
        public string ShortDesc { get; set; }

        [Display(Name = "TCM no")]
        public string Tcmno { get; set; }

        [Display(Name = "Client name")]
        public string Clientname { get; set; }

        [Display(Name = "Location")]
        public string Location { get; set; }

        [Display(Name = "Project manager")]
        public string Pmempno { get; set; }

        [Display(Name = "Revision")]
        public decimal Revision { get; set; }

        [Display(Name = "Revised closing date")]
        public DateTime? Revclosedate { get; set; }

        [Display(Name = "Actual closing date")]
        public DateTime? Actualclosedate { get; set; }

        public decimal? IsActive { get; set; }
    }
}