using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class ModuleActionsDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Action Id")]
        public string ActionId { get; set; }

        [Display(Name = "Action Name")]
        public string ActionName { get; set; }

        [Display(Name = "Action Description")]
        public string ActionDesc { get; set; }

        [Display(Name = "Module Id")]
        public string ModuleId { get; set; }

        [Display(Name = "Module Name")]
        public string ModuleName { get; set; }

        [Display(Name = "Module Long Description")]
        public string ModuleLongDesc { get; set; }

        [Display(Name = "Action IsActive")]
        public string ActionIsActive { get; set; }

        [Display(Name = "Module Action Key Id")]
        public string ModuleActionKeyId { get; set; }

        public decimal? DeleteAllowed { get; set; }
    }
}