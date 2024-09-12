using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HSE
{
    public class IncidentDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Id")]
        public string Reportid { get; set; }

        public DateTime? Reportdate { get; set; }

        [Display(Name = "Emp no.")]
        public string Empno { get; set; }

        [Display(Name = "Name of injuried person")]
        public string Name { get; set; }

        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Location")]
        public string Loc { get; set; }

        [Display(Name = "Incident date")]
        public DateTime? Incdate { get; set; }

        [Display(Name = "Incident time")]
        public string Inctime { get; set; }

        [Display(Name = "Reported by")]
        public string Reportedby { get; set; }

        public Int16 Mailsend { get; set; }

        public Int16 Isactive { get; set; }

        [Display(Name = "Status")]
        public string Statusstring { get; set; }
    }
}