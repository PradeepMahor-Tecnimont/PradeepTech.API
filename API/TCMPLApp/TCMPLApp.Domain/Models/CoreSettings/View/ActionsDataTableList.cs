using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class ActionsDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Action Id")]
        public string ActionId { get; set; }

        [Display(Name = "Action Name")]
        public string ActionName { get; set; }

        [Display(Name = "Action Description")]
        public string ActionDesc { get; set; }

        public decimal? DeleteAllowed { get; set; }
    }
}