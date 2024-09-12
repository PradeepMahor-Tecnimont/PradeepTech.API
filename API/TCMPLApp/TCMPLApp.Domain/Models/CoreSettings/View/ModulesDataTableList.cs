using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class ModulesDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Module Id")]
        public string ModuleId { get; set; }

        [Display(Name = "Module Name")]
        public string ModuleName { get; set; }

        [Display(Name = "Module Long Description")]
        public string ModuleLongDesc { get; set; }

        [Display(Name = "Module IsActive")]
        public string ModuleIsActive { get; set; }

        [Display(Name = "Module Schema Name")]
        public string ModuleSchemaName { get; set; }
        
        [Display(Name = "Function To Check User Access")]
        public string FuncToCheckUserAccess { get; set; }
        
        [Display(Name = "Module Short Description")]
        public string ModuleShortDesc { get; set; }
        public decimal? DeleteAllowed { get; set; }


    }
}
