
using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskDataTableExcel
    {
        [Display(Name = "Desk Id")]
        public string DeskId { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified on")]
        public DateTime? ModifiedOn { get; set; }
    }
}
